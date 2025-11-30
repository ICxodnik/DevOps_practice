from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.db.models import Count
import json

from .models import Country, UserVisit
from .forms import EmailUserCreationForm


def register_view(request):
    """Реєстрація нового користувача"""
    if request.user.is_authenticated:
        return redirect('home')
    
    if request.method == 'POST':
        form = EmailUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            email = form.cleaned_data.get('email')
            password = form.cleaned_data.get('password1')
            user = authenticate(username=email, password=password)
            if user:
                # Переносимо відвідані країни з сесії в базу даних
                visited_countries = request.session.get('visited_countries', [])
                if visited_countries:
                    for country_id in visited_countries:
                        try:
                            country = Country.objects.get(id=country_id)
                            UserVisit.objects.get_or_create(user=user, country=country)
                        except Country.DoesNotExist:
                            pass
                    # Очищаємо сесію
                    del request.session['visited_countries']
                
                login(request, user)
                messages.success(request, f'Вітаємо! Ваш акаунт успішно створено.')
                return redirect('home')
    else:
        form = EmailUserCreationForm()
    return render(request, 'travel_tracker/register.html', {'form': form})


def login_view(request):
    """Вхід користувача"""
    if request.user.is_authenticated:
        return redirect('home')
    
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')
        user = authenticate(request, username=email, password=password)
        if user is not None:
            # Переносимо відвідані країни з сесії в базу даних
            visited_countries = request.session.get('visited_countries', [])
            if visited_countries:
                for country_id in visited_countries:
                    try:
                        country = Country.objects.get(id=country_id)
                        UserVisit.objects.get_or_create(user=user, country=country)
                    except Country.DoesNotExist:
                        pass
                # Очищаємо сесію
                del request.session['visited_countries']
            
            login(request, user)
            messages.success(request, f'Вітаємо!')
            return redirect('home')
        else:
            messages.error(request, 'Невірний email або пароль.')
    return render(request, 'travel_tracker/login.html')


def home_view(request):
    """Головна сторінка з картою (доступна без авторизації)"""
    # Отримуємо всі країни
    countries = Country.objects.all()
    
    # Отримуємо відвідані країни
    if request.user.is_authenticated:
        # Для авторизованих користувачів - з бази даних
        visited_countries = UserVisit.objects.filter(user=request.user).values_list('country_id', flat=True)
        visited_countries_set = set(visited_countries)
    else:
        # Для неавторизованих - з сесії
        visited_countries_set = set(request.session.get('visited_countries', []))
    
    # Підраховуємо відсоток відвіданих країн
    total_countries = countries.count()
    visited_count = len(visited_countries_set)
    percentage = (visited_count / total_countries * 100) if total_countries > 0 else 0
    
    # Формуємо дані для карти
    countries_data = []
    for country in countries:
        countries_data.append({
            'id': country.id,
            'name': country.name,
            'code': country.code,
            'lat': country.latitude,
            'lng': country.longitude,
            'visited': country.id in visited_countries_set
        })
    
    context = {
        'countries_data': json.dumps(countries_data),
        'visited_count': visited_count,
        'total_countries': total_countries,
        'percentage': round(percentage, 2),
        'visited_countries': visited_countries_set,
        'is_authenticated': request.user.is_authenticated,
    }
    
    return render(request, 'travel_tracker/home.html', context)


def countries_list_view(request):
    """Сторінка зі списком всіх країн з пошуком та чекбоксами"""
    # Отримуємо відвідані країни
    if request.user.is_authenticated:
        visited_countries = set(UserVisit.objects.filter(user=request.user).values_list('country_id', flat=True))
    else:
        visited_countries = set(request.session.get('visited_countries', []))
    
    # Отримуємо параметр пошуку
    search_query = request.GET.get('search', '').strip()
    
    # Фільтруємо країни за пошуковим запитом
    countries = Country.objects.all().order_by('name')
    if search_query:
        countries = countries.filter(name__icontains=search_query)
    
    # Додаємо інформацію про відвідування до кожної країни
    countries_list = []
    for country in countries:
        countries_list.append({
            'id': country.id,
            'name': country.name,
            'code': country.code,
            'visited': country.id in visited_countries
        })
    
    # Підраховуємо статистику
    total_visited = len(visited_countries)
    total_countries = Country.objects.count()
    
    context = {
        'countries': countries_list,
        'search_query': search_query,
        'is_authenticated': request.user.is_authenticated,
        'total_visited': total_visited,
        'total_countries': total_countries,
    }
    
    return render(request, 'travel_tracker/countries_list.html', context)


@require_POST
def toggle_country_view(request, country_id):
    """Додати/видалити країну зі списку відвіданих"""
    try:
        country = get_object_or_404(Country, id=country_id)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=400)
    
    if request.user.is_authenticated:
        # Для авторизованих користувачів - зберігаємо в базу даних
        visit, created = UserVisit.objects.get_or_create(
            user=request.user,
            country=country
        )
        
        if not created:
            visit.delete()
            visited = False
        else:
            visited = True
        
        visited_count = UserVisit.objects.filter(user=request.user).count()
    else:
        # Для неавторизованих - зберігаємо в сесію
        if 'visited_countries' not in request.session:
            request.session['visited_countries'] = []
        
        visited_countries = request.session['visited_countries']
        
        if country_id in visited_countries:
            visited_countries.remove(country_id)
            visited = False
        else:
            visited_countries.append(country_id)
            visited = True
        
        request.session['visited_countries'] = visited_countries
        request.session.modified = True
        visited_count = len(visited_countries)
    
    # Підраховуємо новий відсоток
    total_countries = Country.objects.count()
    percentage = (visited_count / total_countries * 100) if total_countries > 0 else 0
    
    return JsonResponse({
        'visited': visited,
        'visited_count': visited_count,
        'total_countries': total_countries,
        'percentage': round(percentage, 2),
        'is_authenticated': request.user.is_authenticated
    })



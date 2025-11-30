from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    path('', views.home_view, name='home'),
    path('health/', views.health_check_view, name='health'),
    path('countries/', views.countries_list_view, name='countries_list'),
    path('register/', views.register_view, name='register'),
    path('login/', views.login_view, name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('toggle-country/<int:country_id>/', views.toggle_country_view, name='toggle_country'),
]



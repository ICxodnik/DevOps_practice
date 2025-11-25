from django.contrib import admin
from .models import Country, UserVisit


@admin.register(Country)
class CountryAdmin(admin.ModelAdmin):
    list_display = ('name', 'code', 'latitude', 'longitude')
    search_fields = ('name', 'code')


@admin.register(UserVisit)
class UserVisitAdmin(admin.ModelAdmin):
    list_display = ('user', 'country', 'visited_at')
    list_filter = ('country', 'visited_at')
    search_fields = ('user__username', 'country__name')



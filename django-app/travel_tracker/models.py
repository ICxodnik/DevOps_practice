from django.db import models
from django.contrib.auth.models import User


class Country(models.Model):
    """Модель країни"""
    name = models.CharField(max_length=100, unique=True, verbose_name="Назва країни")
    code = models.CharField(max_length=3, unique=True, verbose_name="Код країни")
    latitude = models.FloatField(verbose_name="Широта")
    longitude = models.FloatField(verbose_name="Довгота")
    
    class Meta:
        verbose_name = "Країна"
        verbose_name_plural = "Країни"
        ordering = ['name']
    
    def __str__(self):
        return self.name


class UserVisit(models.Model):
    """Модель відвідування країни користувачем"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='visits', verbose_name="Користувач")
    country = models.ForeignKey(Country, on_delete=models.CASCADE, related_name='visits', verbose_name="Країна")
    visited_at = models.DateTimeField(auto_now_add=True, verbose_name="Дата відвідування")
    
    class Meta:
        verbose_name = "Відвідування"
        verbose_name_plural = "Відвідування"
        unique_together = ['user', 'country']
        ordering = ['-visited_at']
    
    def __str__(self):
        return f"{self.user.username} - {self.country.name}"



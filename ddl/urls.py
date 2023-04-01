from django.urls import path
from . import views

urlpatterns = [
    path('ddl/', views.ddl_funct)
]
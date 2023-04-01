from django.urls import path
from . import views

urlpatterns = [
    path('dml/', views.dml_funct),
]
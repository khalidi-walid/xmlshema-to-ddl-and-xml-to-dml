from django.shortcuts import render
from lxml import etree

# Create your views here.
def index(request):
    return render(request, 'home.html')
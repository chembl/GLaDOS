from django.core import serializers
from django.http import HttpResponse
import cx_Oracle
import time
from glados.models import Country
import json

def test(request):
    
    countries = Country.objects.all()
    response = serializers.serialize("json", countries)
    
    return HttpResponse(response, content_type="application/json")
from django.contrib import admin

from .models import Faq
from .models import Acknowledgement

admin.site.register(Faq)
admin.site.register(Acknowledgement)
from django.contrib import admin

from .models import Faq
from .models import Acknowledgement
from .models import FaqCategory
from .models import FaqSubcategory

class FaqAdmin(admin.ModelAdmin):

    list_display = ('question', 'category', 'subcategory', 'deleted')


admin.site.register(Faq, FaqAdmin)
admin.site.register(FaqCategory)
admin.site.register(FaqSubcategory)
admin.site.register(Acknowledgement)


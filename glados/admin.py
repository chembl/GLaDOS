from django.contrib import admin

from .models import Faq
from .models import Acknowledgement
from .models import FaqCategory
from .models import FaqSubcategory
from .models import WizardStep
from .models import WizardOptionType
from .models import WizardOption

class FaqAdmin(admin.ModelAdmin):

    list_display = ('question', 'category', 'subcategory', 'deleted')

class FaqCategoryAdmin(admin.ModelAdmin):

    list_display = ('category_name', 'position')

admin.site.register(Faq, FaqAdmin)
admin.site.register(FaqCategory, FaqCategoryAdmin)
admin.site.register(FaqSubcategory)
admin.site.register(Acknowledgement)

admin.site.register(WizardStep)
admin.site.register(WizardOptionType)
admin.site.register(WizardOption)


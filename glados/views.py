from .models import Acknowledgement
from .models import Faq
from .models import FaqCategory
from .models import FaqSubcategory
from django.shortcuts import render

# Returns all acknowledgements grouped by current and old
def acks(request):

  ack_list = Acknowledgement.objects.order_by('id')
  context = {
    'current_acks': [ack for ack in ack_list if ack.is_current == 1],
    'old_acks' : [ack for ack in ack_list if ack.is_current != 1]
  }
  return render(request, 'glados/acknowledgements.html', context)

# returns all Faqs grouped by category and subcategory
def faqs(request):

  print('------------------')
  #faqs_list = Faq.objects.all();
  # the categories are ordered by the position theu should have in the page
  categories = FaqCategory.objects.all();
  subcategories = FaqSubcategory.objects.all();

  faqs_structure = []

  for cat in categories:

    faqs_in_this_category = {}
    faqs_in_this_category['category'] = cat
    faqs_in_this_category['items'] = []
    faqs_structure.append(faqs_in_this_category)

    for subcat in subcategories:

      faqs_in_this_subcategory = {}
      faqs_in_this_subcategory ['subcategory'] = subcat
      faqs_in_this_subcategory ['items'] = []
      faqs_in_this_category['items'].append(faqs_in_this_subcategory)

      questions_by_subcategory = Faq.objects.filter(category=cat, subcategory=subcat)

      for q in questions_by_subcategory:
        faqs_in_this_subcategory ['items'].append(q)



  print(faqs_structure)
  print('^^^^')


  context = {'faqs_structure': faqs_structure}


  return render(request, 'glados/faqs.html', context)
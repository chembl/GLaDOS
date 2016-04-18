from .models import Acknowledgement
from django.template import loader
from django.shortcuts import render

def acks(request):

  ack_list = Acknowledgement.objects.order_by('id')
  context = {
    'current_acks': [ack for ack in ack_list if ack.is_current == 1],
    'old_acks' : [ack for ack in ack_list if ack.is_current != 1]
  }
  return render(request, 'glados/acknowledgements.html', context)



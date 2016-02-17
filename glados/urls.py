from django.conf.urls import url

from glados.utils import DirectTemplateView

urlpatterns = [
  url(r'^compound_report_card/$', DirectTemplateView.as_view(template_name="glados/compoundReportCard.html"),),
]

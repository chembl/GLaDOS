from django.conf.urls import url

from glados.utils import DirectTemplateView

urlpatterns = [
  url(r'^compound_report_card/$', DirectTemplateView.as_view(template_name="glados/compoundReportCard.html"),),
  url(r'^layout_test/$', DirectTemplateView.as_view(template_name="glados/layoutTest.html"),),
]

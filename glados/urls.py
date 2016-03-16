from django.conf.urls import url

from glados.utils import DirectTemplateView

urlpatterns = [
  url(r'^compound_report_card/(?P<chembl_id>\w+)/$', DirectTemplateView.as_view(template_name="glados/compoundReportCard.html"),),
  url(r'^compound_report_card/(?P<chembl_id>\w+)/embed/name_and_classification/$', DirectTemplateView.as_view(template_name="glados/CompoundReportCardParts/NameAndClassificationToEmbed.html"),),
  url(r'^layout_test/$', DirectTemplateView.as_view(template_name="glados/layoutTest.html"),),
]

from django.conf.urls import url
from glados.utils import DirectTemplateView
from django.views.decorators.clickjacking import xframe_options_exempt
from . import views

urlpatterns = [

  url(r'^compound_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/compoundReportCard.html"), ),

  url(r'^compound_report_card/(?P<chembl_id>\w+)/embed/representations/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/CompoundReportCardParts/RepresentationsToEmbed.html")), ),

  url(r'^compound_report_card/(?P<chembl_id>\w+)/embed/name_and_classification/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/CompoundReportCardParts/NameAndClassificationToEmbed.html")), ),

  url(r'^compound_report_card/(?P<chembl_id>\w+)/embed/mechanism_of_action/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/CompoundReportCardParts/MechanismOfActionToEmbed.html")), ),

   url(r'^compound_report_card/(?P<chembl_id>\w+)/embed/molecule_features/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/CompoundReportCardParts/MoleculeFeaturesToEmbed.html")), ),

  url(r'^compound_report_card/(?P<chembl_id>\w+)/embed/alternate_forms/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/CompoundReportCardParts/AlternateFormsToEmbed.html")), ),

  url(r'^compound_report_card/(?P<chembl_id>\w+)/embed/calculated_properties/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/CompoundReportCardParts/CalculatedCompoundParentPropertiesToEmbed.html")), ),

  url(r'^target_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/targetReportCard.html"), ),

  url(r'^target_report_card/(?P<chembl_id>\w+)/embed/name_and_classification/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/TargetReportCardParts/NameAndClassificationToEmbed.html")), ),

  url(r'^target_report_card/(?P<chembl_id>\w+)/embed/components/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/TargetReportCardParts/ComponentsToEmbed.html")), ),

  url(r'^assay_report_card/$',
      DirectTemplateView.as_view(template_name="glados/assayReportCard.html"), ),

  url(r'^document_report_card/$',
      DirectTemplateView.as_view(template_name="glados/documentReportCard.html"), ),

  url(r'^cell_line_report_card/$',
      DirectTemplateView.as_view(template_name="glados/cellLineReportCard.html"), ),

  url(r'^tissue_report_card/$',
      DirectTemplateView.as_view(template_name="glados/tissueReportCard.html"), ),

  url(r'^$', views.main_page, name='main' ),

  url(r'^marvin_search_fullscreen/$',
      DirectTemplateView.as_view(template_name="glados/marvin_search_fullscreen.html"), ),

  url(r'^compound_3D_speck/$',
      DirectTemplateView.as_view(template_name="glados/comp_3D_view_speck_fullscreen.html"), ),

  url(r'^layout_test/$', DirectTemplateView.as_view(template_name="glados/layoutTest.html"), ),

  url(r'^acknowledgements/$', views.acks, name='acks'),
  url(r'^faqs/$', views.faqs, name='faqs'),

  url(r'^download_wizard/(?P<step_id>\w+)$', views.wizard_step_json, name='wizard_step_json')
]

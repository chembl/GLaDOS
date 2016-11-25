from django.conf.urls import url
from django.conf.urls.static import static
from glados.utils import DirectTemplateView
from django.views.decorators.clickjacking import xframe_options_exempt
from django.conf import settings
from . import views

urlpatterns = [

  # --------------------------------------------------------------------------------------------------------------------
  # Compounds
  # --------------------------------------------------------------------------------------------------------------------

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
    DirectTemplateView.as_view(
      template_name="glados/CompoundReportCardParts/CalculatedCompoundParentPropertiesToEmbed.html")), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Targets
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^target_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/targetReportCard.html"), ),

  url(r'^target_report_card/(?P<chembl_id>\w+)/embed/name_and_classification/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/TargetReportCardParts/NameAndClassificationToEmbed.html")), ),

  url(r'^target_report_card/(?P<chembl_id>\w+)/embed/components/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/TargetReportCardParts/ComponentsToEmbed.html")), ),

  url(r'^target_report_card/(?P<chembl_id>\w+)/embed/relations/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/TargetReportCardParts/RelationsToEmbed.html")), ),

  url(r'^target_report_card/(?P<chembl_id>\w+)/embed/approved_drugs_clinical_candidates/$', xframe_options_exempt(
    DirectTemplateView.as_view(
      template_name="glados/TargetReportCardParts/ApprovedDrugsAndClinicalCandidatesToEmbed.html")), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Assays
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^assay_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/assayReportCard.html"), ),

  url(r'^assay_report_card/(?P<chembl_id>\w+)/embed/basic_information/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/AssayReportCardParts/BasicInformationToEmbed.html")), ),

  url(r'^assay_report_card/(?P<chembl_id>\w+)/embed/curation_summary/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/AssayReportCardParts/CurationSummaryToEmbed.html")), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Documents
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^document_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/documentReportCard.html"), ),

  url(r'^document_report_card/(?P<chembl_id>\w+)/embed/basic_information/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/DocumentReportCardParts/BasicInformationToEmbed.html")), ),

  url(r'^document_report_card/(?P<chembl_id>\w+)/embed/word_cloud/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/DocumentReportCardParts/WordCloudToEmbed.html")), ),

  url(r'^document_report_card/(?P<chembl_id>\w+)/embed/assay_network/$', xframe_options_exempt(
      DirectTemplateView.as_view(template_name="glados/DocumentReportCardParts/AssayNetworkToEmbed.html")), ),

  url(r'^document_assay_network/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/DocumentAssayNetwork/DocumentAssayNetwork.html"), ),

  url(r'^documents_with_same_terms/(?P<doc_terms>.+)/$',
    DirectTemplateView.as_view(template_name="glados/DocumentTerms/DocumentTermsSearch.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Cells
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^cell_line_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/cellLineReportCard.html"), ),

  url(r'^cell_line_report_card/(?P<chembl_id>\w+)/embed/basic_information/$', xframe_options_exempt(
    DirectTemplateView.as_view(template_name="glados/CellReportCardParts/BasicInformationToEmbed.html")), ),

  url(r'^tissue_report_card/$',
      DirectTemplateView.as_view(template_name="glados/tissueReportCard.html"), ),

  url(r'^$', views.main_page, name='main' ),

  url(r'^marvin_search_fullscreen/$',
      DirectTemplateView.as_view(template_name="glados/marvin_search_fullscreen.html"), ),

  url(r'^compound_3D_speck/$',
      DirectTemplateView.as_view(template_name="glados/comp_3D_view_speck_fullscreen.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Tests
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^layout_test/$', DirectTemplateView.as_view(template_name="glados/layoutTest.html"), ),
  url(r'^js_tests/$', DirectTemplateView.as_view(template_name="glados/jsTests.html"), ),
  url(r'^components_summary/$', DirectTemplateView.as_view(template_name="glados/componentSummary.html"), ),

  url(r'^acknowledgements/$', views.acks, name='acks'),
  url(r'^faqs/$', views.faqs, name='faqs'),

  url(r'^download_wizard/(?P<step_id>\w+)$', views.wizard_step_json, name='wizard_step_json'),

  # --------------------------------------------------------------------------------------------------------------------
  # Drug Browser
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^drug_browser_infinity/$',
      DirectTemplateView.as_view(template_name="glados/MainPageParts/DrugBrowserParts/browse_drugs_infinity.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Search Results
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^search_results/.*?$',
      DirectTemplateView.as_view(template_name="glados/SearchResultsParts/SearchResultsMain.html"), ),

  # Compound results graph
  url(r'^compound_results_graph/$',
      DirectTemplateView.as_view(template_name="glados/SearchResultsParts/CompoundResultsGraph.html"), ),

  # Compound vs Target Matrix
  url(r'^compound_target_matrix/$',
      DirectTemplateView.as_view(template_name="glados/SearchResultsParts/CompoundTargetMatrix.html"), ),

]

# ----------------------------------------------------------------------------------------------------------------------
# Static Files
# ----------------------------------------------------------------------------------------------------------------------

urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

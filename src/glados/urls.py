from django.conf.urls import include, url
from django.conf.urls.i18n import i18n_patterns
from django.conf.urls.static import static
from glados.utils import DirectTemplateView
from django.views.decorators.clickjacking import xframe_options_exempt
from django.conf import settings
from . import views
from django.contrib import admin
import glados.grammar.search_parser
from django.views.i18n import JavaScriptCatalog

common_urls = [

  # --------------------------------------------------------------------------------------------------------------------
  # Main Pages
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^g/$', views.main_html_base_no_bar, name='no_bar'),

  url(r'^$',
      views.main_page, name='main'),

  url(r'^tweets/$', views.get_latest_tweets_json, name='tweets'),

  url(r'^database_summary/$', views.get_database_summary, name='database_summary'),

  url(r'^entities_records/$', views.get_entities_records, name='entities_records'),

  url(r'^blog_entries/(?P<pageToken>.+)?$', views.get_latest_blog_entries, name='blog_entries'),

  url(r'^marvin_search_fullscreen/$',
      DirectTemplateView.as_view(template_name="glados/marvin_search_fullscreen.html"), ),

  url(r'^compound_3D_speck/$',
      DirectTemplateView.as_view(template_name="glados/comp_3D_view_speck_fullscreen.html"), ),

  url(r'^acknowledgements/$', views.acks, name='acks'),

  url(r'^faqs/$', views.faqs, name='faqs'),

  url(r'^db_schema',
    DirectTemplateView.as_view(template_name="glados/database_schema.html"), name='db_schema'),

  url(r'^ws_schema',
    DirectTemplateView.as_view(template_name="glados/web_services_schema.html"), name='ws_schema'),

  url(r'^download_wizard/(?P<step_id>\w+)$', views.wizard_step_json, name='wizard_step_json'),

  # --------------------------------------------------------------------------------------------------------------------
  # Tests
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^layout_test/$', DirectTemplateView.as_view(template_name="glados/layoutTest.html"), ),
  url(r'^string_standardisation_test/$',
      DirectTemplateView.as_view(template_name="glados/stringStandardisationTest.html"), ),
  url(r'^js_tests/$', DirectTemplateView.as_view(template_name="glados/jsTests.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Django Admin
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^admin/', include(admin.site.urls)),

  # --------------------------------------------------------------------------------------------------------------------
  # Embedding
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^embed/$',
      xframe_options_exempt(DirectTemplateView.as_view(template_name="glados/Embedding/embed_base.html")), ),

  url(r'^embed/tiny/(?P<hash>.*?)$', views.render_params_from_hash_when_embedded, name='embed-tiny'),
  # --------------------------------------------------------------------------------------------------------------------
  # Compounds
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^compound_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/compoundReportCard.html"), ),

  url(r'^compound_metabolism/(?P<chembl_id>\w+)$', xframe_options_exempt(
    DirectTemplateView.as_view(
      template_name="glados/MoleculeMetabolismGraphFS.html")), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Targets
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^target_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/targetReportCard.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Assays
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^assay_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/assayReportCard.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Documents
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^document_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/documentReportCard.html"), ),

  url(r'^document_assay_network/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/DocumentAssayNetwork/DocumentAssayNetwork.html"), ),

  url(r'^documents_with_same_terms/(?P<doc_terms>.+)/$',
    DirectTemplateView.as_view(template_name="glados/DocumentTerms/DocumentTermsSearch.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Cells
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^cell_line_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/cellLineReportCard.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Tissues
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^tissue_report_card/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/tissueReportCard.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Search Results
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^search_results_parser.*$',
      glados.grammar.search_parser.parse_url_search, ),

  # --------------------------------------------------------------------------------------------------------------------
  # Tiny urls
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^g/tiny/(?P<hash>.*?)$', views.render_params_from_hash, name='tiny'),
  url(r'^shorten_url', views.shorten_url, name='shorten'),
  url(r'^extend_url/(?P<hash>.*?)$', views.extend_url, name='extend')

]

# ----------------------------------------------------------------------------------------------------------------------
# Static Files
# ----------------------------------------------------------------------------------------------------------------------

common_urls += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

# ----------------------------------------------------------------------------------------------------------------------
# SERVER BASE PATH DEFINITION
# ----------------------------------------------------------------------------------------------------------------------

urlpatterns = [url(r'^'+settings.SERVER_BASE_PATH, include(common_urls))]

# ----------------------------------------------------------------------------------------------------------------------
# Translation for Javascript
# ----------------------------------------------------------------------------------------------------------------------

urlpatterns += \
  i18n_patterns(
    url(r'^{0}glados_jsi18n/glados$'.format(settings.SERVER_BASE_PATH),
        JavaScriptCatalog.as_view(packages=['glados'], domain='glados'),
        name='js-glados-catalog'),
    url(r'^{0}glados_jsi18n/glados_es_generated$'.format(settings.SERVER_BASE_PATH),
        JavaScriptCatalog.as_view(packages=['glados'], domain='glados_es_generated'),
        name='js-glados_es_generated-catalog'),
    url(r'^{0}glados_jsi18n/glados_es_override$'.format(settings.SERVER_BASE_PATH),
        JavaScriptCatalog.as_view(packages=['glados'], domain='glados_es_override'),
        name='js-glados_es_override-catalog'),
  )


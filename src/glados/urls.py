from django.conf.urls import include, url
from django.conf.urls.i18n import i18n_patterns
from django.conf.urls.static import static
from glados.utils import DirectTemplateView
from django.views.decorators.clickjacking import xframe_options_exempt
from django.conf import settings
from . import views
from django.contrib import admin
import glados.grammar.search_parser
from django.views.i18n import javascript_catalog

from django.conf.urls import url
from django.http import HttpResponse



common_urls = [
  # --------------------------------------------------------------------------------------------------------------------
  # Translation for Javascript
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^glados_jsi18n/glados$', javascript_catalog, {
      'packages': ('glados',),
      'domain': 'glados',

    }, name='js-glados-catalog'),
  url(r'^glados_jsi18n/glados_es_generated$', javascript_catalog, {
      'packages': ('glados',),
      'domain': 'glados_es_generated',

    }, name='js-glados_es_generated-catalog'),
  url(r'^glados_jsi18n/glados_es_override$', javascript_catalog, {
      'packages': ('glados',),
      'domain': 'glados_es_override',

    }, name='js-glados_es_override-catalog'),
  # --------------------------------------------------------------------------------------------------------------------
  # Main Pages
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^g/$', views.main_html_base_no_bar, name='javascript_routing'),

  url(r'^$',
      views.main_page, name='main'),

  url(r'^tweets/$', views.get_latest_tweets_json, name='tweets'),

  url(r'^database_summary/$', views.get_database_summary, name='database_summary'),

  url(r'^entities_records/$', views.get_entities_records, name='entities_records'),

  url(r'^github_details/$', views.get_github_details, name='github_details'),

  url(r'^blog_entries/(?P<pageToken>.+)?$', views.get_latest_blog_entries, name='blog_entries'),

  url(r'^visualise/$', views.visualise, name='visualise'),

  url(r'^design_components/$', views.design_components , name='design_components'),

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

  url(r'^compound_report_card/(?P<chembl_id>\w+)/$', views.compound_report_card,
      name='compound_report_card'),

  url(r'^compound_metabolism/(?P<chembl_id>\w+)$', xframe_options_exempt(
    DirectTemplateView.as_view(
      template_name="glados/MoleculeMetabolismGraphFS.html")), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Targets
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^target_report_card/(?P<chembl_id>\w+)/$',
      views.target_report_card, name='target_report_card'),

  # --------------------------------------------------------------------------------------------------------------------
  # Assays
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^assay_report_card/(?P<chembl_id>\w+)/$',
      views.assay_report_card, name='assay_report_card'),

  # --------------------------------------------------------------------------------------------------------------------
  # Documents
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^document_report_card/(?P<chembl_id>\w+)/$',
      views.document_report_card, name='document_report_card'),

  url(r'^document_assay_network/(?P<chembl_id>\w+)/$',
      DirectTemplateView.as_view(template_name="glados/DocumentAssayNetwork/DocumentAssayNetwork.html"), ),

  url(r'^documents_with_same_terms/(?P<doc_terms>.+)/$',
    DirectTemplateView.as_view(template_name="glados/DocumentTerms/DocumentTermsSearch.html"), ),

  # --------------------------------------------------------------------------------------------------------------------
  # Cells
  # --------------------------------------------------------------------------------------------------------------------

  url(r'^cell_line_report_card/(?P<chembl_id>\w+)/$',
      views.cell_line_report_card, name='cell_line_report_card'),

  # --------------------------------------------------------------------------------------------------------------------
  # Tissues
  # --------------------------------------------------------------------------------------------------------------------
  url(r'^tissue_report_card/(?P<chembl_id>\w+)/$',
      views.tissue_report_card, name='tissue_report_card'),

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
  url(r'^extend_url/(?P<hash>.*?)$', views.extend_url, name='extend'),

  url(r'^robots.txt', lambda x: HttpResponse(
        "User-Agent: *\nDisallow: / \nUser-Agent: Twitterbot\nAllow: {0}img".format(settings.STATIC_URL),
        content_type="text/plain"),
        name="robots_file")

]

# ----------------------------------------------------------------------------------------------------------------------
# SERVER BASE PATH DEFINITION
# ----------------------------------------------------------------------------------------------------------------------

urlpatterns = [url(r'^'+settings.SERVER_BASE_PATH, include(common_urls))]

# ----------------------------------------------------------------------------------------------------------------------
# Static Files
# ----------------------------------------------------------------------------------------------------------------------

urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)


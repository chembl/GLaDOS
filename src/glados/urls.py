from django.conf.urls import include, url
from django.conf.urls.static import static
from glados.utils_refactor import DirectTemplateView
from django.views.decorators.clickjacking import xframe_options_exempt
from django.conf import settings
from . import views
from glados import old_urls_redirector
from django.conf.urls import url
from django.http import HttpResponse

from django.views.generic.base import RedirectView

from glados.es_connection import setup_glados_es_connection, DATA_CONNECTION, MONITORING_CONNECTION

# Setup Elastic Search Connection here only once
setup_glados_es_connection(DATA_CONNECTION)
setup_glados_es_connection(MONITORING_CONNECTION)

common_urls = [

    # --------------------------------------------------------------------------------------------------------------------
    # Main Pages
    # --------------------------------------------------------------------------------------------------------------------
    url(r'^g/$', views.main_html_base_no_bar, name='javascript_routing'),

    url(r'^$',
        views.main_page, name='main'),

    url(r'^tweets/$', views.get_latest_tweets_json, name='tweets'),

    url(r'^database_summary/$', views.get_database_summary, name='database_summary'),

    url(r'^entities_records/$', views.get_entities_records, name='entities_records'),

    url(r'^covid_entities_records/$', views.get_covid_entities_records, name='covid_entities_records'),

    url(r'^github_details/$', views.get_github_details, name='github_details'),

    url(r'^blog_entries/(?P<pageToken>.+)?$', views.get_latest_blog_entries, name='blog_entries'),

    url(r'^visualise/$', views.visualise, name='visualise'),

    url(r'^handlebars/visualisation_sources/$',
        xframe_options_exempt(
            DirectTemplateView.as_view(
                template_name="glados/Handlebars/LazilyLoaded/Visualisations/VisualisationsSources.html")
        ), ),

    url(r'^design_components/$', views.design_components, name='design_components'),

    url(r'^marvin_search_fullscreen/$',
        DirectTemplateView.as_view(template_name="glados/marvin_search_fullscreen.html"), ),

    url(r'^compound_3D_speck/$',
        DirectTemplateView.as_view(template_name="glados/comp_3D_view_speck_fullscreen.html"), ),

    # ------------------------------------------------------------------------------------------------------------------
    # Redirections to other chembl resources and documentation
    # ------------------------------------------------------------------------------------------------------------------

    url(r'^acknowledgements/$',
        RedirectView.as_view(url='https://chembl.gitbook.io/chembl-interface-documentation/acknowledgments',
                             permanent=True), name='acks'),

    url(r'^faq(s)?/$',
        RedirectView.as_view(url='https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions',
                             permanent=True), name='faqs'),

    url(r'^faqs_browsing_related_entities/$',
        RedirectView.as_view(
            url='https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/chembl-interface-questions#browsing-related-entities',
            permanent=True), name='faqs_browsing_related_entities'),

    url(r'^faqs_see_full_query/$',
        RedirectView.as_view(
            url='https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/chembl-interface-questions#i-am-seeing-a-list-of-compounds-or-targets-assays-etc-how-can-i-see-the-query-used',
            permanent=True), name='faqs_see_full_query'),

    url(r'^faqs_edit_query_string/$',
        RedirectView.as_view(
            url='https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/chembl-interface-questions#can-i-edit-the-query-being-used',
            permanent=True), name='faqs_edit_query_string'),

    url(r'^faqs_shorten_url/$',
        RedirectView.as_view(
            url='https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/chembl-data-questions#are-my-queries-stored-and-if-so-are-they-routinely-deleted',
            permanent=True), name='faqs_shorten_url'),

    url(r'^contact_us/$',
        RedirectView.as_view(
            url='https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/general-questions#how-do-i-report-errors-or-make-suggestions-for-the-interface',
            permanent=True), name='contact_us'),

    url(r'^about/$',
        RedirectView.as_view(url='https://chembl.gitbook.io/chembl-interface-documentation/about',
                             permanent=True), name='about_us'),
    url(r'^downloads/$',
        RedirectView.as_view(url='https://chembl.gitbook.io/chembl-interface-documentation/downloads',
                             permanent=True), name='downloads'),
    url(r'^chembl-ntd/$',
        RedirectView.as_view(url='https://chembl.gitbook.io/chembl-ntd/',
                             permanent=True), name='chembl-ntd'),

    url(r'^status/$',
        RedirectView.as_view(url='http://chembl.github.io/status/',
                             permanent=True), name='status'),

    url(r'^ws_home/$',
        RedirectView.as_view(url='https://chembl.gitbook.io/chembl-interface-documentation/web-services',
                             permanent=True), name='web_services_home'),

    url(r'^ws/$',
        RedirectView.as_view(url='https://chembl.gitbook.io/chembl-interface-documentation/web-services',
                             permanent=True), name='web_services_home_2'),

    url(r'^unichem_home/$',
        RedirectView.as_view(url='https://www.ebi.ac.uk/unichem',
                             permanent=True), name='unichem_home'),

    url(r'^surechembl/$',
        RedirectView.as_view(url='https://www.surechembl.org',
                             permanent=True), name='surechembl'),
    url(r'^maip/$',
        RedirectView.as_view(url='https://www.ebi.ac.uk/chembl/maip/',
                             permanent=True), name='maip'),

    url(r'^chembl_rdf/$',
        RedirectView.as_view(url='https://www.ebi.ac.uk/rdf',
                             permanent=True), name='chembl_rdf'),

    url(r'^chembl_blog/$',
        RedirectView.as_view(url='https://chembl.blogspot.co.uk',
                             permanent=True), name='chembl_blog'),

    url(r'^chembl_twitter/$',
        RedirectView.as_view(url='https://twitter.com/chembl',
                             permanent=True), name='chembl_twitter'),

    url(r'^db_schema',
        DirectTemplateView.as_view(template_name="glados/database_schema.html"), name='db_schema'),

    url(r'^admesarfari/$',
        RedirectView.as_view(
            url="https://chembl.gitbook.io/chembl-interface-documentation/legacy-resources#adme-sarfari",
            permanent=True),
        name='adme_sarfari'),

    url(r'^sarfari/kinasesarfari/$',
        RedirectView.as_view(
            url="https://chembl.gitbook.io/chembl-interface-documentation/legacy-resources#kinase-sarfari",
            permanent=True),
        name='kinase_sarfari'),

    url(r'^sarfari/GPCRsarfari/$',
        RedirectView.as_view(
            url="https://chembl.gitbook.io/chembl-interface-documentation/legacy-resources#gpcr-sarfari",
            permanent=True),
        name='gpcr_sarfari'),

    url(r'^malaria/$',
        RedirectView.as_view(
            url="https://chembl.gitbook.io/chembl-interface-documentation/legacy-resources#chembl-malaria",
            permanent=True),
        name='chembl_malaria'),

    url(r'^download_expiration/$',
        RedirectView.as_view(
            url="https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/chembl-download-questions#what-is-the-expiration-date-in-the-downloads-from-the-interface",
            permanent=True),
        name='download_expiration'),

    url(r'^sssearch_expiration/$',
        RedirectView.as_view(
            url="https://chembl.gitbook.io/chembl-interface-documentation/frequently-asked-questions/chembl-interface-questions#what-is-the-expiration-date-in-the-structure-based-searches-from-the-interface",
            permanent=True),
        name='sssearch_expiration'),

    # --------------------------------------------------------------------------------------------------------------------
    # Tests
    # --------------------------------------------------------------------------------------------------------------------
    url(r'^layout_test/$', DirectTemplateView.as_view(template_name="glados/layoutTest.html"), ),
    url(r'^js_tests/$', DirectTemplateView.as_view(template_name="glados/jsTests.html"), ),


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

    # ------------------------------------------------------------------------------------------------------------------
    # Old Interface redirections
    # ------------------------------------------------------------------------------------------------------------------
    url(r'^(index\.php\/)?(?P<entity_name>\w+)/inspect/(?P<chembl_id>\w+)/$', old_urls_redirector.redirect_report_card),

    # --------------------------------------------------------------------------------------------------------------------
    # Tiny urls
    # --------------------------------------------------------------------------------------------------------------------
    url(r'^g/tiny/(?P<hash>.*?)$', views.render_params_from_hash, name='tiny'),

    url(r'^robots.txt', lambda x: HttpResponse(
        "User-Agent: *\nDisallow: / \nUser-Agent: Twitterbot\nAllow: {0}img".format(settings.STATIC_URL),
        content_type="text/plain"),
        name="robots_file"),

    # --------------------------------------------------------------------------------------------------------------------
    # Tracking
    # --------------------------------------------------------------------------------------------------------------------
    url(r'^register_usage', views.register_usage, name='register_usage'),

    # --------------------------------------------------------------------------------------------------------------------
    # Chembl UI API
    # --------------------------------------------------------------------------------------------------------------------
    url(r'^glados_api/', include('glados.api.urls')),

]

# ----------------------------------------------------------------------------------------------------------------------
# SERVER BASE PATH DEFINITION
# ----------------------------------------------------------------------------------------------------------------------

urlpatterns = [url(r'^' + settings.SERVER_BASE_PATH, include(common_urls))]

# ----------------------------------------------------------------------------------------------------------------------
# Static Files
# ----------------------------------------------------------------------------------------------------------------------

urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

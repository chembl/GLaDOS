from elasticsearch_dsl import Search
import json
from django.contrib.staticfiles.templatetags.staticfiles import static
from django.conf import settings
from django.urls import reverse
from glados.es_connection import DATA_CONNECTION, MONITORING_CONNECTION

# This uses elasticsearch to generate helper objects to generate the schema tags of the pages
# ------------------------------------------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------------------------------------------


def get_no_metadata_object():
    schema_obj = {
        'metadata_generated': False
    }
    return schema_obj


# ------------------------------------------------------------------------------------------------------------------
# Main Page
# ------------------------------------------------------------------------------------------------------------------
def get_main_page_schema(request):

    if request is not None:
        absolute_uri = request.build_absolute_uri()
    else:
        absolute_uri = 'http://0.0.0.0:8000/'

    metadata_obj = {
        '@context': {
            'schema': 'http://schema.org/',
            'bs': 'http://bioschemas.org/'
        },
        '@type': 'schema:Dataset',
        '@id': '{base_url}#data'.format(base_url=absolute_uri),
        'schema:name': 'ChEMBL',
        'schema:description': 'A manually curated database of bioactive molecules with drug-like properties. It brings '
                              'together chemical, bioactivity and genomic data to aid the translation of '
                              'genomic information into effective new drugs.',
        'schema:url': absolute_uri,
        'schema:identifier': settings.CURRENT_CHEMBL_FULL_DOI,
        'schema:keywords': 'database, molecule, chemical, curated, bioactivities',
        'schema:includedInDataCatalog': absolute_uri,
        'schema:creator': {
            '@context': 'http://schema.org/',
            '@type': 'Organization',
            'name': 'EMBL-EBI',
            'url': 'https://www.ebi.ac.uk/'
        },
        'schema:version': settings.CURRENT_CHEMBL_RELEASE_NAME,
        'schema:license': 'Creative Commons Attribution-Share Alike 3.0 Unported License',
    }

    if request is not None:
        downloads_url = request.build_absolute_uri(reverse('downloads'))
    else:
        downloads_url = 'http://0.0.0.0:8000' + reverse('downloads')

    metadata_obj['schema:distribution'] = []
    for current_format in ['.fa', '.fps', '.sdf', '_bio.fa', '_chemreps.txt', '_mysql.tar',
                           '_oracle10g.tar', '_oracle11g.tar', '_oracle12c.tar', '_postgresql.tar', '_sqlite.tar']:

        distribution = {
            '@context': 'http://schema.org/',
            '@type': 'DataDownload',
            'name': settings.CURRENT_CHEMBL_RELEASE_NAME,
            'encodingFormat': 'application/gzip',
            'contentURL': 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/{release_name}{current_format}.gz'
            .format(
                release_name=settings.DOWNLOADS_RELEASE_NAME,
                current_format=current_format
            ),
            'uploadDate': settings.CURRENT_DOWNLOADS_DATE,
            'url': downloads_url
        }
        metadata_obj['schema:distribution'].append(distribution)

    for current_format in ['_schema_documentation', '_release_notes']:

        distribution = {

            '@context': 'http://schema.org/',
            '@type': 'DataDownload',
            'name': settings.CURRENT_CHEMBL_RELEASE_NAME,
            'encodingFormat': 'text/plain',
            'contentURL': 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/{release_name}{current_format}.txt'
            .format(
                release_name=settings.DOWNLOADS_RELEASE_NAME,
                current_format=current_format
            ),
            'uploadDate': settings.CURRENT_DOWNLOADS_DATE,
            'url': downloads_url
        }
        metadata_obj['schema:distribution'].append(distribution)

    metadata_obj['schema:distribution'].append({
        '@context': 'http://schema.org/',
        '@type': 'DataDownload',
        'name': settings.CURRENT_CHEMBL_RELEASE_NAME,
        'encodingFormat': 'text/plain',
        'contentURL': 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/chembl_uniprot_mapping.txt',
        'uploadDate': settings.CURRENT_DOWNLOADS_DATE,
        'url': downloads_url
    })

    metadata_obj['schema:distribution'].append({
        '@context': 'http://schema.org/',
        '@type': 'DataDownload',
        'name': settings.CURRENT_CHEMBL_RELEASE_NAME,
        'encodingFormat': 'text/html',
        'contentURL': 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/{release_name}'
                      '_schema_documentation.html'.format(release_name=settings.DOWNLOADS_RELEASE_NAME),
        'uploadDate': settings.CURRENT_DOWNLOADS_DATE,
        'url': downloads_url
    })

    metadata_obj['schema:distribution'].append({
        '@context': 'http://schema.org/',
        '@type': 'DataDownload',
        'name': settings.CURRENT_CHEMBL_RELEASE_NAME,
        'encodingFormat': 'image/png',
        'contentURL': 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/{release_name}_schema.png'.format(
            release_name=settings.DOWNLOADS_RELEASE_NAME),
        'uploadDate': settings.CURRENT_DOWNLOADS_DATE,
        'url': downloads_url
    })

    metadata_obj['schema:distribution'].append({
        '@context': 'http://schema.org/',
        '@type': 'DataDownload',
        'name': settings.CURRENT_CHEMBL_RELEASE_NAME,
        'encodingFormat': 'application/xml',
        'contentURL': "ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/{release_name}_monomer_library.xml"
            .format(release_name=settings.DOWNLOADS_RELEASE_NAME),
        'uploadDate': settings.CURRENT_DOWNLOADS_DATE,
        'url': downloads_url
    })

    return metadata_obj


# ------------------------------------------------------------------------------------------------------------------
# Compound
# ------------------------------------------------------------------------------------------------------------------
def get_schema_obj_for_compound(chembl_id, request):

    q = {
        "query_string": {
            "default_field": "molecule_chembl_id",
            "query": chembl_id
        }
    }
    s = Search(index=settings.CHEMBL_ES_INDEX_PREFIX+"molecule")\
        .extra(track_total_hits=True).using(DATA_CONNECTION).query(q)
    response = s.execute()

    if response.hits.total.value == 0:
        return get_no_metadata_object()

    item = response.hits[0]
    molecule_type = item['molecule_type']
    do_not_generate_metadata = molecule_type in ['Unclassified', 'Cell', 'Antibody', 'Enzyme', 'Protein']
    if do_not_generate_metadata:
        return get_no_metadata_object()

    metadata_obj = {
        "@context": "http://schema.org",
        "@type": "MolecularEntity",
        "identifier": chembl_id,
        "url": request.build_absolute_uri(),
    }

    item_name = item['pref_name']
    if item_name is not None:
        metadata_obj['name'] = item['pref_name']

    iupac_name = ""
    alternate_names_set = set()
    raw_synonyms = item['molecule_synonyms']
    if raw_synonyms is not None:
        for raw_syn in raw_synonyms:
            alternate_names_set.add(raw_syn['molecule_synonym'])
            if raw_syn['syn_type'] == 'SYSTEMATIC':
                iupac_name = raw_syn['molecule_synonym']

    alternate_names = list(alternate_names_set)
    if len(alternate_names) > 0:
        metadata_obj['alternateName'] = alternate_names

    if len(iupac_name):
        metadata_obj['iupacName'] = iupac_name

    try:
        placeholder_image = item['_metadata']['compound_generated']['image_file']
        host_url = request.get_host()
        image_local_url = static("img/compound_placeholders/{}".format(placeholder_image))
        metadata_obj['image'] = "{}{}".format(host_url, image_local_url)
    except (KeyError, AttributeError, TypeError):
        metadata_obj['image'] = "{0}/image/{1}.svg".format(settings.WS_URL, chembl_id)

    try:
        metadata_obj['molecularFormula'] = item['molecule_properties']['full_molformula']
    except (KeyError, AttributeError, TypeError):
        pass

    try:
        metadata_obj['molecularWeight'] = float(item['molecule_properties']['full_mwt'])
    except (KeyError, AttributeError, TypeError):
        pass

    try:
        metadata_obj['monoisotopicMolecularWeight'] = float(item['molecule_properties']['mw_monoisotopic'])
    except (KeyError, AttributeError, TypeError):
        pass

    try:
        metadata_obj['inChI'] = item['molecule_structures']['standard_inchi']
    except (KeyError, AttributeError, TypeError):
        pass

    try:
        metadata_obj['inChIKey'] = item['molecule_structures']['standard_inchi_key']
    except (KeyError, AttributeError, TypeError):
        pass

    try:
        metadata_obj['smiles'] = [item['molecule_structures']['canonical_smiles']]
    except (KeyError, AttributeError, TypeError):
        pass

    try:
        related_targets_ids = item['_metadata']['related_targets']['all_chembl_ids'].split(' ')[:5]
        related_targets_for_schema = []

        for targ_id in related_targets_ids:
            rel_target_obj = {
                "@type": "BioChemEntity",
                "identifier": targ_id,
                "url": "{}/{}target_report_card/{}/".format(request.get_host(), settings.SERVER_BASE_PATH, targ_id)
            }
            related_targets_for_schema.append(rel_target_obj)
        if len(related_targets_for_schema) == 0:
            related_targets_for_schema = None

        metadata_obj['bioChemInteraction'] = related_targets_for_schema
    except (KeyError, AttributeError, TypeError):
        pass

    schema_obj = {
        'metadata_generated': True,
        'metadata_obj': json.dumps(metadata_obj, indent=2)

    }
    return schema_obj

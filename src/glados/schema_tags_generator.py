from elasticsearch_dsl import Search
import json
from django.contrib.staticfiles.templatetags.staticfiles import static
from django.conf import settings
# This uses elasticsearch to generate helper objects to generate the schema tags of the pages
# ------------------------------------------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------------------------------------------


def get_no_metadata_object():
    schema_obj = {
        'metadata_generated': False
    }
    return schema_obj


def get_schema_obj_for_compound(chembl_id, request):

    q = {
        "query_string": {
            "default_field": "molecule_chembl_id",
            "query": chembl_id
        }
    }
    s = Search(index="chembl_molecule").query(q)
    response = s.execute()

    if response.hits.total == 0:
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

    alternate_names_set = set()
    raw_synonyms = item['molecule_synonyms']
    if raw_synonyms is not None:
        for raw_syn in raw_synonyms:
            alternate_names_set.add(raw_syn['molecule_synonym'])

    alternate_names = list(alternate_names_set)
    if len(alternate_names) > 0:
        metadata_obj['alternateName'] = alternate_names

    try:
        placeholder_image = item['_metadata']['compound_generated']['image_file']
        host_url = request.get_host()
        image_local_url = static("img/compound_placeholders/{}".format(placeholder_image))
        metadata_obj['image'] = "{}{}".format(host_url, image_local_url)
    except (KeyError, AttributeError, TypeError):
        metadata_obj['image'] = "https://www.ebi.ac.uk/chembl/api/data/image/{}.svg?engine=indigo".format(chembl_id)

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
        metadata_obj['canonical_smiles'] = [item['molecule_structures']['canonical_smiles']]
    except (KeyError, AttributeError, TypeError):
        pass

    try:
        related_targets_ids = item['_metadata']['related_targets']['chembl_ids']['0'][:5]
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

        metadata_obj['biochemicalInteraction'] = related_targets_for_schema
    except (KeyError, AttributeError, TypeError):
        pass

    schema_obj = {
        'metadata_generated': True,
        'metadata_obj': json.dumps(metadata_obj, indent=2)

    }
    return schema_obj

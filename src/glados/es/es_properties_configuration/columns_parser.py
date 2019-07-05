def parse_synonyms(raw_synonyms):
    true_synonyms = set()
    for raw_syn in raw_synonyms:
        true_synonyms.add(raw_syn['synonyms'])
    sorted_synonyms = list(true_synonyms)
    sorted_synonyms.sort()
    return '|'.join(sorted_synonyms)


def parse_research_codes(raw_synonyms):
    true_synonyms = set()
    for raw_syn in raw_synonyms:
        if raw_syn['syn_type'] == 'RESEARCH_CODE':
            true_synonyms.add(raw_syn['molecule_synonym'])
    sorted_synonyms = list(true_synonyms)
    sorted_synonyms.sort()
    return '|'.join(sorted_synonyms)


def list_to_pipe_separated_string(raw_applicants):
    return '|'.join(raw_applicants)


def escape_text_with_simple_colon(raw_value):
    if raw_value is None:
        return ''
    if raw_value == '':
        return ''
    return "'{}'".format(raw_value)


def parse_drug_atc_classifications(raw_classifications):
    return '|'.join([class_data['code'] for class_data in raw_classifications])


def parse_drug_atc_class_descriptions(raw_classifications):
    return '|'.join([class_data['description'] for class_data in raw_classifications])


def parse_drug_type(raw_type):
    type = int(raw_type)
    if type == 1:
        return '1:Synthetic Small Molecule'
    elif type == 2:
        return '2:Enzyme'
    elif type == 3:
        return '3:Oligosaccharide'
    elif type == 4:
        return '4:Oligonucleotide'
    elif type == 5:
        return '5:Oligopeptide'
    elif type == 6:
        return '6:Antibody'
    elif type == 7:
        return '7:Natural Product-derived'
    elif type == 8:
        return '8:Cell-based'
    elif type == 9:
        return '9:Inorganic'
    elif type == 10:
        return '10:Polymer'
    elif type == -1:
        return '-1:Unknown'
    else:
        return ''


def parse_target_uniprot_accession(raw_components):
    accessions = []
    for comp in raw_components:
        accession = comp.get('accession')
        if accession is not None:
            accessions.append(accession)

    return '|'.join(accessions)


def parse_mech_of_act_synonyms(raw_synonyms):
    return '|'.join(raw_synonyms)


def parse_document_source(raw_source):
    return '|'.join([v['src_description'] for v in raw_source])


def parse_efo_ids(raw_efo_data):
    return '|'.join([v['id'] for v in raw_efo_data])


def parse_efo_efo_terms(raw_efo_data):
    return '|'.join([v['term'] for v in raw_efo_data])


def parse_mech_or_indication_refs(raw_refs):
    return '|'.join(['Type: {} RefID: {} URL: {}'.format(r['ref_type'], r['ref_id'], r['ref_url']) for r in raw_refs])


def parse_mech_or_indication_syns(raw_synonyms):
    return '|'.join(raw_synonyms)


def parse_assay_parameters(raw_parameters):

    params_groups = []

    for param in raw_parameters:

        useful_params = []

        for key in ['standard_type', 'standard_relation', 'standard_value', 'standard_units', 'comments']:
            useful_params.append('{param_name}:{value}'.format(param_name=key, value=param[key]))

        params_groups.append(' '.join(useful_params))

    return ' | '.join(params_groups)


PARSING_FUNCTIONS = {
    'chembl_molecule': {
        'molecule_synonyms': lambda original_value: parse_synonyms(original_value),
        'research_codes': lambda original_value: parse_research_codes(original_value),
        '_metadata.drug.drug_data.applicants': lambda original_value: list_to_pipe_separated_string(original_value),
        'usan_stem': lambda original_value: escape_text_with_simple_colon(original_value),
        '_metadata.drug.drug_data.usan_stem_substem': lambda original_value: escape_text_with_simple_colon(
            original_value),
        'drug_atc_classifications': lambda original_value: parse_drug_atc_classifications(original_value),
        'drug_atc_descriptions': lambda original_value: parse_drug_atc_class_descriptions(original_value),
        '_metadata.drug.drug_data.drug_type': lambda original_value: parse_drug_type(original_value),
    },
    'chembl_target': {
        'uniprot_accessions': lambda original_value: parse_target_uniprot_accession(original_value)
    },
    'chembl_assay': {
        'assay_parameters': lambda original_value: parse_assay_parameters(original_value)
    },
    'chembl_document': {
        '_metadata.source': lambda original_value: parse_document_source(original_value),
    },
    'chembl_activity': {
        'standard_relation': lambda original_value: escape_text_with_simple_colon(original_value),
    },
    'chembl_mechanism_by_parent_target': {
        'parent_molecule._metadata.drug.drug_data.synonyms': lambda original_value: parse_mech_of_act_synonyms(
            original_value)
    },
    'chembl_drug_indication_by_parent': {
        'parent_molecule._metadata.drug.drug_data.synonyms': lambda original_value: parse_mech_of_act_synonyms(
            original_value),
        'efo_ids': lambda original_value: parse_efo_ids(original_value),
        'efo_terms': lambda original_value: parse_efo_efo_terms(original_value),
        'drug_indication.indication_refs': lambda original_value: parse_mech_or_indication_refs(original_value),
        'parent_molecule._metadata.drug.drug_data.synonyms': lambda original_value: parse_mech_or_indication_syns(
            original_value),
        'parent_molecule._metadata.drug.drug_data.usan_stem': lambda original_value: escape_text_with_simple_colon(
            original_value)
    },
    'chembl_mechanism_by_parent_target': {
        'parent_molecule.usan_stem': lambda original_value: escape_text_with_simple_colon(
            original_value),
        'mechanism_of_action.mechanism_comment': lambda original_value: list_to_pipe_separated_string(original_value),
        'mechanism_of_action.selectivity_comment': lambda original_value: list_to_pipe_separated_string(original_value),
        'mechanism_of_action.mechanism_refs': lambda raw_refs: parse_mech_or_indication_refs(raw_refs),
        'parent_molecule._metadata.drug.drug_data.synonyms': lambda original_value: parse_mech_or_indication_syns(
            original_value),
        'mechanism_of_action.binding_site_comment': lambda original_value: list_to_pipe_separated_string(original_value)
    }

}


def parse(original_value, index_name, property_name):
    functions_for_index = PARSING_FUNCTIONS.get(index_name)

    if functions_for_index is None:
        return original_value
    else:
        function_for_property = functions_for_index.get(property_name)
        if function_for_property is None:
            return original_value
        else:
            return function_for_property(original_value)

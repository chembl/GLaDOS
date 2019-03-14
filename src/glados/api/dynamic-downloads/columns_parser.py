def parse_synonyms(raw_synonyms):
    true_synonyms = set()
    for raw_syn in raw_synonyms:
        true_synonyms.add(raw_syn['synonyms'])
    return '|'.join(true_synonyms)


def parse_target_uniprot_accession(raw_components):
    accessions = []
    for comp in raw_components:
        accession = comp.get('accession')
        if accession is not None:
            accessions.append(accession)

    return '|'.join(accessions)


PARSING_FUNCTIONS = {
    'chembl_molecule': {
        'molecule_synonyms': lambda original_value: parse_synonyms(original_value)
    },
    'chembl_target': {
        'target_components': lambda original_value: parse_target_uniprot_accession(original_value)
    }
}


def static_parse_property(original_value, index_name, property_name):

    functions_for_index = PARSING_FUNCTIONS.get(index_name)

    if functions_for_index is None:
        return original_value
    else:
        function_for_property = functions_for_index.get(property_name)
        if function_for_property is None:
            return original_value
        else:
            return function_for_property(original_value)
from elasticsearch_dsl import Search
# This uses elasticsearch to generate og tags for the main entities in ChEMBL (Compounds, Targets, Assays, Documents,
# Cell Lines, Tissues) and other pages. These tags are used to generate a preview when you share the page in social
# media

def get_og_tags_for_compound(chembl_id):

    q = {
        "query_string": {
            "default_field": "molecule_chembl_id",
            "query": chembl_id
        }
    }
    s = Search(index="chembl_molecule").query(q)
    response = s.execute()

    title = 'Compound: '+ chembl_id
    description = 'Compound not found'
    if response.hits.total == 1:
        description = ''
        description_items = []
        item = response.hits[0]
        # add the items to the description if they are available
        pref_name = item['pref_name']
        if pref_name is not None:
            title = 'Compound: '+ pref_name

        molecule_type = item['molecule_type']
        if molecule_type is not None:
            description_items.append("{}".format(molecule_type))

        try:
            mol_formula = item['molecule_properties']['full_molformula']
            description_items.append("Molecular Formula: {}".format(mol_formula))
        except (AttributeError, TypeError):
            pass

        try:
            mol_formula = item['molecule_properties']['full_mwt']
            description_items.append("Molecular Weight: {}".format(mol_formula))
        except (AttributeError, TypeError):
            pass

        synonyms = set()
        tradenames = set()
        raw_synonyms = item['molecule_synonyms']
        if raw_synonyms is not None:
            for raw_syn in raw_synonyms:
                if raw_syn['syn_type'] != 'TRADE_NAME':
                    synonyms.add(raw_syn['molecule_synonym'])
                else:
                    tradenames.add(raw_syn['molecule_synonym'])

            if len(synonyms) > 0:
                description_items.append("Synonyms: {}".format(";".join(synonyms)))
            if len(tradenames) > 0:
                description_items.append("Trade Names: {}".format(";".join(tradenames)))
        description = ', '.join(description_items)

    og_tags = {
        'chembl_id': chembl_id,
        'title': title,
        'description': description
    }
    return og_tags

def get_og_tags_for_target(chembl_id):

    q = {
        "query_string": {
            "default_field": "target_chembl_id",
            "query": chembl_id
        }
    }

    s = Search(index="chembl_target").query(q)
    response = s.execute()

    title = 'Target: ' + chembl_id
    description = 'Target not found'
    if response.hits.total == 1:
        description = ''
        description_items = []
        item = response.hits[0]
        # add the items to the description if they are available
        pref_name = item['pref_name']
        if pref_name is not None:
            title = 'Target: ' + pref_name

        target_type = item['target_type']
        if target_type is not None:
            description_items.append("Type: {}".format(target_type))

        organism = item['organism']
        if organism is not None:
            description_items.append("Type: {}".format(organism))

        description = ', '.join(description_items)

    og_tags = {
        'chembl_id': chembl_id,
        'title': title,
        'description': description
    }
    return og_tags

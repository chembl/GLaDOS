from elasticsearch_dsl import Search
# This uses elasticsearch to generate og tags for the main entities in ChEMBL (Compounds, Targets, Assays, Documents,
# Cell Lines, Tissues) and other pages. These tags are used to generate a preview when you share the page in social
# media

# --------------------------------------------------------------------------------------------------------------------
# Helper Functions
# --------------------------------------------------------------------------------------------------------------------


def add_attribute_to_tescription(description_items, item, attr_name, text_attr_name):

    attr_vale = item[attr_name]
    if attr_vale is not None:
        description_items.append("{}: {}".format(text_attr_name, attr_vale))

# --------------------------------------------------------------------------------------------------------------------
# Tag generation functions
# --------------------------------------------------------------------------------------------------------------------


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

        add_attribute_to_tescription(description_items, item, 'molecule_type', 'Molecule Type')

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

        add_attribute_to_tescription(description_items, item, 'target_type', 'Type')
        add_attribute_to_tescription(description_items, item, 'organism', 'Organism')

        description = ', '.join(description_items)

    og_tags = {
        'chembl_id': chembl_id,
        'title': title,
        'description': description
    }
    return og_tags


def get_og_tags_for_assay(chembl_id):

    q = {
        "query_string": {
            "default_field": "assay_chembl_id",
            "query": chembl_id
        }
    }

    s = Search(index="chembl_assay").query(q)
    response = s.execute()

    title = 'Assay: ' + chembl_id
    description = 'Assay not found'
    if response.hits.total == 1:
        description = ''
        description_items = []
        item = response.hits[0]
        # add the items to the description if they are available

        add_attribute_to_tescription(description_items, item, 'assay_type_description', 'Type')
        add_attribute_to_tescription(description_items, item, 'assay_organism', 'Organism')
        add_attribute_to_tescription(description_items, item, 'description', 'Description')

        description = ', '.join(description_items)

    og_tags = {
        'chembl_id': chembl_id,
        'title': title,
        'description': description
    }

    return og_tags

def get_og_tags_for_cell_line(chembl_id):

    q = {
        "query_string": {
            "default_field": "cell_chembl_id",
            "query": chembl_id
        }
    }

    s = Search(index="chembl_cell_line").query(q)
    response = s.execute()

    title = 'Cell Line: ' + chembl_id
    description = 'Target not found'
    if response.hits.total == 1:
        description = ''
        description_items = []
        item = response.hits[0]
        # add the items to the description if they are available
        cell_name = item['cell_name']
        if cell_name is not None:
            title = 'Cell Line: ' + cell_name

        add_attribute_to_tescription(description_items, item, 'cell_source_organism', 'Source Organism')
        add_attribute_to_tescription(description_items, item, 'cell_source_tissue', 'Source Tissue')
        add_attribute_to_tescription(description_items, item, 'cell_description', 'Description')
        description = ', '.join(description_items)

    og_tags = {
        'chembl_id': chembl_id,
        'title': title,
        'description': description
    }

    return og_tags
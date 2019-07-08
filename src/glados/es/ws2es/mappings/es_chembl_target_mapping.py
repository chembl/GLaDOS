# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# Target relations with compounds make them have big documents
shards = 5
replicas = 1

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        '_doc': 
        {
            'properties': 
            {
                '_metadata':
                {
                    'properties':
                    {
                        'es_completion': DefaultMappings.COMPLETION_TYPE,
                        'activity_count': DefaultMappings.LONG,
                        'disease_name': DefaultMappings.LOWER_CASE_KEYWORD + DefaultMappings.TEXT_STD,
                        'related_compounds':
                        {
                            'properties':
                            {
                                'chembl_ids': {
                                    'properties': {
                                        # '0': DefaultMappings.CHEMBL_ID_REF
                                    }
                                },
                                'count': DefaultMappings.LONG,
                                # EXAMPLES:
                                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                            }
                        },
                        'tags': DefaultMappings.LOWER_CASE_KEYWORD
                    }
                },
                'cross_references':
                {
                    'properties':
                    {
                        'xref_id': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'EBI-9009008' , 'EBI-9685439' , 'Nicotinamide_phosphoribosyltransferase' , 'Replication_protei
                        # n_A1' , 'NBK23341' , 'P0A7Y4' , 'CDC14A' , 'BUB1' , 'Q8IL32' , 'O94782'
                        'xref_name': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'None' , 'None' , 'Delta opioid receptor' , 'None' , 'None' , 'None' , 'Somatostatin receptor
                        # (sst2)' , 'None' , '5-HT4 serotonin receptors' , 'None'
                        'xref_src': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'ComplexPortal' , 'ComplexPortal' , 'Wikipedia' , 'Wikipedia' , 'MICAD' , 'canSAR-Target' , 'W
                        # ikipedia' , 'Wikipedia' , 'canSAR-Target' , 'canSAR-Target'
                    }
                },
                'organism': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Bos taurus' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens' , 'H
                # omo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens'
                'pref_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'Glutathione S-transferase Mu 3' , 'Anandamide amidohydrolase' , 'Estrogen sulfotransferase' , 'Histam
                # ine H2 receptor' , 'Aldehyde reductase' , 'Atrial natriuretic peptide receptor C' , 'IgE Fc receptor, 
                # alpha-subunit' , 'Lysyl oxidase' , 'Tyrosine-protein kinase BLK' , 'PI4-kinase type II'
                'species_group_flag': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'target_chembl_id': DefaultMappings.CHEMBL_ID,
                # EXAMPLES:
                # 'CHEMBL2242' , 'CHEMBL2243' , 'CHEMBL2244' , 'CHEMBL2245' , 'CHEMBL2246' , 'CHEMBL2247' , 'CHEMBL2248'
                #  , 'CHEMBL2249' , 'CHEMBL2250' , 'CHEMBL2251'
                'target_components': 
                {
                    'properties': 
                    {
                        'accession': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'P21266' , 'O00519' , 'P19217' , 'P97292' , 'P14550' , 'P17342' , 'P12319' , 'P28300' , 'P5145
                        # 1' , 'Q9BTU6'
                        'component_description': DefaultMappings.TEXT_STD,
                        # EXAMPLES:
                        # 'Glutathione S-transferase Mu 3' , 'Fatty-acid amide hydrolase 1' , 'Estrogen sulfotransferase
                        # ' , 'Histamine H2 receptor' , 'Alcohol dehydrogenase [NADP(+)]' , 'Atrial natriuretic peptide 
                        # receptor 3' , 'High affinity immunoglobulin epsilon receptor subunit alpha' , 'Protein-lysine 
                        # 6-oxidase' , 'Tyrosine-protein kinase Blk' , 'Phosphatidylinositol 4-kinase type 2-alpha'
                        'component_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # '583' , '584' , '585' , '586' , '587' , '588' , '589' , '590' , '591' , '592'
                        'component_type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' 
                        # , 'PROTEIN' , 'PROTEIN'
                        'relationship': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' ,
                        #  'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN'
                        'target_component_synonyms': 
                        {
                            'properties': 
                            {
                                'component_synonym': DefaultMappings.ALT_NAME,
                                # EXAMPLES:
                                # 'GST5' , 'FAAH1' , 'OST ' , 'Hrh2' , 'ALDR1 ' , 'ANPRC ' , 'FCE1A' , 'LOX' , 'BLK' , '
                                # PI4K2A'
                                'syn_type': DefaultMappings.KEYWORD,
                                # EXAMPLES:
                                # 'GENE_SYMBOL' , 'GENE_SYMBOL' , 'GENE_SYMBOL' , 'GENE_SYMBOL' , 'GENE_SYMBOL' , 'GENE_
                                # SYMBOL' , 'GENE_SYMBOL' , 'GENE_SYMBOL' , 'GENE_SYMBOL' , 'GENE_SYMBOL'
                            }
                        },
                        'target_component_xrefs': {
                            'properties': {
                                'xref_id': DefaultMappings.KEYWORD,
                                # EXAMPLES:
                                # 'Q9UPZ9' , 'GO:0006508' , 'P0AEG4' , 'Q7KQK5' , 'Q9IP65' , 'Q14332' , 'O00398' , 'Q8G9
                                # Q0' , 'Q848S6' , 'A7WP95'
                                'xref_name': DefaultMappings.KEYWORD,
                                # EXAMPLES:
                                # 'None' , 'brainstem development' , 'transport' , 'placenta development' , 'None' , 'tr
                                # ansport' , 'transcription, DNA-templated' , 'None' , 'None' , 'proteolysis'
                                'xref_src_db': DefaultMappings.KEYWORD
                                # EXAMPLES:
                                # 'UniProt' , 'GoProcess' , 'UniProt' , 'UniProt' , 'UniProt' , 'UniProt' , 'UniProt' ,
                                # 'UniProt' , 'UniProt' , 'UniProt'
                            }
                        }
                    }
                },
                'target_type': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE
                #  PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN'
                'tax_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '9606' , '9606' , '9606' , '9606' , '10090' , '10090' , '10116' , '9606' , '10116' , '10090'
            }
        }
    }

autocomplete_settings = {
    'pref_name': 100,
    'organism': 20,
    'target_chembl_id': 10,
    'target_components': {
        'target_component_synonyms': {
            'component_synonym': 75
        }
    }
}
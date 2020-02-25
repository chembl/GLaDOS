# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# shards = 3,
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
                        'activity_count': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'es_completion': 'TEXT',
                        # EXAMPLES:
                        # '{'weight': 75, 'input': 'Voltage-dependent T-type calcium channel subunit alpha-1H'}' , '{'we
                        # ight': 20, 'input': 'Ascaris suum'}' , '{'weight': 100, 'input': 'Dihydrofolate reductase'}' ,
                        #  '{'weight': 75, 'input': 'Abelson tyrosine-protein kinase 1'}' , '{'weight': 75, 'input': 'Re
                        # ceptor tyrosine-protein kinase erbB-1'}' , '{'weight': 75, 'input': 'Thrombin heavy chain'}' ,
                        #  '{'weight': 10, 'input': 'CHEMBL1801'}' , '{'weight': 75, 'input': 'Serpin C1'}' , '{'weight'
                        # : 75, 'input': '3.2.1.18'}' , '{'weight': 100, 'input': 'Glucocorticoid receptor'}'
                        'related_compounds': 
                        {
                            'properties': 
                            {
                                'count': 'NUMERIC',
                                # EXAMPLES:
                                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                            }
                        },
                    }
                },
                'cross_references': 
                {
                    'properties': 
                    {
                        'xref_id': 'TEXT',
                        # EXAMPLES:
                        # 'O95180' , 'O96760' , 'P00374' , 'P00519' , 'P00533' , 'P00734' , 'P00747' , 'P01008' , 'P0346
                        # 8' , 'P04150'
                        'xref_name': 'TEXT',
                        # EXAMPLES:
                        # 'Epidermal growth factor receptor' , '5-HT4 serotonin receptors' , 'Matrix metalloprotein-2 (M
                        # MP-2)' , 'Caspase-3' , 'IGF1 receptor (IGF1R), CCND1 mRNA' , 'Dopamine transporter (DAT)' , 'G
                        # astrin/cholecystokinin-2 (CCK-2, CCK-B) receptor' , 'Brain norepinephrine transporter (NET)' ,
                        #  'Carbonic anhydrase IX' , 'Alpha-Fetoprotein (AFP)'
                        'xref_src': 'TEXT',
                        # EXAMPLES:
                        # 'canSAR-Target' , 'canSAR-Target' , 'canSAR-Target' , 'canSAR-Target' , 'canSAR-Target' , 'can
                        # SAR-Target' , 'canSAR-Target' , 'canSAR-Target' , 'canSAR-Target' , 'canSAR-Target'
                    }
                },
                'organism': 'TEXT',
                # EXAMPLES:
                # 'Homo sapiens' , 'Ascaris suum' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 
                # 'Homo sapiens' , 'Homo sapiens' , 'Influenza A virus (A/Puerto Rico/8/1934(H1N1))' , 'Homo sapiens'
                'pref_name': 'TEXT',
                # EXAMPLES:
                # 'Voltage-gated T-type calcium channel alpha-1H subunit' , 'Nicotinic acetylcholine receptor alpha subu
                # nit' , 'Dihydrofolate reductase' , 'Tyrosine-protein kinase ABL' , 'Epidermal growth factor receptor e
                # rbB1' , 'Thrombin' , 'Plasminogen' , 'Antithrombin-III' , 'Neuraminidase' , 'Glucocorticoid receptor'
                'species_group_flag': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1859' , 'CHEMBL1884' , 'CHEMBL202' , 'CHEMBL1862' , 'CHEMBL203' , 'CHEMBL204' , 'CHEMBL1801' , 
                # 'CHEMBL1950' , 'CHEMBL2051' , 'CHEMBL2034'
                'target_components': 
                {
                    'properties': 
                    {
                        'accession': 'TEXT',
                        # EXAMPLES:
                        # 'O95180' , 'O96760' , 'P00374' , 'P00519' , 'P00533' , 'P00734' , 'P00747' , 'P01008' , 'P0346
                        # 8' , 'P04150'
                        'component_description': 'TEXT',
                        # EXAMPLES:
                        # 'Voltage-dependent T-type calcium channel subunit alpha-1H' , 'Nicotinic acetylcholine recepto
                        # r alpha subunit' , 'Dihydrofolate reductase' , 'Tyrosine-protein kinase ABL1' , 'Epidermal gro
                        # wth factor receptor' , 'Prothrombin' , 'Plasminogen' , 'Antithrombin-III' , 'Neuraminidase' , 
                        # 'Glucocorticoid receptor'
                        'component_id': 'NUMERIC',
                        # EXAMPLES:
                        # '167' , '198' , '396' , '173' , '147' , '92' , '93' , '273' , '391' , '371'
                        'component_type': 'TEXT',
                        # EXAMPLES:
                        # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' 
                        # , 'PROTEIN' , 'PROTEIN'
                        'relationship': 'TEXT',
                        # EXAMPLES:
                        # 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' ,
                        #  'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN'
                        'target_component_synonyms': 
                        {
                            'properties': 
                            {
                                'component_synonym': 'TEXT',
                                # EXAMPLES:
                                # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None
                                # '
                                'syn_type': 'TEXT',
                                # EXAMPLES:
                                # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None
                                # '
                            }
                        },
                        'target_component_xrefs': 
                        {
                            'properties': 
                            {
                                'xref_id': 'TEXT',
                                # EXAMPLES:
                                # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None
                                # '
                                'xref_name': 'TEXT',
                                # EXAMPLES:
                                # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None
                                # '
                                'xref_src_db': 'TEXT',
                                # EXAMPLES:
                                # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None
                                # '
                            }
                        }
                    }
                },
                'target_type': 'TEXT',
                # EXAMPLES:
                # 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE
                #  PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN'
                'tax_id': 'NUMERIC',
                # EXAMPLES:
                # '9606' , '6253' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '211044' , '9606'
            }
        }
    }

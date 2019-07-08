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
                        # '{'weight': 75, 'input': 'CYP-S1'}' , '{'weight': 75, 'input': 'NET1'}' , '{'weight': 10, 'inp
                        # ut': 'CHEMBL2039'}' , '{'weight': 75, 'input': 'ENR'}' , '{'weight': 75, 'input': 'IMPA'}' , '
                        # {'weight': 75, 'input': 'GABT1'}' , '{'weight': 100, 'input': 'Somatostatin receptor 2'}' , '{
                        # 'weight': 75, 'input': 'Type II 5-alpha reductase'}' , '{'weight': 100, 'input': 'Amiloride-se
                        # nsitive sodium channel alpha-subunit'}' , '{'weight': 10, 'input': 'CHEMBL236'}'
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
                        # 'PPIB' , 'Norepinephrine_transporter' , 'Monoamine_oxidase_B' , 'P0AEK4' , 'IMPA1' , 'GABA_tra
                        # nsporter_1' , 'Somatostatin_receptor_2' , 'SRD5A2' , 'SCNN1A' , 'NBK23011'
                        'xref_name': 'TEXT',
                        # EXAMPLES:
                        # 'Delta opioid receptor' , 'Type 2 vesicular monoamine transporter (VMAT2)' , 'Prostate-specifi
                        # c membrane antigen (PSMA)' , 'Dopamine D4 receptors' , 'Somatostatin receptor (sst2)' , 'Delta
                        #  opioid receptor' , 'Epidermal growth factor receptor (EGFR)' , 'Adenosine A1 receptor' , 'Pol
                        # y(ADP-ribose)polymerase-1 (PARP-1)' , 'Cathepsin K'
                        'xref_src': 'TEXT',
                        # EXAMPLES:
                        # 'Wikipedia' , 'Wikipedia' , 'Wikipedia' , 'canSAR-Target' , 'Wikipedia' , 'Wikipedia' , 'Wikip
                        # edia' , 'Wikipedia' , 'Wikipedia' , 'MICAD'
                    }
                },
                'organism': 'TEXT',
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Escherichia coli K-12' , 'Homo sapiens' , 'Homo sa
                # piens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens'
                'pref_name': 'TEXT',
                # EXAMPLES:
                # 'Cyclophilin B' , 'Norepinephrine transporter' , 'Monoamine oxidase B' , 'Enoyl-[acyl-carrier-protein]
                #  reductase' , 'Inositol-1(or 4)-monophosphatase 1' , 'GABA transporter 1' , 'Somatostatin receptor 2' 
                # , 'Steroid 5-alpha-reductase 2' , 'Amiloride-sensitive sodium channel alpha-subunit' , 'Delta opioid r
                # eceptor'
                'species_group_flag': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2075' , 'CHEMBL222' , 'CHEMBL2039' , 'CHEMBL1857' , 'CHEMBL1786' , 'CHEMBL1903' , 'CHEMBL1804' 
                # , 'CHEMBL1856' , 'CHEMBL1791' , 'CHEMBL236'
                'target_components': 
                {
                    'properties': 
                    {
                        'accession': 'TEXT',
                        # EXAMPLES:
                        # 'P23284' , 'P23975' , 'P27338' , 'P0AEK4' , 'P29218' , 'P30531' , 'P30874' , 'P31213' , 'P3708
                        # 8' , 'P41143'
                        'component_description': 'TEXT',
                        # EXAMPLES:
                        # 'Peptidyl-prolyl cis-trans isomerase B' , 'Sodium-dependent noradrenaline transporter' , 'Amin
                        # e oxidase [flavin-containing] B' , 'Enoyl-[acyl-carrier-protein] reductase [NADH] FabI' , 'Ino
                        # sitol monophosphatase 1' , 'Sodium- and chloride-dependent GABA transporter 1' , 'Somatostatin
                        #  receptor type 2' , '3-oxo-5-alpha-steroid 4-dehydrogenase 2' , 'Amiloride-sensitive sodium ch
                        # annel subunit alpha' , 'Delta-type opioid receptor'
                        'component_id': 'NUMERIC',
                        # EXAMPLES:
                        # '435' , '436' , '377' , '165' , '77' , '218' , '98' , '164' , '82' , '242'
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
                # '9606' , '9606' , '9606' , '83333' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606'
            }
        }
    }

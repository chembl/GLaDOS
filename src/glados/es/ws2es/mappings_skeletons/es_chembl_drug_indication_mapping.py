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
                'drugind_id': 'NUMERIC',
                # EXAMPLES:
                # '25316' , '59296' , '56581' , '53006' , '48050' , '42824' , '25318' , '59297' , '56582' , '53007'
                'efo_id': 'TEXT',
                # EXAMPLES:
                # 'Orphanet:309005' , 'Orphanet:906' , 'EFO:0000305' , 'EFO:0002506' , 'EFO:0000673' , 'EFO:0000319' , '
                # EFO:0005529' , 'EFO:0000266' , 'EFO:0000616' , 'EFO:0002508'
                'efo_term': 'TEXT',
                # EXAMPLES:
                # 'Disorder of lipid metabolism' , 'Wiskott-Aldrich syndrome' , 'breast carcinoma' , 'osteoarthritis' , 
                # 'prostate adenocarcinoma' , 'cardiovascular disease' , 'Chagas cardiomyopathy' , 'aortic stenosis' , '
                # neoplasm' , 'Parkinson's disease'
                'indication_refs': 
                {
                    'properties': 
                    {
                        'ref_id': 'TEXT',
                        # EXAMPLES:
                        # 'NCT00169559,NCT00361868,NCT00504829,NCT00928694,NCT01539616,NCT01674712,NCT02066207,NCT022621
                        # 43,NCT02651753,NCT02890992,NCT03346187,NCT03510884' , 'NCT00885833' , 'NCT00928330,NCT00960960
                        # ,NCT01437566,NCT01740336,NCT02389842' , 'NCT01113333,NCT01463488,NCT01511549,NCT01598415' , 'N
                        # CT00110214,NCT00182052,NCT00183924,NCT00438464,NCT00450229,NCT00450749,NCT00459407,NCT00537381
                        # ,NCT00546039,NCT00638690,NCT00676650,NCT00744497,NCT00744549,NCT00844792,NCT01011751,NCT011268
                        # 79,NCT01200810,NCT01325311,NCT01433913,NCT01443026,NCT01519414,NCT01796028,NCT01821404,NCT0183
                        # 2259,NCT01857817,NCT01912820,NCT01946204,NCT01996696,NCT02064946,NCT02257736,NCT02311764,NCT02
                        # 326805,NCT02718378,NCT02799602,NCT02840162,NCT03248570,NCT03371719,NCT03767244,NCT03834493,NCT
                        # 03834506' , 'C04AE04' , 'NCT00349271,NCT02154269' , 'NCT00092677' , 'NCT00996892' , 'NCT029143
                        # 66,NCT02941822'
                        'ref_type': 'TEXT',
                        # EXAMPLES:
                        # 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' ,
                        #  'ATC' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials'
                        'ref_url': 'TEXT',
                        # EXAMPLES:
                        # 'https://clinicaltrials.gov/search?id=%22NCT00169559%22OR%22NCT00361868%22OR%22NCT00504829%22O
                        # R%22NCT00928694%22OR%22NCT01539616%22OR%22NCT01674712%22OR%22NCT02066207%22OR%22NCT02262143%22
                        # OR%22NCT02651753%22OR%22NCT02890992%22OR%22NCT03346187%22OR%22NCT03510884%22' , 'https://clini
                        # caltrials.gov/search?id=%22NCT00885833%22' , 'https://clinicaltrials.gov/search?id=%22NCT00928
                        # 330%22OR%22NCT00960960%22OR%22NCT01437566%22OR%22NCT01740336%22OR%22NCT02389842%22' , 'https:/
                        # /clinicaltrials.gov/search?id=%22NCT01113333%22OR%22NCT01463488%22OR%22NCT01511549%22OR%22NCT0
                        # 1598415%22' , 'https://clinicaltrials.gov/search?id=%22NCT00110214%22OR%22NCT00182052%22OR%22N
                        # CT00183924%22OR%22NCT00438464%22OR%22NCT00450229%22OR%22NCT00450749%22OR%22NCT00459407%22OR%22
                        # NCT00537381%22OR%22NCT00546039%22OR%22NCT00638690%22OR%22NCT00676650%22OR%22NCT00744497%22OR%2
                        # 2NCT00744549%22OR%22NCT00844792%22OR%22NCT01011751%22OR%22NCT01126879%22OR%22NCT01200810%22OR%
                        # 22NCT01325311%22OR%22NCT01433913%22OR%22NCT01443026%22OR%22NCT01519414%22OR%22NCT01796028%22OR
                        # %22NCT01821404%22OR%22NCT01832259%22OR%22NCT01857817%22OR%22NCT01912820%22OR%22NCT01946204%22O
                        # R%22NCT01996696%22OR%22NCT02064946%22OR%22NCT02257736%22OR%22NCT02311764%22OR%22NCT02326805%22
                        # OR%22NCT02718378%22OR%22NCT02799602%22OR%22NCT02840162%22OR%22NCT03248570%22OR%22NCT03371719%2
                        # 2OR%22NCT03767244%22OR%22NCT03834493%22OR%22NCT03834506%22' , 'http://www.whocc.no/atc_ddd_ind
                        # ex/?code=C04AE04' , 'https://clinicaltrials.gov/search?id=%22NCT00349271%22OR%22NCT02154269%22
                        # ' , 'https://clinicaltrials.gov/search?id=%22NCT00092677%22' , 'https://clinicaltrials.gov/sea
                        # rch?id=%22NCT00996892%22' , 'https://clinicaltrials.gov/search?id=%22NCT02914366%22OR%22NCT029
                        # 41822%22'
                    }
                },
                'max_phase_for_ind': 'NUMERIC',
                # EXAMPLES:
                # '3' , '1' , '2' , '2' , '3' , '0' , '3' , '3' , '1' , '2'
                'mesh_heading': 'TEXT',
                # EXAMPLES:
                # 'Lipid Metabolism Disorders' , 'Wiskott-Aldrich Syndrome' , 'Breast Neoplasms' , 'Osteoarthritis' , 'P
                # rostatic Neoplasms' , 'Cardiovascular Diseases' , 'Chagas Cardiomyopathy' , 'Aortic Valve Stenosis' , 
                # 'Neoplasms' , 'Parkinson Disease'
                'mesh_id': 'TEXT',
                # EXAMPLES:
                # 'D052439' , 'D014923' , 'D001943' , 'D010003' , 'D011471' , 'D002318' , 'D002598' , 'D001024' , 'D0093
                # 69' , 'D010300'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL672' , 'CHEMBL820' , 'CHEMBL521851' , 'CHEMBL3544945' , 'CHEMBL1351' , 'CHEMBL601773' , 'CHEMBL
                # 1201567' , 'CHEMBL1138' , 'CHEMBL521851' , 'CHEMBL153479'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL672' , 'CHEMBL820' , 'CHEMBL521851' , 'CHEMBL3544945' , 'CHEMBL1351' , 'CHEMBL601773' , 'CHEMBL
                # 1201567' , 'CHEMBL1138' , 'CHEMBL521851' , 'CHEMBL153479'
            }
        }
    }

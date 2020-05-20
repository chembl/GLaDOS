# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 1

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        'properties': 
        {
            '_metadata': 
            {
                'properties': 
                {
                    'all_molecule_chembl_ids': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL1201572' , 'CHEMBL1421' , 'CHEMBL1617' , 'CHEMBL1201187' , 'CHEMBL2105659' , 'CHEMBL1336' ,
                    #  'CHEMBL1200515' , 'CHEMBL1046' , 'CHEMBL1201823' , 'CHEMBL483254'
                }
            },
            'drugind_id': 'NUMERIC',
            # EXAMPLES:
            # '24420' , '22983' , '52145' , '23450' , '55936' , '55165' , '24310' , '52076' , '22606' , '50681'
            'efo_id': 'TEXT',
            # EXAMPLES:
            # 'EFO:0001359' , 'EFO:0005952' , 'EFO:0003932' , 'EFO:0000764' , 'EFO:0000378' , 'EFO:0000637' , 'EFO:00005
            # 37' , 'MP:0001845' , 'EFO:0000404' , 'EFO:0000339'
            'efo_term': 'TEXT',
            # EXAMPLES:
            # 'type I diabetes mellitus' , 'non-Hodgkins lymphoma' , 'bacterial vaginosis' , 'HIV infection' , 'coronary
            #  artery disease' , 'osteosarcoma' , 'hypertension' , 'inflammation' , 'diffuse scleroderma' , 'chronic mye
            # logenous leukemia'
            'indication_refs': 
            {
                'properties': 
                {
                    'ref_id': 'TEXT',
                    # EXAMPLES:
                    # 'NCT00434811,NCT00434850,NCT00468117,NCT00730392,NCT00784966,NCT00789308,NCT00888628,NCT02464033,N
                    # CT02464878,NCT02821026,NCT03182426' , 'NCT00550615,NCT01643603' , 'NCT02376972' , 'NCT00098306,NCT
                    # 00098722,NCT00098748,NCT00426660,NCT00496782,NCT00537394,NCT00624195,NCT00634959,NCT00643643,NCT00
                    # 703586,NCT00719823,NCT00771823,NCT00791700,NCT00808002,NCT00821535,NCT00827112,NCT00935480,NCT0094
                    # 4541,NCT00976404,NCT00982878,NCT00987948,NCT01056874,NCT01154673,NCT01242579,NCT01291459,NCT013487
                    # 63,NCT01363037,NCT01505114,NCT01597648,NCT01719627,NCT01749566,NCT01896921,NCT02302547,NCT02475915
                    # ,NCT02480894,NCT02741323,NCT02778204,NCT03708861' , 'NCT00455546,NCT00525954' , 'NCT00889057,NCT01
                    # 804374' , 'C02AA05' , 'NCT00223704' , 'NCT02161406' , 'NCT00449761,NCT00451035'
                    'ref_type': 'TEXT',
                    # EXAMPLES:
                    # 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'Cl
                    # inicalTrials' , 'ATC' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials'
                    'ref_url': 'TEXT',
                    # EXAMPLES:
                    # 'https://clinicaltrials.gov/search?id=%22NCT00434811%22OR%22NCT00434850%22OR%22NCT00468117%22OR%22
                    # NCT00730392%22OR%22NCT00784966%22OR%22NCT00789308%22OR%22NCT00888628%22OR%22NCT02464033%22OR%22NCT
                    # 02464878%22OR%22NCT02821026%22OR%22NCT03182426%22' , 'https://clinicaltrials.gov/search?id=%22NCT0
                    # 0550615%22OR%22NCT01643603%22' , 'https://clinicaltrials.gov/search?id=%22NCT02376972%22' , 'https
                    # ://clinicaltrials.gov/search?id=%22NCT00098306%22OR%22NCT00098722%22OR%22NCT00098748%22OR%22NCT004
                    # 26660%22OR%22NCT00496782%22OR%22NCT00537394%22OR%22NCT00624195%22OR%22NCT00634959%22OR%22NCT006436
                    # 43%22OR%22NCT00703586%22OR%22NCT00719823%22OR%22NCT00771823%22OR%22NCT00791700%22OR%22NCT00808002%
                    # 22OR%22NCT00821535%22OR%22NCT00827112%22OR%22NCT00935480%22OR%22NCT00944541%22OR%22NCT00976404%22O
                    # R%22NCT00982878%22OR%22NCT00987948%22OR%22NCT01056874%22OR%22NCT01154673%22OR%22NCT01242579%22OR%2
                    # 2NCT01291459%22OR%22NCT01348763%22OR%22NCT01363037%22OR%22NCT01505114%22OR%22NCT01597648%22OR%22NC
                    # T01719627%22OR%22NCT01749566%22OR%22NCT01896921%22OR%22NCT02302547%22OR%22NCT02475915%22OR%22NCT02
                    # 480894%22OR%22NCT02741323%22OR%22NCT02778204%22OR%22NCT03708861%22' , 'https://clinicaltrials.gov/
                    # search?id=%22NCT00455546%22OR%22NCT00525954%22' , 'https://clinicaltrials.gov/search?id=%22NCT0088
                    # 9057%22OR%22NCT01804374%22' , 'http://www.whocc.no/atc_ddd_index/?code=C02AA05' , 'https://clinica
                    # ltrials.gov/search?id=%22NCT00223704%22' , 'https://clinicaltrials.gov/search?id=%22NCT02161406%22
                    # ' , 'https://clinicaltrials.gov/search?id=%22NCT00449761%22OR%22NCT00451035%22'
                }
            },
            'max_phase_for_ind': 'NUMERIC',
            # EXAMPLES:
            # '3' , '1' , '2' , '4' , '2' , '2' , '4' , '2' , '2' , '2'
            'mesh_heading': 'TEXT',
            # EXAMPLES:
            # 'Diabetes Mellitus, Type 1' , 'Lymphoma, Non-Hodgkin' , 'Vaginosis, Bacterial' , 'HIV Infections' , 'Coron
            # ary Artery Disease' , 'Osteosarcoma' , 'Hypertension' , 'Inflammation' , 'Scleroderma, Diffuse' , 'Leukemi
            # a, Myelogenous, Chronic, BCR-ABL Positive'
            'mesh_id': 'TEXT',
            # EXAMPLES:
            # 'D003922' , 'D008228' , 'D016585' , 'D015658' , 'D003324' , 'D012516' , 'D006973' , 'D007249' , 'D045743' 
            # , 'D015464'
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1201572' , 'CHEMBL1421' , 'CHEMBL1617' , 'CHEMBL1201187' , 'CHEMBL2105659' , 'CHEMBL1336' , 'CHEMBL
            # 1200515' , 'CHEMBL1046' , 'CHEMBL1201823' , 'CHEMBL483254'
            'parent_molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1201572' , 'CHEMBL1421' , 'CHEMBL1617' , 'CHEMBL1201187' , 'CHEMBL2105659' , 'CHEMBL1336' , 'CHEMBL
            # 1200515' , 'CHEMBL1046' , 'CHEMBL1201823' , 'CHEMBL483254'
        }
    }

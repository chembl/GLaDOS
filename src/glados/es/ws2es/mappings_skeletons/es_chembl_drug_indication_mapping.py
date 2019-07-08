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
                # '50557' , '54675' , '45928' , '41621' , '57958' , '23733' , '50558' , '54676' , '45931' , '41622'
                'efo_id': 'TEXT',
                # EXAMPLES:
                # 'EFO:0002430' , 'EFO:0000770' , 'EFO:0003777' , 'EFO:0000612' , 'EFO:0005687' , 'EFO:0002506' , 'EFO:0
                # 001061' , 'EFO:0003778' , 'EFO:0000253' , 'EFO:0004149'
                'efo_term': 'TEXT',
                # EXAMPLES:
                # 'primary myelofibrosis' , 'malignant pleural mesothelioma' , 'heart disease' , 'myocardial infarction'
                #  , 'fibromyalgia' , 'osteoarthritis' , 'cervical carcinoma' , 'psoriatic arthritis' , 'amyotrophic lat
                # eral sclerosis' , 'neuropathy'
                'indication_refs': 
                {
                    'properties': 
                    {
                        'ref_id': 'TEXT',
                        # EXAMPLES:
                        # 'NCT02426086' , 'NCT02568449,NCT02863055' , 'NCT02250820,NCT02836431' , '0036ad62-e92a-42cb-b0
                        # ae-61bb87049ff2' , 'NCT03102723' , 'NCT00151489,NCT00151528,NCT00230776,NCT00282997,NCT0033386
                        # 6,NCT00346034,NCT00645398,NCT00696787,NCT00760474,NCT00830128,NCT00830167,NCT01271933,NCT01387
                        # 607,NCT01432236,NCT02146430,NCT02187159,NCT02187471,NCT02639533,NCT02868814' , 'NCT00312221,NC
                        # T00483977,NCT00743587,NCT00902837,NCT00985621' , 'NCT00348738' , 'NCT02376790' , 'dff598e8-e66
                        # 2-411f-978d-4ba3fb8ef7db'
                        'ref_type': 'TEXT',
                        # EXAMPLES:
                        # 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'DailyMed' , 'ClinicalTrials' , 'Clin
                        # icalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'DailyMed'
                        'ref_url': 'TEXT',
                        # EXAMPLES:
                        # 'https://clinicaltrials.gov/search?id=%22NCT02426086%22' , 'https://clinicaltrials.gov/search?
                        # id=%22NCT02568449%22OR%22NCT02863055%22' , 'https://clinicaltrials.gov/search?id=%22NCT0225082
                        # 0%22OR%22NCT02836431%22' , 'http://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=0036ad62-e
                        # 92a-42cb-b0ae-61bb87049ff2' , 'https://clinicaltrials.gov/search?id=%22NCT03102723%22' , 'http
                        # s://clinicaltrials.gov/search?id=%22NCT00151489%22OR%22NCT00151528%22OR%22NCT00230776%22OR%22N
                        # CT00282997%22OR%22NCT00333866%22OR%22NCT00346034%22OR%22NCT00645398%22OR%22NCT00696787%22OR%22
                        # NCT00760474%22OR%22NCT00830128%22OR%22NCT00830167%22OR%22NCT01271933%22OR%22NCT01387607%22OR%2
                        # 2NCT01432236%22OR%22NCT02146430%22OR%22NCT02187159%22OR%22NCT02187471%22OR%22NCT02639533%22OR%
                        # 22NCT02868814%22' , 'https://clinicaltrials.gov/search?id=%22NCT00312221%22OR%22NCT00483977%22
                        # OR%22NCT00743587%22OR%22NCT00902837%22OR%22NCT00985621%22' , 'https://clinicaltrials.gov/searc
                        # h?id=%22NCT00348738%22' , 'https://clinicaltrials.gov/search?id=%22NCT02376790%22' , 'http://d
                        # ailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=dff598e8-e662-411f-978d-4ba3fb8ef7db'
                    }
                },
                'max_phase_for_ind': 'NUMERIC',
                # EXAMPLES:
                # '2' , '3' , '1' , '4' , '2' , '4' , '3' , '3' , '4' , '4'
                'mesh_heading': 'TEXT',
                # EXAMPLES:
                # 'Primary Myelofibrosis' , 'Mesothelioma' , 'Heart Diseases' , 'Hyperpigmentation' , 'Myocardial Infarc
                # tion' , 'Fibromyalgia' , 'Osteoarthritis' , 'Uterine Cervical Neoplasms' , 'Arthritis, Psoriatic' , 'I
                # ridocyclitis'
                'mesh_id': 'TEXT',
                # EXAMPLES:
                # 'D055728' , 'D008654' , 'D006331' , 'D017495' , 'D009203' , 'D005356' , 'D010003' , 'D002583' , 'D0155
                # 35' , 'D015863'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2107856' , 'CHEMBL502835' , 'CHEMBL778' , 'CHEMBL537' , 'CHEMBL334966' , 'CHEMBL1059' , 'CHEMBL
                # 656' , 'CHEMBL2109092' , 'CHEMBL1201572' , 'CHEMBL1200637'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2107856' , 'CHEMBL502835' , 'CHEMBL778' , 'CHEMBL537' , 'CHEMBL334966' , 'CHEMBL1059' , 'CHEMBL
                # 656' , 'CHEMBL2109092' , 'CHEMBL1201572' , 'CHEMBL1201302'
            }
        }
    }

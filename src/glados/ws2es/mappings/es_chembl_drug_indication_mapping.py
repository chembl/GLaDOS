# Elastic search mapping definition for the Molecule entity
from glados.ws2es.es_util import DefaultMappings

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
                'drugind_id': DefaultMappings.ID,
                # EXAMPLES:
                # '40525' , '40527' , '40528' , '22607' , '22608' , '22609' , '22610' , '22612' , '22613' , '22614'
                'efo_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'HP:0001636' , 'HP:0001891' , 'HP:0002027' , 'EFO:0000685' , 'EFO:0002690' , 'EFO:0000612' , 'EFO:0001
                # 663' , 'EFO:0000400' , 'EFO:0000195' , 'EFO:0003095'
                'efo_term': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'TETRALOGY OF FALLOT' , 'IRON DEFICIENCY ANEMIA' , 'ABDOMINAL PAIN' , 'RHEUMATOID ARTHRITIS' , 'SYSTEM
                # IC LUPUS ERYTHEMATOSUS' , 'MYOCARDIAL INFARCTION' , 'PROSTATE CARCINOMA' , 'DIABETES MELLITUS' , 'META
                # BOLIC SYNDROME' , 'NON-ALCOHOLIC FATTY LIVER DISEASE'
                'indication_refs': 
                {
                    'properties': 
                    {
                        'ref_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # 'NCT01971593' , 'NCT02086838,NCT00593619,NCT01307007' , 'NCT01532518,NCT01258153,NCT01309009' 
                        # , 'setid=0836c6ac-ee37-5640-2fed-a3185a0b16eb' , 'NCT00430677,NCT00705367,NCT00119678,NCT02270
                        # 957' , 'NCT00638638,NCT00712101,NCT00986050,NCT01499407,NCT01080638,NCT00133250,NCT00383136,NC
                        # T00894023,NCT00354406,NCT01757457,NCT00426751' , 'setid=4e338e89-3cf2-48eb-b6e2-a06c608c6513' 
                        # , 'NCT01490918,NCT00417729,NCT01175486' , 'NCT00629213' , 'NCT00677521'
                        'ref_type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials' , 'DailyMed' , 'ClinicalTrials' , 'Clin
                        # icalTrials' , 'DailyMed' , 'ClinicalTrials' , 'ClinicalTrials' , 'ClinicalTrials'
                        'ref_url': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'https://clinicaltrials.gov/search?id=%22NCT01971593%22' , 'https://clinicaltrials.gov/search?
                        # id=%22NCT02086838%22OR%22NCT00593619%22OR%22NCT01307007%22' , 'https://clinicaltrials.gov/sear
                        # ch?id=%22NCT01532518%22OR%22NCT01258153%22OR%22NCT01309009%22' , 'http://dailymed.nlm.nih.gov/
                        # dailymed/drugInfo.cfm?setid=0836c6ac-ee37-5640-2fed-a3185a0b16eb' , 'https://clinicaltrials.go
                        # v/search?id=%22NCT00430677%22OR%22NCT00705367%22OR%22NCT00119678%22OR%22NCT02270957%22' , 'htt
                        # ps://clinicaltrials.gov/search?id=%22NCT00638638%22OR%22NCT00712101%22OR%22NCT00986050%22OR%22
                        # NCT01499407%22OR%22NCT01080638%22OR%22NCT00133250%22OR%22NCT00383136%22OR%22NCT00894023%22OR%2
                        # 2NCT00354406%22OR%22NCT01757457%22OR%22NCT00426751%22' , 'http://dailymed.nlm.nih.gov/dailymed
                        # /drugInfo.cfm?setid=4e338e89-3cf2-48eb-b6e2-a06c608c6513' , 'https://clinicaltrials.gov/search
                        # ?id=%22NCT01490918%22OR%22NCT00417729%22OR%22NCT01175486%22' , 'https://clinicaltrials.gov/sea
                        # rch?id=%22NCT00629213%22' , 'https://clinicaltrials.gov/search?id=%22NCT00677521%22'
                    }
                },
                'max_phase_for_ind': DefaultMappings.SHORT,
                # EXAMPLES:
                # '4' , '4' , '2' , '4' , '2' , '4' , '4' , '4' , '3' , '2'
                'mesh_heading': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'TETRALOGY OF FALLOT' , 'ANEMIA, IRON-DEFICIENCY' , 'ABDOMINAL PAIN' , 'ARTHRITIS, RHEUMATOID' , 'LUPU
                # S ERYTHEMATOSUS, SYSTEMIC' , 'MYOCARDIAL INFARCTION' , 'PROSTATIC NEOPLASMS' , 'DIABETES MELLITUS' , '
                # METABOLIC SYNDROME X' , 'NON-ALCOHOLIC FATTY LIVER DISEASE'
                'mesh_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'D013771' , 'D018798' , 'D015746' , 'D001172' , 'D008180' , 'D009203' , 'D011471' , 'D003920' , 'D0248
                # 21' , 'D065626'
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1095097' , 'CHEMBL1201544' , 'CHEMBL1908318' , 'CHEMBL1201823' , 'CHEMBL1201823' , 'CHEMBL12015
                # 84' , 'CHEMBL271227' , 'CHEMBL1566' , 'CHEMBL1566' , 'CHEMBL1566'
                'parent_molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1200550' , 'CHEMBL1201190' , 'CHEMBL1201759' , 'CHEMBL1564' , 'CHEMBL1633' , 'CHEMBL1200403' ,
                # 'CHEMBL1200406' , 'CHEMBL2103739' , 'CHEMBL1200959' , 'CHEMBL1201089'
            }
        }
    }

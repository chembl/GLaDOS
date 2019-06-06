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
                'drug_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL109' , 'CHEMBL109' , 'CHEMBL1201180' , 'CHEMBL1201180' , 'CHEMBL1201180' , 'CHEMBL1201180' , 'C
                # HEMBL1223' , 'CHEMBL1223' , 'CHEMBL1200651' , 'CHEMBL1200651'
                'enzyme_name': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'CYP2C9' , 'CYP3A4' , 'CYP2C9' , 'flavin-containing monooxygenases' , 'UGT1A4' , 'CYP1A2' , 'CYP3A5' ,
                #  'CYP3A4' , 'UGT1A9' , 'CYP3A4 '
                'met_comment': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Organ: Liver|Comment: Major metabolic pathway' , 'Organ: Liver mitochondria|Comment: Minor but signif
                # icant metabolic pathway' , 'Organ: Liver|Comment: The main metabolite of Diclofenac, it has weak pharm
                # acological activity; can undergo subsequent glucuronide and sulfonation conjugation' , 'Organ: Liver|C
                # omment: can undergo subsequent glucuronide and sulfonation conjugation' , 'Organ: Liver|Comment: can u
                # ndergo subsequent glucuronide and sulfonation conjugation' , 'Organ: Liver|Comment: can undergo subseq
                # uent glucuronide and sulfonation conjugation' , 'Organ: Liver and Kidneys|Comment: Inactive metabolite
                # ' , 'Organ: Liver and Kidneys|Comment: Inactive metabolite' , 'Organ: Liver and Kidneys|Comment: Inact
                # ive metabolite' , 'Organ: Liver and Kidneys|Comment: Inactive metabolite'
                'met_conversion': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Glucuronide conjugation' , 'Mitochondrial Beta-oxidation' , 'hydroxylation' , 'hydroxylation' , 'hydr
                # oxylation' , 'hydroxylation and methoxylation' , 'beta-lactam ring cleavage as via reaction with glyce
                # rone via nucleophilic attack of the carbonyl of the amide.' , 'Beta-lactam ring attack via nucleophili
                # c attack of the amide carbonyl by cysteine' , 'Decarboxylation' , 'Reduction of the ketone in the glyc
                # erone moiety'
                'met_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '1318' , '1319' , '1320' , '1321' , '1322' , '1323' , '1324' , '1325' , '1326' , '1327'
                'metabolism_refs': 
                {
                    'properties': 
                    {
                        'ref_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # 'label/2014/018723s041lbl.pdf' , 'label/2014/018723s041lbl.pdf' , 'label/2009/022202lbl.pdf' ,
                        #  'label/2009/022202lbl.pdf' , 'label/2009/022202lbl.pdf' , 'label/2009/022202lbl.pdf' , '21154
                        # 651' , '21154651' , '21154651' , '21154651'
                        'ref_type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'FDA' , 'FDA' , 'FDA' , 'FDA' , 'FDA' , 'FDA' , 'PMID' , 'PMID' , 'PMID' , 'PMID'
                        'ref_url': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'http://www.accessdata.fda.gov/drugsatfda_docs/label/2014/018723s041lbl.pdf' , 'http://www.acc
                        # essdata.fda.gov/drugsatfda_docs/label/2014/018723s041lbl.pdf' , 'http://www.accessdata.fda.gov
                        # /drugsatfda_docs/label/2009/022202lbl.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/la
                        # bel/2009/022202lbl.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/label/2009/022202lbl.
                        # pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/label/2009/022202lbl.pdf' , 'http://euro
                        # pepmc.org/abstract/MED/21154651' , 'http://europepmc.org/abstract/MED/21154651' , 'http://euro
                        # pepmc.org/abstract/MED/21154651' , 'http://europepmc.org/abstract/MED/21154651'
                    }
                },
                'metabolite_chembl_id': DefaultMappings.CHEMBL_ID,
                # EXAMPLES:
                # 'CHEMBL3544732' , 'CHEMBL3544736' , 'CHEMBL1030' , 'CHEMBL1035' , 'CHEMBL1032' , 'CHEMBL1033' , 'CHEMB
                # L3544681' , 'CHEMBL3544593' , 'CHEMBL3544680' , 'CHEMBL3544696'
                'metabolite_name': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'NORKETAMINE' , 'NORKETAMINE' , 'NORKETAMINE' , 'NORKETAMINE' , '5,6-DEHYDRONORKETAMINE' , '5,6-DEHYDR
                # ONORKETAMINE' , '6-HYDROXYKETAMINE' , '5,6-DEHYDROKETAMINE' , '5-HYDROXYKETAMINE' , '5,6-DEHYDROKETAMI
                # NE'
                'organism': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens'
                'pathway_id': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'pathway_key': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 
                # 'Fig. 2, p.19' , 'fig 6' , 'fig 6' , 'fig 9'
                'substrate_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL109' , 'CHEMBL109' , 'CHEMBL139' , 'CHEMBL139' , 'CHEMBL139' , 'CHEMBL139' , 'CHEMBL29' , 'CHEM
                # BL29' , 'CHEMBL1235368' , 'CHEMBL3544681'
                'substrate_name': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'KETAMINE' , 'KETAMINE' , 'KETAMINE' , 'KETAMINE' , '6-HYDROXYNORKETAMINE' , '5-HYDROXYNORKETAMINE' ,
                # 'KETAMINE' , '6-HYDROXYKETAMINE' , 'KETAMINE' , '5-HYDROXYKETAMINE'
                'target_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL612545' , 'CHEMBL612545' , 'CHEMBL3397' , 'CHEMBL340' , 'CHEMBL612545' , 'CHEMBL3397' , 'CHEMBL
                # 612545' , 'CHEMBL612545' , 'CHEMBL612545' , 'CHEMBL612545'
                'tax_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606'
            }
        }
    }

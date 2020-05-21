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
                    'all_graph_chembl_ids': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL3508152' , 'CHEMBL3544577' , 'CHEMBL3544570' , 'CHEMBL3508152' , 'CHEMBL3544577' , 'CHEMBL3
                    # 508152' , 'CHEMBL3544577' , 'CHEMBL3544577' , 'CHEMBL3507699' , 'CHEMBL3544577'
                    'compound_data': 
                    {
                        'properties': 
                        {
                            'drug_pref_name': 'TEXT',
                            # EXAMPLES:
                            # 'EPIRUBICIN' , 'ETHINYL ESTRADIOL' , 'FLOXURIDINE' , 'EPIRUBICIN' , 'ETHINYL ESTRADIOL' , 
                            # 'EPIRUBICIN' , 'ETHINYL ESTRADIOL' , 'ETHINYL ESTRADIOL' , 'ALISKIREN' , 'ETHINYL ESTRADIO
                            # L'
                            'metabolite_image_file': 'TEXT',
                            # EXAMPLES:
                            # 'smallMolecule.svg' , 'smallMolecule.svg' , 'smallMolecule.svg' , 'unknown.svg' , 'unknown
                            # .svg' , 'unknown.svg' , 'smallMolecule.svg' , 'smallMolecule.svg' , 'smallMolecule.svg' , 
                            # 'unknown.svg'
                            'metabolite_pref_name': 'TEXT',
                            # EXAMPLES:
                            # 'IOTYROSINE' , 'COTININE' , 'PHENETHYL ISOCYANATE' , '4-HYDROXYCYCLOPHOSPHAMIDE' , 'ACROLE
                            # IN' , 'NORNITROGEN MUSTARD' , 'SALICYLURIC ACID' , '1,2,4-TRIAZOLE' , '4-HYDROXYCYCLOPHOSP
                            # HAMIDE' , '4-HYDROXYCYCLOPHOSPHAMIDE'
                            'substrate_image_file': 'TEXT',
                            # EXAMPLES:
                            # 'smallMolecule.svg' , 'unknown.svg' , 'smallMolecule.svg' , 'smallMolecule.svg' , 'smallMo
                            # lecule.svg' , 'smallMolecule.svg' , 'smallMolecule.svg' , 'smallMolecule.svg' , 'smallMole
                            # cule.svg' , 'smallMolecule.svg'
                            'substrate_pref_name': 'TEXT',
                            # EXAMPLES:
                            # 'ETHINYL ESTRADIOL' , 'EPIRUBICIN' , 'ETHINYL ESTRADIOL' , 'ETHINYL ESTRADIOL' , 'ETHINYL 
                            # ESTRADIOL' , 'FAMOTIDINE' , 'TICLOPIDINE' , 'DIOTYROSINE' , 'ALISKIREN' , 'LIOTHYRONINE'
                        }
                    }
                }
            },
            'drug_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL417' , 'CHEMBL691' , 'CHEMBL917' , 'CHEMBL417' , 'CHEMBL691' , 'CHEMBL417' , 'CHEMBL691' , 'CHEMBL6
            # 91' , 'CHEMBL1639' , 'CHEMBL691'
            'enzyme_name': 'TEXT',
            # EXAMPLES:
            # 'CYP2C9' , 'Dihydropyrimidase' , 'CYP3A4' , 'CYP3A4' , 'UGT1A1' , 'CYP2B6' , 'Deiodinase' , 'CYP2D6' , 'CY
            # P2C9' , 'P35503'
            'met_comment': 'TEXT',
            # EXAMPLES:
            # 'Organ: Intestines|Comment: The predominant metabolite, the major pathway of metabolism, has a small amoun
            # t of estrogenic activity. Can undergo subsequent metabolism including conjugation with glucuronides and su
            # lfates' , 'Organ: Liver' , 'Organ: Intestines|Comment: Part of the major route of metabolism.' , 'Organ: I
            # ntestines|Comment: A minor metabolite, only a small contribution to the overall metabolism of the parent d
            # rug. Has a small amount of estrogenic activity. Can undergo conjugation with glucuronides and sulfates' , 
            # 'Organ: Intestines|Comment: A minor metabolite, only a small contribution to the overall metabolism of the
            #  parent drug. Has a small amount of estrogenic activity. Can undergo conjugation with glucuronides and sul
            # fates' , 'Species: Figure legend also mentions Rattus norvegicus.' , 'Organ: Intestines|Comment: Glucuroni
            # des are the main urinary conjugates. Inactive.' , 'Species: Figure legend also mentions Rattus norvegicus.
            # ' , 'Organ: Unknown|Comment: The only metabolite identified in man' , 'Organ: Liver'
            'met_conversion': 'TEXT',
            # EXAMPLES:
            # 'Hydroxylation at the 2 position' , 'Pyrimidine ring-opening' , 'Methylation of the hydroxyl at the 2 posi
            # tion' , 'Hydroxylation at the 6 alpha position' , 'Hydroxylation at the 16 beta position' , 'glucuronide c
            # onjugation at the 13 hydroxyl forming an ether' , 'C-oxidation' , 'Oxidation' , 'Oxidation' , 'Oxidation o
            # f the S atom in the aliphatic side chain'
            'met_id': 'NUMERIC',
            # EXAMPLES:
            # '119' , '953' , '1517' , '123' , '955' , '125' , '957' , '958' , '130' , '960'
            'metabolism_refs': 
            {
                'properties': 
                {
                    'ref_id': 'TEXT',
                    # EXAMPLES:
                    # 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'label/2010/
                    # 022501s000lbl.pdf' , 'c8edabc1-67cd-421b-a147-7c1f19f05b8e' , 'http://www.accessdata.fda.gov/drugs
                    # atfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , '0443051488' , 'http://www.accessdata.fda.gov/dr
                    # ugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , '0443051488' , '0443051488' , 'http://www.acc
                    # essdata.fda.gov/drugsatfda_docs/nda/2007/021985s000_PharmR_P2.pdf' , 'label/2010/022501s000lbl.pdf
                    # '
                    'ref_type': 'TEXT',
                    # EXAMPLES:
                    # 'OTHER' , 'FDA' , 'DAILYMED' , 'OTHER' , 'ISBN' , 'OTHER' , 'ISBN' , 'ISBN' , 'OTHER' , 'FDA'
                    'ref_url': 'TEXT',
                    # EXAMPLES:
                    # 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.
                    # accessdata.fda.gov/drugsatfda_docs/label/2010/022501s000lbl.pdf' , 'http://dailymed.nlm.nih.gov/da
                    # ilymed/lookup.cfm?setid=c8edabc1-67cd-421b-a147-7c1f19f05b8e' , 'http://www.accessdata.fda.gov/dru
                    # gsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.isbnsearch.org/isbn/0443051488' , 
                    # 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.
                    # isbnsearch.org/isbn/0443051488' , 'http://www.isbnsearch.org/isbn/0443051488' , 'http://www.access
                    # data.fda.gov/drugsatfda_docs/nda/2007/021985s000_PharmR_P2.pdf' , 'http://www.accessdata.fda.gov/d
                    # rugsatfda_docs/label/2010/022501s000lbl.pdf'
                }
            },
            'metabolite_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3508152' , 'CHEMBL3544698' , 'CHEMBL3544570' , 'CHEMBL3508141' , 'CHEMBL1627649' , 'CHEMBL3508143' 
            # , 'CHEMBL1627959' , 'CHEMBL3544578' , 'CHEMBL3507701' , 'CHEMBL3544597'
            'metabolite_name': 'TEXT',
            # EXAMPLES:
            # 'Doxorubicinol aglycone' , '2-HYDROXY ETHINYL ESTRADIOL' , 'ALPHA-FLUORO-BETA-UREIDEPROPIONIC ACID' , 'Epi
            # doxorubicinol, 4'-epiadriamycinol' , '2-METHOXY ETHINYL ESTRADIOL' , '7d-Aolon' , '6 ALPHA-HYDROXYL ETHINY
            # L ESTRADIOL' , '16 BETA-HYDROXYL ETHINYL ESTRADIOL' , 'Metabolite M4' , 'ETHINYL ESTRADIOL-3-O-GLUCURONIDE
            # '
            'organism': 'TEXT',
            # EXAMPLES:
            # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Mus musculus' , 'Mus musculus' , 'Callithrix jacchus' 
            # , 'Homo sapiens' , 'Mus musculus' , 'Homo sapiens' , 'Callithrix jacchus'
            'pathway_id': 'NUMERIC',
            # EXAMPLES:
            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            'pathway_key': 'TEXT',
            # EXAMPLES:
            # 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2.1.1.1, p.35' , 'Fig. 2.1.1.1, p.35' , 'Fig. 2.1
            # .4.1, p.46' , 'Fig. 9, p164/165' , 'Fig. 2.1.1.1, p.35' , 'Fig5' , 'Fig. 9, p164/165'
            'substrate_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3508141' , 'CHEMBL691' , 'CHEMBL219497' , 'CHEMBL417' , 'CHEMBL3544698' , 'CHEMBL3508141' , 'CHEMBL
            # 691' , 'CHEMBL691' , 'CHEMBL3507700' , 'CHEMBL691'
            'substrate_name': 'TEXT',
            # EXAMPLES:
            # 'Epidoxorubicinol, 4'-epiadriamycinol' , 'ETHINYL ESTRADIOL' , '5-FLUORO-5,6-DIHYDROURACIL' , 'Epirubicin'
            #  , '2-HYDROXY ETHINYL ESTRADIOL' , 'Epidoxorubicinol, 4'-epiadriamycinol' , 'ETHINYL ESTRADIOL' , 'ETHINYL
            #  ESTRADIOL' , 'Metabolite M3' , 'ETHINYL ESTRADIOL'
            'target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3397' , 'CHEMBL2465' , 'CHEMBL612545' , 'CHEMBL340' , 'CHEMBL340' , 'CHEMBL1287617' , 'CHEMBL612545
            # ' , 'CHEMBL612545' , 'CHEMBL4729' , 'CHEMBL3542431'
            'tax_id': 'NUMERIC',
            # EXAMPLES:
            # '9606' , '9606' , '9606' , '10090' , '10090' , '9483' , '9606' , '10090' , '9606' , '9483'
        }
    }

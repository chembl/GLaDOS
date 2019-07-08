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
                'drug_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL417' , 'CHE
                # MBL1639' , 'CHEMBL1639' , 'CHEMBL1639'
                'enzyme_name': 'TEXT',
                # EXAMPLES:
                # 'CYP3A' , 'CYP1A' , 'CYP3A4/3A5' , 'CYP3A4/3A5' , 'CYP3A4/3A5' , 'CYP3A4/3A5' , 'CYP3A4/3A5' , 'NNMT' 
                # , 'Cytochrome P450s' , 'AOX'
                'met_comment': 'TEXT',
                # EXAMPLES:
                # 'Species: Figure legend also mentions Rattus norvegicus.' , 'Species: Figure legend also mentions Ratt
                # us norvegicus.' , 'Species: Figure legend also mentions Rattus norvegicus.' , 'Species: Figure legend 
                # also mentions Rattus norvegicus.' , 'Species: Figure legend also mentions Rattus norvegicus.' , 'Speci
                # es: Figure legend also mentions Rattus norvegicus.' , 'Species: Figure legend also mentions Rattus nor
                # vegicus.' , 'Species: Figure legend also mentions Rattus norvegicus.' , 'Conditions:in-vitro' , 'Condi
                # tions:in-vitro'
                'met_conversion': 'TEXT',
                # EXAMPLES:
                # 'O-dealkylation' , 'O-demethylation of the methoxypropoxy side chain' , 'Oxidative dealkylation' , 'C-
                # oxidation' , 'Oxidation' , 'Oxidation' , 'Glucuronidation' , 'Glucuronidation' , 'O-glucuronidation' ,
                #  'Cyclization of the carboxylic acid intermediate'
                'met_id': 'NUMERIC',
                # EXAMPLES:
                # '119' , '120' , '121' , '122' , '123' , '124' , '125' , '127' , '128' , '129'
                'metabolism_refs': 
                {
                    'properties': 
                    {
                        'ref_id': 'TEXT',
                        # EXAMPLES:
                        # 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://
                        # www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.acce
                        # ssdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.f
                        # da.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/d
                        # rugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/drugsatfd
                        # a_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/n
                        # da/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/2007/
                        # 021985s000_ClinPharmR_P2.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/2007/021985
                        # s000_PharmR_P2.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_bio
                        # pharmr.pdf'
                        'ref_type': 'TEXT',
                        # EXAMPLES:
                        # 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTH
                        # ER'
                        'ref_url': 'TEXT',
                        # EXAMPLES:
                        # 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://
                        # www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.acce
                        # ssdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.f
                        # da.gov/drugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/d
                        # rugsatfda_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/drugsatfd
                        # a_docs/nda/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/n
                        # da/99/50-778_Ellence_biopharmr.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/2007/
                        # 021985s000_ClinPharmR_P2.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/2007/021985
                        # s000_PharmR_P2.pdf' , 'http://www.accessdata.fda.gov/drugsatfda_docs/nda/99/50-778_Ellence_bio
                        # pharmr.pdf'
                    }
                },
                'metabolite_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3508152' , 'CHEMBL3508144' , 'CHEMBL3508153' , 'CHEMBL3508145' , 'CHEMBL3508141' , 'CHEMBL35081
                # 42' , 'CHEMBL3508143' , 'CHEMBL3507701' , 'CHEMBL3507701' , 'CHEMBL3507701'
                'metabolite_name': 'TEXT',
                # EXAMPLES:
                # 'Doxorubicinol aglycone' , '7d-Aon' , 'Doxorubicin aglycone' , 'Epirubicin glucuronide' , 'Epidoxorubi
                # cinol, 4'-epiadriamycinol' , 'Epirubicinol glucuronide' , '7d-Aolon' , 'Metabolite M4' , 'Metabolite M
                # 4' , 'Metabolite M4'
                'organism': 'TEXT',
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 
                # 'Homo sapiens' , 'Homo sapiens' , 'Callithrix jacchus' , 'Homo sapiens'
                'pathway_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '3' , '2' , '1'
                'pathway_key': 'TEXT',
                # EXAMPLES:
                # 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 'Fig. 2, p.19' , 
                # 'Fig. 2, p.19' , 'Fig. 9, p164/165' , 'Fig. 2.1.4.1, p.46' , 'Fig. 2, p.19'
                'substrate_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3508141' , 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL417' , 'CHEMBL3508141' , 'CHEMBL350
                # 8141' , 'CHEMBL1639' , 'CHEMBL1639' , 'CHEMBL1639'
                'substrate_name': 'TEXT',
                # EXAMPLES:
                # 'Epidoxorubicinol, 4'-epiadriamycinol' , 'Epirubicin' , 'Epirubicin' , 'Epirubicin' , 'Epirubicin' , '
                # Epidoxorubicinol, 4'-epiadriamycinol' , 'Epidoxorubicinol, 4'-epiadriamycinol' , 'Aliskiren, SPP100' ,
                #  'Aliskiren, SPP100' , 'Aliskiren, SPP100'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2364675' , 'CHEMBL3544905' , 'CHEMBL2111472' , 'CHEMBL2111472' , 'CHEMBL2111472' , 'CHEMBL21114
                # 72' , 'CHEMBL2111472' , 'CHEMBL2346486' , 'CHEMBL612545' , 'CHEMBL3257'
                'tax_id': 'NUMERIC',
                # EXAMPLES:
                # '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9483' , '9606'
            }
        }
    }

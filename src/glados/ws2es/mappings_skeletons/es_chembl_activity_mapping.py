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
                'activity_comment': 'TEXT',
                # EXAMPLES:
                # 'Not Active' , 'Not Determined' , 'active at 100 mg/kg' , 'Not Determined' , 'Not Active' , 'Not Deter
                # mined' , 'no protection up to 100 mg/kg' , 'Not Active' , 'Not Active' , 'Not Active'
                'activity_id': 'NUMERIC',
                # EXAMPLES:
                # '113191' , '110281' , '93501' , '99205' , '116326' , '107960' , '113376' , '99206' , '93503' , '93504'
                'activity_properties': 
                {
                    'properties': 
                    {
                        'relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'result_flag': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'standard_relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_text_value': 'TEXT',
                        # EXAMPLES:
                        # 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'NEUTLE (Neutrophils/Leukocytes)' , 'APTT (Activate
                        # d Partial Thromboplastin Time)' , 'RBC (Erythrocytes)' , 'RETIRBC (Reticulocytes/Erythrocytes)
                        # ' , 'BASOLE (Basophils/Leukocytes)' , 'MONOLE (Monocytes/Leukocytes)' , 'LYMLE (Lymphocytes/Le
                        # ukocytes)' , 'APTT (Activated Partial Thromboplastin Time)' , 'RETIRBC (Reticulocytes/Erythroc
                        # ytes)'
                        'standard_type': 'TEXT',
                        # EXAMPLES:
                        # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACT
                        # IVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                        'standard_units': 'TEXT',
                        # EXAMPLES:
                        # 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' 
                        # , 'mg.kg-1' , 'mg.kg-1'
                        'standard_value': 'NUMERIC',
                        # EXAMPLES:
                        # '300' , '50' , '50' , '1000' , '100' , '0' , '0' , '0' , '0' , '100'
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'NEUTLE (Neutrophils/Leukocytes)' , 'APTT (Activate
                        # d Partial Thromboplastin Time)' , 'RBC (Erythrocytes)' , 'RETIRBC (Reticulocytes/Erythrocytes)
                        # ' , 'BASOLE (Basophils/Leukocytes)' , 'MONOLE (Monocytes/Leukocytes)' , 'LYMLE (Lymphocytes/Le
                        # ukocytes)' , 'APTT (Activated Partial Thromboplastin Time)' , 'RETIRBC (Reticulocytes/Erythroc
                        # ytes)'
                        'type': 'TEXT',
                        # EXAMPLES:
                        # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACT
                        # IVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                        'units': 'TEXT',
                        # EXAMPLES:
                        # 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/
                        # kg'
                        'value': 'NUMERIC',
                        # EXAMPLES:
                        # '300' , '50' , '50' , '1000' , '100' , '0' , '0' , '0' , '0' , '100'
                    }
                },
                'assay_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL636564' , 'CHEMBL649456' , 'CHEMBL694573' , 'CHEMBL852303' , 'CHEMBL725678' , 'CHEMBL718849' , 
                # 'CHEMBL727297' , 'CHEMBL649694' , 'CHEMBL698413' , 'CHEMBL692770'
                'assay_description': 'TEXT',
                # EXAMPLES:
                # 'Retention time at 30 mM' , 'In vitro minimum inhibitory concentration for Bacillus cereus ATCC 11778'
                #  , 'Agonistic activity tested against histamine H2 receptor on guinea pig atrium' , 'Selectivity expre
                # ssed as ratio between NE and 5-HT uptake inhibition in mouse brain slices' , 'Compound at an intraperi
                # toneal dose of 10 mg/Kg was tested for salivation in mice expressed as score; 2=Marked salivation or t
                # remor' , 'Inhibitory constant against matrix metalloprotease-1' , 'In vivo activity tested against C3H
                #  mice bearing mammary adenocarcinoma -16c/ADR tumor measured as % treated/control calculated at 582 mg
                # /kg (po)' , 'In vitro inhibitory activity towards partially purified calf lens aldose reductase; value
                #  ranges from 10E-6 - 10E-7' , 'In vitro antagonistic activity tested against Histamine H3 receptor on 
                # synaptosomes from rat cerebral cortex' , 'In vitro antagonistic activity tested against Histamine H3 r
                # eceptor on synaptosomes from rat cerebral cortex'
                'assay_type': 'TEXT',
                # EXAMPLES:
                # 'A' , 'F' , 'F' , 'F' , 'F' , 'B' , 'F' , 'B' , 'F' , 'F'
                'bao_endpoint': 'TEXT',
                # EXAMPLES:
                # 'BAO_0000179' , 'BAO_0002146' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000192' , 'BAO_0
                # 001103' , 'BAO_0000190' , 'BAO_0000192' , 'BAO_0000192'
                'bao_format': 'TEXT',
                # EXAMPLES:
                # 'BAO_0000019' , 'BAO_0000218' , 'BAO_0000221' , 'BAO_0000221' , 'BAO_0000218' , 'BAO_0000357' , 'BAO_0
                # 000218' , 'BAO_0000357' , 'BAO_0000220' , 'BAO_0000220'
                'bao_label': 'TEXT',
                # EXAMPLES:
                # 'assay format' , 'organism-based format' , 'tissue-based format' , 'tissue-based format' , 'organism-b
                # ased format' , 'single protein format' , 'organism-based format' , 'single protein format' , 'subcellu
                # lar format' , 'subcellular format'
                'canonical_smiles': 'TEXT',
                # EXAMPLES:
                # 'Cc1nc2cc(Cl)c(cc2[nH]1)c3nc(C)c([nH]3)c4cccnc4' , 'C[C@@H]1[C@H](CN1c2cc3N(C=C(C(=O)O)C(=O)c3cc2F)C4C
                # C4)N(C)C' , 'Ic1ccccc1C(=O)OCCCc2c[nH]cn2' , 'CNC\C=C(/c1ccc(Br)cc1)\c2cccnc2' , 'CCCSc1nsnc1OC2CN3CCC
                # 2C3' , 'Cc1ccc(CCC[C@H](CC(=O)NO)C(=O)N[C@@H](CC2CCCCC2)C(=O)NCCc3ccccc3)cc1' , 'COc1ccc2ncc(Oc3ccc(OC
                # (C)C(=O)O)cc3)nc2c1' , 'O=C1NC(=O)C2(CCOc3c(cccc23)c4ccccc4)N1' , 'Cc1ccc(cc1I)C(=O)OCCCc2c[nH]cn2' , 
                # 'Cc1ccc(cc1I)C(=O)OCCCc2c[nH]cn2'
                'data_validity_comment': 'TEXT',
                # EXAMPLES:
                # 'Outside typical range' , 'Outside typical range' , 'Potential missing data' , 'Potential missing data
                # ' , 'Potential missing data' , 'Non standard unit for type' , 'Outside typical range' , 'Outside typic
                # al range' , 'Non standard unit for type' , 'Non standard unit for type'
                'data_validity_description': 'TEXT',
                # EXAMPLES:
                # 'Values for this activity type are unusually large/small, so may not be accurate' , 'Values for this a
                # ctivity type are unusually large/small, so may not be accurate' , 'No data provided for value, units o
                # r activity_comment, needs further investigation' , 'No data provided for value, units or activity_comm
                # ent, needs further investigation' , 'No data provided for value, units or activity_comment, needs furt
                # her investigation' , 'Units for this activity type are unusual and may be incorrect (or the standard_t
                # ype may be incorrect)' , 'Values for this activity type are unusually large/small, so may not be accur
                # ate' , 'Values for this activity type are unusually large/small, so may not be accurate' , 'Units for 
                # this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 'Units 
                # for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1127309' , 'CHEMBL1127424' , 'CHEMBL1129520' , 'CHEMBL1124236' , 'CHEMBL1131461' , 'CHEMBL11347
                # 61' , 'CHEMBL1134487' , 'CHEMBL1124229' , 'CHEMBL1129520' , 'CHEMBL1129520'
                'document_journal': 'TEXT',
                # EXAMPLES:
                # 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Che
                # m.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.'
                'document_year': 'NUMERIC',
                # EXAMPLES:
                # '1994' , '1994' , '1996' , '1988' , '1998' , '2001' , '2001' , '1988' , '1996' , '1996'
                'ligand_efficiency': 
                {
                    'properties': 
                    {
                        'bei': 'NUMERIC',
                        # EXAMPLES:
                        # '11.57' , '20.39' , '15.5' , '27.71' , '15.47' , '25.75' , '12.44' , '13.04' , '15.83' , '12.3
                        # 2'
                        'le': 'NUMERIC',
                        # EXAMPLES:
                        # '0.22' , '0.37' , '0.29' , '0.56' , '0.28' , '0.47' , '0.24' , '0.25' , '0.3' , '0.23'
                        'lle': 'NUMERIC',
                        # EXAMPLES:
                        # '1.4' , '3.83' , '3.44' , '5.84' , '2.67' , '4.53' , '0.07' , '4.29' , '2.31' , '0.57'
                        'sei': 'NUMERIC',
                        # EXAMPLES:
                        # '5.61' , '8.9' , '7.52' , '10.38' , '9.2' , '36.8' , '11.08' , '8.36' , '7.46' , '7.51'
                    }
                },
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL140914' , 'CHEMBL334799' , 'CHEMBL20191' , 'CHEMBL173745' , 'CHEMBL126846' , 'CHEMBL312076' , '
                # CHEMBL50493' , 'CHEMBL420024' , 'CHEMBL20211' , 'CHEMBL20211'
                'molecule_pref_name': 'TEXT',
                # EXAMPLES:
                # 'NORZIMELIDINE' , 'Platinum complex' , 'FENTANYL' , 'FENTANYL' , 'CISPLATIN' , 'CISPLATIN' , 'CISPLATI
                # N' , 'CISPLATIN' , 'L-764004' , 'EZETIMIBE'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL140914' , 'CHEMBL334799' , 'CHEMBL20191' , 'CHEMBL173745' , 'CHEMBL126846' , 'CHEMBL312076' , '
                # CHEMBL50493' , 'CHEMBL420024' , 'CHEMBL20211' , 'CHEMBL20211'
                'pchembl_value': 'NUMERIC',
                # EXAMPLES:
                # '6.04' , '6' , '7.52' , '7.5' , '8.08' , '6.58' , '7.9' , '7' , '7.7' , '8.67'
                'potential_duplicate': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'qudt_units': 'TEXT',
                # EXAMPLES:
                # 'http://qudt.org/vocab/unit#MinuteTime' , 'http://www.openphacts.org/units/MicrogramPerMilliliter' , '
                # http://www.openphacts.org/units/Nanomolar' , 'http://qudt.org/vocab/unit#Percent' , 'http://www.openph
                # acts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/u
                # nits/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://qudt.org/vocab/unit#Percent' ,
                #  'http://www.openphacts.org/units/Nanomolar'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '272543' , '257165' , '26300' , '340885' , '243621' , '136431' , '83880' , '144058' , '26315' , '26315
                # '
                'relation': 'TEXT',
                # EXAMPLES:
                # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'standard_flag': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'True' , 'False' , 'False' , 'False' , 'True' , 'False' , 'True' , 'True' , 'True'
                'standard_relation': 'TEXT',
                # EXAMPLES:
                # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                'standard_text_value': 'TEXT',
                # EXAMPLES:
                # 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'Not Active' , 'Acti
                # ve' , 'Active' , 'Active'
                'standard_type': 'TEXT',
                # EXAMPLES:
                # 'Retention time' , 'MIC' , '-Log KB' , 'Ratio' , 'Score' , 'Ki' , 'T/C' , 'IC50' , 'Ki' , 'Ki'
                'standard_units': 'TEXT',
                # EXAMPLES:
                # 'min' , 'ug.mL-1' , 'nM' , '%' , 'nM' , 'nM' , 'nM' , 'nM' , '%' , 'nM'
                'standard_value': 'NUMERIC',
                # EXAMPLES:
                # '3.41' , '0.5' , '4.6' , '0.32' , '2' , '921' , '0' , '1000' , '30' , '31.62'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL612558' , 'CHEMBL613070' , 'CHEMBL2882' , 'CHEMBL612545' , 'CHEMBL375' , 'CHEMBL332' , 'CHEMBL3
                # 75' , 'CHEMBL3081' , 'CHEMBL4124' , 'CHEMBL4124'
                'target_organism': 'TEXT',
                # EXAMPLES:
                # 'Bacillus cereus' , 'Cavia porcellus' , 'Mus musculus' , 'Homo sapiens' , 'Mus musculus' , 'Bos taurus
                # ' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Homo sapiens' , 'Mus musculus'
                'target_pref_name': 'TEXT',
                # EXAMPLES:
                # 'ADMET' , 'Bacillus cereus' , 'Histamine H2 receptor' , 'Unchecked' , 'Mus musculus' , 'Matrix metallo
                # proteinase-1' , 'Mus musculus' , 'Aldose reductase' , 'Histamine H3 receptor' , 'Histamine H3 receptor
                # '
                'target_tax_id': 'NUMERIC',
                # EXAMPLES:
                # '1396' , '10141' , '10090' , '9606' , '10090' , '9913' , '10116' , '10116' , '9606' , '10090'
                'text_value': 'TEXT',
                # EXAMPLES:
                # 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'Not Active' , 'Acti
                # ve' , 'Active' , 'Active'
                'toid': 'NUMERIC',
                # EXAMPLES:
                # '5141' , '4817' , '4820' , '5146' , '4822' , '4974' , '4974' , '4974' , '4974' , '4823'
                'type': 'TEXT',
                # EXAMPLES:
                # 'Retention time' , 'MIC' , '-Log KB' , 'Ratio' , 'Score' , 'Ki' , 'T/C' , 'IC50' , 'Ki' , '-Log Ki'
                'units': 'TEXT',
                # EXAMPLES:
                # 'min' , 'ug ml-1' , 'nM' , '%' , 'M' , 'nM' , 'nM' , '%' , 'uM' , 'uM'
                'uo_units': 'TEXT',
                # EXAMPLES:
                # 'UO_0000031' , 'UO_0000274' , 'UO_0000065' , 'UO_0000187' , 'UO_0000065' , 'UO_0000065' , 'UO_0000065'
                #  , 'UO_0000065' , 'UO_0000187' , 'UO_0000065'
                'upper_value': 'NUMERIC',
                # EXAMPLES:
                # '17' , '25.9' , '18.87' , '1800' , '35' , '440' , '10.5' , '10.5' , '1.82' , '10.5'
                'value': 'NUMERIC',
                # EXAMPLES:
                # '3.41' , '0.5' , '4.6' , '0.32' , '2' , '921' , '0' , '0.000001' , '30' , '7.5'
            }
        }
    }

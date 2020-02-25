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
                'activity_comment': 'TEXT',
                # EXAMPLES:
                # 'less potent' , 'Not Determined' , 'Not Determined' , 'Partially active' , 'Not Active' , 'Not signifi
                # cant' , 'Not significant' , 'Not Active' , 'Not Active' , 'Active'
                'activity_id': 'NUMERIC',
                # EXAMPLES:
                # '38667' , '47821' , '41769' , '59926' , '59927' , '53669' , '47823' , '44920' , '35731' , '32674'
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
                        # 'WBC (Leukocytes)' , 'EOSLE (Eosinophils/Leukocytes)' , 'HCT (Hematocrit)' , 'WBC (Leukocytes)
                        # ' , 'NEUTLE (Neutrophils/Leukocytes)' , 'MONOLE (Monocytes/Leukocytes)' , 'APTT (Activated Par
                        # tial Thromboplastin Time)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'MCHC (Ery. Mean Corpu
                        # scular HGB Concentration)' , 'MCV (Ery. Mean Corpuscular Volume)'
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
                        # '60.0' , '60.0' , '600.0' , '600.0' , '600.0' , '600.0' , '600.0' , '600.0' , '600.0' , '200.0
                        # '
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'WBC (Leukocytes)' , 'EOSLE (Eosinophils/Leukocytes)' , 'HCT (Hematocrit)' , 'WBC (Leukocytes)
                        # ' , 'NEUTLE (Neutrophils/Leukocytes)' , 'MONOLE (Monocytes/Leukocytes)' , 'APTT (Activated Par
                        # tial Thromboplastin Time)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'MCHC (Ery. Mean Corpu
                        # scular HGB Concentration)' , 'MCV (Ery. Mean Corpuscular Volume)'
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
                        # '60.0' , '60.0' , '600.0' , '600.0' , '600.0' , '600.0' , '600.0' , '600.0' , '600.0' , '200.0
                        # '
                    }
                },
                'assay_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL772292' , 'CHEMBL699059' , 'CHEMBL710767' , 'CHEMBL807560' , 'CHEMBL804398' , 'CHEMBL760811' , 
                # 'CHEMBL671073' , 'CHEMBL722545' , 'CHEMBL638243' , 'CHEMBL729973'
                'assay_description': 'TEXT',
                # EXAMPLES:
                # 'Tested ex vivo for ocular tissue concentration against cornea after 2 hour of treatment with 50 uL' ,
                #  'Concentration required to inhibit the growth of HeLa S3 cells after 72 hours.' , 'Compound was teste
                # d for analgesic activity in mice after intraperitoneal administration at a dose of 10 ug/kg; less pote
                # nt' , 'In vitro antibacterial activity of compound against Staphylococcus aureus Tour L 165' , 'In vit
                # ro antibacterial activity of compound against Staphylococcus epidermidis ATCC 12228' , 'Agonistic acti
                # vity against human progesterone receptor in T47D breast cancer cells' , 'Binding affinity to cloned hu
                # man Dopamine receptor D2 expressed in A9L cells by [3H]spiperone displacement.' , 'Suppressive antimal
                # arial activity against Plasmodium berghei in Rane mice (Mus musculus) when administered at 40 mg/kg pe
                # rorally; 2 cured' , 'The compound was evaluated for the optical density at concentrations 10E-7 M in M
                # CF-7 cell culture in the presence of estradiol.' , 'Agonistic efficacy against human Mineralocorticoid
                #  receptor'
                'assay_type': 'TEXT',
                # EXAMPLES:
                # 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'B' , 'F' , 'A' , 'F'
                'bao_endpoint': 'TEXT',
                # EXAMPLES:
                # 'BAO_0002752' , 'BAO_0000190' , 'BAO_0000375' , 'BAO_0002146' , 'BAO_0002146' , 'BAO_0000188' , 'BAO_0
                # 000190' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000656'
                'bao_format': 'TEXT',
                # EXAMPLES:
                # 'BAO_0000218' , 'BAO_0000219' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000219' , 'BAO_0
                # 000219' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000019'
                'bao_label': 'TEXT',
                # EXAMPLES:
                # 'organism-based format' , 'cell-based format' , 'organism-based format' , 'organism-based format' , 'o
                # rganism-based format' , 'cell-based format' , 'cell-based format' , 'organism-based format' , 'organis
                # m-based format' , 'assay format'
                'canonical_smiles': 'TEXT',
                # EXAMPLES:
                # 'NC(=O)CC(/N=C(\S)Nc1ccc(S(N)(=O)=O)cc1)C(=O)O' , 'COC(=O)c1c(C)[nH]c2c1[C@@]13C[C@@H]1CN(C(=O)c1cc4cc
                # (OC)c(OC)c(OC)c4[nH]1)C3=CC2=O' , 'Clc1ccc(C2CCNC2)cn1' , 'CO[C@H]1/C=C/O[C@@]2(C)Oc3c(C)c(O)c4c(O)c(c
                # (/C=N/N5CCN(C)CC5)c(O)c4c3C2=O)NC(=O)/C(C)=C\C=C\[C@H](C)[C@H](O)[C@@H](C)[C@@H](O)[C@@H](C)[C@H](OC(C
                # )=O)[C@@H]1C' , 'CO[C@H]1/C=C/O[C@@]2(C)Oc3c(C)c(O)c4c(O)c(c(/C=N/N5CCN(C)CC5)c(O)c4c3C2=O)NC(=O)/C(C)
                # =C\C=C\[C@H](C)[C@H](O)[C@@H](C)[C@@H](O)[C@@H](C)[C@H](OC(C)=O)[C@@H]1C' , 'CC1=CC(C)(C)Nc2ccc3c(c21)
                # /C(=C/c1ccncc1C)Oc1ccc(F)cc1-3' , 'Fc1ccc(-c2cccc(CN3CCN(c4ncccn4)CC3)c2)cc1' , 'CCCCCCOc1c(OC)cc(NC(C
                # )CCCN)c2nc(OC)cc(C)c12' , 'CN(C)CCOc1ccc(C2=C(c3ccccc3)CCCc3ccccc32)cc1' , 'CC1=CC(C)(C)Nc2ccc3c(c21)/
                # C(=C/c1ccsc1)Oc1ccc(F)cc1-3'
                'data_validity_comment': 'TEXT',
                # EXAMPLES:
                # 'Outside typical range' , 'Potential missing data' , 'Non standard unit for type' , 'Outside typical r
                # ange' , 'Outside typical range' , 'Outside typical range' , 'Outside typical range' , 'Non standard un
                # it for type' , 'Outside typical range' , 'Outside typical range'
                'data_validity_description': 'TEXT',
                # EXAMPLES:
                # 'Values for this activity type are unusually large/small, so may not be accurate' , 'No data provided 
                # for value, units or activity_comment, needs further investigation' , 'Units for this activity type are
                #  unusual and may be incorrect (or the standard_type may be incorrect)' , 'Values for this activity typ
                # e are unusually large/small, so may not be accurate' , 'Values for this activity type are unusually la
                # rge/small, so may not be accurate' , 'Values for this activity type are unusually large/small, so may 
                # not be accurate' , 'Values for this activity type are unusually large/small, so may not be accurate' ,
                #  'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect
                # )' , 'Values for this activity type are unusually large/small, so may not be accurate' , 'Values for t
                # his activity type are unusually large/small, so may not be accurate'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1133556' , 'CHEMBL1129161' , 'CHEMBL1128964' , 'CHEMBL1124774' , 'CHEMBL1124774' , 'CHEMBL11450
                # 87' , 'CHEMBL1130912' , 'CHEMBL1124633' , 'CHEMBL1123514' , 'CHEMBL1145087'
                'document_journal': 'TEXT',
                # EXAMPLES:
                # 'J. Med. Chem.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'J. Med. Chem.' , 'J. Med.
                #  Chem.' , 'J. Med. Chem.' , 'Bioorg. Med. Chem. Lett.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. 
                # Chem.'
                'document_year': 'NUMERIC',
                # EXAMPLES:
                # '2000' , '1996' , '1996' , '1990' , '1990' , '2003' , '1998' , '1989' , '1986' , '2003'
                'ligand_efficiency': 
                {
                    'properties': 
                    {
                        'bei': 'NUMERIC',
                        # EXAMPLES:
                        # '20.98' , '19.94' , '6.88' , '16.16' , '21.87' , '12.99' , '19.41' , '17.43' , '13.34' , '13.9
                        # 4'
                        'le': 'NUMERIC',
                        # EXAMPLES:
                        # '0.38' , '0.41' , '0.13' , '0.29' , '0.41' , '0.25' , '0.37' , '0.38' , '0.26' , '0.27'
                        'lle': 'NUMERIC',
                        # EXAMPLES:
                        # '3.71' , '6.46' , '-2.41' , '-0.25' , '4.69' , '3.19' , '4.12' , '3.58' , '2.53' , '2.65'
                        'sei': 'NUMERIC',
                        # EXAMPLES:
                        # '22.66' , '5.55' , '3.85' , '18.86' , '17.19' , '4.50' , '15.88' , '7.49' , '7.02' , '7.51'
                    }
                },
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL144006' , 'CHEMBL35670' , 'CHEMBL94774' , 'CHEMBL374478' , 'CHEMBL374478' , 'CHEMBL130141' , 'C
                # HEMBL59942' , 'CHEMBL48245' , 'CHEMBL23063' , 'CHEMBL134277'
                'molecule_pref_name': 'TEXT',
                # EXAMPLES:
                # 'RIFAMPIN' , 'RIFAMPIN' , 'RIFAMPIN' , 'BUTYLATED HYDROXYTOLUENE' , 'RIFAMPIN' , 'RIFAMPIN' , 'RIFAMPI
                # N' , 'RIFAMPIN' , 'SURAMIN' , 'SURAMIN'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL144006' , 'CHEMBL35670' , 'CHEMBL94774' , 'CHEMBL374478' , 'CHEMBL374478' , 'CHEMBL130141' , 'C
                # HEMBL59942' , 'CHEMBL48245' , 'CHEMBL23063' , 'CHEMBL134277'
                'pchembl_value': 'NUMERIC',
                # EXAMPLES:
                # '8.34' , '7.31' , '7.89' , '4.28' , '4.60' , '4.19' , '6.44' , '9.70' , '6.41' , '8.96'
                'potential_duplicate': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'qudt_units': 'TEXT',
                # EXAMPLES:
                # 'http://www.openphacts.org/units/Micromolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://w
                # ww.openphacts.org/units/MicrogramPerMilliliter' , 'http://www.openphacts.org/units/MicrogramPerMillili
                # ter' , 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'ht
                # tp://qudt.org/vocab/unit#Percent' , 'http://qudt.org/vocab/unit#Percent' , 'http://www.openphacts.org/
                # units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '282510' , '119153' , '176513' , '54507' , '54507' , '253304' , '108671' , '80038' , '110442' , '25329
                # 0'
                'relation': 'TEXT',
                # EXAMPLES:
                # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'standard_flag': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'True' , 'False' , 'True' , 'True' , 'True' , 'True' , 'False' , 'False' , 'False'
                'standard_relation': 'TEXT',
                # EXAMPLES:
                # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                'standard_text_value': 'TEXT',
                # EXAMPLES:
                # 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'Not Active' , 'Acti
                # ve' , 'Active' , 'Active'
                'standard_type': 'TEXT',
                # EXAMPLES:
                # 'Concentration' , 'IC50' , 'Activity' , 'MIC' , 'MIC' , 'EC50' , 'IC50' , 'MST' , 'Optical density' , 
                # 'Efficacy'
                'standard_units': 'TEXT',
                # EXAMPLES:
                # 'uM' , 'nM' , 'ug.mL-1' , 'ug.mL-1' , 'nM' , 'nM' , '%' , '%' , 'nM' , 'nM'
                'standard_value': 'NUMERIC',
                # EXAMPLES:
                # '54.0' , '0.0052' , '0.016' , '0.008' , '4.6' , '49.0' , '0.379' , '63.0' , '1.0' , '13.0'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL374' , 'CHEMBL399' , 'CHEMBL375' , 'CHEMBL352' , 'CHEMBL353' , 'CHEMBL208' , 'CHEMBL217' , 'CHE
                # MBL375' , 'CHEMBL372' , 'CHEMBL1994'
                'target_organism': 'TEXT',
                # EXAMPLES:
                # 'Oryctolagus cuniculus' , 'Homo sapiens' , 'Mus musculus' , 'Staphylococcus aureus' , 'Staphylococcus 
                # epidermidis' , 'Homo sapiens' , 'Homo sapiens' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens'
                'target_pref_name': 'TEXT',
                # EXAMPLES:
                # 'Oryctolagus cuniculus' , 'HeLa' , 'Mus musculus' , 'Staphylococcus aureus' , 'Staphylococcus epidermi
                # dis' , 'Progesterone receptor' , 'Dopamine D2 receptor' , 'Mus musculus' , 'Homo sapiens' , 'Mineraloc
                # orticoid receptor'
                'target_tax_id': 'NUMERIC',
                # EXAMPLES:
                # '9986' , '9606' , '10090' , '1280' , '1282' , '9606' , '9606' , '10090' , '9606' , '9606'
                'text_value': 'TEXT',
                # EXAMPLES:
                # 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'Not Active' , 'Acti
                # ve' , 'Active' , 'Active'
                'toid': 'NUMERIC',
                # EXAMPLES:
                # '4967' , '4967' , '4807' , '4807' , '4807' , '4807' , '4807' , '4808' , '4808' , '4969'
                'type': 'TEXT',
                # EXAMPLES:
                # 'Concentration' , 'IC50' , 'Activity' , 'MIC' , 'MIC' , 'EC50' , 'IC50' , 'MST' , 'Optical density' , 
                # 'Efficacy'
                'units': 'TEXT',
                # EXAMPLES:
                # 'uM' , 'nM' , 'ug ml-1' , 'ug ml-1' , 'nM' , 'nM' , 'day' , '%' , '%' , 'nM'
                'uo_units': 'TEXT',
                # EXAMPLES:
                # 'UO_0000064' , 'UO_0000065' , 'UO_0000274' , 'UO_0000274' , 'UO_0000065' , 'UO_0000065' , 'UO_0000187'
                #  , 'UO_0000187' , 'UO_0000065' , 'UO_0000065'
                'upper_value': 'NUMERIC',
                # EXAMPLES:
                # '1.0' , '100.0' , '100.0' , '40.0' , '5.0' , '5.0' , '300.0' , '0.5' , '1.0' , '6000.0'
                'value': 'NUMERIC',
                # EXAMPLES:
                # '54.0' , '0.0052' , '0.016' , '0.008' , '4.6' , '49.0' , '0.379' , '63.0' , '1.0' , '13.0'
            }
        }
    }

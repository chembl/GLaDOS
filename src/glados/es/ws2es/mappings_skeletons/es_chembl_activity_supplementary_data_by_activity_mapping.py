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
            'activity_comment': 'TEXT',
            # EXAMPLES:
            # 'See Activity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Act
            # ivity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Activity_Su
            # pp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Activity_Supp For I
            # ndividual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Activity_Supp For Individua
            # l Animal Data' , 'See Activity_Supp For Individual Animal Data'
            'activity_id': 'NUMERIC',
            # EXAMPLES:
            # '17186320' , '17186417' , '17201253' , '17195263' , '17189366' , '17198362' , '17186240' , '17195363' , '1
            # 7195318' , '17186243'
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
                    # 'WBC (Leukocytes)' , 'MCV (Ery. Mean Corpuscular Volume)' , 'APTT (Activated Partial Thromboplasti
                    # n Time)' , 'NEUTLE (Neutrophils/Leukocytes)' , 'BASOLE (Basophils/Leukocytes)' , 'PT (Prothrombin 
                    # Time)' , 'LYMLE (Lymphocytes/Leukocytes)' , 'PLAT (Platelets)' , 'LYMLE (Lymphocytes/Leukocytes)' 
                    # , 'FIBRINO (Fibrinogen)'
                    'standard_type': 'TEXT',
                    # EXAMPLES:
                    # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVIT
                    # Y_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                    'standard_units': 'TEXT',
                    # EXAMPLES:
                    # 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'm
                    # g.kg-1' , 'mg.kg-1'
                    'standard_value': 'NUMERIC',
                    # EXAMPLES:
                    # '100.0' , '300.0' , '100.0' , '0.0' , '1.0' , '2000.0' , '1000.0' , '40.0' , '12.0' , '1000.0'
                    'text_value': 'TEXT',
                    # EXAMPLES:
                    # 'WBC (Leukocytes)' , 'MCV (Ery. Mean Corpuscular Volume)' , 'APTT (Activated Partial Thromboplasti
                    # n Time)' , 'NEUTLE (Neutrophils/Leukocytes)' , 'BASOLE (Basophils/Leukocytes)' , 'PT (Prothrombin 
                    # Time)' , 'LYMLE (Lymphocytes/Leukocytes)' , 'PLAT (Platelets)' , 'LYMLE (Lymphocytes/Leukocytes)' 
                    # , 'FIBRINO (Fibrinogen)'
                    'type': 'TEXT',
                    # EXAMPLES:
                    # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVIT
                    # Y_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                    'units': 'TEXT',
                    # EXAMPLES:
                    # 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg'
                    'value': 'NUMERIC',
                    # EXAMPLES:
                    # '100.0' , '300.0' , '100.0' , '0.0' , '1.0' , '2000.0' , '1000.0' , '40.0' , '12.0' , '1000.0'
                }
            },
            'assay_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3885863' , 'CHEMBL3885863' , 'CHEMBL3885862' , 'CHEMBL3885863' , 'CHEMBL3885863' , 'CHEMBL3885863' 
            # , 'CHEMBL3885862' , 'CHEMBL3885863' , 'CHEMBL3885863' , 'CHEMBL3885862'
            'assay_description': 'TEXT',
            # EXAMPLES:
            # 'Open TG-GATES - Regimen: Single' , 'Open TG-GATES - Regimen: Single' , 'Open TG-GATES - Regimen: Daily Re
            # peat' , 'Open TG-GATES - Regimen: Single' , 'Open TG-GATES - Regimen: Single' , 'Open TG-GATES - Regimen: 
            # Single' , 'Open TG-GATES - Regimen: Daily Repeat' , 'Open TG-GATES - Regimen: Single' , 'Open TG-GATES - R
            # egimen: Single' , 'Open TG-GATES - Regimen: Daily Repeat'
            'assay_type': 'TEXT',
            # EXAMPLES:
            # 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T'
            'bao_endpoint': 'TEXT',
            # EXAMPLES:
            # 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_00001
            # 79' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179'
            'bao_format': 'TEXT',
            # EXAMPLES:
            # 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_00002
            # 18' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218'
            'bao_label': 'TEXT',
            # EXAMPLES:
            # 'organism-based format' , 'organism-based format' , 'organism-based format' , 'organism-based format' , 'o
            # rganism-based format' , 'organism-based format' , 'organism-based format' , 'organism-based format' , 'org
            # anism-based format' , 'organism-based format'
            'canonical_smiles': 'TEXT',
            # EXAMPLES:
            # 'O=C(O)COc1nn(Cc2ccccc2)c2ccccc12' , 'O=C(O)COc1nn(Cc2ccccc2)c2ccccc12' , 'CN(CCOc1ccc(CC2SC(=O)NC2=O)cc1)
            # c1ccccn1.O=C(O)/C=C\C(=O)O' , 'CN(C)c1ncnc2c1ncn2[C@@H]1O[C@H](CO)[C@@H](N)[C@H]1O' , 'NNC(=O)c1ccncc1' , 
            # 'C#C[C@]1(O)CC[C@H]2[C@@H]3CCC4=Cc5oncc5C[C@]4(C)[C@H]3CC[C@@]21C' , 'CN(C)c1ncnc2c1ncn2[C@@H]1O[C@H](CO)[
            # C@@H](N)[C@H]1O' , 'CN(C)c1ncnc2c1ncn2[C@@H]1O[C@H](CO)[C@@H](N)[C@H]1O' , 'C#C[C@]1(O)CC[C@H]2[C@@H]3CCC4
            # =Cc5oncc5C[C@]4(C)[C@H]3CC[C@@]21C' , 'O=C(O)COc1nn(Cc2ccccc2)c2ccccc12'
            'data_validity_comment': 'TEXT',
            # EXAMPLES:
            # 'Non standard unit for type' , 'Non standard unit for type' , 'Non standard unit for type' , 'Non standard
            #  unit for type' , 'Non standard unit for type' , 'Non standard unit for type' , 'Non standard unit for typ
            # e' , 'Non standard unit for type' , 'Non standard unit for type' , 'Non standard unit for type'
            'data_validity_description': 'TEXT',
            # EXAMPLES:
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)'
            'document_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' 
            # , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861'
            'ligand_efficiency': 
            {
                'properties': 
                {
                }
            },
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1089221' , 'CHEMBL1089221' , 'CHEMBL843' , 'CHEMBL1233071' , 'CHEMBL11359' , 'CHEMBL64' , 'CHEMBL14
            # 79' , 'CHEMBL1233071' , 'CHEMBL1233071' , 'CHEMBL1479'
            'molecule_pref_name': 'TEXT',
            # EXAMPLES:
            # 'BENDAZAC' , 'BENDAZAC' , 'ROSIGLITAZONE MALEATE' , 'PUROMYCIN AMINONUCLEOSIDE' , 'CISPLATIN' , 'ISONIAZID
            # ' , 'DANAZOL' , 'PUROMYCIN AMINONUCLEOSIDE' , 'PUROMYCIN AMINONUCLEOSIDE' , 'DANAZOL'
            'parent_molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1089221' , 'CHEMBL1089221' , 'CHEMBL121' , 'CHEMBL1233071' , 'CHEMBL2068237' , 'CHEMBL64' , 'CHEMBL
            # 1479' , 'CHEMBL1233071' , 'CHEMBL1233071' , 'CHEMBL1479'
            'potential_duplicate': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'qudt_units': 'TEXT',
            # EXAMPLES:
            # 'http://qudt.org/vocab/unit#SecondTime' , 'http://qudt.org/vocab/unit#Percent' , 'http://qudt.org/vocab/un
            # it#Percent' , 'http://qudt.org/vocab/unit#SecondTime' , 'http://qudt.org/vocab/unit#Percent' , 'http://qud
            # t.org/vocab/unit#Percent' , 'http://www.openphacts.org/units/MicrogramPerMilliliter' , 'http://qudt.org/vo
            # cab/unit#Percent' , 'http://qudt.org/vocab/unit#SecondTime' , 'http://qudt.org/vocab/unit#Percent'
            'record_id': 'NUMERIC',
            # EXAMPLES:
            # '2834472' , '2834472' , '2834585' , '2834581' , '2834495' , '2834542' , '2834503' , '2834581' , '2834581' 
            # , '2834503'
            'relation': 'TEXT',
            # EXAMPLES:
            # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
            'src_id': 'NUMERIC',
            # EXAMPLES:
            # '11' , '11' , '11' , '11' , '11' , '11' , '11' , '11' , '11' , '11'
            'standard_flag': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
            'standard_relation': 'TEXT',
            # EXAMPLES:
            # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
            'standard_type': 'TEXT',
            # EXAMPLES:
            # 'WBC' , 'MCV' , 'APTT' , 'NEUTLE' , 'BASOLE' , 'PT' , 'LYMLE' , 'PLAT' , 'LYMLE' , 'FIBRINO'
            'standard_units': 'TEXT',
            # EXAMPLES:
            # 'cells.uL-1' , 'fL' , 's' , '%' , '%' , 's' , '%' , 'cells.uL-1' , '%' , 'ug.mL-1'
            'standard_value': 'NUMERIC',
            # EXAMPLES:
            # '11180.0' , '66.8' , '16.1' , '17.0' , '0.0' , '14.4' , '79.4' , '1345000.0' , '75.0' , '3206.0'
            'supplementary_data': 
            {
                'properties': 
                {
                    'as_id': 'NUMERIC',
                    # EXAMPLES:
                    # '310356' , '310861' , '384273' , '354554' , '325418' , '369876' , '309919' , '355062' , '354830' ,
                    #  '309905'
                    'comments': 'TEXT',
                    # EXAMPLES:
                    # 'SAMPLE_ID: 0550055' , 'SAMPLE_ID: 0550115' , 'SAMPLE_ID: 0666143' , 'SAMPLE_ID: 0606043' , 'SAMPL
                    # E_ID: 0574091' , 'SAMPLE_ID: 0629165' , 'SAMPLE_ID: 0545164' , 'SAMPLE_ID: 0606103' , 'SAMPLE_ID: 
                    # 0606074' , 'SAMPLE_ID: 0545163'
                    'relation': 'TEXT',
                    # EXAMPLES:
                    # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                    'rgid': 'NUMERIC',
                    # EXAMPLES:
                    # '19563' , '908' , '22435' , '20985' , '19888' , '4161' , '19550' , '21015' , '21001' , '19549'
                    'standard_relation': 'TEXT',
                    # EXAMPLES:
                    # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                    'standard_text_value': 'TEXT',
                    # EXAMPLES:
                    # 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'm
                    # inimal' , 'minimal'
                    'standard_type': 'TEXT',
                    # EXAMPLES:
                    # 'WBC' , 'MCV' , 'APTT' , 'NEUTLE' , 'BASOLE' , 'PT' , 'LYMLE' , 'PLAT' , 'LYMLE' , 'FIBRINO'
                    'standard_units': 'TEXT',
                    # EXAMPLES:
                    # 'cells.uL-1' , 'fL' , 's' , '%' , '%' , 's' , '%' , 'cells.uL-1' , '%' , 'ug.mL-1'
                    'standard_value': 'NUMERIC',
                    # EXAMPLES:
                    # '6700.0' , '64.9' , '15.4' , '21.0' , '0.0' , '17.4' , '79.0' , '1540000.0' , '79.0' , '3020.0'
                    'text_value': 'TEXT',
                    # EXAMPLES:
                    # 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'm
                    # inimal' , 'minimal'
                    'type': 'TEXT',
                    # EXAMPLES:
                    # 'WBC' , 'MCV' , 'APTT' , 'Neu' , 'Bas' , 'PT' , 'Lym' , 'Plat' , 'Lym' , 'Fbg'
                    'units': 'TEXT',
                    # EXAMPLES:
                    # 'x10_2/uL' , 'fL' , 's' , '%' , '%' , 's' , '%' , 'x10_4/uL' , '%' , 'mg/dL'
                    'value': 'NUMERIC',
                    # EXAMPLES:
                    # '67.0' , '64.9' , '15.4' , '21.0' , '0.0' , '17.4' , '79.0' , '154.0' , '79.0' , '302.0'
                }
            },
            'target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL3
            # 76' , 'CHEMBL376' , 'CHEMBL376'
            'target_organism': 'TEXT',
            # EXAMPLES:
            # 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus
            # ' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norveg
            # icus'
            'target_pref_name': 'TEXT',
            # EXAMPLES:
            # 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus
            # ' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norveg
            # icus'
            'target_tax_id': 'NUMERIC',
            # EXAMPLES:
            # '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116'
            'toid': 'NUMERIC',
            # EXAMPLES:
            # '8316' , '8322' , '9194' , '8842' , '8495' , '9024' , '8311' , '8848' , '8845' , '8311'
            'type': 'TEXT',
            # EXAMPLES:
            # 'WBC' , 'MCV' , 'APTT' , 'Neu' , 'Bas' , 'PT' , 'Lym' , 'Plat' , 'Lym' , 'Fbg'
            'units': 'TEXT',
            # EXAMPLES:
            # 'x10_2/uL' , 'fL' , 's' , '%' , '%' , 's' , '%' , 'x10_4/uL' , '%' , 'mg/dL'
            'uo_units': 'TEXT',
            # EXAMPLES:
            # 'UO_0000010' , 'UO_0000187' , 'UO_0000187' , 'UO_0000010' , 'UO_0000187' , 'UO_0000187' , 'UO_0000274' , '
            # UO_0000187' , 'UO_0000010' , 'UO_0000187'
            'value': 'NUMERIC',
            # EXAMPLES:
            # '111.8' , '66.8' , '16.1' , '17.0' , '0.0' , '14.4' , '79.4' , '134.5' , '75.0' , '320.6'
        }
    }

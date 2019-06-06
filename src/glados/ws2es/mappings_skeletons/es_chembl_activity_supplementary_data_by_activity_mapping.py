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
                # 'See Activity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See
                #  Activity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Act
                # ivity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Activit
                # y_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Activity_Su
                # pp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data'
                'activity_id': 'NUMERIC',
                # EXAMPLES:
                # '17150240' , '17150243' , '17150245' , '17150256' , '17150261' , '17150262' , '17150267' , '17150299' 
                # , '17150300' , '17150305'
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
                        # 'FIBRINO (Fibrinogen)' , 'HCT (Hematocrit)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'APTT
                        #  (Activated Partial Thromboplastin Time)' , 'MCV (Ery. Mean Corpuscular Volume)' , 'MCH (Ery. 
                        # Mean Corpuscular Hemoglobin)' , 'NEUTLE (Neutrophils/Leukocytes)' , 'PLAT (Platelets)' , 'WBC 
                        # (Leukocytes)' , 'LYMLE (Lymphocytes/Leukocytes)'
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
                        # '0' , '10' , '10' , '10' , '10' , '10' , '10' , '10' , '10' , '10'
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'FIBRINO (Fibrinogen)' , 'HCT (Hematocrit)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'APTT
                        #  (Activated Partial Thromboplastin Time)' , 'MCV (Ery. Mean Corpuscular Volume)' , 'MCH (Ery. 
                        # Mean Corpuscular Hemoglobin)' , 'NEUTLE (Neutrophils/Leukocytes)' , 'PLAT (Platelets)' , 'WBC 
                        # (Leukocytes)' , 'LYMLE (Lymphocytes/Leukocytes)'
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
                        # '0' , '10' , '10' , '10' , '10' , '10' , '10' , '10' , '10' , '10'
                    }
                },
                'assay_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3885862' , 'CHEMBL3885862' , 'CHEMBL3885862' , 'CHEMBL3885862' , 'CHEMBL3885862' , 'CHEMBL38858
                # 62' , 'CHEMBL3885862' , 'CHEMBL3885862' , 'CHEMBL3885862' , 'CHEMBL3885862'
                'assay_description': 'TEXT',
                # EXAMPLES:
                # 'Open TG-GATES - Regimen: Daily Repeat' , 'Open TG-GATES - Regimen: Daily Repeat' , 'Open TG-GATES - R
                # egimen: Daily Repeat' , 'Open TG-GATES - Regimen: Daily Repeat' , 'Open TG-GATES - Regimen: Daily Repe
                # at' , 'Open TG-GATES - Regimen: Daily Repeat' , 'Open TG-GATES - Regimen: Daily Repeat' , 'Open TG-GAT
                # ES - Regimen: Daily Repeat' , 'Open TG-GATES - Regimen: Daily Repeat' , 'Open TG-GATES - Regimen: Dail
                # y Repeat'
                'assay_type': 'TEXT',
                # EXAMPLES:
                # 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T' , 'T'
                'bao_endpoint': 'TEXT',
                # EXAMPLES:
                # 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0
                # 000179' , 'BAO_0000179' , 'BAO_0000179' , 'BAO_0000179'
                'bao_format': 'TEXT',
                # EXAMPLES:
                # 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0
                # 000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218'
                'bao_label': 'TEXT',
                # EXAMPLES:
                # 'organism-based format' , 'organism-based format' , 'organism-based format' , 'organism-based format' 
                # , 'organism-based format' , 'organism-based format' , 'organism-based format' , 'organism-based format
                # ' , 'organism-based format' , 'organism-based format'
                'canonical_smiles': 'TEXT',
                # EXAMPLES:
                # 'C\C(=C/CO)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=
                # C/CO)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\
                # C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\C=C\C=
                # C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\C=C\C=C(/C)\
                # C=C\C1=C(C)CCCC1(C)C' , 'C\C(=C/CO)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C'
                'data_validity_comment': 'TEXT',
                # EXAMPLES:
                # 'Non standard unit for type' , 'Non standard unit for type' , 'Non standard unit for type' , 'Non stan
                # dard unit for type' , 'Non standard unit for type' , 'Non standard unit for type' , 'Non standard unit
                #  for type' , 'Non standard unit for type' , 'Non standard unit for type' , 'Non standard unit for type
                # '
                'data_validity_description': 'TEXT',
                # EXAMPLES:
                # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)
                # ' , 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorr
                # ect)' , 'Units for this activity type are unusual and may be incorrect (or the standard_type may be in
                # correct)' , 'Units for this activity type are unusual and may be incorrect (or the standard_type may b
                # e incorrect)' , 'Units for this activity type are unusual and may be incorrect (or the standard_type m
                # ay be incorrect)' , 'Units for this activity type are unusual and may be incorrect (or the standard_ty
                # pe may be incorrect)' , 'Units for this activity type are unusual and may be incorrect (or the standar
                # d_type may be incorrect)' , 'Units for this activity type are unusual and may be incorrect (or the sta
                # ndard_type may be incorrect)' , 'Units for this activity type are unusual and may be incorrect (or the
                #  standard_type may be incorrect)' , 'Units for this activity type are unusual and may be incorrect (or
                #  the standard_type may be incorrect)'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL38858
                # 61' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861' , 'CHEMBL3885861'
                'ligand_efficiency': 
                {
                    'properties': 
                    {
                    }
                },
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHE
                # MBL986' , 'CHEMBL986' , 'CHEMBL986'
                'molecule_pref_name': 'TEXT',
                # EXAMPLES:
                # 'RETINOL' , 'RETINOL' , 'RETINOL' , 'RETINOL' , 'RETINOL' , 'RETINOL' , 'RETINOL' , 'RETINOL' , 'RETIN
                # OL' , 'RETINOL'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHEMBL986' , 'CHE
                # MBL986' , 'CHEMBL986' , 'CHEMBL986'
                'potential_duplicate': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'qudt_units': 'TEXT',
                # EXAMPLES:
                # 'http://www.openphacts.org/units/MicrogramPerMilliliter' , 'http://qudt.org/vocab/unit#Percent' , 'htt
                # p://qudt.org/vocab/unit#SecondTime' , 'http://qudt.org/vocab/unit#Percent' , 'http://qudt.org/vocab/un
                # it#Percent' , 'http://qudt.org/vocab/unit#SecondTime' , 'http://qudt.org/vocab/unit#Percent' , 'http:/
                # /qudt.org/vocab/unit#Percent' , 'http://qudt.org/vocab/unit#Percent' , 'http://qudt.org/vocab/unit#Per
                # cent'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '2834607' , '2834607' , '2834607' , '2834607' , '2834607' , '2834607' , '2834607' , '2834607' , '28346
                # 07' , '2834607'
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
                # 'FIBRINO' , 'HCT' , 'MCH' , 'APTT' , 'MCV' , 'MCH' , 'NEUTLE' , 'PLAT' , 'WBC' , 'LYMLE'
                'standard_units': 'TEXT',
                # EXAMPLES:
                # 'ug.mL-1' , '%' , 'pg' , 's' , 'fL' , 'pg' , '%' , 'cells.uL-1' , 'cells.uL-1' , '%'
                'standard_value': 'NUMERIC',
                # EXAMPLES:
                # '3548' , '38.9' , '21' , '22.3' , '60.9' , '21.2' , '16.8' , '1023000' , '8600' , '82.8'
                'supplementary_data': 
                {
                    'properties': 
                    {
                        'as_id': 'NUMERIC',
                        # EXAMPLES:
                        # '131908' , '131979' , '131981' , '131992' , '132065' , '132066' , '132071' , '132239' , '13224
                        # 0' , '132245'
                        'comments': 'TEXT',
                        # EXAMPLES:
                        # 'SAMPLE_ID: 0282041' , 'SAMPLE_ID: 0282051' , 'SAMPLE_ID: 0282051' , 'SAMPLE_ID: 0282051' , 'S
                        # AMPLE_ID: 0282061' , 'SAMPLE_ID: 0282061' , 'SAMPLE_ID: 0282061' , 'SAMPLE_ID: 0282081' , 'SAM
                        # PLE_ID: 0282081' , 'SAMPLE_ID: 0282081'
                        'relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'rgid': 'NUMERIC',
                        # EXAMPLES:
                        # '11593' , '11598' , '11598' , '11598' , '11603' , '11603' , '11603' , '6668' , '6668' , '6668'
                        'standard_relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_text_value': 'TEXT',
                        # EXAMPLES:
                        # 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'P' , 'min
                        # imal' , 'minimal'
                        'standard_type': 'TEXT',
                        # EXAMPLES:
                        # 'FIBRINO' , 'HCT' , 'MCH' , 'APTT' , 'MCV' , 'MCH' , 'NEUTLE' , 'PLAT' , 'WBC' , 'LYMLE'
                        'standard_units': 'TEXT',
                        # EXAMPLES:
                        # 'ug.mL-1' , '%' , 'pg' , 's' , 'fL' , 'pg' , '%' , 'cells.uL-1' , 'cells.uL-1' , '%'
                        'standard_value': 'NUMERIC',
                        # EXAMPLES:
                        # '3540' , '40.1' , '21.1' , '21.2' , '57.4' , '20.1' , '21' , '846000' , '6810' , '81'
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'P' , 'min
                        # imal' , 'minimal'
                        'type': 'TEXT',
                        # EXAMPLES:
                        # 'Fbg' , 'Ht' , 'MCH' , 'APTT' , 'MCV' , 'MCH' , 'Neu' , 'Plat' , 'WBC' , 'Lym'
                        'units': 'TEXT',
                        # EXAMPLES:
                        # 'mg/dL' , '%' , 'pg' , 's' , 'fL' , 'pg' , '%' , 'x10_4/uL' , 'x10_2/uL' , '%'
                        'value': 'NUMERIC',
                        # EXAMPLES:
                        # '354' , '40.1' , '21.1' , '21.2' , '57.4' , '20.1' , '21' , '84.6' , '68.1' , '81'
                    }
                },
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHEMBL376' , 'CHE
                # MBL376' , 'CHEMBL376' , 'CHEMBL376'
                'target_organism': 'TEXT',
                # EXAMPLES:
                # 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norveg
                # icus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattu
                # s norvegicus'
                'target_pref_name': 'TEXT',
                # EXAMPLES:
                # 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norveg
                # icus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattu
                # s norvegicus'
                'target_tax_id': 'NUMERIC',
                # EXAMPLES:
                # '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116' , '10116'
                'toid': 'NUMERIC',
                # EXAMPLES:
                # '6192' , '6193' , '6193' , '6193' , '6194' , '6194' , '6194' , '6196' , '6196' , '6196'
                'type': 'TEXT',
                # EXAMPLES:
                # 'Fbg' , 'Ht' , 'MCH' , 'APTT' , 'MCV' , 'MCH' , 'Neu' , 'Plat' , 'WBC' , 'Lym'
                'units': 'TEXT',
                # EXAMPLES:
                # 'mg/dL' , '%' , 'pg' , 's' , 'fL' , 'pg' , '%' , 'x10_4/uL' , 'x10_2/uL' , '%'
                'uo_units': 'TEXT',
                # EXAMPLES:
                # 'UO_0000274' , 'UO_0000187' , 'UO_0000025' , 'UO_0000010' , 'UO_0000025' , 'UO_0000187' , 'UO_0000187'
                #  , 'UO_0000010' , 'UO_0000187' , 'UO_0000187'
                'value': 'NUMERIC',
                # EXAMPLES:
                # '354.8' , '38.9' , '21' , '22.3' , '60.9' , '21.2' , '16.8' , '102.3' , '86' , '82.8'
            }
        }
    }

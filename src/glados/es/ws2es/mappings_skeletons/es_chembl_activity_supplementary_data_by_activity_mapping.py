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
                # 'See Activity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See
                #  Activity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Act
                # ivity_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Activit
                # y_Supp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data' , 'See Activity_Su
                # pp For Individual Animal Data' , 'See Activity_Supp For Individual Animal Data'
                'activity_id': 'NUMERIC',
                # EXAMPLES:
                # '17128248' , '17127342' , '17127343' , '17128275' , '17128284' , '17127357' , '17127359' , '17127365' 
                # , '17127372' , '17128320'
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
                        # 'MCHC (Ery. Mean Corpuscular HGB Concentration)' , 'RBC (Erythrocytes)' , 'HGB (Hemoglobin)' ,
                        #  'APTT (Activated Partial Thromboplastin Time)' , 'PLAT (Platelets)' , 'APTT (Activated Partia
                        # l Thromboplastin Time)' , 'RBC (Erythrocytes)' , 'RETIRBC (Reticulocytes/Erythrocytes)' , 'LYM
                        # LE (Lymphocytes/Leukocytes)' , 'NEUTLE (Neutrophils/Leukocytes)'
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
                        # '10.0' , '0.0' , '0.0' , '10.0' , '30.0' , '0.0' , '0.0' , '0.0' , '0.0' , '30.0'
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'MCHC (Ery. Mean Corpuscular HGB Concentration)' , 'RBC (Erythrocytes)' , 'HGB (Hemoglobin)' ,
                        #  'APTT (Activated Partial Thromboplastin Time)' , 'PLAT (Platelets)' , 'APTT (Activated Partia
                        # l Thromboplastin Time)' , 'RBC (Erythrocytes)' , 'RETIRBC (Reticulocytes/Erythrocytes)' , 'LYM
                        # LE (Lymphocytes/Leukocytes)' , 'NEUTLE (Neutrophils/Leukocytes)'
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
                        # '10.0' , '0.0' , '0.0' , '10.0' , '30.0' , '0.0' , '0.0' , '0.0' , '0.0' , '30.0'
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
                # 'CCC1(c2ccccc2)C(=O)NC(=O)NC1=O' , 'ClC(Cl)(Cl)Cl' , 'ClC(Cl)(Cl)Cl' , 'CCC1(c2ccccc2)C(=O)NC(=O)NC1=O
                # ' , 'CCC1(c2ccccc2)C(=O)NC(=O)NC1=O' , 'ClC(Cl)(Cl)Cl' , 'ClC(Cl)(Cl)Cl' , 'ClC(Cl)(Cl)Cl' , 'ClC(Cl)(
                # Cl)Cl' , 'CCC1(c2ccccc2)C(=O)NC(=O)NC1=O'
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
                # 'CHEMBL40' , 'CHEMBL44814' , 'CHEMBL44814' , 'CHEMBL40' , 'CHEMBL40' , 'CHEMBL44814' , 'CHEMBL44814' ,
                #  'CHEMBL44814' , 'CHEMBL44814' , 'CHEMBL40'
                'molecule_pref_name': 'TEXT',
                # EXAMPLES:
                # 'PHENOBARBITAL' , 'CARBON TETRACHLORIDE' , 'CARBON TETRACHLORIDE' , 'PHENOBARBITAL' , 'PHENOBARBITAL' 
                # , 'CARBON TETRACHLORIDE' , 'CARBON TETRACHLORIDE' , 'CARBON TETRACHLORIDE' , 'CARBON TETRACHLORIDE' , 
                # 'PHENOBARBITAL'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL40' , 'CHEMBL44814' , 'CHEMBL44814' , 'CHEMBL40' , 'CHEMBL40' , 'CHEMBL44814' , 'CHEMBL44814' ,
                #  'CHEMBL44814' , 'CHEMBL44814' , 'CHEMBL40'
                'potential_duplicate': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'qudt_units': 'TEXT',
                # EXAMPLES:
                # 'http://qudt.org/vocab/unit#Percent' , 'http://www.openphacts.org/units/MicrogramPerMilliliter' , 'htt
                # p://qudt.org/vocab/unit#SecondTime' , 'http://qudt.org/vocab/unit#SecondTime' , 'http://qudt.org/vocab
                # /unit#Percent' , 'http://qudt.org/vocab/unit#Percent' , 'http://qudt.org/vocab/unit#Percent' , 'http:/
                # /qudt.org/vocab/unit#Percent' , 'http://www.openphacts.org/units/MicrogramPerMilliliter' , 'http://qud
                # t.org/vocab/unit#Percent'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '2834574' , '2834484' , '2834484' , '2834574' , '2834574' , '2834484' , '2834484' , '2834484' , '28344
                # 84' , '2834574'
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
                # 'MCHC' , 'RBC' , 'HGB' , 'APTT' , 'PLAT' , 'APTT' , 'RBC' , 'RETIRBC' , 'LYMLE' , 'NEUTLE'
                'standard_units': 'TEXT',
                # EXAMPLES:
                # '%' , 'cells.uL-1' , 'ug.mL-1' , 's' , 'cells.uL-1' , 's' , 'cells.uL-1' , '%' , '%' , '%'
                'standard_value': 'NUMERIC',
                # EXAMPLES:
                # '33.3' , '6474000.0' , '139000.0' , '17.6' , '1188000.0' , '18.3' , '7280000.0' , '3.9' , '80.8' , '8.
                # 4'
                'supplementary_data': 
                {
                    'properties': 
                    {
                        'as_id': 'NUMERIC',
                        # EXAMPLES:
                        # '22845' , '18335' , '18319' , '22872' , '22983' , '18299' , '18420' , '18358' , '18365' , '231
                        # 38'
                        'comments': 'TEXT',
                        # EXAMPLES:
                        # 'SAMPLE_ID: 0093075' , 'SAMPLE_ID: 0067025' , 'SAMPLE_ID: 0067024' , 'SAMPLE_ID: 0093081' , 'S
                        # AMPLE_ID: 0093093' , 'SAMPLE_ID: 0067022' , 'SAMPLE_ID: 0067035' , 'SAMPLE_ID: 0067031' , 'SAM
                        # PLE_ID: 0067031' , 'SAMPLE_ID: 0093112'
                        'relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'rgid': 'NUMERIC',
                        # EXAMPLES:
                        # '5554' , '7075' , '7074' , '7224' , '7227' , '7073' , '1415' , '7076' , '7076' , '5567'
                        'standard_relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_text_value': 'TEXT',
                        # EXAMPLES:
                        # 'P' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'P' , 'slight' ,
                        #  'P'
                        'standard_type': 'TEXT',
                        # EXAMPLES:
                        # 'MCHC' , 'RBC' , 'HGB' , 'APTT' , 'PLAT' , 'APTT' , 'RBC' , 'RETIRBC' , 'LYMLE' , 'NEUTLE'
                        'standard_units': 'TEXT',
                        # EXAMPLES:
                        # '%' , 'cells.uL-1' , 'ug.mL-1' , 's' , 'cells.uL-1' , 's' , 'cells.uL-1' , '%' , '%' , '%'
                        'standard_value': 'NUMERIC',
                        # EXAMPLES:
                        # '33.6' , '6190000.0' , '140000.0' , '18.9' , '1243000.0' , '18.2' , '7000000.0' , '3.1' , '84.
                        # 0' , '10.0'
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'P' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'minimal' , 'P' , 'slight' ,
                        #  'P'
                        'type': 'TEXT',
                        # EXAMPLES:
                        # 'MCHC' , 'RBC' , 'Hb' , 'APTT' , 'Plat' , 'APTT' , 'RBC' , 'Ret' , 'Lym' , 'Neu'
                        'units': 'TEXT',
                        # EXAMPLES:
                        # '%' , 'x10_4/ul' , 'g/dL' , 's' , 'x10_4/uL' , 's' , 'x10_4/ul' , '%' , '%' , '%'
                        'value': 'NUMERIC',
                        # EXAMPLES:
                        # '33.6' , '619.0' , '14.0' , '18.9' , '124.3' , '18.2' , '700.0' , '3.1' , '84.0' , '10.0'
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
                # '4899' , '4846' , '4846' , '4900' , '4901' , '4846' , '4847' , '4847' , '4847' , '4903'
                'type': 'TEXT',
                # EXAMPLES:
                # 'MCHC' , 'RBC' , 'Hb' , 'APTT' , 'Plat' , 'APTT' , 'RBC' , 'Ret' , 'Lym' , 'Neu'
                'units': 'TEXT',
                # EXAMPLES:
                # '%' , 'x10_4/ul' , 'g/dL' , 's' , 'x10_4/uL' , 's' , 'x10_4/ul' , '%' , '%' , '%'
                'uo_units': 'TEXT',
                # EXAMPLES:
                # 'UO_0000187' , 'UO_0000274' , 'UO_0000010' , 'UO_0000010' , 'UO_0000187' , 'UO_0000187' , 'UO_0000187'
                #  , 'UO_0000187' , 'UO_0000274' , 'UO_0000187'
                'value': 'NUMERIC',
                # EXAMPLES:
                # '33.3' , '647.4' , '13.9' , '17.6' , '118.8' , '18.3' , '728.0' , '3.9' , '80.8' , '8.4'
            }
        }
    }

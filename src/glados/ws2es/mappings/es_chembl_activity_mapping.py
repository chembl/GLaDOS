# Elastic search mapping definition for the Molecule entity
from glados.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
shards = 7
replicas = 1

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        '_doc':
        {
            'properties': 
            {
                'activity_comment': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Not significant' , 'Not Active' , 'Not Determined' , 'Not Determined' , 'Not Determined' , 'Not Deter
                # mined' , 'No Activity' , 'Active' , 'Not Active' , 'Not Determined'
                'activity_id': DefaultMappings.ID,
                'activity_properties':
                {
                    'properties':
                    {
                        'relation': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                        'result_flag': DefaultMappings.SHORT,
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'standard_relation': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                        'standard_text_value': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'LYMLE (Lymphocytes/Leukocytes)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'PT (Prothrombin
                        #  Time)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'PLAT (Platelets)' , 'HCT (Hematocrit)' ,
                        #  'HGB (Hemoglobin)' , 'WBC (Leukocytes)' , 'MCV (Ery. Mean Corpuscular Volume)' , 'RBC (Erythr
                        # ocytes)'
                        'standard_type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACT
                        # IVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                        'standard_units': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                        'standard_value': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                        'text_value': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'LYMLE (Lymphocytes/Leukocytes)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'PT (Prothrombin
                        #  Time)' , 'MCH (Ery. Mean Corpuscular Hemoglobin)' , 'PLAT (Platelets)' , 'HCT (Hematocrit)' ,
                        #  'HGB (Hemoglobin)' , 'WBC (Leukocytes)' , 'MCV (Ery. Mean Corpuscular Volume)' , 'RBC (Erythr
                        # ocytes)'
                        'type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACT
                        # IVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                        'units': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                        'value': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                    }
                },
                # EXAMPLES:
                # '1257115' , '1255687' , '1208208' , '1206737' , '1250105' , '1248197' , '1269811' , '1202567' , '12494
                # 39' , '1202658'
                'assay_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL660317' , 'CHEMBL658042' , 'CHEMBL715010' , 'CHEMBL813448' , 'CHEMBL841714' , 'CHEMBL696911' , 
                # 'CHEMBL845947' , 'CHEMBL719082' , 'CHEMBL746729' , 'CHEMBL645253'
                'assay_description': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Effect of BSA on Chymotrypsinogen inhibition by the compound, expressed as fold increase in IC50' , '
                # Inhibitory activity against Human carbonic anhydrase II' , 'Inhibitory activity against Matrix metallo
                # protease-2' , 'Effect of dose dependent inhibition of TOPO II-catalyzed kDNA decatenation in vitro' , 
                # 'Therapeutic ratio in mixed-breed or Beagle dogs after intravenous administration of the compound.' , 
                # 'Cytotoxicity against the cancer cell lines CNS SF-539' , 'Ratio for antagonistic activity for Pgp/MRP
                # 1 was determined' , 'Agonist activity in rat at mGlu1a receptor expressed in HEK293 cells' , 'Inhibiti
                # on of [3H]- DCKA binding to NMDA receptor of rat brain membranes' , 'Potency to antagonize the ability
                #  of angiotensin II to contract rabbit aorta'
                'assay_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'B' , 'B' , 'B' , 'F' , 'A' , 'F' , 'F' , 'F' , 'B' , 'B'
                'bao_endpoint': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'BAO_0000179' , 'BAO_0000192' , 'BAO_0000192' , 'BAO_0002144' , 'BAO_0000179' , 'BAO_0000189' , 'BAO_0
                # 000179' , 'BAO_0000188' , 'BAO_0000190' , 'BAO_0000034'
                'bao_format': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'BAO_0000357' , 'BAO_0000357' , 'BAO_0000357' , 'BAO_0000019' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0
                # 000019' , 'BAO_0000219' , 'BAO_0000249' , 'BAO_0000224'
                'bao_label': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'cell membrane format' , 'protein complex format' , 'single protein format' , 'assay format' , 'organi
                # sm-based format' , 'assay format' , 'single protein format' , 'single protein format' , 'organism-base
                # d format' , 'organism-based format'
                'canonical_smiles': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'Oc1ccc2ccccc2c1N=Nc3c(O)cc(c4ccccc34)S(=O)(=O)O' , 'NS(=O)(=O)c1cc(c(NC(=O)CN(CCOCCOCCN(CC(=O)O)CC(=O
                # )Nc2c(Cl)c(Cl)c(cc2S(=O)(=O)N)S(=O)(=O)N)CC(=O)O)c(Cl)c1Cl)S(=O)(=O)N' , 'CS(=O)(=O)NO' , 'COc1cc(NS(=
                # O)(=O)C)ccc1Nc2c3ccccc3nc4ccccc24' , 'CC(C)N(CCC(C(=O)N)(c1ccccc1)c2ccccn2)C(C)C' , 'COc1cc(\C=C\c2cc3
                # [C@H]4CC[C@]5(C)[C@@H](O)CC[C@H]5[C@@H]4CCc3cc2O)cc(OC)c1OC' , 'CC(=O)Nc1ccccc1c2nc3ccccc3nc2O' , 'N[C
                # @@H](C[C@@H](O)C(=O)O)C(=O)O' , 'Oc1nc2ccc(Cl)c(Cl)c2c(O)c1N=O' , 'CCN(Cc1ccc(cc1)c2ccccc2c3nn[nH]n3)c
                # 4ncccc4C(=O)O'
                'data_validity_comment': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Outside typical range' , 'Outside typical range' , 'Outside typical range' , 'Outside typical range'
                # , 'Outside typical range' , 'Outside typical range' , 'Outside typical range' , 'Potential missing dat
                # a' , 'Outside typical range' , 'Outside typical range'
                'data_validity_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Values for this activity type are unusually large/small, so may not be accurate' , 'No data provided
                # for value, units or activity_comment, needs further investigation' , 'Units for this activity type are
                #  unusual and may be incorrect (or the standard_type may be incorrect)' , 'Values for this activity typ
                # e are unusually large/small, so may not be accurate' , 'Units for this activity type are unusual and m
                # ay be incorrect (or the standard_type may be incorrect)' , 'Units for this activity type are unusual a
                # nd may be incorrect (or the standard_type may be incorrect)' , 'Values for this activity type are unus
                # ually large/small, so may not be accurate' , 'Values for this activity type are unusually large/small,
                #  so may not be accurate' , 'Units for this activity type are unusual and may be incorrect (or the stan
                # dard_type may be incorrect)' , 'Units for this activity type are unusual and may be incorrect (or the
                # standard_type may be incorrect)'
                'document_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1135922' , 'CHEMBL1135903' , 'CHEMBL1133677' , 'CHEMBL1127394' , 'CHEMBL1121621' , 'CHEMBL11356
                # 29' , 'CHEMBL1134347' , 'CHEMBL1134758' , 'CHEMBL1129792' , 'CHEMBL1126796'
                'document_journal': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'J. Med. Che
                # m.' , 'J. Med. Chem.' , 'Bioorg. Med. Chem. Lett.' , 'J. Med. Chem.' , 'J. Med. Chem.'
                'document_year': DefaultMappings.SHORT,
                # EXAMPLES:
                # '2002' , '2002' , '2000' , '1994' , '1980' , '2002' , '2001' , '2001' , '1996' , '1993'
                'ligand_efficiency':
                {
                    'properties':
                    {
                        'bei': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # '16.02' , '18.43' , '19.83' , '21.43' , '20.51' , '23.47' , '29.8' , '12.3' , '18.7' , '8.73'
                        'le': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # '0.3' , '0.34' , '0.36' , '0.42' , '0.38' , '0.43' , '0.54' , '0.24' , '0.38' , '0.16'
                        'lle': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # '3.31' , '7.42' , '1.45' , '3.37' , '2.55' , '2.76' , '4.52' , '0.72' , '3.27' , '0.74'
                        'sei': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # '12.27' , '8.42' , '7.97' , '14.66' , '29.24' , '52.57' , '24.27' , '6.16' , '7.25' , '3.59'
                    }
                },
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL124855' , 'CHEMBL34899' , 'CHEMBL98328' , 'CHEMBL43' , 'CHEMBL517' , 'CHEMBL1628072' , 'CHEMBL1
                # 54885' , 'CHEMBL371946' , 'CHEMBL40708' , 'CHEMBL440521'
                'molecule_pref_name': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # '4'-HYDROXYCHALCONE' , 'BERBERINE' , 'CHLORANIL' , 'CORTICOSTERONE' , 'DESACETOXYMATRICARIN' , 'TOLBUT
                # AMIDE' , 'NIFEDIPINE' , 'DYCLONINE HYDROCHLORIDE' , 'HARMAN' , 'EPINEPHRINE BITARTRATE'
                'parent_molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL310082' , 'CHEMBL423241' , 'CHEMBL326713' , 'CHEMBL300429' , 'CHEMBL283728' , 'CHEMBL950' , 'CH
                # EMBL173709' , 'CHEMBL173709' , 'CHEMBL1192700' , 'CHEMBL53463'
                'pchembl_value': DefaultMappings.DOUBLE,
                # EXAMPLES:
                # '8.00' , '6.77' , '8.77' , '4.83' , '7.60' , '6.19' , '4.46' , '8.89' , '9.52' , '7.07'
                'potential_duplicate': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'qudt_units': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://ww
                # w.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphac
                # ts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/uni
                # ts/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomol
                # ar' , 'http://www.openphacts.org/units/Nanomolar'
                'record_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '78932' , '54374' , '231729' , '239131' , '11901' , '278312' , '304982' , '64208' , '208002' , '164930
                # '
                'relation': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                'src_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'standard_flag': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'standard_relation': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '>' , '=' , '>' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                'standard_text_value': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'Not Active' , 'Acti
                # ve' , 'Active' , 'Active'
                'standard_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Increase in IC50' , 'Ki' , 'Ki' , 'IC90' , 'TR' , 'GI50' , 'Ratio' , 'EC50' , 'IC50' , 'Kd'
                'standard_units': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'nM' , 'nM' , 'nM' , 'nM' , 'nM' , 'nM' , 'nM' , 'nM' , 'mg.kg-1' , 'nM'
                'standard_value': DefaultMappings.DOUBLE,
                # EXAMPLES:
                # '50' , '10' , '100' , '33000' , '6.6' , '2000' , '1' , '373000' , '170' , '1.7'
                'target_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL3314' , 'CHEMBL205' , 'CHEMBL333' , 'CHEMBL2094255' , 'CHEMBL373' , 'CHEMBL372' , 'CHEMBL612545
                # ' , 'CHEMBL4477' , 'CHEMBL330' , 'CHEMBL2094256'
                'target_organism': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Bos taurus' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Canis lupus familiaris' , 'Homo sap
                # iens' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Homo sapiens' , 'Homo sapiens'
                'target_pref_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'Alpha-chymotrypsin' , 'Carbonic anhydrase II' , 'Matrix metalloproteinase-2' , 'DNA topoisomerase II'
                #  , 'Canis familiaris' , 'Homo sapiens' , 'Unchecked' , 'Metabotropic glutamate receptor 1' , 'Glutamat
                # e (NMDA) receptor subunit zeta 1' , 'Angiotensin II receptor'
                'target_tax_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '10090' , '9606' , '1280' , '9606' , '9606' , '7787' , '10116' , '9606' , '10090' , '5666'
                'text_value': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'Not Active' , 'Acti
                # ve' , 'Active' , 'Active'
                'toid': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '4981' , '5141' , '4981' , '4975' , '5141' , '4807' , '4982' , '4807' , '4969' , '4801'
                'type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Potency' , 'Potency' , 'Potency' , 'Potency' , 'Potency' , 'Potency' , 'Potency' , 'Potency' , 'Poten
                # cy' , 'Potency'
                'units': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'um' , 'um' , 'um' , 'um' , 'um' , 'um' , 'um' , 'um' , 'um' , 'um'
                'uo_units': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'UO_0000065' , 'UO_0000065' , 'UO_0000065' , 'UO_0000065' , 'UO_0000065' , 'UO_0000065' , 'UO_0000065'
                #  , 'UO_0000065' , 'UO_0000308' , 'UO_0000065'
                'upper_value': DefaultMappings.DOUBLE,
                # EXAMPLES:
                # '100' , '100' , '83' , '83' , '3' , '15' , '6' , '1' , '3' , '63'
                'value': DefaultMappings.DOUBLE,
                # EXAMPLES:
                # '2.8184' , '35.4813' , '31.6228' , '3.1623' , '2.8184' , '7.9433' , '31.6228' , '28.1838' , '3.9811' ,
                #  '3.9811'
            }
        }
    }

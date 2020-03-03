# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings
import glados.es.ws2es.mappings.es_chembl_drug_mapping as drug_mapping
import glados.es.ws2es.mappings.es_chembl_molecule_n_drug_shared_mapping as molecule_n_drug_mapping

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 0

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        '_doc':
        {
            'properties': 
            {
                '_metadata':
                {
                    'properties':
                    {
                        'es_completion': DefaultMappings.COMPLETION_TYPE,
                        'activity_count': DefaultMappings.LONG,
                        'compound_records':
                        {
                            'properties':
                            {
                                'compound_key': DefaultMappings.ALT_NAME,
                                'compound_name': DefaultMappings.ALT_NAME
                            }
                        },
                        'disease_name': DefaultMappings.LOWER_CASE_KEYWORD + DefaultMappings.TEXT_STD,
                        'drug': {
                            'properties': {
                                'is_drug': DefaultMappings.BOOLEAN,
                                'drug_data': drug_mapping.mappings['_doc']
                            }
                        },
                        'related_targets':
                        {
                            'properties':
                            {
                                'chembl_ids':  {
                                    'properties': {
                                        # '0': DefaultMappings.CHEMBL_ID_REF
                                    }
                                },
                                'count': DefaultMappings.LONG,
                                # EXAMPLES:
                                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                            }
                        },
                        'tags': DefaultMappings.LOWER_CASE_KEYWORD
                    }
                },
                'atc_classifications': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'P03AB01' , 'B01AC07' , 'C04AX26' , 'S01BC01' , 'L04AA19' , 'R05DB21' , 'S01EA04' , 'L01XX49' , 'J04AB
                # 03' , 'D11AH03'
                'availability_type': DefaultMappings.SHORT,
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'biotherapeutic': molecule_n_drug_mapping.biotherapeutic
                ,
                'black_box_warning': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                'chebi_par_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '6503' , '65589' , '73393' , '28750' , '16130' , '1189' , '4653' , '73635' , '73288' , '73828'
                'chirality': DefaultMappings.INTEGER,
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '2' , '-1' , '-1' , '-1'
                'cross_references':
                {
                    'properties':
                    {
                        'xref_id': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'Arachidonoyl_serotonin' , '49641958' , '49674688' , '49667260' , '174006733' , '29217610' , '
                        # 515936' , '516189' , '487570' , '137275973'
                        'xref_name': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'SID: 47198421' , 'SID: 11532971' , 'SID: 26755659' , 'SID: 50112911' , 'SID: 503840' , 'SID:
                        # 11113527' , 'SID: 50111183' , 'SID: 85148698' , 'SID: 24801881' , 'SID: 3713259'
                        'xref_src': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'Wikipedia' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem
                        # ' , 'PubChem' , 'PubChem'
                    }
                },
                'dosed_ingredient': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'first_approval': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1961' , '1965' , '1974' , '2014' , '1982' , '1982' , '1999' , '1982' , '1959' , '1996'
                'first_in_class': DefaultMappings.INTEGER,
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '0' , '-1' , '-1' , '-1'
                'helm_notation': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'PEPTIDE1{[Cbz_V].A.[X1486]}$$$$' , 'PEPTIDE1{[ac].[X1693].L.G.G.I.W}$$$$' , 'PEPTIDE1{[dP].R.[Nal].G.
                # [dY]}$PEPTIDE1,PEPTIDE1,5:R2-1:R1$$$' , 'PEPTIDE1{[dC].[dR].V.[dY].R.[dP].[dC].W.[dE].[dV]}$PEPTIDE1,P
                # EPTIDE1,7:R3-1:R3$$$' , 'PEPTIDE1{F.G.G.F.T.G.C.R.K.S.A.R.K.C.[am]}$PEPTIDE1,PEPTIDE1,14:R3-7:R3$$$' ,
                #  'PEPTIDE1{[dY].[dC].F.W.K.T.C.[meT].[am]}$PEPTIDE1,PEPTIDE1,7:R3-2:R3$$$' , 'PEPTIDE1{[Sar].R.V.[X539
                # ].V.H.[dP].F}$$$$' , 'PEPTIDE1{R.[dP].[dK].P.Q.[dQ].[dF].F.G.L.M.[am]}$$$$' , 'PEPTIDE1{[Glp].G.P.P.I.
                # S.I.D.L.P.L.E.L.L.R.K.M.I.E.I.E.K.Q.E.K.E.K.Q.Q.A.A.N.N.R.L.L.L.D.T.I}$$$$' , 'PEPTIDE1{[dCha].P.[X219
                # 2].G.G.G.G.D.Y.E.P.[lalloI].P.E.E.Y.[Cha].D}$$$$'
                'indication_class': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Vasodilator (coronary)' , 'Antiprotozoal (babesia)' , 'Vasodilator (peripheral)' , 'Anti-Inflammatory
                # ' , 'Immunosuppressant' , 'Antihypertensive' , 'Anti-Asthmatic (prophylactic)' , 'Antibacterial' , 'Ph
                # armaceutic Aid (antimicrobial agent)' , 'Cardiotonic'
                'inorganic_flag': DefaultMappings.SHORT,
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '0' , '-1' , '-1' , '-1'
                'max_phase': DefaultMappings.SHORT,
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID,
                # EXAMPLES:
                # 'CHEMBL419173' , 'CHEMBL1203473' , 'CHEMBL419179' , 'CHEMBL419180' , 'CHEMBL419186' , 'CHEMBL421548' ,
                #  'CHEMBL421556' , 'CHEMBL421558' , 'CHEMBL421560' , 'CHEMBL421562'
                'molecule_hierarchy': 
                {
                    'properties': 
                    {
                        'molecule_chembl_id': DefaultMappings.ID,
                        # EXAMPLES:
                        # 'CHEMBL419173' , 'CHEMBL1203473' , 'CHEMBL419179' , 'CHEMBL419180' , 'CHEMBL419186' , 'CHEMBL4
                        # 21548' , 'CHEMBL421556' , 'CHEMBL421558' , 'CHEMBL421560' , 'CHEMBL421562'
                        'parent_chembl_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # 'CHEMBL419173' , 'CHEMBL153048' , 'CHEMBL419179' , 'CHEMBL419180' , 'CHEMBL419186' , 'CHEMBL42
                        # 1548' , 'CHEMBL421556' , 'CHEMBL421558' , 'CHEMBL421560' , 'CHEMBL421562'
                    }
                },
                'molecule_properties': molecule_n_drug_mapping.molecule_properties
                ,
                'molecule_structures': molecule_n_drug_mapping.molecule_structures
                ,
                'molecule_synonyms': molecule_n_drug_mapping.molecule_synonyms
                ,
                'molecule_type': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small 
                # molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule'
                'natural_product': DefaultMappings.SHORT,
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '0' , '-1' , '-1' , '-1'
                'oral': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'parenteral': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'polymer_flag': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'pref_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'ACETIAMINE' , 'BENZOYLENUREA' , 'PARETHOXYCAINE' , '[Pt(NH3)2BPMAA]' , 'CASEANIGRESCEN B' , 'BIS(BUTY
                # RYLOXYMETHYL) SUCCINATE' , 'ESCULENTIN B' , 'TIZOXANIDE GLUCURONIDE' , 'NIGROLINEAXANTHONE N' , 'LASAL
                # OCID METHYLETHER'
                'prodrug': DefaultMappings.SHORT,
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '0' , '-1' , '-1' , '-1'
                'structure_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL'
                'therapeutic_flag': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'topical': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'usan_stem': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '-cycline' , 'cef-' , '-ium' , '-triptyline' , 'cef-' , '-ium' , '-erg-' , '-ium' , '-pril' , '-ium'
                'usan_stem_definition': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'local anesthetics' , 'vasodilators (undefined group)' , 'angiotensin II receptor antagonists' , 'quat
                # ernary ammonium derivatives' , 'immunosuppressives' , 'enzyme inhibitors: inhibitors of histone deacet
                # ylase' , 'antibiotics (Streptomyces strains); antibiotics (rifamycin derivatives)' , 'penicillins' , '
                # retinol derivatives' , 'BCL-2 (B-cell lymphoma 2) inhibitors'
                'usan_substem': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '-inostat' , '-mastat' , '-lukast' , '-cavir' , '-patrilat' , '-vastatin' , '-tegravir' , '-morelin' ,
                #  '-navir' , '-restat'
                'usan_year': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1963' , '1970' , '1978' , '1963' , '1993' , '1969' , '2006' , '2009' , '1968' , '2011'
                'withdrawn_class': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Cardiotoxicity' , 'Gastrotoxicity; Hepatotoxicity' , 'Cardiotoxicity' , 'Cardiotoxicity' , 'Neurotoxi
                # city' , 'Hematological toxicity' , 'Cardiotoxicity' , 'Cardiotoxicity; Neurotoxicity' , 'Misuse' , 'He
                # matological toxicity; Misuse'
                'withdrawn_country': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'United States' , 'United States' , 'United Kingdom; United States; Germany; France' , 'United Kingdom
                # ' , 'United Kingdom; United States; European Union; Canada; Malasia; India; Saudi Arabia' , 'France' ,
                #  'Canada; United Kingdom' , 'New Zealand' , 'United Kingdom' , 'Germany'
                'withdrawn_flag': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'withdrawn_reason': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Agranulocytosis' , 'Cardiac valvular disease' , 'Convulsions' , 'Hepatic toxicity' , 'Asthma Mortalit
                # y' , 'Vasculitis; Rash' , 'Dermatologic, Hematologic and Hepatic Reactions' , 'Gastrointestinal Toxici
                # ty; Hepatotoxicity' , 'Serious, irreversible, and even fatal nephrotoxicity and hepatotoxicity' , 'Res
                # piratory Reaction'
                'withdrawn_year': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1970' , '1986' , '1997' , '1996' , '1997' , '1990' , '1979' , '1988' , '1990' , '2001'
            }
        }
    }

autocomplete_settings = {
    'molecule_chembl_id': 10,
    'molecule_hierarchy': {
        'parent_chembl_id': 5
    },
    'molecule_structures': {
        'canonical_smiles':  30,
        'standard_inchi':  30,
        'standard_inchi_key':  30,
    },
    'molecule_synonyms': {
        'molecule_synonym': 75,
        'synonyms': 75
    },
    'molecule_properties': {
        'full_molformula': 90
    },
    'pref_name': 100,
    'usan_stem_definition': 40
}

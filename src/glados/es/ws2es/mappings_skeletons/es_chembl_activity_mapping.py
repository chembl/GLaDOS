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
                    'activity_generated': 
                    {
                        'properties': 
                        {
                        }
                    },
                    'assay_data': 
                    {
                        'properties': 
                        {
                            'assay_cell_type': 'TEXT',
                            # EXAMPLES:
                            # 'Hs-578T' , 'NIH3T3' , 'MDA-MB-231' , 'MDA-MB-231' , 'HEK293' , 'MCF7' , 'HOP-92' , 'A549'
                            #  , 'HEK293' , 'EKVX '
                            'assay_organism': 'TEXT',
                            # EXAMPLES:
                            # 'Plasmodium falciparum' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Rattus norve
                            # gicus' , 'Homo sapiens' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens
                            # '
                            'assay_parameters': 
                            {
                                'properties': 
                                {
                                    'active': 'NUMERIC',
                                    # EXAMPLES:
                                    # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                                    'comments': 'TEXT',
                                    # EXAMPLES:
                                    # 'Is the measured interaction considered due to direct binding to target?' , 'Is th
                                    # e measured interaction considered due to direct binding to target?' , 'Is the meas
                                    # ured interaction considered due to direct binding to target?' , 'Is the measured i
                                    # nteraction considered due to direct binding to target?' , 'Is the measured interac
                                    # tion considered due to direct binding to target?' , 'Is the measured interaction c
                                    # onsidered due to direct binding to target?' , 'Is the measured interaction conside
                                    # red due to direct binding to target?' , 'Is the measured interaction considered du
                                    # e to direct binding to target?' , 'Is the measured interaction considered due to d
                                    # irect binding to target?' , 'Is the measured interaction considered due to direct 
                                    # binding to target?'
                                    'relation': 'TEXT',
                                    # EXAMPLES:
                                    # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                                    'standard_relation': 'TEXT',
                                    # EXAMPLES:
                                    # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                                    'standard_text_value': 'TEXT',
                                    # EXAMPLES:
                                    # 'Oral' , 'Intraperitoneal' , 'Intraperitoneal' , 'Intraperitoneal' , 'Oral' , 'Int
                                    # raperitoneal' , 'Intraperitoneal' , 'Intraperitoneal' , 'Oral' , 'Oral'
                                    'standard_type': 'TEXT',
                                    # EXAMPLES:
                                    # 'DOSE' , 'DOSE' , 'ROUTE' , 'DOSE' , 'DOSE' , 'ROUTE' , 'ROUTE' , 'DOSE' , 'DOSE' 
                                    # , 'DOSE'
                                    'standard_type_fixed': 'NUMERIC',
                                    # EXAMPLES:
                                    # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                                    'standard_units': 'TEXT',
                                    # EXAMPLES:
                                    # 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' 
                                    # , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1'
                                    'standard_value': 'NUMERIC',
                                    # EXAMPLES:
                                    # '100.0' , '50.0' , '100.0' , '25.0' , '50.0' , '100.0' , '200.0' , '10.0' , '2.0' 
                                    # , '3.0'
                                    'text_value': 'TEXT',
                                    # EXAMPLES:
                                    # 'Oral' , 'Intraperitoneal' , 'Intraperitoneal' , 'Intraperitoneal' , 'Oral' , 'Int
                                    # raperitoneal' , 'Intraperitoneal' , 'Intraperitoneal' , 'Oral' , 'Oral'
                                    'type': 'TEXT',
                                    # EXAMPLES:
                                    # 'DOSE' , 'DOSE' , 'ROUTE' , 'DOSE' , 'DOSE' , 'ROUTE' , 'ROUTE' , 'DOSE' , 'DOSE' 
                                    # , 'DOSE'
                                    'units': 'TEXT',
                                    # EXAMPLES:
                                    # 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'm
                                    # g/kg' , 'mg/kg'
                                    'value': 'NUMERIC',
                                    # EXAMPLES:
                                    # '100.0' , '50.0' , '100.0' , '25.0' , '50.0' , '100.0' , '200.0' , '10.0' , '2.0' 
                                    # , '3.0'
                                }
                            },
                            'assay_strain': 'TEXT',
                            # EXAMPLES:
                            # 'MTCC 277' , 'MTCC 277' , 'ATCC 22019' , 'DSMZ 737' , 'MTCC 277' , 'albino Wistar' , 'albi
                            # no Wistar' , 'albino Wistar' , 'ICR' , 'ICR'
                            'assay_subcellular_fraction': 'TEXT',
                            # EXAMPLES:
                            # 'Microsome' , 'Microsome' , 'Microsome' , 'Microsome' , 'Microsome' , 'Microsome' , 'Micro
                            # some' , 'Ribosome' , 'S9 fraction' , 'Microsome'
                            'assay_tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '5833' , '9606' , '9606' , '10116' , '9606' , '10090' , '9606' , '9606' , '9606' , '9606'
                            'assay_tissue': 'TEXT',
                            # EXAMPLES:
                            # 'Aorta' , 'Plasma' , 'Stomach' , 'Aorta' , 'Aorta' , 'Tail' , 'Liver' , 'Plasma' , 'Liver'
                            #  , 'Cardiac atrium'
                            'assay_type': 'TEXT',
                            # EXAMPLES:
                            # 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'F'
                            'cell_chembl_id': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3307672' , 'CHEMBL3307716' , 'CHEMBL3307960' , 'CHEMBL3307960' , 'CHEMBL3307715' , 
                            # 'CHEMBL3308403' , 'CHEMBL3308091' , 'CHEMBL3307651' , 'CHEMBL3307715' , 'CHEMBL3307626'
                            'src_desc': 'TEXT',
                            # EXAMPLES:
                            # 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific 
                            # Literature' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature' 
                            # , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature'
                            'src_id': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                            'tissue_chembl_id': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3638186' , 'CHEMBL3559721' , 'CHEMBL3638185' , 'CHEMBL3638186' , 'CHEMBL3638186' , 
                            # 'CHEMBL3833541' , 'CHEMBL3559723' , 'CHEMBL3559721' , 'CHEMBL3559723' , 'CHEMBL3638237'
                            'type_label': 'TEXT',
                            # EXAMPLES:
                            # 'B - Binding' , 'B - Binding' , 'B - Binding' , 'B - Binding' , 'B - Binding' , 'B - Bindi
                            # ng' , 'B - Binding' , 'B - Binding' , 'B - Binding' , 'F - Functional'
                        }
                    },
                    'document_data': 
                    {
                        'properties': 
                        {
                            'first_page': 'NUMERIC',
                            # EXAMPLES:
                            # '3228' , '2396' , '3356' , '4351' , '2396' , '4351' , '3356' , '3356' , '3356' , '3356'
                            'pubmed_id': 'NUMERIC',
                            # EXAMPLES:
                            # '20434817' , '20202722' , '20430619' , '20483621' , '20202722' , '20483621' , '20430619' ,
                            #  '20430619' , '20430619' , '20430619'
                            'volume': 'NUMERIC',
                            # EXAMPLES:
                            # '45' , '45' , '20' , '18' , '45' , '18' , '20' , '20' , '20' , '20'
                            'year': 'NUMERIC',
                            # EXAMPLES:
                            # '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010'
                        }
                    },
                    'organism_taxonomy': 
                    {
                        'properties': 
                        {
                            'l1': 'TEXT',
                            # EXAMPLES:
                            # 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 
                            # 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes'
                            'l2': 'TEXT',
                            # EXAMPLES:
                            # 'Apicomplexa' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia
                            # ' , 'Mammalia' , 'Mammalia' , 'Mammalia'
                            'l3': 'TEXT',
                            # EXAMPLES:
                            # 'Plasmodium' , 'Primates' , 'Primates' , 'Primates' , 'Primates' , 'Primates' , 'Primates'
                            #  , 'Primates' , 'Rodentia' , 'Rodentia'
                            'oc_id': 'NUMERIC',
                            # EXAMPLES:
                            # '19' , '7' , '7' , '7' , '7' , '7' , '7' , '7' , '42' , '35'
                            'tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '5833' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '10116' , '10090'
                        }
                    },
                    'parent_molecule_data': 
                    {
                        'properties': 
                        {
                            'alogp': 'NUMERIC',
                            # EXAMPLES:
                            # '6.45' , '-0.60' , '5.58' , '6.10' , '-0.72' , '6.10' , '5.43' , '5.58' , '5.58' , '5.43'
                            'compound_key': 'TEXT',
                            # EXAMPLES:
                            # '2a' , '12' , '7f' , '5l' , '25' , '5l' , '7g' , '7f' , '7f' , '7g'
                            'full_mwt': 'NUMERIC',
                            # EXAMPLES:
                            # '717.17' , '272.31' , '468.60' , '545.01' , '202.24' , '545.01' , '468.60' , '468.60' , '4
                            # 68.60' , '468.60'
                            'image_file': 'TEXT',
                            # EXAMPLES:
                            # 'unknown.svg' , 'metalContaining.svg' , 'metalContaining.svg' , 'metalContaining.svg' , 'u
                            # nknown.svg' , 'metalContaining.svg' , 'metalContaining.svg' , 'metalContaining.svg' , 'met
                            # alContaining.svg' , 'metalContaining.svg'
                            'max_phase': 'NUMERIC',
                            # EXAMPLES:
                            # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                            'num_ro5_violations': 'NUMERIC',
                            # EXAMPLES:
                            # '2' , '0' , '1' , '2' , '0' , '2' , '1' , '1' , '1' , '1'
                            'psa': 'NUMERIC',
                            # EXAMPLES:
                            # '126.40' , '116.65' , '61.08' , '57.70' , '97.11' , '57.70' , '61.08' , '61.08' , '61.08' 
                            # , '61.08'
                        }
                    },
                    'protein_classification': 
                    {
                        'properties': 
                        {
                            'l1': 'TEXT',
                            # EXAMPLES:
                            # 'Enzyme' , 'Enzyme' , 'Enzyme' , 'Enzyme' , 'Enzyme' , 'Enzyme' , 'Enzyme' , 'Enzyme' , 'E
                            # nzyme' , 'Enzyme'
                            'l2': 'TEXT',
                            # EXAMPLES:
                            # 'Protease' , 'Lyase' , 'Kinase' , 'Kinase' , 'Lyase' , 'Kinase' , 'Kinase' , 'Kinase' , 'K
                            # inase' , 'Protease'
                            'l3': 'TEXT',
                            # EXAMPLES:
                            # 'Cysteine protease' , 'Protein Kinase' , 'Protein Kinase' , 'Protein Kinase' , 'Protein Ki
                            # nase' , 'Protein Kinase' , 'Protein Kinase' , 'Aspartic protease' , 'Aspartic protease' , 
                            # 'Aspartic protease'
                            'l4': 'TEXT',
                            # EXAMPLES:
                            # 'Cysteine protease CA clan' , 'CAMK protein kinase group' , 'TK protein kinase group' , 'T
                            # KL protein kinase group' , 'STE protein kinase group' , 'TK protein kinase group' , 'Atypi
                            # cal protein kinase group' , 'Aspartic protease AA clan' , 'Aspartic protease AA clan' , 'A
                            # spartic protease AA clan'
                            'l5': 'TEXT',
                            # EXAMPLES:
                            # 'Cysteine protease C1A family' , 'CAMK protein kinase CAMK1 family' , 'Tyrosine protein ki
                            # nase PDGFR family' , 'TKL protein kinase LISK family' , 'STE protein kinase STE7 family' ,
                            #  'Tyrosine protein kinase VEGFR family' , 'Atypical protein kinase RIO family' , 'Aspartic
                            #  protease A1A subfamily' , 'Aspartic protease A1A subfamily' , 'Aspartic protease A1A subf
                            # amily'
                            'l6': 'TEXT',
                            # EXAMPLES:
                            # 'CAMK protein kinase CHK1 subfamily' , 'TKL protein kinase LIMK subfamily' , 'Atypical pro
                            # tein kinase RIO1 subfamily' , 'AGC protein kinase ROCK subfamily' , 'AGC protein kinase RO
                            # CK subfamily' , 'AGC protein kinase ROCK subfamily' , 'CAMK protein kinase LKB subfamily' 
                            # , 'AGC protein kinase ROCK subfamily' , 'AGC protein kinase ROCK subfamily' , 'AGC protein
                            #  kinase ROCK subfamily'
                            'protein_class_id': 'NUMERIC',
                            # EXAMPLES:
                            # '50' , '648' , '411' , '159' , '648' , '348' , '298' , '160' , '437' , '47'
                        }
                    },
                    'source': 
                    {
                        'properties': 
                        {
                            'src_description': 'TEXT',
                            # EXAMPLES:
                            # 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific 
                            # Literature' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature' 
                            # , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature'
                            'src_id': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                            'src_short_name': 'TEXT',
                            # EXAMPLES:
                            # 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 
                            # 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE'
                        }
                    },
                    'target_data': 
                    {
                        'properties': 
                        {
                            'target_type': 'TEXT',
                            # EXAMPLES:
                            # 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEI
                            # N' , 'SINGLE PROTEIN' , 'UNCHECKED' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'TISSUE'
                        }
                    }
                }
            },
            'activity_comment': 'TEXT',
            # EXAMPLES:
            # 'Not Active' , 'Not Active' , 'Not Active' , 'Not Determined' , 'Not Determined' , 'Not Active' , 'Not Act
            # ive' , 'Non-toxic' , 'Non-toxic' , 'Not Active'
            'activity_id': 'NUMERIC',
            # EXAMPLES:
            # '3348135' , '3345136' , '3308373' , '3339149' , '3345211' , '3339152' , '3308378' , '3308381' , '3308387' 
            # , '3308390'
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
                    # 'MCV (Ery. Mean Corpuscular Volume)' , 'CAPSULE, THROMBUS' , 'PROT (Protein)' , 'NEUTLE (Neutrophi
                    # ls/Leukocytes)' , 'LYMLE (Lymphocytes/Leukocytes)' , 'ALB (Albumin)' , 'LYM (Lymphocytes)' , 'HEPA
                    # TOCYTE, CENTRILOBULAR, LIPID ACCUMULATION, MACROVESICULAR' , 'CAPSULE, INFLAMMATORY CELL INFILTRAT
                    # E, MIXED CELL' , 'HEPATOCYTE, CENTRILOBULAR, NECROSIS, ONCOCYTIC'
                    'standard_type': 'TEXT',
                    # EXAMPLES:
                    # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVIT
                    # Y_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                    'standard_units': 'TEXT',
                    # EXAMPLES:
                    # 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg'
                    'standard_value': 'NUMERIC',
                    # EXAMPLES:
                    # '600.0' , '1170.0' , '0.0' , '4.2' , '375.0' , '4.2' , '0.0' , '1170.0' , '7.5' , '1170.0'
                    'text_value': 'TEXT',
                    # EXAMPLES:
                    # 'MCV (Ery. Mean Corpuscular Volume)' , 'CAPSULE, THROMBUS' , 'PROT (Protein)' , 'NEUTLE (Neutrophi
                    # ls/Leukocytes)' , 'LYMLE (Lymphocytes/Leukocytes)' , 'ALB (Albumin)' , 'LYM (Lymphocytes)' , 'HEPA
                    # TOCYTE, CENTRILOBULAR, LIPID ACCUMULATION, MACROVESICULAR' , 'CAPSULE, INFLAMMATORY CELL INFILTRAT
                    # E, MIXED CELL' , 'HEPATOCYTE, CENTRILOBULAR, NECROSIS, ONCOCYTIC'
                    'type': 'TEXT',
                    # EXAMPLES:
                    # 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVIT
                    # Y_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST' , 'ACTIVITY_TEST'
                    'units': 'TEXT',
                    # EXAMPLES:
                    # 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg' , 'mg/Kg'
                    'value': 'NUMERIC',
                    # EXAMPLES:
                    # '600.0' , '1170.0' , '0.0' , '4.2' , '375.0' , '4.2' , '0.0' , '1170.0' , '7.5' , '1170.0'
                }
            },
            'assay_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1175064' , 'CHEMBL1167307' , 'CHEMBL1119647' , 'CHEMBL1166043' , 'CHEMBL1167310' , 'CHEMBL1166048' 
            # , 'CHEMBL1119649' , 'CHEMBL1119651' , 'CHEMBL1119653' , 'CHEMBL1119654'
            'assay_description': 'TEXT',
            # EXAMPLES:
            # 'Inhibition of Plasmodium falciparum falcipain-2 after 10 to 15 min' , 'Inhibition of human cloned carboni
            # c anhydrase 2 preincubated for 15 mins by stopped flow CO2 hydration assay' , 'Inhibition of CHK1 at 3 uM'
            #  , 'Inhibition of KIT V559D,V654A mutant at 1 uM' , 'Inhibition of human full length carbonic anhydrase 14
            #  catalytic domain preincubated for 15 mins by stopped flow CO2 hydration assay' , 'Inhibition of LIMK2 at 
            # 1 uM' , 'Inhibition of JNK at 3 uM' , 'Inhibition of MEK1 at 3 uM' , 'Inhibition of VEGFR3 at 3 uM' , 'Ex 
            # vivo antiangiogenic activity in rat aortic ring assessed as inhibition of VEGF-stimulated microvessel grow
            # th'
            'assay_type': 'TEXT',
            # EXAMPLES:
            # 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'B' , 'F'
            'bao_endpoint': 'TEXT',
            # EXAMPLES:
            # 'BAO_0000192' , 'BAO_0000192' , 'BAO_0000376' , 'BAO_0000201' , 'BAO_0000192' , 'BAO_0000201' , 'BAO_00003
            # 76' , 'BAO_0000376' , 'BAO_0000190' , 'BAO_0000188'
            'bao_format': 'TEXT',
            # EXAMPLES:
            # 'BAO_0000357' , 'BAO_0000357' , 'BAO_0000357' , 'BAO_0000019' , 'BAO_0000357' , 'BAO_0000357' , 'BAO_00000
            # 19' , 'BAO_0000357' , 'BAO_0000357' , 'BAO_0000221'
            'bao_label': 'TEXT',
            # EXAMPLES:
            # 'single protein format' , 'single protein format' , 'single protein format' , 'assay format' , 'single pro
            # tein format' , 'single protein format' , 'assay format' , 'single protein format' , 'single protein format
            # ' , 'tissue-based format'
            'canonical_smiles': 'TEXT',
            # EXAMPLES:
            # 'CC(C)(C)S[C@H]1OC(=O)C[C@@H]1NC(=O)CN1C(=O)[C@@H](COC(=O)Nc2ccc(Cl)cc2C(F)(F)F)N=C(c2ccccc2)c2ccccc21' , 
            # 'Cn1nnnc1Sc1ccncc1S(N)(=O)=O' , 'CCCCn1c2ccc(C3CCCCO3)cc2c2c3c(c4c(c21)CCc1nn(C)cc1-4)C(=O)NC3' , 'COC1CCN
            # (C(=O)c2ccc(-c3cnc4c(c3)N(Cc3cc(Cl)ccc3C(F)(F)F)CCN4)cc2)CC1' , 'CNNc1ccncc1S(N)(=O)=O' , 'COC1CCN(C(=O)c2
            # ccc(-c3cnc4c(c3)N(Cc3cc(Cl)ccc3C(F)(F)F)CCN4)cc2)CC1' , 'CC(C)Cn1c2ccc(C3CCCCO3)cc2c2c3c(c4c(c21)CCc1nn(C)
            # cc1-4)C(=O)NC3' , 'CCCCn1c2ccc(C3CCCCO3)cc2c2c3c(c4c(c21)CCc1nn(C)cc1-4)C(=O)NC3' , 'CCCCn1c2ccc(C3CCCCO3)
            # cc2c2c3c(c4c(c21)CCc1nn(C)cc1-4)C(=O)NC3' , 'CC(C)Cn1c2ccc(C3CCCCO3)cc2c2c3c(c4c(c21)CCc1nn(C)cc1-4)C(=O)N
            # C3'
            'data_validity_comment': 'TEXT',
            # EXAMPLES:
            # 'Non standard unit for type' , 'Outside typical range' , 'Outside typical range' , 'Non standard unit for 
            # type' , 'Non standard unit for type' , 'Non standard unit for type' , 'Outside typical range' , 'Outside t
            # ypical range' , 'Outside typical range' , 'Non standard unit for type'
            'data_validity_description': 'TEXT',
            # EXAMPLES:
            # 'Units for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)' , 
            # 'Values for this activity type are unusually large/small, so may not be accurate' , 'Values for this activ
            # ity type are unusually large/small, so may not be accurate' , 'Units for this activity type are unusual an
            # d may be incorrect (or the standard_type may be incorrect)' , 'Units for this activity type are unusual an
            # d may be incorrect (or the standard_type may be incorrect)' , 'Units for this activity type are unusual an
            # d may be incorrect (or the standard_type may be incorrect)' , 'Values for this activity type are unusually
            #  large/small, so may not be accurate' , 'Values for this activity type are unusually large/small, so may n
            # ot be accurate' , 'Values for this activity type are unusually large/small, so may not be accurate' , 'Uni
            # ts for this activity type are unusual and may be incorrect (or the standard_type may be incorrect)'
            'document_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1177889' , 'CHEMBL1165874' , 'CHEMBL1155474' , 'CHEMBL1165965' , 'CHEMBL1165874' , 'CHEMBL1165965' 
            # , 'CHEMBL1155474' , 'CHEMBL1155474' , 'CHEMBL1155474' , 'CHEMBL1155474'
            'document_journal': 'TEXT',
            # EXAMPLES:
            # 'Eur. J. Med. Chem.' , 'Eur. J. Med. Chem.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem.' , 'Eur. J.
            #  Med. Chem.' , 'Bioorg. Med. Chem.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. M
            # ed. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.'
            'document_year': 'NUMERIC',
            # EXAMPLES:
            # '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010' , '2010'
            'ligand_efficiency': 
            {
                'properties': 
                {
                    'bei': 'NUMERIC',
                    # EXAMPLES:
                    # '7.09' , '26.95' , '34.71' , '17.71' , '8.15' , '8.30' , '27.28' , '7.34' , '6.60' , '22.44'
                    'le': 'NUMERIC',
                    # EXAMPLES:
                    # '0.14' , '0.59' , '0.74' , '0.32' , '0.16' , '0.16' , '0.58' , '0.14' , '0.12' , '0.41'
                    'lle': 'NUMERIC',
                    # EXAMPLES:
                    # '-1.36' , '7.94' , '7.74' , '2.72' , '1.78' , '0.83' , '5.39' , '0.37' , '-1.01' , '4.28'
                    'sei': 'NUMERIC',
                    # EXAMPLES:
                    # '4.02' , '6.29' , '7.23' , '13.59' , '3.71' , '4.15' , '6.24' , '3.77' , '3.49' , '19.18'
                }
            },
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1171866' , 'CHEMBL1165072' , 'CHEMBL1082829' , 'CHEMBL1163567' , 'CHEMBL1164878' , 'CHEMBL1163567' 
            # , 'CHEMBL1084337' , 'CHEMBL1082829' , 'CHEMBL1082829' , 'CHEMBL1084337'
            'molecule_pref_name': 'TEXT',
            # EXAMPLES:
            # 'TOPOTECAN' , 'STREPTOMYCIN' , 'GRISEOFULVIN' , 'OLEIC ACID' , 'O-Chloroacetylcarbamoylfumagillol' , 'PACL
            # ITAXEL' , 'XANTHOHUMOL' , 'CEFTRIAXONE' , 'VORINOSTAT' , 'ASCIDIDEMIN'
            'parent_molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1171866' , 'CHEMBL1165072' , 'CHEMBL1082829' , 'CHEMBL1163567' , 'CHEMBL1164878' , 'CHEMBL1163567' 
            # , 'CHEMBL1084337' , 'CHEMBL1082829' , 'CHEMBL1082829' , 'CHEMBL1084337'
            'pchembl_value': 'NUMERIC',
            # EXAMPLES:
            # '5.09' , '7.34' , '7.02' , '8.30' , '9.05' , '5.09' , '5.96' , '4.48' , '5.13' , '4.53'
            'potential_duplicate': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'qudt_units': 'TEXT',
            # EXAMPLES:
            # 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://qudt.o
            # rg/vocab/unit#Percent' , 'http://www.openphacts.org/units/Nanomolar' , 'http://qudt.org/vocab/unit#Percent
            # ' , 'http://www.openphacts.org/units/Nanomolar' , 'http://www.openphacts.org/units/Nanomolar' , 'http://qu
            # dt.org/vocab/unit#Percent' , 'http://www.openphacts.org/units/Nanomolar' , 'http://qudt.org/vocab/unit#Per
            # cent'
            'record_id': 'NUMERIC',
            # EXAMPLES:
            # '923038' , '920133' , '914556' , '918806' , '920215' , '918806' , '914635' , '914556' , '914556' , '914635
            # '
            'relation': 'TEXT',
            # EXAMPLES:
            # '=' , '=' , '<' , '=' , '<' , '=' , '=' , '=' , '=' , '<'
            'src_id': 'NUMERIC',
            # EXAMPLES:
            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            'standard_flag': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'False' , 'True' , 'True' , 'True' , 'False' , 'False' , 'True' , 'True'
            'standard_relation': 'TEXT',
            # EXAMPLES:
            # '=' , '=' , '<' , '=' , '<' , '=' , '=' , '=' , '=' , '<'
            'standard_text_value': 'TEXT',
            # EXAMPLES:
            # 'Active' , 'Active' , 'Not Active' , 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'A
            # ctive' , 'Not Active'
            'standard_type': 'TEXT',
            # EXAMPLES:
            # 'Ki' , 'Ki' , 'Inhibition' , 'Inhibition' , 'Ki' , 'Inhibition' , 'Inhibition' , 'Inhibition' , 'IC50' , '
            # EC50'
            'standard_units': 'TEXT',
            # EXAMPLES:
            # 'nM' , 'nM' , '%' , 'nM' , '%' , 'nM' , 'nM' , '%' , 'nM' , '%'
            'standard_value': 'NUMERIC',
            # EXAMPLES:
            # '8200.0' , '45.8' , '50.0' , '95.7' , '50.0' , '5.0' , '0.9' , '58.0' , '12100.0' , '50.0'
            'target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL5800' , 'CHEMBL205' , 'CHEMBL4630' , 'CHEMBL1936' , 'CHEMBL3510' , 'CHEMBL5932' , 'CHEMBL612545' , 
            # 'CHEMBL3587' , 'CHEMBL1955' , 'CHEMBL613606'
            'target_organism': 'TEXT',
            # EXAMPLES:
            # 'Plasmodium falciparum' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapien
            # s' , 'Homo sapiens' , 'Homo sapiens' , 'Rattus norvegicus' , 'Mus musculus'
            'target_pref_name': 'TEXT',
            # EXAMPLES:
            # 'Falcipain 2' , 'Carbonic anhydrase II' , 'Serine/threonine-protein kinase Chk1' , 'Stem cell growth facto
            # r receptor' , 'Carbonic anhydrase XIV' , 'LIM domain kinase 2' , 'Unchecked' , 'Dual specificity mitogen-a
            # ctivated protein kinase kinase 1' , 'Vascular endothelial growth factor receptor 3' , 'Aorta'
            'target_tax_id': 'NUMERIC',
            # EXAMPLES:
            # '5833' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '10116' , '10090'
            'text_value': 'TEXT',
            # EXAMPLES:
            # 'Active' , 'Active' , 'Not Active' , 'Active' , 'Not Active' , 'Not Active' , 'Not Active' , 'Active' , 'A
            # ctive' , 'Not Active'
            'toid': 'NUMERIC',
            # EXAMPLES:
            # '13074' , '9935' , '13083' , '13409' , '13240' , '13410' , '13085' , '9935' , '9654' , '9935'
            'type': 'TEXT',
            # EXAMPLES:
            # 'Ki' , 'Ki' , 'INH' , 'INH' , 'Ki' , 'INH' , 'INH' , 'INH' , 'IC50' , 'EC50'
            'units': 'TEXT',
            # EXAMPLES:
            # 'uM' , 'nM' , '%' , 'nM' , '%' , 'nM' , 'nM' , '%' , 'nM' , '%'
            'uo_units': 'TEXT',
            # EXAMPLES:
            # 'UO_0000065' , 'UO_0000065' , 'UO_0000187' , 'UO_0000065' , 'UO_0000187' , 'UO_0000065' , 'UO_0000065' , '
            # UO_0000187' , 'UO_0000065' , 'UO_0000187'
            'upper_value': 'NUMERIC',
            # EXAMPLES:
            # '5.0' , '0.06' , '3.54' , '0.47' , '27.4' , '66.0' , '100.0' , '8.0' , '8.89' , '3.1'
            'value': 'NUMERIC',
            # EXAMPLES:
            # '8.2' , '45.8' , '50.0' , '95.7' , '50.0' , '5.0' , '0.9' , '58.0' , '12100.0' , '50.0'
        }
    }

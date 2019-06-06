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
                '_metadata': 
                {
                    'properties': 
                    {
                        'es_completion': 'TEXT',
                        # EXAMPLES:
                        # '{'weight': 10, 'input': 'CHEMBL626547'}' , '{'weight': 10, 'input': 'BAO_0000019'}' , '{'weig
                        # ht': 30, 'input': 'Rattus norvegicus'}' , '{'weight': 10, 'input': 'BAO_0000100'}' , '{'weight
                        # ': 10, 'input': 'CHEMBL1133614'}' , '{'weight': 10, 'input': 'CHEMBL639051'}' , '{'weight': 10
                        # , 'input': 'BAO_0000019'}' , '{'weight': 10, 'input': 'BAO_0000100'}' , '{'weight': 80, 'input
                        # ': 'Biodistribution after 1 hour of postinjection in blood'}' , '{'weight': 10, 'input': 'CHEM
                        # BL639052'}'
                    }
                },
                'assay_category': 'TEXT',
                # EXAMPLES:
                # 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 
                # 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory'
                'assay_cell_type': 'TEXT',
                # EXAMPLES:
                # 'HeLa' , 'HeLa' , 'HeLa' , 'CHO' , 'CCRF S-180' , 'CHO' , 'CCRF S-180' , 'CCRF S-180' , 'CCRF S-180' ,
                #  'NG 108-15'
                'assay_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL626547' , 'CHEMBL615627' , 'CHEMBL626548' , 'CHEMBL876617' , 'CHEMBL874503' , 'CHEMBL639051' , 
                # 'CHEMBL627509' , 'CHEMBL633640' , 'CHEMBL640971' , 'CHEMBL639052'
                'assay_classifications': 
                {
                    'properties': 
                    {
                        'assay_class_id': 'NUMERIC',
                        # EXAMPLES:
                        # '216' , '322' , '322' , '85' , '115' , '115' , '85' , '115' , '115' , '210'
                        'class_type': 'TEXT',
                        # EXAMPLES:
                        # 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo e
                        # fficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' ,
                        #  'In vivo efficacy'
                        'l1': 'TEXT',
                        # EXAMPLES:
                        # 'CARDIOVASCULAR SYSTEM' , 'NERVOUS SYSTEM' , 'NERVOUS SYSTEM' , 'ANTINEOPLASTIC AND IMMUNOMODU
                        # LATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODU
                        # LATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODU
                        # LATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'CARDIOVASCULAR SYSTEM'
                        'l2': 'TEXT',
                        # EXAMPLES:
                        # 'Inhibition of Cholesterol Absorption' , 'Anti-Depressant Activity' , 'Anti-Depressant Activit
                        # y' , 'Carcinoma Oncology Models' , 'Neoplasm Oncology Models' , 'Neoplasm Oncology Models' , '
                        # Carcinoma Oncology Models' , 'Neoplasm Oncology Models' , 'Neoplasm Oncology Models' , 'Influe
                        # nce on Lipid Metabolism'
                        'l3': 'TEXT',
                        # EXAMPLES:
                        # 'General Cholesterol Activity' , 'General Hypothermia' , 'General Hypothermia' , 'Non Small Ce
                        # ll Lung Carcinoma' , 'Neoplasms' , 'Neoplasms' , 'Non Small Cell Lung Carcinoma' , 'Neoplasms'
                        #  , 'Neoplasms' , 'General Lipid Metabolism'
                    }
                },
                'assay_organism': 'TEXT',
                # EXAMPLES:
                # 'Rattus norvegicus' , 'Cavia porcellus' , 'Rattus norvegicus' , 'Rattus norvegicus' , 'Rattus norvegic
                # us' , 'Rattus norvegicus' , 'Canis lupus familiaris' , 'Rattus norvegicus' , 'Canis lupus familiaris' 
                # , 'Homo sapiens'
                'assay_parameters': 
                {
                    'properties': 
                    {
                        'active': 'NUMERIC',
                        # EXAMPLES:
                        # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                        'comments': 'TEXT',
                        # EXAMPLES:
                        # 'Is the measured interaction considered due to direct binding to target?' , 'Is the measured i
                        # nteraction considered due to direct binding to target?' , 'Is the measured interaction conside
                        # red due to direct binding to target?' , 'Is the measured interaction considered due to direct 
                        # binding to target?' , 'Is the measured interaction considered due to direct binding to target?
                        # ' , 'Is the measured interaction considered due to direct binding to target?' , 'Is the measur
                        # ed interaction considered due to direct binding to target?' , 'Is the measured interaction con
                        # sidered due to direct binding to target?' , 'Is the measured interaction considered due to dir
                        # ect binding to target?' , 'Is the measured interaction considered due to direct binding to tar
                        # get?'
                        'relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_text_value': 'TEXT',
                        # EXAMPLES:
                        # 'Intravenous' , 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Intravenous' , 'Intravenous' , '
                        # Intravenous' , 'Oral'
                        'standard_type': 'TEXT',
                        # EXAMPLES:
                        # 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                        'standard_type_fixed': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'standard_units': 'TEXT',
                        # EXAMPLES:
                        # 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' 
                        # , 'mg.kg-1' , 'mg.kg-1'
                        'standard_value': 'NUMERIC',
                        # EXAMPLES:
                        # '5' , '2' , '30' , '10' , '10' , '2' , '40' , '30' , '1' , '4'
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'Intravenous' , 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Intravenous' , 'Intravenous' , '
                        # Intravenous' , 'Oral'
                        'type': 'TEXT',
                        # EXAMPLES:
                        # 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                        'units': 'TEXT',
                        # EXAMPLES:
                        # 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/
                        # kg'
                        'value': 'NUMERIC',
                        # EXAMPLES:
                        # '5' , '2' , '30' , '10' , '10' , '2' , '40' , '30' , '1' , '4'
                    }
                },
                'assay_strain': 'TEXT',
                # EXAMPLES:
                # 'oka' , 'nigeriensis' , 'nigeriensis' , 'K1' , 'tk-07' , 'oka' , 'nigeriensis' , 'nigeriensis' , 'nige
                # riensis' , 'nigeriensis'
                'assay_subcellular_fraction': 'TEXT',
                # EXAMPLES:
                # 'Membrane' , 'Mitochondria' , 'Microsome' , 'S9 fraction' , 'S9 fraction' , 'S9 fraction' , 'Microsome
                # ' , 'Mitochondria' , 'Brain membranes' , 'Membrane'
                'assay_tax_id': 'NUMERIC',
                # EXAMPLES:
                # '10116' , '10141' , '10116' , '10116' , '10116' , '10116' , '9615' , '10116' , '9615' , '9606'
                'assay_test_type': 'TEXT',
                # EXAMPLES:
                # 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vi
                # vo' , 'In vivo'
                'assay_tissue': 'TEXT',
                # EXAMPLES:
                # 'Thalamus' , 'Blood' , 'Brain' , 'Feces' , 'Kidney' , 'Plasma' , 'Plasma' , 'Muscle tissue' , 'Spleen'
                #  , 'Cerebral cortex'
                'assay_type': 'TEXT',
                # EXAMPLES:
                # 'A' , 'F' , 'A' , 'P' , 'A' , 'B' , 'A' , 'P' , 'A' , 'B'
                'assay_type_description': 'TEXT',
                # EXAMPLES:
                # 'ADME' , 'Functional' , 'ADME' , 'Physicochemical' , 'ADME' , 'Binding' , 'ADME' , 'Physicochemical' ,
                #  'ADME' , 'Binding'
                'bao_format': 'TEXT',
                # EXAMPLES:
                # 'BAO_0000218' , 'BAO_0000019' , 'BAO_0000218' , 'BAO_0000100' , 'BAO_0000218' , 'BAO_0000357' , 'BAO_0
                # 000019' , 'BAO_0000100' , 'BAO_0000218' , 'BAO_0000357'
                'bao_label': 'TEXT',
                # EXAMPLES:
                # 'organism-based format' , 'assay format' , 'organism-based format' , 'small-molecule physicochemical f
                # ormat' , 'organism-based format' , 'single protein format' , 'assay format' , 'small-molecule physicoc
                # hemical format' , 'organism-based format' , 'single protein format'
                'cell_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3308376' , 'CHEMBL3308376' , 'CHEMBL3308376' , 'CHEMBL3308072' , 'CHEMBL3307278' , 'CHEMBL33080
                # 72' , 'CHEMBL3307278' , 'CHEMBL3307278' , 'CHEMBL3307278' , 'CHEMBL3307651'
                'confidence_description': 'TEXT',
                # EXAMPLES:
                # 'Target assigned is non-molecular' , 'Homologous single protein target assigned' , 'Target assigned is
                #  non-molecular' , 'Default value - Target unknown or has yet to be assigned' , 'Target assigned is non
                # -molecular' , 'Homologous single protein target assigned' , 'Default value - Target unknown or has yet
                #  to be assigned' , 'Default value - Target unknown or has yet to be assigned' , 'Default value - Targe
                # t unknown or has yet to be assigned' , 'Homologous single protein target assigned'
                'confidence_score': 'NUMERIC',
                # EXAMPLES:
                # '1' , '8' , '1' , '0' , '1' , '8' , '0' , '0' , '0' , '8'
                'description': 'TEXT',
                # EXAMPLES:
                # 'Pharmacokinetic parameter area under curve was reported' , 'Inhibition of [14C]arachidonic acid conve
                # rsion to 5-HETE by broken cell 5-LO isolated from guinea pig PMN; not active at the highest concentrat
                # ion (3 ug/mL) tested; No activity' , 'Pharmacokinetic property (AUC) in rat' , 'Solubility in phosphat
                # e buffer, tested as a HCl salt' , 'Biodistribution of radioactivity in rat thalamus upon Tail-Vein inj
                # ection of [11C]-labeled compound after 60 min' , 'Compound was tested for inhibition against human acr
                # osin and control activity being 11.3 umol/min/mg; No data' , 'Effect of pH on carbamate hydrolysis in 
                # 0.05 M buffer concentration at the pH 5.0, 25 degree C.' , 'Solubility in saline' , 'Biodistribution a
                # fter 1 hour of postinjection in blood' , 'Compound was tested for inhibition of Human acrosin by aldoh
                # exoses'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1135072' , 'CHEMBL1126332' , 'CHEMBL1134422' , 'CHEMBL1123133' , 'CHEMBL1133614' , 'CHEMBL11231
                # 55' , 'CHEMBL1124794' , 'CHEMBL1131746' , 'CHEMBL1133774' , 'CHEMBL1121739'
                'relationship_description': 'TEXT',
                # EXAMPLES:
                # 'Non-molecular target assigned' , 'Homologous protein target assigned' , 'Non-molecular target assigne
                # d' , 'Default value - Target has yet to be curated' , 'Non-molecular target assigned' , 'Homologous pr
                # otein target assigned' , 'Default value - Target has yet to be curated' , 'Default value - Target has 
                # yet to be curated' , 'Default value - Target has yet to be curated' , 'Homologous protein target assig
                # ned'
                'relationship_type': 'TEXT',
                # EXAMPLES:
                # 'N' , 'H' , 'N' , 'U' , 'N' , 'H' , 'U' , 'U' , 'U' , 'H'
                'src_assay_id': 'NUMERIC',
                # EXAMPLES:
                # '506980' , '533665' , '503053' , '515022' , '503051' , '517112' , '503050' , '515019' , '517111' , '50
                # 3131'
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL376' , 'CHEMBL215' , 'CHEMBL376' , 'CHEMBL2362975' , 'CHEMBL376' , 'CHEMBL2738' , 'CHEMBL612558
                # ' , 'CHEMBL2362975' , 'CHEMBL612558' , 'CHEMBL2738'
                'tissue_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3638280' , 'CHEMBL3638178' , 'CHEMBL3638188' , 'CHEMBL3638230' , 'CHEMBL3638241' , 'CHEMBL35597
                # 21' , 'CHEMBL3559721' , 'CHEMBL3638254' , 'CHEMBL3559722' , 'CHEMBL3559724'
            }
        }
    }

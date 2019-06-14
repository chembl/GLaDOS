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
                '_metadata':
                {
                    'properties':
                    {
                        'es_completion': DefaultMappings.COMPLETION_TYPE
                    }
                },
                'assay_category': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'other' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confir
                # matory' , 'confirmatory' , 'confirmatory' , 'confirmatory'
                'assay_classifications':
                {
                    'properties':
                    {
                        'assay_class_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # '115' , '259' , '322' , '280' , '91' , '91' , '91' , '91' , '91' , '91'
                        'class_type': DefaultMappings.LOWER_CASE_KEYWORD,
                        # EXAMPLES:
                        # 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo e
                        # fficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' ,
                        #  'In vivo efficacy'
                        'l1': DefaultMappings.LOWER_CASE_KEYWORD,
                        # EXAMPLES:
                        # 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'GENITO URINARY SYSTEM AND SEX HORMONES' , 'NER
                        # VOUS SYSTEM' , 'GENITO URINARY SYSTEM AND SEX HORMONES' , 'ANTINEOPLASTIC AND IMMUNOMODULATING
                        #  AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING
                        #  AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING
                        #  AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS'
                        'l2': DefaultMappings.LOWER_CASE_KEYWORD,
                        # EXAMPLES:
                        # 'Neoplasm Oncology Models' , 'Assessment of Renal Function' , 'Anti-Depressant Activity' , 'Te
                        # sticular Steroid Hormones' , 'Melanoma Oncology Models' , 'Melanoma Oncology Models' , 'Melano
                        # ma Oncology Models' , 'Melanoma Oncology Models' , 'Melanoma Oncology Models' , 'Melanoma Onco
                        # logy Models'
                        'l3': DefaultMappings.LOWER_CASE_KEYWORD,
                        # EXAMPLES:
                        # 'Neoplasms' , 'Fractional Excretion Methods' , 'General Hypothermia' , 'General Androgen Activ
                        # ity' , 'Experimental Melanoma' , 'Experimental Melanoma' , 'Experimental Melanoma' , 'Experime
                        # ntal Melanoma' , 'Experimental Melanoma' , 'Experimental Melanoma'
                    }
                },
                'assay_cell_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'P388' , 'P388' , 'P388' , 'CCRF-CEM' , 'P388' , 'P388' , 'P388' , 'L1210' , 'L1210' , 'L1210'
                'assay_chembl_id': DefaultMappings.CHEMBL_ID,
                # EXAMPLES:
                # 'CHEMBL723493' , 'CHEMBL723497' , 'CHEMBL723502' , 'CHEMBL723503' , 'CHEMBL723504' , 'CHEMBL723505' , 
                # 'CHEMBL723506' , 'CHEMBL723507' , 'CHEMBL723508' , 'CHEMBL723512'
                'assay_organism': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Mus musculus' , 'Mus musculus' , 'Mus musculus' , 'Mus musculus' , 'Mus musculus' , 'Mus musculus' , 
                # 'Mus musculus' , 'Mus musculus' , 'Mus musculus' , 'Mus musculus'
                'assay_parameters':
                {
                    'properties':
                    {
                        'active': DefaultMappings.SHORT,
                        # EXAMPLES:
                        # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                        'comments': DefaultMappings.LOWER_CASE_KEYWORD + DefaultMappings.TEXT_STD,
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
                        'relation': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_relation': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_text_value': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'Intravenous' , 'Intravenous' , 'Intravenous' , 'Intravenous' , 'Intraduodenal' , 'Intravenous
                        # ' , 'Intragastric' , 'Intraduodenal' , 'Oral' , 'Intravenous'
                        'standard_type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                        'standard_type_fixed': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'standard_units': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1'
                        # , 'mg.kg-1' , 'mg.kg-1'
                        'standard_value': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # '6.3' , '25' , '2.6' , '15' , '10' , '2.27' , '5.45' , '10' , '10' , '10'
                        'text_value': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'Intravenous' , 'Intravenous' , 'Intravenous' , 'Intravenous' , 'Intraduodenal' , 'Intravenous
                        # ' , 'Intragastric' , 'Intraduodenal' , 'Oral' , 'Intravenous'
                        'type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                        'units': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/
                        # kg'
                        'value': DefaultMappings.DOUBLE,
                        # EXAMPLES:
                        # '6.3' , '25' , '2.6' , '15' , '10' , '2.27' , '5.45' , '10' , '10' , '10'
                    }
                },
                'assay_strain': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '3B' , 'STIB900' , 'Sprague-Dawley' , 'Wistar' , 'Albino' , 'NMRI' , 'Swiss' , 'Swiss Albino' , 'Sprag
                # ue-Dawley' , 'V1/S'
                'assay_subcellular_fraction': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Microsomes' , 'Microsomes' , 'Microsomes' , 'Microsomes' , 'Microsomes' , 'Microsomes' , 'Microsomes'
                #  , 'Microsomes' , 'Membranes' , 'Membranes'
                'assay_tax_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '10090' , '10090' , '10090' , '10090' , '10090' , '10090' , '10090' , '10090' , '10090' , '10090'
                'assay_test_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vi
                # vo' , 'In vivo'
                'assay_tissue': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Plasma' , 'Blood' , 'Brain' , 'Uterus' , 'Spleen' , 'Spleen' , 'Stomach' , 'Stomach' , 'Lung' , 'Plas
                # ma'
                'assay_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F'
                'assay_type_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Functional' , 'Functional' , 'Functional' , 'Functional' , 'Functional' , 'Functional' , 'Functional'
                #  , 'Functional' , 'Functional' , 'Functional'
                'bao_format': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0
                # 000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218'
                'bao_label': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'assay format' , 'tissue-based format' , 'assay format' , 'cell membrane format' , 'assay format' , 't
                # issue-based format' , 'single protein format' , 'cell membrane format' , 'assay format' , 'tissue-base
                # d format'
                'cell_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL3308401' , 'CHEMBL3308401' , 'CHEMBL3308401' , 'CHEMBL3307641' , 'CHEMBL3308401' , 'CHEMBL33084
                # 01' , 'CHEMBL3308401' , 'CHEMBL3308391' , 'CHEMBL3308391' , 'CHEMBL3308391'
                'confidence_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Target assigned is non-molecular' , 'Target assigned is non-molecular' , 'Target assigned is non-mole
                # cular' , 'Target assigned is non-molecular' , 'Target assigned is non-molecular' , 'Target assigned is
                #  non-molecular' , 'Target assigned is non-molecular' , 'Target assigned is non-molecular' , 'Target as
                # signed is non-molecular' , 'Target assigned is non-molecular'
                'confidence_score': DefaultMappings.DOUBLE,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'description': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Effect on prolongation of hypoxic survival time (HS) in Carworth farms male albino mice' , 'Spermatog
                # enic index (percent change from vehicle control) was calculated in Adult Male Swiss Mice at 2 (umol/kg
                # ) dose' , 'Spermatogenic index (percent change from vehicle control) was calculated in Adult Male Swis
                # s Mice at 3 (umol/kg) dose' , 'Spermatogenic index (percent change from vehicle control) was calculate
                # d in Adult Male Swiss Mice at 6 (umol/kg) dose' , 'Spermatogenic index (percent change from vehicle co
                # ntrol) was calculated in Adult Male Swiss Mice at 62 (umol/kg) dose' , 'Spermatogenic index (percent c
                # hange from vehicle control) was calculated in Adult Male Swiss Mice at 7 (umol/kg) dose' , 'Spermatoge
                # nic index (percent change from vehicle control) was calculated in Adult Male Swiss Mice at 75 (umol/kg
                # ) dose' , 'Time of recovery of spontaneous movement (SMT) in seconds was measured after administration
                #  of 0.3 mg/kg orally in mice for the promotional effect on recovery from coma.' , 'Time of recovery of
                #  spontaneous movement (SMT) in seconds was measured after administration of 100 mg/kg intraperitoneall
                # y in mice for the promotional effect on recovery from coma.' , 'Serum concentration in mice, after ora
                # l administration at a dose of 100 mg/kg p.o. at 5 hr'
                'document_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1121489' , 'CHEMBL1130324' , 'CHEMBL1130324' , 'CHEMBL1130324' , 'CHEMBL1130324' , 'CHEMBL11303
                # 24' , 'CHEMBL1130324' , 'CHEMBL1125278' , 'CHEMBL1125278' , 'CHEMBL1123243'
                'relationship_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Non-molecular target assigned' , 'Non-molecular target assigned' , 'Non-molecular target assigned' , 
                # 'Non-molecular target assigned' , 'Non-molecular target assigned' , 'Non-molecular target assigned' , 
                # 'Non-molecular target assigned' , 'Non-molecular target assigned' , 'Non-molecular target assigned' , 
                # 'Non-molecular target assigned'
                'relationship_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
                'src_assay_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '609914' , '410278' , '385243' , '173' , '39' , '412456' , '397273' , '438091' , '395487' , '383332'
                'src_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'target_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL375' , 'CHEMBL375' , 'CHEMBL375' , 'CHEMBL375' , 'CHEMBL375' , 'CHEMBL375' , 'CHEMBL375' , 'CHE
                # MBL375' , 'CHEMBL375' , 'CHEMBL375'
                'tissue_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL3559721' , 'CHEMBL3638178' , 'CHEMBL3638188' , 'CHEMBL3638197' , 'CHEMBL3559722' , 'CHEMBL35597
                # 22' , 'CHEMBL3638185' , 'CHEMBL3638185' , 'CHEMBL3638235' , 'CHEMBL3559721'
            }
        }
    }

autocomplete_settings = {
    'assay_cell_type': 10,
    'assay_chembl_id': 10,
    'document_chembl_id': 10,
    'assay_organism': 30,
    'assay_strain': 10,
    'assay_subcellular_fraction': 40,
    'assay_test_type': 40,
    'assay_tissue': 30,
    'bao_format': 10,
    'description': 80
}

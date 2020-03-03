# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

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
                        'es_completion': DefaultMappings.COMPLETION_TYPE
                    }
                },
                'cell_chembl_id': DefaultMappings.CHEMBL_ID,
                # EXAMPLES:
                # 'CHEMBL3307241' , 'CHEMBL3307242' , 'CHEMBL3307243' , 'CHEMBL3307244' , 'CHEMBL3307245' , 'CHEMBL33072
                # 46' , 'CHEMBL3307247' , 'CHEMBL3307248' , 'CHEMBL3307249' , 'CHEMBL3307250'
                'cell_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'DC3F' , 'P3HR-1' , 'UCLA P-3' , 'UMSCC22B' , 'UMUC3' , 'V79-4' , 'VCR100' , 'W256' , 'WEHI265.1' , 'W
                # iDr-NTR'
                'cell_id': DefaultMappings.ID,
                # EXAMPLES:
                # '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '10'
                'cell_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'DC3F' , 'P3HR-1' , 'UCLA P-3' , 'UMSCC22B' , 'UMUC3' , 'V79-4' , 'VCR100' , 'W256' , 'WEHI265.1' , 'W
                # iDr-NTR'
                'cell_source_organism': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Cricetulus griseus' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Cricetulus
                #  griseus' , 'Mus musculus' , 'Rattus norvegicus' , 'Mus musculus' , 'Homo sapiens'
                'cell_source_tax_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '10029' , '9606' , '9606' , '9606' , '9606' , '10029' , '10090' , '10116' , '10090' , '9606'
                'cell_source_tissue': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Lung' , 'Lyphoma' , 'Lung Adenocarcinoma' , 'Carcinoma' , 'Bladder Carcinoma' , 'Lung' , 'Leukaemia' 
                # , 'Monocytic Carcinosarcoma' , 'Macrophage' , 'Colon Adenocarcinoma'
                'cellosaurus_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'CVCL_4704' , 'CVCL_2676' , 'CVCL_N513' , 'CVCL_7732' , 'CVCL_1783' , 'CVCL_2796' , 'CVCL_3537' , 'CVC
                # L_3620' , 'CVCL_1891' , 'CVCL_1794'
                'cl_lincs_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'LCL-2024' , 'LCL-1721' , 'LCL-1792' , 'LCL-1511' , 'LCL-1031' , 'LCL-2001' , 'LCL-1514' , 'LCL-1889' 
                # , 'LCL-1166' , 'LCL-1734'
                'clo_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'CLO_0008331' , 'CLO_0009487' , 'CLO_0009504' , 'CLO_0007335' , 'CLO_0009576' , 'CLO_0009645' , 'CLO_0
                # 009711' , 'CLO_0003434' , 'CLO_0007018' , 'CLO_0008195'
                'efo_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'EFO_0002312' , 'EFO_0002387' , 'EFO_0002179' , 'EFO_0002344' , 'EFO_0002377' , 'EFO_0002084' , 'EFO_0
                # 002866' , 'EFO_0002834' , 'EFO_0002246' , 'EFO_0002367'
            }
        }
    }

autocomplete_settings = {
    'cell_chembl_id': 10,
    'cell_description': 40,
    'cell_name': 100,
    'cell_source_organism': 30,
    'cell_source_tissue': 30,
    'cellosaurus_id': 10,
    'cl_lincs_id': 10,
    'clo_id': 10
}

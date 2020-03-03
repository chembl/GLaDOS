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
                        'es_completion': 'TEXT',
                        # EXAMPLES:
                        # '{'weight': 100, 'input': 'Colon carcinoma cell line'}' , '{'weight': 10, 'input': 'CHEMBL3308
                        # 568'}' , '{'weight': 10, 'input': 'CHEMBL3308650'}' , '{'weight': 40, 'input': 'Human MFH-ST c
                        # ell line'}' , '{'weight': 10, 'input': 'CHEMBL3308653'}' , '{'weight': 10, 'input': 'CHEMBL330
                        # 8654'}' , '{'weight': 40, 'input': 'CML/BC cell line'}' , '{'weight': 10, 'input': 'CVCL_D346'
                        # }' , '{'weight': 10, 'input': 'CHEMBL3308657'}' , '{'weight': 40, 'input': 'HNO 97 cell lines'
                        # }'
                    }
                },
                'cell_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3308649' , 'CHEMBL3308568' , 'CHEMBL3308650' , 'CHEMBL3308652' , 'CHEMBL3308653' , 'CHEMBL33086
                # 54' , 'CHEMBL3308655' , 'CHEMBL3308656' , 'CHEMBL3308657' , 'CHEMBL3308658'
                'cell_description': 'TEXT',
                # EXAMPLES:
                # 'Colon carcinoma cell line' , 'Human lung cancer cell line' , 'M-5 ovarian carcinoma cell line' , 'Hum
                # an MFH-ST cell line' , 'B(EBV+) cell line' , 'BE-WT cell lines' , 'CML/BC cell line' , 'H2981 cell lin
                # e' , 'HA22T cell line' , 'HNO 97 cell lines'
                'cell_id': 'NUMERIC',
                # EXAMPLES:
                # '1132' , '1133' , '1135' , '1137' , '1138' , '1139' , '1140' , '1141' , '1142' , '1143'
                'cell_name': 'TEXT',
                # EXAMPLES:
                # 'Colon carcinoma cell line' , 'Lung cancer cell line' , 'M-5' , 'MFH-ST' , 'B(EBV+)' , 'BE-WT' , 'CML/
                # BC' , 'H2981 cell line' , 'HA22T cell line' , 'HNO 97 cell line'
                'cell_source_organism': 'TEXT',
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens'
                'cell_source_tax_id': 'NUMERIC',
                # EXAMPLES:
                # '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606'
                'cell_source_tissue': 'TEXT',
                # EXAMPLES:
                # 'Ovarian carcinoma' , 'Human cerebral epithelial cells' , 'Lung fibroblast' , 'Mammary adenocarcinoma'
                #  , 'Neuroglioma cells' , 'Bladder Carcinoma' , 'Monocytic Carcinosarcoma' , 'Macrophage' , 'Colon Aden
                # ocarcinoma' , 'Sarcoma'
                'cellosaurus_id': 'TEXT',
                # EXAMPLES:
                # 'CVCL_D346' , 'CVCL_7046' , 'CVCL_D227' , 'CVCL_M353' , 'CVCL_0294' , 'CVCL_2480' , 'CVCL_3317' , 'CVC
                # L_8233' , 'CVCL_1282' , 'CVCL_H947'
                'cl_lincs_id': 'TEXT',
                # EXAMPLES:
                # 'LCL-1465' , 'LCL-1620' , 'LCL-1292' , 'LCL-1943' , 'LCL-1708' , 'LCL-1772' , 'LCL-1685' , 'LCL-1634' 
                # , 'LCL-1687' , 'LCL-1602'
                'clo_id': 'TEXT',
                # EXAMPLES:
                # 'CLO_0003675' , 'CLO_0003681' , 'CLO_0003785' , 'CLO_0003786' , 'CLO_0003836' , 'CLO_0008100' , 'CLO_0
                # 002190' , 'CLO_0008074' , 'CLO_0009224' , 'CLO_0001202'
                'efo_id': 'TEXT',
                # EXAMPLES:
                # 'EFO_0002192' , 'EFO_0002195' , 'EFO_0005359' , 'EFO_0002287' , 'EFO_0002372' , 'EFO_0002097' , 'EFO_0
                # 002098' , 'EFO_0002099' , 'EFO_0002813' , 'EFO_0002110'
            }
        }
    }

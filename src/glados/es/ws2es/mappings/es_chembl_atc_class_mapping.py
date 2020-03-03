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
                'level1': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'H' , 'H' , 'H' , 'H' , 'H' , 'H' , 'H' , 'H' , 'H' , 'H'
                'level1_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'SYSTEMIC HORMONAL PREPARATIONS, EXCL. ' , 'SYSTEMIC HORMONAL PREPARATIONS, EXCL. ' , 'SYSTEMIC HORMON
                # AL PREPARATIONS, EXCL. ' , 'SYSTEMIC HORMONAL PREPARATIONS, EXCL. ' , 'SYSTEMIC HORMONAL PREPARATIONS,
                #  EXCL. ' , 'SYSTEMIC HORMONAL PREPARATIONS, EXCL. ' , 'SYSTEMIC HORMONAL PREPARATIONS, EXCL. ' , 'SYST
                # EMIC HORMONAL PREPARATIONS, EXCL. ' , 'SYSTEMIC HORMONAL PREPARATIONS, EXCL. ' , 'SYSTEMIC HORMONAL PR
                # EPARATIONS, EXCL. '
                'level2': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'H02' , 'H02' , 'H02' , 'H02' , 'H02' , 'H02' , 'H03' , 'H03' , 'H03' , 'H03'
                'level2_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'CORTICOSTEROIDS FOR SYSTEMIC USE' , 'CORTICOSTEROIDS FOR SYSTEMIC USE' , 'CORTICOSTEROIDS FOR SYSTEMI
                # C USE' , 'CORTICOSTEROIDS FOR SYSTEMIC USE' , 'CORTICOSTEROIDS FOR SYSTEMIC USE' , 'CORTICOSTEROIDS FO
                # R SYSTEMIC USE' , 'THYROID THERAPY' , 'THYROID THERAPY' , 'THYROID THERAPY' , 'THYROID THERAPY'
                'level3': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'H02A' , 'H02A' , 'H02A' , 'H02A' , 'H02B' , 'H02C' , 'H03A' , 'H03A' , 'H03A' , 'H03A'
                'level3_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'CORTICOSTEROIDS FOR SYSTEMIC USE, PLAIN' , 'CORTICOSTEROIDS FOR SYSTEMIC USE, PLAIN' , 'CORTICOSTEROI
                # DS FOR SYSTEMIC USE, PLAIN' , 'CORTICOSTEROIDS FOR SYSTEMIC USE, PLAIN' , 'CORTICOSTEROIDS FOR SYSTEMI
                # C USE, COMBINATIONS' , 'ANTIADRENAL PREPARATIONS' , 'THYROID PREPARATIONS' , 'THYROID PREPARATIONS' , 
                # 'THYROID PREPARATIONS' , 'THYROID PREPARATIONS'
                'level4': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'H02AB' , 'H02AB' , 'H02AB' , 'H02AB' , 'H02BX' , 'H02CA' , 'H03AA' , 'H03AA' , 'H03AA' , 'H03AA'
                'level4_description': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Glucocorticoids' , 'Glucocorticoids' , 'Glucocorticoids' , 'Glucocorticoids' , 'Corticosteroids for s
                # ystemic use, combinations' , 'Anticorticosteroids' , 'Thyroid hormones' , 'Thyroid hormones' , 'Thyroi
                # d hormones' , 'Thyroid hormones'
                'level5': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'H02AB13' , 'H02AB14' , 'H02AB15' , 'H02AB17' , 'H02BX01' , 'H02CA01' , 'H03AA01' , 'H03AA02' , 'H03AA
                # 03' , 'H03AA04'
                'who_name': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'deflazacort' , 'cloprednol' , 'meprednisone' , 'cortivazol' , 'methylprednisolone, combinations' , 't
                # rilostane' , 'levothyroxine sodium' , 'liothyronine sodium' , 'combinations of levothyroxine and lioth
                # yronine' , 'tiratricol'
            }
        }
    }

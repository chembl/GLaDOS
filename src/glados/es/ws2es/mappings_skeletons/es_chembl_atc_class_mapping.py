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
                'level1': 'TEXT',
                # EXAMPLES:
                # 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A'
                'level1_description': 'TEXT',
                # EXAMPLES:
                # 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLI
                # SM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND ME
                # TABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT 
                # AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM'
                'level2': 'TEXT',
                # EXAMPLES:
                # 'A01' , 'A01' , 'A01' , 'A01' , 'A01' , 'A01' , 'A01' , 'A01' , 'A01' , 'A01'
                'level2_description': 'TEXT',
                # EXAMPLES:
                # 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMA
                # TOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGI
                # CAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PR
                # EPARATIONS'
                'level3': 'TEXT',
                # EXAMPLES:
                # 'A01A' , 'A01A' , 'A01A' , 'A01A' , 'A01A' , 'A01A' , 'A01A' , 'A01A' , 'A01A' , 'A01A'
                'level3_description': 'TEXT',
                # EXAMPLES:
                # 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMA
                # TOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGI
                # CAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PREPARATIONS' , 'STOMATOLOGICAL PR
                # EPARATIONS'
                'level4': 'TEXT',
                # EXAMPLES:
                # 'A01AA' , 'A01AA' , 'A01AA' , 'A01AA' , 'A01AA' , 'A01AA' , 'A01AB' , 'A01AB' , 'A01AB' , 'A01AB'
                'level4_description': 'TEXT',
                # EXAMPLES:
                # 'Caries prophylactic agents' , 'Caries prophylactic agents' , 'Caries prophylactic agents' , 'Caries p
                # rophylactic agents' , 'Caries prophylactic agents' , 'Caries prophylactic agents' , 'Antiinfectives an
                # d antiseptics for local oral treatment' , 'Antiinfectives and antiseptics for local oral treatment' , 
                # 'Antiinfectives and antiseptics for local oral treatment' , 'Antiinfectives and antiseptics for local 
                # oral treatment'
                'level5': 'TEXT',
                # EXAMPLES:
                # 'A01AA01' , 'A01AA02' , 'A01AA03' , 'A01AA04' , 'A01AA30' , 'A01AA51' , 'A01AB02' , 'A01AB03' , 'A01AB
                # 04' , 'A01AB05'
                'who_name': 'TEXT',
                # EXAMPLES:
                # 'sodium fluoride' , 'sodium monofluorophosphate' , 'olaflur' , 'stannous fluoride' , 'combinations' , 
                # 'sodium fluoride, combinations' , 'hydrogen peroxide' , 'chlorhexidine' , 'amphotericin B' , 'polynoxy
                # lin'
            }
        }
    }

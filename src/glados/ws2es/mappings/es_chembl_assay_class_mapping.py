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
                'assay_class_id': DefaultMappings.ID,
                # EXAMPLES:
                # '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '10'
                'class_type': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy'
                #  , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo effica
                # cy'
                'l1': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLI
                # SM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND ME
                # TABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT 
                # AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM'
                'l2': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Anti-Obesity Activity' , 'Anti-Obesity Activity' , 'Anti-Obesity Activity' , 'Anti-Obesity Activity' 
                # , 'Experimental Diabetes Mellitus' , 'Experimental Diabetes Mellitus' , 'Experimental Diabetes Mellitu
                # s' , 'Experimental Diabetes Mellitus' , 'Experimental Obesity' , 'Experimental Obesity'
                'l3': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Computer-Assisted Measurement of Food Consumption in Rats Anorectic Activity' , 'Food Consumption in 
                # Rats Anorectic Activity' , 'General Anti-Obesity activity' , 'Resting Metabolic Rate Anti-Obesity' , '
                # Alloxan Induced Diabetes' , 'Corticosteroid Induced Diabetes' , 'Streptozotocin Induced Diabetes' , 'V
                # irus Induced Diabetes' , 'Diet Induced Obesity' , 'Goldthioglucose Induced Obesity'
            }
        }
    }

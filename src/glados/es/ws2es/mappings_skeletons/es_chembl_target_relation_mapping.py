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
                'related_target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1907599' , 'CHEMBL4296119' , 'CHEMBL2979' , 'CHEMBL2111463' , 'CHEMBL3429' , 'CHEMBL2096666' , 
                # 'CHEMBL2111352' , 'CHEMBL2096669' , 'CHEMBL3885544' , 'CHEMBL4106133'
                'relationship': 'TEXT',
                # EXAMPLES:
                # 'OVERLAPS WITH' , 'OVERLAPS WITH' , 'SUPERSET OF' , 'SUBSET OF' , 'SUPERSET OF' , 'OVERLAPS WITH' , 'O
                # VERLAPS WITH' , 'SUBSET OF' , 'OVERLAPS WITH' , 'SUBSET OF'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2095184' , 'CHEMBL2221342' , 'CHEMBL2095184' , 'CHEMBL5034' , 'CHEMBL4296142' , 'CHEMBL3038506'
                #  , 'CHEMBL2095187' , 'CHEMBL3038506' , 'CHEMBL3885543' , 'CHEMBL4105991'
            }
        }
    }

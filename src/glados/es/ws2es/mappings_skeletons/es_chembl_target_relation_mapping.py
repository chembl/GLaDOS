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
            'related_target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL2095180' , 'CHEMBL3559691' , 'CHEMBL2094127' , 'CHEMBL3038467' , 'CHEMBL3885551' , 'CHEMBL3038468' 
            # , 'CHEMBL4296066' , 'CHEMBL4296065' , 'CHEMBL1907602' , 'CHEMBL2094108'
            'relationship': 'TEXT',
            # EXAMPLES:
            # 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET 
            # OF' , 'SUBSET OF' , 'SUBSET OF'
            'target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL261' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL3
            # 08' , 'CHEMBL308' , 'CHEMBL271'
        }
    }

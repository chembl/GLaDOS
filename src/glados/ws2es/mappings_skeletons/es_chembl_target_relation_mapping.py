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
                'related_target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2095180' , 'CHEMBL3559691' , 'CHEMBL2094127' , 'CHEMBL3038467' , 'CHEMBL3885551' , 'CHEMBL30384
                # 68' , 'CHEMBL1907602' , 'CHEMBL2094108' , 'CHEMBL2096991' , 'CHEMBL2095164'
                'relationship': 'TEXT',
                # EXAMPLES:
                # 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUBSET OF' , 'SUB
                # SET OF' , 'SUBSET OF' , 'SUBSET OF'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL261' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHEMBL308' , 'CHE
                # MBL271' , 'CHEMBL271' , 'CHEMBL271'
            }
        }
    }

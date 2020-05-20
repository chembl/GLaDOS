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
            'is_parent': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL246397' , 'CHEMBL248129' , 'CHEMBL247210' , 'CHEMBL397121' , 'CHEMBL245878' , 'CHEMBL395353' , 'CHE
            # MBL246081' , 'CHEMBL247330' , 'CHEMBL246713' , 'CHEMBL246284'
            'parent_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL246397' , 'CHEMBL248129' , 'CHEMBL247210' , 'CHEMBL397121' , 'CHEMBL245878' , 'CHEMBL395353' , 'CHE
            # MBL246081' , 'CHEMBL247330' , 'CHEMBL246713' , 'CHEMBL246284'
        }
    }

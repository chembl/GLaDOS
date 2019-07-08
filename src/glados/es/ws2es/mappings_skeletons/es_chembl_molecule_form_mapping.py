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
                'is_parent': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'False' , 'True' , 'True' , 'True' , 'True' , 'True'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1258267' , 'CHEMBL1201581' , 'CHEMBL1209043' , 'CHEMBL1224675' , 'CHEMBL1213652' , 'CHEMBL12547
                # 45' , 'CHEMBL1241945' , 'CHEMBL1221872' , 'CHEMBL1209046' , 'CHEMBL1213654'
                'parent_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1258267' , 'CHEMBL1201581' , 'CHEMBL1209043' , 'CHEMBL1224675' , 'CHEMBL218291' , 'CHEMBL125474
                # 5' , 'CHEMBL1241945' , 'CHEMBL1221872' , 'CHEMBL1209046' , 'CHEMBL1213654'
            }
        }
    }

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
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL515641' , 'CHEMBL496009' , 'CHEMBL518524' , 'CHEMBL464791' , 'CHEMBL522114' , 'CHEMBL463151' , 
                # 'CHEMBL449803' , 'CHEMBL474072' , 'CHEMBL463757' , 'CHEMBL455279'
                'parent_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL515641' , 'CHEMBL496009' , 'CHEMBL518524' , 'CHEMBL464791' , 'CHEMBL522114' , 'CHEMBL463151' , 
                # 'CHEMBL449803' , 'CHEMBL474072' , 'CHEMBL463757' , 'CHEMBL455279'
            }
        }
    }

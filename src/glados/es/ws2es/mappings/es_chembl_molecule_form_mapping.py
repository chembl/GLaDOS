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
                'is_parent': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1719391' , 'CHEMBL1701348' , 'CHEMBL1705923' , 'CHEMBL1719363' , 'CHEMBL1704578' , 'CHEMBL17266
                # 42' , 'CHEMBL1736809' , 'CHEMBL1725139' , 'CHEMBL1731976' , 'CHEMBL1708381'
                'parent_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1719391' , 'CHEMBL1701348' , 'CHEMBL1705923' , 'CHEMBL1719363' , 'CHEMBL1704578' , 'CHEMBL17266
                # 42' , 'CHEMBL1736809' , 'CHEMBL1725139' , 'CHEMBL1731976' , 'CHEMBL1708381'
            }
        }
    }

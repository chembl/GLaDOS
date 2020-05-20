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
            'document_1_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1135026' , 'CHEMBL1135026' , 'CHEMBL1135026' , 'CHEMBL1135026' , 'CHEMBL1135026' , 'CHEMBL1135026' 
            # , 'CHEMBL1135026' , 'CHEMBL1135028' , 'CHEMBL1135028' , 'CHEMBL1135028'
            'document_2_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1147479' , 'CHEMBL1147580' , 'CHEMBL1121524' , 'CHEMBL1121543' , 'CHEMBL1121371' , 'CHEMBL1121630' 
            # , 'CHEMBL1121447' , 'CHEMBL1136751' , 'CHEMBL1148890' , 'CHEMBL1152254'
            'mol_tani': 'NUMERIC',
            # EXAMPLES:
            # '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0'
            'tid_tani': 'NUMERIC',
            # EXAMPLES:
            # '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0'
        }
    }

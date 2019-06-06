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
                'document_1_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1127162' , 'CHEMBL1130369' , 'CHEMBL1126530' , 'CHEMBL1127968' , 'CHEMBL1126410' , 'CHEMBL11271
                # 62' , 'CHEMBL1129107' , 'CHEMBL1128095' , 'CHEMBL1126530' , 'CHEMBL1130369'
                'document_2_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1129716' , 'CHEMBL1142063' , 'CHEMBL1132089' , 'CHEMBL1133055' , 'CHEMBL1121586' , 'CHEMBL11289
                # 52' , 'CHEMBL1122357' , 'CHEMBL1128591' , 'CHEMBL1131680' , 'CHEMBL1145533'
                'mol_tani': 'NUMERIC',
                # EXAMPLES:
                # '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.02' , '0.0' , '0.0'
                'tid_tani': 'NUMERIC',
                # EXAMPLES:
                # '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0'
            }
        }
    }

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
                'document_1_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1130857' , 'CHEMBL1130857' , 'CHEMBL1130857' , 'CHEMBL1130857' , 'CHEMBL1130857' , 'CHEMBL11308
                # 57' , 'CHEMBL1130858' , 'CHEMBL1130858' , 'CHEMBL1130858' , 'CHEMBL1130858'
                'document_2_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1122698' , 'CHEMBL1123134' , 'CHEMBL1123261' , 'CHEMBL1123391' , 'CHEMBL1123306' , 'CHEMBL11236
                # 34' , 'CHEMBL1122856' , 'CHEMBL1125631' , 'CHEMBL1127841' , 'CHEMBL1127481'
                'mol_tani': DefaultMappings.FLOAT,
                # EXAMPLES:
                # '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0'
                'tid_tani': DefaultMappings.FLOAT,
                # EXAMPLES:
                # '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0'
            }
        }
    }

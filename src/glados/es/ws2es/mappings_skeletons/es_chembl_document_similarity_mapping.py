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
                'document_1_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1129912' , 'CHEMBL1129182' , 'CHEMBL1130787' , 'CHEMBL1129014' , 'CHEMBL1129182' , 'CHEMBL11318
                # 34' , 'CHEMBL1130601' , 'CHEMBL1130813' , 'CHEMBL1131789' , 'CHEMBL1129866'
                'document_2_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1151435' , 'CHEMBL1921691' , 'CHEMBL1147473' , 'CHEMBL1122840' , 'CHEMBL3244383' , 'CHEMBL11331
                # 56' , 'CHEMBL1131789' , 'CHEMBL1133147' , 'CHEMBL1147505' , 'CHEMBL1130963'
                'mol_tani': 'NUMERIC',
                # EXAMPLES:
                # '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0' , '0.0'
                'tid_tani': 'NUMERIC',
                # EXAMPLES:
                # '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '0.8' , '1.0' , '1.0' , '1.0' , '0.75'
            }
        }
    }

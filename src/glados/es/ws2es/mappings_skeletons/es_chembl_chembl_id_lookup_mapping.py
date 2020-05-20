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
            'chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1000002' , 'CHEMBL1000003' , 'CHEMBL1000008' , 'CHEMBL1000009' , 'CHEMBL100001' , 'CHEMBL1002704' ,
            #  'CHEMBL1002706' , 'CHEMBL10054' , 'CHEMBL100271' , 'CHEMBL1002710'
            'chembl_id_number': 'NUMERIC',
            # EXAMPLES:
            # '1000002' , '1000003' , '1000008' , '1000009' , '100001' , '1002704' , '1002706' , '10054' , '100271' , '1
            # 002710'
            'entity_type': 'TEXT',
            # EXAMPLES:
            # 'ASSAY' , 'ASSAY' , 'ASSAY' , 'ASSAY' , 'COMPOUND' , 'ASSAY' , 'ASSAY' , 'COMPOUND' , 'COMPOUND' , 'ASSAY'
            'resource_url': 'TEXT',
            # EXAMPLES:
            # '/chembl/api/data/assay/CHEMBL1000002' , '/chembl/api/data/assay/CHEMBL1000003' , '/chembl/api/data/assay/
            # CHEMBL1000008' , '/chembl/api/data/assay/CHEMBL1000009' , '/chembl/api/data/molecule/CHEMBL100001' , '/che
            # mbl/api/data/assay/CHEMBL1002704' , '/chembl/api/data/assay/CHEMBL1002706' , '/chembl/api/data/molecule/CH
            # EMBL10054' , '/chembl/api/data/molecule/CHEMBL100271' , '/chembl/api/data/assay/CHEMBL1002710'
            'status': 'TEXT',
            # EXAMPLES:
            # 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'INACTIVE' , 'ACTIVE' , 'ACTI
            # VE'
        }
    }

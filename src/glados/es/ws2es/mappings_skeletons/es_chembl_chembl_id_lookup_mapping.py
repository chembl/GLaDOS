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
                'chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1060315' , 'CHEMBL1060316' , 'CHEMBL1062397' , 'CHEMBL1057849' , 'CHEMBL1056580' , 'CHEMBL10603
                # 19' , 'CHEMBL106032' , 'CHEMBL1056583' , 'CHEMBL1056584' , 'CHEMBL1064799'
                'chembl_id_number': 'NUMERIC',
                # EXAMPLES:
                # '1060315' , '1060316' , '1062397' , '1057849' , '1056580' , '1060319' , '106032' , '1056583' , '105658
                # 4' , '1064799'
                'entity_type': 'TEXT',
                # EXAMPLES:
                # 'ASSAY' , 'ASSAY' , 'ASSAY' , 'ASSAY' , 'ASSAY' , 'ASSAY' , 'COMPOUND' , 'ASSAY' , 'ASSAY' , 'ASSAY'
                'resource_url': 'TEXT',
                # EXAMPLES:
                # '/chembl/api/data/assay/CHEMBL1060315' , '/chembl/api/data/assay/CHEMBL1060316' , '/chembl/api/data/as
                # say/CHEMBL1062397' , '/chembl/api/data/assay/CHEMBL1057849' , '/chembl/api/data/assay/CHEMBL1056580' ,
                #  '/chembl/api/data/assay/CHEMBL1060319' , '/chembl/api/data/molecule/CHEMBL106032' , '/chembl/api/data
                # /assay/CHEMBL1056583' , '/chembl/api/data/assay/CHEMBL1056584' , '/chembl/api/data/assay/CHEMBL1064799
                # '
                'status': 'TEXT',
                # EXAMPLES:
                # 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'AC
                # TIVE'
            }
        }
    }

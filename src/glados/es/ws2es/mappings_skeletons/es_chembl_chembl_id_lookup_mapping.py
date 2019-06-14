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
                # 'CHEMBL1006085' , 'CHEMBL1001146' , 'CHEMBL100876' , 'CHEMBL1006087' , 'CHEMBL1003807' , 'CHEMBL100608
                # 9' , 'CHEMBL100115' , 'CHEMBL100609' , 'CHEMBL1001150' , 'CHEMBL1008764'
                'chembl_id_number': 'NUMERIC',
                # EXAMPLES:
                # '1006085' , '1001146' , '100876' , '1006087' , '1003807' , '1006089' , '100115' , '100609' , '1001150'
                #  , '1008764'
                'entity_type': 'TEXT',
                # EXAMPLES:
                # 'ASSAY' , 'ASSAY' , 'COMPOUND' , 'ASSAY' , 'ASSAY' , 'ASSAY' , 'COMPOUND' , 'COMPOUND' , 'ASSAY' , 'AS
                # SAY'
                'resource_url': 'TEXT',
                # EXAMPLES:
                # '/chembl/api/data/assay/CHEMBL1006085' , '/chembl/api/data/assay/CHEMBL1001146' , '/chembl/api/data/mo
                # lecule/CHEMBL100876' , '/chembl/api/data/assay/CHEMBL1006087' , '/chembl/api/data/assay/CHEMBL1003807'
                #  , '/chembl/api/data/assay/CHEMBL1006089' , '/chembl/api/data/molecule/CHEMBL100115' , '/chembl/api/da
                # ta/molecule/CHEMBL100609' , '/chembl/api/data/assay/CHEMBL1001150' , '/chembl/api/data/assay/CHEMBL100
                # 8764'
                'status': 'TEXT',
                # EXAMPLES:
                # 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'AC
                # TIVE'
            }
        }
    }

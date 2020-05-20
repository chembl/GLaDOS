# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 0

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        'properties':
        {
            'chembl_id': DefaultMappings.CHEMBL_ID,
            # EXAMPLES:
            # 'CHEMBL1139771' , 'CHEMBL1139774' , 'CHEMBL1139776' , 'CHEMBL1139777' , 'CHEMBL1139783' , 'CHEMBL11397
            # 87' , 'CHEMBL1139791' , 'CHEMBL1139793' , 'CHEMBL1139796' , 'CHEMBL1139807'
            'chembl_id_number': DefaultMappings.LONG,
            # EXAMPLES:
            # '1001798' , '10018' , '1001804' , '1001806' , '1001807' , '1001808' , '1001811' , '1001814' , '1001819
            # ' , '1001820'
            'entity_type': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # 'DOCUMENT' , 'DOCUMENT' , 'DOCUMENT' , 'DOCUMENT' , 'DOCUMENT' , 'DOCUMENT' , 'DOCUMENT' , 'DOCUMENT'
            # , 'DOCUMENT' , 'DOCUMENT'
            'resource_url': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # '/chembl/api/data/document/CHEMBL1139771' , '/chembl/api/data/document/CHEMBL1139774' , '/chembl/api/d
            # ata/document/CHEMBL1139776' , '/chembl/api/data/document/CHEMBL1139777' , '/chembl/api/data/document/C
            # HEMBL1139783' , '/chembl/api/data/document/CHEMBL1139787' , '/chembl/api/data/document/CHEMBL1139791'
            # , '/chembl/api/data/document/CHEMBL1139793' , '/chembl/api/data/document/CHEMBL1139796' , '/chembl/api
            # /data/document/CHEMBL1139807'
            'status': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'ACTIVE' , 'AC
            # TIVE'
        }
    }

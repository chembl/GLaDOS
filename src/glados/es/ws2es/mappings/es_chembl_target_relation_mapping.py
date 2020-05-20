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
            'related_target_chembl_id': DefaultMappings.CHEMBL_ID_REF,
            # EXAMPLES:
            # 'CHEMBL2096907' , 'CHEMBL2096907' , 'CHEMBL4123' , 'CHEMBL2406895' , 'CHEMBL5776' , 'CHEMBL4109' , 'CH
            # EMBL2094129' , 'CHEMBL4088' , 'CHEMBL2109245' , 'CHEMBL2095194'
            'relationship': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # 'SUBSET OF' , 'SUBSET OF' , 'SUPERSET OF' , 'SUPERSET OF' , 'SUPERSET OF' , 'SUPERSET OF' , 'OVERLAPS
            # WITH' , 'SUPERSET OF' , 'SUBSET OF' , 'SUBSET OF'
            'target_chembl_id': DefaultMappings.CHEMBL_ID_REF,
            # EXAMPLES:
            # 'CHEMBL3038451' , 'CHEMBL3038457' , 'CHEMBL3038478' , 'CHEMBL3038490' , 'CHEMBL3038499' , 'CHEMBL30385
            # 04' , 'CHEMBL3038507' , 'CHEMBL3038508' , 'CHEMBL3427' , 'CHEMBL4081'
        }
    }

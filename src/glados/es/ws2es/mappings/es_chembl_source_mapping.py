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
            'src_description': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # 'DONT USE, RESERVED FOR K4DD' , 'FDA Approval Packages' , 'GSK Kinetoplastid Screening' , 'MMV Pathoge
            # n Box' , 'External Project Compounds' , 'Gene Expression Atlas Compounds' , 'Gates Library compound co
            # llection' , 'HeCaToS Compounds' , 'Withdrawn Drugs' , 'BindingDB Database'
            'src_id': DefaultMappings.ID,
            # EXAMPLES:
            # '30' , '28' , '29' , '34' , '25' , '26' , '33' , '35' , '36' , '37'
            'src_short_name': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # 'FDA_APPROVAL' , 'GSK_TCAKS' , 'MMV_PBOX' , 'EXT. PROJECT CPDS' , 'ATLAS' , 'GATES_LIBRARY' , 'HECATOS
            # ' , 'WITHDRAWN' , 'BINDINGDB' , 'DRUGS'
        }
    }

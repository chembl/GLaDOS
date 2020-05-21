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
            'l1': 'TEXT',
            # EXAMPLES:
            # 'Eukaryotes' , 'Eukaryotes' , 'Bacteria' , 'Fungi' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryo
            # tes' , 'Eukaryotes' , 'Eukaryotes'
            'l2': 'TEXT',
            # EXAMPLES:
            # 'Mammalia' , 'Mammalia' , 'Gram-Negative' , 'Ascomycota' , 'Kinetoplastida' , 'Kinetoplastida' , 'Mammalia
            # ' , 'Apicomplexa' , 'Apicomplexa' , 'Apicomplexa'
            'l3': 'TEXT',
            # EXAMPLES:
            # 'Rodentia' , 'Primates' , 'Acinetobacter' , 'Saccharomycetales' , 'Leishmania' , 'Trypanosoma' , 'Primates
            # ' , 'Cryptosporidium' , 'Cryptosporidium' , 'Eimeria'
            'oc_id': 'NUMERIC',
            # EXAMPLES:
            # '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '10'
            'tax_id': 'NUMERIC',
            # EXAMPLES:
            # '10030' , '9593' , '470' , '5475' , '5660' , '5691' , '9606' , '237895' , '5807' , '5800'
        }
    }

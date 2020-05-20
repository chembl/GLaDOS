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
            'l1': DefaultMappings.LOWER_CASE_KEYWORD,
            # EXAMPLES:
            # 'Eukaryotes' , 'Bacteria' , 'Fungi' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Euk
            # aryotes' , 'Eukaryotes' , 'Eukaryotes'
            'l2': DefaultMappings.LOWER_CASE_KEYWORD,
            # EXAMPLES:
            # 'Viridiplantae' , 'Gram-Negative' , 'Ascomycota' , 'Kinetoplastida' , 'Kinetoplastida' , 'Mammalia' ,
            # 'Apicomplexa' , 'Arthropoda' , 'Arthropoda' , 'Apicomplexa'
            'l3': DefaultMappings.LOWER_CASE_KEYWORD,
            # EXAMPLES:
            # 'Eudicotyledons' , 'Acinetobacter' , 'Saccharomycetales' , 'Leishmania' , 'Trypanosoma' , 'Primates' ,
            #  'Cryptosporidium' , 'Thysanoptera' , 'Arachnida' , 'Eimeria'
            'oc_id': DefaultMappings.ID,
            # EXAMPLES:
            # '3318' , '3' , '4' , '5' , '6' , '7' , '8' , '3324' , '3325' , '14'
            'tax_id': DefaultMappings.ID,
            # EXAMPLES:
            # '263974' , '470' , '5475' , '5660' , '5691' , '9606' , '237895' , '133901' , '714357' , '51315'
        }
    }

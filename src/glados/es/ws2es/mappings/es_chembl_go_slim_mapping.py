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
                'aspect': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'F' , 'P' , 'P' , 'F' , 'C' , 'F' , 'F' , 'F' , 'F' , 'F'
                'class_level': DefaultMappings.SHORT,
                # EXAMPLES:
                # '4' , '2' , '1' , '2' , '3' , '1' , '4' , '4' , '2' , '3'
                'go_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'GO:0051434' , 'GO:0051604' , 'GO:0061024' , 'GO:0000149' , 'GO:0000229' , 'GO:0003682' , 'GO:0003848'
                #  , 'GO:0004062' , 'GO:0005044' , 'GO:0005123'
                'parent_go_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'GO:0051400' , 'GO:0008152' , 'GO:0008150' , 'GO:0005515' , 'GO:0005694' , 'GO:0003674' , 'GO:0016772'
                #  , 'GO:0008146' , 'GO:0004872' , 'GO:0005102'
                'path': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'molecular_function  protein binding  protein domain specific binding  BH domain binding  BH3 domain b
                # inding' , 'biological_process  metabolic process  protein maturation' , 'biological_process  membrane 
                # organization' , 'molecular_function  protein binding  SNARE binding' , 'cellular_component  organelle 
                #  chromosome  cytoplasmic chromosome' , 'molecular_function  chromatin binding' , 'molecular_function  
                # catalytic activity  transferase activity  transferase activity, transferring phosphorus-containing gro
                # ups  2-amino-4-hydroxy-6-hydroxymethyldihydropteridine diphosphokinase activity' , 'molecular_function
                #   catalytic activity  transferase activity  sulfotransferase activity  aryl sulfotransferase activity'
                #  , 'molecular_function  receptor activity  scavenger receptor activity' , 'molecular_function  protein
                #  binding  receptor binding  death receptor binding'
                'pref_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'BH3 domain binding' , 'protein maturation' , 'membrane organization' , 'SNARE binding' , 'cytoplasmic
                #  chromosome' , 'chromatin binding' , '2-amino-4-hydroxy-6-hydroxymethyldihydropteridine diphosphokinas
                # e activity' , 'aryl sulfotransferase activity' , 'scavenger receptor activity' , 'death receptor bindi
                # ng'
            }
        }
    }

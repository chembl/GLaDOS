# Elastic search mapping definition for the Molecule entity
from glados.ws2es.es_util import DefaultMappings

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
                'l1': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Transcription factor' , 'Transcription factor' , 'Transcription factor' , 'Transcription factor' , 'T
                # ranscription factor' , 'Transcription factor' , 'Transcription factor' , 'Transcription factor' , 'Tra
                # nscription factor' , 'Transcription factor'
                'l2': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Nuclear receptor' , 'Nuclear receptor' , 'Nuclear receptor' , 'Nuclear receptor' , 'Nuclear receptor'
                #  , 'Nuclear receptor' , 'Nuclear receptor' , 'Nuclear receptor' , 'Nuclear receptor' , 'Nuclear recept
                # or'
                'l3': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Nuclear hormone receptor subfamily 2' , 'Nuclear hormone receptor subfamily 3' , 'Nuclear hormone rec
                # eptor subfamily 3' , 'Nuclear hormone receptor subfamily 3' , 'Nuclear hormone receptor subfamily 3' ,
                #  'Nuclear hormone receptor subfamily 3' , 'Nuclear hormone receptor subfamily 3' , 'Nuclear hormone re
                # ceptor subfamily 3' , 'Nuclear hormone receptor subfamily 3' , 'Nuclear hormone receptor subfamily 3'
                'l4': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Nuclear hormone receptor subfamily 2 group E' , 'Nuclear hormone receptor subfamily 3 group A' , 'Nuc
                # lear hormone receptor subfamily 3 group A' , 'Nuclear hormone receptor subfamily 3 group B' , 'Nuclear
                #  hormone receptor subfamily 3 group B' , 'Nuclear hormone receptor subfamily 3 group B' , 'Nuclear hor
                # mone receptor subfamily 3 group C' , 'Nuclear hormone receptor subfamily 3 group C' , 'Nuclear hormone
                #  receptor subfamily 3 group C' , 'Nuclear hormone receptor subfamily 3 group C'
                'l5': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Nuclear hormone receptor subfamily 2 group E member 3' , 'Nuclear hormone receptor subfamily 3 group 
                # A member 1' , 'Nuclear hormone receptor subfamily 3 group A member 2' , 'Nuclear hormone receptor subf
                # amily 3 group B member 1' , 'Nuclear hormone receptor subfamily 3 group B member 2' , 'Nuclear hormone
                #  receptor subfamily 3 group B member 3' , 'Nuclear hormone receptor subfamily 3 group C member 1' , 'N
                # uclear hormone receptor subfamily 3 group C member 2' , 'Nuclear hormone receptor subfamily 3 group C 
                # member 3' , 'Nuclear hormone receptor subfamily 3 group C member 4'
                'l6': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'AGC protein kinase RSKp70' , 'CAMK protein kinase LKB subfamily' , 'CAMK protein kinase QIK subfamily
                # ' , 'CAMK protein kinase MSKb subfamily' , 'CAMK protein kinase RSKb subfamily' , 'CMGC protein kinase
                #  TAIRE subfamily' , 'CMGC protein kinase HIPK subfamily' , 'CMGC protein kinase ERK1' , 'CMGC protein 
                # kinase ERK3' , 'CMGC protein kinase ERK5'
                'protein_class_id': DefaultMappings.ID,
                # EXAMPLES:
                # '369' , '370' , '371' , '372' , '373' , '374' , '375' , '376' , '377' , '378'
            }
        }
    }

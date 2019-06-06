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
                'l1': 'TEXT',
                # EXAMPLES:
                # 'Enzyme' , 'Adhesion' , 'Secreted protein' , 'Structural protein' , 'Other nuclear protein' , 'Enzyme'
                #  , 'Other membrane protein' , 'Other cytosolic protein' , 'Surface antigen' , 'Enzyme'
                'l2': 'TEXT',
                # EXAMPLES:
                # 'Kinase' , 'Oxidoreductase' , 'Cytochrome P450' , 'Protease' , 'Protease' , 'Protease' , 'Protease' , 
                # 'Protease' , 'Protease' , 'Protease'
                'l3': 'TEXT',
                # EXAMPLES:
                # 'Cytochrome P450 CAM family' , 'Serine protease' , 'Serine protease' , 'Serine protease' , 'Serine pro
                # tease' , 'Serine protease' , 'Serine protease' , 'Serine protease' , 'Serine protease' , 'Serine prote
                # ase'
                'l4': 'TEXT',
                # EXAMPLES:
                # 'Serine protease PA clan' , 'Serine protease SB clan' , 'Serine protease SB clan' , 'Serine protease S
                # C clan' , 'Serine protease SC clan' , 'Serine protease SC clan' , 'Serine protease SC clan' , 'Serine 
                # protease SC clan' , 'Serine protease SE clan' , 'Serine protease SE clan'
                'l5': 'TEXT',
                # EXAMPLES:
                # 'Serine protease S6 family' , 'Serine protease S8A subfamily' , 'Serine protease S8B subfamily' , 'Ser
                # ine protease S10 family' , 'Serine protease S28 family' , 'Serine protease S33 family' , 'Serine prote
                # ase S9A subfamily' , 'Serine protease S9B subfamily' , 'Serine protease S11 family' , 'Serine protease
                #  S12 family'
                'l6': 'TEXT',
                # EXAMPLES:
                # 'Metallo protease M28A subfamily' , 'Metallo protease M28B subfamily' , 'Cysteine protease C14A subfam
                # ily' , 'Cysteine protease C2 regulatory subfamily' , 'Serine protease S29 regulatory subfamily' , 'Met
                # allo protease M14B regulatory subfamily' , 'Aspartic protease A22A regulatory subfamily' , 'Tyrosine p
                # rotein kinase Srm' , 'Tyrosine protein kinase SrcA' , 'AGC protein kinase GRK subfamily'
                'protein_class_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '10'
            }
        }
    }

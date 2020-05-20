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
            'compound_key': 'TEXT',
            # EXAMPLES:
            # '9b' , '14' , '26 (E)' , 'Tazobactam' , 'Ro-481220' , '17 (+/-)' , '16 (+/-)' , '14 (+/-)' , '13 (+/-)' , 
            # '6'
            'compound_name': 'TEXT',
            # EXAMPLES:
            # '2-bromo-4-[2-(3-bromo-4-hydroxyphenyl)-1-ethylbutyl]phenol' , '1-(4-Hydroxy-5-hydroxymethyl-tetrahydro-fu
            # ran-2-yl)-1H-[1,2,4]triazole-3-carboxylic acid amide; compound with staphylococcal enterotoxin B (SEB)' , 
            # 'Sodium salt (2S,3S,5R,6R)-3-((E)-2-cyano-vinyl)-6-hydroxymethyl-3-methyl-4,4,7-trioxo-4lambda*6*-thia-1-a
            # za-bicyclo[3.2.0]heptane-2-carboxylate' , 'Sodium salt (2S,3S,5R)-3-methyl-4,4,7-trioxo-3-[1,2,3]triazol-1
            # -ylmethyl-4lambda*6*-thia-1-aza-bicyclo[3.2.0]heptane-2-carboxylate' , 'Sodium salt (2S,3R,5R)-3-((Z)-2-cy
            # ano-vinyl)-3-methyl-4,4,7-trioxo-4lambda*6*-thia-1-aza-bicyclo[3.2.0]heptane-2-carboxylate' , '3-(3-Amino-
            # 4-chloro-phenyl)-5-[(thiophene-3-sulfonylamino)-methyl]-4,5-dihydro-isoxazole-5-carboxylic acid [5-(2-sulf
            # amoyl-phenyl)-pyridin-2-yl]-amide' , '3-(3-Amino-4-chloro-phenyl)-5-(benzenesulfonylamino-methyl)-4,5-dihy
            # dro-isoxazole-5-carboxylic acid [5-(2-sulfamoyl-phenyl)-pyridin-2-yl]-amide' , '3-(3-Amino-4-chloro-phenyl
            # )-5-[(propane-1-sulfonylamino)-methyl]-4,5-dihydro-isoxazole-5-carboxylic acid [5-(2-sulfamoyl-phenyl)-pyr
            # idin-2-yl]-amide' , '3-(3-Amino-4-chloro-phenyl)-5-(methanesulfonylamino-methyl)-4,5-dihydro-isoxazole-5-c
            # arboxylic acid [5-(2-sulfamoyl-phenyl)-pyridin-2-yl]-amide' , '2-{2-[(S)-2-({1-[(S)-6-Amino-2-((S)-(S)-2,6
            # -diamino-hexylamino)-hexanoyl]-pyrrolidine-2-carbonyl}-amino)-3-(1H-indol-3-yl)-1-(S)-oxo-propylamino]-3-m
            # ethyl-pentanoylamino}-4-methyl-pentanoic acid'
            'document_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1121517' , 'CHEMBL1133712' , 'CHEMBL1131672' , 'CHEMBL1131672' , 'CHEMBL1131672' , 'CHEMBL1145764' 
            # , 'CHEMBL1145764' , 'CHEMBL1145764' , 'CHEMBL1145764' , 'CHEMBL1150005'
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL6485' , 'CHEMBL269651' , 'CHEMBL269471' , 'CHEMBL1439' , 'CHEMBL6461' , 'CHEMBL275957' , 'CHEMBL269
            # 065' , 'CHEMBL8135' , 'CHEMBL7626' , 'CHEMBL427604'
            'record_id': 'NUMERIC',
            # EXAMPLES:
            # '360' , '3147' , '363' , '366' , '368' , '3154' , '3155' , '3157' , '3158' , '374'
            'src_id': 'NUMERIC',
            # EXAMPLES:
            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
        }
    }

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
                'compound_key': 'TEXT',
                # EXAMPLES:
                # '2a' , '172 (Glucose)' , '2d' , '43' , '18' , '9a' , '17' , '8a' , '51d' , '56'
                'compound_name': 'TEXT',
                # EXAMPLES:
                # '2,6-Di-tert-butyl-4-[(dimethyl-phenyl-silanyl)-methylsulfanyl]-phenol' , 'Glucose6-Hydroxymethyl-tetr
                # ahydro-pyran-2,3,4,5-tetraol' , '2,6-Di-tert-butyl-4-{[(2-methoxy-phenyl)-dimethyl-silanyl]-methoxy}-p
                # henol' , '1-(4-Phenyl-butyl)-3-(5-thioxo-4,5-dihydro-[1,3,4]thiadiazol-2-yl)-urea' , '10,10-Dioxo-9,10
                # -dihydro-10lambda*6*-thioxanthene-9-carboxylic acid [(2R,3S,5R)-5-(5-ethyl-2,4-dioxo-3,4-dihydro-2H-py
                # rimidin-1-yl)-3-hydroxy-tetrahydro-furan-2-ylmethyl]-amide' , '8-[2-((S)-2-tert-Butoxycarbonylamino-2-
                # methyl-3-phenyl-propionylamino)-3-phenyl-propionylamino]-octanoic acid' , '9H-Thioxanthene-9-carboxyli
                # c acid [(2R,3S,5R)-5-(5-ethyl-2,4-dioxo-3,4-dihydro-2H-pyrimidin-1-yl)-3-hydroxy-tetrahydro-furan-2-yl
                # methyl]-amide' , '{(S)-1-[1-(8-Methoxy-octylcarbamoyl)-2-phenyl-ethylcarbamoyl]-1-methyl-2-phenyl-ethy
                # l}-carbamic acid tert-butyl ester' , '4-{(E)-2-[({[2,4-Dichloro-3-(2,3-dimethyl-benzofuran-7-yloxymeth
                # yl)-phenyl]-methyl-carbamoyl}-methyl)-carbamoyl]-vinyl}-N-methyl-benzamide' , '(S)-3-Phenyl-2-[3-(5-th
                # ioxo-4,5-dihydro-[1,3,4]thiadiazol-2-yl)-ureido]-propionamide'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1129112' , 'CHEMBL1122538' , 'CHEMBL1129112' , 'CHEMBL1132172' , 'CHEMBL1134111' , 'CHEMBL11277
                # 09' , 'CHEMBL1134111' , 'CHEMBL1127709' , 'CHEMBL1149113' , 'CHEMBL1132172'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL433056' , 'CHEMBL1222250' , 'CHEMBL288433' , 'CHEMBL39316' , 'CHEMBL42459' , 'CHEMBL46290' , 'C
                # HEMBL288569' , 'CHEMBL47929' , 'CHEMBL41446' , 'CHEMBL39553'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '63491' , '72160' , '63492' , '60878' , '72353' , '75336' , '72354' , '75337' , '69381' , '60881'
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            }
        }
    }

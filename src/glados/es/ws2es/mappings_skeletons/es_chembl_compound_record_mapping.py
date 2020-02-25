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
                # '179' , '17' , '36c' , '11' , '(3S,4S,5S,10R,13R,17R)-17-((R)-1,5-Dimethyl-hexyl)-4-(4-fluoro-benzyl)-
                # 10,13-dimethyl-hexadecahydro-cyclopenta[a]phenanthren-3-ol' , '36t' , '17' , '16' , '14' , '8'
                'compound_name': 'TEXT',
                # EXAMPLES:
                # '4-(3-Trifluoromethyl-3H-diazirin-3-yl)-benzoic acid 2-amino-4-oxo-3,4,5,6,7,8-hexahydro-pteridin-6-yl
                # methyl ester' , '(3R,4S,10R,13R,17R)-4-Butyl-17-((R)-1,5-dimethyl-hexyl)-10,13-dimethyl-hexadecahydro-
                # cyclopenta[a]phenanthren-3-ol' , '(3R,4S,10R,13R,17R)-17-((R)-1,5-Dimethyl-hexyl)-4-(3-iodo-benzyl)-10
                # ,13-dimethyl-hexadecahydro-cyclopenta[a]phenanthren-3-ol' , '(3R,4S,10R,13R,17R)-4-(2-Chloro-allyl)-17
                # -((1R,4R)-4-ethyl-1,5-dimethyl-hexyl)-10,13-dimethyl-hexadecahydro-cyclopenta[a]phenanthren-3-ol' , '(
                # 3S,4S,5S,10R,13R,17R)-17-((R)-1,5-Dimethyl-hexyl)-4-(4-fluoro-benzyl)-10,13-dimethyl-hexadecahydro-cyc
                # lopenta[a]phenanthren-3-ol' , '(3R,4S,10R,13R,17R)-17-((R)-1,5-Dimethyl-hexyl)-4-(4-hydroxy-benzyl)-10
                # ,13-dimethyl-hexadecahydro-cyclopenta[a]phenanthren-3-ol' , 'Sodium salt 3-[(R)-{3-[(E)-2-(7-chloro-qu
                # inolin-2-yl)-vinyl]-phenyl}-(2-dimethylcarbamoyl-ethylsulfanyl)-methylsulfanyl]-propionate' , 'Sodium 
                # salt 3-[{3-[(E)-2-(7-chloro-quinolin-2-yl)-vinyl]-phenyl}-(2-dimethylcarbamoyl-ethylsulfanyl)-methylsu
                # lfanyl]-propionate' , '4-{(R)-1-{3-[(E)-2-(7-Chloro-quinolin-2-yl)-vinyl]-phenyl}-3-[2-(1-hydroxy-1-me
                # thyl-ethyl)-phenyl]-propylsulfanyl}-3,3-dimethyl-butyric acid' , '(R)-3-{(R)-1-{3-[(E)-2-(7-Chloro-qui
                # nolin-2-yl)-vinyl]-phenyl}-3-[2-(1-hydroxy-1-methyl-ethyl)-phenyl]-propylsulfanyl}-butyric acid'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1135494' , 'CHEMBL1128436' , 'CHEMBL1128436' , 'CHEMBL1128436' , 'CHEMBL1128436' , 'CHEMBL11284
                # 36' , 'CHEMBL1151076' , 'CHEMBL1151076' , 'CHEMBL1151076' , 'CHEMBL1151076'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL101527' , 'CHEMBL3137873' , 'CHEMBL3137881' , 'CHEMBL3138214' , 'CHEMBL3137902' , 'CHEMBL313823
                # 5' , 'CHEMBL89340' , 'CHEMBL89768' , 'CHEMBL99775' , 'CHEMBL95317'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '185724' , '180925' , '180927' , '180928' , '180931' , '180941' , '180944' , '180945' , '180947' , '18
                # 0952'
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            }
        }
    }

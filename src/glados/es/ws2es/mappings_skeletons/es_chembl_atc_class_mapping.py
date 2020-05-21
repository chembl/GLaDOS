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
            'level1': 'TEXT',
            # EXAMPLES:
            # 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A' , 'A'
            'level1_description': 'TEXT',
            # EXAMPLES:
            # 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' 
            # , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM
            # ' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLISM' , 'ALIMENTARY TRACT AND METABOLI
            # SM' , 'ALIMENTARY TRACT AND METABOLISM'
            'level2': 'TEXT',
            # EXAMPLES:
            # 'A03' , 'A03' , 'A03' , 'A03' , 'A03' , 'A03' , 'A03' , 'A04' , 'A04' , 'A05'
            'level2_description': 'TEXT',
            # EXAMPLES:
            # 'DRUGS FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'DRUGS FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'D
            # RUGS FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'DRUGS FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'DRU
            # GS FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'DRUGS FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'DRUGS
            #  FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'ANTIEMETICS AND ANTINAUSEANTS' , 'ANTIEMETICS AND ANTINAUSE
            # ANTS' , 'BILE AND LIVER THERAPY'
            'level3': 'TEXT',
            # EXAMPLES:
            # 'A03A' , 'A03B' , 'A03C' , 'A03C' , 'A03C' , 'A03D' , 'A03D' , 'A04A' , 'A04A' , 'A05A'
            'level3_description': 'TEXT',
            # EXAMPLES:
            # 'DRUGS FOR FUNCTIONAL GASTROINTESTINAL DISORDERS' , 'BELLADONNA AND DERIVATIVES, PLAIN' , 'ANTISPASMODICS 
            # IN COMBINATION WITH PSYCHOLEPTICS' , 'ANTISPASMODICS IN COMBINATION WITH PSYCHOLEPTICS' , 'ANTISPASMODICS 
            # IN COMBINATION WITH PSYCHOLEPTICS' , 'ANTISPASMODICS IN COMBINATION WITH ANALGESICS' , 'ANTISPASMODICS IN 
            # COMBINATION WITH ANALGESICS' , 'ANTIEMETICS AND ANTINAUSEANTS' , 'ANTIEMETICS AND ANTINAUSEANTS' , 'BILE T
            # HERAPY'
            'level4': 'TEXT',
            # EXAMPLES:
            # 'A03AX' , 'A03BA' , 'A03CA' , 'A03CA' , 'A03CA' , 'A03DA' , 'A03DA' , 'A04AA' , 'A04AD' , 'A05AA'
            'level4_description': 'TEXT',
            # EXAMPLES:
            # 'Other drugs for functional gastrointestinal disorders' , 'Belladonna alkaloids, tertiary amines' , 'Synth
            # etic anticholinergic agents in combination with psycholeptics' , 'Synthetic anticholinergic agents in comb
            # ination with psycholeptics' , 'Synthetic anticholinergic agents in combination with psycholeptics' , 'Synt
            # hetic anticholinergic agents in combination with analgesics' , 'Synthetic anticholinergic agents in combin
            # ation with analgesics' , 'Serotonin (5HT3) antagonists' , 'Other antiemetics' , 'Bile acids and derivative
            # s'
            'level5': 'TEXT',
            # EXAMPLES:
            # 'A03AX30' , 'A03BA01' , 'A03CA03' , 'A03CA08' , 'A03CA30' , 'A03DA02' , 'A03DA07' , 'A04AA04' , 'A04AD05' 
            # , 'A05AA01'
            'who_name': 'TEXT',
            # EXAMPLES:
            # 'trimethyldiphenylpropylamine' , 'atropine' , 'oxyphencyclimine and psycholeptics' , 'diphemanil and psych
            # oleptics' , 'emepronium and psycholeptics' , 'pitofenone and analgesics' , 'tiemonium iodide and analgesic
            # s' , 'dolasetron' , 'metopimazine' , 'chenodeoxycholic acid'
        }
    }

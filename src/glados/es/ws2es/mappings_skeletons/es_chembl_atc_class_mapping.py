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
                'level1': 'TEXT',
                # EXAMPLES:
                # 'C' , 'C' , 'C' , 'C' , 'C' , 'C' , 'C' , 'C' , 'C' , 'C'
                'level1_description': 'TEXT',
                # EXAMPLES:
                # 'CARDIOVASCULAR SYSTEM' , 'CARDIOVASCULAR SYSTEM' , 'CARDIOVASCULAR SYSTEM' , 'CARDIOVASCULAR SYSTEM' 
                # , 'CARDIOVASCULAR SYSTEM' , 'CARDIOVASCULAR SYSTEM' , 'CARDIOVASCULAR SYSTEM' , 'CARDIOVASCULAR SYSTEM
                # ' , 'CARDIOVASCULAR SYSTEM' , 'CARDIOVASCULAR SYSTEM'
                'level2': 'TEXT',
                # EXAMPLES:
                # 'C02' , 'C02' , 'C02' , 'C02' , 'C02' , 'C02' , 'C02' , 'C02' , 'C02' , 'C02'
                'level2_description': 'TEXT',
                # EXAMPLES:
                # 'ANTIHYPERTENSIVES' , 'ANTIHYPERTENSIVES' , 'ANTIHYPERTENSIVES' , 'ANTIHYPERTENSIVES' , 'ANTIHYPERTENS
                # IVES' , 'ANTIHYPERTENSIVES' , 'ANTIHYPERTENSIVES' , 'ANTIHYPERTENSIVES' , 'ANTIHYPERTENSIVES' , 'ANTIH
                # YPERTENSIVES'
                'level3': 'TEXT',
                # EXAMPLES:
                # 'C02A' , 'C02A' , 'C02A' , 'C02A' , 'C02A' , 'C02A' , 'C02A' , 'C02A' , 'C02A' , 'C02B'
                'level3_description': 'TEXT',
                # EXAMPLES:
                # 'ANTIADRENERGIC AGENTS, CENTRALLY ACTING' , 'ANTIADRENERGIC AGENTS, CENTRALLY ACTING' , 'ANTIADRENERGI
                # C AGENTS, CENTRALLY ACTING' , 'ANTIADRENERGIC AGENTS, CENTRALLY ACTING' , 'ANTIADRENERGIC AGENTS, CENT
                # RALLY ACTING' , 'ANTIADRENERGIC AGENTS, CENTRALLY ACTING' , 'ANTIADRENERGIC AGENTS, CENTRALLY ACTING' 
                # , 'ANTIADRENERGIC AGENTS, CENTRALLY ACTING' , 'ANTIADRENERGIC AGENTS, CENTRALLY ACTING' , 'ANTIADRENER
                # GIC AGENTS, GANGLION-BLOCKING'
                'level4': 'TEXT',
                # EXAMPLES:
                # 'C02AA' , 'C02AA' , 'C02AB' , 'C02AB' , 'C02AC' , 'C02AC' , 'C02AC' , 'C02AC' , 'C02AC' , 'C02BA'
                'level4_description': 'TEXT',
                # EXAMPLES:
                # 'Rauwolfia alkaloids' , 'Rauwolfia alkaloids' , 'Methyldopa' , 'Methyldopa' , 'Imidazoline receptor ag
                # onists' , 'Imidazoline receptor agonists' , 'Imidazoline receptor agonists' , 'Imidazoline receptor ag
                # onists' , 'Imidazoline receptor agonists' , 'Sulfonium derivatives'
                'level5': 'TEXT',
                # EXAMPLES:
                # 'C02AA53' , 'C02AA57' , 'C02AB01' , 'C02AB02' , 'C02AC01' , 'C02AC02' , 'C02AC04' , 'C02AC05' , 'C02AC
                # 06' , 'C02BA01'
                'who_name': 'TEXT',
                # EXAMPLES:
                # 'combinations of rauwolfia alkoloids, combinations' , 'bietaserpine, combinations' , 'methyldopa (levo
                # rotatory)' , 'methyldopa (racemic)' , 'clonidine' , 'guanfacine' , 'tolonidine' , 'moxonidine' , 'rilm
                # enidine' , 'trimetaphan'
            }
        }
    }

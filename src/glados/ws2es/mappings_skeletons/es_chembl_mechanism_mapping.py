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
                'action_type': 'TEXT',
                # EXAMPLES:
                # 'INHIBITOR' , 'INHIBITOR' , 'INHIBITOR' , 'INHIBITOR' , 'INHIBITOR' , 'INHIBITOR' , 'INHIBITOR' , 'ANT
                # AGONIST' , 'ANTAGONIST' , 'ANTAGONIST'
                'binding_site_comment': 'TEXT',
                # EXAMPLES:
                # 'Binds to ifenprodil site on N-terminal domain.' , 'Benzodiazepine site' , 'Benzodiazepine site' , 'Be
                # nzodiazepine site' , 'Alpha subunit is likely binding site' , 'Alpha subunit is likely binding site' ,
                #  'Binds to the same (or nearby) sites on ß-tubulin as colchicine ' , 'Alpha subunit is likely binding 
                # site' , 'Alpha subunit is likely binding site' , 'Alpha subunit is likely binding site'
                'direct_interaction': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'disease_efficacy': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'max_phase': 'NUMERIC',
                # EXAMPLES:
                # '4' , '4' , '4' , '4' , '4' , '4' , '4' , '4' , '4' , '4'
                'mec_id': 'NUMERIC',
                # EXAMPLES:
                # '13' , '14' , '15' , '16' , '17' , '18' , '19' , '20' , '21' , '22'
                'mechanism_comment': 'TEXT',
                # EXAMPLES:
                # 'Expressed in eye' , 'Expressed in eye' , 'Role in regulating gastric secretion, M3 likely involved' ,
                #  'Indicated for overactive bladder, M3 likely responsible' , 'Role in regulating gastric secretion and
                #  overactive bladded, M3 likely involved' , 'Indicated in mydriasis and regulating gastric secretion, M
                # 3 likely involved (main form in iris)' , 'Role in regulating gastric secretion, M3 likely involved' , 
                # 'Role in regulating gastric secretion, M3 likely involved' , 'Role in regulating gastric secretion, M3
                #  likely involved' , 'Indicated in irritable bowel, M3 likely involved'
                'mechanism_of_action': 'TEXT',
                # EXAMPLES:
                # 'Carbonic anhydrase VII inhibitor' , 'Carbonic anhydrase I inhibitor' , 'Carbonic anhydrase I inhibito
                # r' , 'Carbonic anhydrase I inhibitor' , 'Carbonic anhydrase I inhibitor' , 'Carbonic anhydrase I inhib
                # itor' , 'Cytochrome b inhibitor' , 'Muscarinic acetylcholine receptor M3 antagonist' , 'Muscarinic ace
                # tylcholine receptor M3 antagonist' , 'Muscarinic acetylcholine receptor M3 antagonist'
                'mechanism_refs': 
                {
                    'properties': 
                    {
                        'ref_id': 'TEXT',
                        # EXAMPLES:
                        # 'setid=8e162b6d-8fa6-45f6-80d8-5132d94c1207' , '1460006' , '10713865' , '18336310' , '10713865
                        # ' , 'setid=8e162b6d-8fa6-45f6-80d8-5132d94c1207' , 'setid=b426b6bf-f07e-4580-97ae-dfca1ddf5b8f
                        # ' , '9780702034718 PP. 153' , 'setid=5e29f133-270c-4e5a-8493-e038c163a891' , '9780702034718 PP
                        # . 153'
                        'ref_type': 'TEXT',
                        # EXAMPLES:
                        # 'DailyMed' , 'PubMed' , 'PubMed' , 'PubMed' , 'PubMed' , 'DailyMed' , 'DailyMed' , 'ISBN' , 'D
                        # ailyMed' , 'ISBN'
                        'ref_url': 'TEXT',
                        # EXAMPLES:
                        # 'http://dailymed.nlm.nih.gov/dailymed/lookup.cfm?setid=8e162b6d-8fa6-45f6-80d8-5132d94c1207' ,
                        #  'http://europepmc.org/abstract/MED/1460006' , 'http://europepmc.org/abstract/MED/10713865' , 
                        # 'http://europepmc.org/abstract/MED/18336310' , 'http://europepmc.org/abstract/MED/10713865' , 
                        # 'http://dailymed.nlm.nih.gov/dailymed/lookup.cfm?setid=8e162b6d-8fa6-45f6-80d8-5132d94c1207' ,
                        #  'http://dailymed.nlm.nih.gov/dailymed/lookup.cfm?setid=b426b6bf-f07e-4580-97ae-dfca1ddf5b8f#n
                        # lm34090-1' , 'http://www.isbnsearch.org/isbn/9780702034718' , 'http://dailymed.nlm.nih.gov/dai
                        # lymed/lookup.cfm?setid=5e29f133-270c-4e5a-8493-e038c163a891' , 'http://www.isbnsearch.org/isbn
                        # /9780702034718'
                    }
                },
                'molecular_mechanism': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL19' , 'CHEMBL1201117' , 'CHEMBL1200814' , 'CHEMBL17' , 'CHEMBL20' , 'CHEMBL19' , 'CHEMBL1450' ,
                #  'CHEMBL1200771' , 'CHEMBL1722209' , 'CHEMBL1240'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL19' , 'CHEMBL1201117' , 'CHEMBL20' , 'CHEMBL17' , 'CHEMBL20' , 'CHEMBL19' , 'CHEMBL1450' , 'CHE
                # MBL1201354' , 'CHEMBL1382' , 'CHEMBL1180725'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '1343810' , '1344053' , '1344649' , '1343255' , '1344903' , '1343810' , '1343336' , '1343534' , '13432
                # 71' , '1343367'
                'selectivity_comment': 'TEXT',
                # EXAMPLES:
                # 'M3 selective' , 'Selective' , 'Non-selective but type 5 receptor is overexpressed in Cushing's diseas
                # e' , 'Selective' , 'Selective' , 'Non-selective but type 5 receptor is overexpressed in Cushing's dise
                # ase' , 'Selective' , 'Selective' , 'Selective' , 'Selective'
                'site_id': 'NUMERIC',
                # EXAMPLES:
                # '2617' , '2617' , '2617' , '2651' , '2651' , '2651' , '2651' , '2651' , '2651' , '2627'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2326' , 'CHEMBL261' , 'CHEMBL261' , 'CHEMBL261' , 'CHEMBL261' , 'CHEMBL261' , 'CHEMBL1777' , 'C
                # HEMBL245' , 'CHEMBL245' , 'CHEMBL245'
            }
        }
    }

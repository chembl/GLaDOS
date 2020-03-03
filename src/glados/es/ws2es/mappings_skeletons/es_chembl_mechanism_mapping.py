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
                'action_type': 'TEXT',
                # EXAMPLES:
                # 'PARTIAL AGONIST' , 'ANTAGONIST' , 'PARTIAL AGONIST' , 'ANTAGONIST' , 'POSITIVE ALLOSTERIC MODULATOR' 
                # , 'ANTAGONIST' , 'ANTAGONIST' , 'ANTAGONIST' , 'ANTAGONIST' , 'AGONIST'
                'binding_site_comment': 'TEXT',
                # EXAMPLES:
                # 'Partial agonist of the glycin-site on GRIN1-subunits.' , 'Binds to ifenprodil site on N-terminal doma
                # in.' , 'Benzodiazepine site' , 'Benzodiazepine site' , 'Benzodiazepine site' , 'ATP-binding site' , 'B
                # inds to ifenprodil site on N-terminal domain.' , 'Binds to ifenprodil site on N-terminal domain.' , 'S
                # ee structure of the complex in PDBe under accession codes: 5TH6 (apo) 5TH9 (GS-5745 complex)' , 'Binds
                #  free carboxy terminal amino acids 30-40 of the Abeta40 peptide (PMID:22197375).'
                'direct_interaction': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'disease_efficacy': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'max_phase': 'NUMERIC',
                # EXAMPLES:
                # '2' , '4' , '3' , '4' , '2' , '4' , '2' , '4' , '2' , '4'
                'mec_id': 'NUMERIC',
                # EXAMPLES:
                # '5132' , '611' , '5133' , '612' , '5134' , '613' , '5135' , '614' , '5136' , '615'
                'mechanism_comment': 'TEXT',
                # EXAMPLES:
                # 'Partial agonist of the glycin-site on GRIN1-subunits, preferentially modulates NR2B-containing NMDAR 
                # receptor complexes.' , 'NMDA glycin site partial-agonist, preferentially modulates NR2B-containing NMD
                # AR receptor complexes' , 'PAM of the glycin-site on GRIN1-subunits, binds to other allosteric site?' ,
                #  'Antagonist of the glycin-site on GRIN1-subunits.' , ' Compound is listed in AstaZeneca's clinical an
                # d/or preclinical compound bank and available for research projects (http://openinnovation.astrazeneca.
                # com/what-we-offer/compound/azd9056/).' , 'P2RX3 and P2RX2/3 trimers allosteric antagonist' , 'Developm
                # ent discontinued due to QT prolongation.' , 'Alpha-7 nicotinic receptor: consists entirely of a7 subun
                # its (pentamere) CNS-type.' , 'Alpha-7 nicotinic receptor: consists entirely of a7 subunits (pentamere)
                #  CNS-type.' , 'Open channel stabilizer.'
                'mechanism_of_action': 'TEXT',
                # EXAMPLES:
                # 'Glutamate [NMDA] receptor partial agonist' , 'Serotonin 2a (5-HT2a) receptor antagonist' , 'Glutamate
                #  [NMDA] receptor partial agonist' , 'Serotonin 2a (5-HT2a) receptor antagonist' , 'Glutamate [NMDA] re
                # ceptor positive allosteric modulator' , 'Serotonin 2a (5-HT2a) receptor antagonist' , 'Glutamate [NMDA
                # ] receptor antagonist' , 'Serotonin 2c (5-HT2c) receptor antagonist' , 'P2X purinoceptor 7 antagonist'
                #  , 'Serotonin 2c (5-HT2c) receptor agonist'
                'mechanism_refs': 
                {
                    'properties': 
                    {
                        'ref_id': 'TEXT',
                        # EXAMPLES:
                        # 'NRX-1074' , '0443-059748 PP. 555' , '16051282' , 'setid=5c03ca62-5dd5-4cf5-abc7-b0c2873503dd#
                        # nlm34090-1' , '23009122' , 'setid=5c03ca62-5dd5-4cf5-abc7-b0c2873503dd#nlm34090-1' , 'http://w
                        # ww.vistagen.com/?page_id=11' , 'label/2012/022549s000lbl.pdf' , 'http://openinnovation.astraze
                        # neca.com/what-we-offer/compound/azd9056/' , 'LORCASERIN'
                        'ref_type': 'TEXT',
                        # EXAMPLES:
                        # 'Wikipedia' , 'ISBN' , 'PubMed' , 'DailyMed' , 'PubMed' , 'DailyMed' , 'Other' , 'FDA' , 'Othe
                        # r' , 'Expert'
                        'ref_url': 'TEXT',
                        # EXAMPLES:
                        # 'https://en.wikipedia.org/wiki/NRX-1074' , 'http://www.isbnsearch.org/isbn/0443059748' , 'http
                        # ://europepmc.org/abstract/MED/16051282' , 'http://dailymed.nlm.nih.gov/dailymed/lookup.cfm?set
                        # id=5c03ca62-5dd5-4cf5-abc7-b0c2873503dd#nlm34090-1' , 'http://europepmc.org/abstract/MED/23009
                        # 122' , 'http://dailymed.nlm.nih.gov/dailymed/lookup.cfm?setid=5c03ca62-5dd5-4cf5-abc7-b0c28735
                        # 03dd#nlm34090-1' , 'http://www.vistagen.com/?page_id=11' , 'http://www.accessdata.fda.gov/drug
                        # satfda_docs/label/2012/022549s000lbl.pdf' , 'http://openinnovation.astrazeneca.com/what-we-off
                        # er/compound/azd9056/' , 'http://chembl.blogspot.co.uk/search?q=LORCASERIN'
                    }
                },
                'molecular_mechanism': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3989872' , 'CHEMBL1200948' , 'CHEMBL3544917' , 'CHEMBL1375743' , 'CHEMBL1255840' , 'CHEMBL39898
                # 33' , 'CHEMBL3545351' , 'CHEMBL831' , 'CHEMBL3545108' , 'CHEMBL2095211'
                'parent_molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3989872' , 'CHEMBL644' , 'CHEMBL3544917' , 'CHEMBL708' , 'CHEMBL1255840' , 'CHEMBL708' , 'CHEMB
                # L3545351' , 'CHEMBL831' , 'CHEMBL3545108' , 'CHEMBL360328'
                'record_id': 'NUMERIC',
                # EXAMPLES:
                # '2473316' , '1343777' , '2472686' , '1343179' , '1705337' , '1344176' , '2473609' , '1703520' , '24730
                # 41' , '1679367'
                'selectivity_comment': 'TEXT',
                # EXAMPLES:
                # 'Partial agonist of the glycin-site on GRIN1-subunits, preferentially modulates NR2B-containing NMDAR'
                #  , 'Selective for the NR2B subunit.' , 'Selectivity for the cytisine binding site on CHRNA4.' , 'Selec
                # tivity for the cytisine binding site on CHRNA4.' , 'GRIN2B selective.' , 'Binds with higher affinity t
                # o RARB+RARG' , 'M3 selective' , 'Selective' , 'Selective' , 'Non-selective but type 5 receptor is over
                # expressed in Cushing's disease'
                'site_id': 'NUMERIC',
                # EXAMPLES:
                # '2617' , '2617' , '2617' , '2638' , '2638' , '2646' , '2633' , '2631' , '2631' , '2632'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL2094124' , 'CHEMBL224' , 'CHEMBL2094124' , 'CHEMBL224' , 'CHEMBL2094124' , 'CHEMBL224' , 'CHEMB
                # L2094124' , 'CHEMBL225' , 'CHEMBL4805' , 'CHEMBL225'
            }
        }
    }

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
            '_metadata': 
            {
                'properties': 
                {
                    'all_molecule_chembl_ids': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL1256' , 'CHEMBL2104095' , 'CHEMBL1190' , 'CHEMBL3833372' , 'CHEMBL362558' , 'CHEMBL1201509'
                    #  , 'CHEMBL265502' , 'CHEMBL1201216' , 'CHEMBL3544949' , 'CHEMBL111'
                    'parent_molecule_chembl_id': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL1256' , 'CHEMBL2104095' , 'CHEMBL1190' , 'CHEMBL3833372' , 'CHEMBL362558' , 'CHEMBL1201509'
                    #  , 'CHEMBL265502' , 'CHEMBL1201216' , 'CHEMBL3544949' , 'CHEMBL111'
                    'should_appear_in_browser': 'BOOLEAN',
                    # EXAMPLES:
                    # 'True' , 'True' , 'False' , 'True' , 'True' , 'True' , 'False' , 'False' , 'True' , 'True'
                }
            },
            'action_type': 'TEXT',
            # EXAMPLES:
            # 'POSITIVE ALLOSTERIC MODULATOR' , 'PARTIAL AGONIST' , 'INHIBITOR' , 'INHIBITOR' , 'AGONIST' , 'INHIBITOR' 
            # , 'ANTAGONIST' , 'ANTAGONIST' , 'ANTAGONIST' , 'POSITIVE ALLOSTERIC MODULATOR'
            'binding_site_comment': 'TEXT',
            # EXAMPLES:
            # 'Likely allosteric but unclear whether benzodiazepine or barbiturate site involved' , 'Alpha (p19) subunit
            #  is binding site' , 'Binds to fibroblast growth factor 1 in a hydrophobic manner at L14, C16, L133, and L1
            # 35 residues' , 'Binds with high affinity to TTR at its Thyroxine (T4)-binding sites' , 'Melagatran, the ac
            # tive molecule, binds to the arginine side pocket of thrombin.' , 'Alpha subunit is likely binding site' , 
            # 'Calcitonin receptor is binding site' , 'PDBe: 1ht8 (The 2.7 angstrom resolution model of ovine COX-1 comp
            # lexed with alclofenac)' , 'Alpha subunit is likely binding site' , 'Binds Pro-Asp-Thr-Arg sequences of tan
            # dem repeats in Mucin 1 N-terminal extracellular subunit'
            'direct_interaction': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
            'disease_efficacy': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
            'max_phase': 'NUMERIC',
            # EXAMPLES:
            # '4' , '4' , '4' , '2' , '2' , '4' , '3' , '4' , '2' , '4'
            'mec_id': 'NUMERIC',
            # EXAMPLES:
            # '1629' , '6673' , '1527' , '6385' , '4753' , '253' , '5890' , '239' , '5102' , '6296'
            'mechanism_comment': 'TEXT',
            # EXAMPLES:
            # 'Choline salicylate is a non-steroidal anti-inflammatory drug.' , 'depolarizing' , 'Alcuronium binds to ca
            # rdiac muscarinic receptors simultaneously with their specific antagonist [3H]methyl-N-scopolamine ([3H]NMS
            # ) and allosterically increases their affinity to this ligand.' , 'Also thought to inhibit CDK1, CDK6 and C
            # DK9 (http://www.bloodjournal.org/content/122/21/1636?sso-checked=true)' , 'Clotiapine affects multiple rec
            # eptors. It blocks 5HT3-receptors and downregulates cortical 5HT2- receptors. It has high affinity for the 
            # 5HT-6 and 5HT-7 receptors and acts as an antagonist of the D-4 receptors.' , 'Relebactam is used in combin
            # ation with the beta-lactam antibacterial imipenem and protects imipenem from degradation by certain bacter
            # ial beta-lactamases. Relebactam itself has no antibacterial activity.' , 'mAB' , 'Role in regulating gastr
            # ic secretion, M1 likely involved' , 'Beclamide is a drug that possesses anticonvulsant activity.' , 'Alkyl
            # ating agent'
            'mechanism_of_action': 'TEXT',
            # EXAMPLES:
            # 'GABA-A receptor; anion channel positive allosteric modulator' , 'Unknown' , 'Muscle-type nicotinic acetyl
            # choline receptor partial agonist' , 'Interleukin-23 inhibitor' , 'Glycogen synthase kinase-3 alpha inhibit
            # or' , 'Luteinizing hormone/Choriogonadotropin receptor agonist' , 'Acidic fibroblast growth factor inhibit
            # or' , 'Alpha-1a adrenergic receptor antagonist' , 'C-X-C chemokine receptor type 4 antagonist' , 'Cannabin
            # oid CB1 receptor antagonist'
            'mechanism_refs': 
            {
                'properties': 
                {
                    'ref_id': 'TEXT',
                    # EXAMPLES:
                    # '20083606' , '25057393' , '9780702034718 PP. 164' , '25205227' , '23305709' , 'setid=f93b2baa-03ac
                    # -4650-b35a-20b818d712d6' , '8514' , '9401944' , 'http://mct.aacrjournals.org/content/6/11_Suppleme
                    # nt/A153.short' , '16503766'
                    'ref_type': 'TEXT',
                    # EXAMPLES:
                    # 'PubMed' , 'PubMed' , 'ISBN' , 'PubMed' , 'PubMed' , 'DailyMed' , 'PubChem' , 'PubMed' , 'Other' ,
                    #  'PubMed'
                    'ref_url': 'TEXT',
                    # EXAMPLES:
                    # 'http://europepmc.org/abstract/MED/20083606' , 'http://europepmc.org/abstract/MED/25057393' , 'htt
                    # p://www.isbnsearch.org/isbn/9780702034718' , 'http://europepmc.org/abstract/MED/25205227' , 'http:
                    # //europepmc.org/abstract/MED/23305709' , 'http://dailymed.nlm.nih.gov/dailymed/lookup.cfm?setid=f9
                    # 3b2baa-03ac-4650-b35a-20b818d712d6' , 'https://pubchem.ncbi.nlm.nih.gov/compound/8514' , 'http://e
                    # uropepmc.org/abstract/MED/9401944' , 'http://mct.aacrjournals.org/content/6/11_Supplement/A153.sho
                    # rt' , 'http://europepmc.org/abstract/MED/16503766'
                }
            },
            'molecular_mechanism': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1256' , 'CHEMBL2104095' , 'CHEMBL1134' , 'CHEMBL3833372' , 'CHEMBL362558' , 'CHEMBL1201509' , 'CHEM
            # BL413376' , 'CHEMBL1201044' , 'CHEMBL3544949' , 'CHEMBL111'
            'parent_molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1256' , 'CHEMBL2104095' , 'CHEMBL1190' , 'CHEMBL3833372' , 'CHEMBL362558' , 'CHEMBL1201509' , 'CHEM
            # BL265502' , 'CHEMBL1201216' , 'CHEMBL3544949' , 'CHEMBL111'
            'record_id': 'NUMERIC',
            # EXAMPLES:
            # '1344953' , '1700302' , '1343488' , '1707161' , '2472886' , '1343544' , '1699551' , '1344726' , '2472748' 
            # , '1699368'
            'selectivity_comment': 'TEXT',
            # EXAMPLES:
            # 'Inhibition was reversible and competitive in nature with a KI of 0.7 mM' , 'Inhibits serine beta lactamas
            # es (SHV, TEM, CTX-M type and Enterobacter cloacae P99, Pseudomonase derived cephalosporinase PDC and Klebs
            # iella pneumoniae carbapenemase KPC). Not active against MBLs, some oxacillinases and certain GES allelles.
            #  Can restore the activity of imipenem/cilastatin combinations against KPC-producing Enterobacteriaceae and
            #  PDC-producing Pseudomonas aeruginosa.' , 'Specifically directed against the alphav subunit of human integ
            # rins.' , 'High selectivity for CXCR2 over CXCR1' , 'Higher selectivity for JAK2 over family members JAK1, 
            # JAK3 and TYK2.' , 'Antibody binding affinity: Kd~1 nmol/L' , 'Bilastine has high specificity for H1-recept
            # ors while has negligible affinity for 30 other receptors (serotonin, bradykinin, leukotriene-D4, muscarini
            # c M3-receptors, ¿1-adrenoceptors, ß2-adrenoceptors, and H2- and H3-histamine receptors).' , 'Isoxsuprine h
            # as a higher affinity of ¿1-adrenoreceptors (Kd=59+-15nM, adrenoreceptors in rat vas deferens) than for ß2-
            # adrenoceptors ( Kd=3900+-500nM adrenoreceptors in rat vas deferens).' , 'It binds to the alpha2/alpha3 sub
            # types of the GABAA receptor' , 'Selective'
            'site_id': 'NUMERIC',
            # EXAMPLES:
            # '9800' , '2651' , '2635' , '9803' , '2651' , '2617' , '2617' , '2617' , '2645' , '2644'
            'target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL2093872' , 'CHEMBL2362997' , 'CHEMBL2364154' , 'CHEMBL2850' , 'CHEMBL1854' , 'CHEMBL2120' , 'CHEMBL
            # 229' , 'CHEMBL2107' , 'CHEMBL218' , 'CHEMBL211'
        }
    }

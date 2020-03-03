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
                '_metadata': 
                {
                    'properties': 
                    {
                        'es_completion': 'TEXT',
                        # EXAMPLES:
                        # '{'weight': 60, 'input': 'A solid-phase synthesis of heterocyclic beta-turn mimetics of sialyl
                        #  Lewis X, which is a natural carbohydrate ligand of selectins, was established. This synthetic
                        #  method could be very useful for drug discovery of selectin antagonists using combinatorial ch
                        # emistry techniques.'}' , '{'weight': 10, 'input': '10.1016/S0960-894X(01)80160-8'}' , '{'weigh
                        # t': 60, 'input': '(5-Amino-1,3-dimethyl-1H-pyrazol-4-yl)(2-fluorophenyl)methanone (1) was foun
                        # d to have an antipsychotic-like profile in behavioral tests predictive of antipsychotic effica
                        # cy but, unlike available antipsychotic agents, did not bind in vitro to dopamine receptors. Up
                        # on further evaluation, 1 was found to cause clonic seizures in aged rodents. An examination of
                        #  related structures revealed that 5-(substituted aminoacetamide) analogues of 1 shared this no
                        # vel pharmacology and did not cause seizures. The synthesis and pharmacological evaluation of t
                        # his series of compounds are described. Two compounds, 2-(diethylamino)acetamide (25) and 2-[[3
                        # -(2-methyl-1-piperidinyl)propyl]-amino]acetamide (38), were selected for examination in second
                        # ary tests. Like known antipsychotics both compounds reduced spontaneous locomotion in mice at 
                        # doses that did not cause ataxia and inhibited conditioned avoidance selectively in both rats a
                        # nd monkeys. Unlike known antipsychotics neither 25 nor 38 elicited dystonic movements in halop
                        # eridol-sensitized cebus monkeys, a primate model of antipsychotic-induced extrapyramidal side 
                        # effects. Biochemical studies indicated that these compounds act via a nondopaminergic mechanis
                        # m. Neither 25 nor 38 bound to dopamine receptors in vitro or caused changes in striatal dopami
                        # ne metabolism in vivo. In addition, they did not raise serum prolactin levels as do known anti
                        # psychotics. Although adverse animal toxicological findings have precluded clinical evaluation 
                        # of these agents, the present results indicate that it is possible to identify at the preclinic
                        # al level nondopaminergic compounds with antipsychotic-like properties.'}' , '{'weight': 100, '
                        # input': 'Nantermet PG, Barrow JC, Lindsley SR, Young M, Mao SS, Carroll S, Bailey C, Bosserman
                        #  M, Colussi D, McMasters DR, Vacca JP, Selnick HG.'}' , '{'weight': 100, 'input': 'Synthesis a
                        # nd evaluation of quinoline carboxyguanidines as antidiabetic agents.'}' , '{'weight': 10, 'inp
                        # ut': 'CHEMBL1127250'}' , '{'weight': 60, 'input': 'The preparation of a series of 1H-imidazol-
                        # 1-yl-substituted benzo[b]furan-, benzo[b]thiophene-, and indolecarboxylic acids is described. 
                        # Most of the compounds were potent inhibitors of TxA2 synthetase in vitro, and the distance bet
                        # ween the imidazole and carboxylic acid groups was found to be important for optimal potency. T
                        # he most potent compound in vivo was 6-(1H-imidazol-1-ylmethyl)-3-methylbenzo[b]thiophene-2-car
                        # boxylic acid (71), which, in conscious dogs, showed a similar profile of activity to that of d
                        # azoxiben (1).'}' , '{'weight': 100, 'input': 'Capped dipeptide phenethylamide inhibitors of th
                        # e HCV NS3 protease.'}' , '{'weight': 60, 'input': 'A new glucuronylated prodrug of nornitrogen
                        #  mustard, incorporating the same spacer group as the doxorubicin prodrug HMR 1826, has been pr
                        # epared. Upon exposure to E. coli beta-glucuronidase, fast hydrolysis occurs but a lower cytoto
                        # xicity against LoVo cancer cells is observed compared to the nornitrogen mustard alone. This i
                        # s explained by cyclization of the intermediate carbamic acid to the inactive chloroethyl oxazo
                        # lidinone.'}' , '{'weight': 10, 'input': '10.1016/s0960-894x(01)00263-3'}'
                    }
                },
                'abstract': 'TEXT',
                # EXAMPLES:
                # '' , 'The synthesis and in vivo activities of a series of substituted quinoline carboxyguanidines as a
                #  possible novel class of antidiabetic agents is described.' , '' , '' , '' , 'A series of novel C2-exo
                #  unsaturated pyrrolo[2,1-c][1,4]benzodiazepines (PBDs) has been synthesised via a versatile pro-C2 ket
                # one precursor. C2-exo-unsaturation enhances both DNA-binding reactivity and in vitro cytotoxic potency
                # .' , '' , '' , '' , 'The present manuscript details structure-activity relationship studies of lead st
                # ructure 1, which led to the discovery of CCR1 antagonists >100-fold more potent than 1.'
                'authors': 'TEXT',
                # EXAMPLES:
                # 'Kurokawa K, Kumihara H, Kondo H.' , 'Kleinman EF, Fray AH, Holt WF, Ravi Kiron M, Murphy WR, Purcell 
                # IM, Rosati RL' , 'Wise LD, Butler DE, DeWald HA, Lustgarten D, Coughenour LL, Downs DA, Heffner TG, Pu
                # gsley TA.' , 'Nantermet PG, Barrow JC, Lindsley SR, Young M, Mao SS, Carroll S, Bailey C, Bosserman M,
                #  Colussi D, McMasters DR, Vacca JP, Selnick HG.' , 'Edmont D, Rocher R, Plisson C, Chenault J.' , 'Hua
                # ng L, Kashiwada Y, Cosentino L, Fan S, Lee K' , 'Cross PE, Dickinson RP, Parry MJ, Randall MJ.' , 'Niz
                # i E, Koch U, Ontoria JM, Marchetti A, Narjes F, Malancona S, Matassa VG, Gardelli C.' , 'Papot S, Comb
                # aud D, Bosslet K, Gerken M, Czech J, Gesson JP.' , 'Phoon CW, Ng PY, Ting AE, Yeo SL, Sim MM.'
                'doc_type': 'TEXT',
                # EXAMPLES:
                # 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLI
                # CATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1133272' , 'CHEMBL1150545' , 'CHEMBL1123363' , 'CHEMBL1147549' , 'CHEMBL1133273' , 'CHEMBL11272
                # 50' , 'CHEMBL1123466' , 'CHEMBL1147550' , 'CHEMBL1133274' , 'CHEMBL1134109'
                'doi': 'TEXT',
                # EXAMPLES:
                # '10.1016/s0960-894x(00)00358-9' , '10.1016/S0960-894X(01)80160-8' , '10.1021/jm00159a011' , '10.1016/j
                # .bmcl.2004.02.033' , '10.1016/s0960-894x(00)00354-1' , '10.1016/S0960-894X(01)80161-X' , '10.1021/jm00
                # 159a012' , '10.1016/j.bmcl.2004.02.032' , '10.1016/s0960-894x(00)00353-x' , '10.1016/s0960-894x(01)002
                # 63-3'
                'first_page': 'NUMERIC',
                # EXAMPLES:
                # '1827' , '589' , '1628' , '2141' , '1831' , '593' , '1637' , '2151' , '1835' , '1647'
                'issue': 'NUMERIC',
                # EXAMPLES:
                # '16' , '4' , '9' , '9' , '16' , '4' , '9' , '9' , '16' , '13'
                'journal': 'TEXT',
                # EXAMPLES:
                # 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'J. Med. Chem.' , 'Bioorg. Med. Chem. Lett.'
                #  , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'J. Med. Chem.' , 'Bioorg. Med. Chem. Let
                # t.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.'
                'journal_full_title': 'TEXT',
                # EXAMPLES:
                # 'Bioorganic & medicinal chemistry letters.' , 'Bioorganic & medicinal chemistry letters.' , 'Journal o
                # f medicinal chemistry.' , 'Bioorganic & medicinal chemistry letters.' , 'Bioorganic & medicinal chemis
                # try letters.' , 'Bioorganic & medicinal chemistry letters.' , 'Journal of medicinal chemistry.' , 'Bio
                # organic & medicinal chemistry letters.' , 'Bioorganic & medicinal chemistry letters.' , 'Bioorganic & 
                # medicinal chemistry letters.'
                'last_page': 'NUMERIC',
                # EXAMPLES:
                # '1830' , '592' , '1637' , '2145' , '1834' , '598' , '1643' , '2154' , '1837' , '1650'
                'patent_id': 'TEXT',
                # EXAMPLES:
                # 'US-9321727-B2' , 'US-9290454-B2' , 'US-9290456-B2' , 'US-9290463-B2' , 'US-9296747-B1' , 'US-9296734-
                # B2' , 'US-9296736-B2' , 'US-9296745-B2' , 'US-9296748-B2' , 'US-9302981-B2'
                'pubmed_id': 'NUMERIC',
                # EXAMPLES:
                # '10969978' , '2875184' , '15080996' , '10969979' , '3746813' , '15080998' , '10969980' , '11425528' , 
                # '7310821' , '3336022'
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'title': 'TEXT',
                # EXAMPLES:
                # 'A solid-phase synthesis for beta-turn mimetics of sialyl Lewis X.' , 'CP-71,362, an unusually potent 
                # inhibitor of rat and dog renin' , '(5-Amino-1,3-dimethyl-1H-pyrazol-4-yl)(2-fluorophenyl)methanones . 
                # A series of novel potential antipsychotic agents.' , 'Imidazole acetic acid TAFIa inhibitors: SAR stud
                # ies centered around the basic P(1)(') group.' , 'Synthesis and evaluation of quinoline carboxyguanidin
                # es as antidiabetic agents.' , '3,4-Di-o-()-camphanoyl-(+)-ciskhellactone and related compounds: A. new
                #  class of potent anti-HIV agents' , 'Selective thromboxane synthetase inhibitors. 3. 1H-imidazol-1-yl-
                # substituted benzo[b]furan-, benzo[b]thiophene-, and indole-2- and -3-carboxylic acids.' , 'Capped dipe
                # ptide phenethylamide inhibitors of the HCV NS3 protease.' , 'Synthesis and cytotoxic activity of a glu
                # curonylated prodrug of nornitrogen mustard.' , 'Biological evaluation of hepatitis C virus helicase in
                # hibitors.'
                'volume': 'NUMERIC',
                # EXAMPLES:
                # '10' , '4' , '29' , '14' , '10' , '4' , '29' , '14' , '10' , '11'
                'year': 'NUMERIC',
                # EXAMPLES:
                # '2000' , '1994' , '1986' , '2004' , '2000' , '1994' , '1986' , '2004' , '2000' , '2001'
            }
        }
    }

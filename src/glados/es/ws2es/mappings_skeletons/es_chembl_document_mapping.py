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
                    'es_completion': 'TEXT',
                    # EXAMPLES:
                    # '{'weight': 60, 'input': 'Pescapreins XXI-XXX (1-10), pentasaccharide resin glycosides, together w
                    # ith the known pescapreins I-IV and stoloniferin III were isolated from the aerial parts of Ipomoea
                    #  pes-caprae (beach morning-glory). The pescapreins are macrolactones of simonic acid B, partially 
                    # esterified with different fatty acids. The lactonization site of the aglycone, jalapinolic acid, w
                    # as located at C-2 or C-3 of the second saccharide moiety. Their structures were established by a c
                    # ombination of spectroscopic and chemical methods. Compounds 1-10 were evaluated for their potentia
                    # l to modulate multidrug resistance in the human breast cancer cell line MCF-7/ADR. The combined us
                    # e of these new compounds at a concentration of 5 ¿g/mL increased the cytotoxicity of doxorubicin b
                    # y 1.5-3.7-fold.'}' , '{'weight': 1, 'input': '1998'}' , '{'weight': 100, 'input': 'Chu J, Suh DH, 
                    # Lee G, Han AR, Chae SW, Lee HJ, Seo EK, Lim HJ.'}' , '{'weight': 10, 'input': 'CHEMBL3044640'}' , 
                    # '{'weight': 10, 'input': 'CHEMBL1153255'}' , '{'weight': 60, 'input': 'A data set of 348 urea-like
                    #  compounds that inhibit the soluble epoxide hydrolase enzyme in mice and humans is examined. Compo
                    # unds having IC(50) values ranging from 0.06 to >500 microM (murine) and 0.10 to >500 microM (human
                    # ) are categorized as active or inactive for classification, while quantitation is performed on sma
                    # ller compound subsets ranging from 0.07 to 431 microM (murine) and 0.11 to 490 microM (human). Eac
                    # h compound is represented by calculated structural descriptors that encode topological, geometrica
                    # l, electronic, and polar surface features. Multiple linear regression (MLR) and computational neur
                    # al networks (CNNs) are employed for quantitative models. Three classification algorithms, k-neares
                    # t neighbor (kNN), linear discriminant analysis (LDA), and radial basis function neural networks (R
                    # BFNN), are used to categorize compounds as active or inactive based on selected data split points.
                    #  Quantitative modeling of human enzyme inhibition results in a nonlinear, five-descriptor model wi
                    # th root-mean-square errors (log units of IC(50) [microM]) of 0.616 (r(2) = 0.66), 0.674 (r(2) = 0.
                    # 61), and 0.914 (r(2) = 0.33) for training, cross-validation, and prediction sets, respectively. Th
                    # e best classification results for human and murine enzyme inhibition are found using kNN. Human cl
                    # assification rates using a seven-descriptor model for training and prediction sets are 89.1% and 9
                    # 1.4%, respectively. Murine classification rates using a five-descriptor model for training and pre
                    # diction sets are 91.5% and 88.6%, respectively.'}' , '{'weight': 60, 'input': 'The RNA recognition
                    #  motif (RRM) is one of the most common RNA binding domains. There have been few investigations of 
                    # small molecule inhibitors of RRM-RNA complexes, although these inhibitors could be valuable tools 
                    # for probing biological processes involving RRM-RNA complexes and would have the potential to be ef
                    # fective drugs. In this paper, the inhibition by small molecules of the complex formed between the 
                    # N-terminal RRM of the U1A protein and stem loop 2 of U1 snRNA has been investigated. An aminoacrid
                    # ine derivative has been found to promote dissociation of the U1A-stem loop 2 RNA complex with an I
                    # C(50) value of 1 microM. Fluorescence experiments indicate that two aminoacridine ligands bind to 
                    # each RNA target site. RNase A footprinting suggests that one binding site may be near the base pai
                    # r that closes the loop and the other may be in a more flexible region of the loop. The addition of
                    #  the aminoacridine derivative to stem loop 2 RNA increases the susceptibility of other portions of
                    #  the loop to digestion by RNase A, which implies that binding of the ligand changes the conformati
                    # on or dynamics of the stem loop target site. Either direct binding to the RNA or indirect alterati
                    # on of the structure or dynamics of the loop would be likely to inhibit binding of the U1A protein 
                    # to this RNA.'}' , '{'weight': 10, 'input': '7401111'}' , '{'weight': 100, 'input': 'Apogossypolone
                    #  derivatives as anticancer agents'}' , '{'weight': 1, 'input': '2001'}'
                    'related_activities': 
                    {
                        'properties': 
                        {
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '71' , '12' , '20' , '5' , '50' , '50' , '4' , '17' , '20' , '39'
                        }
                    },
                    'related_assays': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3054435 CHEMBL3054452 CHEMBL3080633 CHEMBL3059548 CHEMBL3080641 CHEMBL3054451 CHEMB
                            # L3054988 CHEMBL3054440 CHEMBL3080640 CHEMBL3054430 CHEMBL3054428 CHEMBL3054444 CHEMBL30806
                            # 28 CHEMBL3054429 CHEMBL3059546 CHEMBL3054443 CHEMBL3054432 CHEMBL3080629 CHEMBL3054433 CHE
                            # MBL3054447 CHEMBL3080630 CHEMBL3080631 CHEMBL3054448 CHEMBL3059549 CHEMBL3054431 CHEMBL305
                            # 9551 CHEMBL3054434 CHEMBL3054450 CHEMBL3054414 CHEMBL3054415 CHEMBL3054438 CHEMBL3054449 C
                            # HEMBL3054437 CHEMBL3054446 CHEMBL3080642 CHEMBL3054442 CHEMBL3080632 CHEMBL3054439 CHEMBL3
                            # 054987 CHEMBL3059547 CHEMBL3054445 CHEMBL3054436 CHEMBL3054441 CHEMBL3059550' , 'CHEMBL817
                            # 066 CHEMBL764912 CHEMBL817726 CHEMBL764904 CHEMBL764913 CHEMBL821128' , 'CHEMBL810460 CHEM
                            # BL810462 CHEMBL809079 CHEMBL810461' , 'CHEMBL817608 CHEMBL814272 CHEMBL857418' , 'CHEMBL76
                            # 4617 CHEMBL764619 CHEMBL764120 CHEMBL763899 CHEMBL764616 CHEMBL764122 CHEMBL764121 CHEMBL7
                            # 64618 CHEMBL764620 CHEMBL764615 CHEMBL764123' , 'CHEMBL3707894 CHEMBL3707868 CHEMBL3707566
                            #  CHEMBL3705613 CHEMBL3705614' , 'CHEMBL942540 CHEMBL942541 CHEMBL942542' , 'CHEMBL1032124 
                            # CHEMBL1032131 CHEMBL1032128 CHEMBL1032125 CHEMBL1032126 CHEMBL1032129 CHEMBL1032123 CHEMBL
                            # 1032122 CHEMBL1032132 CHEMBL1032127 CHEMBL1032130' , 'CHEMBL763572 CHEMBL763573 CHEMBL7843
                            # 24 CHEMBL783491' , 'CHEMBL4035421 CHEMBL4035426 CHEMBL4035422 CHEMBL4035423 CHEMBL4035425 
                            # CHEMBL4035420 CHEMBL4035424'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '44' , '6' , '4' , '3' , '11' , '5' , '3' , '11' , '4' , '7'
                        }
                    },
                    'related_cell_lines': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3308376' , 'CHEMBL3307574 CHEMBL3307655' , 'CHEMBL3307718 CHEMBL3308495 CHEMBL33083
                            # 76 CHEMBL3307635' , 'CHEMBL3307651 CHEMBL3307674 CHEMBL3308530 CHEMBL3307648 CHEMBL3308403
                            #  CHEMBL3307716 CHEMBL3307570 CHEMBL3307564' , 'CHEMBL3308376 CHEMBL3307501 CHEMBL3307651 C
                            # HEMBL3308372 CHEMBL3307570 CHEMBL3307691' , 'CHEMBL3307519' , 'CHEMBL3307512' , 'CHEMBL330
                            # 7530 CHEMBL3307574 CHEMBL3308043 CHEMBL3308027 CHEMBL3307715' , 'CHEMBL3308072' , 'CHEMBL3
                            # 307569 CHEMBL3308811'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '2' , '4' , '8' , '6' , '1' , '1' , '5' , '1' , '2'
                        }
                    },
                    'related_compounds': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL444478 CHEMBL465226' , 'CHEMBL280444 CHEMBL60718 CHEMBL14566 CHEMBL279866' , 'CHEMB
                            # L11405 CHEMBL11293 CHEMBL11522 CHEMBL11524 CHEMBL11658 CHEMBL441348 CHEMBL11326 CHEMBL1083
                            # 5 CHEMBL11448 CHEMBL11552' , 'CHEMBL97338 CHEMBL320369' , 'CHEMBL1203842 CHEMBL1203838 CHE
                            # MBL1203837 CHEMBL26717 CHEMBL1744259 CHEMBL1203839 CHEMBL1788154 CHEMBL1203845 CHEMBL53910
                            # 5 CHEMBL1744260 CHEMBL1744256 CHEMBL557973 CHEMBL1744257 CHEMBL1744262 CHEMBL1203841 CHEMB
                            # L1744261 CHEMBL1203844 CHEMBL1744258 CHEMBL1203843 CHEMBL1203836 CHEMBL1203840' , 'CHEMBL1
                            # 269012 CHEMBL1269070 CHEMBL1269077 CHEMBL1269107 CHEMBL1269076 CHEMBL1269075 CHEMBL1272224
                            #  CHEMBL1269073 CHEMBL1269072 CHEMBL1269074 CHEMBL1272170 CHEMBL1269110' , 'CHEMBL442824 CH
                            # EMBL445528 CHEMBL447797 CHEMBL502136' , 'CHEMBL3216679 CHEMBL553697' , 'CHEMBL13512 CHEMBL
                            # 273832 CHEMBL268976 CHEMBL428496 CHEMBL871 CHEMBL295740 CHEMBL870 CHEMBL13513 CHEMBL275536
                            #  CHEMBL48095' , 'CHEMBL4091223 CHEMBL4099879 CHEMBL4083431 CHEMBL4098101 CHEMBL417016 CHEM
                            # BL1233058 CHEMBL4064422 CHEMBL4070292 CHEMBL4061623 CHEMBL4080071 CHEMBL4073003 CHEMBL4092
                            # 131'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '2' , '4' , '10' , '2' , '21' , '12' , '4' , '2' , '10' , '12'
                        }
                    },
                    'related_targets': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL613465 CHEMBL612899' , 'CHEMBL2407 CHEMBL3314' , 'CHEMBL2409 CHEMBL4140' , 'CHEMBL6
                            # 12545 CHEMBL345' , 'CHEMBL2331 CHEMBL4617 CHEMBL4874' , 'CHEMBL4625 CHEMBL4860 CHEMBL6044 
                            # CHEMBL4361' , 'CHEMBL612558' , 'CHEMBL612514 CHEMBL345' , 'CHEMBL612545 CHEMBL376' , 'CHEM
                            # BL3668 CHEMBL612545 CHEMBL4531 CHEMBL5475 CHEMBL4105904 CHEMBL4915 CHEMBL4105945'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '2' , '2' , '2' , '2' , '3' , '4' , '1' , '2' , '2' , '7'
                        }
                    },
                    'related_tissues': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3559721' , 'CHEMBL3638215 CHEMBL3559724' , 'CHEMBL3559721 CHEMBL3559723' , 'CHEMBL3
                            # 638178 CHEMBL3559723 CHEMBL3832984' , 'CHEMBL3638212 CHEMBL3559721 CHEMBL3638188' , 'CHEMB
                            # L3987659 CHEMBL3638241 CHEMBL3638188 CHEMBL3638273 CHEMBL3638233 CHEMBL3638219 CHEMBL35597
                            # 23 CHEMBL3638187 CHEMBL3832984 CHEMBL3559722 CHEMBL3638176' , 'CHEMBL3559723' , 'CHEMBL355
                            # 9721 CHEMBL3559723' , 'CHEMBL3638261' , 'CHEMBL3559721 CHEMBL3638178'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '2' , '2' , '3' , '3' , '11' , '1' , '2' , '1' , '2'
                        }
                    },
                    'similar_documents': 
                    {
                        'properties': 
                        {
                            'document_chembl_id': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL1817614' , 'CHEMBL3259756' , 'CHEMBL2074108' , 'CHEMBL3046322' , 'CHEMBL1128985' , 
                            # 'CHEMBL1139516' , 'CHEMBL1126714' , 'CHEMBL1152066' , 'CHEMBL1137320' , 'CHEMBL1136873'
                            'doi': 'TEXT',
                            # EXAMPLES:
                            # '10.1016/j.bmc.2011.07.036' , '10.1021/np400950h' , '10.1006/bbrc.1999.1850' , '10.1016/j.
                            # indcrop.2012.12.038' , '10.1016/0960-894X(96)00065-0' , '10.1021/jm0500929' , '10.1021/jm0
                            # 0064a008' , '10.1016/0960-894X(96)00440-4' , '10.1021/jm060967z' , '10.1016/j.bmcl.2009.04
                            # .005'
                            'first_page': 'NUMERIC',
                            # EXAMPLES:
                            # '5559' , '855' , '492' , '283' , '543' , '3621' , '1746' , '2399' , '6539' , '3059'
                            'journal': 'TEXT',
                            # EXAMPLES:
                            # 'Bioorg. Med. Chem.' , 'J. Nat. Prod.' , 'Biochem. Biophys. Res. Commun.' , 'Ind Crops Pro
                            # d' , 'Bioorg. Med. Chem. Lett.' , 'J. Med. Chem.' , 'J. Med. Chem.' , 'Bioorg. Med. Chem. 
                            # Lett.' , 'J. Med. Chem.' , 'Bioorg. Med. Chem. Lett.'
                            'last_page': 'NUMERIC',
                            # EXAMPLES:
                            # '5568' , '862' , '496' , '292' , '546' , '3629' , '1753' , '2404' , '6548' , '3062'
                            'mol_tani': 'NUMERIC',
                            # EXAMPLES:
                            # '0.03' , '0.0' , '0.0' , '0.22' , '0.0' , '0.0' , '0.0' , '0.0' , '0.76' , '0.02'
                            'pubmed_id': 'NUMERIC',
                            # EXAMPLES:
                            # '21856162' , '24720452' , '10600530' , '15887969' , '8510102' , '9873732' , '17064072' , '
                            # 19394221' , '12238931' , '15369397'
                            'tid_tani': 'NUMERIC',
                            # EXAMPLES:
                            # '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '1.0' , '0.0' , '1.0'
                            'title': 'TEXT',
                            # EXAMPLES:
                            # 'Inhibitory effects of chalcone glycosides isolated from Brassica rapa L. 'hidabeni' and t
                            # heir synthetic derivatives on LPS-induced NO production in microglia.' , 'Voacamine modula
                            # tes the sensitivity to doxorubicin of resistant osteosarcoma and melanoma cells and does n
                            # ot induce toxicity in normal fibroblasts.' , 'Inhibition of P-glycoprotein activity and ch
                            # emosensitization of multidrug-resistant ovarian carcinoma 2780AD cells by hexanoylglucosyl
                            # ceramide.' , 'Insect growth regulatory effects by diterpenes from Calceolaria talcana Grau
                            #  & Ehrhart (Calceolariaceae: Scrophulariaceae) against Spodoptera frugiperda and Drosophil
                            # a melanogaster' , 'Mechanism-based inactivation of -chymotrypsin' , 'Optimization of amide
                            # -based inhibitors of soluble epoxide hydrolase with improved water solubility.' , 'Structu
                            # re, DNA minor groove binding, and base pair specificity of alkyl- and aryl-linked bis(amid
                            # inobenzimidazoles) and bis(amidinoindoles).' , '7,10-Bis(2-mercapto-2-methyl)propyl-7,10-d
                            # iazapalmitic acid: a novel, N2S2 ligand for technetium-99m' , 'A novel class of carbonic a
                            # nhydrase inhibitors: glycoconjugate benzene sulfonamides prepared by "click-tailing".' , '
                            # Application of combinatorial biocatalysis for a unique ring expansion of dihydroxymethylze
                            # aralenone.'
                            'volume': 'NUMERIC',
                            # EXAMPLES:
                            # '19' , '77' , '266' , '45' , '6' , '48' , '36' , '6' , '49' , '19'
                            'year': 'NUMERIC',
                            # EXAMPLES:
                            # '2011' , '2014' , '1999' , '2013' , '1996' , '2005' , '1993' , '1996' , '2006' , '2009'
                        }
                    },
                    'source': 
                    {
                        'properties': 
                        {
                            'src_description': 'TEXT',
                            # EXAMPLES:
                            # 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific 
                            # Literature' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature' 
                            # , 'Scientific Literature' , 'BindingDB Database' , 'Scientific Literature'
                            'src_id': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '37' , '1'
                            'src_short_name': 'TEXT',
                            # EXAMPLES:
                            # 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 
                            # 'LITERATURE' , 'LITERATURE' , 'BINDINGDB' , 'LITERATURE'
                        }
                    }
                }
            },
            'abstract': 'TEXT',
            # EXAMPLES:
            # 'The total synthesis of optically active phenylbutenoid dimers 1, 3, and ent-3 is described. The key step 
            # to access optically active cyclohexene rings was achieved by Diels-Alder reaction of chiral acryloyloxazol
            # inone 9 and phenylbetadiene 10.' , '' , '' , '' , '' , '' , '' , '' , '' , ''
            'authors': 'TEXT',
            # EXAMPLES:
            # 'Yu BW, Luo JG, Wang JS, Zhang DM, Yu SS, Kong LY.' , 'Prinsep MR, Patterson GM, Larsen LK, Smith CD.' , '
            # Chu J, Suh DH, Lee G, Han AR, Chae SW, Lee HJ, Seo EK, Lim HJ.' , 'Munoz E, Lamilla C, Marin JC, Alarcon J
            # , Cespedes CL.' , 'Ohba T, Wakayama J, Ikeda E, Takei H' , 'McElroy NR, Jurs PC, Morisseau C, Hammock BD.'
            #  , 'Gayle AY, Baranger AM.' , 'Blank B, Krog AJ, Weiner G, Pendleton RG.' , 'Ivanchina NV, Kicha AA, Kalin
            # ovsky AI, Dmitrenok PS, Prokofreva NG, Stonik VA.' , 'Xiang YZ, Liao YL, Zhang J, Zhang DW, Chen SY, Lu QS
            # , Zhang Y, Lin HH, Yu XQ.'
            'doc_type': 'TEXT',
            # EXAMPLES:
            # 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATI
            # ON' , 'PUBLICATION' , 'PATENT' , 'PUBLICATION'
            'document_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1773028' , 'CHEMBL1150948' , 'CHEMBL1817658' , 'CHEMBL3044640' , 'CHEMBL1153255' , 'CHEMBL1136721' 
            # , 'CHEMBL1135200' , 'CHEMBL1121600' , 'CHEMBL3638406' , 'CHEMBL1155728'
            'doi': 'TEXT',
            # EXAMPLES:
            # '10.1021/np100640f' , '10.1021/np970566+' , '10.1021/np100942e' , '10.1016/j.indcrop.2012.05.014' , '10.10
            # 16/0960-894X(96)00178-3' , '10.1021/jm020269o' , '10.1016/s0960-894x(02)00636-4' , '10.1021/jm00182a005' ,
            #  '10.1021/np000572x' , '10.1016/j.bmcl.2009.05.015'
            'first_page': 'NUMERIC',
            # EXAMPLES:
            # '620' , '1133' , '1817' , '137' , '1127' , '1066' , '2839' , '837' , '945' , '3458'
            'issue': 'NUMERIC',
            # EXAMPLES:
            # '4' , '9' , '8' , '10' , '6' , '20' , '8' , '7' , '13' , '15'
            'journal': 'TEXT',
            # EXAMPLES:
            # 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'Ind Crops Prod' , 'Bioorg. Med. Chem. Lett.' , 'J. 
            # Med. Chem.' , 'Bioorg. Med. Chem. Lett.' , 'J. Med. Chem.' , 'J. Nat. Prod.' , 'Bioorg. Med. Chem. Lett.'
            'journal_full_title': 'TEXT',
            # EXAMPLES:
            # 'Journal of natural products.' , 'Journal of natural products.' , 'Journal of natural products.' , 'Indust
            # rial crops and products.' , 'Bioorganic & medicinal chemistry letters.' , 'Journal of medicinal chemistry.
            # ' , 'Bioorganic & medicinal chemistry letters.' , 'Journal of medicinal chemistry.' , 'Journal of natural 
            # products.' , 'Bioorganic & medicinal chemistry letters.'
            'last_page': 'NUMERIC',
            # EXAMPLES:
            # '628' , '1136' , '1821' , '144' , '1132' , '1080' , '2842' , '840' , '947' , '3460'
            'patent_id': 'TEXT',
            # EXAMPLES:
            # 'US-8937193-B2' , 'US-9328124-B2' , 'US-8487096-B2' , 'US-9321766-B1' , 'US20160355563A1' , 'US-9242995-B2
            # ' , 'WO-2012094462-A2' , 'US-8889708-B2' , 'US-8673966-B2' , 'US-9126987-B2'
            'pubmed_id': 'NUMERIC',
            # EXAMPLES:
            # '21338052' , '9748382' , '21770432' , '12620084' , '12270158' , '7401111' , '11473430' , '19464883' , '284
            # 83453' , '17157501'
            'src_id': 'NUMERIC',
            # EXAMPLES:
            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '37' , '1'
            'title': 'TEXT',
            # EXAMPLES:
            # 'Pentasaccharide resin glycosides from Ipomoea pes-caprae.' , 'Tolyporphins J and K, two further porphinoi
            # d metabolites from the cyanobacterium Tolypothrix nodosa.' , 'Synthesis and biological activity of optical
            # ly active phenylbutenoid dimers.' , 'Antifeedant, insect growth regulatory and insecticidal effects of Cal
            # ceolaria talcana (Calceolariaceae) on Drosophila melanogaster and Spodoptera frugiperda' , 'Studies on irr
            # eversible inhibition of serine proteases by -sulfonyloxyketone derivatives' , 'QSAR and classification of 
            # murine and human soluble epoxide hydrolase inhibition by urea-like compounds.' , 'Inhibition of the U1A-RN
            # A complex by an aminoacridine derivative.' , 'Inhibitors of phenylethanolamine N-methyltransferase and epi
            # nephrine biosynthesis. 2. 1,2,3,4-Tetrahydroisoquinoline-7-sulfonanilides.' , 'Apogossypolone derivatives 
            # as anticancer agents' , 'New steroid glycosides from the starfish Asterias rathbuni.'
            'volume': 'NUMERIC',
            # EXAMPLES:
            # '74' , '61' , '74' , '42' , '6' , '46' , '12' , '23' , '64' , '19'
            'year': 'NUMERIC',
            # EXAMPLES:
            # '2011' , '1998' , '2011' , '2013' , '1996' , '2003' , '2002' , '1980' , '2015' , '2001'
        }
    }

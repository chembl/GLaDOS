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
                    # '{'weight': 100, 'input': 'Thymidylate synthase'}' , '{'weight': 75, 'input': 'IL5RB'}' , '{'weigh
                    # t': 75, 'input': 'Puromycin-sensitive aminopeptidase'}' , '{'weight': 10, 'input': 'CHEMBL3712927'
                    # }' , '{'weight': 75, 'input': 'GPDH-M'}' , '{'weight': 75, 'input': 'T12'}' , '{'weight': 75, 'inp
                    # ut': 'Interferon alpha-D'}' , '{'weight': 10, 'input': 'CHEMBL3710485'}' , '{'weight': 20, 'input'
                    # : 'Onchocerca volvulus'}' , '{'weight': 100, 'input': 'CD276 antigen'}'
                    'organism_taxonomy': 
                    {
                        'properties': 
                        {
                            'l1': 'TEXT',
                            # EXAMPLES:
                            # 'Fungi' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Euka
                            # ryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes'
                            'l2': 'TEXT',
                            # EXAMPLES:
                            # 'Ascomycota' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia'
                            #  , 'Mammalia' , 'Nematoda' , 'Mammalia'
                            'l3': 'TEXT',
                            # EXAMPLES:
                            # 'Saccharomycetales' , 'Primates' , 'Primates' , 'Primates' , 'Primates' , 'Primates' , 'Pr
                            # imates' , 'Primates' , 'Other' , 'Primates'
                            'oc_id': 'NUMERIC',
                            # EXAMPLES:
                            # '877' , '7' , '7' , '7' , '7' , '7' , '7' , '7' , '159' , '7'
                            'tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '5476' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '6282' , '9606'
                        }
                    },
                    'protein_classification': 
                    {
                        'properties': 
                        {
                            'l1': 'TEXT',
                            # EXAMPLES:
                            # 'Enzyme' , 'Membrane receptor' , 'Enzyme' , 'Unclassified protein' , 'Enzyme' , 'Adhesion'
                            #  , 'Secreted protein' , 'Unclassified protein' , 'Ion channel' , 'Surface antigen'
                            'l2': 'TEXT',
                            # EXAMPLES:
                            # 'Transferase' , 'Protease' , 'Oxidoreductase' , 'Ligand-gated ion channel' , 'Isomerase' ,
                            #  'Transferase' , 'Kinase' , 'Isomerase' , 'Frizzled family G protein-coupled receptor' , '
                            # Kinase'
                            'l3': 'TEXT',
                            # EXAMPLES:
                            # 'Metallo protease' , 'Protein Kinase' , 'Protein Kinase' , 'Bromodomain' , 'Serine proteas
                            # e' , 'SLC superfamily of solute carriers' , 'Cytochrome P450 family 51' , 'Peptide recepto
                            # r (family B GPCR)' , 'Methyl-lysine/arginine binding protein' , 'Serine protease'
                            'l4': 'TEXT',
                            # EXAMPLES:
                            # 'Metallo protease MAE clan' , 'TK protein kinase group' , 'TK protein kinase group' , 'Ser
                            # ine protease unclassified' , 'SLC12 family of cation-coupled chloride transporters' , 'Cyt
                            # ochrome P450 family 51A' , 'Calcitonin-like receptor' , 'Chromodomain' , 'Serine protease 
                            # SC clan' , 'Phosphodiesterase 4B'
                            'l5': 'TEXT',
                            # EXAMPLES:
                            # 'Metallo protease M1 family' , 'Tyrosine protein kinase Src family' , 'Tyrosine protein ki
                            # nase Tec family' , 'Serine protease S13 family' , 'Cytochrome P450 51A1' , 'Calcitonin gen
                            # e-related peptide receptor' , 'Serine protease S28 family' , 'Metallo protease M12A subfam
                            # ily' , 'CAMK protein kinase PHk family' , 'Serine protease S29 family'
                            'l6': 'TEXT',
                            # EXAMPLES:
                            # 'Tyrosine protein kinase Srm' , 'AGC protein kinase RSK subfamily' , 'CMGC protein kinase 
                            # CDK5 subfamily' , 'STE protein kinase MST subfamily' , 'CMGC protein kinase CDK2' , 'Other
                            #  protein kinase Meta subfamily' , 'CMGC protein kinase Dyrk1 subfamily' , 'STE protein kin
                            # ase NinaC subfamily' , 'TKL protein kinase TESK subfamily' , 'CAMK protein kinase AMPK sub
                            # family'
                            'protein_class_id': 'NUMERIC',
                            # EXAMPLES:
                            # '643' , '11' , '31' , '601' , '10' , '2' , '3' , '601' , '1024' , '9'
                        }
                    },
                    'related_activities': 
                    {
                        'properties': 
                        {
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '31' , '51' , '68' , '1' , '1' , '24' , '85' , '47' , '91' , '3'
                        }
                    },
                    'related_assays': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL909434 CHEMBL990822 CHEMBL909435' , 'CHEMBL1217926 CHEMBL985133 CHEMBL1217956 CHEMB
                            # L985131 CHEMBL1217941 CHEMBL985134 CHEMBL1217911 CHEMBL985132' , 'CHEMBL3238559 CHEMBL1697
                            # 325 CHEMBL1063960 CHEMBL961203 CHEMBL1697322' , 'CHEMBL4138830' , 'CHEMBL2040020' , 'CHEMB
                            # L689958 CHEMBL4266421 CHEMBL695045 CHEMBL689957 CHEMBL695049 CHEMBL695047 CHEMBL689956 CHE
                            # MBL692891 CHEMBL695048 CHEMBL695046 CHEMBL1694791 CHEMBL695050' , 'CHEMBL3395427 CHEMBL378
                            # 8469 CHEMBL3862275 CHEMBL1177142 CHEMBL1177141 CHEMBL650370 CHEMBL1912893 CHEMBL3862297 CH
                            # EMBL871899' , 'CHEMBL1033433 CHEMBL1029136 CHEMBL1017632 CHEMBL4180042 CHEMBL1001692 CHEMB
                            # L1033432' , 'CHEMBL974694 CHEMBL978491 CHEMBL979319 CHEMBL981337 CHEMBL978390 CHEMBL978499
                            #  CHEMBL1027847 CHEMBL986679 CHEMBL976945 CHEMBL3107357 CHEMBL978495 CHEMBL981323 CHEMBL307
                            # 8932 CHEMBL1043916 CHEMBL3078938 CHEMBL2342356 CHEMBL1005234 CHEMBL3078944 CHEMBL985781 CH
                            # EMBL984996 CHEMBL1054655 CHEMBL982229 CHEMBL984914 CHEMBL986282 CHEMBL1100829 CHEMBL974979
                            #  CHEMBL995259 CHEMBL982222 CHEMBL938871 CHEMBL982235 CHEMBL981330 CHEMBL984918' , 'CHEMBL3
                            # 705529'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '3' , '8' , '5' , '1' , '1' , '12' , '9' , '6' , '32' , '1'
                        }
                    },
                    'related_cell_lines': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3308501 CHEMBL3307960 CHEMBL4106362 CHEMBL3307651 CHEMBL3308372 CHEMBL3307570 CHEMB
                            # L3308403 CHEMBL3307526' , 'CHEMBL3308206' , 'CHEMBL3308072' , 'CHEMBL3308753' , 'CHEMBL330
                            # 8003' , 'CHEMBL3308003 CHEMBL3308358' , 'CHEMBL3308360' , 'CHEMBL3307757 CHEMBL3308378' , 
                            # 'CHEMBL3307715' , 'CHEMBL3308665'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '8' , '1' , '1' , '1' , '1' , '2' , '1' , '2' , '1' , '1'
                        }
                    },
                    'related_compounds': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL438632 CHEMBL517821 CHEMBL213764 CHEMBL387087 CHEMBL478821 CHEMBL514705 CHEMBL21413
                            # 3 CHEMBL504813 CHEMBL216493 CHEMBL479251 CHEMBL514692 CHEMBL148674 CHEMBL385732 CHEMBL4788
                            # 20 CHEMBL446349 CHEMBL332993 CHEMBL515637 CHEMBL506485 CHEMBL214182 CHEMBL384032 CHEMBL214
                            # 030 CHEMBL148649' , 'CHEMBL29 CHEMBL520642 CHEMBL44354 CHEMBL148 CHEMBL316157 CHEMBL186 CH
                            # EMBL127 CHEMBL491571' , 'CHEMBL549486 CHEMBL562454 CHEMBL496429 CHEMBL563970 CHEMBL521905 
                            # CHEMBL539729 CHEMBL522714 CHEMBL570302 CHEMBL3235099 CHEMBL495156 CHEMBL496822 CHEMBL52273
                            # 7 CHEMBL550850 CHEMBL497201 CHEMBL550355 CHEMBL562610 CHEMBL497626 CHEMBL449923 CHEMBL5570
                            # 93 CHEMBL564677 CHEMBL496809 CHEMBL521890 CHEMBL1651956 CHEMBL448768 CHEMBL549626 CHEMBL56
                            # 1858 CHEMBL522239 CHEMBL496796 CHEMBL497024 CHEMBL551309 CHEMBL451472 CHEMBL496428 CHEMBL5
                            # 55599 CHEMBL449802 CHEMBL551387 CHEMBL160 CHEMBL553003 CHEMBL444959 CHEMBL496627 CHEMBL526
                            # 271 CHEMBL496017 CHEMBL11252 CHEMBL455547 CHEMBL550359 CHEMBL551051 CHEMBL560252 CHEMBL553
                            # 413 CHEMBL559005 CHEMBL551308 CHEMBL560973 CHEMBL569841 CHEMBL561455 CHEMBL495819 CHEMBL55
                            # 1588 CHEMBL551388 CHEMBL523091 CHEMBL507065 CHEMBL558111 CHEMBL508368 CHEMBL562055 CHEMBL5
                            # 49833 CHEMBL562313 CHEMBL560372 CHEMBL497625 CHEMBL496797' , 'CHEMBL4172977' , 'CHEMBL2035
                            # 983' , 'CHEMBL1741 CHEMBL510533 CHEMBL3248973 CHEMBL174 CHEMBL532 CHEMBL529 CHEMBL329011 C
                            # HEMBL338614' , 'CHEMBL421340 CHEMBL2207397 CHEMBL1173592 CHEMBL205982 CHEMBL3909220 CHEMBL
                            # 3971616 CHEMBL3216051 CHEMBL3958252 CHEMBL3940374 CHEMBL3393929 CHEMBL3980439 CHEMBL378579
                            # 9 CHEMBL3786789 CHEMBL3393931 CHEMBL1170022 CHEMBL82895 CHEMBL3910926 CHEMBL1173832 CHEMBL
                            # 3910334 CHEMBL3216704 CHEMBL1173591 CHEMBL1173658 CHEMBL3393927 CHEMBL3937138 CHEMBL310596
                            #  CHEMBL84940 CHEMBL3926655 CHEMBL3970376 CHEMBL3960509 CHEMBL3785103 CHEMBL206468 CHEMBL11
                            # 73113 CHEMBL1173233 CHEMBL3786410 CHEMBL3942035 CHEMBL2206826 CHEMBL1173830 CHEMBL3931823 
                            # CHEMBL3919261 CHEMBL3786889 CHEMBL1173308 CHEMBL80254 CHEMBL445624 CHEMBL1173483 CHEMBL505
                            # 422 CHEMBL1911831 CHEMBL3786399 CHEMBL84941 CHEMBL83278 CHEMBL461161 CHEMBL1213470 CHEMBL1
                            # 172197 CHEMBL3933048 CHEMBL2115197 CHEMBL408500 CHEMBL3944991 CHEMBL406973 CHEMBL84272 CHE
                            # MBL2206827 CHEMBL1173112 CHEMBL3393928 CHEMBL3215812 CHEMBL3393932 CHEMBL84104 CHEMBL11723
                            # 86 CHEMBL456583 CHEMBL309850 CHEMBL1172967 CHEMBL3953477 CHEMBL1172966 CHEMBL313295 CHEMBL
                            # 3979715 CHEMBL79727 CHEMBL2207396 CHEMBL3787337 CHEMBL3787285 CHEMBL3899927 CHEMBL3393930 
                            # CHEMBL3786269 CHEMBL1172578 CHEMBL3786086 CHEMBL3974420 CHEMBL3787212 CHEMBL3950752 CHEMBL
                            # 3215810' , 'CHEMBL524540 CHEMBL479291 CHEMBL481446 CHEMBL481250 CHEMBL526703 CHEMBL479292 
                            # CHEMBL452148 CHEMBL509612 CHEMBL447066 CHEMBL486390 CHEMBL481447 CHEMBL509031 CHEMBL526155
                            #  CHEMBL524332 CHEMBL400092 CHEMBL98745' , 'CHEMBL446859 CHEMBL503094 CHEMBL2335706 CHEMBL5
                            # 22562 CHEMBL495861 CHEMBL517513 CHEMBL461488 CHEMBL458698 CHEMBL484652 CHEMBL525179 CHEMBL
                            # 480668 CHEMBL463611 CHEMBL500587 CHEMBL246083 CHEMBL459195 CHEMBL501733 CHEMBL2335711 CHEM
                            # BL500561 CHEMBL491984 CHEMBL513609 CHEMBL123292 CHEMBL524637 CHEMBL199341 CHEMBL497523 CHE
                            # MBL463612 CHEMBL513806 CHEMBL455585 CHEMBL563475 CHEMBL449489 CHEMBL524291 CHEMBL2287550 C
                            # HEMBL499303 CHEMBL1982182 CHEMBL443078 CHEMBL451012 CHEMBL461906 CHEMBL2335710 CHEMBL10871
                            # 62 CHEMBL2287549 CHEMBL2335709 CHEMBL458128 CHEMBL576579 CHEMBL484653 CHEMBL519268 CHEMBL5
                            # 19682 CHEMBL461275 CHEMBL3103610 CHEMBL495669 CHEMBL2335708 CHEMBL458852 CHEMBL1077087 CHE
                            # MBL497524 CHEMBL444765 CHEMBL459194 CHEMBL490313 CHEMBL479906 CHEMBL2335707 CHEMBL572121 C
                            # HEMBL468037 CHEMBL463613 CHEMBL1559 CHEMBL453810 CHEMBL479907 CHEMBL1087672 CHEMBL458697 C
                            # HEMBL1087671 CHEMBL525170 CHEMBL91 CHEMBL462111 CHEMBL516554 CHEMBL453809 CHEMBL498450 CHE
                            # MBL455749 CHEMBL461274 CHEMBL2335705 CHEMBL462112 CHEMBL552932 CHEMBL505726 CHEMBL464203 C
                            # HEMBL496253 CHEMBL517659 CHEMBL461905 CHEMBL524460 CHEMBL586557 CHEMBL1088469 CHEMBL462893
                            #  CHEMBL449617 CHEMBL453087' , 'CHEMBL3681913 CHEMBL3681914 CHEMBL3681915'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '22' , '8' , '65' , '1' , '1' , '8' , '85' , '16' , '88' , '3'
                        }
                    },
                    'related_documents': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL1137329 CHEMBL1155819' , 'CHEMBL1143427 CHEMBL1212772' , 'CHEMBL1687706 CHEMBL32328
                            # 68 CHEMBL1152400 CHEMBL1136961' , 'CHEMBL4138076' , 'CHEMBL2034981' , 'CHEMBL1687717 CHEMB
                            # L1131139 CHEMBL4265876' , 'CHEMBL3784998 CHEMBL1133958 CHEMBL3393046 CHEMBL1177655 CHEMBL3
                            # 861951 CHEMBL1909572' , 'CHEMBL1151658 CHEMBL4177607 CHEMBL1151201' , 'CHEMBL1144062 CHEMB
                            # L1151984 CHEMBL1150617 CHEMBL3046792 CHEMBL1150574 CHEMBL1157994 CHEMBL1151807 CHEMBL11541
                            # 37 CHEMBL1146522 CHEMBL1148154 CHEMBL1140142 CHEMBL1142640 CHEMBL1156655 CHEMBL1144103 CHE
                            # MBL1154880 CHEMBL3102742 CHEMBL1158720 CHEMBL1146554 CHEMBL1158853 CHEMBL2331098 CHEMBL114
                            # 2597' , 'CHEMBL3639193'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '2' , '2' , '4' , '1' , '1' , '3' , '6' , '3' , '21' , '1'
                        }
                    },
                    'related_tissues': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3638254' , 'CHEMBL3638230' , 'CHEMBL3638235 CHEMBL3638197 CHEMBL3638188' , 'CHEMBL3
                            # 638230' , 'CHEMBL3559723' , 'CHEMBL3559723' , 'CHEMBL3638188' , 'CHEMBL3638251' , 'CHEMBL3
                            # 559721' , 'CHEMBL3559723'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '3' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                        }
                    },
                    'target_component': 
                    {
                        'properties': 
                        {
                            'accession': 'TEXT',
                            # EXAMPLES:
                            # 'P12461' , 'P15509' , 'P15144' , 'Q99795' , 'P43304' , 'P30203' , 'P01562' , 'Q9Y5C1' , 'Q
                            # 25634' , 'Q5ZPR3'
                            'component_id': 'NUMERIC',
                            # EXAMPLES:
                            # '7864' , '353' , '220' , '15081' , '8364' , '15007' , '15161' , '12638' , '7383' , '15033'
                            'component_type': 'TEXT',
                            # EXAMPLES:
                            # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTE
                            # IN' , 'PROTEIN' , 'PROTEIN'
                            'description': 'TEXT',
                            # EXAMPLES:
                            # 'Thymidylate synthase' , 'Granulocyte-macrophage colony-stimulating factor receptor subuni
                            # t alpha' , 'Aminopeptidase N' , 'Cell surface A33 antigen' , 'Glycerol-3-phosphate dehydro
                            # genase, mitochondrial' , 'T-cell differentiation antigen CD6' , 'Interferon alpha-1/13' , 
                            # 'Angiopoietin-related protein 3' , 'Glutamate-gated chloride channel' , 'CD276 antigen'
                            'go_slims': 
                            {
                                'properties': 
                                {
                                    'go_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                }
                            },
                            'organism': 'TEXT',
                            # EXAMPLES:
                            # 'Candida albicans SC5314' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapie
                            # ns' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Onchocerca volvulus' , 'Homo sap
                            # iens'
                            'protein_classifications': 
                            {
                                'properties': 
                                {
                                    'protein_classification_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                }
                            },
                            'sequence': 'TEXT',
                            # EXAMPLES:
                            # 'MTVSPNTAEQAYLDLCKRIIDEGEHRPDRTGTGTKSLFAPPQLRFDLSNDTFPLLTTKKVFSKGIIHELLWFVAGSTDAKILSEKGVKI
                            # WEGNGSREFLDKLGLTHRREGDLGPVYGFQWRHFGAEYKDCDSDYTGQGFDQLQDVIKKLKTNPYDRRIIMSAWNPPDFAKMALPPCHVF
                            # CQFYVNFPTSSPDPNNPKQAKTAKPKLSCLLYQRSCDMGLGVPFNIASYALLTKMIAHVVDMDCGEFIHTLGDAHVYLDHIDALKEQFER
                            # IPKQFPKLVIKEERKNEIKSIDDFKFEDFEIVGYEPYPPIKMKMSV' , 'MLLLVTSLLLCELPHPAFLLIPEKSDLRTVAPASSLNVR
                            # FDSRTMNLSWDCQENTTFSKCFLTDKKNRVVEPRLSNNECSCTFREICLHEGVTFEVHVNTSQRGFQQKLLYPNSGREGTAAQNFSCFIY
                            # NADLMNCTWARGPTAPRDVQYFLYIRNSKRRREIRCPYYIQDSGTHVGCHLDNLSGLTSRNYFLVNGTSREIGIQFFDSLLDTKKIERFN
                            # PPSNVTVRCNTTHCLVRWKQPRTYQKLSYLDFQYQLDVHRKNTQPGTENLLINVSGDLENRYNFPSSEPRAKHSVKIRAADVRILNWSSW
                            # SEAIEFGSDDGNLGSVYIYVLLIVGTLVCGIVLGFLFKRFLRIQRLFPPVPQIKDKLNDNHEVEDEIIWEEFTPEEGKGYREEVLTVKEI
                            # T' , 'MAKGFYISKSLGILGILLGVAAVCTIIALSVVYSQEKNKNANSSPVASTTPSASATTNPASATTLDQSKAWNRYRLPNTLKPDS
                            # YRVTLRPYLTPNDRGLYVFKGSSTVRFTCKEATDVIIIHSKKLNYTLSQGHRVVLRGVGGSQPPDIDKTELVEPTEYLVVHLKGSLVKDS
                            # QYEMDSEFEGELADDLAGFYRSEYMEGNVRKVVATTQMQAADARKSFPCFDEPAMKAEFNITLIHPKDLTALSNMLPKGPSTPLPEDPNW
                            # NVTEFHTTPKMSTYLLAFIVSEFDYVEKQASNGVLIRIWARPSAIAAGHGDYALNVTGPILNFFAGHYDTPYPLPKSDQIGLPDFNAGAM
                            # ENWGLVTYRENSLLFDPLSSSSSNKERVVTVIAHELAHQWFGNLVTIEWWNDLWLNEGFASYVEYLGADYAEPTWNLKDLMVLNDVYRVM
                            # AVDALASSHPLSTPASEINTPAQISELFDAISYSKGASVLRMLSSFLSEDVFKQGLASYLHTFAYQNTIYLNLWDHLQEAVNNRSIQLPT
                            # TVRDIMNRWTLQMGFPVITVDTSTGTLSQEHFLLDPDSNVTRPSEFNYVWIVPITSIRDGRQQQDYWLIDVRAQNDLFSTSGNEWVLLNL
                            # NVTGYYRVNYDEENWRKIQTQLQRDHSAIPVINRAQIINDAFNLASAHKVPVTLALNNTLFLIEERQYMPWEAALSSLSYFKLMFDRSEV
                            # YGPMKNYLKKQVTPLFIHFRNNTNNWREIPENLMDQYSEVNAISTACSNGVPECEEMVSGLFKQWMENPNNNPIHPNLRSTVYCNAIAQG
                            # GEEEWDFAWEQFRNATLVNEADKLRAALACSKELWILNRYLSYTLNPDLIRKQDATSTIISITNNVIGQGLVWDFVQSNWKKLFNDYGGG
                            # SFSFSNLIQAVTRRFSTEYELQQLEQFKKDNEETGFGSGTRALEQALEKTKANIKWVKENKEVVLQWFTENSK' , 'MVGKMWPVLWTL
                            # CAVRVTVDAISVETPQDVLRASQGKSVTLPCTYHTSTSSREGLIQWDKLLLTHTERVVIWPFSNKNYIHGELYKNRVSISNNAEQSDASI
                            # TIDQLTMADNGTYECSVSLMSDLEGNTKSRVRLLVLVPPSKPECGIEGETIIGNNIQLTCQSKEGSPTPQYSWKRYNILNQEQPLAQPAS
                            # GQPVSLKNISTDTSGYYICTSSNEEGTQFCNITVAVRSPSMNVALYVGIAVGVVAALIIIGIIIYCCCCRGKDDNTEDKEDARPNREAYE
                            # EPPEQLRELSREREEEDDYRQEEQRSTGRESPDHLDQ' , 'MAFQKAVKGTILVGGGALATVLGLSQFAHYRRKQMNLAYVKAADCISE
                            # PVNREPPSREAQLLTLQNTSEFDILVIGGGATGSGCALDAVTRGLKTALVERDDFSSGTSSRSTKLIHGGVRYLQKAIMKLDIEQYRMVK
                            # EALHERANLLEIAPHLSAPLPIMLPVYKWWQLPYYWVGIKLYDLVAGSNCLKSSYVLSKSRALEHFPMLQKDKLVGAIVYYDGQHNDARM
                            # NLAIALTAARYGAATANYMEVVSLLKKTDPQTGKVRVSGARCKDVLTGQEFDVRAKCVINATGPFTDSVRKMDDKDAAAICQPSAGVHIV
                            # MPGYYSPESMGLLDPATSDGRVIFFLPWQKMTIAGTTDTPTDVTHHPIPSEEDINFILNEVRNYLSCDVEVRRGDVLAAWSGIRPLVTDP
                            # KSADTQSISRNHVVDISESGLITIAGGKWTTYRSMAEDTINAAVKTHNLKAGPSRTVGLFLQGGKDWSPTLYIRLVQDYGLESEVAQHLA
                            # ATYGDKAFEVAKMASVTGKRWPIVGVRLVSEFPYIEAEVKYGIKEYACTAVDMISRRTRLAFLNVQAAEEALPRIVELMGRELNWDDYKK
                            # QEQLETARKFLYYEMGYKSRSEQLTDRSEISLLPSDIDRYKKRFHKFDADQKGFITIVDVQRVLESINVQMDENTLHEILNEVDLNKNGQ
                            # VELNEFLQLMSAIQKGRVSGSRLAILMKTAEENLDRRVPIPVDRSCGGL' , 'MWLFFGITGLLTAALSGHPSPAPPDQLNTSSAESEL
                            # WEPGERLPVRLTNGSSSCSGTVEVRLEASWEPACGALWDSRAAEAVCRALGCGGAEAASQLAPPTPELPPPPAAGNTSVAANATLAGAPA
                            # LLCSGAEWRLCEVVEHACRSDGRRARVTCAENRALRLVDGGGACAGRVEMLEHGEWGSVCDDTWDLEDAHVVCRQLGCGWAVQALPGLHF
                            # TPGRGPIHRDQVNCSGAEAYLWDCPGLPGQHYCGHKEDAGAVCSEHQSWRLTGGADRCEGQVEVHFRGVWNTVCDSEWYPSEAKVLCQSL
                            # GCGTAVERPKGLPHSLSGRMYYSCNGEELTLSNCSWRFNNSNLCSQSLAARVLCSASRSLHNLSTPEVPASVQTVTIESSVTVKIENKES
                            # RELMLLIPSIVLGILLLGSLIFIAFILLRIKGKYALPVMVNHQHLPTTIPAGSNSYQPVPITIPKEVFMLPIQVQAPPPEDSDSGSDSDY
                            # EHYDFSAQPPVALTTFYNSQRHRVTDEEVQQSRFQMPPLEEGLEELHASHIPTANPGHCITDPPSLGPQYHPRSNSESSTSSGEDYCNSP
                            # KSKLPPWNPQVFSSERSSFLEQPPNLELAGTQPAFSAGPPADDSSSTSSGEWYQNFQPPPQPPSEEQFGCPGSPSPQPDSTDNDDYDDIS
                            # AA' , 'MASPFALLMVLVVLSCKSSCSLGCDLPETHSLDNRRTLMLLAQMSRISPSSCLMDRHDFGFPQEEFDGNQFQKAPAISVLHEL
                            # IQQIFNLFTTKDSSAAWDEDLLDKFCTELYQQLNDLEACVMQEERVGETPLMNADSILAVKKYFRRITLYLTEKKYSPCAWEVVRAEIMR
                            # SLSLSTNLQERLRRKE' , 'MFTIKLLLFIVPLVISSRIDQDNSSFDSLSPEPKSRFAMLDDVKILANGLLQLGHGLKDFVHKTKGQIN
                            # DIFQKLNIFDQSFYDLSLQTSEIKEEEKELRRTTYKLQVKNEEVKNMSLELNSKLESLLEEKILLQQKVKYLEEQLTNLIQNQPETPEHP
                            # EVTSLKTFVEKQDNSIKDLLQTVEDQYKQLNQQHSQIKEIENQLRRTSIQEPTEISLSSKPRAPRTTPFLQLNEIRNVKHDGIPAECTTI
                            # YNRGEHTSGMYAIRPSNSQVFHVYCDVISGSPWTLIQHRIDGSQNFNETWENYKYGFGRLDGEFWLGLEKIYSIVKQSNYVLRIELEDWK
                            # DNKHYIEYSFYLGNHETNYTLHLVAITGNVPNAIPENKDLVFSTWDHKAKGHFNCPEGYSGGWWWHDECGENNLNGKYNKPRAKSKPERR
                            # RGLSWKSQNGRLYSIKSTKMLIHPTDSESFE' , 'MNSFPIVCWNLAFLILVVAKKKLKEQEIIQRTLKDYDWRVRPRGNNLSWPDTGG
                            # PVLVSVNIYLRSISKIDDVNMEYSAQFTFREEWNDARLGYERLADENTQVPPFVVLAASEQPDLTQQIWMPDTFFQNEKEARRHLIDKPN
                            # VLIRIHPDGQILYSVRLSLVLSCPMSLEYYPLDRQTCLIDLASYAYTTDDIKYEWKVKNPIQQKEGLRQSLPSFELQDVLTEYCTSKTNT
                            # GEYSCARVLLLLRREYRFSYYLIQLYIPCIMLVVVSWVSFWLDKDAVPARVSLGVTTLLTMTTQASGINAKLPPVSYIKAVDVWIGVCLA
                            # FIFGALLEYALVNYHGRQEFLKKEKKK' , 'MLRRRGSPGMGVHVGAALGALWFCLTGALEVQVPEDPVVALVGTDATLCCSFSPEPGF
                            # SLAQLNLIWQLTDTKQLVHSFAEGQDQGSAYANRTALFPDLLAQGNASLRLQRVRVADEGSFTCFVSIRDFGSAAVSLQVAAPYSKPSMT
                            # LEPNKDLRPGDTVTITCSSYQGYPEAEVFWQDGQGVPLTGNVTTSQMANEQGLFDVHSILRVVLGANGTYSCLVRNPVLQQDAHSSVTIT
                            # PQRSPTGAVEVQVPEDPVVALVGTDATLRCSFSPEPGFSLAQLNLIWQLTDTKQLVHSFTEGRDQGSAYANRTALFPDLLAQGNASLRLQ
                            # RVRVADEGSFTCFVSIRDFGSAAVSLQVAAPYSKPSMTLEPNKDLRPGDTVTITCSSYRGYPEAEVFWQDGQGVPLTGNVTTSQMANEQG
                            # LFDVHSVLRVVLGANGTYSCLVRNPVLQQDAHGSVTITGQPMTFPPEALWVTVGLSVCLIALLVALAFVCWRKIKQSCEEENAGAEDQDG
                            # EGEGSKTALQPLKHSDSKEDDGQEIA'
                            'target_component_synonyms': 
                            {
                                'properties': 
                                {
                                    'component_synonym': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                    'syn_type': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                }
                            },
                            'target_component_xrefs': 
                            {
                                'properties': 
                                {
                                    'xref_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                    'xref_name': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                    'xref_src_db': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                    'xref_src_url': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                    'xref_url': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                }
                            },
                            'targets': 
                            {
                                'properties': 
                                {
                                    'target_chembl_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                }
                            },
                            'tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '237561' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '6282' , '9606'
                        }
                    }
                }
            },
            'cross_references': 
            {
                'properties': 
                {
                    'xref_id': 'TEXT',
                    # EXAMPLES:
                    # 'Sodium-chloride_symporter' , 'Q6PRG8' , 'P00722' , 'CBX1' , 'Q8VBU5' , 'EIF4H' , 'Q80ZG2' , 'Q8RN
                    # 04' , 'Q9H227' , 'Q15904'
                    'xref_name': 'TEXT',
                    # EXAMPLES:
                    # 'Progesterone receptor (PR)' , 'CD22' , 'Albumin' , 'Phosphodiesterase type 10A' , 'Galectin-3' , 
                    # 'Cathepsin K' , 'D3 dopamine receptors' , 'Type 2 vesicular monoamine transporter (VMAT2)' , 'Gast
                    # rin-releasing peptide receptor (GRP-R)' , 'Kappa opioid receptor'
                    'xref_src': 'TEXT',
                    # EXAMPLES:
                    # 'Wikipedia' , 'canSAR-Target' , 'canSAR-Target' , 'Wikipedia' , 'canSAR-Target' , 'Wikipedia' , 'c
                    # anSAR-Target' , 'canSAR-Target' , 'canSAR-Target' , 'canSAR-Target'
                    'xref_src_url': 'TEXT',
                    # EXAMPLES:
                    # 'http://www.wikipedia.org' , 'https://cansar.icr.ac.uk/cansar' , 'https://cansar.icr.ac.uk/cansar'
                    #  , 'http://www.wikipedia.org' , 'https://cansar.icr.ac.uk/cansar' , 'http://www.wikipedia.org' , '
                    # https://cansar.icr.ac.uk/cansar' , 'https://cansar.icr.ac.uk/cansar' , 'https://cansar.icr.ac.uk/c
                    # ansar' , 'https://cansar.icr.ac.uk/cansar'
                    'xref_url': 'TEXT',
                    # EXAMPLES:
                    # 'http://en.wikipedia.org/wiki/Sodium-chloride_symporter' , 'https://cansar.icr.ac.uk/cansar/protei
                    # n-targets/Q6PRG8/' , 'https://cansar.icr.ac.uk/cansar/protein-targets/P00722/' , 'http://en.wikipe
                    # dia.org/wiki/CBX1' , 'https://cansar.icr.ac.uk/cansar/protein-targets/Q8VBU5/' , 'http://en.wikipe
                    # dia.org/wiki/EIF4H' , 'https://cansar.icr.ac.uk/cansar/protein-targets/Q80ZG2/' , 'https://cansar.
                    # icr.ac.uk/cansar/protein-targets/Q8RN04/' , 'https://cansar.icr.ac.uk/cansar/protein-targets/Q9H22
                    # 7/' , 'https://cansar.icr.ac.uk/cansar/protein-targets/Q15904/'
                }
            },
            'organism': 'TEXT',
            # EXAMPLES:
            # 'Candida albicans' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 
            # 'Homo sapiens' , 'Homo sapiens' , 'Onchocerca volvulus' , 'Homo sapiens'
            'pref_name': 'TEXT',
            # EXAMPLES:
            # 'Thymidylate synthase' , 'Granulocyte-macrophage colony-stimulating factor receptor' , 'Aminopeptidase' , 
            # 'Cell surface A33 antigen' , 'Mitochondrial glycerol-3-phosphate dehydrogenase' , 'T-cell differentiation 
            # antigen CD6' , 'Interferon alpha-1/13' , 'Angiopoietin-related protein 3' , 'Glutamate-gated chloride chan
            # nel' , 'CD276 antigen'
            'species_group_flag': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL2364680' , 'CHEMBL2364169' , 'CHEMBL3831223' , 'CHEMBL3712927' , 'CHEMBL3391681' , 'CHEMBL3712853' 
            # , 'CHEMBL3713007' , 'CHEMBL3710485' , 'CHEMBL2363051' , 'CHEMBL3712879'
            'target_components': 
            {
                'properties': 
                {
                    'accession': 'TEXT',
                    # EXAMPLES:
                    # 'P12461' , 'P15509' , 'P15144' , 'Q99795' , 'P43304' , 'P30203' , 'P01562' , 'Q9Y5C1' , 'Q25634' ,
                    #  'Q5ZPR3'
                    'component_description': 'TEXT',
                    # EXAMPLES:
                    # 'Thymidylate synthase' , 'Granulocyte-macrophage colony-stimulating factor receptor subunit alpha'
                    #  , 'Aminopeptidase N' , 'Cell surface A33 antigen' , 'Glycerol-3-phosphate dehydrogenase, mitochon
                    # drial' , 'T-cell differentiation antigen CD6' , 'Interferon alpha-1/13' , 'Angiopoietin-related pr
                    # otein 3' , 'Glutamate-gated chloride channel' , 'CD276 antigen'
                    'component_id': 'NUMERIC',
                    # EXAMPLES:
                    # '7864' , '353' , '220' , '15081' , '8364' , '15007' , '15161' , '12638' , '7383' , '15033'
                    'component_type': 'TEXT',
                    # EXAMPLES:
                    # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'P
                    # ROTEIN' , 'PROTEIN'
                    'relationship': 'TEXT',
                    # EXAMPLES:
                    # 'SINGLE PROTEIN' , 'PROTEIN SUBUNIT' , 'GROUP MEMBER' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SIN
                    # GLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN'
                    'target_component_synonyms': 
                    {
                        'properties': 
                        {
                            'component_synonym': 'TEXT',
                            # EXAMPLES:
                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                            'syn_type': 'TEXT',
                            # EXAMPLES:
                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                        }
                    },
                    'target_component_xrefs': 
                    {
                        'properties': 
                        {
                            'xref_id': 'TEXT',
                            # EXAMPLES:
                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                            'xref_name': 'TEXT',
                            # EXAMPLES:
                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                            'xref_src_db': 'TEXT',
                            # EXAMPLES:
                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                            'xref_src_url': 'TEXT',
                            # EXAMPLES:
                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                            'xref_url': 'TEXT',
                            # EXAMPLES:
                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None'
                        }
                    }
                }
            },
            'target_type': 'TEXT',
            # EXAMPLES:
            # 'SINGLE PROTEIN' , 'PROTEIN COMPLEX' , 'PROTEIN FAMILY' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PR
            # OTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN' , 'SINGLE PROTEIN'
            'tax_id': 'NUMERIC',
            # EXAMPLES:
            # '5476' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '6282' , '9606'
        }
    }

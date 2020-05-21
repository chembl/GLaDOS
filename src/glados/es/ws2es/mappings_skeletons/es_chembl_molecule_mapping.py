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
                    'atc_classifications': 
                    {
                        'properties': 
                        {
                            'level1': 'TEXT',
                            # EXAMPLES:
                            # 'R' , 'P' , 'G' , 'B' , 'A' , 'J' , 'V' , 'B' , 'V' , 'P'
                            'level1_description': 'TEXT',
                            # EXAMPLES:
                            # 'R - RESPIRATORY SYSTEM' , 'P - ANTIPARASITIC PRODUCTS, INSECTICIDES AND REPELLENTS' , 'G 
                            # - GENITO URINARY SYSTEM AND SEX HORMONES' , 'B - BLOOD AND BLOOD FORMING ORGANS' , 'A - AL
                            # IMENTARY TRACT AND METABOLISM' , 'J - ANTIINFECTIVES FOR SYSTEMIC USE' , 'V - VARIOUS' , '
                            # B - BLOOD AND BLOOD FORMING ORGANS' , 'V - VARIOUS' , 'P - ANTIPARASITIC PRODUCTS, INSECTI
                            # CIDES AND REPELLENTS'
                            'level2': 'TEXT',
                            # EXAMPLES:
                            # 'R05' , 'P01' , 'G01' , 'B03' , 'A16' , 'J07' , 'V08' , 'B03' , 'V09' , 'P02'
                            'level2_description': 'TEXT',
                            # EXAMPLES:
                            # 'R05 - COUGH AND COLD PREPARATIONS' , 'P01 - ANTIPROTOZOALS' , 'G01 - GYNECOLOGICAL ANTIIN
                            # FECTIVES AND ANTISEPTICS' , 'B03 - ANTIANEMIC PREPARATIONS' , 'A16 - OTHER ALIMENTARY TRAC
                            # T AND METABOLISM PRODUCTS' , 'J07 - VACCINES' , 'V08 - CONTRAST MEDIA' , 'B03 - ANTIANEMIC
                            #  PREPARATIONS' , 'V09 - DIAGNOSTIC RADIOPHARMACEUTICALS' , 'P02 - ANTHELMINTICS'
                            'level3': 'TEXT',
                            # EXAMPLES:
                            # 'R05C' , 'P01A' , 'G01A' , 'B03A' , 'A16A' , 'J07A' , 'V08C' , 'B03A' , 'V09D' , 'P02B'
                            'level3_description': 'TEXT',
                            # EXAMPLES:
                            # 'R05C - EXPECTORANTS, EXCL. COMBINATIONS WITH COUGH SUPPRESSANTS' , 'P01A - AGENTS AGAINST
                            #  AMOEBIASIS AND OTHER PROTOZOAL DISEASES' , 'G01A - ANTIINFECTIVES AND ANTISEPTICS, EXCL. 
                            # COMBINATIONS WITH CORTICOSTEROIDS' , 'B03A - IRON PREPARATIONS' , 'A16A - OTHER ALIMENTARY
                            #  TRACT AND METABOLISM PRODUCTS' , 'J07A - BACTERIAL VACCINES' , 'V08C - MAGNETIC RESONANCE
                            #  IMAGING CONTRAST MEDIA' , 'B03A - IRON PREPARATIONS' , 'V09D - HEPATIC AND RETICULO ENDOT
                            # HELIAL SYSTEM' , 'P02B - ANTITREMATODALS'
                            'level4': 'TEXT',
                            # EXAMPLES:
                            # 'R05CA' , 'P01AR' , 'G01AX' , 'B03AB' , 'A16AB' , 'J07AH' , 'V08CA' , 'B03AA' , 'V09DA' , 
                            # 'P02BX'
                            'level4_description': 'TEXT',
                            # EXAMPLES:
                            # 'R05CA - Expectorants' , 'P01AR - Arsenic compounds' , 'G01AX - Other antiinfectives and a
                            # ntiseptics' , 'B03AB - Iron trivalent, oral preparations' , 'A16AB - Enzymes' , 'J07AH - M
                            # eningococcal vaccines' , 'V08CA - Paramagnetic contrast media' , 'B03AA - Iron bivalent, o
                            # ral preparations' , 'V09DA - Technetium (99mTc) compounds' , 'P02BX - Other antitrematodal
                            #  agents'
                            'level5': 'TEXT',
                            # EXAMPLES:
                            # 'R05CA08' , 'P01AR03' , 'G01AX15' , 'B03AB03' , 'A16AB06' , 'J07AH07' , 'V08CA03' , 'B03AA
                            # 04' , 'V09DA05' , 'P02BX03'
                            'who_name': 'TEXT',
                            # EXAMPLES:
                            # 'creosote' , 'glycobiarsol' , 'copper usnate' , 'sodium feredetate' , 'sacrosidase' , 'men
                            # ingococcus C, purified polysaccharides antigen conjugated' , 'gadodiamide' , 'ferrous carb
                            # onate' , 'technetium (99mTc) galtifenin' , 'stibophen'
                        }
                    },
                    'compound_generated': 
                    {
                        'properties': 
                        {
                            'availability_type_label': 'TEXT',
                            # EXAMPLES:
                            # 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unkno
                            # wn' , 'Unknown' , 'Unknown'
                            'chirality_label': 'TEXT',
                            # EXAMPLES:
                            # 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unknown' , 'Unkno
                            # wn' , 'Unknown' , 'Unknown'
                            'image_file': 'TEXT',
                            # EXAMPLES:
                            # 'metalContaining.svg' , 'metalContaining.svg' , 'unknown.svg' , 'smallMolecule.svg' , 'sma
                            # llMolecule.svg' , 'metalContaining.svg' , 'unknown.svg' , 'unknown.svg' , 'unknown.svg' , 
                            # 'unknown.svg'
                        }
                    },
                    'compound_records': 
                    {
                        'properties': 
                        {
                            'compound_key': 'TEXT',
                            # EXAMPLES:
                            # 'Gamma-10' , '3' , 'SID499209' , '15' , '14g' , '9' , '9b' , '26' , 'Mel2' , '3a'
                            'compound_name': 'TEXT',
                            # EXAMPLES:
                            # 'N-(2-((2-((2-(1H-indol-3-yl)ethyl)(2-amino-2-oxoethyl)amino)-2-oxoethyl)(4-ammoniobutyl)a
                            # mino)-2-oxoethyl)-3,7,11-trimethyldodeca-2,6,10-trien-1-aminium' , '1-[(1-Thiophen-2-yl-cy
                            # clopentylmethyl)-amino]-3-p-tolyloxy-propan-2-ol' , 'SID499209' , '(S)-2-(6-(3-(3-chloroph
                            # enoxy)propoxy)-2,3-dihydrobenzofuran-3-yl)acetic acid' , '(E)-1-(3',4-dihydroxy-[1,1'-biph
                            # enyl]-3-yl)tetradecan-1-one oxime' , '4-Aminomethyl-cyclohexanecarboxylic acid (2,2-dimeth
                            # yl-propionylamino)-methyl ester hydrochloride' , '1-(3-((4-amino-3-(1-(2-methoxyethyl)-1H-
                            # pyrazol-4-yl)-1H-pyrazolo[3,4-d]pyrimidin-1-yl)methyl)piperidin-1-yl)prop-2-en-1-one' , '2
                            # -((4-((2'-chloro-4'-ethoxy-[1,1'-biphenyl]-3-yl)methoxy)phenyl)sulfonyl)acetic acid' , 'N2
                            # -(3-fluorobenzyl)-N4-methyl-6-(perfluorophenoxy)-1,3,5-triazine-2,4-diamine' , '3-(3,4,5-T
                            # rimethoxyphenyl)-6-(4-methylphenyl)-1H-pyrazolo[5,1-c][1,2,4]triazole'
                            'src_description': 'TEXT',
                            # EXAMPLES:
                            # 'Scientific Literature' , 'Scientific Literature' , 'PubChem BioAssays' , 'Scientific Lite
                            # rature' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature' , 'S
                            # cientific Literature' , 'Scientific Literature' , 'Scientific Literature'
                            'src_id': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '7' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                            'src_short_name': 'TEXT',
                            # EXAMPLES:
                            # 'LITERATURE' , 'LITERATURE' , 'PUBCHEM_BIOASSAY' , 'LITERATURE' , 'LITERATURE' , 'LITERATU
                            # RE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE'
                        }
                    },
                    'drug': 
                    {
                        'properties': 
                        {
                            'drug_data': 
                            {
                                'properties': 
                                {
                                    'applicants': 'TEXT',
                                    # EXAMPLES:
                                    # 'Novo Nordisk Inc' , 'Lantheus Medical Imaging Inc' , 'Jubilant Draximage Inc' , '
                                    # Qol Medical Llc' , 'Novo Nordisk Inc' , 'Ge Healthcare' , 'Lantheus Medical Imagin
                                    # g Inc' , 'Curium Us Llc' , 'Advanced Accelerator Applications Usa Inc' , 'Glaxosmi
                                    # thkline'
                                    'atc_classification': 
                                    {
                                        'properties': 
                                        {
                                            'code': 'TEXT',
                                            # EXAMPLES:
                                            # 'R05CA08' , 'P01AR53' , 'G01AX15' , 'B03AB03' , 'A16AB06' , 'J07AH07' , 'V
                                            # 08CA03' , 'B03AA04' , 'P02BX03' , 'D01AA03'
                                            'description': 'TEXT',
                                            # EXAMPLES:
                                            # 'RESPIRATORY SYSTEM: COUGH AND COLD PREPARATIONS: EXPECTORANTS, EXCL. COMB
                                            # INATIONS WITH COUGH SUPPRESSANTS: Expectorants' , 'ANTIPARASITIC PRODUCTS,
                                            #  INSECTICIDES AND REPELLENTS: ANTIPROTOZOALS: AGENTS AGAINST AMOEBIASIS AN
                                            # D OTHER PROTOZOAL DISEASES: Arsenic compound' , 'GENITO URINARY SYSTEM AND
                                            #  SEX HORMONES: GYNECOLOGICAL ANTIINFECTIVES AND ANTISEPTICS: ANTIINFECTIVE
                                            # S AND ANTISEPTICS, EXCL. COMBINATIONS WITH CORTICOSTEROIDS: Other antiinfe
                                            # ctives and antiseptics' , 'BLOOD AND BLOOD FORMING ORGANS: ANTIANEMIC PREP
                                            # ARATIONS: IRON PREPARATIONS: Iron trivalent, oral preparations' , 'ALIMENT
                                            # ARY TRACT AND METABOLISM: OTHER ALIMENTARY TRACT AND METABOLISM PRODUCTS: 
                                            # OTHER ALIMENTARY TRACT AND METABOLISM PRODUCTS: Enzymes' , 'ANTIINFECTIVES
                                            #  FOR SYSTEMIC USE: VACCINES: BACTERIAL VACCINES: Meningococcal vaccines' ,
                                            #  'VARIOUS: CONTRAST MEDIA: MAGNETIC RESONANCE IMAGING CONTRAST MEDIA: Para
                                            # magnetic contrast media' , 'BLOOD AND BLOOD FORMING ORGANS: ANTIANEMIC PRE
                                            # PARATIONS: IRON PREPARATIONS: Iron bivalent, oral preparations' , 'ANTIPAR
                                            # ASITIC PRODUCTS, INSECTICIDES AND REPELLENTS: ANTHELMINTICS: ANTITREMATODA
                                            # LS: Other antitrematodal agents' , 'DERMATOLOGICALS: ANTIFUNGALS FOR DERMA
                                            # TOLOGICAL USE: ANTIFUNGALS FOR TOPICAL USE: Antibiotic'
                                        }
                                    },
                                    'availability_type': 'NUMERIC',
                                    # EXAMPLES:
                                    # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                                    'biotherapeutic': 
                                    {
                                        'properties': 
                                        {
                                            'biocomponents': 
                                            {
                                                'properties': 
                                                {
                                                    'component_id': 'NUMERIC',
                                                    # EXAMPLES:
                                                    # '17490' , '17463' , '6720' , '17477' , '17518' , '6720' , '6509' ,
                                                    #  '10182' , '6433' , '17532'
                                                    'component_type': 'TEXT',
                                                    # EXAMPLES:
                                                    # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTE
                                                    # IN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN'
                                                    'description': 'TEXT',
                                                    # EXAMPLES:
                                                    # 'FRUNEVETMAB Heavy chain' , 'COFETUZUMAB PELIDOTIN Heavy chain' , 
                                                    # 'Purified bovine insulin zinc suspension' , 'VADASTUXIMAB Heavy ch
                                                    # ain' , 'Purified bovine insulin zinc suspension' , 'Panobacumab he
                                                    # avy chain' , 'TAMTUVETMAB Heavy Chain' , 'Suvizumab heavy chain' ,
                                                    #  'DUVORTUXIZUMAB h-CH2-CH3 chain3 sequence' , 'OLENDALIZUMAB Heavy
                                                    #  chain'
                                                    'organism': 'TEXT',
                                                    # EXAMPLES:
                                                    # 'Bos taurus' , 'Bos taurus' , 'Homo sapiens' , 'Homo sapiens' , 'H
                                                    # omo sapiens' , 'Homo sapiens' , 'Bos taurus' , 'Homo sapiens' , 'H
                                                    # omo sapiens' , 'Homo sapiens'
                                                    'sequence': 'TEXT',
                                                    # EXAMPLES:
                                                    # 'QVQLVESGAELVQPGESLRLTCAASGFSLTNNNVNWVRQAPGKGLEWMGGVWAGGATDYNSALKS
                                                    # RLTITRDTSKNTVFLQMHSLQSEDTATYYCARDGGYSSSTLYAMDAWGQGTTVTVSAASTTAPSVF
                                                    # PLAPSCGTTSGATVALACLVLGYFPEPVTVSWNSGALTSGVHTFPAVLQASGLYSLSSMVTVPSSR
                                                    # WLSDTFTCNVAHPPSNTKVDKTVRKTDHPPGPKPCDCPKCPPPEMLGGPSIFIFPPKPKDTLSISR
                                                    # TPEVTCLVVDLGPDDSDVQITWFVDNTQVYTAKTSPREEQFNSTYRVVSVLPILHQDWLKGKEFKC
                                                    # KVNSKSLPSPIERTISKAKGQPHEPQVYVLPPAQEELSRNKVSVTCLIKSFHPPDIAVEWEITGQP
                                                    # EPENNYRTTPPQLDSDGTYFVYSKLSVDRSHWQRGNTYTCSVSHEALHSHHTQKSLTQSPGK' , 
                                                    # 'Q1VQLVQSGPEVKKPGASVKVSCKASGYTFTDYAVHWVRQAPGKRLEWIGVISTYNDYTYNNQDF
                                                    # KGRVTMTRDTSASTAYMELSRLRSEDTAVYYCARGNSYFYALDYWGQGTSVTVSSASTKGPSVFPL
                                                    # APSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLG
                                                    # TQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVT
                                                    # CVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNK
                                                    # ALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYK
                                                    # TTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPG' , 'MALWTRL
                                                    # RPLLALLALWPPPPARAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVGALELAGGPG
                                                    # AGGLEGPPQKRGIVEQCCASVCSLYQLENYCN' , 'M1SPGQGTQSENSCTHFPGNLPNMLRDLR
                                                    # DAFSRVKTFFQMKDQLDNLLLKESLLEDFKGYLGCQALSEMIQFYLEEVMPQAENQDPDIKAHVNS
                                                    # LGENLKTLRLRLRRCHRFLPCENKSKAVEQVKNAFNKLQEKGIYKAMSEFDIFINYIEAYMTMKIR
                                                    # N' , 'XVQLVQSGAEVKKPGASVKVSCKASGYTFTNYDINWVRQAPGQGLEWIGWIYPGDGSTKY
                                                    # NEKFKAKATLTADTSTSTAYMELRSLRSDDTAVYYCASGYEDAMDYWGQGTTVTVSSASTKGPSVF
                                                    # PLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSS
                                                    # LGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPCVFLFPPKPKDTLMISRTPE
                                                    # VTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVS
                                                    # NKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENN
                                                    # YKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'MALW
                                                    # TRLRPLLALLALWPPPPARAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVGALELAG
                                                    # GPGAGGLEGPPQKRGIVEQCCASVCSLYQLENYCN' , 'EEQVVESGGGFVQPGGSLRLSCAASG
                                                    # FTFSPYWMHWVRQAPGKGLVWVSRINSDGSTYYADSVKGRFTISRDNARNTLYLQMNSLRAEDTAV
                                                    # YYCARDRYYGPEMWGQGTMVTVSSGSASAPTLFPLVSCENSPSDTSSVAVGCLAQDFLPDSITFSW
                                                    # KYKNNSDISSTRGFPSVLRGGKYAATSQVLLPSKDVMQGTDEHVVCKVQHPNGNKEKNVPLPVIAE
                                                    # LPPKVSVFVPPRDGFFGNPRKSKLICQATGFSPRQIQVSWLREGKQVGSGVTTDQVQAEAKESGPT
                                                    # TYKVTSTLTIKESDWLSQSMFTCRVDHRGLTFQQNASSMCVPDQDTAIRVFAIPPSFASIFLTKST
                                                    # KLTCLVTDLTTYDSVTISWTRQNGEAVKTHTNISESHPNATFSAVGEASICEDDWNSGERFTCTVT
                                                    # HTDLPSPLKQTISRPKGVALHRPDVYLLPPAREQLNLRESATITCLVTGFSPADVFVQWMQRGQPL
                                                    # SPEKYVTSAPMPEPQAPGRYFAHSILTVSEEEWNTGETYTCVVAHEALPNRVTERTVDKSTGKPTL
                                                    # YNVSLVMSDTAGTCY' , 'EVKLLESGGGLVQPGGSMRLSCAGSGFTFTDFYMNWIRQPAGKAPE
                                                    # WLGFIRDKAKGYTTEYNPSVKGRFTISRDNTQNMLYLQMNTLRAEDTATYYCAREGHTAAPFDYWG
                                                    # QGTLVTVSSASTTAPSVFPLAPSCGSTSGSTVALACLVSGYFPEPVTVSWNSGSLTSGVHTFPSVL
                                                    # QSSGLYSLSSMVTVPSSRWPSETFTCNVAHPASKTKVDKPVPKRENGRVPRPPDCPKCPAPEMLGG
                                                    # PSVFIFPPKPKDTLLIARTPEVTCVVVDLDPEDPEVQISWFVDGKQMQTAKTQPREEQFNGTYRVV
                                                    # SVLPIGHQDWLKGKQFTCKVNNKALPSPIERTISKARGQAHQPSVYVLPPSREELSKNTVSLTCLI
                                                    # KDFFPPDIDVEWQSNGQQEPESKYRTTPPQLDEDGSYFLYSKLSVDKSRWQRGDTFICAVMHEALH
                                                    # NHYTQKSLSHSPGK' , 'QVQLVQSGAEVKKPGASVKVSCKASGYTFTNSWIGWFRQAPGQGLEW
                                                    # IGDIYPGGGYTNYNEIFKGKATMTADTSTNTAYMELSSLRSEDTAVYYCSRGIPGYAMDYWGQGTL
                                                    # VTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSG
                                                    # LYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFP
                                                    # PKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLH
                                                    # QDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSD
                                                    # IAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLS
                                                    # LSPGK' , 'DKTHTCPPCPAPEAAGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFN
                                                    # WYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQ
                                                    # PREPQVYTLPPSREEMTKNQVSLSCAVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLVS
                                                    # KLTVDKSRWQQGNVFSCSVMHEALHNRYTQKSLSLSPG'
                                                    'tax_id': 'NUMERIC',
                                                    # EXAMPLES:
                                                    # '9913' , '9913' , '9606' , '9606' , '9606' , '9606' , '9913' , '96
                                                    # 06' , '9606' , '9606'
                                                }
                                            },
                                            'description': 'TEXT',
                                            # EXAMPLES:
                                            # 'ONCOLYSIN M (Immunotoxin mab)' , 'J591 (111In) (mab)' , 'Vapaliximab (chi
                                            # meric mab)' , 'Prompt bovine insulin zinc suspension' , 'REGN-846 (mab)' ,
                                            #  'ALG-991 (chimeric mab)' , 'Nacolomab tafenatox (mouse Fab)' , 'Felvizuma
                                            # b (humanized mab)' , 'MEDI-500 (mouse mab)' , 'SAR-1349 (mab)'
                                            'helm_notation': 'TEXT',
                                            # EXAMPLES:
                                            # 'PEPTIDE1{D.I.Q.M.T.Q.R.P.D.S.L.S.A.S.V.G.D.R.V.T.M.S.C.K.S.S.Q.S.L.L.N.S.
                                            # G.D.Q.K.N.Y.L.T.W.Y.Q.Q.K.P.G.Q.P.P.K.L.L.I.Y.W.A.S.T.G.E.S.G.V.P.D.R.F.S.
                                            # G.S.G.S.G.T.D.F.T.F.T.I.S.S.L.Q.P.E.D.I.A.T.Y.Y.C.Q.N.D.Y.S.Y.P.W.T.F.G.Q.
                                            # G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.
                                            # N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.
                                            # L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.
                                            # G.E.C}|PEPTIDE2{Q.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.A.S.V.K.V.S.C.K.A.S.G.Y.T.F.
                                            # T.N.S.W.I.G.W.F.R.Q.A.P.G.Q.G.L.E.W.I.G.D.I.Y.P.G.G.G.Y.T.N.Y.N.E.I.F.K.G.
                                            # K.A.T.M.T.A.D.T.S.T.N.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V.Y.Y.C.S.R.G.I.P.G.Y.
                                            # A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.
                                            # A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.
                                            # S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.
                                            # K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.
                                            # L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.
                                            # K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.
                                            # N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.
                                            # Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.
                                            # D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.
                                            # Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{Q.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.A.S.V.K.V.
                                            # S.C.K.A.S.G.Y.T.F.T.N.S.W.I.G.W.F.R.Q.A.P.G.Q.G.L.E.W.I.G.D.I.Y.P.G.G.G.Y.
                                            # T.N.Y.N.E.I.F.K.G.K.A.T.M.T.A.D.T.S.T.N.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V.Y.
                                            # Y.C.S.R.G.I.P.G.Y.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.
                                            # S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.
                                            # H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.
                                            # K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.
                                            # L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.
                                            # V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.
                                            # G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.
                                            # P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.
                                            # N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.
                                            # V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.R.P.D.S.L.
                                            # S.A.S.V.G.D.R.V.T.M.S.C.K.S.S.Q.S.L.L.N.S.G.D.Q.K.N.Y.L.T.W.Y.Q.Q.K.P.G.Q.
                                            # P.P.K.L.L.I.Y.W.A.S.T.G.E.S.G.V.P.D.R.F.S.G.S.G.S.G.T.D.F.T.F.T.I.S.S.L.Q.
                                            # P.E.D.I.A.T.Y.Y.C.Q.N.D.Y.S.Y.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.
                                            # I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.
                                            # L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.
                                            # V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE1,PEPTIDE1,140:R3-
                                            # 200:R3|PEPTIDE3,PEPTIDE3,145:R3-201:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTI
                                            # DE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE2,262:R3-322:R3|PEPTIDE4,PEPTID
                                            # E4,140:R3-200:R3|PEPTIDE3,PEPTIDE4,221:R3-220:R3|PEPTIDE4,PEPTIDE4,23:R3-9
                                            # 4:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE3,227:R3-227:R3|PEPTIDE
                                            # 3,PEPTIDE3,262:R3-322:R3|PEPTIDE2,PEPTIDE1,221:R3-220:R3|PEPTIDE2,PEPTIDE2
                                            # ,145:R3-201:R3|PEPTIDE1,PEPTIDE1,23:R3-94:R3|PEPTIDE2,PEPTIDE2,368:R3-426:
                                            # R3|PEPTIDE3,PEPTIDE3,368:R3-426:R3$$$' , 'PEPTIDE1{Q.S.V.L.T.Q.P.P.S.A.S.G
                                            # .T.P.G.Q.R.V.T.I.S.C.S.G.S.N.T.N.I.G.K.N.Y.V.S.W.Y.Q.Q.L.P.G.T.A.P.K.L.L.I
                                            # .Y.A.N.S.N.R.P.S.G.V.P.D.R.F.S.G.S.K.S.G.T.S.A.S.L.A.I.S.G.L.R.S.E.D.E.A.D
                                            # .Y.Y.C.A.S.W.D.A.S.L.N.G.W.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P
                                            # .P.S.S.E.E.L.Q.A.N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K
                                            # .A.G.V.E.T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C
                                            # .Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.T.E.C.S}|PEPTIDE2{E.V.Q.L.L.E.S.G.G.G.L.V.Q
                                            # .P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.N.A.W.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.S.S
                                            # .I.S.V.G.G.H.R.T.Y.Y.A.D.S.V.K.G.R.S.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R
                                            # .A.E.D.T.A.V.Y.Y.C.A.R.I.R.V.G.P.S.G.G.A.F.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T
                                            # .K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S
                                            # .W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G
                                            # .T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A
                                            # .P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H
                                            # .E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V
                                            # .L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q
                                            # .P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V
                                            # .E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R
                                            # .W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E
                                            # .V.Q.L.L.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.N.A.W.M.S.W.V.R
                                            # .Q.A.P.G.K.G.L.E.W.V.S.S.I.S.V.G.G.H.R.T.Y.Y.A.D.S.V.K.G.R.S.T.I.S.R.D.N.S
                                            # .K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.I.R.V.G.P.S.G.G.A.F.D.Y.W.G
                                            # .Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L
                                            # .V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L
                                            # .S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S
                                            # .C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T
                                            # .P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E
                                            # .E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A
                                            # .P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C
                                            # .L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F
                                            # .F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L
                                            # .S.L.S.P.G.K}|PEPTIDE4{Q.S.V.L.T.Q.P.P.S.A.S.G.T.P.G.Q.R.V.T.I.S.C.S.G.S.N
                                            # .T.N.I.G.K.N.Y.V.S.W.Y.Q.Q.L.P.G.T.A.P.K.L.L.I.Y.A.N.S.N.R.P.S.G.V.P.D.R.F
                                            # .S.G.S.K.S.G.T.S.A.S.L.A.I.S.G.L.R.S.E.D.E.A.D.Y.Y.C.A.S.W.D.A.S.L.N.G.W.V
                                            # .F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E.E.L.Q.A.N.K.A.T.L.V
                                            # .C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E.T.T.T.P.S.K.Q.S.N.N
                                            # .K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A
                                            # .P.T.E.C.S}$PEPTIDE3,PEPTIDE4,224:R3-215:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R
                                            # 3|PEPTIDE4,PEPTIDE4,22:R3-89:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEP
                                            # TIDE3,233:R3-233:R3|PEPTIDE1,PEPTIDE1,22:R3-89:R3|PEPTIDE2,PEPTIDE2,22:R3-
                                            # 96:R3|PEPTIDE1,PEPTIDE1,138:R3-197:R3|PEPTIDE2,PEPTIDE2,148:R3-204:R3|PEPT
                                            # IDE4,PEPTIDE4,138:R3-197:R3|PEPTIDE3,PEPTIDE3,148:R3-204:R3|PEPTIDE2,PEPTI
                                            # DE2,265:R3-325:R3|PEPTIDE2,PEPTIDE2,371:R3-429:R3|PEPTIDE3,PEPTIDE3,371:R3
                                            # -429:R3|PEPTIDE2,PEPTIDE1,224:R3-215:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3$$$
                                            # ' , 'PEPTIDE1{S.S.E.L.T.Q.D.P.A.V.S.V.A.L.G.Q.T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.
                                            # Y.A.S.W.Y.Q.Q.K.P.G.Q.A.P.V.L.V.I.Y.G.K.N.N.R.P.S.G.I.P.D.R.F.S.G.S.S.S.G.
                                            # N.T.A.S.L.T.I.T.G.A.Q.A.E.D.E.A.D.Y.Y.C.N.S.R.D.S.S.G.N.H.V.V.F.G.G.G.T.K.
                                            # L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E.E.L.Q.A.N.K.A.T.L.V.C.L.I.S.D.F.
                                            # Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E.T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.
                                            # Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.T.E.C.S}|P
                                            # EPTIDE2{E.V.Q.L.V.Q.S.G.G.G.V.E.R.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.D.D.Y.G.
                                            # M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.S.G.I.N.W.N.G.G.S.T.G.Y.A.D.S.V.K.G.R.V.T.I.
                                            # S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.K.I.L.G.A.G.R.G.W.Y.
                                            # F.D.L.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.
                                            # A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.
                                            # G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.
                                            # V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.
                                            # M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.
                                            # T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.
                                            # K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.
                                            # V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.
                                            # S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.
                                            # T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.Q.S.G.G.G.V.E.R.P.G.G.S.L.R.L.S.
                                            # C.A.A.S.G.F.T.F.D.D.Y.G.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.S.G.I.N.W.N.G.G.S.T.
                                            # G.Y.A.D.S.V.K.G.R.V.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.
                                            # C.A.K.I.L.G.A.G.R.G.W.Y.F.D.L.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.
                                            # A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.
                                            # G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.
                                            # N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.
                                            # V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.
                                            # W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.
                                            # L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.
                                            # L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.
                                            # E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.
                                            # C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{S.S.E.L.T.Q.D.P.A.
                                            # V.S.V.A.L.G.Q.T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.Y.A.S.W.Y.Q.Q.K.P.G.Q.A.P.V.L.V.
                                            # I.Y.G.K.N.N.R.P.S.G.I.P.D.R.F.S.G.S.S.S.G.N.T.A.S.L.T.I.T.G.A.Q.A.E.D.E.A.
                                            # D.Y.Y.C.N.S.R.D.S.S.G.N.H.V.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.
                                            # P.P.S.S.E.E.L.Q.A.N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.
                                            # K.A.G.V.E.T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.
                                            # C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.T.E.C.S}$PEPTIDE4,PEPTIDE4,22:R3-87:R3|PEP
                                            # TIDE3,PEPTIDE3,148:R3-204:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPT
                                            # IDE2,148:R3-204:R3|PEPTIDE4,PEPTIDE4,136:R3-195:R3|PEPTIDE3,PEPTIDE4,224:R
                                            # 3-213:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE1,PEPTIDE1,22:R3-87:R3|PEPTI
                                            # DE3,PEPTIDE3,265:R3-325:R3|PEPTIDE2,PEPTIDE1,224:R3-213:R3|PEPTIDE3,PEPTID
                                            # E3,22:R3-96:R3|PEPTIDE2,PEPTIDE2,371:R3-429:R3|PEPTIDE1,PEPTIDE1,136:R3-19
                                            # 5:R3|PEPTIDE2,PEPTIDE2,265:R3-325:R3|PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTI
                                            # DE2,PEPTIDE3,233:R3-233:R3$$$' , 'PEPTIDE1{S.S.E.L.T.Q.D.P.A.V.S.V.A.L.G.Q
                                            # .T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.Y.A.T.W.Y.Q.Q.K.P.G.Q.A.P.I.L.V.I.Y.G.E.N.K.R
                                            # .P.S.G.I.P.D.R.F.S.G.S.S.S.G.N.T.A.S.L.T.I.T.G.A.Q.A.E.D.E.A.D.Y.Y.C.K.S.R
                                            # .D.G.S.G.Q.H.L.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E.E.L
                                            # .Q.A.N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E.T.T
                                            # .T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G
                                            # .S.T.V.E.K.T.V.A.P.A.E.C.S}|PEPTIDE2{E.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.S.S.V.K
                                            # .V.S.C.K.A.S.G.G.T.F.S.S.Y.A.I.S.W.V.R.Q.A.P.G.Q.G.L.E.W.M.G.G.I.I.P.I.F.G
                                            # .T.A.N.Y.A.Q.K.F.Q.G.R.V.T.I.T.A.D.K.S.T.S.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V
                                            # .Y.Y.C.A.R.A.P.L.R.F.L.E.W.S.T.Q.D.H.Y.Y.Y.Y.Y.M.D.V.W.G.K.G.T.T.V.T.V.S.S
                                            # .A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V
                                            # .T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S
                                            # .S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P
                                            # .C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D
                                            # .V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V
                                            # .V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A
                                            # .K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D
                                            # .I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D
                                            # .K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPT
                                            # IDE3{E.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.S.S.V.K.V.S.C.K.A.S.G.G.T.F.S.S.Y.A.I.S
                                            # .W.V.R.Q.A.P.G.Q.G.L.E.W.M.G.G.I.I.P.I.F.G.T.A.N.Y.A.Q.K.F.Q.G.R.V.T.I.T.A
                                            # .D.K.S.T.S.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V.Y.Y.C.A.R.A.P.L.R.F.L.E.W.S.T.Q
                                            # .D.H.Y.Y.Y.Y.Y.M.D.V.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K
                                            # .S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F
                                            # .P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S
                                            # .N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P
                                            # .P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G
                                            # .V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E
                                            # .Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R
                                            # .E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K
                                            # .T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H
                                            # .E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{S.S.E.L.T.Q.D.P.A.V.S.V.A.L
                                            # .G.Q.T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.Y.A.T.W.Y.Q.Q.K.P.G.Q.A.P.I.L.V.I.Y.G.E.N
                                            # .K.R.P.S.G.I.P.D.R.F.S.G.S.S.S.G.N.T.A.S.L.T.I.T.G.A.Q.A.E.D.E.A.D.Y.Y.C.K
                                            # .S.R.D.G.S.G.Q.H.L.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E
                                            # .E.L.Q.A.N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E
                                            # .T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H
                                            # .E.G.S.T.V.E.K.T.V.A.P.A.E.C.S}$PEPTIDE2,PEPTIDE1,233:R3-213:R3|PEPTIDE3,P
                                            # EPTIDE3,157:R3-213:R3|PEPTIDE2,PEPTIDE2,380:R3-438:R3|PEPTIDE2,PEPTIDE3,23
                                            # 9:R3-239:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE4,PEPTIDE4,136:R3-195:R3|
                                            # PEPTIDE2,PEPTIDE3,242:R3-242:R3|PEPTIDE3,PEPTIDE3,380:R3-438:R3|PEPTIDE2,P
                                            # EPTIDE2,22:R3-96:R3|PEPTIDE1,PEPTIDE1,136:R3-195:R3|PEPTIDE3,PEPTIDE4,233:
                                            # R3-213:R3|PEPTIDE2,PEPTIDE2,157:R3-213:R3|PEPTIDE3,PEPTIDE3,274:R3-334:R3|
                                            # PEPTIDE1,PEPTIDE1,22:R3-87:R3|PEPTIDE2,PEPTIDE2,274:R3-334:R3|PEPTIDE4,PEP
                                            # TIDE4,22:R3-87:R3$$$' , 'PEPTIDE1{D.I.V.M.T.Q.S.Q.R.F.M.S.T.T.V.G.D.R.V.S.
                                            # I.T.C.K.A.S.Q.N.V.V.S.A.V.A.W.Y.Q.Q.K.P.G.Q.S.P.K.L.L.I.Y.S.A.S.N.R.Y.T.G.
                                            # V.P.D.R.F.T.G.S.G.S.G.T.D.F.T.L.T.I.S.N.M.Q.S.E.D.L.A.D.F.F.C.Q.Q.Y.S.N.Y.
                                            # P.W.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.
                                            # V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.
                                            # K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.
                                            # T.K.S.F.N.R.G.E.C}|PEPTIDE2{D.V.K.L.V.E.S.G.G.G.L.V.K.L.G.G.S.L.K.L.S.C.A.
                                            # A.S.G.F.T.F.S.N.Y.Y.M.S.W.V.R.Q.T.P.E.K.R.L.E.L.V.A.A.I.N.S.D.G.G.I.T.Y.Y.
                                            # L.D.T.V.K.G.R.F.T.I.S.R.D.N.A.K.N.T.L.Y.L.Q.M.S.S.L.K.S.E.D.T.A.L.F.Y.C.A.
                                            # R.H.R.S.G.Y.F.S.M.D.Y.W.G.Q.G.T.S.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.
                                            # K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.
                                            # F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.
                                            # S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.
                                            # P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.
                                            # G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.
                                            # E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.
                                            # R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.
                                            # K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.
                                            # H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{D.V.K.L.V.E.S.G.G.G.L.V.K.
                                            # L.G.G.S.L.K.L.S.C.A.A.S.G.F.T.F.S.N.Y.Y.M.S.W.V.R.Q.T.P.E.K.R.L.E.L.V.A.A.
                                            # I.N.S.D.G.G.I.T.Y.Y.L.D.T.V.K.G.R.F.T.I.S.R.D.N.A.K.N.T.L.Y.L.Q.M.S.S.L.K.
                                            # S.E.D.T.A.L.F.Y.C.A.R.H.R.S.G.Y.F.S.M.D.Y.W.G.Q.G.T.S.V.T.V.S.S.A.S.T.K.G.
                                            # P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.
                                            # S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.
                                            # T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.
                                            # L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.
                                            # P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.
                                            # V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.
                                            # E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.
                                            # E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.
                                            # Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.V.
                                            # M.T.Q.S.Q.R.F.M.S.T.T.V.G.D.R.V.S.I.T.C.K.A.S.Q.N.V.V.S.A.V.A.W.Y.Q.Q.K.P.
                                            # G.Q.S.P.K.L.L.I.Y.S.A.S.N.R.Y.T.G.V.P.D.R.F.T.G.S.G.S.G.T.D.F.T.L.T.I.S.N.
                                            # M.Q.S.E.D.L.A.D.F.F.C.Q.Q.Y.S.N.Y.P.W.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.
                                            # V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.
                                            # N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.
                                            # H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE3,PEPTIDE4,222
                                            # :R3-214:R3|PEPTIDE4,PEPTIDE4,134:R3-194:R3|PEPTIDE1,PEPTIDE1,134:R3-194:R3
                                            # |PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE2,146:R3-202:R3|PEPTIDE2,PE
                                            # PTIDE1,222:R3-214:R3|PEPTIDE2,PEPTIDE2,369:R3-427:R3|PEPTIDE3,PEPTIDE3,263
                                            # :R3-323:R3|PEPTIDE2,PEPTIDE2,263:R3-323:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3|P
                                            # EPTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3|PEPTIDE3,PEPT
                                            # IDE3,369:R3-427:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,146:R3-
                                            # 202:R3|PEPTIDE2,PEPTIDE3,228:R3-228:R3$$$' , 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S
                                            # .V.S.A.S.I.G.D.R.V.T.I.T.C.R.A.S.Q.G.I.D.N.W.L.G.W.Y.Q.Q.K.P.G.K.A.P.K.L.L
                                            # .I.Y.D.A.S.N.L.D.T.G.V.P.S.R.F.S.G.S.G.S.G.T.Y.F.T.L.T.I.S.S.L.Q.A.E.D.F.A
                                            # .V.Y.F.C.Q.Q.A.K.A.F.P.P.T.F.G.G.G.T.K.V.D.I.K.G.T.V.A.A.P.S.V.F.I.F.P.P.S
                                            # .D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N
                                            # .S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E
                                            # .V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.Q.S.G.G.G.L.V.K
                                            # .P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.S.M.N.W.V.R.Q.A.P.G.K.G.L.E.W.V.S.S
                                            # .I.S.S.S.S.S.Y.I.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R
                                            # .A.E.D.T.A.V.Y.Y.C.A.R.V.T.D.A.F.D.I.W.G.Q.G.T.M.V.T.V.S.S.A.S.T.K.G.P.S.V
                                            # .F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A
                                            # .L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I
                                            # .C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G
                                            # .G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V
                                            # .K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H
                                            # .Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q
                                            # .V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N
                                            # .G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N
                                            # .V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.Q
                                            # .S.G.G.G.L.V.K.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.S.M.N.W.V.R.Q.A.P.G.K
                                            # .G.L.E.W.V.S.S.I.S.S.S.S.S.Y.I.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y
                                            # .L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.V.T.D.A.F.D.I.W.G.Q.G.T.M.V.T.V.S.S.A
                                            # .S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T
                                            # .V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S
                                            # .L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C
                                            # .P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V
                                            # .S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V
                                            # .S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K
                                            # .G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I
                                            # .A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K
                                            # .S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTID
                                            # E4{D.I.Q.M.T.Q.S.P.S.S.V.S.A.S.I.G.D.R.V.T.I.T.C.R.A.S.Q.G.I.D.N.W.L.G.W.Y
                                            # .Q.Q.K.P.G.K.A.P.K.L.L.I.Y.D.A.S.N.L.D.T.G.V.P.S.R.F.S.G.S.G.S.G.T.Y.F.T.L
                                            # .T.I.S.S.L.Q.A.E.D.F.A.V.Y.F.C.Q.Q.A.K.A.F.P.P.T.F.G.G.G.T.K.V.D.I.K.G.T.V
                                            # .A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q
                                            # .W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A
                                            # .D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE3,PEP
                                            # TIDE4,219:R3-214:R3|PEPTIDE2,PEPTIDE2,143:R3-199:R3|PEPTIDE1,PEPTIDE1,23:R
                                            # 3-88:R3|PEPTIDE3,PEPTIDE3,366:R3-424:R3|PEPTIDE3,PEPTIDE3,260:R3-320:R3|PE
                                            # PTIDE2,PEPTIDE3,225:R3-225:R3|PEPTIDE2,PEPTIDE2,366:R3-424:R3|PEPTIDE3,PEP
                                            # TIDE3,143:R3-199:R3|PEPTIDE4,PEPTIDE4,134:R3-194:R3|PEPTIDE2,PEPTIDE2,260:
                                            # R3-320:R3|PEPTIDE2,PEPTIDE1,219:R3-214:R3|PEPTIDE1,PEPTIDE1,134:R3-194:R3|
                                            # PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTI
                                            # DE3,228:R3-228:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3$$$' , 'PEPTIDE1{D.I.Q.M.T.
                                            # Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.G.I.S.R.W.L.A.W.Y.Q.Q.K.P.E.K.
                                            # A.P.K.S.L.I.Y.A.A.S.S.L.Q.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.
                                            # P.E.D.F.A.T.Y.Y.C.Q.Q.Y.N.T.Y.P.R.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.
                                            # I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.
                                            # L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.
                                            # V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{Q.V.Q.L.V.E.S.G.
                                            # G.G.V.V.Q.P.G.R.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.D.M.H.W.V.R.Q.A.P.G.K.G.L.
                                            # E.W.V.A.V.I.W.Y.D.G.S.N.K.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.
                                            # M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.G.S.G.N.W.G.F.F.D.Y.W.G.Q.G.T.L.V.T.V.S.S.
                                            # A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.
                                            # T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.
                                            # S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.
                                            # C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.
                                            # V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.
                                            # V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.
                                            # K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.
                                            # I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.
                                            # K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K.G.S.S}
                                            # |PEPTIDE3{Q.V.Q.L.V.E.S.G.G.G.V.V.Q.P.G.R.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.
                                            # D.M.H.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.V.I.W.Y.D.G.S.N.K.Y.Y.A.D.S.V.K.G.R.F.T.
                                            # I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.G.S.G.N.W.G.F.F.
                                            # D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.
                                            # L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.
                                            # L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.
                                            # E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.
                                            # I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.
                                            # K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.
                                            # A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.
                                            # S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.
                                            # D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.
                                            # Q.K.S.L.S.L.S.P.G.K.G.S.S}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.
                                            # T.I.T.C.R.A.S.Q.G.I.S.R.W.L.A.W.Y.Q.Q.K.P.E.K.A.P.K.S.L.I.Y.A.A.S.S.L.Q.S.
                                            # G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.Y.N.T.
                                            # Y.P.R.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.
                                            # S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.
                                            # S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.
                                            # V.T.K.S.F.N.R.G.E.C}$PEPTIDE1,PEPTIDE1,134:R3-194:R3|PEPTIDE3,PEPTIDE3,263
                                            # :R3-323:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE2,146:R3-202:R3|P
                                            # EPTIDE4,PEPTIDE4,134:R3-194:R3|PEPTIDE2,PEPTIDE2,369:R3-427:R3|PEPTIDE3,PE
                                            # PTIDE4,222:R3-214:R3|PEPTIDE2,PEPTIDE3,228:R3-228:R3|PEPTIDE3,PEPTIDE3,146
                                            # :R3-202:R3|PEPTIDE2,PEPTIDE1,222:R3-214:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|P
                                            # EPTIDE2,PEPTIDE2,263:R3-323:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3|PEPTIDE1,PE
                                            # PTIDE1,23:R3-88:R3|PEPTIDE3,PEPTIDE3,369:R3-427:R3|PEPTIDE4,PEPTIDE4,23:R3
                                            # -88:R3$$$' , 'PEPTIDE1{I.M.D.Q.V.P.F.S.V}$$$$' , 'PEPTIDE1{D.I.Q.L.T.Q.S.P
                                            # .S.S.L.S.A.S.V.G.D.R.V.T.M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.K.A.P.K.P
                                            # .W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F.S.G.S.G.S.G.T.D.Y.T.F.T.I.S.S.L.Q.P.E.D.I
                                            # .A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P
                                            # .S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G
                                            # .N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C
                                            # .E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{Q.V.Q.L.Q.Q.S.G.A.E.V.K
                                            # .K.P.G.S.S.V.K.V.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.A.P.G.Q.G.L.E.W.I.G
                                            # .A.I.Y.P.G.M.G.D.T.S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.E.S.T.N.T.A.Y.M.E.L.S.S.L
                                            # .R.S.E.D.T.A.F.Y.Y.C.A.R.S.T.Y.Y.G.G.D.W.Y.F.D.V.W.G.Q.G.T.T.V.T.V.S.S.A.S
                                            # .T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V
                                            # .S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L
                                            # .G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P
                                            # .A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S
                                            # .H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S
                                            # .V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G
                                            # .Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A
                                            # .V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S
                                            # .R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3
                                            # {Q.V.Q.L.Q.Q.S.G.A.E.V.K.K.P.G.S.S.V.K.V.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V
                                            # .K.Q.A.P.G.Q.G.L.E.W.I.G.A.I.Y.P.G.M.G.D.T.S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.E
                                            # .S.T.N.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.F.Y.Y.C.A.R.S.T.Y.Y.G.G.D.W.Y.F.D.V.W
                                            # .G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C
                                            # .L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S
                                            # .L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K
                                            # .S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R
                                            # .T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R
                                            # .E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P
                                            # .A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T
                                            # .C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S
                                            # .F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S
                                            # .L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.L.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.M.T.C.R.A
                                            # .S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.K.A.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F.S
                                            # .G.S.G.S.G.T.D.Y.T.F.T.I.S.S.L.Q.P.E.D.I.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G
                                            # .G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N
                                            # .N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S
                                            # .L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R
                                            # .G.E.C}$PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE2,PEPTIDE1,224:R3-213:R3|PE
                                            # PTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE2,148:R3-204:R3|PEPTIDE1,PEPTI
                                            # DE1,133:R3-193:R3|PEPTIDE1,PEPTIDE1,23:R3-87:R3|PEPTIDE4,PEPTIDE4,23:R3-87
                                            # :R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE3,PEPTIDE3,148:R3-204:R3|PEPTID
                                            # E4,PEPTIDE4,133:R3-193:R3|PEPTIDE2,PEPTIDE2,265:R3-325:R3|PEPTIDE2,PEPTIDE
                                            # 2,22:R3-96:R3|PEPTIDE3,PEPTIDE4,224:R3-213:R3|PEPTIDE2,PEPTIDE2,371:R3-429
                                            # :R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3$$$' , 
                                            # 'PEPTIDE1{E.I.V.L.T.Q.S.P.A.T.L.S.L.S.P.G.E.R.A.T.L.S.C.S.A.S.I.S.V.S.Y.M.
                                            # Y.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.D.M.S.N.L.A.S.G.I.P.A.R.F.S.G.S.G.S.G.T.D.
                                            # F.T.L.T.I.S.S.L.E.P.E.D.F.A.V.Y.Y.C.M.Q.W.S.G.Y.P.Y.T.F.G.G.G.T.K.V.E.I.K.
                                            # R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.
                                            # K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.
                                            # S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE
                                            # 2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.P.F.A.M.S.W.
                                            # V.R.Q.A.P.G.K.G.L.E.W.V.A.K.I.S.P.G.G.S.W.T.Y.Y.S.D.T.V.T.G.R.F.T.I.S.R.D.
                                            # N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.Q.L.W.G.Y.Y.A.L.D.I.W.G.
                                            # Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.
                                            # V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.
                                            # S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.
                                            # C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.
                                            # P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.
                                            # E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.
                                            # P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.
                                            # L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.
                                            # F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.
                                            # S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.
                                            # F.T.F.S.P.F.A.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.K.I.S.P.G.G.S.W.T.Y.Y.S.D.T.
                                            # V.T.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.Q.L.
                                            # W.G.Y.Y.A.L.D.I.W.G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.
                                            # S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.
                                            # V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.
                                            # K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.
                                            # P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.
                                            # V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.
                                            # C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.
                                            # L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.
                                            # P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.
                                            # L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{E.I.V.L.T.Q.S.P.A.T.L.S.L.S.P.G.
                                            # E.R.A.T.L.S.C.S.A.S.I.S.V.S.Y.M.Y.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.D.M.S.N.L.
                                            # A.S.G.I.P.A.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.E.P.E.D.F.A.V.Y.Y.C.M.Q.W.
                                            # S.G.Y.P.Y.T.F.G.G.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.
                                            # T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.
                                            # Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.
                                            # S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE1,PEPTIDE1,23:R3-87:R3|PEPTIDE3,PEPTIDE4,2
                                            # 22:R3-213:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE1,PEPTIDE1,133:R3-193:R3
                                            # |PEPTIDE4,PEPTIDE4,133:R3-193:R3|PEPTIDE2,PEPTIDE2,146:R3-202:R3|PEPTIDE3,
                                            # PEPTIDE3,369:R3-427:R3|PEPTIDE2,PEPTIDE1,222:R3-213:R3|PEPTIDE3,PEPTIDE3,1
                                            # 46:R3-202:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE3,PEPTIDE3,263:R3-323:R3
                                            # |PEPTIDE2,PEPTIDE2,263:R3-323:R3|PEPTIDE2,PEPTIDE3,228:R3-228:R3|PEPTIDE4,
                                            # PEPTIDE4,23:R3-87:R3|PEPTIDE2,PEPTIDE2,369:R3-427:R3|PEPTIDE2,PEPTIDE3,231
                                            # :R3-231:R3$$$'
                                            'molecule_chembl_id': 'TEXT',
                                            # EXAMPLES:
                                            # 'CHEMBL3990010' , 'CHEMBL2109520' , 'CHEMBL3989983' , 'CHEMBL2109674' , 'C
                                            # HEMBL3545192' , 'CHEMBL2108827' , 'CHEMBL1201642' , 'CHEMBL2109648' , 'CHE
                                            # MBL2109626' , 'CHEMBL3989992'
                                        }
                                    },
                                    'black_box': 'BOOLEAN',
                                    # EXAMPLES:
                                    # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'F
                                    # alse' , 'False'
                                    'chirality': 'NUMERIC',
                                    # EXAMPLES:
                                    # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                                    'development_phase': 'NUMERIC',
                                    # EXAMPLES:
                                    # '0' , '0' , '0' , '4' , '0' , '0' , '0' , '1' , '0' , '0'
                                    'drug_type': 'NUMERIC',
                                    # EXAMPLES:
                                    # '-1' , '-1' , '10' , '-1' , '3' , '-1' , '-1' , '1' , '-1' , '6'
                                    'first_approval': 'NUMERIC',
                                    # EXAMPLES:
                                    # '1982' , '1997' , '1988' , '1998' , '1982' , '1993' , '1994' , '1994' , '2018' , '
                                    # 1990'
                                    'first_in_class': 'BOOLEAN',
                                    # EXAMPLES:
                                    # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'F
                                    # alse' , 'False'
                                    'helm_notation': 'TEXT',
                                    # EXAMPLES:
                                    # 'PEPTIDE1{D.I.Q.M.T.Q.R.P.D.S.L.S.A.S.V.G.D.R.V.T.M.S.C.K.S.S.Q.S.L.L.N.S.G.D.Q.K.
                                    # N.Y.L.T.W.Y.Q.Q.K.P.G.Q.P.P.K.L.L.I.Y.W.A.S.T.G.E.S.G.V.P.D.R.F.S.G.S.G.S.G.T.D.F.
                                    # T.F.T.I.S.S.L.Q.P.E.D.I.A.T.Y.Y.C.Q.N.D.Y.S.Y.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.
                                    # P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.
                                    # L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.
                                    # E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{Q.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.A.
                                    # S.V.K.V.S.C.K.A.S.G.Y.T.F.T.N.S.W.I.G.W.F.R.Q.A.P.G.Q.G.L.E.W.I.G.D.I.Y.P.G.G.G.Y.
                                    # T.N.Y.N.E.I.F.K.G.K.A.T.M.T.A.D.T.S.T.N.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V.Y.Y.C.S.R.
                                    # G.I.P.G.Y.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.
                                    # T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.
                                    # Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.
                                    # D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.
                                    # V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.
                                    # V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.
                                    # R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.
                                    # G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.
                                    # S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{Q.V.Q.L.V.Q.S.G.A.E.V.K.K.P.
                                    # G.A.S.V.K.V.S.C.K.A.S.G.Y.T.F.T.N.S.W.I.G.W.F.R.Q.A.P.G.Q.G.L.E.W.I.G.D.I.Y.P.G.G.
                                    # G.Y.T.N.Y.N.E.I.F.K.G.K.A.T.M.T.A.D.T.S.T.N.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V.Y.Y.C.
                                    # S.R.G.I.P.G.Y.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.
                                    # G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.
                                    # G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.
                                    # S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.
                                    # T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.
                                    # R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.
                                    # Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.
                                    # S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.
                                    # S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.R.P.D.S.L.S.
                                    # A.S.V.G.D.R.V.T.M.S.C.K.S.S.Q.S.L.L.N.S.G.D.Q.K.N.Y.L.T.W.Y.Q.Q.K.P.G.Q.P.P.K.L.L.
                                    # I.Y.W.A.S.T.G.E.S.G.V.P.D.R.F.S.G.S.G.S.G.T.D.F.T.F.T.I.S.S.L.Q.P.E.D.I.A.T.Y.Y.C.
                                    # Q.N.D.Y.S.Y.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.
                                    # A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.
                                    # S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.
                                    # G.E.C}$PEPTIDE1,PEPTIDE1,140:R3-200:R3|PEPTIDE3,PEPTIDE3,145:R3-201:R3|PEPTIDE2,PE
                                    # PTIDE2,22:R3-96:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE2,262:R3-322:R3
                                    # |PEPTIDE4,PEPTIDE4,140:R3-200:R3|PEPTIDE3,PEPTIDE4,221:R3-220:R3|PEPTIDE4,PEPTIDE4
                                    # ,23:R3-94:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE3,227:R3-227:R3|PEPTIDE
                                    # 3,PEPTIDE3,262:R3-322:R3|PEPTIDE2,PEPTIDE1,221:R3-220:R3|PEPTIDE2,PEPTIDE2,145:R3-
                                    # 201:R3|PEPTIDE1,PEPTIDE1,23:R3-94:R3|PEPTIDE2,PEPTIDE2,368:R3-426:R3|PEPTIDE3,PEPT
                                    # IDE3,368:R3-426:R3$$$' , 'PEPTIDE1{Q.S.V.L.T.Q.P.P.S.A.S.G.T.P.G.Q.R.V.T.I.S.C.S.G
                                    # .S.N.T.N.I.G.K.N.Y.V.S.W.Y.Q.Q.L.P.G.T.A.P.K.L.L.I.Y.A.N.S.N.R.P.S.G.V.P.D.R.F.S.G
                                    # .S.K.S.G.T.S.A.S.L.A.I.S.G.L.R.S.E.D.E.A.D.Y.Y.C.A.S.W.D.A.S.L.N.G.W.V.F.G.G.G.T.K
                                    # .L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E.E.L.Q.A.N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A
                                    # .V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E.T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q
                                    # .W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.T.E.C.S}|PEPTIDE2{E.V.Q.L.L.E.S.G
                                    # .G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.N.A.W.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.S
                                    # .S.I.S.V.G.G.H.R.T.Y.Y.A.D.S.V.K.G.R.S.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D
                                    # .T.A.V.Y.Y.C.A.R.I.R.V.G.P.S.G.G.A.F.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P
                                    # .L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H
                                    # .T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T
                                    # .K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T
                                    # .L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P
                                    # .R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I
                                    # .E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y
                                    # .P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K
                                    # .S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q
                                    # .L.L.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.N.A.W.M.S.W.V.R.Q.A.P.G.K.G
                                    # .L.E.W.V.S.S.I.S.V.G.G.H.R.T.Y.Y.A.D.S.V.K.G.R.S.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S
                                    # .L.R.A.E.D.T.A.V.Y.Y.C.A.R.I.R.V.G.P.S.G.G.A.F.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G
                                    # .P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L
                                    # .T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H
                                    # .K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P
                                    # .K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N
                                    # .A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A
                                    # .L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L
                                    # .V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K
                                    # .L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPT
                                    # IDE4{Q.S.V.L.T.Q.P.P.S.A.S.G.T.P.G.Q.R.V.T.I.S.C.S.G.S.N.T.N.I.G.K.N.Y.V.S.W.Y.Q.Q
                                    # .L.P.G.T.A.P.K.L.L.I.Y.A.N.S.N.R.P.S.G.V.P.D.R.F.S.G.S.K.S.G.T.S.A.S.L.A.I.S.G.L.R
                                    # .S.E.D.E.A.D.Y.Y.C.A.S.W.D.A.S.L.N.G.W.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L
                                    # .F.P.P.S.S.E.E.L.Q.A.N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G
                                    # .V.E.T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G
                                    # .S.T.V.E.K.T.V.A.P.T.E.C.S}$PEPTIDE3,PEPTIDE4,224:R3-215:R3|PEPTIDE3,PEPTIDE3,265:
                                    # R3-325:R3|PEPTIDE4,PEPTIDE4,22:R3-89:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEP
                                    # TIDE3,233:R3-233:R3|PEPTIDE1,PEPTIDE1,22:R3-89:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PE
                                    # PTIDE1,PEPTIDE1,138:R3-197:R3|PEPTIDE2,PEPTIDE2,148:R3-204:R3|PEPTIDE4,PEPTIDE4,13
                                    # 8:R3-197:R3|PEPTIDE3,PEPTIDE3,148:R3-204:R3|PEPTIDE2,PEPTIDE2,265:R3-325:R3|PEPTID
                                    # E2,PEPTIDE2,371:R3-429:R3|PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE2,PEPTIDE1,224:R3
                                    # -215:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3$$$' , 'PEPTIDE1{S.S.E.L.T.Q.D.P.A.V.S.V.A.
                                    # L.G.Q.T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.Y.A.S.W.Y.Q.Q.K.P.G.Q.A.P.V.L.V.I.Y.G.K.N.N.R.P.
                                    # S.G.I.P.D.R.F.S.G.S.S.S.G.N.T.A.S.L.T.I.T.G.A.Q.A.E.D.E.A.D.Y.Y.C.N.S.R.D.S.S.G.N.
                                    # H.V.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E.E.L.Q.A.N.K.A.T.L.V.C.
                                    # L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E.T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.
                                    # S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.T.E.C.S}|PEPTIDE
                                    # 2{E.V.Q.L.V.Q.S.G.G.G.V.E.R.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.D.D.Y.G.M.S.W.V.R.Q.A.
                                    # P.G.K.G.L.E.W.V.S.G.I.N.W.N.G.G.S.T.G.Y.A.D.S.V.K.G.R.V.T.I.S.R.D.N.A.K.N.S.L.Y.L.
                                    # Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.K.I.L.G.A.G.R.G.W.Y.F.D.L.W.G.K.G.T.T.V.T.V.S.S.A.
                                    # S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.
                                    # S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.
                                    # N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.
                                    # L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.
                                    # E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.
                                    # S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.
                                    # L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.
                                    # L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.
                                    # K}|PEPTIDE3{E.V.Q.L.V.Q.S.G.G.G.V.E.R.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.D.D.Y.G.M.S.
                                    # W.V.R.Q.A.P.G.K.G.L.E.W.V.S.G.I.N.W.N.G.G.S.T.G.Y.A.D.S.V.K.G.R.V.T.I.S.R.D.N.A.K.
                                    # N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.K.I.L.G.A.G.R.G.W.Y.F.D.L.W.G.K.G.T.T.V.
                                    # T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.
                                    # T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.
                                    # Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.
                                    # G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.
                                    # Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.
                                    # Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.
                                    # K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.
                                    # D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.
                                    # S.L.S.P.G.K}|PEPTIDE4{S.S.E.L.T.Q.D.P.A.V.S.V.A.L.G.Q.T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.
                                    # Y.A.S.W.Y.Q.Q.K.P.G.Q.A.P.V.L.V.I.Y.G.K.N.N.R.P.S.G.I.P.D.R.F.S.G.S.S.S.G.N.T.A.S.
                                    # L.T.I.T.G.A.Q.A.E.D.E.A.D.Y.Y.C.N.S.R.D.S.S.G.N.H.V.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.
                                    # A.A.P.S.V.T.L.F.P.P.S.S.E.E.L.Q.A.N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.
                                    # S.S.P.V.K.A.G.V.E.T.T.T.P.S.K.Q.S.N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.
                                    # C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.T.E.C.S}$PEPTIDE4,PEPTIDE4,22:R3-87:R3|PEPTIDE3,PE
                                    # PTIDE3,148:R3-204:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE2,148:R3-204:
                                    # R3|PEPTIDE4,PEPTIDE4,136:R3-195:R3|PEPTIDE3,PEPTIDE4,224:R3-213:R3|PEPTIDE2,PEPTID
                                    # E2,22:R3-96:R3|PEPTIDE1,PEPTIDE1,22:R3-87:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTI
                                    # DE2,PEPTIDE1,224:R3-213:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE2,371:R3-
                                    # 429:R3|PEPTIDE1,PEPTIDE1,136:R3-195:R3|PEPTIDE2,PEPTIDE2,265:R3-325:R3|PEPTIDE3,PE
                                    # PTIDE3,371:R3-429:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3$$$' , 'PEPTIDE1{S.S.E.L.T.Q.D
                                    # .P.A.V.S.V.A.L.G.Q.T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.Y.A.T.W.Y.Q.Q.K.P.G.Q.A.P.I.L.V.I.Y
                                    # .G.E.N.K.R.P.S.G.I.P.D.R.F.S.G.S.S.S.G.N.T.A.S.L.T.I.T.G.A.Q.A.E.D.E.A.D.Y.Y.C.K.S
                                    # .R.D.G.S.G.Q.H.L.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E.E.L.Q.A.N
                                    # .K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E.T.T.T.P.S.K.Q.S.N
                                    # .N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.A.E
                                    # .C.S}|PEPTIDE2{E.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.S.S.V.K.V.S.C.K.A.S.G.G.T.F.S.S.Y.A.I
                                    # .S.W.V.R.Q.A.P.G.Q.G.L.E.W.M.G.G.I.I.P.I.F.G.T.A.N.Y.A.Q.K.F.Q.G.R.V.T.I.T.A.D.K.S
                                    # .T.S.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V.Y.Y.C.A.R.A.P.L.R.F.L.E.W.S.T.Q.D.H.Y.Y.Y.Y.Y
                                    # .M.D.V.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C
                                    # .L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V
                                    # .V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C
                                    # .P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S
                                    # .H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V
                                    # .L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y
                                    # .T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N
                                    # .Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A
                                    # .L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.S.S.V.K.V
                                    # .S.C.K.A.S.G.G.T.F.S.S.Y.A.I.S.W.V.R.Q.A.P.G.Q.G.L.E.W.M.G.G.I.I.P.I.F.G.T.A.N.Y.A
                                    # .Q.K.F.Q.G.R.V.T.I.T.A.D.K.S.T.S.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.V.Y.Y.C.A.R.A.P.L.R
                                    # .F.L.E.W.S.T.Q.D.H.Y.Y.Y.Y.Y.M.D.V.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P
                                    # .S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P
                                    # .A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D
                                    # .K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I
                                    # .S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E
                                    # .Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T
                                    # .I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D
                                    # .I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W
                                    # .Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{S.S.E.L.T.Q
                                    # .D.P.A.V.S.V.A.L.G.Q.T.V.R.I.T.C.Q.G.D.S.L.R.S.Y.Y.A.T.W.Y.Q.Q.K.P.G.Q.A.P.I.L.V.I
                                    # .Y.G.E.N.K.R.P.S.G.I.P.D.R.F.S.G.S.S.S.G.N.T.A.S.L.T.I.T.G.A.Q.A.E.D.E.A.D.Y.Y.C.K
                                    # .S.R.D.G.S.G.Q.H.L.V.F.G.G.G.T.K.L.T.V.L.G.Q.P.K.A.A.P.S.V.T.L.F.P.P.S.S.E.E.L.Q.A
                                    # .N.K.A.T.L.V.C.L.I.S.D.F.Y.P.G.A.V.T.V.A.W.K.A.D.S.S.P.V.K.A.G.V.E.T.T.T.P.S.K.Q.S
                                    # .N.N.K.Y.A.A.S.S.Y.L.S.L.T.P.E.Q.W.K.S.H.R.S.Y.S.C.Q.V.T.H.E.G.S.T.V.E.K.T.V.A.P.A
                                    # .E.C.S}$PEPTIDE2,PEPTIDE1,233:R3-213:R3|PEPTIDE3,PEPTIDE3,157:R3-213:R3|PEPTIDE2,P
                                    # EPTIDE2,380:R3-438:R3|PEPTIDE2,PEPTIDE3,239:R3-239:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R
                                    # 3|PEPTIDE4,PEPTIDE4,136:R3-195:R3|PEPTIDE2,PEPTIDE3,242:R3-242:R3|PEPTIDE3,PEPTIDE
                                    # 3,380:R3-438:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE1,PEPTIDE1,136:R3-195:R3|PEPT
                                    # IDE3,PEPTIDE4,233:R3-213:R3|PEPTIDE2,PEPTIDE2,157:R3-213:R3|PEPTIDE3,PEPTIDE3,274:
                                    # R3-334:R3|PEPTIDE1,PEPTIDE1,22:R3-87:R3|PEPTIDE2,PEPTIDE2,274:R3-334:R3|PEPTIDE4,P
                                    # EPTIDE4,22:R3-87:R3$$$' , 'PEPTIDE1{D.I.V.M.T.Q.S.Q.R.F.M.S.T.T.V.G.D.R.V.S.I.T.C.
                                    # K.A.S.Q.N.V.V.S.A.V.A.W.Y.Q.Q.K.P.G.Q.S.P.K.L.L.I.Y.S.A.S.N.R.Y.T.G.V.P.D.R.F.T.G.
                                    # S.G.S.G.T.D.F.T.L.T.I.S.N.M.Q.S.E.D.L.A.D.F.F.C.Q.Q.Y.S.N.Y.P.W.T.F.G.G.G.T.K.L.E.
                                    # I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.
                                    # Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.
                                    # K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{D.V.K.L.V.E.S.G.G.
                                    # G.L.V.K.L.G.G.S.L.K.L.S.C.A.A.S.G.F.T.F.S.N.Y.Y.M.S.W.V.R.Q.T.P.E.K.R.L.E.L.V.A.A.
                                    # I.N.S.D.G.G.I.T.Y.Y.L.D.T.V.K.G.R.F.T.I.S.R.D.N.A.K.N.T.L.Y.L.Q.M.S.S.L.K.S.E.D.T.
                                    # A.L.F.Y.C.A.R.H.R.S.G.Y.F.S.M.D.Y.W.G.Q.G.T.S.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.
                                    # S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.
                                    # A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.
                                    # K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.
                                    # S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.
                                    # Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.
                                    # I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.
                                    # I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.
                                    # Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{D.V.K.L.V.E.
                                    # S.G.G.G.L.V.K.L.G.G.S.L.K.L.S.C.A.A.S.G.F.T.F.S.N.Y.Y.M.S.W.V.R.Q.T.P.E.K.R.L.E.L.
                                    # V.A.A.I.N.S.D.G.G.I.T.Y.Y.L.D.T.V.K.G.R.F.T.I.S.R.D.N.A.K.N.T.L.Y.L.Q.M.S.S.L.K.S.
                                    # E.D.T.A.L.F.Y.C.A.R.H.R.S.G.Y.F.S.M.D.Y.W.G.Q.G.T.S.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.
                                    # L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.
                                    # T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.
                                    # K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.
                                    # L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.
                                    # R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.
                                    # E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.
                                    # P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.
                                    # S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.V.
                                    # M.T.Q.S.Q.R.F.M.S.T.T.V.G.D.R.V.S.I.T.C.K.A.S.Q.N.V.V.S.A.V.A.W.Y.Q.Q.K.P.G.Q.S.P.
                                    # K.L.L.I.Y.S.A.S.N.R.Y.T.G.V.P.D.R.F.T.G.S.G.S.G.T.D.F.T.L.T.I.S.N.M.Q.S.E.D.L.A.D.
                                    # F.F.C.Q.Q.Y.S.N.Y.P.W.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.
                                    # S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.
                                    # S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.
                                    # F.N.R.G.E.C}$PEPTIDE3,PEPTIDE4,222:R3-214:R3|PEPTIDE4,PEPTIDE4,134:R3-194:R3|PEPTI
                                    # DE1,PEPTIDE1,134:R3-194:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE2,146:R3-
                                    # 202:R3|PEPTIDE2,PEPTIDE1,222:R3-214:R3|PEPTIDE2,PEPTIDE2,369:R3-427:R3|PEPTIDE3,PE
                                    # PTIDE3,263:R3-323:R3|PEPTIDE2,PEPTIDE2,263:R3-323:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3
                                    # |PEPTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3|PEPTIDE3,PEPTIDE3,3
                                    # 69:R3-427:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,146:R3-202:R3|PEPTIDE
                                    # 2,PEPTIDE3,228:R3-228:R3$$$' , 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.V.S.A.S.I.G.D.R.V.T.I
                                    # .T.C.R.A.S.Q.G.I.D.N.W.L.G.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.I.Y.D.A.S.N.L.D.T.G.V.P.S.R.F
                                    # .S.G.S.G.S.G.T.Y.F.T.L.T.I.S.S.L.Q.A.E.D.F.A.V.Y.F.C.Q.Q.A.K.A.F.P.P.T.F.G.G.G.T.K
                                    # .V.D.I.K.G.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A
                                    # .K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D
                                    # .Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.Q.S
                                    # .G.G.G.L.V.K.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.S.M.N.W.V.R.Q.A.P.G.K.G.L.E.W.V
                                    # .S.S.I.S.S.S.S.S.Y.I.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E
                                    # .D.T.A.V.Y.Y.C.A.R.V.T.D.A.F.D.I.W.G.Q.G.T.M.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S
                                    # .S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A
                                    # .V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K
                                    # .K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S
                                    # .R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q
                                    # .Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I
                                    # .S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I
                                    # .A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q
                                    # .Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.Q.S
                                    # .G.G.G.L.V.K.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.S.M.N.W.V.R.Q.A.P.G.K.G.L.E.W.V
                                    # .S.S.I.S.S.S.S.S.Y.I.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E
                                    # .D.T.A.V.Y.Y.C.A.R.V.T.D.A.F.D.I.W.G.Q.G.T.M.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S
                                    # .S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A
                                    # .V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K
                                    # .K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S
                                    # .R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q
                                    # .Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I
                                    # .S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I
                                    # .A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q
                                    # .Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.S
                                    # .P.S.S.V.S.A.S.I.G.D.R.V.T.I.T.C.R.A.S.Q.G.I.D.N.W.L.G.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.I
                                    # .Y.D.A.S.N.L.D.T.G.V.P.S.R.F.S.G.S.G.S.G.T.Y.F.T.L.T.I.S.S.L.Q.A.E.D.F.A.V.Y.F.C.Q
                                    # .Q.A.K.A.F.P.P.T.F.G.G.G.T.K.V.D.I.K.G.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A
                                    # .S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S
                                    # .T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G
                                    # .E.C}$PEPTIDE3,PEPTIDE4,219:R3-214:R3|PEPTIDE2,PEPTIDE2,143:R3-199:R3|PEPTIDE1,PEP
                                    # TIDE1,23:R3-88:R3|PEPTIDE3,PEPTIDE3,366:R3-424:R3|PEPTIDE3,PEPTIDE3,260:R3-320:R3|
                                    # PEPTIDE2,PEPTIDE3,225:R3-225:R3|PEPTIDE2,PEPTIDE2,366:R3-424:R3|PEPTIDE3,PEPTIDE3,
                                    # 143:R3-199:R3|PEPTIDE4,PEPTIDE4,134:R3-194:R3|PEPTIDE2,PEPTIDE2,260:R3-320:R3|PEPT
                                    # IDE2,PEPTIDE1,219:R3-214:R3|PEPTIDE1,PEPTIDE1,134:R3-194:R3|PEPTIDE2,PEPTIDE2,22:R
                                    # 3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE3,228:R3-228:R3|PEPTIDE4,PEP
                                    # TIDE4,23:R3-88:R3$$$' , 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.
                                    # A.S.Q.G.I.S.R.W.L.A.W.Y.Q.Q.K.P.E.K.A.P.K.S.L.I.Y.A.A.S.S.L.Q.S.G.V.P.S.R.F.S.G.S.
                                    # G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.Y.N.T.Y.P.R.T.F.G.Q.G.T.K.V.E.I.
                                    # K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.
                                    # W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.
                                    # H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{Q.V.Q.L.V.E.S.G.G.G.
                                    # V.V.Q.P.G.R.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.D.M.H.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.V.I.
                                    # W.Y.D.G.S.N.K.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.
                                    # V.Y.Y.C.A.R.G.S.G.N.W.G.F.F.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.
                                    # S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.
                                    # V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.
                                    # K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.
                                    # R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.
                                    # Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.
                                    # S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.
                                    # A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.
                                    # Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K.G.S.S}|PEPTIDE3{Q.V.Q.L.
                                    # V.E.S.G.G.G.V.V.Q.P.G.R.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.D.M.H.W.V.R.Q.A.P.G.K.G.L.
                                    # E.W.V.A.V.I.W.Y.D.G.S.N.K.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.
                                    # R.A.E.D.T.A.V.Y.Y.C.A.R.G.S.G.N.W.G.F.F.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.
                                    # F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.
                                    # V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.
                                    # N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.
                                    # D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.
                                    # K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.
                                    # P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.
                                    # F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.
                                    # D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K.G.S.S}|PEPTI
                                    # DE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.G.I.S.R.W.L.A.W.Y.Q.Q.K.
                                    # P.E.K.A.P.K.S.L.I.Y.A.A.S.S.L.Q.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.
                                    # E.D.F.A.T.Y.Y.C.Q.Q.Y.N.T.Y.P.R.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.
                                    # D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.
                                    # V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.
                                    # P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE1,PEPTIDE1,134:R3-194:R3|PEPTIDE3,PEPTIDE3,263:R3-32
                                    # 3:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE2,146:R3-202:R3|PEPTIDE4,PEPTID
                                    # E4,134:R3-194:R3|PEPTIDE2,PEPTIDE2,369:R3-427:R3|PEPTIDE3,PEPTIDE4,222:R3-214:R3|P
                                    # EPTIDE2,PEPTIDE3,228:R3-228:R3|PEPTIDE3,PEPTIDE3,146:R3-202:R3|PEPTIDE2,PEPTIDE1,2
                                    # 22:R3-214:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE2,PEPTIDE2,263:R3-323:R3|PEPTIDE
                                    # 2,PEPTIDE3,231:R3-231:R3|PEPTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE3,PEPTIDE3,369:R3-42
                                    # 7:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3$$$' , 'PEPTIDE1{I.M.D.Q.V.P.F.S.V}$$$$' , 'PEPT
                                    # IDE1{D.I.Q.L.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P
                                    # .G.K.A.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F.S.G.S.G.S.G.T.D.Y.T.F.T.I.S.S.L.Q.P.E
                                    # .D.I.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D
                                    # .E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V
                                    # .T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P
                                    # .V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{Q.V.Q.L.Q.Q.S.G.A.E.V.K.K.P.G.S.S.V.K.V.S.C.K.A.S.G
                                    # .Y.T.F.T.S.Y.N.M.H.W.V.K.Q.A.P.G.Q.G.L.E.W.I.G.A.I.Y.P.G.M.G.D.T.S.Y.N.Q.K.F.K.G.K
                                    # .A.T.L.T.A.D.E.S.T.N.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.F.Y.Y.C.A.R.S.T.Y.Y.G.G.D.W.Y.F
                                    # .D.V.W.G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L
                                    # .V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V
                                    # .T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P
                                    # .P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H
                                    # .E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L
                                    # .H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T
                                    # .L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y
                                    # .K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L
                                    # .H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{Q.V.Q.L.Q.Q.S.G.A.E.V.K.K.P.G.S.S.V.K.V.S
                                    # .C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.A.P.G.Q.G.L.E.W.I.G.A.I.Y.P.G.M.G.D.T.S.Y.N.Q
                                    # .K.F.K.G.K.A.T.L.T.A.D.E.S.T.N.T.A.Y.M.E.L.S.S.L.R.S.E.D.T.A.F.Y.Y.C.A.R.S.T.Y.Y.G
                                    # .G.D.W.Y.F.D.V.W.G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A
                                    # .A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S
                                    # .L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K
                                    # .T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V
                                    # .V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S
                                    # .V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E
                                    # .P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q
                                    # .P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V
                                    # .M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.L.T.Q.S.P.S.S.L.S.A.S.V.G
                                    # .D.R.V.T.M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.K.A.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V
                                    # .P.V.R.F.S.G.S.G.S.G.T.D.Y.T.F.T.I.S.S.L.Q.P.E.D.I.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G
                                    # .G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y
                                    # .P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L
                                    # .S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE3,PEPTI
                                    # DE3,371:R3-429:R3|PEPTIDE2,PEPTIDE1,224:R3-213:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PE
                                    # PTIDE2,PEPTIDE2,148:R3-204:R3|PEPTIDE1,PEPTIDE1,133:R3-193:R3|PEPTIDE1,PEPTIDE1,23
                                    # :R3-87:R3|PEPTIDE4,PEPTIDE4,23:R3-87:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE3,P
                                    # EPTIDE3,148:R3-204:R3|PEPTIDE4,PEPTIDE4,133:R3-193:R3|PEPTIDE2,PEPTIDE2,265:R3-325
                                    # :R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE4,224:R3-213:R3|PEPTIDE2,PEPTIDE
                                    # 2,371:R3-429:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3$$$
                                    # ' , 'PEPTIDE1{E.I.V.L.T.Q.S.P.A.T.L.S.L.S.P.G.E.R.A.T.L.S.C.S.A.S.I.S.V.S.Y.M.Y.W.
                                    # Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.D.M.S.N.L.A.S.G.I.P.A.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.
                                    # S.L.E.P.E.D.F.A.V.Y.Y.C.M.Q.W.S.G.Y.P.Y.T.F.G.G.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.
                                    # F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.
                                    # S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.
                                    # G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.
                                    # C.A.A.S.G.F.T.F.S.P.F.A.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.K.I.S.P.G.G.S.W.T.Y.Y.S.D.
                                    # T.V.T.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.Q.L.W.G.Y.
                                    # Y.A.L.D.I.W.G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.
                                    # G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.
                                    # S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.
                                    # T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.
                                    # V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.
                                    # T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.
                                    # V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.
                                    # N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.
                                    # E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.
                                    # R.L.S.C.A.A.S.G.F.T.F.S.P.F.A.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.K.I.S.P.G.G.S.W.T.Y.
                                    # Y.S.D.T.V.T.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.Q.L.
                                    # W.G.Y.Y.A.L.D.I.W.G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.
                                    # A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.
                                    # S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.
                                    # K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.
                                    # V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.
                                    # S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.
                                    # E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.
                                    # Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.
                                    # V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{E.I.V.L.T.Q.S.P.A.T.L.S.L.S.P.
                                    # G.E.R.A.T.L.S.C.S.A.S.I.S.V.S.Y.M.Y.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.D.M.S.N.L.A.S.G.
                                    # I.P.A.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.E.P.E.D.F.A.V.Y.Y.C.M.Q.W.S.G.Y.P.Y.T.F.
                                    # G.G.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.
                                    # Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.
                                    # L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE1,PEPT
                                    # IDE1,23:R3-87:R3|PEPTIDE3,PEPTIDE4,222:R3-213:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEP
                                    # TIDE1,PEPTIDE1,133:R3-193:R3|PEPTIDE4,PEPTIDE4,133:R3-193:R3|PEPTIDE2,PEPTIDE2,146
                                    # :R3-202:R3|PEPTIDE3,PEPTIDE3,369:R3-427:R3|PEPTIDE2,PEPTIDE1,222:R3-213:R3|PEPTIDE
                                    # 3,PEPTIDE3,146:R3-202:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE3,PEPTIDE3,263:R3-32
                                    # 3:R3|PEPTIDE2,PEPTIDE2,263:R3-323:R3|PEPTIDE2,PEPTIDE3,228:R3-228:R3|PEPTIDE4,PEPT
                                    # IDE4,23:R3-87:R3|PEPTIDE2,PEPTIDE2,369:R3-427:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3$$
                                    # $'
                                    'indication_class': 'TEXT',
                                    # EXAMPLES:
                                    # 'Radioactive Agent' , 'Pharmaceutic Aid (surfactant)' , 'Contact Lens Material (hy
                                    # drophilic)' , 'Pharmaceutic Aid (viscosity-increasing agent)' , 'Radioactive Agent
                                    # ' , 'Pharmaceutic Aid (ointment base, absorbent)' , 'Pharmaceutic Aid (excipient)'
                                    #  , 'Contact Lens Material (hydrophilic)' , 'Immunizing Agent (passive)' , 'Pharmac
                                    # eutic Aid (surfactant); Pharmaceutic Aid (emulsifying agent)'
                                    'molecule_chembl_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'CHEMBL2219777' , 'CHEMBL2109114' , 'CHEMBL2108846' , 'CHEMBL2108245' , 'CHEMBL210
                                    # 9012' , 'CHEMBL2107953' , 'CHEMBL2108392' , 'CHEMBL3545431' , 'CHEMBL2108213' , 'C
                                    # HEMBL3990010'
                                    'molecule_properties': 
                                    {
                                        'properties': 
                                        {
                                            'alogp': 'NUMERIC',
                                            # EXAMPLES:
                                            # '3.97' , '3.84' , '6.44' , '4.99' , '3.20' , '4.98' , '4.77' , '2.25' , '3
                                            # .56' , '5.17'
                                            'aromatic_rings': 'NUMERIC',
                                            # EXAMPLES:
                                            # '2' , '2' , '0' , '2' , '2' , '3' , '0' , '2' , '3' , '3'
                                            'cx_logd': 'NUMERIC',
                                            # EXAMPLES:
                                            # '-0.64' , '3.77' , '4.47' , '3.50' , '0.34' , '2.22' , '2.14' , '1.83' , '
                                            # 3.16' , '3.37'
                                            'cx_logp': 'NUMERIC',
                                            # EXAMPLES:
                                            # '-0.65' , '3.77' , '6.95' , '4.22' , '2.61' , '4.23' , '5.06' , '2.54' , '
                                            # 3.16' , '5.28'
                                            'cx_most_apka': 'NUMERIC',
                                            # EXAMPLES:
                                            # '11.05' , '9.98' , '4.89' , '4.36' , '11.50' , '9.39' , '11.85' , '4.27' ,
                                            #  '2.70' , '3.24'
                                            'cx_most_bpka': 'NUMERIC',
                                            # EXAMPLES:
                                            # '8.03' , '9.40' , '9.42' , '8.02' , '4.94' , '9.31' , '10.90' , '8.79' , '
                                            # 9.36' , '9.70'
                                            'full_molformula': 'TEXT',
                                            # EXAMPLES:
                                            # 'Sm' , 'C8H9AsBiNO6' , 'C18H14CuO7' , 'C6H12N2Na5O12P4Sm' , 'C13H25N4O3Tc'
                                            #  , 'C10H12FeN2NaO8' , 'C16H26GdN5O8' , 'C12H22N2O5S2Tc' , 'C18H12CrN3O6' ,
                                            #  'CFeO3'
                                            'full_mwt': 'NUMERIC',
                                            # EXAMPLES:
                                            # '150.36' , '499.06' , '405.85' , '693.37' , '383.37' , '367.05' , '573.66'
                                            #  , '436.45' , '418.31' , '115.85'
                                            'hba': 'NUMERIC',
                                            # EXAMPLES:
                                            # '3' , '1' , '1' , '5' , '3' , '4' , '2' , '5' , '5' , '3'
                                            'hba_lipinski': 'NUMERIC',
                                            # EXAMPLES:
                                            # '4' , '2' , '2' , '6' , '3' , '4' , '3' , '6' , '6' , '3'
                                            'hbd': 'NUMERIC',
                                            # EXAMPLES:
                                            # '1' , '2' , '1' , '0' , '1' , '0' , '2' , '1' , '1' , '0'
                                            'hbd_lipinski': 'NUMERIC',
                                            # EXAMPLES:
                                            # '1' , '2' , '1' , '0' , '1' , '0' , '2' , '1' , '1' , '0'
                                            'heavy_atoms': 'NUMERIC',
                                            # EXAMPLES:
                                            # '30' , '16' , '22' , '35' , '18' , '29' , '21' , '28' , '28' , '26'
                                            'molecular_species': 'TEXT',
                                            # EXAMPLES:
                                            # 'NEUTRAL' , 'NEUTRAL' , 'ACID' , 'NEUTRAL' , 'BASE' , 'BASE' , 'ACID' , 'N
                                            # EUTRAL' , 'NEUTRAL' , 'BASE'
                                            'mw_freebase': 'NUMERIC',
                                            # EXAMPLES:
                                            # '150.36' , '499.06' , '405.85' , '693.37' , '383.37' , '367.05' , '573.66'
                                            #  , '436.45' , '418.31' , '115.85'
                                            'mw_monoisotopic': 'NUMERIC',
                                            # EXAMPLES:
                                            # '151.9197' , '498.9450' , '405.0036' , '694.8026' , '382.0990' , '366.9841
                                            # ' , '574.1022' , '435.0034' , '418.0131' , '115.9197'
                                            'num_lipinski_ro5_violations': 'NUMERIC',
                                            # EXAMPLES:
                                            # '0' , '0' , '1' , '0' , '0' , '0' , '0' , '0' , '0' , '1'
                                            'num_ro5_violations': 'NUMERIC',
                                            # EXAMPLES:
                                            # '0' , '0' , '1' , '0' , '0' , '0' , '0' , '0' , '0' , '1'
                                            'psa': 'NUMERIC',
                                            # EXAMPLES:
                                            # '46.53' , '31.58' , '37.30' , '54.37' , '28.16' , '42.16' , '57.53' , '54.
                                            # 04' , '79.94' , '17.40'
                                            'qed_weighted': 'NUMERIC',
                                            # EXAMPLES:
                                            # '0.55' , '0.76' , '0.28' , '0.56' , '0.66' , '0.60' , '0.51' , '0.89' , '0
                                            # .76' , '0.56'
                                            'ro3_pass': 'TEXT',
                                            # EXAMPLES:
                                            # 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
                                            'rtb': 'NUMERIC',
                                            # EXAMPLES:
                                            # '7' , '2' , '15' , '7' , '5' , '6' , '12' , '3' , '4' , '8'
                                        }
                                    },
                                    'molecule_structures': 
                                    {
                                        'properties': 
                                        {
                                            'canonical_smiles': 'TEXT',
                                            # EXAMPLES:
                                            # 'C[N@@+]1(CCCF)[C@H]2CC[C@@H]1C[C@H](OC(=O)C(O)(c1ccccc1)c1ccccc1)C2' , 'C
                                            # c1cccc([C@H](C)c2c[nH]c(=S)[nH]2)c1C' , 'CCCCC/C=C\C/C=C\C/C=C\CCCCCCC(=O)
                                            # O' , 'CCOc1cc2c(cc1OC)C(c1ccc(C(=O)N(C(C)C)C(C)C)cc1)=N[C@@H]1CCN(C)C[C@H]
                                            # 21' , 'CN(C)CCCNc1ccnc2cc(I)ccc12' , 'Cc1nnc(C(CCN2CC3CCC2CC3)(c2ccccc2)c2
                                            # ccccc2)o1' , 'CCCCCCC1CCC(O)C1CCCCCCC(=O)O' , 'O=C1NCN(c2ccccc2)C12CCN(CC1
                                            # COc3ccccc3O1)CC2' , 'CC(C)OC(=O)N[C@H]1Cc2c(n(Cc3ccccn3)c3ccc(C#N)cc23)C1'
                                            #  , 'CCN(CC)CCOc1ccccc1-n1c(C)ccc1-c1ccccc1'
                                            'standard_inchi': 'TEXT',
                                            # EXAMPLES:
                                            # 'InChI=1S/C25H31FNO3/c1-27(16-8-15-26)21-13-14-22(27)18-23(17-21)30-24(28)
                                            # 25(29,19-9-4-2-5-10-19)20-11-6-3-7-12-20/h2-7,9-12,21-23,29H,8,13-18H2,1H3
                                            # /q+1/t21-,22?,23+,27+/m1/s1' , 'InChI=1S/C13H16N2S/c1-8-5-4-6-11(9(8)2)10(
                                            # 3)12-7-14-13(16)15-12/h4-7,10H,1-3H3,(H2,14,15,16)/t10-/m0/s1' , 'InChI=1S
                                            # /C20H34O2/c1-2-3-4-5-6-7-8-9-10-11-12-13-14-15-16-17-18-19-20(21)22/h6-7,9
                                            # -10,12-13H,2-5,8,11,14-19H2,1H3,(H,21,22)/b7-6-,10-9-,13-12-' , 'InChI=1S/
                                            # C29H39N3O3/c1-8-35-27-15-22-23(16-26(27)34-7)28(30-25-13-14-31(6)17-24(22)
                                            # 25)20-9-11-21(12-10-20)29(33)32(18(2)3)19(4)5/h9-12,15-16,18-19,24-25H,8,1
                                            # 3-14,17H2,1-7H3/t24-,25-/m1/s1' , 'InChI=1S/C14H18IN3/c1-18(2)9-3-7-16-13-
                                            # 6-8-17-14-10-11(15)4-5-12(13)14/h4-6,8,10H,3,7,9H2,1-2H3,(H,16,17)' , 'InC
                                            # hI=1S/C25H29N3O/c1-19-26-27-24(29-19)25(21-8-4-2-5-9-21,22-10-6-3-7-11-22)
                                            # 16-17-28-18-20-12-14-23(28)15-13-20/h2-11,20,23H,12-18H2,1H3' , 'InChI=1S/
                                            # C18H34O3/c1-2-3-4-7-10-15-13-14-17(19)16(15)11-8-5-6-9-12-18(20)21/h15-17,
                                            # 19H,2-14H2,1H3,(H,20,21)' , 'InChI=1S/C22H25N3O3/c26-21-22(25(16-23-21)17-
                                            # 6-2-1-3-7-17)10-12-24(13-11-22)14-18-15-27-19-8-4-5-9-20(19)28-18/h1-9,18H
                                            # ,10-16H2,(H,23,26)' , 'InChI=1S/C22H22N4O2/c1-14(2)28-22(27)25-17-10-19-18
                                            # -9-15(12-23)6-7-20(18)26(21(19)11-17)13-16-5-3-4-8-24-16/h3-9,14,17H,10-11
                                            # ,13H2,1-2H3,(H,25,27)/t17-/m0/s1' , 'InChI=1S/C23H28N2O/c1-4-24(5-2)17-18-
                                            # 26-23-14-10-9-13-22(23)25-19(3)15-16-21(25)20-11-7-6-8-12-20/h6-16H,4-5,17
                                            # -18H2,1-3H3'
                                            'standard_inchi_key': 'TEXT',
                                            # EXAMPLES:
                                            # 'ARMJUIHNEFCOOI-ABIOMGQESA-N' , 'WQXVKEDUCPMRRI-JTQLQIEISA-N' , 'HOBAELRKJ
                                            # CKHQD-QNEBEIHSSA-N' , 'CVDXFPBVOIERBH-JWQCQUIFSA-N' , 'XKUMTLINEKGTOG-UHFF
                                            # FAOYSA-N' , 'CVOCKGAVXLCEGM-UHFFFAOYSA-N' , 'NMAOJFAMEOVURT-UHFFFAOYSA-N' 
                                            # , 'JVGBTTIJPBFLTE-UHFFFAOYSA-N' , 'IHIWYQYVBNODSV-KRWDZBQOSA-N' , 'DQIUUHJ
                                            # EYNMMLD-UHFFFAOYSA-N'
                                        }
                                    },
                                    'molecule_synonyms': 
                                    {
                                        'properties': 
                                        {
                                            'molecule_synonym': 'TEXT',
                                            # EXAMPLES:
                                            # '85KR' , 'Boroglycerin' , 'Carbomer Interpolymer' , 'Creosote' , 'Certopar
                                            # in Sodium' , 'Polyenephosphatidyl Choline' , 'Horse Chestnut, Powdered' , 
                                            # 'HMN-214' , 'Adekalant' , 'Frunevetmab'
                                            'syn_type': 'TEXT',
                                            # EXAMPLES:
                                            # 'OTHER' , 'NATIONAL_FORMULARY' , 'NATIONAL_FORMULARY' , 'ATC' , 'BAN' , 'J
                                            # AN' , 'NATIONAL_FORMULARY' , 'OTHER' , 'INN' , 'USAN'
                                            'synonyms': 'TEXT',
                                            # EXAMPLES:
                                            # '85KR' , 'BOROGLYCERIN' , 'CARBOMER INTERPOLYMER' , 'CREOSOTE' , 'CERTOPAR
                                            # IN SODIUM' , 'POLYENEPHOSPHATIDYL CHOLINE' , 'HORSE CHESTNUT, POWDERED' , 
                                            # 'HMN-214' , 'ADEKALANT' , 'FRUNEVETMAB'
                                        }
                                    },
                                    'ob_patent': 'NUMERIC',
                                    # EXAMPLES:
                                    # '9255261' , '7341744' , '7381428' , '8664215' , '6552065' , '7291132' , '6444226' 
                                    # , '6409990' , '5753706' , '6056941'
                                    'oral': 'BOOLEAN',
                                    # EXAMPLES:
                                    # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'F
                                    # alse' , 'False'
                                    'parenteral': 'BOOLEAN',
                                    # EXAMPLES:
                                    # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'F
                                    # alse' , 'False'
                                    'prodrug': 'BOOLEAN',
                                    # EXAMPLES:
                                    # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'True' , 'Fa
                                    # lse' , 'False'
                                    'research_codes': 'TEXT',
                                    # EXAMPLES:
                                    # 'IVX-214' , 'NV-02' , 'PRS-343' , 'Oncolysin M' , 'M-402' , 'SC-70935' , 'E-52' , 
                                    # 'PF-06647020' , 'J591' , 'M-9346A'
                                    'rule_of_five': 'BOOLEAN',
                                    # EXAMPLES:
                                    # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'F
                                    # alse' , 'False'
                                    'sc_patent': 'TEXT',
                                    # EXAMPLES:
                                    # 'US-9255261-B2' , 'US-7341744-B1' , 'US-7381428-B2' , 'US-8664215-B2' , 'US-655206
                                    # 5-B2' , 'US-7291132-B2' , 'US-6444226-B1' , 'US-6409990-B1' , 'US-5753706-A' , 'US
                                    # -6056941-A'
                                    'synonyms': 'TEXT',
                                    # EXAMPLES:
                                    # 'Krypton Clathrate Kr 85 (USAN)' , 'Boroglycerin (NF)' , 'Carbomer Interpolymer (N
                                    # F)' , 'Creosote (JAN)' , 'Certoparin Sodium (BAN, INN)' , 'Polyenephosphatidyl Cho
                                    # line (JAN)' , 'Horse Chestnut, Powdered (NF)' , 'HMN-214' , 'Adekalant (INN)' , 'F
                                    # runevetmab (USAN)'
                                    'topical': 'BOOLEAN',
                                    # EXAMPLES:
                                    # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'F
                                    # alse' , 'False'
                                    'usan_stem': 'TEXT',
                                    # EXAMPLES:
                                    # '-mer' , '-parin' , '-kalant' , '-mab' , '-parin' , '-anib' , '-stim' , '-filcon' 
                                    # , '-vin-' , '-poetin'
                                    'usan_stem_definition': 'TEXT',
                                    # EXAMPLES:
                                    # 'polymers' , 'heparin derivatives and low molecular weight (or depolymerized) hepa
                                    # rins' , 'potassium channel antagonists' , 'monoclonal antibodies: veterinary use' 
                                    # , 'heparin derivatives and low molecular weight (or depolymerized) heparins' , 'an
                                    # giogenesis inhibitors' , 'colony-stimulating factors: conjugates of two different 
                                    # types of colony-stimulating factors' , 'hydrophilic contact lens materials' , 'vin
                                    # ca alkaloids' , 'erythropoietins'
                                    'usan_stem_substem': 'TEXT',
                                    # EXAMPLES:
                                    # '-mer(-mer)' , '-parin(-parin)' , '-kalant(-kalant)' , '-mab(-mab (-vetmab))' , '-
                                    # parin(-parin)' , '-anib(-anib)' , '-stim(-stim (-distim))' , '-filcon(-filcon)' , 
                                    # '-vin-(-vin-)' , '-poetin(-poetin)'
                                    'usan_year': 'NUMERIC',
                                    # EXAMPLES:
                                    # '1963' , '2016' , '2014' , '1998' , '1983' , '1987' , '1985' , '2016' , '2015' , '
                                    # 2004'
                                    'withdrawn_class': 'TEXT',
                                    # EXAMPLES:
                                    # 'Hepatotoxicity' , 'Hepatotoxicity' , 'Carcinogenicity; Gastrotoxicity' , 'Cardiot
                                    # oxicity' , 'Respiratory toxicity' , 'Neurotoxicity' , 'Carcinogenicity' , 'Hepatot
                                    # oxicity' , 'Cardiotoxicity' , 'Cardiotoxicity; Respiratory toxicity'
                                    'withdrawn_country': 'TEXT',
                                    # EXAMPLES:
                                    # 'European Union' , 'United States' , 'France' , 'Australia' , 'United States' , 'U
                                    # nited Kingdom; Spain; Germany' , 'Germany' , 'United Kingdom; United States' , 'Un
                                    # ited States' , 'United States'
                                    'withdrawn_reason': 'TEXT',
                                    # EXAMPLES:
                                    # 'Lack of eficacy' , 'Increased mortality' , 'Hepatotoxicity' , 'Hepatotoxicity' , 
                                    # 'Animal Carcinogenicity (rodent); Gastrointestinal Toxicity' , 'Multi-Organ Toxici
                                    # ties' , 'Ventricular arrhythmias; Cardiotoxicity and Excess Mortality' , 'Fatal br
                                    # onchospasm' , 'Progressive multifocal leukoencephalopathy' , 'Animal carcinogenici
                                    # ty (dogs)'
                                    'withdrawn_year': 'NUMERIC',
                                    # EXAMPLES:
                                    # '2011' , '2007' , '1984' , '1971' , '1983' , '1986' , '1991' , '2001' , '2009' , '
                                    # 1970'
                                }
                            },
                            'is_drug': 'BOOLEAN',
                            # EXAMPLES:
                            # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                        }
                    },
                    'drug_indications': 
                    {
                        'properties': 
                        {
                            '_metadata': 
                            {
                                'properties': 
                                {
                                    'all_molecule_chembl_ids': 'TEXT',
                                    # EXAMPLES:
                                    # 'CHEMBL2107366' , 'CHEMBL465183' , 'CHEMBL2103744' , 'CHEMBL3542265' , 'CHEMBL2109
                                    # 548' , 'CHEMBL2109449' , 'CHEMBL2109065' , 'CHEMBL3039543' , 'CHEMBL2107960' , 'CH
                                    # EMBL3544907'
                                }
                            },
                            'drugind_id': 'NUMERIC',
                            # EXAMPLES:
                            # '110828' , '113938' , '23535' , '54093' , '111498' , '67658' , '64747' , '112350' , '47333
                            # ' , '65413'
                            'efo_id': 'TEXT',
                            # EXAMPLES:
                            # 'EFO:1000869' , 'EFO:0000274' , 'EFO:0003843' , 'EFO:0004234' , 'EFO:0001663' , 'EFO:00026
                            # 90' , 'HP:0100806' , 'EFO:0009441' , 'EFO:0000685' , 'EFO:0001075'
                            'efo_term': 'TEXT',
                            # EXAMPLES:
                            # 'chronic interstitial cystitis' , 'atopic eczema' , 'pain' , 'erectile dysfunction' , 'pro
                            # state carcinoma' , 'systemic lupus erythematosus' , 'sepsis' , 'Waldenstrom macroglobuline
                            # mia' , 'rheumatoid arthritis' , 'ovarian carcinoma'
                            'indication_refs': 
                            {
                                'properties': 
                                {
                                    'ref_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                    'ref_type': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                    'ref_url': 'TEXT',
                                    # EXAMPLES:
                                    # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , '
                                    # None'
                                }
                            },
                            'max_phase_for_ind': 'NUMERIC',
                            # EXAMPLES:
                            # '2' , '2' , '4' , '2' , '1' , '1' , '3' , '1' , '2' , '1'
                            'mesh_heading': 'TEXT',
                            # EXAMPLES:
                            # 'Cystitis, Interstitial' , 'Dermatitis, Atopic' , 'Pain' , 'Erectile Dysfunction' , 'Prost
                            # atic Neoplasms' , 'Lupus Erythematosus, Systemic' , 'Sepsis' , 'Waldenstrom Macroglobuline
                            # mia' , 'Arthritis, Rheumatoid' , 'Ovarian Neoplasms'
                            'mesh_id': 'TEXT',
                            # EXAMPLES:
                            # 'D018856' , 'D003876' , 'D010146' , 'D007172' , 'D011471' , 'D008180' , 'D018805' , 'D0082
                            # 58' , 'D001172' , 'D010051'
                            'molecule_chembl_id': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL2107366' , 'CHEMBL465183' , 'CHEMBL2103744' , 'CHEMBL3542265' , 'CHEMBL2109548' , '
                            # CHEMBL2109449' , 'CHEMBL2109065' , 'CHEMBL3039543' , 'CHEMBL2107960' , 'CHEMBL3544907'
                            'parent_molecule_chembl_id': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL2107366' , 'CHEMBL465183' , 'CHEMBL70' , 'CHEMBL3542265' , 'CHEMBL2109548' , 'CHEMB
                            # L2109449' , 'CHEMBL2109065' , 'CHEMBL3039543' , 'CHEMBL2107960' , 'CHEMBL3544907'
                        }
                    },
                    'es_completion': 'TEXT',
                    # EXAMPLES:
                    # '{'weight': 90, 'input': 'C35H54N6O3'}' , '{'weight': 30, 'input': 'YGSZOLBJQDRZDM-UHFFFAOYSA-N'}'
                    #  , '{'weight': 10, 'input': 'CHEMBL2146236'}' , '{'weight': 90, 'input': 'C19H19ClO5'}' , '{'weigh
                    # t': 30, 'input': 'CCCCCCCCCCCCC/C(=N\\O)c1cc(-c2cccc(O)c2)ccc1O'}' , '{'weight': 90, 'input': 'C14
                    # H27ClN2O3'}' , '{'weight': 10, 'input': 'CHEMBL4249872'}' , '{'weight': 30, 'input': 'InChI=1S/C23
                    # H21ClO6S/c1-2-29-19-8-11-21(22(24)13-19)17-5-3-4-16(12-17)14-30-18-6-9-20(10-7-18)31(27,28)15-23(2
                    # 5)26/h3-13H,2,14-15H2,1H3,(H,25,26)'}' , '{'weight': 90, 'input': 'C17H11F6N5O'}' , '{'weight': 10
                    # , 'input': 'CHEMBL4164768'}'
                    'hierarchy': 
                    {
                        'properties': 
                        {
                            'all_family': 
                            {
                                'properties': 
                                {
                                    'chembl_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'CHEMBL4285456' , 'CHEMBL4204510' , 'CHEMBL2146236' , 'CHEMBL4291932' , 'CHEMBL428
                                    # 3165' , 'CHEMBL3139277' , 'CHEMBL4249872' , 'CHEMBL4204628' , 'CHEMBL4278745' , 'C
                                    # HEMBL4164768'
                                    'inchi': 'TEXT',
                                    # EXAMPLES:
                                    # 'InChI=1S/C35H54N6O3/c1-27(2)11-9-12-28(3)13-10-14-29(4)17-20-38-24-34(43)40(21-8-
                                    # 7-19-36)26-35(44)41(25-33(37)42)22-18-30-23-39-32-16-6-5-15-31(30)32/h5-6,11,13,15
                                    # -17,23,38-39H,7-10,12,14,18-22,24-26,36H2,1-4H3,(H2,37,42)/b28-13+,29-17+' , 'InCh
                                    # I=1S/C20H27NO2S/c1-16-6-8-18(9-7-16)23-14-17(22)13-21-15-20(10-2-3-11-20)19-5-4-12
                                    # -24-19/h4-9,12,17,21-22H,2-3,10-11,13-15H2,1H3' , 'InChI=1S/C19H19ClO5/c20-14-3-1-
                                    # 4-15(10-14)23-7-2-8-24-16-5-6-17-13(9-19(21)22)12-25-18(17)11-16/h1,3-6,10-11,13H,
                                    # 2,7-9,12H2,(H,21,22)/t13-/m1/s1' , 'InChI=1S/C26H37NO3/c1-2-3-4-5-6-7-8-9-10-11-12
                                    # -16-25(27-30)24-20-22(17-18-26(24)29)21-14-13-15-23(28)19-21/h13-15,17-20,28-30H,2
                                    # -12,16H2,1H3/b27-25+' , 'InChI=1S/C14H26N2O3/c1-14(2,3)13(18)16-9-19-12(17)11-6-4-
                                    # 10(8-15)5-7-11/h10-11H,4-9,15H2,1-3H3,(H,16,18)/t10-,11-' , 'InChI=1S/C20H26N8O2/c
                                    # 1-3-16(29)26-6-4-5-14(10-26)11-28-20-17(19(21)22-13-23-20)18(25-28)15-9-24-27(12-1
                                    # 5)7-8-30-2/h3,9,12-14H,1,4-8,10-11H2,2H3,(H2,21,22,23)' , 'InChI=1S/C23H21ClO6S/c1
                                    # -2-29-19-8-11-21(22(24)13-19)17-5-3-4-16(12-17)14-30-18-6-9-20(10-7-18)31(27,28)15
                                    # -23(25)26/h3-13H,2,14-15H2,1H3,(H,25,26)' , 'InChI=1S/C17H11F6N5O/c1-24-15-26-16(2
                                    # 5-6-7-3-2-4-8(18)5-7)28-17(27-15)29-14-12(22)10(20)9(19)11(21)13(14)23/h2-5H,6H2,1
                                    # H3,(H2,24,25,26,27,28)' , 'InChI=1S/C20H20N4O3/c1-12-5-7-13(8-6-12)15-11-18-21-22-
                                    # 20(24(18)23-15)14-9-16(25-2)19(27-4)17(10-14)26-3/h5-11,21H,1-4H3' , 'InChI=1S/C16
                                    # H12ClN3O5S/c17-12-3-7-15(8-4-12)26(23,24)18-10-14-9-16(19-25-14)11-1-5-13(6-2-11)2
                                    # 0(21)22/h1-9,18H,10H2'
                                    'inchi_connectivity_layer': 'TEXT',
                                    # EXAMPLES:
                                    # 'ARZCFGFAMDMEPO' , 'YGSZOLBJQDRZDM' , 'KNTFJPOCGUBOIF' , 'XSYOYDLEVZEUOY' , 'WXKAC
                                    # KRBIWSPTI' , 'ZEAVIMCJNXJZPV' , 'DLOCFEFHMHCCIV' , 'IQISVMOHBQJIPD' , 'CWYUAJHFEZA
                                    # LNJ' , 'IPRVCBYYTLAIRI'
                                    'inchi_key': 'TEXT',
                                    # EXAMPLES:
                                    # 'ARZCFGFAMDMEPO-OUADVBRVSA-N' , 'YGSZOLBJQDRZDM-UHFFFAOYSA-N' , 'KNTFJPOCGUBOIF-CY
                                    # BMUJFWSA-N' , 'XSYOYDLEVZEUOY-IMVLJIQESA-N' , 'WXKACKRBIWSPTI-XYPYZODXSA-N' , 'ZEA
                                    # VIMCJNXJZPV-UHFFFAOYSA-N' , 'DLOCFEFHMHCCIV-UHFFFAOYSA-N' , 'IQISVMOHBQJIPD-UHFFFA
                                    # OYSA-N' , 'CWYUAJHFEZALNJ-UHFFFAOYSA-N' , 'IPRVCBYYTLAIRI-UHFFFAOYSA-N'
                                }
                            },
                            'children': 
                            {
                                'properties': 
                                {
                                    'chembl_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'CHEMBL4239680' , 'CHEMBL1980575' , 'CHEMBL4210088' , 'CHEMBL4284388' , 'CHEMBL274
                                    # 133' , 'CHEMBL4172088' , 'CHEMBL3884716' , 'CHEMBL3323283' , 'CHEMBL4290318' , 'CH
                                    # EMBL4290776'
                                    'sources': 
                                    {
                                        'properties': 
                                        {
                                            'src_description': 'TEXT',
                                            # EXAMPLES:
                                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'N
                                            # one' , 'None'
                                            'src_id': 'TEXT',
                                            # EXAMPLES:
                                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'N
                                            # one' , 'None'
                                            'src_short_name': 'TEXT',
                                            # EXAMPLES:
                                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'N
                                            # one' , 'None'
                                        }
                                    },
                                    'synonyms': 
                                    {
                                        'properties': 
                                        {
                                            'molecule_synonym': 'TEXT',
                                            # EXAMPLES:
                                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'N
                                            # one' , 'None'
                                            'syn_type': 'TEXT',
                                            # EXAMPLES:
                                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'N
                                            # one' , 'None'
                                            'synonyms': 'TEXT',
                                            # EXAMPLES:
                                            # 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'None' , 'N
                                            # one' , 'None'
                                        }
                                    }
                                }
                            },
                            'family_inchi_connectivity_layer': 'TEXT',
                            # EXAMPLES:
                            # 'ARZCFGFAMDMEPO' , 'YGSZOLBJQDRZDM' , 'KNTFJPOCGUBOIF' , 'XSYOYDLEVZEUOY' , 'WXKACKRBIWSPT
                            # I' , 'ZEAVIMCJNXJZPV' , 'DLOCFEFHMHCCIV' , 'IQISVMOHBQJIPD' , 'CWYUAJHFEZALNJ' , 'IPRVCBYY
                            # TLAIRI'
                            'is_approved_drug': 'BOOLEAN',
                            # EXAMPLES:
                            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 
                            # 'False'
                            'is_usan': 'BOOLEAN',
                            # EXAMPLES:
                            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 
                            # 'False'
                            'parent': 
                            {
                                'properties': 
                                {
                                    'chembl_id': 'TEXT',
                                    # EXAMPLES:
                                    # 'CHEMBL3139277' , 'CHEMBL497724' , 'CHEMBL4300436' , 'CHEMBL4302298' , 'CHEMBL1624
                                    # 566' , 'CHEMBL4300421' , 'CHEMBL3991471' , 'CHEMBL4302551' , 'CHEMBL3547542' , 'CH
                                    # EMBL4300499'
                                    'sources': 
                                    {
                                        'properties': 
                                        {
                                            'src_description': 'TEXT',
                                            # EXAMPLES:
                                            # 'Scientific Literature' , 'Scientific Literature' , 'Scientific Literature
                                            # ' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Litera
                                            # ture' , 'Scientific Literature' , 'Scientific Literature' , 'Scientific Li
                                            # terature' , 'Scientific Literature'
                                            'src_id': 'NUMERIC',
                                            # EXAMPLES:
                                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                                            'src_short_name': 'TEXT',
                                            # EXAMPLES:
                                            # 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' ,
                                            #  'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE' , 'LITERATURE'
                                        }
                                    },
                                    'synonyms': 
                                    {
                                        'properties': 
                                        {
                                            'molecule_synonym': 'TEXT',
                                            # EXAMPLES:
                                            # '(-)-PF-00446687' , 'NSC-664238' , 'Manzamine J N-Oxide' , 'Cobalt (II) su
                                            # lfate' , 'Technetium sestamibi' , 'Bms-955176' , 'Erivedge' , 'Doxycycline
                                            # ' , 'N-Methylpyridylylporphyrin' , 'Behepan'
                                            'syn_type': 'TEXT',
                                            # EXAMPLES:
                                            # 'RESEARCH_CODE' , 'RESEARCH_CODE' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' 
                                            # , 'TRADE_NAME' , 'ATC' , 'OTHER' , 'TRADE_NAME'
                                            'synonyms': 'TEXT',
                                            # EXAMPLES:
                                            # '(-)-PF-00446687' , 'NSC-664238' , 'Manzamine J N-Oxide' , 'Cobalt (II) su
                                            # lfate' , 'TECHNETIUM SESTAMIBI' , 'BMS-955176' , 'ERIVEDGE' , 'DOXYCYCLINE
                                            # ' , 'N-Methylpyridylylporphyrin' , 'BEHEPAN'
                                        }
                                    }
                                }
                            }
                        }
                    },
                    'related_activities': 
                    {
                        'properties': 
                        {
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '3' , '3' , '57' , '10' , '1' , '3' , '9' , '4' , '2' , '3'
                        }
                    },
                    'related_assays': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL4269242 CHEMBL4269241 CHEMBL4269243' , 'CHEMBL4186236 CHEMBL4186237 CHEMBL4186239' 
                            # , 'CHEMBL1963868 CHEMBL1964012 CHEMBL1964047 CHEMBL1963874 CHEMBL1963887 CHEMBL1963854 CHE
                            # MBL1964018 CHEMBL1963866 CHEMBL1964062 CHEMBL1964087 CHEMBL1964043 CHEMBL1963880 CHEMBL196
                            # 4006 CHEMBL1963985 CHEMBL1963961 CHEMBL1964009 CHEMBL1963911 CHEMBL1963991 CHEMBL1963954 C
                            # HEMBL1964088 CHEMBL1964077 CHEMBL1964034 CHEMBL1964021 CHEMBL1964092 CHEMBL1964059 CHEMBL1
                            # 964075 CHEMBL1963963 CHEMBL1963960 CHEMBL1963990 CHEMBL1964048 CHEMBL1964091 CHEMBL1964074
                            #  CHEMBL1964014 CHEMBL1964004 CHEMBL1963876 CHEMBL1963889 CHEMBL1963860 CHEMBL1964037 CHEMB
                            # L1964025 CHEMBL1964007 CHEMBL1963935 CHEMBL1964049 CHEMBL1964040 CHEMBL1963929 CHEMBL19640
                            # 85 CHEMBL1963953 CHEMBL1963901 CHEMBL1963981 CHEMBL1963994 CHEMBL1963895 CHEMBL1963903 CHE
                            # MBL1963922 CHEMBL1963848 CHEMBL1963989 CHEMBL1964072 CHEMBL1964030 CHEMBL1963844' , 'CHEMB
                            # L4269157 CHEMBL4269160 CHEMBL4269161 CHEMBL4269162 CHEMBL4269164 CHEMBL4269158 CHEMBL42691
                            # 67 CHEMBL4269163 CHEMBL4269169 CHEMBL4269159' , 'CHEMBL4275246' , 'CHEMBL629172 CHEMBL6379
                            # 66 CHEMBL636792' , 'CHEMBL4236385 CHEMBL4236388 CHEMBL4236382 CHEMBL4236387 CHEMBL4236386 
                            # CHEMBL4236383 CHEMBL4236389 CHEMBL4236384 CHEMBL4236390' , 'CHEMBL4192359 CHEMBL4192358 CH
                            # EMBL4192357 CHEMBL4192356' , 'CHEMBL4272317 CHEMBL4272319' , 'CHEMBL4132595 CHEMBL4132596 
                            # CHEMBL4132597'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '3' , '3' , '57' , '10' , '1' , '3' , '9' , '4' , '2' , '3'
                        }
                    },
                    'related_cell_lines': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3307718' , '' , 'CHEMBL3307677 CHEMBL3307580 CHEMBL3308494 CHEMBL3307591 CHEMBL3307
                            # 756 CHEMBL3307710 CHEMBL3307732 CHEMBL3308487 CHEMBL3307633 CHEMBL3308074 CHEMBL3307522 CH
                            # EMBL3307743 CHEMBL3307535 CHEMBL3307750 CHEMBL3307499 CHEMBL3307945 CHEMBL3308091 CHEMBL33
                            # 07738 CHEMBL3307744 CHEMBL3307651 CHEMBL3307670 CHEMBL3307537 CHEMBL3307660 CHEMBL3307734 
                            # CHEMBL3307517 CHEMBL3308348 CHEMBL3307506 CHEMBL3307565 CHEMBL3307502 CHEMBL3307768 CHEMBL
                            # 3307518 CHEMBL3307564 CHEMBL3307944 CHEMBL3307735 CHEMBL3307697 CHEMBL3307654 CHEMBL330839
                            # 2 CHEMBL3308018 CHEMBL3307746 CHEMBL3307975 CHEMBL3307671 CHEMBL3307969 CHEMBL3307552 CHEM
                            # BL3307612 CHEMBL3307641 CHEMBL3307616 CHEMBL3308008 CHEMBL3307783 CHEMBL3307689 CHEMBL3308
                            # 378 CHEMBL3307557 CHEMBL3308372 CHEMBL3307507 CHEMBL3308425 CHEMBL3307626 CHEMBL3307721 CH
                            # EMBL3307782' , '' , '' , '' , '' , 'CHEMBL3307718' , '' , 'CHEMBL3307651 CHEMBL3307739 CHE
                            # MBL3308396'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '0' , '57' , '0' , '0' , '0' , '0' , '1' , '0' , '3'
                        }
                    },
                    'related_documents': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL4265984' , 'CHEMBL4184157' , 'CHEMBL1201862' , 'CHEMBL4265981' , 'CHEMBL4270621' , 
                            # 'CHEMBL1123423' , 'CHEMBL4229546' , 'CHEMBL4190257' , 'CHEMBL4270538' , 'CHEMBL4130379'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                        }
                    },
                    'related_targets': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL612545 CHEMBL365 CHEMBL395' , 'CHEMBL612545' , 'CHEMBL614285 CHEMBL614317 CHEMBL614
                            # 803 CHEMBL614051 CHEMBL614067 CHEMBL614642 CHEMBL614110 CHEMBL614034 CHEMBL614917 CHEMBL61
                            # 4908 CHEMBL385 CHEMBL612262 CHEMBL613889 CHEMBL614021 CHEMBL614925 CHEMBL612555 CHEMBL6144
                            # 51 CHEMBL613984 CHEMBL614809 CHEMBL614791 CHEMBL384 CHEMBL614886 CHEMBL614164 CHEMBL614516
                            #  CHEMBL614860 CHEMBL614388 CHEMBL614177 CHEMBL396 CHEMBL615022 CHEMBL382 CHEMBL614214 CHEM
                            # BL613855 CHEMBL614019 CHEMBL614096 CHEMBL614387 CHEMBL614919 CHEMBL614997 CHEMBL614487 CHE
                            # MBL614888 CHEMBL383 CHEMBL612796 CHEMBL394 CHEMBL392 CHEMBL614054 CHEMBL614213 CHEMBL61254
                            # 3 CHEMBL614643 CHEMBL614922 CHEMBL613102 CHEMBL614519 CHEMBL612263 CHEMBL614709 CHEMBL6147
                            # 40 CHEMBL614882 CHEMBL614610 CHEMBL613977 CHEMBL614561' , 'CHEMBL239 CHEMBL235 CHEMBL3979 
                            # CHEMBL4422 CHEMBL375' , 'CHEMBL4191' , 'CHEMBL376 CHEMBL612558' , 'CHEMBL5251 CHEMBL2148 C
                            # HEMBL612545 CHEMBL3553 CHEMBL2971 CHEMBL2835 CHEMBL4295857' , 'CHEMBL395 CHEMBL4422 CHEMBL
                            # 612545' , 'CHEMBL4295931' , 'CHEMBL392 CHEMBL614580 CHEMBL614909'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '3' , '1' , '57' , '5' , '1' , '2' , '7' , '3' , '1' , '3'
                        }
                    },
                    'related_tissues': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # '' , '' , '' , '' , '' , 'CHEMBL3638201' , '' , '' , '' , ''
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '0' , '0' , '0' , '0' , '0' , '1' , '0' , '0' , '0' , '0'
                        }
                    },
                    'unichem': 
                    {
                        'properties': 
                        {
                            'id': 'TEXT',
                            # EXAMPLES:
                            # '6777659' , '798758' , '118744219' , 'C778AD5E795DD866E787B3577BBB2E25' , '44572669' , 'SC
                            # HEMBL11410190' , '53317248' , 'SCHEMBL15991438' , '2131349' , '8318471'
                            'link': 'TEXT',
                            # EXAMPLES:
                            # 'https://www.emolecules.com/cgi-bin/more?vid=6777659' , 'https://www.emolecules.com/cgi-bi
                            # n/more?vid=798758' , 'http://pubchem.ncbi.nlm.nih.gov/compound/118744219' , 'http://www-93
                            # 5.ibm.com/services/us/gbs/bao/siip/nih/?sid=C778AD5E795DD866E787B3577BBB2E25' , 'http://pu
                            # bchem.ncbi.nlm.nih.gov/compound/44572669' , 'https://www.surechembl.org/chemical/SCHEMBL11
                            # 410190' , 'http://pubchem.ncbi.nlm.nih.gov/compound/53317248' , 'https://www.surechembl.or
                            # g/chemical/SCHEMBL15991438' , 'https://www.emolecules.com/cgi-bin/more?vid=2131349' , 'htt
                            # ps://www.emolecules.com/cgi-bin/more?vid=8318471'
                            'src_name': 'TEXT',
                            # EXAMPLES:
                            # 'eMolecules' , 'eMolecules' , 'PubChem' , 'IBM Patent System' , 'PubChem' , 'SureChEMBL' ,
                            #  'PubChem' , 'SureChEMBL' , 'eMolecules' , 'eMolecules'
                            'src_url': 'TEXT',
                            # EXAMPLES:
                            # 'https://www.emolecules.com/' , 'https://www.emolecules.com/' , 'http://pubchem.ncbi.nlm.n
                            # ih.gov' , 'http://www-935.ibm.com/services/us/gbs/bao/siip/nih/' , 'http://pubchem.ncbi.nl
                            # m.nih.gov' , 'https://www.surechembl.org/search/' , 'http://pubchem.ncbi.nlm.nih.gov' , 'h
                            # ttps://www.surechembl.org/search/' , 'https://www.emolecules.com/' , 'https://www.emolecul
                            # es.com/'
                        }
                    }
                }
            },
            'atc_classifications': 'TEXT',
            # EXAMPLES:
            # 'R05CA08' , 'P01AR03' , 'G01AX15' , 'B03AB03' , 'A16AB06' , 'J07AH07' , 'V08CA03' , 'B03AA04' , 'V09DA05' 
            # , 'P02BX03'
            'availability_type': 'NUMERIC',
            # EXAMPLES:
            # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
            'biotherapeutic': 
            {
                'properties': 
                {
                    'biocomponents': 
                    {
                        'properties': 
                        {
                            'component_id': 'NUMERIC',
                            # EXAMPLES:
                            # '17490' , '17463' , '6720' , '17477' , '17518' , '6720' , '6509' , '10182' , '6433' , '175
                            # 32'
                            'component_type': 'TEXT',
                            # EXAMPLES:
                            # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTE
                            # IN' , 'PROTEIN' , 'PROTEIN'
                            'description': 'TEXT',
                            # EXAMPLES:
                            # 'FRUNEVETMAB Heavy chain' , 'COFETUZUMAB PELIDOTIN Heavy chain' , 'Purified bovine insulin
                            #  zinc suspension' , 'VADASTUXIMAB Heavy chain' , 'Purified bovine insulin zinc suspension'
                            #  , 'Panobacumab heavy chain' , 'TAMTUVETMAB Heavy Chain' , 'Suvizumab heavy chain' , 'DUVO
                            # RTUXIZUMAB h-CH2-CH3 chain3 sequence' , 'OLENDALIZUMAB Heavy chain'
                            'organism': 'TEXT',
                            # EXAMPLES:
                            # 'Bos taurus' , 'Bos taurus' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sap
                            # iens' , 'Bos taurus' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens'
                            'sequence': 'TEXT',
                            # EXAMPLES:
                            # 'QVQLVESGAELVQPGESLRLTCAASGFSLTNNNVNWVRQAPGKGLEWMGGVWAGGATDYNSALKSRLTITRDTSKNTVFLQMHSLQSED
                            # TATYYCARDGGYSSSTLYAMDAWGQGTTVTVSAASTTAPSVFPLAPSCGTTSGATVALACLVLGYFPEPVTVSWNSGALTSGVHTFPAVL
                            # QASGLYSLSSMVTVPSSRWLSDTFTCNVAHPPSNTKVDKTVRKTDHPPGPKPCDCPKCPPPEMLGGPSIFIFPPKPKDTLSISRTPEVTC
                            # LVVDLGPDDSDVQITWFVDNTQVYTAKTSPREEQFNSTYRVVSVLPILHQDWLKGKEFKCKVNSKSLPSPIERTISKAKGQPHEPQVYVL
                            # PPAQEELSRNKVSVTCLIKSFHPPDIAVEWEITGQPEPENNYRTTPPQLDSDGTYFVYSKLSVDRSHWQRGNTYTCSVSHEALHSHHTQK
                            # SLTQSPGK' , 'Q1VQLVQSGPEVKKPGASVKVSCKASGYTFTDYAVHWVRQAPGKRLEWIGVISTYNDYTYNNQDFKGRVTMTRDTSA
                            # STAYMELSRLRSEDTAVYYCARGNSYFYALDYWGQGTSVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALT
                            # SGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMIS
                            # RTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPR
                            # EPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHN
                            # HYTQKSLSLSPG' , 'MALWTRLRPLLALLALWPPPPARAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVGALELAGGPG
                            # AGGLEGPPQKRGIVEQCCASVCSLYQLENYCN' , 'M1SPGQGTQSENSCTHFPGNLPNMLRDLRDAFSRVKTFFQMKDQLDNLLLKES
                            # LLEDFKGYLGCQALSEMIQFYLEEVMPQAENQDPDIKAHVNSLGENLKTLRLRLRRCHRFLPCENKSKAVEQVKNAFNKLQEKGIYKAMS
                            # EFDIFINYIEAYMTMKIRN' , 'XVQLVQSGAEVKKPGASVKVSCKASGYTFTNYDINWVRQAPGQGLEWIGWIYPGDGSTKYNEKFKA
                            # KATLTADTSTSTAYMELRSLRSDDTAVYYCASGYEDAMDYWGQGTTVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTV
                            # SWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPCVFLFPPK
                            # PKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTI
                            # SKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCS
                            # VMHEALHNHYTQKSLSLSPGK' , 'MALWTRLRPLLALLALWPPPPARAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVG
                            # ALELAGGPGAGGLEGPPQKRGIVEQCCASVCSLYQLENYCN' , 'EEQVVESGGGFVQPGGSLRLSCAASGFTFSPYWMHWVRQAPGKG
                            # LVWVSRINSDGSTYYADSVKGRFTISRDNARNTLYLQMNSLRAEDTAVYYCARDRYYGPEMWGQGTMVTVSSGSASAPTLFPLVSCENSP
                            # SDTSSVAVGCLAQDFLPDSITFSWKYKNNSDISSTRGFPSVLRGGKYAATSQVLLPSKDVMQGTDEHVVCKVQHPNGNKEKNVPLPVIAE
                            # LPPKVSVFVPPRDGFFGNPRKSKLICQATGFSPRQIQVSWLREGKQVGSGVTTDQVQAEAKESGPTTYKVTSTLTIKESDWLSQSMFTCR
                            # VDHRGLTFQQNASSMCVPDQDTAIRVFAIPPSFASIFLTKSTKLTCLVTDLTTYDSVTISWTRQNGEAVKTHTNISESHPNATFSAVGEA
                            # SICEDDWNSGERFTCTVTHTDLPSPLKQTISRPKGVALHRPDVYLLPPAREQLNLRESATITCLVTGFSPADVFVQWMQRGQPLSPEKYV
                            # TSAPMPEPQAPGRYFAHSILTVSEEEWNTGETYTCVVAHEALPNRVTERTVDKSTGKPTLYNVSLVMSDTAGTCY' , 'EVKLLESGGG
                            # LVQPGGSMRLSCAGSGFTFTDFYMNWIRQPAGKAPEWLGFIRDKAKGYTTEYNPSVKGRFTISRDNTQNMLYLQMNTLRAEDTATYYCAR
                            # EGHTAAPFDYWGQGTLVTVSSASTTAPSVFPLAPSCGSTSGSTVALACLVSGYFPEPVTVSWNSGSLTSGVHTFPSVLQSSGLYSLSSMV
                            # TVPSSRWPSETFTCNVAHPASKTKVDKPVPKRENGRVPRPPDCPKCPAPEMLGGPSVFIFPPKPKDTLLIARTPEVTCVVVDLDPEDPEV
                            # QISWFVDGKQMQTAKTQPREEQFNGTYRVVSVLPIGHQDWLKGKQFTCKVNNKALPSPIERTISKARGQAHQPSVYVLPPSREELSKNTV
                            # SLTCLIKDFFPPDIDVEWQSNGQQEPESKYRTTPPQLDEDGSYFLYSKLSVDKSRWQRGDTFICAVMHEALHNHYTQKSLSHSPGK' , 
                            # 'QVQLVQSGAEVKKPGASVKVSCKASGYTFTNSWIGWFRQAPGQGLEWIGDIYPGGGYTNYNEIFKGKATMTADTSTNTAYMELSSLRSE
                            # DTAVYYCSRGIPGYAMDYWGQGTLVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSG
                            # LYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSH
                            # EDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDEL
                            # TKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK'
                            #  , 'DKTHTCPPCPAPEAAGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVL
                            # TVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSREEMTKNQVSLSCAVKGFYPSDIAVEWESNGQPENNYKTTPP
                            # VLDSDGSFFLVSKLTVDKSRWQQGNVFSCSVMHEALHNRYTQKSLSLSPG'
                            'tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '9913' , '9913' , '9606' , '9606' , '9606' , '9606' , '9913' , '9606' , '9606' , '9606'
                        }
                    },
                    'description': 'TEXT',
                    # EXAMPLES:
                    # 'ONCOLYSIN M (Immunotoxin mab)' , 'J591 (111In) (mab)' , 'Vapaliximab (chimeric mab)' , 'Prompt bo
                    # vine insulin zinc suspension' , 'REGN-846 (mab)' , 'ALG-991 (chimeric mab)' , 'Nacolomab tafenatox
                    #  (mouse Fab)' , 'Felvizumab (humanized mab)' , 'MEDI-500 (mouse mab)' , 'SAR-1349 (mab)'
                    'helm_notation': 'TEXT',
                    # EXAMPLES:
                    # 'PEPTIDE1{S.C.R.L.Y.E.L.L.H.G.A.G.N.H.A.A.G.I.L.T.L}|PEPTIDE2{S.C.R.L.Y.E.L.L.H.G.A.G.N.H.A.A.G.I.
                    # L.T.L}$PEPTIDE2,PEPTIDE1,2:R3-2:R3$$$' , 'PEPTIDE1{H.S.D.G.I.A.T.D.S.Y.S.R.Y.R.K.Q.M.A.V.K.K.Y.L.A
                    # .A.V.L.G.K.R.Y.K.Q.R.V.K.N.K.[am]}$$$$' , 'PEPTIDE1{[ac].W.E.E.W.D.K.K.I.E.E.Y.T.K.K.I.E.E.L.I.K.K
                    # .S.E.E.E.Q.K.K.N.E.E.E.L.K.K.[am]}$$$$' , 'PEPTIDE1{[dC].S.[dC].S.[dS].L.[dM].D.[dK].E.[dC].V.[dY]
                    # .F.C.H.L.T.[X274].I.W}$PEPTIDE1,PEPTIDE1,11:R3-3:R3|PEPTIDE1,PEPTIDE1,15:R3-1:R3$$$' , 'PEPTIDE1{[
                    # Glp].G.P.P.I.S.I.D.L.P.L.L.L.L.R.K.M.I.E.I.E.K.Q.E.K.E.K.Q.Q.A.A.N.N.R.L.L.L.D.T.I}$$$$' , 'PEPTID
                    # E1{E.L.R.P.E.D.D.M.K.P.G.S.F.D.R.S.I.P.E.N.N.I.M.R.[lalloT].I.I.E.F.L.S.F.L.H.L.K.E.A.G.A.I}$$$$' 
                    # , 'PEPTIDE1{Y.T.S.L.I.H.S.L.I.E.E.S.Q.N.Q.Q.E.K.N.E.Q.E.L.L.E.L.D.K.W.A.S.L.W.N.W.F.[dC]}$$$$' , '
                    # PEPTIDE1{[ac].Y.T.S.L.I.E.E.L.I.K.K.T.E.E.Q.Q.K.K.N.E.E.E.L.K.K.L.E.E.W.A.K.K.W.N.W.F.[am]}$$$$' ,
                    #  'PEPTIDE1{S.Q.E.P.P.I.S.L.D.L.T.F.H.L.L.R.E.V.L.E.M.T.K.A.D.Q.L.A.Q.Q.A.H.S.N.R.K.L.A.D.I.A.[am]}
                    # $$$$' , 'PEPTIDE1{S.Q.E.P.P.I.S.L.D.L.T.F.H.L.L.R.E.V.L.E.M.T.K.A.D.Q.L.A.Q.Q.A.H.S.N.R.K.L.L.D.I.
                    # A.[am]}$$$$'
                    'molecule_chembl_id': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL3990010' , 'CHEMBL2109520' , 'CHEMBL429376' , 'CHEMBL3989983' , 'CHEMBL2109674' , 'CHEMBL35
                    # 45192' , 'CHEMBL2108827' , 'CHEMBL1201642' , 'CHEMBL525817' , 'CHEMBL2109648'
                }
            },
            'black_box_warning': 'NUMERIC',
            # EXAMPLES:
            # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
            'chebi_par_id': 'NUMERIC',
            # EXAMPLES:
            # '77566' , '53434' , '2930' , '30119' , '35404' , '78292' , '48828' , '37333' , '50369' , '31941'
            'chirality': 'NUMERIC',
            # EXAMPLES:
            # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
            'cross_references': 
            {
                'properties': 
                {
                    'xref_id': 'NUMERIC',
                    # EXAMPLES:
                    # '486737' , '504254' , '49819394' , '22405915' , '50106179' , '4251658' , '17401137' , '4859' , '24
                    # 811386' , '144210252'
                    'xref_name': 'TEXT',
                    # EXAMPLES:
                    # 'SID: 486737' , 'SID: 504254' , 'SID: 49819394' , 'SID: 22405915' , 'SID: 50106179' , 'SID: 425165
                    # 8' , 'SID: 17401137' , 'creosote' , 'SID: 24811386' , 'SID: 144210252'
                    'xref_src': 'TEXT',
                    # EXAMPLES:
                    # 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'DrugCentral' 
                    # , 'PubChem' , 'PubChem'
                    'xref_src_url': 'TEXT',
                    # EXAMPLES:
                    # 'http://pubchem.ncbi.nlm.nih.gov' , 'http://pubchem.ncbi.nlm.nih.gov' , 'http://pubchem.ncbi.nlm.n
                    # ih.gov' , 'http://pubchem.ncbi.nlm.nih.gov' , 'http://pubchem.ncbi.nlm.nih.gov' , 'http://pubchem.
                    # ncbi.nlm.nih.gov' , 'http://pubchem.ncbi.nlm.nih.gov' , 'http://drugcentral.org' , 'http://pubchem
                    # .ncbi.nlm.nih.gov' , 'http://pubchem.ncbi.nlm.nih.gov'
                    'xref_url': 'TEXT',
                    # EXAMPLES:
                    # 'http://drugcentral.org/drugcard/4859/view' , 'http://drugcentral.org/drugcard/4104/view' , 'http:
                    # //en.wikipedia.org/wiki/Aurothioglucose' , 'http://drugcentral.org/drugcard/4279/view' , 'http://d
                    # ailymed.nlm.nih.gov/dailymed/advSearch.cfm?startswith=NAME:(%22samarium%20sm-153%20lexidronam%20pe
                    # ntasodium%22)' , 'http://dailymed.nlm.nih.gov/dailymed/advSearch.cfm?startswith=NAME:(%22technetiu
                    # m%20tc-99m%20exametazime%20kit%22)' , 'http://drugcentral.org/drugcard/4709/view' , 'http://dailym
                    # ed.nlm.nih.gov/dailymed/advSearch.cfm?startswith=NAME:(%22sacrosidase%22)' , 'http://dailymed.nlm.
                    # nih.gov/dailymed/advSearch.cfm?startswith=NAME:(%22gadodiamide%22)' , 'http://dailymed.nlm.nih.gov
                    # /dailymed/advSearch.cfm?startswith=NAME:(%22technetium%20tc-99m%20bicisate%20kit%22)'
                }
            },
            'dosed_ingredient': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'first_approval': 'NUMERIC',
            # EXAMPLES:
            # '1982' , '1997' , '1988' , '1998' , '1982' , '1993' , '1994' , '1994' , '2018' , '1990'
            'first_in_class': 'NUMERIC',
            # EXAMPLES:
            # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
            'helm_notation': 'TEXT',
            # EXAMPLES:
            # 'PEPTIDE1{S.C.R.L.Y.E.L.L.H.G.A.G.N.H.A.A.G.I.L.T.L}|PEPTIDE2{S.C.R.L.Y.E.L.L.H.G.A.G.N.H.A.A.G.I.L.T.L}$P
            # EPTIDE2,PEPTIDE1,2:R3-2:R3$$$' , 'PEPTIDE1{H.S.D.G.I.A.T.D.S.Y.S.R.Y.R.K.Q.M.A.V.K.K.Y.L.A.A.V.L.G.K.R.Y.K
            # .Q.R.V.K.N.K.[am]}$$$$' , 'PEPTIDE1{[ac].W.E.E.W.D.K.K.I.E.E.Y.T.K.K.I.E.E.L.I.K.K.S.E.E.E.Q.K.K.N.E.E.E.L
            # .K.K.[am]}$$$$' , 'PEPTIDE1{[dC].S.[dC].S.[dS].L.[dM].D.[dK].E.[dC].V.[dY].F.C.H.L.T.[X274].I.W}$PEPTIDE1,
            # PEPTIDE1,11:R3-3:R3|PEPTIDE1,PEPTIDE1,15:R3-1:R3$$$' , 'PEPTIDE1{[Glp].G.P.P.I.S.I.D.L.P.L.L.L.L.R.K.M.I.E
            # .I.E.K.Q.E.K.E.K.Q.Q.A.A.N.N.R.L.L.L.D.T.I}$$$$' , 'PEPTIDE1{E.L.R.P.E.D.D.M.K.P.G.S.F.D.R.S.I.P.E.N.N.I.M
            # .R.[lalloT].I.I.E.F.L.S.F.L.H.L.K.E.A.G.A.I}$$$$' , 'PEPTIDE1{Y.T.S.L.I.H.S.L.I.E.E.S.Q.N.Q.Q.E.K.N.E.Q.E.
            # L.L.E.L.D.K.W.A.S.L.W.N.W.F.[dC]}$$$$' , 'PEPTIDE1{[ac].Y.T.S.L.I.E.E.L.I.K.K.T.E.E.Q.Q.K.K.N.E.E.E.L.K.K.
            # L.E.E.W.A.K.K.W.N.W.F.[am]}$$$$' , 'PEPTIDE1{S.Q.E.P.P.I.S.L.D.L.T.F.H.L.L.R.E.V.L.E.M.T.K.A.D.Q.L.A.Q.Q.A
            # .H.S.N.R.K.L.A.D.I.A.[am]}$$$$' , 'PEPTIDE1{S.Q.E.P.P.I.S.L.D.L.T.F.H.L.L.R.E.V.L.E.M.T.K.A.D.Q.L.A.Q.Q.A.
            # H.S.N.R.K.L.L.D.I.A.[am]}$$$$'
            'indication_class': 'TEXT',
            # EXAMPLES:
            # 'Radioactive Agent' , 'Pharmaceutic Aid (surfactant)' , 'Contact Lens Material (hydrophilic)' , 'Pharmaceu
            # tic Aid (viscosity-increasing agent)' , 'Radioactive Agent' , 'Pharmaceutic Aid (ointment base, absorbent)
            # ' , 'Pharmaceutic Aid (excipient)' , 'Contact Lens Material (hydrophilic)' , 'Immunizing Agent (passive)' 
            # , 'Pharmaceutic Aid (surfactant); Pharmaceutic Aid (emulsifying agent)'
            'inorganic_flag': 'NUMERIC',
            # EXAMPLES:
            # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
            'max_phase': 'NUMERIC',
            # EXAMPLES:
            # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL4285456' , 'CHEMBL4204510' , 'CHEMBL2146236' , 'CHEMBL4291932' , 'CHEMBL4283165' , 'CHEMBL3084592' 
            # , 'CHEMBL4249872' , 'CHEMBL4204628' , 'CHEMBL4278745' , 'CHEMBL4164768'
            'molecule_hierarchy': 
            {
                'properties': 
                {
                    'molecule_chembl_id': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL4285456' , 'CHEMBL4204510' , 'CHEMBL2146236' , 'CHEMBL4291932' , 'CHEMBL4283165' , 'CHEMBL3
                    # 084592' , 'CHEMBL4249872' , 'CHEMBL4204628' , 'CHEMBL4278745' , 'CHEMBL4164768'
                    'parent_chembl_id': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL4285456' , 'CHEMBL4204510' , 'CHEMBL2146236' , 'CHEMBL4291932' , 'CHEMBL4283165' , 'CHEMBL3
                    # 139277' , 'CHEMBL4249872' , 'CHEMBL4204628' , 'CHEMBL4278745' , 'CHEMBL4164768'
                }
            },
            'molecule_properties': 
            {
                'properties': 
                {
                    'alogp': 'NUMERIC',
                    # EXAMPLES:
                    # '4.60' , '3.90' , '4.14' , '7.64' , '1.41' , '1.34' , '4.84' , '4.15' , '3.73' , '3.38'
                    'aromatic_rings': 'NUMERIC',
                    # EXAMPLES:
                    # '2' , '2' , '2' , '2' , '0' , '3' , '3' , '3' , '4' , '3'
                    'cx_logd': 'NUMERIC',
                    # EXAMPLES:
                    # '0.22' , '2.40' , '0.21' , '7.54' , '-0.82' , '0.56' , '1.27' , '4.92' , '4.20' , '3.39'
                    'cx_logp': 'NUMERIC',
                    # EXAMPLES:
                    # '3.29' , '4.43' , '3.50' , '8.17' , '1.79' , '0.56' , '4.77' , '4.92' , '4.20' , '3.39'
                    'cx_most_apka': 'NUMERIC',
                    # EXAMPLES:
                    # '3.75' , '6.88' , '12.49' , '2.81' , '13.77' , '11.78' , '9.61' , '8.41' , '7.31' , '11.99'
                    'cx_most_bpka': 'NUMERIC',
                    # EXAMPLES:
                    # '9.90' , '9.46' , '2.19' , '10.22' , '4.04' , '5.02' , '0.87' , '3.74' , '1.80' , '9.65'
                    'full_molformula': 'TEXT',
                    # EXAMPLES:
                    # 'C35H54N6O3' , 'C20H27NO2S' , 'C9H10ClN3O2PtS' , 'C19H19ClO5' , 'C26H37NO3' , 'C14H27ClN2O3' , 'C2
                    # 0H26N8O2' , 'C23H21ClO6S' , 'C17H11F6N5O' , 'C20H20N4O3'
                    'full_mwt': 'NUMERIC',
                    # EXAMPLES:
                    # '606.86' , '345.51' , '454.80' , '362.81' , '411.59' , '306.83' , '410.48' , '460.94' , '415.30' ,
                    #  '364.41'
                    'hba': 'NUMERIC',
                    # EXAMPLES:
                    # '5' , '4' , '4' , '4' , '4' , '9' , '5' , '6' , '6' , '6'
                    'hba_lipinski': 'NUMERIC',
                    # EXAMPLES:
                    # '9' , '3' , '5' , '4' , '5' , '10' , '6' , '6' , '7' , '8'
                    'hbd': 'NUMERIC',
                    # EXAMPLES:
                    # '4' , '2' , '1' , '3' , '2' , '1' , '1' , '2' , '1' , '1'
                    'hbd_lipinski': 'NUMERIC',
                    # EXAMPLES:
                    # '6' , '2' , '1' , '3' , '3' , '2' , '1' , '2' , '1' , '1'
                    'heavy_atoms': 'NUMERIC',
                    # EXAMPLES:
                    # '44' , '24' , '25' , '30' , '19' , '30' , '31' , '29' , '27' , '26'
                    'molecular_species': 'TEXT',
                    # EXAMPLES:
                    # 'BASE' , 'BASE' , 'ACID' , 'NEUTRAL' , 'BASE' , 'NEUTRAL' , 'ACID' , 'NEUTRAL' , 'NEUTRAL' , 'NEUT
                    # RAL'
                    'mw_freebase': 'NUMERIC',
                    # EXAMPLES:
                    # '606.86' , '345.51' , '454.80' , '362.81' , '411.59' , '270.37' , '410.48' , '460.94' , '415.30' ,
                    #  '364.41'
                    'mw_monoisotopic': 'NUMERIC',
                    # EXAMPLES:
                    # '606.4257' , '345.1763' , '453.9830' , '362.0921' , '411.2773' , '270.1943' , '410.2179' , '460.07
                    # 47' , '415.0868' , '364.1535'
                    'num_lipinski_ro5_violations': 'NUMERIC',
                    # EXAMPLES:
                    # '2' , '0' , '0' , '1' , '0' , '0' , '0' , '0' , '0' , '0'
                    'num_ro5_violations': 'NUMERIC',
                    # EXAMPLES:
                    # '1' , '0' , '0' , '1' , '0' , '0' , '0' , '0' , '0' , '0'
                    'psa': 'NUMERIC',
                    # EXAMPLES:
                    # '137.55' , '41.49' , '64.99' , '73.05' , '81.42' , '116.98' , '89.90' , '71.96' , '73.67' , '115.3
                    # 4'
                    'qed_weighted': 'NUMERIC',
                    # EXAMPLES:
                    # '0.12' , '0.76' , '0.71' , '0.13' , '0.60' , '0.58' , '0.49' , '0.36' , '0.58' , '0.51'
                    'ro3_pass': 'TEXT',
                    # EXAMPLES:
                    # 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
                    'rtb': 'NUMERIC',
                    # EXAMPLES:
                    # '21' , '8' , '8' , '14' , '4' , '7' , '9' , '6' , '5' , '6'
                }
            },
            'molecule_structures': 
            {
                'properties': 
                {
                    'canonical_smiles': 'TEXT',
                    # EXAMPLES:
                    # 'CC(C)=CCC/C(C)=C/CC/C(C)=C/CNCC(=O)N(CCCCN)CC(=O)N(CCc1c[nH]c2ccccc12)CC(N)=O' , 'Cc1ccc(OCC(O)CN
                    # CC2(c3cccs3)CCCC2)cc1' , 'O=C(O)C[C@@H]1COc2cc(OCCCOc3cccc(Cl)c3)ccc21' , 'CCCCCCCCCCCCC/C(=N\O)c1
                    # cc(-c2cccc(O)c2)ccc1O' , 'CC(C)(C)C(=O)NCOC(=O)[C@H]1CC[C@H](CN)CC1.Cl' , 'C=CC(=O)N1CCCC(Cn2nc(-c
                    # 3cnn(CCOC)c3)c3c(N)ncnc32)C1' , 'CCOc1ccc(-c2cccc(COc3ccc(S(=O)(=O)CC(=O)O)cc3)c2)c(Cl)c1' , 'CNc1
                    # nc(NCc2cccc(F)c2)nc(Oc2c(F)c(F)c(F)c(F)c2F)n1' , 'COc1cc(-c2n[nH]c3cc(-c4ccc(C)cc4)nn23)cc(OC)c1OC
                    # ' , 'O=[N+]([O-])c1ccc(-c2cc(CNS(=O)(=O)c3ccc(Cl)cc3)on2)cc1'
                    'standard_inchi': 'TEXT',
                    # EXAMPLES:
                    # 'InChI=1S/C35H54N6O3/c1-27(2)11-9-12-28(3)13-10-14-29(4)17-20-38-24-34(43)40(21-8-7-19-36)26-35(44
                    # )41(25-33(37)42)22-18-30-23-39-32-16-6-5-15-31(30)32/h5-6,11,13,15-17,23,38-39H,7-10,12,14,18-22,2
                    # 4-26,36H2,1-4H3,(H2,37,42)/b28-13+,29-17+' , 'InChI=1S/C20H27NO2S/c1-16-6-8-18(9-7-16)23-14-17(22)
                    # 13-21-15-20(10-2-3-11-20)19-5-4-12-24-19/h4-9,12,17,21-22H,2-3,10-11,13-15H2,1H3' , 'InChI=1S/C19H
                    # 19ClO5/c20-14-3-1-4-15(10-14)23-7-2-8-24-16-5-6-17-13(9-19(21)22)12-25-18(17)11-16/h1,3-6,10-11,13
                    # H,2,7-9,12H2,(H,21,22)/t13-/m1/s1' , 'InChI=1S/C26H37NO3/c1-2-3-4-5-6-7-8-9-10-11-12-16-25(27-30)2
                    # 4-20-22(17-18-26(24)29)21-14-13-15-23(28)19-21/h13-15,17-20,28-30H,2-12,16H2,1H3/b27-25+' , 'InChI
                    # =1S/C14H26N2O3.ClH/c1-14(2,3)13(18)16-9-19-12(17)11-6-4-10(8-15)5-7-11;/h10-11H,4-9,15H2,1-3H3,(H,
                    # 16,18);1H/t10-,11-;' , 'InChI=1S/C20H26N8O2/c1-3-16(29)26-6-4-5-14(10-26)11-28-20-17(19(21)22-13-2
                    # 3-20)18(25-28)15-9-24-27(12-15)7-8-30-2/h3,9,12-14H,1,4-8,10-11H2,2H3,(H2,21,22,23)' , 'InChI=1S/C
                    # 23H21ClO6S/c1-2-29-19-8-11-21(22(24)13-19)17-5-3-4-16(12-17)14-30-18-6-9-20(10-7-18)31(27,28)15-23
                    # (25)26/h3-13H,2,14-15H2,1H3,(H,25,26)' , 'InChI=1S/C17H11F6N5O/c1-24-15-26-16(25-6-7-3-2-4-8(18)5-
                    # 7)28-17(27-15)29-14-12(22)10(20)9(19)11(21)13(14)23/h2-5H,6H2,1H3,(H2,24,25,26,27,28)' , 'InChI=1S
                    # /C20H20N4O3/c1-12-5-7-13(8-6-12)15-11-18-21-22-20(24(18)23-15)14-9-16(25-2)19(27-4)17(10-14)26-3/h
                    # 5-11,21H,1-4H3' , 'InChI=1S/C16H12ClN3O5S/c17-12-3-7-15(8-4-12)26(23,24)18-10-14-9-16(19-25-14)11-
                    # 1-5-13(6-2-11)20(21)22/h1-9,18H,10H2'
                    'standard_inchi_key': 'TEXT',
                    # EXAMPLES:
                    # 'ARZCFGFAMDMEPO-OUADVBRVSA-N' , 'YGSZOLBJQDRZDM-UHFFFAOYSA-N' , 'KNTFJPOCGUBOIF-CYBMUJFWSA-N' , 'X
                    # SYOYDLEVZEUOY-IMVLJIQESA-N' , 'NEEUYPGQUDJVNW-PFWPSKEQSA-N' , 'ZEAVIMCJNXJZPV-UHFFFAOYSA-N' , 'DLO
                    # CFEFHMHCCIV-UHFFFAOYSA-N' , 'IQISVMOHBQJIPD-UHFFFAOYSA-N' , 'CWYUAJHFEZALNJ-UHFFFAOYSA-N' , 'IPRVC
                    # BYYTLAIRI-UHFFFAOYSA-N'
                }
            },
            'molecule_synonyms': 
            {
                'properties': 
                {
                    'molecule_synonym': 'TEXT',
                    # EXAMPLES:
                    # '85KR' , 'Boroglycerin' , 'Triphenylstannyl Benzoate' , 'Carbomer Interpolymer' , 'Creosote' , 'Ce
                    # rtoparin Sodium' , 'Polyenephosphatidyl Choline' , 'Milicifoline D' , 'Zirconium (IV) Chloride' , 
                    # 'Dichlorodiphenylstannane'
                    'syn_type': 'TEXT',
                    # EXAMPLES:
                    # 'OTHER' , 'NATIONAL_FORMULARY' , 'OTHER' , 'NATIONAL_FORMULARY' , 'ATC' , 'BAN' , 'JAN' , 'OTHER' 
                    # , 'OTHER' , 'OTHER'
                    'synonyms': 'TEXT',
                    # EXAMPLES:
                    # '85KR' , 'BOROGLYCERIN' , 'Triphenylstannyl Benzoate' , 'CARBOMER INTERPOLYMER' , 'CREOSOTE' , 'CE
                    # RTOPARIN SODIUM' , 'POLYENEPHOSPHATIDYL CHOLINE' , 'Milicifoline D' , 'Zirconium (IV) Chloride' , 
                    # 'Dichlorodiphenylstannane'
                }
            },
            'molecule_type': 'TEXT',
            # EXAMPLES:
            # 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small mole
            # cule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule'
            'natural_product': 'NUMERIC',
            # EXAMPLES:
            # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
            'oral': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'parenteral': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'polymer_flag': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'pref_name': 'TEXT',
            # EXAMPLES:
            # 'Platinum complex' , 'N-methyl-3-azapentane-1,5-dithiol complex' , 'KRYPTON CLATHRATE KR 85' , 'BOROGLYCER
            # IN' , '[p-(N-acrylamino)-phenyl]mercuric chloride' , 'TRIPHENYLSTANNYL BENZOATE' , 'CARBOMER INTERPOLYMER'
            #  , 'CREOSOTE CARBONATE' , 'CERTOPARIN SODIUM' , 'POLYENEPHOSPHATIDYL CHOLINE'
            'prodrug': 'NUMERIC',
            # EXAMPLES:
            # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
            'structure_type': 'TEXT',
            # EXAMPLES:
            # 'MOL' , 'MOL' , 'NONE' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL'
            'therapeutic_flag': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'topical': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'usan_stem': 'TEXT',
            # EXAMPLES:
            # '-mer' , '-parin' , '-kalant' , '-mab' , '-parin' , '-anib' , '-stim' , '-filcon' , '-vin-' , '-poetin'
            'usan_stem_definition': 'TEXT',
            # EXAMPLES:
            # 'polymers' , 'heparin derivatives and low molecular weight (or depolymerized) heparins' , 'potassium chann
            # el antagonists' , 'monoclonal antibodies: veterinary use' , 'heparin derivatives and low molecular weight 
            # (or depolymerized) heparins' , 'angiogenesis inhibitors' , 'colony-stimulating factors: conjugates of two 
            # different types of colony-stimulating factors' , 'hydrophilic contact lens materials' , 'vinca alkaloids' 
            # , 'erythropoietins'
            'usan_substem': 'TEXT',
            # EXAMPLES:
            # '-mer' , '-parin' , '-kalant' , '-mab (-vetmab)' , '-parin' , '-anib' , '-stim (-distim)' , '-filcon' , '-
            # vin-' , '-poetin'
            'usan_year': 'NUMERIC',
            # EXAMPLES:
            # '1963' , '2016' , '2014' , '1998' , '1983' , '1987' , '1985' , '2016' , '2015' , '2004'
            'withdrawn_class': 'TEXT',
            # EXAMPLES:
            # 'Misuse' , 'Hepatotoxicity' , 'Hepatotoxicity' , 'Carcinogenicity; Gastrotoxicity' , 'Cardiotoxicity' , 'R
            # espiratory toxicity' , 'Cardiotoxicity' , 'Neurotoxicity' , 'Neurotoxicity; Psychiatric toxicity' , 'Carci
            # nogenicity'
            'withdrawn_country': 'TEXT',
            # EXAMPLES:
            # 'European Union' , 'United States' , 'France; Norway' , 'France' , 'Australia' , 'United States' , 'United
            #  Kingdom; Spain; Germany' , 'Germany' , 'United Kingdom; United States' , 'United States'
            'withdrawn_flag': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'withdrawn_reason': 'TEXT',
            # EXAMPLES:
            # 'Lack of eficacy' , 'Increased mortality' , 'Self-poisoning' , 'Hepatotoxicity' , 'Hepatotoxicity' , 'Anim
            # al Carcinogenicity (rodent); Gastrointestinal Toxicity' , 'Multi-Organ Toxicities' , 'Ventricular arrhythm
            # ias; Cardiotoxicity and Excess Mortality' , 'Fatal bronchospasm' , 'Torsade de pointes'
            'withdrawn_year': 'NUMERIC',
            # EXAMPLES:
            # '2011' , '2007' , '1980' , '1984' , '1971' , '1983' , '1986' , '1991' , '2001' , '1998'
        }
    }

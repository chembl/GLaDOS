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
            'applicants': 'TEXT',
            # EXAMPLES:
            # 'Novitium Pharma Llc' , 'Glaxosmithkline Consumer Healthcare' , 'Bausch And Lomb Pharmaceuticals Inc' , 'S
            # anofi Aventis Us Llc' , 'Zydus Pharmaceuticals Usa Inc' , 'Sandoz Inc' , 'Sandoz Inc' , 'Aurolife Pharma L
            # lc' , 'Zydus Pharmaceuticals Usa Inc' , 'Wockhardt Ltd'
            'atc_classification': 
            {
                'properties': 
                {
                    'code': 'TEXT',
                    # EXAMPLES:
                    # 'C02CA01' , 'N07BA01' , 'S02AA16' , 'J01MB02' , 'M01AB51' , 'J01CG01' , 'J01CG02' , 'J01MA08' , 'N
                    # 02AA03' , 'C08CA55'
                    'description': 'TEXT',
                    # EXAMPLES:
                    # 'CARDIOVASCULAR SYSTEM: ANTIHYPERTENSIVES: ANTIADRENERGIC AGENTS, PERIPHERALLY ACTING: Alpha-adren
                    # oreceptor antagonists' , 'NERVOUS SYSTEM: OTHER NERVOUS SYSTEM DRUGS: DRUGS USED IN ADDICTIVE DISO
                    # RDERS: Drugs used in nicotine dependence' , 'SENSORY ORGANS: OTOLOGICALS: ANTIINFECTIVES: Antiinfe
                    # ctive' , 'ANTIINFECTIVES FOR SYSTEMIC USE: ANTIBACTERIALS FOR SYSTEMIC USE: QUINOLONE ANTIBACTERIA
                    # LS: Other quinolones' , 'MUSCULO-SKELETAL SYSTEM: ANTIINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS: ANT
                    # IINFLAMMATORY AND ANTIRHEUMATIC PRODUCTS, NON-STEROIDS: Acetic acid derivatives and related substa
                    # nce' , 'ANTIINFECTIVES FOR SYSTEMIC USE: ANTIBACTERIALS FOR SYSTEMIC USE: BETA-LACTAM ANTIBACTERIA
                    # LS, PENICILLINS: Beta-lactamase inhibitors' , 'ANTIINFECTIVES FOR SYSTEMIC USE: ANTIBACTERIALS FOR
                    #  SYSTEMIC USE: BETA-LACTAM ANTIBACTERIALS, PENICILLINS: Beta-lactamase inhibitors' , 'ANTIINFECTIV
                    # ES FOR SYSTEMIC USE: ANTIBACTERIALS FOR SYSTEMIC USE: QUINOLONE ANTIBACTERIALS: Fluoroquinolones' 
                    # , 'NERVOUS SYSTEM: ANALGESICS: OPIOIDS: Natural opium alkaloids' , 'CARDIOVASCULAR SYSTEM: CALCIUM
                    #  CHANNEL BLOCKERS: SELECTIVE CALCIUM CHANNEL BLOCKERS WITH MAINLY VASCULAR EFFECTS: Dihydropyridin
                    # e derivative'
                }
            },
            'availability_type': 'NUMERIC',
            # EXAMPLES:
            # '1' , '2' , '1' , '0' , '-1' , '-1' , '1' , '1' , '-1' , '1'
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
                            # '17453' , '6348' , '17463' , '17465' , '17477' , '18557' , '17492' , '17509' , '17513' , '
                            # 17522'
                            'component_type': 'TEXT',
                            # EXAMPLES:
                            # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTE
                            # IN' , 'PROTEIN' , 'PROTEIN'
                            'description': 'TEXT',
                            # EXAMPLES:
                            # 'Bezlotoxumab heavy chain' , 'COFETUZUMAB PELIDOTIN Heavy chain' , 'NAVICIXIZUMAB Anti-DLL
                            # 4 heavy chain' , 'DONANEMAB Heavy chain' , 'ROVALPITUZUMAB TESIRINE Heavy chain' , 'VADAST
                            # UXIMAB TALIRINE Heavy chain' , 'Botulinum neurotoxin type A precursor' , 'Quilizumab heavy
                            #  chain' , 'Tositumomab heavy chain' , 'Tumor necrosis factor receptor superfamily member 1
                            # B precursor'
                            'organism': 'TEXT',
                            # EXAMPLES:
                            # 'Homo sapiens' , 'Clostridium botulinum' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens
                            # ' , 'Homo sapiens' , 'Homo sapiens' , 'Sus scrofa' , 'Home sapiens' , 'Bos taurus'
                            'sequence': 'TEXT',
                            # EXAMPLES:
                            # 'KCRGDCF' , 'EVQLVQSGAEVKKSGESLKISCKGSGYSFTSYWIGWVRQMPGKGLEWMGIFYPGDSSTRYSPSFQGQVTISADKSVN
                            # TAYLQWSSLKASDTAMYYCARRRNWGNAFDIWGQGTMVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTS
                            # GVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKRVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISR
                            # TPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPRE
                            # PQVYTLPPSREEMTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNH
                            # YTQKSLSLSPGK' , 'Q1VQLVQSGPEVKKPGASVKVSCKASGYTFTDYAVHWVRQAPGKRLEWIGVISTYNDYTYNNQDFKGRVTMTR
                            # DTSASTAYMELSRLRSEDTAVYYCARGNSYFYALDYWGQGTSVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNS
                            # GALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDT
                            # LMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAK
                            # GQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHE
                            # ALHNHYTQKSLSLSPG' , 'QVQLVQSGAEVKKPGASVKISCKASGYSFTAYYIHWVKQAPGQGLEWIGYISNYNRATNYNQKFKGRVT
                            # FTTDTSTSTAYMELRSLRSDDTAVYYCARDYDYDVGMDYWGQGTLVTVSSASTKGPSVFPLAPCSRSTSESTAALGCLVKDYFPEPVTVS
                            # WNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSNFGTQTYTCNVDHKPSNTKVDKTVERKCCVECPPCPAPPVAGPSVFLFPPKPKDTL
                            # MISRTPEVTCVVVDVSHEDPEVQFNWYVDGVEVHNAKTKPREEQFNSTFRVVSVLTVVHQDWLNGKEYKCKVSNKGLPAPIEKTISKTKG
                            # QPREPQVYTLPPSREEMTKNQVSLTCLVEGFYPSDIAVEWESNGQPENNYKTTPPMLDSDGSFFLYSELTVDKSRWQQGNVFSCSVMHEA
                            # LHNHYTQKSLSLSPGK' , 'M1SPGQGTQSENSCTHFPGNLPNMLRDLRDAFSRVKTFFQMKDQLDNLLLKESLLEDFKGYLGCQALSE
                            # MIQFYLEEVMPQAENQDPDIKAHVNSLGENLKTLRLRLRRCHRFLPCENKSKAVEQVKNAFNKLQEKGIYKAMSEFDIFINYIEAYMTMK
                            # IRN' , 'QVQLVQSGAEVKKPGSSVKVSCKASGYDFTRYYINWVRQAPGQGLEWMGWINPGSGNTKYNEKFKGRVTITADESTSTAYME
                            # LSSLRSEDTAVYYCAREGITVYWGQGTTVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVL
                            # QSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVV
                            # DVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPS
                            # RDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLS
                            # PG' , 'Q1VQLVQSGAEVKKPGASVKVSCKASGYTFTNYGMNWVRQAPGQGLEWMGWINTYTGEPTYADDFKGRVTMTTDTSTSTAYME
                            # LRSLRSDDTAVYYCARIGDSSPSDYWGQGTLVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFP
                            # AVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSC1DKTHTC1PPC1PAPELLGGPSVFLFPPKPKDTLMISRTPE
                            # VTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQV
                            # YTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQ
                            # KSLSLSPG' , 'DEAREAAAVRALVARLLGPGPAADFSVSVERALAAKPGLDTYSLGGGGAARVRVRGSTGVAAAAGLHRYLRDFCGCH
                            # VAWSGSQLRLPRPLPAVPGELTEATPNRYRYYQNVCTQSYSFVWWDWARWEREIDWMALNGINLALAWSGQEAIWQRVYLALGLTQAEIN
                            # EFFTGPAFLAWGRMGNLHTWDGPLPPSWHIKQLYLQHRVLDQMRSFGMTPVLPAFAGHVPEAVTRVFPQVNVTKMGSWGHFNCSYSCSFL
                            # LAPEDPIFPIIGSLFLRELIKEFGTDHIYGADTFNEMQPPSSEPSYLAAATTAVYEAMTAVDTEAVWLLQGWLFQHQPQFWGPAQIRAVL
                            # GAVPRGRLLVLDLFAESQPVYTRTASFQGQPFIWCMLHNFGGNHGLFGALEAVNGGPEAARLFPNSTMVGTGMAPEGISQNEVVYSLMAE
                            # LGWRKDPVPDLAAWVTSFAARRYGVSHPDAGAAWRLLLRSVYNCSGEACRGHNRSPLVRRPSLQMNTSIWYNRSDVFEAWRLLLTSAPSL
                            # ATSPAFRYDLLDLTRQAVQELVSLYYEEARSAYLSKELASLLRAGGVLAYELLPALDEVLASDSRFLLGSWLEQARAAAVSEAEADFYEQ
                            # NSRYQLTLWGPEGNILDYANKQLAGLVANYYTPRWRLFLEALVDSVAQGIPFQQHQFDKNVFQLEQAFVLSKQRYPSQPRGDTVDLAKKI
                            # FLKYYPRWVAGSW' , 'XVQLVQSGAEVKKPGASVKVSCKASGYTFTNYDINWVRQAPGQGLEWIGWIYPGDGSTKYNEKFKAKATLTA
                            # DTSTSTAYMELSLRSDDTAVYYCASGYEDAMDYWGQGTTVTVSSASTKGPSVFLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALT
                            # SGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPC1VFLFPPKPKDTLMI
                            # SRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQP
                            # REPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALH
                            # NHYTQKSLSLSPGK' , 'A1QTPAFNKPK1VELHVHLDGAIK1PETILYYGRK1RGIALPADTPEELQNIIGMDK1PLSLPEFLAK1FD
                            # YYMPAIAGSREAVK1RIAYEFVEMK1AKDGVVYVEVRYSPHLLANSK1VEPIPWNQAEGDLTPDEVVSLVNQGLQEGERDFGVK1VRSIL
                            # CCMRHQPSWSSEVVELCK1K1YREQTVVAIDLAGDETIEGSSLFPGHVK1AYAEAVK1SGVHRTVHAGEVGSANVVK1EAVDTLK1TERL
                            # GHGYHTLEDTTLYNRLRQENMHFEVCPWSSYLTGAWK1PDTEHPVVRFK1NDQVNYSLNTDDPLIFK1STLDTDYQMTK1NEMGFTEEEF
                            # K1RLNINAAKSSFLPEDEK1K1ELLDLLYK1AYGMPSPA'
                            'tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '9606' , '1491' , '10090' , '9606' , '9606' , '9606' , '9606' , '9823' , '9606' , '9913'
                        }
                    },
                    'description': 'TEXT',
                    # EXAMPLES:
                    # 'ANGIOTENSIN II' , 'Nerelimomab (mouse mab)' , 'Tanezumab (humanized mab)' , 'Trebananib (mab)' , 
                    # 'Fontolizumab (humanized mab)' , 'Bapineuzumab (humanized mab)' , 'Catumaxomab (rat/mouse hybrid 3
                    # funct)' , 'EFEGATRAN' , 'ULARITIDE' , 'CYT-356 (mouse mab)'
                    'helm_notation': 'TEXT',
                    # EXAMPLES:
                    # 'PEPTIDE1{D.R.V.Y.I.H.P.F}$$$$' , 'PEPTIDE1{[Me_dF].P.[X120]}$$$$' , 'PEPTIDE1{T.A.P.R.S.L.R.R.S.S
                    # .C.F.G.G.R.M.D.R.I.G.A.Q.S.G.L.G.C.N.S.F.R.Y}$PEPTIDE1,PEPTIDE1,27:R3-11:R3$$$' , 'PEPTIDE1{[dS].Y
                    # .S.[dNle].E.[dH].[dF].R.W.G.[dK].P.V.G.K.[dK].R.[dR].P.V.[dK].V.[dY].P.V.[am]}$$$$' , 'PEPTIDE1{A.
                    # V.S.E.H.Q.L.L.H.D.K.G.K.S.I.Q.D.L.R.R.R.E.L.L.E.K.L.L.E.K.L.H.T.A.[am]}$$$$' , 'PEPTIDE1{[dF].C.[d
                    # Y].W.K.V.C.W.[am]}$PEPTIDE1,PEPTIDE1,7:R3-2:R3$$$' , 'PEPTIDE1{C.F.F.Q.N.C.P.[dK].G.[am]}$PEPTIDE1
                    # ,PEPTIDE1,6:R3-1:R3$$$' , 'PEPTIDE1{[dS].Y.S.[dM].E.[dH].[dF].R.W.G.[dK].P.V.G.K.[dK].K.[dK].[am]}
                    # $$$$' , 'PEPTIDE1{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S.Q.S.V.S.S.S.Y.L.A.W.Y.Q.Q.K.
                    # P.G.Q.A.P.R.L.L.I.Y.G.A.S.S.R.A.T.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.R.L.E.P.E.D.F.A.V.Y.Y.C.
                    # Q.Q.Y.G.S.S.T.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.
                    # N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.
                    # E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.Q.S.G.A.E.V.K.K.S.G.E.
                    # S.L.K.I.S.C.K.G.S.G.Y.S.F.T.S.Y.W.I.G.W.V.R.Q.M.P.G.K.G.L.E.W.M.G.I.F.Y.P.G.D.S.S.T.R.Y.S.P.S.F.Q.
                    # G.Q.V.T.I.S.A.D.K.S.V.N.T.A.Y.L.Q.W.S.S.L.K.A.S.D.T.A.M.Y.Y.C.A.R.R.R.N.W.G.N.A.F.D.I.W.G.Q.G.T.M.
                    # V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.
                    # A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.
                    # V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.
                    # T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.
                    # L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.
                    # M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.
                    # Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.
                    # L.V.Q.S.G.A.E.V.K.K.S.G.E.S.L.K.I.S.C.K.G.S.G.Y.S.F.T.S.Y.W.I.G.W.V.R.Q.M.P.G.K.G.L.E.W.M.G.I.F.Y.
                    # P.G.D.S.S.T.R.Y.S.P.S.F.Q.G.Q.V.T.I.S.A.D.K.S.V.N.T.A.Y.L.Q.W.S.S.L.K.A.S.D.T.A.M.Y.Y.C.A.R.R.R.N.
                    # W.G.N.A.F.D.I.W.G.Q.G.T.M.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.
                    # Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.
                    # Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.
                    # P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.
                    # Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.
                    # E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.
                    # T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.
                    # L.S.P.G.K}|PEPTIDE4{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S.Q.S.V.S.S.S.Y.L.A.W.Y.Q.Q.
                    # K.P.G.Q.A.P.R.L.L.I.Y.G.A.S.S.R.A.T.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.R.L.E.P.E.D.F.A.V.Y.Y.
                    # C.Q.Q.Y.G.S.S.T.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.
                    # N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.
                    # Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE1,222:R3-215:R3|PEPTIDE
                    # 4,PEPTIDE4,135:R3-195:R3|PEPTIDE3,PEPTIDE4,222:R3-215:R3|PEPTIDE1,PEPTIDE1,135:R3-195:R3|PEPTIDE2,
                    # PEPTIDE2,263:R3-323:R3|PEPTIDE3,PEPTIDE3,263:R3-323:R3|PEPTIDE2,PEPTIDE2,369:R3-427:R3|PEPTIDE2,PE
                    # PTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,369:R3-427:R3|PEPTIDE4,PEPTIDE4,23:R3-89:R3|PEPTIDE2,PEPTIDE3
                    # ,228:R3-228:R3|PEPTIDE1,PEPTIDE1,23:R3-89:R3|PEPTIDE3,PEPTIDE3,146:R3-202:R3|PEPTIDE2,PEPTIDE2,146
                    # :R3-202:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3$$$' , 'PEPTIDE1{D.I.Q.M.T
                    # .Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.I.Y
                    # .K.V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.S.Q.N.T.L.V.P.W.T.F
                    # .G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q
                    # .W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V
                    # .T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G
                    # .F.T.F.S.D.Y.G.I.A.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.F.I.S.D.L.A.Y.T.I.Y.Y.A.D.T.V.T.G.R.F.T.I.S.R.D.N.S
                    # .K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.N.W.D.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S
                    # .V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V
                    # .L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K
                    # .T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P
                    # .E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K
                    # .C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V
                    # .K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q
                    # .Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G
                    # .G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.G.I.A.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.F.I.S.D.L.A.Y.T.I.Y.Y.A.D.T.V
                    # .T.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.N.W.D.A.M.D.Y.W.G.Q.G.T.L.V
                    # .T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A
                    # .L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V
                    # .D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T
                    # .C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L
                    # .H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M
                    # .T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y
                    # .S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M
                    # .T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.I
                    # .Y.K.V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.S.Q.N.T.L.V.P.W.T
                    # .F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V
                    # .Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E
                    # .V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE3,229:R3-229:R3|PEPTIDE1,PEPTIDE1,23:R3-93
                    # :R3|PEPTIDE3,PEPTIDE3,261:R3-321:R3|PEPTIDE2,PEPTIDE1,220:R3-219:R3|PEPTIDE2,PEPTIDE2,144:R3-200:R
                    # 3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE3,226:R3-226:R3|PEPT
                    # IDE3,PEPTIDE4,220:R3-219:R3|PEPTIDE3,PEPTIDE3,367:R3-425:R3|PEPTIDE2,PEPTIDE2,261:R3-321:R3|PEPTID
                    # E4,PEPTIDE4,139:R3-199:R3|PEPTIDE3,PEPTIDE3,144:R3-200:R3|PEPTIDE2,PEPTIDE2,367:R3-425:R3|PEPTIDE4
                    # ,PEPTIDE4,23:R3-93:R3|PEPTIDE1,PEPTIDE1,139:R3-199:R3$$$'
                    'molecule_chembl_id': 'TEXT',
                    # EXAMPLES:
                    # 'CHEMBL408403' , 'CHEMBL2108566' , 'CHEMBL2108567' , 'CHEMBL2108568' , 'CHEMBL2108459' , 'CHEMBL21
                    # 08576' , 'CHEMBL2108581' , 'CHEMBL273196' , 'CHEMBL2103920' , 'CHEMBL2108800'
                }
            },
            'black_box': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'True' , 'False' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False'
            'chirality': 'NUMERIC',
            # EXAMPLES:
            # '2' , '1' , '0' , '2' , '2' , '2' , '2' , '1' , '2' , '1'
            'development_phase': 'NUMERIC',
            # EXAMPLES:
            # '4' , '4' , '4' , '4' , '2' , '3' , '4' , '4' , '0' , '4'
            'drug_type': 'NUMERIC',
            # EXAMPLES:
            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '7' , '1' , '7'
            'first_approval': 'NUMERIC',
            # EXAMPLES:
            # '1976' , '1984' , '1990' , '1964' , '1965' , '1986' , '1993' , '1984' , '1981' , '2000'
            'first_in_class': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'helm_notation': 'TEXT',
            # EXAMPLES:
            # 'PEPTIDE1{D.R.V.Y.I.H.P.F}$$$$' , 'PEPTIDE1{[Me_dF].P.[X120]}$$$$' , 'PEPTIDE1{T.A.P.R.S.L.R.R.S.S.C.F.G.G
            # .R.M.D.R.I.G.A.Q.S.G.L.G.C.N.S.F.R.Y}$PEPTIDE1,PEPTIDE1,27:R3-11:R3$$$' , 'PEPTIDE1{[dS].Y.S.[dNle].E.[dH]
            # .[dF].R.W.G.[dK].P.V.G.K.[dK].R.[dR].P.V.[dK].V.[dY].P.V.[am]}$$$$' , 'PEPTIDE1{A.V.S.E.H.Q.L.L.H.D.K.G.K.
            # S.I.Q.D.L.R.R.R.E.L.L.E.K.L.L.E.K.L.H.T.A.[am]}$$$$' , 'PEPTIDE1{[dF].C.[dY].W.K.V.C.W.[am]}$PEPTIDE1,PEPT
            # IDE1,7:R3-2:R3$$$' , 'PEPTIDE1{C.F.F.Q.N.C.P.[dK].G.[am]}$PEPTIDE1,PEPTIDE1,6:R3-1:R3$$$' , 'PEPTIDE1{[dS]
            # .Y.S.[dM].E.[dH].[dF].R.W.G.[dK].P.V.G.K.[dK].K.[dK].[am]}$$$$' , 'PEPTIDE1{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.
            # G.E.R.A.T.L.S.C.R.A.S.Q.S.V.S.S.S.Y.L.A.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.G.A.S.S.R.A.T.G.I.P.D.R.F.S.G.S.G.S.
            # G.T.D.F.T.L.T.I.S.R.L.E.P.E.D.F.A.V.Y.Y.C.Q.Q.Y.G.S.S.T.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.
            # S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.
            # S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.Q.S.
            # G.A.E.V.K.K.S.G.E.S.L.K.I.S.C.K.G.S.G.Y.S.F.T.S.Y.W.I.G.W.V.R.Q.M.P.G.K.G.L.E.W.M.G.I.F.Y.P.G.D.S.S.T.R.Y.
            # S.P.S.F.Q.G.Q.V.T.I.S.A.D.K.S.V.N.T.A.Y.L.Q.W.S.S.L.K.A.S.D.T.A.M.Y.Y.C.A.R.R.R.N.W.G.N.A.F.D.I.W.G.Q.G.T.
            # M.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.
            # S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.
            # K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.
            # P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.
            # S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.
            # I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.
            # E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.Q.S.G.A.E.V.K.K.S.G.E.S.L.K.I.S.C.K.G.S.G.Y.S.F.T.
            # S.Y.W.I.G.W.V.R.Q.M.P.G.K.G.L.E.W.M.G.I.F.Y.P.G.D.S.S.T.R.Y.S.P.S.F.Q.G.Q.V.T.I.S.A.D.K.S.V.N.T.A.Y.L.Q.W.
            # S.S.L.K.A.S.D.T.A.M.Y.Y.C.A.R.R.R.N.W.G.N.A.F.D.I.W.G.Q.G.T.M.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.
            # T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.
            # V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.
            # F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.
            # E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.
            # Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.
            # S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{
            # E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S.Q.S.V.S.S.S.Y.L.A.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.G.A.S.
            # S.R.A.T.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.R.L.E.P.E.D.F.A.V.Y.Y.C.Q.Q.Y.G.S.S.T.W.T.F.G.Q.G.T.K.V.E.
            # I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.
            # S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.
            # G.E.C}$PEPTIDE2,PEPTIDE1,222:R3-215:R3|PEPTIDE4,PEPTIDE4,135:R3-195:R3|PEPTIDE3,PEPTIDE4,222:R3-215:R3|PEP
            # TIDE1,PEPTIDE1,135:R3-195:R3|PEPTIDE2,PEPTIDE2,263:R3-323:R3|PEPTIDE3,PEPTIDE3,263:R3-323:R3|PEPTIDE2,PEPT
            # IDE2,369:R3-427:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,369:R3-427:R3|PEPTIDE4,PEPTIDE4,23:R3-8
            # 9:R3|PEPTIDE2,PEPTIDE3,228:R3-228:R3|PEPTIDE1,PEPTIDE1,23:R3-89:R3|PEPTIDE3,PEPTIDE3,146:R3-202:R3|PEPTIDE
            # 2,PEPTIDE2,146:R3-202:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3$$$' , 'PEPTIDE1{D.I
            # .Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.I.Y.K
            # .V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.S.Q.N.T.L.V.P.W.T.F.G.Q.G.T.K
            # .V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S
            # .G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F
            # .N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.G.I.A.W.V.R.Q.A.P.G.K
            # .G.L.E.W.V.A.F.I.S.D.L.A.Y.T.I.Y.Y.A.D.T.V.T.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C
            # .A.R.D.N.W.D.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y
            # .F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V
            # .N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R
            # .T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V
            # .L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N
            # .Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K
            # .S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G
            # .G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.G.I.A.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.F.I.S.D.L.A.Y.T.I.Y.Y.A.D.T.V.T.G.R.F
            # .T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.N.W.D.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K
            # .G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L
            # .Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P
            # .P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D
            # .G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E
            # .K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q
            # .P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K
            # .S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W
            # .Y.Q.Q.K.P.G.K.A.P.K.L.L.I.Y.K.V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C
            # .S.Q.N.T.L.V.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P
            # .R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C
            # .E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE3,229:R3-229:R3|PEPTIDE1,PEPTIDE1,23:R3-93:R3|PE
            # PTIDE3,PEPTIDE3,261:R3-321:R3|PEPTIDE2,PEPTIDE1,220:R3-219:R3|PEPTIDE2,PEPTIDE2,144:R3-200:R3|PEPTIDE2,PEP
            # TIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE3,226:R3-226:R3|PEPTIDE3,PEPTIDE4,220:R3-2
            # 19:R3|PEPTIDE3,PEPTIDE3,367:R3-425:R3|PEPTIDE2,PEPTIDE2,261:R3-321:R3|PEPTIDE4,PEPTIDE4,139:R3-199:R3|PEPT
            # IDE3,PEPTIDE3,144:R3-200:R3|PEPTIDE2,PEPTIDE2,367:R3-425:R3|PEPTIDE4,PEPTIDE4,23:R3-93:R3|PEPTIDE1,PEPTIDE
            # 1,139:R3-199:R3$$$'
            'indication_class': 'TEXT',
            # EXAMPLES:
            # 'Antihypertensive' , 'Smoking Cessation Adjunct' , 'Antibacterial' , 'Antibacterial' , 'Anti-Inflammatory'
            #  , 'Inhibitor (beta-lactamase); Synergist (penicillin/cephalosporin),Synergist (penicillin/cephalosporin);
            #  Inhibitor (beta-lactamase)' , 'Anti-Infective (DNA gyrase inhibitor)' , 'Inhibitor (beta-lactamase)' , 'A
            # ntibacterial' , 'Analgesic (narcotic)'
            'molecule_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL2' , 'CHEMBL3' , 'CHEMBL4' , 'CHEMBL5' , 'CHEMBL6246' , 'CHEMBL204021' , 'CHEMBL6' , 'CHEMBL403' , 
            # 'CHEMBL6259' , 'CHEMBL404'
            'molecule_properties': 
            {
                'properties': 
                {
                    'alogp': 'NUMERIC',
                    # EXAMPLES:
                    # '1.78' , '1.85' , '1.54' , '1.42' , '1.31' , '7.22' , '3.93' , '-0.79' , '2.72' , '-1.52'
                    'aromatic_rings': 'NUMERIC',
                    # EXAMPLES:
                    # '3' , '1' , '2' , '2' , '4' , '4' , '3' , '0' , '3' , '1'
                    'cx_logd': 'NUMERIC',
                    # EXAMPLES:
                    # '1.43' , '-0.04' , '-0.47' , '-0.45' , '-0.53' , '6.34' , '0.26' , '-4.35' , '1.44' , '-4.89'
                    'cx_logp': 'NUMERIC',
                    # EXAMPLES:
                    # '1.65' , '1.16' , '0.51' , '0.79' , '2.32' , '7.31' , '3.53' , '-0.89' , '2.23' , '-1.40'
                    'cx_most_apka': 'NUMERIC',
                    # EXAMPLES:
                    # '5.29' , '4.37' , '5.54' , '3.79' , '3.09' , '5.48' , '2.86' , '3.53' , '5.32' , '10.11'
                    'cx_most_bpka': 'NUMERIC',
                    # EXAMPLES:
                    # '7.24' , '8.58' , '6.16' , '6.06' , '8.31' , '6.42' , '0.75' , '5.99' , '8.59' , '10.33'
                    'full_molformula': 'TEXT',
                    # EXAMPLES:
                    # 'C19H21N5O4' , 'C10H14N2' , 'C18H20FN3O4' , 'C12H12N2O3' , 'C14H6O8' , 'C36H38F4N4O2S' , 'C19H16Cl
                    # NO4' , 'C8H11NO5S' , 'C21H19F2N3O3' , 'C10H12N4O5S'
                    'full_mwt': 'NUMERIC',
                    # EXAMPLES:
                    # '383.41' , '162.24' , '361.37' , '232.24' , '302.19' , '666.79' , '357.79' , '233.25' , '399.40' ,
                    #  '300.30'
                    'hba': 'NUMERIC',
                    # EXAMPLES:
                    # '8' , '2' , '6' , '4' , '8' , '6' , '4' , '4' , '5' , '7'
                    'hba_lipinski': 'NUMERIC',
                    # EXAMPLES:
                    # '9' , '2' , '7' , '5' , '8' , '6' , '5' , '6' , '6' , '9'
                    'hbd': 'NUMERIC',
                    # EXAMPLES:
                    # '1' , '0' , '1' , '1' , '4' , '0' , '1' , '1' , '1' , '1'
                    'hbd_lipinski': 'NUMERIC',
                    # EXAMPLES:
                    # '2' , '0' , '1' , '1' , '4' , '0' , '1' , '1' , '1' , '1'
                    'heavy_atoms': 'NUMERIC',
                    # EXAMPLES:
                    # '28' , '12' , '26' , '17' , '22' , '47' , '25' , '15' , '29' , '20'
                    'molecular_species': 'TEXT',
                    # EXAMPLES:
                    # 'NEUTRAL' , 'BASE' , 'ACID' , 'ACID' , 'ACID' , 'NEUTRAL' , 'ACID' , 'ACID' , 'ACID' , 'ACID'
                    'mw_freebase': 'NUMERIC',
                    # EXAMPLES:
                    # '383.41' , '162.24' , '361.37' , '232.24' , '302.19' , '666.79' , '357.79' , '233.25' , '399.40' ,
                    #  '300.30'
                    'mw_monoisotopic': 'NUMERIC',
                    # EXAMPLES:
                    # '383.1594' , '162.1157' , '361.1438' , '232.0848' , '302.0063' , '666.2652' , '357.0768' , '233.03
                    # 58' , '399.1394' , '300.0528'
                    'num_lipinski_ro5_violations': 'NUMERIC',
                    # EXAMPLES:
                    # '0' , '0' , '0' , '0' , '0' , '2' , '0' , '0' , '0' , '0'
                    'num_ro5_violations': 'NUMERIC',
                    # EXAMPLES:
                    # '0' , '0' , '0' , '0' , '0' , '2' , '0' , '0' , '0' , '0'
                    'psa': 'NUMERIC',
                    # EXAMPLES:
                    # '106.95' , '16.13' , '75.01' , '72.19' , '141.34' , '58.44' , '68.53' , '91.75' , '65.78' , '122.4
                    # 6'
                    'qed_weighted': 'NUMERIC',
                    # EXAMPLES:
                    # '0.73' , '0.63' , '0.87' , '0.85' , '0.22' , '0.09' , '0.77' , '0.60' , '0.73' , '0.67'
                    'ro3_pass': 'TEXT',
                    # EXAMPLES:
                    # 'N' , 'Y' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
                    'rtb': 'NUMERIC',
                    # EXAMPLES:
                    # '4' , '1' , '2' , '2' , '0' , '13' , '4' , '1' , '3' , '3'
                }
            },
            'molecule_structures': 
            {
                'properties': 
                {
                    'canonical_smiles': 'TEXT',
                    # EXAMPLES:
                    # 'COc1cc2nc(N3CCN(C(=O)c4ccco4)CC3)nc(N)c2cc1OC' , 'CN1CCC[C@H]1c1cccnc1' , 'CC1COc2c(N3CCN(C)CC3)c
                    # (F)cc3c(=O)c(C(=O)O)cn1c23' , 'CCn1cc(C(=O)O)c(=O)c2ccc(C)nc21' , 'O=c1oc2c(O)c(O)cc3c(=O)oc4c(O)c
                    # (O)cc1c4c23' , 'CCN(CC)CCN(Cc1ccc(-c2ccc(C(F)(F)F)cc2)cc1)C(=O)Cn1c(SCc2ccc(F)cc2)nc(=O)c2c1CCC2' 
                    # , 'COc1ccc2c(c1)c(CC(=O)O)c(C)n2C(=O)c1ccc(Cl)cc1' , 'CC1(C)[C@H](C(=O)O)N2C(=O)C[C@H]2S1(=O)=O' ,
                    #  'CN1CCN(c2cc3c(cc2F)c(=O)c(C(=O)O)cn3-c2ccc(F)cc2)CC1' , 'C[C@]1(Cn2ccnn2)[C@H](C(=O)O)N2C(=O)C[C
                    # @H]2S1(=O)=O'
                    'standard_inchi': 'TEXT',
                    # EXAMPLES:
                    # 'InChI=1S/C19H21N5O4/c1-26-15-10-12-13(11-16(15)27-2)21-19(22-17(12)20)24-7-5-23(6-8-24)18(25)14-4
                    # -3-9-28-14/h3-4,9-11H,5-8H2,1-2H3,(H2,20,21,22)' , 'InChI=1S/C10H14N2/c1-12-7-3-5-10(12)9-4-2-6-11
                    # -8-9/h2,4,6,8,10H,3,5,7H2,1H3/t10-/m0/s1' , 'InChI=1S/C18H20FN3O4/c1-10-9-26-17-14-11(16(23)12(18(
                    # 24)25)8-22(10)14)7-13(19)15(17)21-5-3-20(2)4-6-21/h7-8,10H,3-6,9H2,1-2H3,(H,24,25)' , 'InChI=1S/C1
                    # 2H12N2O3/c1-3-14-6-9(12(16)17)10(15)8-5-4-7(2)13-11(8)14/h4-6H,3H2,1-2H3,(H,16,17)' , 'InChI=1S/C1
                    # 4H6O8/c15-5-1-3-7-8-4(14(20)22-11(7)9(5)17)2-6(16)10(18)12(8)21-13(3)19/h1-2,15-18H' , 'InChI=1S/C
                    # 36H38F4N4O2S/c1-3-42(4-2)20-21-43(22-25-8-12-27(13-9-25)28-14-16-29(17-15-28)36(38,39)40)33(45)23-
                    # 44-32-7-5-6-31(32)34(46)41-35(44)47-24-26-10-18-30(37)19-11-26/h8-19H,3-7,20-24H2,1-2H3' , 'InChI=
                    # 1S/C19H16ClNO4/c1-11-15(10-18(22)23)16-9-14(25-2)7-8-17(16)21(11)19(24)12-3-5-13(20)6-4-12/h3-9H,1
                    # 0H2,1-2H3,(H,22,23)' , 'InChI=1S/C8H11NO5S/c1-8(2)6(7(11)12)9-4(10)3-5(9)15(8,13)14/h5-6H,3H2,1-2H
                    # 3,(H,11,12)/t5-,6+/m1/s1' , 'InChI=1S/C21H19F2N3O3/c1-24-6-8-25(9-7-24)19-11-18-15(10-17(19)23)20(
                    # 27)16(21(28)29)12-26(18)14-4-2-13(22)3-5-14/h2-5,10-12H,6-9H2,1H3,(H,28,29)' , 'InChI=1S/C10H12N4O
                    # 5S/c1-10(5-13-3-2-11-12-13)8(9(16)17)14-6(15)4-7(14)20(10,18)19/h2-3,7-8H,4-5H2,1H3,(H,16,17)/t7-,
                    # 8+,10+/m1/s1'
                    'standard_inchi_key': 'TEXT',
                    # EXAMPLES:
                    # 'IENZQIKPVFGBNW-UHFFFAOYSA-N' , 'SNICXCGAKADSCV-JTQLQIEISA-N' , 'GSDSWSVVBLHKDQ-UHFFFAOYSA-N' , 'M
                    # HWLWQUZZRMNGJ-UHFFFAOYSA-N' , 'AFSDNFLWKVMVRB-UHFFFAOYSA-N' , 'WDPFJWLDPVQCAJ-UHFFFAOYSA-N' , 'CGI
                    # GDMFJXJATDK-UHFFFAOYSA-N' , 'FKENQMMABCRJMK-RITPCOANSA-N' , 'NOCJXYPHIIZEHN-UHFFFAOYSA-N' , 'LPQZK
                    # KCYTLCDGQ-WEDXCCLWSA-N'
                }
            },
            'molecule_synonyms': 
            {
                'properties': 
                {
                    'molecule_synonym': 'TEXT',
                    # EXAMPLES:
                    # 'CP-12299' , 'Habitrol' , 'DL-8280' , 'Mictral' , 'Benzoaric Acid' , 'Darapladib' , 'Artracin' , '
                    # CP-45899' , 'Difloxacin' , 'CL-298741'
                    'syn_type': 'TEXT',
                    # EXAMPLES:
                    # 'RESEARCH_CODE' , 'TRADE_NAME' , 'RESEARCH_CODE' , 'TRADE_NAME' , 'OTHER' , 'INN' , 'TRADE_NAME' ,
                    #  'RESEARCH_CODE' , 'INN' , 'RESEARCH_CODE'
                    'synonyms': 'TEXT',
                    # EXAMPLES:
                    # 'CP-12299' , 'HABITROL' , 'DL-8280' , 'MICTRAL' , 'BENZOARIC ACID' , 'DARAPLADIB' , 'ARTRACIN' , '
                    # CP-45899' , 'DIFLOXACIN' , 'CL 298,741'
                }
            },
            'ob_patent': 'NUMERIC',
            # EXAMPLES:
            # '8323683' , '8734847' , '6207661' , '6589960' , '6780881' , '6284804' , '6403616' , '6395294' , '6384020' 
            # , '6465463'
            'oral': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'True' , 'True' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False'
            'parenteral': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'True' , 'False' , 'False' , 'False' , 'True' , 'True' , 'False' , 'True'
            'prodrug': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
            'research_codes': 'TEXT',
            # EXAMPLES:
            # 'CP-122991' , 'NSC-97238' , 'HOE-280' , 'WIN-18320' , 'NSC-407286' , 'SB-480848' , 'NSC-77541' , 'CP-45899
            # 2' , 'ABBOTT-56619' , 'CL-307579'
            'rule_of_five': 'BOOLEAN',
            # EXAMPLES:
            # 'True' , 'True' , 'True' , 'True' , 'True' , 'False' , 'True' , 'True' , 'True' , 'True'
            'sc_patent': 'TEXT',
            # EXAMPLES:
            # 'US-8323683-B2' , 'US-8734847-B2' , 'US-6207661-B1' , 'US-6589960-B2' , 'US-6780881-B2' , 'US-6284804-B1' 
            # , 'US-6403616-B1' , 'US-6395294-B1' , 'US-6384020-B1' , 'US-6465463-B1'
            'synonyms': 'TEXT',
            # EXAMPLES:
            # 'Prazosin HCl (FDA, JAN, MI, USAN, USP)' , 'Nicotine Bitartrate (MI, USAN)' , 'Ofloxacin (BAN, FDA, INN, J
            # AN, MI, USAN, USP)' , 'Nalidixate Sodium (USAN)' , 'Ellagic Acid (DCF, INN, MI)' , 'Darapladib (INN, JAN, 
            # MI, USAN)' , 'Indometacin sodium (JAN)' , 'Sulbactam Sodium (FDA, JAN, USAN, USP)' , 'Difloxacin (INN)' , 
            # 'Tazobactam sodium (FDA, USAN)'
            'topical': 'BOOLEAN',
            # EXAMPLES:
            # 'False' , 'True' , 'True' , 'False' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False'
            'usan_stem': 'TEXT',
            # EXAMPLES:
            # '-azosin' , '-oxacin' , 'nal-' , '-pladib' , '-bactam' , '-oxacin' , '-bactam' , '-oxacin' , '-oxacin' , '
            # -dipine'
            'usan_stem_definition': 'TEXT',
            # EXAMPLES:
            # 'antihypertensives (prazosin type)' , 'antibacterials (quinolone derivatives)' , 'narcotic agonists/antago
            # nists (normorphine type)' , 'phospholipase A2 inhibitors' , 'beta-lactamase inhibitors' , 'antibacterials 
            # (quinolone derivatives)' , 'beta-lactamase inhibitors' , 'antibacterials (quinolone derivatives)' , 'antib
            # acterials (quinolone derivatives)' , 'phenylpyridine vasodilators (nifedipine type)'
            'usan_stem_substem': 'TEXT',
            # EXAMPLES:
            # '-azosin(-azosin)' , '-oxacin(-oxacin)' , 'nal-(nal-)' , '-pladib(-pladib)' , '-bactam(-bactam)' , '-oxaci
            # n(-oxacin)' , '-bactam(-bactam)' , '-oxacin(-oxacin)' , '-oxacin(-oxacin)' , '-dipine(-dipine)'
            'usan_year': 'NUMERIC',
            # EXAMPLES:
            # '1968' , '1985' , '1984' , '1962' , '2005' , '1963' , '1980' , '1986' , '1989' , '1987'
            'withdrawn_class': 'TEXT',
            # EXAMPLES:
            # 'Hepatotoxicity' , 'Cardiotoxicity' , 'Cardiotoxicity' , 'Hepatotoxicity' , 'Hepatotoxicity' , 'Gastrotoxi
            # city' , 'Hepatotoxicity' , 'Misuse' , 'Psychiatric toxicity' , 'Hepatotoxicity'
            'withdrawn_country': 'TEXT',
            # EXAMPLES:
            # 'United States' , 'United States' , 'European Union; United States' , 'United Kingdom; United States; Euro
            # pean Union; Canada; Malasia; India; Saudi Arabia' , 'European Union' , 'European Union; United States' , '
            # United States' , 'Canada; Italy; Argentina' , 'United States' , 'Norway'
            'withdrawn_reason': 'TEXT',
            # EXAMPLES:
            # 'Hepatotoxicity' , 'Life-threatening ventricular arrhythmias (especially torsade de pointes)' , 'Cardiac v
            # alvular disease' , 'Liver injury' , 'Hepatotoxicity' , 'Increased risk of dysglycemia' , 'Hepatic necrosis
            # ' , 'Self-poisonings' , 'Psychiatric effects, especially depression' , 'Hepatotoxicity'
            'withdrawn_year': 'NUMERIC',
            # EXAMPLES:
            # '1997' , '2001' , '1997' , '2007' , '1999' , '2006' , '1996' , '1980' , '2006' , '1986'
        }
    }

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
                'applicants': 'TEXT',
                # EXAMPLES:
                # 'Idt Australia Ltd' , 'Wyeth Pharmaceuticals Inc' , 'Pf Prism Cv' , 'Valeant Pharmaceuticals North Ame
                # rica Llc' , 'Sandoz Inc' , 'Sandoz Inc' , 'Beximco Pharmaceuticals Usa Inc' , 'Sandoz Inc' , 'Zydus Ph
                # armaceuticals Usa Inc' , 'Takeda Pharmaceuticals Usa Inc'
                'atc_classification': 
                {
                    'properties': 
                    {
                        'code': 'TEXT',
                        # EXAMPLES:
                        # 'N05AL03' , 'L03AB07' , 'L01XC05' , 'N06AX23' , 'J01CE04' , 'B01AE01' , 'J01FA11' , 'C03AA06' 
                        # , 'R05DB15' , 'N05BB51'
                        'description': 'TEXT',
                        # EXAMPLES:
                        # 'NERVOUS SYSTEM: PSYCHOLEPTICS: ANTIPSYCHOTICS: Benzamides' , 'ANTINEOPLASTIC AND IMMUNOMODULA
                        # TING AGENTS: IMMUNOSTIMULANTS: IMMUNOSTIMULANTS: Interferons' , 'ANTINEOPLASTIC AND IMMUNOMODU
                        # LATING AGENTS: ANTINEOPLASTIC AGENTS: OTHER ANTINEOPLASTIC AGENTS: Monoclonal antibodies' , 'N
                        # ERVOUS SYSTEM: PSYCHOANALEPTICS: ANTIDEPRESSANTS: Other antidepressants' , 'ANTIINFECTIVES FOR
                        #  SYSTEMIC USE: ANTIBACTERIALS FOR SYSTEMIC USE: BETA-LACTAM ANTIBACTERIALS, PENICILLINS: Beta-
                        # lactamase sensitive penicillins' , 'BLOOD AND BLOOD FORMING ORGANS: ANTITHROMBOTIC AGENTS: ANT
                        # ITHROMBOTIC AGENTS: Direct thrombin inhibitors' , 'ANTIINFECTIVES FOR SYSTEMIC USE: ANTIBACTER
                        # IALS FOR SYSTEMIC USE: MACROLIDES, LINCOSAMIDES AND STREPTOGRAMINS: Macrolides' , 'CARDIOVASCU
                        # LAR SYSTEM: DIURETICS: LOW-CEILING DIURETICS, THIAZIDES: Thiazides, plain' , 'RESPIRATORY SYST
                        # EM: COUGH AND COLD PREPARATIONS: COUGH SUPPRESSANTS, EXCL. COMBINATIONS WITH EXPECTORANTS: Oth
                        # er cough suppressants' , 'NERVOUS SYSTEM: PSYCHOLEPTICS: ANXIOLYTICS: Diphenylmethane derivati
                        # ve'
                    }
                },
                'availability_type': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '1' , '-1' , '-1' , '-1' , '1'
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
                                # '6732' , '18545' , '6725' , '6725' , '18548' , '6738' , '6397' , '18561' , '6720' , '1
                                # 8576'
                                'component_type': 'TEXT',
                                # EXAMPLES:
                                # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'P
                                # ROTEIN' , 'PROTEIN' , 'PROTEIN'
                                'description': 'TEXT',
                                # EXAMPLES:
                                # 'Interferon beta precursor' , 'PRABOTULINUMTOXIN A Neurotoxin heavy chain' , 'Purified
                                #  porcine insulin zinc suspension' , 'Purified porcine insulin zinc suspension' , 'OMBU
                                # RTAMAB Heavy chain' , 'Interleukin-11 precursor' , 'Demcizumab heavy chain' , 'CEMIPLI
                                # MAB Heavy Chain' , 'Purified bovine insulin zinc suspension' , 'RASDEGAFUSP ALFA Heavy
                                #  chain'
                                'organism': 'TEXT',
                                # EXAMPLES:
                                # 'Homo sapiens' , 'Sus scrofa' , 'Sus scrofa' , 'Homo sapiens' , 'Bos taurus' , 'Sus sc
                                # rofa' , 'Homo sapiens' , 'Homo sapiens' , 'Sus scrofa' , 'Homo sapiens'
                                'sequence': 'TEXT',
                                # EXAMPLES:
                                # 'MTNKCLLQIALLLCFSTTALSMSYNLLGFLQRSSNFQCQKLLWQLNGRLEYCLKDRMNFDIPEEIKQLQQFQKEDAALTIYEMLQ
                                # NIFAIFRQDSSSTGWNETIVENLLANVYHQINHLKTVLEEKLEKEDFTRGKLMSSLHLKRYYGRILHYLKAKEYSHCAWTIVRVEI
                                # LRNFYFINRLTGYLRN' , 'ALNDLCIKVNNWDLFFSPSEDNFTNDLNKGEEITSDTNIEAAEENISLDLIQQYYLTFNFDNEPE
                                # NISIENLSSDIIGQLELMPNIERFPNGKKYELDKYTMFHYLRAQEFEHGKSRIALTNSVNEALLNPSRVYTFFSSDYVKKVNKATE
                                # AAMFLGWVEQLVYDFTDETSEVSTTDKIPDITIIIPYIGPALNIGNMLYKDDFVGALIFSGAVILLEFIPEIAIPVLGTFALVSYI
                                # ANKVLTVQTIDNALSKRNEKWDEVYKYIVTNWLAKVNTQIDLIRKKMKEALENQAEATKAIINYQYNQYTEEEKNNINFNIDDLSS
                                # KLNESINKAMININKFLNQCSVSYLMNSMIPYGVKRLEDFDASLKDALLKYIYDNRGTLIGQVDRLKDKVNNTLSTDIPFQLSKYV
                                # DNQRLLSTFTEYIKNIINTSILNLRYESNHLIDLSRYASKINIGSKVNFDPIDKNQIQLFNLESSKIEVILKNAIVYNSMYENFST
                                # SFWIRIPKYFNSISLNNEYTIINCMENNSGWKVSLNYGEIIWTLQDTQEIKQRVVFKYSQMINISDYINRWIFVTITNNRLNNSKI
                                # YINGRLIDQKPISNLGNIHASNNIMFKLDGCRDTHRYIWIKYFNLFDKELNEKEIKDLYDNQSNSGILKDFWGDYLQYDKPYYMLN
                                # LYDPNKYVDVNNVGIRGYMYLKGPRGSVMTTNIYLNSSLYRGTKFIIKKYASGNKDNIVRNNDRVYINVVVKNKEYRLATNASQAG
                                # VEKILSALEIPDVGNLSQVVVMKSKNDQGITNKCKMNLQDNNGNDIGFIGFHQFNNIAKLVASNWYNRQIERSSRTLGCSWEFIPV
                                # DDGWGERPL' , 'MALWTRLLPLLALLALWAPAPAQAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREAENPQAGAVELGGGL
                                # GGLQALALEGPPQKRGIVEQCCTSICSLYQLENYCN' , 'MALWTRLLPLLALLALWAPAPAQAFVNQHLCGSHLVEALYLVCGE
                                # RGFFYTPKARREAENPQAGAVELGGGLGGLQALALEGPPQKRGIVEQCCTSICSLYQLENYCN' , 'QVQLQQSGAELVKPGASV
                                # KLSCKASGYTFTNYDINWVRQRPEQGLEWIGWIFPGDGSTQYNEKFKGKATLTTDTSSSTAYMQLSRLTSEDSAVYFCARQTTATW
                                # FAYWGQGTLVTVSAAKTTPPSVYPLAPGSAAQTNSMVTLGCLVKGYFPEPVTVTWNSGSLSSGVHTFPAVLQSDLYTLSSSVTVPS
                                # STWPSETVTCNVAHPASSTKVDKKIVPRDCGCKPCICTVPEVSSVFIFPPKPKDVLTITLTPKVTCVVVDISKDDPEVQFSWFVDD
                                # VEVHTAQTQPREEQFNSTFRSVSELPIMHQDWLNGKEFKCRVNSAAFPAPIEKTISKTKGRPKAPQVYTIPPPKEQMAKDKVSLTC
                                # MITDFFPEDITVEWQWNGQPAENYKNTQPIMDTDGSYFVYSKLNVQKSNWEAGNTFTCSVLHEGLHNHHTEKSLSHSPGK' , 'M
                                # NCVCRLVLVVLSLWPDTAVAPGPPPGPPRVSPDPRAELDSTVLLTRSLLADTRQLAAQLRDKFPADGDHNLDSLPTLAMSAGALGA
                                # LQLPGVLTRLRADLLSYLRHVQWLRRAGGSSLKTLEPELGTLQARLDRLLRRLQLLMSRLALPQPPPDPPAPPLAPPSSAWGGIRA
                                # AHAILGGLHLTLDWAVRGLLLLKTRL' , 'QVQLVQSGAEVKKPGASVKISCKASGYSFTAYYIHWVKQAPGQGLEWIGYISSYN
                                # GATNYNQKFKGRVTFTTDTSTSTAYMELRSLRSDDTAVYYCARDYDYDVGMDYWGQGTLVTVSSASTKGPSVFPLAPCSRSTSEST
                                # AALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSNFGTQTYTCNVDHKPSNTKVDKTVERKCCVECPP
                                # CPAPPVAGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVQFNWYVDGVEVHNAKTKPREEQFNSTFRVVSVLTVVHQDWLN
                                # GKEYKCKVSNKGLPAPIEKTISKTKGQPREPQVYTLPPSREEMTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPMLDSD
                                # GSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPG' , 'EVQLLESGGVLVQPGGSLRLSCAASGFTFSNFGMTW
                                # VRQAPGKGLEWVSGISGGGRDTYFADSVKGRFTISRDNSKNTLYLQMNSLKGEDTAVYYCVKWGNIYFDYWGQGTLVTVSSASTKG
                                # PSVFPLAPCSRSTSESTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTKTYTCNVDHKPSN
                                # TKVDKRVESKYGPPCPPCPAPEFLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSQEDPEVQFNWYVDGVEVHNAKTKPREEQFN
                                # STYRVVSVLTVLHQDWLNGKEYKCKVSNKGLPSSIEKTISKAKGQPREPQVYTLPPSQEEMTKNQVSLTCLVKGFYPSDIAVEWES
                                # NGQPENNYKTTPPVLDSDGSFFLYSRLTVDKSRWQEGNVFSCSVMHEALHNHYTQKSLSLSLGK' , 'MALWTRLRPLLALLALW
                                # PPPPARAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVGALELAGGPGAGGLEGPPQKRGIVEQCCASVCSLYQLENY
                                # CN' , 'MEFGLSWVFLVALLRGVQCQVQLVESGGGVVQPGRSLRLSCAASGFTFSNYGMYWVRQAPGKGLEWVAVIWYDGSNKYY
                                # ADSVKGRFTISRDNSKNTLYLQMNSLRAEDTAVYYCARDLWGWYFDYWGQGTLVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCL
                                # VKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPA
                                # PELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGK
                                # EYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGS
                                # FFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGKGSRQAEGRGTGGSTGDADGPGGPGIPDGPGGNAGGPGEAGAT
                                # GGRGPRGAGAARASGPGGGAPRGPHGGAASGLNGCCRCGARGPESRLLEFYLAMPFATPMEAELARRSLAQDAPPLPVPGVLLKEF
                                # TVSGNILTIRLTAADHRQLQLSISSCLQQLSLLMWITQCFLPVFLAQPPSGQRR'
                                'tax_id': 'NUMERIC',
                                # EXAMPLES:
                                # '9606' , '9823' , '9823' , '9606' , '9913' , '9823' , '9606' , '9606' , '9823' , '9606
                                # '
                            }
                        },
                        'description': 'TEXT',
                        # EXAMPLES:
                        # 'Interferon beta precursor (IFN-beta) (Fibroblast interferon)' , 'Immunoglobulin G 4 (human-mo
                        # use monocional hP67.674-chain anti-human antigen CD 33), disulfide with human-mouse monoclonal
                        #  hP67.6x-chain, dimer' , 'Morolimumab (human mab)' , 'BrE-3 (humanized mab)' , 'Bovine/porcine
                        #  insulin zinc protamine suspension' , 'Prompt purified porcine insulin zinc suspension' , 'T84
                        # .66 (mab)' , 'BW250/183 (mab)' , 'TRC-093 (mab)' , 'FG-3019 (mab)'
                        'helm_notation': 'TEXT',
                        # EXAMPLES:
                        # 'PEPTIDE1{A.[X1521].[X1520]}$$$$' , 'PEPTIDE1{[Glp].H.W.S.Y.[d1-Nal].L.R.P.G.[am]}$$$$' , 'PEP
                        # TIDE1{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W.Y.Q.Q.K.
                        # P.G.K.A.P.K.L.L.I.Y.K.V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.
                        # Y.C.S.Q.N.T.L.V.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.
                        # C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.
                        # L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.
                        # G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.G.I.A.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.F.I.S.D.L.A.
                        # Y.T.I.Y.Y.A.D.T.V.T.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.N.W.D.
                        # A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.
                        # F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.
                        # T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.
                        # P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.
                        # P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.
                        # K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.
                        # G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.
                        # L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.
                        # F.T.F.S.D.Y.G.I.A.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.F.I.S.D.L.A.Y.T.I.Y.Y.A.D.T.V.T.G.R.F.T.I.S.R.D.
                        # N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.N.W.D.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.
                        # K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.
                        # H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.
                        # V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.
                        # V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.
                        # L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.
                        # E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.
                        # S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEP
                        # TIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W.Y.Q.Q.K.
                        # P.G.K.A.P.K.L.L.I.Y.K.V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.
                        # Y.C.S.Q.N.T.L.V.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.
                        # C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.
                        # L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE3,229:R3-
                        # 229:R3|PEPTIDE1,PEPTIDE1,23:R3-93:R3|PEPTIDE3,PEPTIDE3,261:R3-321:R3|PEPTIDE2,PEPTIDE1,220:R3-
                        # 219:R3|PEPTIDE2,PEPTIDE2,144:R3-200:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-9
                        # 6:R3|PEPTIDE2,PEPTIDE3,226:R3-226:R3|PEPTIDE3,PEPTIDE4,220:R3-219:R3|PEPTIDE3,PEPTIDE3,367:R3-
                        # 425:R3|PEPTIDE2,PEPTIDE2,261:R3-321:R3|PEPTIDE4,PEPTIDE4,139:R3-199:R3|PEPTIDE3,PEPTIDE3,144:R
                        # 3-200:R3|PEPTIDE2,PEPTIDE2,367:R3-425:R3|PEPTIDE4,PEPTIDE4,23:R3-93:R3|PEPTIDE1,PEPTIDE1,139:R
                        # 3-199:R3$$$' , 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.D.I.N.S.Y.L.S.W
                        # .F.Q.Q.K.P.G.K.A.P.K.S.L.I.V.R.A.N.R.L.V.D.G.V.P.S.R.F.S.G.S.G.S.G.Q.D.Y.S.L.T.I.S.S.L.Q.P.E.D
                        # .F.A.T.Y.Y.C.L.Q.Y.D.A.F.P.P.Y.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G
                        # .T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L
                        # .S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q
                        # .L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.T.M.L.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.I
                        # .I.K.S.G.G.S.Y.S.Y.Y.P.D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A
                        # .R.D.G.D.Y.G.S.S.Y.G.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T
                        # .A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V
                        # .T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E
                        # .A.A.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D
                        # .G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A
                        # .L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P
                        # .S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N
                        # .V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G
                        # .S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.T.M.L.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.I.I.K.S.G.G.S.Y.S.Y.Y.P.D.S
                        # .V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.G.D.Y.G.S.S.Y.G.A.M.D
                        # .Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E
                        # .P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I
                        # .C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.A.A.G.G.P.S.V.F.L.F.P.P.K
                        # .P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E
                        # .E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K
                        # .G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P
                        # .E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N
                        # .H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.D.I
                        # .N.S.Y.L.S.W.F.Q.Q.K.P.G.K.A.P.K.S.L.I.V.R.A.N.R.L.V.D.G.V.P.S.R.F.S.G.S.G.S.G.Q.D.Y.S.L.T.I.S
                        # .S.L.Q.P.E.D.F.A.T.Y.Y.C.L.Q.Y.D.A.F.P.P.Y.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D
                        # .E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K
                        # .D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PE
                        # PTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE2,PEPTIDE2,266:R3-326:R3|PEPTIDE3,PEPTIDE3,149:R3-205:R3|PE
                        # PTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3|PEPTIDE2,PEPTIDE2,372:R3-430:R3|PEPT
                        # IDE2,PEPTIDE1,225:R3-215:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3|PEPTIDE4,PEPTIDE4,135:R3-195:R3|PE
                        # PTIDE3,PEPTIDE3,372:R3-430:R3|PEPTIDE3,PEPTIDE4,225:R3-215:R3|PEPTIDE2,PEPTIDE3,234:R3-234:R3|
                        # PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE3,PEPTIDE3,266:R3-326:R3|PEPTIDE1,PEPTIDE1,135:R3-195:R3|
                        # PEPTIDE2,PEPTIDE2,149:R3-205:R3$$$' , 'PEPTIDE1{[dNal].C.Y.[dW].K.V.C.T.[am]}$PEPTIDE1,PEPTIDE
                        # 1,7:R3-2:R3$$$' , 'PEPTIDE1{R.P.P.G.F.S.P.F.R}$$$$' , 'PEPTIDE1{C.C.E.Y.C.C.N.P.A.C.T.G.C.Y}$P
                        # EPTIDE1,PEPTIDE1,10:R3-2:R3|PEPTIDE1,PEPTIDE1,6:R3-1:R3|PEPTIDE1,PEPTIDE1,13:R3-5:R3$$$' , 'PE
                        # PTIDE1{H.[dF].R.W.K}|PEPTIDE2{[ac].[Nle].D}$PEPTIDE2,PEPTIDE1,3:R2-1:R1|PEPTIDE2,PEPTIDE1,3:R3
                        # -5:R3$$$' , 'PEPTIDE1{C.K.G.K.G.A.K.C.S.R.L.M.Y.D.C.C.T.G.S.C.R.S.G.K.C.[am]}$PEPTIDE1,PEPTIDE
                        # 1,20:R3-8:R3|PEPTIDE1,PEPTIDE1,25:R3-15:R3|PEPTIDE1,PEPTIDE1,16:R3-1:R3$$$' , 'PEPTIDE1{P.V.T.
                        # K.P.Q.[dA].[am]}$$$$'
                        'molecule_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL1201562' , 'CHEMBL1201506' , 'CHEMBL2109138' , 'CHEMBL4297229' , 'CHEMBL2109363' , 'CHE
                        # MBL1201628' , 'CHEMBL1201643' , 'CHEMBL4297233' , 'CHEMBL2109370' , 'CHEMBL2109371'
                    }
                },
                'black_box': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'chirality': 'NUMERIC',
                # EXAMPLES:
                # '2' , '1' , '0' , '-1' , '-1' , '1' , '1' , '0' , '2' , '1'
                'development_phase': 'NUMERIC',
                # EXAMPLES:
                # '3' , '2' , '0' , '0' , '1' , '4' , '3' , '0' , '0' , '4'
                'drug_type': 'NUMERIC',
                # EXAMPLES:
                # '1' , '7' , '1' , '1' , '-1' , '5' , '7' , '1' , '1' , '1'
                'first_approval': 'NUMERIC',
                # EXAMPLES:
                # '1996' , '1975' , '2000' , '2008' , '2003' , '1994' , '1960' , '1956' , '2019' , '1995'
                'first_in_class': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'helm_notation': 'TEXT',
                # EXAMPLES:
                # 'PEPTIDE1{A.[X1521].[X1520]}$$$$' , 'PEPTIDE1{[Glp].H.W.S.Y.[d1-Nal].L.R.P.G.[am]}$$$$' , 'PEPTIDE1{D.
                # I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.
                # I.Y.K.V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.S.Q.N.T.L.V.P.W.T.F.
                # G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.
                # V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.
                # L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.
                # G.I.A.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.F.I.S.D.L.A.Y.T.I.Y.Y.A.D.T.V.T.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.
                # N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.N.W.D.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.
                # T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.
                # V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.
                # G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.
                # K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.
                # A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.
                # N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.
                # L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.G.I.A.W.V.R.Q.
                # A.P.G.K.G.L.E.W.V.A.F.I.S.D.L.A.Y.T.I.Y.Y.A.D.T.V.T.G.R.F.T.I.S.R.D.N.S.K.N.T.L.Y.L.Q.M.N.S.L.R.A.E.D.
                # T.A.V.Y.Y.C.A.R.D.N.W.D.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.
                # L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.
                # L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.
                # P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.
                # Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.
                # P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.
                # V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}
                # |PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.S.S.Q.S.L.V.H.N.N.A.N.T.Y.L.H.W.Y.Q.Q.K.P.G.
                # K.A.P.K.L.L.I.Y.K.V.S.N.R.F.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.S.Q.N.T.
                # L.V.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.
                # A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.
                # E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE3,229:R3-229:R3|PEPTIDE1,PEPTIDE1,23:R3-93:R3
                # |PEPTIDE3,PEPTIDE3,261:R3-321:R3|PEPTIDE2,PEPTIDE1,220:R3-219:R3|PEPTIDE2,PEPTIDE2,144:R3-200:R3|PEPTI
                # DE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE3,226:R3-226:R3|PEPTIDE3,PEPTID
                # E4,220:R3-219:R3|PEPTIDE3,PEPTIDE3,367:R3-425:R3|PEPTIDE2,PEPTIDE2,261:R3-321:R3|PEPTIDE4,PEPTIDE4,139
                # :R3-199:R3|PEPTIDE3,PEPTIDE3,144:R3-200:R3|PEPTIDE2,PEPTIDE2,367:R3-425:R3|PEPTIDE4,PEPTIDE4,23:R3-93:
                # R3|PEPTIDE1,PEPTIDE1,139:R3-199:R3$$$' , 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S
                # .Q.D.I.N.S.Y.L.S.W.F.Q.Q.K.P.G.K.A.P.K.S.L.I.V.R.A.N.R.L.V.D.G.V.P.S.R.F.S.G.S.G.S.G.Q.D.Y.S.L.T.I.S.S
                # .L.Q.P.E.D.F.A.T.Y.Y.C.L.Q.Y.D.A.F.P.P.Y.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S
                # .G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T
                # .L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G
                # .L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.T.M.L.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.I.I.K.S.G.G.S.Y.S.Y.Y.P
                # .D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.G.D.Y.G.S.S.Y.G.A.M.D.Y.W
                # .G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W
                # .N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T
                # .K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.A.A.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T
                # .C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q
                # .D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q
                # .V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D
                # .K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V
                # .Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.D.Y.T.M.L.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.I.I.K.S.G.G.S.Y.S.Y.Y.P.D.S
                # .V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.D.G.D.Y.G.S.S.Y.G.A.M.D.Y.W.G.Q
                # .G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S
                # .G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V
                # .D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.A.A.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V
                # .V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W
                # .L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S
                # .L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S
                # .R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S
                # .V.G.D.R.V.T.I.T.C.R.A.S.Q.D.I.N.S.Y.L.S.W.F.Q.Q.K.P.G.K.A.P.K.S.L.I.V.R.A.N.R.L.V.D.G.V.P.S.R.F.S.G.S
                # .G.S.G.Q.D.Y.S.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.L.Q.Y.D.A.F.P.P.Y.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V
                # .F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q
                # .D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPT
                # IDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE2,PEPTIDE2,266:R3-326:R3|PEPTIDE3,PEPTIDE3,149:R3-205:R3|PEPTIDE2,PEP
                # TIDE2,22:R3-96:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3|PEPTIDE2,PEPTIDE2,372:R3-430:R3|PEPTIDE2,PEPTIDE1,225:
                # R3-215:R3|PEPTIDE2,PEPTIDE3,231:R3-231:R3|PEPTIDE4,PEPTIDE4,135:R3-195:R3|PEPTIDE3,PEPTIDE3,372:R3-430
                # :R3|PEPTIDE3,PEPTIDE4,225:R3-215:R3|PEPTIDE2,PEPTIDE3,234:R3-234:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPT
                # IDE3,PEPTIDE3,266:R3-326:R3|PEPTIDE1,PEPTIDE1,135:R3-195:R3|PEPTIDE2,PEPTIDE2,149:R3-205:R3$$$' , 'PEP
                # TIDE1{[dNal].C.Y.[dW].K.V.C.T.[am]}$PEPTIDE1,PEPTIDE1,7:R3-2:R3$$$' , 'PEPTIDE1{R.P.P.G.F.S.P.F.R}$$$$
                # ' , 'PEPTIDE1{C.C.E.Y.C.C.N.P.A.C.T.G.C.Y}$PEPTIDE1,PEPTIDE1,10:R3-2:R3|PEPTIDE1,PEPTIDE1,6:R3-1:R3|PE
                # PTIDE1,PEPTIDE1,13:R3-5:R3$$$' , 'PEPTIDE1{H.[dF].R.W.K}|PEPTIDE2{[ac].[Nle].D}$PEPTIDE2,PEPTIDE1,3:R2
                # -1:R1|PEPTIDE2,PEPTIDE1,3:R3-5:R3$$$' , 'PEPTIDE1{C.K.G.K.G.A.K.C.S.R.L.M.Y.D.C.C.T.G.S.C.R.S.G.K.C.[a
                # m]}$PEPTIDE1,PEPTIDE1,20:R3-8:R3|PEPTIDE1,PEPTIDE1,25:R3-15:R3|PEPTIDE1,PEPTIDE1,16:R3-1:R3$$$' , 'PEP
                # TIDE1{P.V.T.K.P.Q.[dA].[am]}$$$$'
                'indication_class': 'TEXT',
                # EXAMPLES:
                # 'Inhibitor (alpha-glucosidase); Antiviral' , 'Bronchodilator' , 'Biological Response Modifier; Antineo
                # plastic' , 'Antidepressant' , 'Inhibitor (decarboxylase)' , 'Analgesic' , 'Cardiac Depressant (anti-ar
                # rhythmic)' , 'Anticoagulant' , 'Regulator (calcium)' , 'Neuromuscular Blocking Agent'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL84158' , 'CHEMBL2110737' , 'CHEMBL1740' , 'CHEMBL3990064' , 'CHEMBL4297894' , 'CHEMBL1201562' ,
                #  'CHEMBL100259' , 'CHEMBL2110982' , 'CHEMBL564109' , 'CHEMBL1201236'
                'molecule_properties': 
                {
                    'properties': 
                    {
                        'alogp': 'NUMERIC',
                        # EXAMPLES:
                        # '1.17' , '-1.13' , '0.35' , '-2.85' , '3.13' , '1.15' , '-0.05' , '1.79' , '-0.32' , '4.29'
                        'aromatic_rings': 'NUMERIC',
                        # EXAMPLES:
                        # '1' , '0' , '1' , '1' , '1' , '2' , '1' , '2' , '2' , '2'
                        'cx_logd': 'NUMERIC',
                        # EXAMPLES:
                        # '0.02' , '-1.82' , '-1.63' , '-2.42' , '0.47' , '0.56' , '-2.53' , '-1.00' , '-8.22' , '3.59'
                        'cx_logp': 'NUMERIC',
                        # EXAMPLES:
                        # '0.46' , '-0.97' , '-0.43' , '-2.42' , '2.55' , '2.15' , '-1.21' , '-0.77' , '-5.47' , '4.18'
                        'cx_most_apka': 'NUMERIC',
                        # EXAMPLES:
                        # '13.23' , '12.93' , '9.69' , '9.70' , '4.28' , '2.35' , '4.01' , '2.39' , '10.11' , '8.16'
                        'cx_most_bpka': 'NUMERIC',
                        # EXAMPLES:
                        # '7.64' , '8.19' , '8.91' , '9.49' , '5.66' , '3.87' , '7.87' , '1.41' , '8.87' , '9.20'
                        'full_molformula': 'TEXT',
                        # EXAMPLES:
                        # 'C15H24N2O4S' , 'C12H21NO5' , 'C9H13NO3' , 'C6H4ClFeNa2O7' , 'C9H12N2O6' , 'C17H23NO' , 'C13H1
                        # 5N5O3' , 'C10H14N2O4' , 'C15H18N3O2+' , 'C23H25N6O8S3+'
                        'full_mwt': 'NUMERIC',
                        # EXAMPLES:
                        # '328.43' , '259.30' , '183.21' , '325.37' , '244.20' , '257.38' , '289.30' , '226.23' , '272.3
                        # 3' , '609.69'
                        'hba': 'NUMERIC',
                        # EXAMPLES:
                        # '5' , '6' , '4' , '7' , '2' , '6' , '5' , '3' , '11' , '2'
                        'hba_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '6' , '6' , '4' , '8' , '2' , '8' , '6' , '5' , '14' , '2'
                        'hbd': 'NUMERIC',
                        # EXAMPLES:
                        # '1' , '3' , '4' , '4' , '0' , '2' , '5' , '2' , '4' , '0'
                        'hbd_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '1' , '3' , '4' , '4' , '0' , '2' , '6' , '3' , '5' , '0'
                        'heavy_atoms': 'NUMERIC',
                        # EXAMPLES:
                        # '22' , '18' , '13' , '17' , '19' , '21' , '16' , '20' , '40' , '22'
                        'molecular_species': 'TEXT',
                        # EXAMPLES:
                        # 'NEUTRAL' , 'NEUTRAL' , 'BASE' , 'NEUTRAL' , 'BASE' , 'ACID' , 'ACID' , 'ACID' , 'ACID' , 'NEU
                        # TRAL'
                        'mw_freebase': 'NUMERIC',
                        # EXAMPLES:
                        # '328.43' , '259.30' , '183.21' , '325.37' , '244.20' , '257.38' , '289.30' , '226.23' , '272.3
                        # 3' , '609.69'
                        'mw_monoisotopic': 'NUMERIC',
                        # EXAMPLES:
                        # '328.1457' , '259.1420' , '183.0895' , '324.8790' , '244.0695' , '257.1780' , '289.1175' , '22
                        # 6.0954' , '272.1394' , '609.0891'
                        'num_lipinski_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '1' , '0' , '2' , '0'
                        'num_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '2' , '0'
                        'psa': 'NUMERIC',
                        # EXAMPLES:
                        # '75.71' , '90.23' , '72.72' , '124.78' , '12.47' , '109.86' , '115.81' , '80.09' , '205.46' , 
                        # '8.17'
                        'qed_weighted': 'NUMERIC',
                        # EXAMPLES:
                        # '0.78' , '0.56' , '0.51' , '0.44' , '0.82' , '0.49' , '0.28' , '0.81' , '0.09' , '0.70'
                        'ro3_pass': 'TEXT',
                        # EXAMPLES:
                        # 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
                        'rtb': 'NUMERIC',
                        # EXAMPLES:
                        # '8' , '3' , '3' , '2' , '3' , '5' , '4' , '5' , '10' , '0'
                    }
                },
                'molecule_structures': 
                {
                    'properties': 
                    {
                        'canonical_smiles': 'TEXT',
                        # EXAMPLES:
                        # 'CCN(CC)CCNC(=O)c1cc(S(C)(=O)=O)ccc1OC' , 'CCCC(=O)O[C@H]1CN2CC[C@H](O)[C@@H]2[C@@H](O)[C@@H]1
                        # O' , 'CNCC(O)c1ccc(O)c(O)c1' , 'O=c1ccn([C@@H]2O[C@H](CO)[C@@H](O)[C@H]2O)c(=O)[nH]1' , 'CN(C)
                        # CCC1(C)OCCC2=C1Cc1ccccc12' , 'CCCCOC(=O)C(=O)Nc1cccc(-c2nnn[nH]2)c1' , 'C[C@@](Cc1ccc(O)c(O)c1
                        # )(NN)C(=O)O' , 'Cc1cc(-c2ccccc2)n[n+](CCCC(=O)O)c1N' , 'C[n+]1ccc(SCC2=C(C(=O)O)N3C(=O)[C@@H](
                        # NC(=O)/C(=N\OC(C)(C)C(=O)O)c4csc(N)n4)[C@H]3[S+]([O-])C2)cc1' , 'Cn1c2c(c3ccccc31)CCN1C[C@@H]3
                        # CCCC[C@H]3C[C@@H]21'
                        'molfile': 'TEXT',
                        # EXAMPLES:
                        # '      RDKit          2D   22 22  0  0  0  0  0  0  0  0999 V2000    16.4813   -3.4973    0.00
                        # 00 C   0  0  0  0  0  0  0  0  0  0  0  0    15.7584   -3.0975    0.0000 C   0  0  0  0  0  0 
                        #  0  0  0  0  0  0    15.7439   -2.2726    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    15.
                        # 0251   -1.8727    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    14.3165   -2.2976    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0    14.3310   -3.1225    0.0000 C   0  0  0  0  0  0  0
                        #   0  0  0  0  0    15.0540   -3.5224    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    17.18
                        # 99   -3.0724    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    16.4958   -4.3222    0.0000 N
                        #    0  0  0  0  0  0  0  0  0  0  0  0    13.6225   -3.5475    0.0000 S   0  0  0  0  0  0  0  
                        # 0  0  0  0  0    16.4524   -1.8476    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    16.4379
                        #    -1.0227    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    17.2188   -4.7221    0.0000 C  
                        #  0  0  0  0  0  0  0  0  0  0  0  0    17.2334   -5.5511    0.0000 C   0  0  0  0  0  0  0  0 
                        #  0  0  0  0    17.9522   -5.9511    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0    17.9667  
                        #  -6.7760    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    18.6607   -5.5261    0.0000 C   0
                        #   0  0  0  0  0  0  0  0  0  0  0    19.3837   -5.9260    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0    12.9012   -3.1470    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    13.2042   -
                        # 4.2583    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    14.0292   -4.2583    0.0000 O   0  
                        # 0  0  0  0  0  0  0  0  0  0  0    18.6883   -7.1759    0.0000 C   0  0  0  0  0  0  0  0  0  
                        # 0  0  0   4  5  1  0   5  6  2  0   6  7  1  0   2  7  2  0   1  8  2  0   1  9  1  0   6 10  
                        # 1  0  11 12  1  0   3 11  1  0  13 14  1  0  15 16  1  0  17 18  1  0  15 17  1  0  14 15  1  
                        # 0   9 13  1  0  10 19  1  0   1  2  1  0  10 20  2  0   2  3  1  0  10 21  2  0   3  4  2  0  
                        # 16 22  1  0 M  END' , '      RDKit          2D   19 20  0  0  0  0  0  0  0  0999 V2000    -2.
                        # 4677    1.2375    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -3.1821    1.6500    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0    -3.8966    1.2375    0.0000 C   0  0  0  0  0  0  0
                        #   0  0  0  0  0    -3.8966    0.4125    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -3.18
                        # 22    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.4677    0.4125    0.0000 N
                        #    0  0  0  0  0  0  0  0  0  0  0  0    -1.6831    0.1576    0.0000 C   0  0  0  0  0  0  0  
                        # 0  0  0  0  0    -1.1981    0.8250    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.6830
                        #     1.4924    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.4280    2.2770    0.0000 O  
                        #  0  0  0  0  0  0  0  0  0  0  0  0    -2.4677    2.0625    0.0000 H   0  0  0  0  0  0  0  0 
                        #  0  0  0  0    -3.1821    2.4750    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -4.6111  
                        #   1.6500    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -4.6111    0.0000    0.0000 O   0
                        #   0  0  0  0  0  0  0  0  0  0  0    -5.3256    0.4125    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0    -6.0400    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -5.3256    
                        # 1.2375    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -6.7545    0.4125    0.0000 C   0  
                        # 0  0  0  0  0  0  0  0  0  0  0    -7.4690    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  
                        # 0  0  0   1  2  1  0   2  3  1  0   3  4  1  0   4  5  1  0   5  6  1  0   1  9  1  0   1  6  
                        # 1  0   6  7  1  0   7  8  1  0   8  9  1  0   9 10  1  1   1 11  1  6   2 12  1  6   3 13  1  
                        # 1   4 14  1  6  14 15  1  0  15 16  1  0  15 17  2  0  16 18  1  0  18 19  1  0 M  END' , '   
                        #    RDKit          2D   13 13  0  0  0  0  0  0  0  0999 V2000     3.9076    1.5548    0.0000 O
                        #    0  0  0  0  0  0  0  0  0  0  0  0     5.3365    2.3798    0.0000 O   0  0  0  0  0  0  0  
                        # 0  0  0  0  0     4.6221   -1.3327    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     6.0510
                        #    -2.1577    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     5.3365   -0.0952    0.0000 C  
                        #  0  0  0  0  0  0  0  0  0  0  0  0     4.6221    1.1423    0.0000 C   0  0  0  0  0  0  0  0 
                        #  0  0  0  0     5.3365    1.5548    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.6221  
                        #   0.3173    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.3365   -0.9202    0.0000 C   0
                        #   0  0  0  0  0  0  0  0  0  0  0     6.0510    0.3173    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0     6.0510    1.1423    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.0510   -
                        # 1.3327    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.7655   -2.5702    0.0000 C   0  
                        # 0  0  0  0  0  0  0  0  0  0  0   1  6  1  0   2  7  1  0   3  9  1  0   4 12  1  0   4 13  1 
                        #  0   5  8  1  0   5  9  1  0   5 10  2  0   6  7  1  0   6  8  2  0   7 11  2  0   9 12  1  0 
                        #  10 11  1  0 M  END' , '      RDKit          2D   17 18  0  0  0  0  0  0  0  0999 V2000    -0
                        # .1397    0.6175    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     0.5748    1.0300    0.000
                        # 0 C   0  0  0  0  0  0  0  0  0  0  0  0     0.5748    1.8550    0.0000 N   0  0  0  0  0  0  
                        # 0  0  0  0  0  0    -0.1397    2.2675    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.8
                        # 542    1.8550    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.8542    1.0300    0.0000 
                        # C   0  0  0  0  0  0  0  0  0  0  0  0     1.2892    0.6175    0.0000 O   0  0  0  0  0  0  0 
                        #  0  0  0  0  0    -0.1397    3.0925    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -0.139
                        # 7   -0.2075    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.5277   -0.6925    0.0000 C 
                        #   0  0  0  0  0  0  0  0  0  0  0  0     0.2728   -1.4771    0.0000 C   0  0  0  0  0  0  0  0
                        #   0  0  0  0    -0.5522   -1.4771    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.3124 
                        #   -0.4375    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     0.7577   -2.1445    0.0000 O   
                        # 0  0  0  0  0  0  0  0  0  0  0  0    -0.8071   -0.6925    0.0000 O   0  0  0  0  0  0  0  0  
                        # 0  0  0  0    -1.0371   -2.1445    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.7016   
                        # -2.8982    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0   2  1  1  0   6  1  1  0   9  1  1  
                        # 1   2  3  1  0   2  7  2  0   4  3  1  0   4  5  1  0   4  8  2  0   5  6  2  0   9 10  1  0  
                        #  9 15  1  0  10 11  1  0  10 13  1  6  11 12  1  0  11 14  1  6  12 15  1  0  12 16  1  1  16 
                        # 17  1  0 M  END' , '      RDKit          2D   19 21  0  0  0  0  0  0  0  0999 V2000     3.216
                        # 7   -1.9917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.9917   -1.3667    0.0000 C 
                        #   0  0  0  0  0  0  0  0  0  0  0  0     2.3000   -1.3667    0.0000 C   0  0  0  0  0  0  0  0
                        #   0  0  0  0     2.6667   -2.4417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.8917 
                        #   -2.1417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.0917   -2.0292    0.0000 C   
                        # 0  0  0  0  0  0  0  0  0  0  0  0     4.5917   -2.4292    0.0000 C   0  0  0  0  0  0  0  0  
                        # 0  0  0  0     4.3667   -1.6375    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     4.5917   
                        # -3.1250    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.8875   -3.5292    0.0000 N   0 
                        #  0  0  0  0  0  0  0  0  0  0  0     3.4875   -0.8250    0.0000 C   0  0  0  0  0  0  0  0  0 
                        #  0  0  0     4.1667   -0.9750    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.8125   -0
                        # .8625    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.5375   -2.8042    0.0000 C   0  0
                        #   0  0  0  0  0  0  0  0  0  0     1.4042   -2.2042    0.0000 C   0  0  0  0  0  0  0  0  0  0
                        #   0  0     4.1542   -4.1792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.2042   -3.4
                        # 292    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.1417   -1.0125    0.0000 C   0  0  
                        # 0  0  0  0  0  0  0  0  0  0     0.9292   -1.7042    0.0000 C   0  0  0  0  0  0  0  0  0  0  
                        # 0  0   2  1  2  0   3  2  1  0   4  1  1  0   5  1  1  0   6  4  1  0   7  5  1  0   8  5  1  
                        # 0   9  7  1  0  10  9  1  0  11  2  1  0  12  8  1  0  13  3  1  0  14  5  1  0  15  6  1  0  
                        # 16 10  1  0  17 10  1  0  18 13  2  0  19 15  2  0   3  6  2  0  11 12  1  0  18 19  1  0 M  E
                        # ND' , '      RDKit          2D   21 22  0  0  0  0  0  0  0  0999 V2000     2.0195  -10.6755  
                        #   0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.3050  -11.0880    0.0000 C   0  0  0  0 
                        #  0  0  0  0  0  0  0  0     0.5906  -10.6755    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0 
                        #     1.3050  -11.9130    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -0.1239  -11.0880    
                        # 0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.8384  -10.6755    0.0000 C   0  0  0  0  0
                        #   0  0  0  0  0  0  0    -1.5528  -11.0880    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   
                        #  -2.2673  -10.6755    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.0195   -9.8505    0.
                        # 0000 O   0  0  0  0  0  0  0  0  0  0  0  0     2.7340  -11.0880    0.0000 N   0  0  0  0  0  
                        # 0  0  0  0  0  0  0     3.4485  -10.6755    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     
                        # 3.4485   -9.8505    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.1629   -9.4380    0.00
                        # 00 C   0  0  0  0  0  0  0  0  0  0  0  0     4.8774   -9.8505    0.0000 C   0  0  0  0  0  0 
                        #  0  0  0  0  0  0     4.8774  -10.6755    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.
                        # 1629  -11.0880    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.5919  -11.0880    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0     6.3455  -10.7525    0.0000 N   0  0  0  0  0  0  0
                        #   0  0  0  0  0     6.8976  -11.3655    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     6.48
                        # 51  -12.0800    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     5.6781  -11.9085    0.0000 N
                        #    0  0  0  0  0  0  0  0  0  0  0  0  10 11  1  0   5  6  1  0  11 12  2  0   1  2  1  0  12 
                        # 13  1  0   6  7  1  0  13 14  2  0   2  4  2  0  14 15  1  0   7  8  1  0  15 16  2  0  16 11 
                        #  1  0  15 17  1  0  17 18  2  0   1  9  2  0   3  5  1  0   1 10  1  0   2  3  1  0  18 19  1 
                        #  0  19 20  2  0  20 21  1  0  21 17  1  0 M  END' , '      RDKit          2D   16 16  0  0  0 
                        #  0  0  0  0  0999 V2000     8.0808    0.2647    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0 
                        #     8.7822    0.6565    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.3698    0.6565    
                        # 0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.1835    0.2502    0.0000 C   0  0  0  0  0
                        #   0  0  0  0  0  0  0     8.4726   -0.4173    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0   
                        #   5.1835   -0.5914    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.9041    0.6275    0.
                        # 0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.6297    0.2502    0.0000 C   0  0  0  0  0  
                        # 0  0  0  0  0  0  0     8.7822    1.4885    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     
                        # 5.9041   -0.9978    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     9.5029    0.2502    0.00
                        # 00 O   0  0  0  0  0  0  0  0  0  0  0  0     6.6297   -0.5914    0.0000 C   0  0  0  0  0  0 
                        #  0  0  0  0  0  0     8.0518   -1.1284    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     4.
                        # 4821    0.6565    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     7.6649   -0.4463    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0     4.4821   -1.0123    0.0000 O   0  0  0  0  0  0  0
                        #   0  0  0  0  0   2  1  1  0   3  1  1  0   4  7  2  0   5  1  1  0   6 10  2  0   7  8  1  0 
                        #   8  3  1  0   9  2  2  0  10 12  1  0  11  2  1  0  12  8  2  0  13  5  1  0  14  4  1  0   1
                        #  15  1  6  16  6  1  0   4  6  1  0 M  END' , '      RDKit          2D   20 21  0  0  0  0  0 
                        #  0  0  0999 V2000     2.3383   -1.3500    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.
                        # 2990   -0.7500    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.2990    0.7500    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0     0.0000    1.5000    0.0000 C   0  0  0  0  0  0  0
                        #   0  0  0  0  0    -1.2990    0.7500    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0    -1.29
                        # 90   -0.7500    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0    -2.6003   -1.4978    0.0000 C
                        #    0  0  0  0  0  0  0  0  0  0  0  0    -3.8990   -0.7455    0.0000 C   0  0  0  0  0  0  0  
                        # 0  0  0  0  0    -5.2003   -1.4932    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -6.4990
                        #    -0.7410    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -7.5395   -1.3388    0.0000 O  
                        #  0  0  0  0  0  0  0  0  0  0  0  0    -6.4969    0.4590    0.0000 O   0  0  0  0  0  0  0  0 
                        #  0  0  0  0     0.0000   -1.5000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.0000  
                        #  -2.7000    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     0.0000    3.0008    0.0000 C   0
                        #   0  0  0  0  0  0  0  0  0  0  0     1.2978    3.7529    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0     1.2954    5.2529    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.0048    
                        # 6.0009    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.3026    5.2488    0.0000 C   0  
                        # 0  0  0  0  0  0  0  0  0  0  0    -1.3002    3.7488    0.0000 C   0  0  0  0  0  0  0  0  0  
                        # 0  0  0   1  2  1  0   2  3  2  0   3  4  1  0   4  5  2  0   5  6  1  0   6  7  1  0   7  8  
                        # 1  0   8  9  1  0   9 10  1  0  10 11  2  0  10 12  1  0   6 13  2  0  13  2  1  0  13 14  1  
                        # 0   4 15  1  0  15 16  2  0  16 17  1  0  17 18  2  0  18 19  1  0  19 20  2  0  20 15  1  0 M
                        #   CHG  1   6   1 M  END' , '      RDKit          2D   41 44  0  0  1  0  0  0  0  0999 V2000  
                        #   11.1290  -10.4737    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0    11.1304   -9.6733    0
                        # .0000 C   0  0  0  0  0  0  0  0  0  0  0  0    11.9391   -9.6738    0.0000 C   0  0  0  0  0 
                        #  0  0  0  0  0  0  0    11.9387  -10.4825    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    
                        # 10.4215   -9.2562    0.0000 S   0  0  0  0  0  0  0  0  0  0  0  0    10.4336  -10.8761    0.0
                        # 000 C   0  0  0  0  0  0  0  0  0  0  0  0     9.7315  -10.4792    0.0000 C   0  0  0  0  0  0
                        #   0  0  0  0  0  0    14.7759  -10.2347    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    14
                        # .1740   -9.4588    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    14.5241  -11.0199    0.000
                        # 0 N   0  0  0  0  0  0  0  0  0  0  0  0    13.1504   -9.9652    0.0000 N   0  0  0  0  0  0  
                        # 0  0  0  0  0  0    13.2423   -8.9431    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    15.0
                        # 872   -8.7767    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0    15.1894  -11.4930    0.0000 
                        # C   0  0  0  0  0  0  0  0  0  0  0  0     9.7277   -9.6710    0.0000 C   0  0  0  0  0  0  0 
                        #  0  0  0  0  0    15.0959   -7.1205    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.871
                        # 1   -8.3227    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0    15.6090  -10.2279    0.0000 C 
                        #   0  0  0  0  0  0  0  0  0  0  0  0    15.8589  -11.0180    0.0000 S   0  0  0  0  0  0  0  0
                        #   0  0  0  0    10.4373  -11.7180    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    14.1801 
                        #   -6.7669    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    14.7870   -8.0559    0.0000 O   
                        # 0  0  0  0  0  0  0  0  0  0  0  0     9.1189  -11.0734    0.0000 C   0  0  0  0  0  0  0  0  
                        # 0  0  0  0    10.4194   -8.4268    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    12.5128  -
                        # 11.0343    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    12.8560   -8.0056    0.0000 O   0 
                        #  0  0  0  0  0  0  0  0  0  0  0     8.1585  -10.7675    0.0000 S   0  0  0  0  0  0  0  0  0 
                        #  0  0  0     9.4356  -12.0953    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    14.2040   -5
                        # .6394    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     7.2607   -8.8325    0.0000 C   0  0
                        #   0  0  0  0  0  0  0  0  0  0     8.6350   -8.7077    0.0000 C   0  0  0  0  0  0  0  0  0  0
                        #   0  0    15.2154  -12.3110    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     8.0713   -9.9
                        # 656    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.3515   -9.5624    0.0000 C   0  0  
                        # 0  0  0  0  0  0  0  0  0  0     8.7216   -9.5056    0.0000 C   0  0  0  0  0  0  0  0  0  0  
                        # 0  0    11.2504  -12.0253    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    13.1594   -6.754
                        # 9    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     7.7125   -7.3865    0.0000 C   0  0  0 
                        #  0  0  0  0  0  0  0  0  0    15.8887   -7.6029    0.0000 C   0  0  0  0  0  0  0  0  0  0  0 
                        #  0    15.6795   -6.3950    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    11.3935   -8.7085 
                        #    0.0000 H   0  0  0  0  0  0  0  0  0  0  0  0   2  1  1  0   3  4  1  0   4  1  1  0   5  2
                        #   1  0   6  1  1  0   7  6  2  0   8  9  1  0   9 12  1  0  10  8  1  0   3 11  1  6  12 11  1
                        #   0  13  9  2  0  14 10  2  0  15  7  1  0  16 22  1  0  17 30  2  0  18  8  2  0  19 18  1  0
                        #   20  6  1  0  21 16  1  0  22 13  1  0  23  7  1  0  24  5  1  0  25  4  2  0  26 12  2  0  2
                        # 7 23  1  0  28 20  2  0  29 21  2  0  30 34  1  0  31 35  2  0  32 14  1  0  33 27  1  0  34 3
                        # 3  2  0  35 33  1  0  36 20  1  0  37 21  1  0  38 17  1  0  39 16  1  0  40 16  1  0   2  3  
                        # 1  0   5 15  1  0  31 17  1  0  19 14  1  0   2 41  1  1 M  CHG  3   5   1  17   1  24  -1 M  
                        # END' , '      RDKit          2D   25 29  0  0  1  0  0  0  0  0999 V2000     4.2375   -5.4042 
                        #    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.6542   -5.8125    0.0000 N   0  0  0  0
                        #   0  0  0  0  0  0  0  0     4.0167   -4.7167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
                        #      4.9250   -5.5750    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.3917   -5.0375   
                        #  0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     3.0917   -5.4042    0.0000 C   0  0  0  0  
                        # 0  0  0  0  0  0  0  0     3.3125   -4.7167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0  
                        #    5.1417   -6.2250    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.4917   -4.2042    0
                        # .0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.1167   -5.1917    0.0000 C   0  0  0  0  0 
                        #  0  0  0  0  0  0  0     5.8417   -6.4042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    
                        #  5.1792   -4.3667    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.3042   -5.8750    0.0
                        # 000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.6542   -6.5125    0.0000 C   0  0  0  0  0  0
                        #   0  0  0  0  0  0     2.3917   -5.5500    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2
                        # .8292   -4.1875    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.0500   -7.0667    0.000
                        # 0 C   0  0  0  0  0  0  0  0  0  0  0  0     7.0125   -6.0167    0.0000 C   0  0  0  0  0  0  
                        # 0  0  0  0  0  0     2.1417   -4.3375    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.9
                        # 000   -5.0167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.2292   -6.7042    0.0000 
                        # C   0  0  0  0  0  0  0  0  0  0  0  0     6.7750   -7.2167    0.0000 C   0  0  0  0  0  0  0 
                        #  0  0  0  0  0     6.9860   -5.1435    0.0000 H   0  0  0  0  0  0  0  0  0  0  0  0     5.153
                        # 9   -7.1301    0.0000 H   0  0  0  0  0  0  0  0  0  0  0  0     4.2461   -6.3092    0.0000 H 
                        #   0  0  0  0  0  0  0  0  0  0  0  0   2  1  1  0   3  1  2  0   4  1  1  0   5  4  1  0   6  
                        # 2  1  0   7  3  1  0   8  4  1  0   9  3  1  0  10  5  1  0  11  8  1  0  12  5  1  0  13 11  
                        # 1  0  14  2  1  0  15  6  1  0  16  7  1  0  17 11  1  0  18 13  1  0  19 16  2  0  20 15  2  
                        # 0  21 22  1  0  22 17  1  0   7  6  2  0   9 12  1  0  10 13  1  0  19 20  1  0  18 21  1  0  
                        # 13 23  1  1  11 24  1  6   4 25  1  6 M  END'
                        'standard_inchi': 'TEXT',
                        # EXAMPLES:
                        # 'InChI=1S/C15H24N2O4S/c1-5-17(6-2)10-9-16-15(18)13-11-12(22(4,19)20)7-8-14(13)21-3/h7-8,11H,5-
                        # 6,9-10H2,1-4H3,(H,16,18)' , 'InChI=1S/C12H21NO5/c1-2-3-9(15)18-8-6-13-5-4-7(14)10(13)12(17)11(
                        # 8)16/h7-8,10-12,14,16-17H,2-6H2,1H3/t7-,8-,10+,11+,12+/m0/s1' , 'InChI=1S/C9H13NO3/c1-10-5-9(1
                        # 3)6-2-3-7(11)8(12)4-6/h2-4,9-13H,5H2,1H3' , 'InChI=1S/C9H12N2O6/c12-3-4-6(14)7(15)8(17-4)11-2-
                        # 1-5(13)10-9(11)16/h1-2,4,6-8,12,14-15H,3H2,(H,10,13,16)/t4-,6-,7-,8-/m1/s1' , 'InChI=1S/C17H23
                        # NO/c1-17(9-10-18(2)3)16-12-13-6-4-5-7-14(13)15(16)8-11-19-17/h4-7H,8-12H2,1-3H3' , 'InChI=1S/C
                        # 13H15N5O3/c1-2-3-7-21-13(20)12(19)14-10-6-4-5-9(8-10)11-15-17-18-16-11/h4-6,8H,2-3,7H2,1H3,(H,
                        # 14,19)(H,15,16,17,18)' , 'InChI=1S/C10H14N2O4/c1-10(12-11,9(15)16)5-6-2-3-7(13)8(14)4-6/h2-4,1
                        # 2-14H,5,11H2,1H3,(H,15,16)/t10-/m0/s1' , 'InChI=1S/C15H17N3O2/c1-11-10-13(12-6-3-2-4-7-12)17-1
                        # 8(15(11)16)9-5-8-14(19)20/h2-4,6-7,10,16H,5,8-9H2,1H3,(H,19,20)/p+1' , 'InChI=1S/C23H24N6O8S3/
                        # c1-23(2,21(34)35)37-27-14(13-9-39-22(24)25-13)17(30)26-15-18(31)29-16(20(32)33)11(10-40(36)19(
                        # 15)29)8-38-12-4-6-28(3)7-5-12/h4-7,9,15,19H,8,10H2,1-3H3,(H4-,24,25,26,30,32,33,34,35)/p+1/b27
                        # -14-/t15-,19-,40?/m1/s1' , 'InChI=1S/C20H26N2/c1-21-18-9-5-4-8-16(18)17-10-11-22-13-15-7-3-2-6
                        # -14(15)12-19(22)20(17)21/h4-5,8-9,14-15,19H,2-3,6-7,10-13H2,1H3/t14-,15-,19-/m0/s1'
                        'standard_inchi_key': 'TEXT',
                        # EXAMPLES:
                        # 'JTVPZMFULRWINT-UHFFFAOYSA-N' , 'HTJGLYIJVSDQAE-VWNXEWBOSA-N' , 'UCTWMZQNUQWSLP-UHFFFAOYSA-N' 
                        # , 'DRTQHJPVMGBUCF-XVFCMESISA-N' , 'AMJPIGOYWBNJLP-UHFFFAOYSA-N' , 'XQTARQNQIVVBRX-UHFFFAOYSA-N
                        # ' , 'TZFNLOMSOLWIDK-JTQLQIEISA-N' , 'LLZVAIDABZBAGE-UHFFFAOYSA-O' , 'HCCFUFNFJIUPHS-MZYBJUSBSA
                        # -O' , 'SNMPZBCEJSLAEK-DOXZYTNZSA-N'
                    }
                },
                'molecule_synonyms': 
                {
                    'properties': 
                    {
                        'molecule_synonym': 'TEXT',
                        # EXAMPLES:
                        # 'Tiapride' , 'Celgosivir' , 'Racepinefrine' , 'Asp8374' , 'Avonex' , 'NSC-20256' , 'Pirandamin
                        # e' , 'Tazanolast' , 'Carbidopa' , 'Mimbane'
                        'syn_type': 'TEXT',
                        # EXAMPLES:
                        # 'ATC' , 'INN' , 'INN' , 'OTHER' , 'TRADE_NAME' , 'RESEARCH_CODE' , 'INN' , 'INN' , 'BAN' , 'IN
                        # N'
                        'synonyms': 'TEXT',
                        # EXAMPLES:
                        # 'TIAPRIDE' , 'CELGOSIVIR' , 'RACEPINEFRINE' , 'ASP8374' , 'AVONEX' , 'NSC-20256' , 'PIRANDAMIN
                        # E' , 'TAZANOLAST' , 'CARBIDOPA' , 'MIMBANE'
                    }
                },
                'ob_patent': 'NUMERIC',
                # EXAMPLES:
                # '6500867' , '6673838' , '7157584' , '7144884' , '8945620' , '6315720' , '6699871' , '7138390' , '65145
                # 31' , '6479500'
                'oral': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'True'
                'parenteral': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False' , 'False'
                'prodrug': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'research_codes': 'TEXT',
                # EXAMPLES:
                # 'MDL-28574A' , 'ASP-8374' , 'NSC-20256' , 'AY-23713' , 'MK-486' , 'W-2291A' , 'ATU027' , 'CMA-676' , '
                # WY-45233' , 'WY-48986'
                'rule_of_five': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'False' , 'False' , 'False' , 'True' , 'True' , 'True' , 'True'
                'sc_patent': 'TEXT',
                # EXAMPLES:
                # 'US-6500867-B1' , 'US-6673838-B2' , 'US-7157584-B2' , 'US-7144884-B2' , 'US-8945620-B2' , 'US-6315720-
                # B1' , 'US-6699871-B2' , 'US-7138390-B2' , 'US-6514531-B1' , 'US-6479500-B1'
                'synonyms': 'TEXT',
                # EXAMPLES:
                # 'Tiapride HCl (MI, JAN)' , 'Celgosivir (INN)' , 'Racepinephrine HCl (USP)' , 'Ferric (59fe) citrate in
                # jection (INN)' , 'Asp-8374' , 'Interferon beta-1a (BAN, FDA, INN, MI, USAN)' , 'Uridine (MI, USP)' , '
                # Pirandamine HCl (USAN)' , 'Tazanolast (INN, JAN)' , 'Carbidopa (BAN, FDA, INN, JAN, MI, USAN, USP, BAN
                # , JAN, USAN, USP)'
                'topical': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'usan_stem': 'TEXT',
                # EXAMPLES:
                # '-pride' , '-vir' , '-ast' , '-dopa' , '-ium' , '-ium; cef-' , '-ast' , '-mab; -micin' , '-faxine' , '
                # -ilide'
                'usan_stem_definition': 'TEXT',
                # EXAMPLES:
                # 'sulpride derivatives' , 'antivirals: glucosidase inhibitor' , 'antiasthmatics/antiallergics (not acti
                # ng primarily as antihistamines)' , 'dopamine receptor agonists' , 'quaternary ammonium derivatives' , 
                # 'quaternary ammonium derivatives; cephalosporins' , 'antiasthmatics/antiallergics (not acting primaril
                # y as antihistamines)' , 'monoclonal antibodies: humanized, tumors as target; antibiotics (Micromonospo
                # ra strains)' , 'antianxiety, antidepressant inhibitor of norepinephrine and dopamine re-uptake' , 'cla
                # ss III antiarrhythmic agents'
                'usan_stem_substem': 'TEXT',
                # EXAMPLES:
                # '-pride(-pride)' , '-vir(-vir (-gosivir))' , '-ast(-ast)' , '-dopa(-dopa)' , '-ium(-ium)' , '-ium(-ium
                # ); cef-(cef-)' , '-ast(-ast)' , '-mab(-mab (-tuzumab)); -micin(-micin)' , '-faxine(-faxine)' , '-ilide
                # (-ilide)'
                'usan_year': 'NUMERIC',
                # EXAMPLES:
                # '1997' , '1993' , '1974' , '1972' , '1963' , '2000' , '2003' , '1990' , '1994' , '1987'
                'withdrawn_class': 'TEXT',
                # EXAMPLES:
                # 'Dermatological toxicity' , 'Cardiotoxicity' , 'Respiratory toxicity' , 'Hematological toxicity' , 'De
                # rmatological toxicity; Neurotoxicity; Psychiatric toxicity' , 'Hepatotoxicity; Neurotoxicity' , 'Cardi
                # otoxicity; Neurotoxicity' , 'Hepatotoxicity' , 'Hematological toxicity' , 'Cardiotoxicity'
                'withdrawn_country': 'TEXT',
                # EXAMPLES:
                # 'United States' , 'Spain; Germany; France' , 'Germany' , 'United States' , 'Germany' , 'Spain' , 'Unit
                # ed States' , 'Spain; United Kingdom' , 'United States' , 'European Union; United States'
                'withdrawn_reason': 'TEXT',
                # EXAMPLES:
                # 'The trial was stopped early when no improvement in clinical benefit was observed, and after a greater
                #  number of deaths occurred in the group of patients who received Mylotarg compared with those receivin
                # g chemotherapy alone' , 'Stevens Johnson Syndrome; Toxic Epidermal Necrolysis' , 'Cardiovascular' , 'F
                # atal bronchospasm' , 'Hematological' , 'Depression, anxiety, sleep disorders, tremor (shaking) and tar
                # dive dyskinesia' , 'Neurologic and Hepatic Toxicities' , 'Risk for heart attack, stroke, and unstable 
                # angina' , 'Liver toxicity; Serious liver injury leading to liver transplant; Death' , 'Agranulocytosis
                # '
                'withdrawn_year': 'NUMERIC',
                # EXAMPLES:
                # '2010' , '1983' , '1969' , '2001' , '1987' , '2005' , '1985' , '2007' , '2006' , '1960'
            }
        }
    }

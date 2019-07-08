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
                # 'Novartis Pharmaceuticals Corp' , 'Professional Disposables Inc' , 'Ucb Inc' , 'Otsuka Pharmaceutical 
                # Co Ltd' , 'Hoffmann-La Roche Inc' , 'Merck Sharp And Dohme Corp' , 'Agouron Pharmaceuticals Llc' , 'Am
                # neal Pharmaceuticals' , 'Glaxosmithkline' , 'Glaxosmithkline Llc'
                'atc_classification': 
                {
                    'properties': 
                    {
                        'code': 'TEXT',
                        # EXAMPLES:
                        # 'N01AB05' , 'L01XE39' , 'D01AC60' , 'N05AB08' , 'D08AX05' , 'N01AA01' , 'N03AX23' , 'J01MA11' 
                        # , 'N05CM13' , 'J05AE01'
                        'description': 'TEXT',
                        # EXAMPLES:
                        # 'NERVOUS SYSTEM: ANESTHETICS: ANESTHETICS, GENERAL: Halogenated hydrocarbons' , 'ANTINEOPLASTI
                        # C AND IMMUNOMODULATING AGENTS: ANTINEOPLASTIC AGENTS: OTHER ANTINEOPLASTIC AGENTS: Protein kin
                        # ase inhibitors' , 'DERMATOLOGICALS: ANTIFUNGALS FOR DERMATOLOGICAL USE: ANTIFUNGALS FOR TOPICA
                        # L USE: Imidazole and triazole derivative' , 'NERVOUS SYSTEM: PSYCHOLEPTICS: ANTIPSYCHOTICS: Ph
                        # enothiazines with piperazine structure' , 'DERMATOLOGICALS: ANTISEPTICS AND DISINFECTANTS: ANT
                        # ISEPTICS AND DISINFECTANTS: Other antiseptics and disinfectants' , 'NERVOUS SYSTEM: ANESTHETIC
                        # S: ANESTHETICS, GENERAL: Ethers' , 'NERVOUS SYSTEM: ANTIEPILEPTICS: ANTIEPILEPTICS: Other anti
                        # epileptics' , 'ANTIINFECTIVES FOR SYSTEMIC USE: ANTIBACTERIALS FOR SYSTEMIC USE: QUINOLONE ANT
                        # IBACTERIALS: Fluoroquinolones' , 'NERVOUS SYSTEM: PSYCHOLEPTICS: HYPNOTICS AND SEDATIVES: Othe
                        # r hypnotics and sedatives' , 'ANTIINFECTIVES FOR SYSTEMIC USE: ANTIVIRALS FOR SYSTEMIC USE: DI
                        # RECT ACTING ANTIVIRALS: Protease inhibitors'
                    }
                },
                'availability_type': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '1' , '-1' , '-1' , '-1' , '2' , '-1' , '-1' , '-1' , '1'
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
                                # '6719' , '6720' , '6333' , '6677' , '6677' , '6720' , '6722' , '6715' , '6679' , '6683
                                # '
                                'component_type': 'TEXT',
                                # EXAMPLES:
                                # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'P
                                # ROTEIN' , 'PROTEIN' , 'PROTEIN'
                                'description': 'TEXT',
                                # EXAMPLES:
                                # 'Tissue-type plasminogen activator precursor' , 'Purified bovine insulin zinc suspensi
                                # on' , 'Ibritumomab tiuxetan heavy chain' , 'Purified semisynthetic human insulin zinc 
                                # suspension' , 'Purified semisynthetic human insulin zinc suspension' , 'Purified bovin
                                # e insulin zinc suspension' , 'Interleukin-2 precursor' , 'Calcitonin 1 precursor' , 'G
                                # lucagon precursor' , 'Somatotropin precursor'
                                'organism': 'TEXT',
                                # EXAMPLES:
                                # 'Homo sapiens' , 'Bos taurus' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens' , 'Bo
                                # s taurus' , 'Homo sapiens' , 'Oncorhynchus keta' , 'Homo sapiens' , 'Homo sapiens'
                                'sequence': 'TEXT',
                                # EXAMPLES:
                                # 'MDAMKRGLCCVLLLCGAVFVSPSQEIHARFRRGARSYQVICRDEKTQMIYQQHQSWLRPVLRSNRVEYCWCNSGRAQCHSVPVKS
                                # CSEPRCFNGGTCQQALYFSDFVCQCPEGFAGKCCEIDTRATCYEDQGISYRGTWSTAESGAECTNWNSSALAQKPYSGRRPDAIRL
                                # GLGNHNYCRNPDRDSKPWCYVFKAGKYSSEFCSTPACSEGNSDCYFGNGSAYRGTHSLTESGASCLPWNSMILIGKVYTAQNPSAQ
                                # ALGLGKHNYCRNPDGDAKPWCHVLKNRRLTWEYCDVPSCSTCGLRQYSQPQFRIKGGLFADIASHPWQAAIFAKHRRSPGERFLCG
                                # GILISSCWILSAAHCFQERFPPHHLTVILGRTYRVVPGEEEQKFEVEKYIVHKEFDDDTYDNDIALLQLKSDSSRCAQESSVVRTV
                                # CLPPADLQLPDWTECELSGYGKHEALSPFYSERLKEAHVRLYPSSRCTSQHLLNRTVTDNMLCAGDTRSGGPQANLHDACQGDSGG
                                # PLVCLNDGRMTLVGIISWGLGCGQKDVPGVYTKVTNYLDWIRDNMRP' , 'MALWTRLRPLLALLALWPPPPARAFVNQHLCGSH
                                # LVEALYLVCGERGFFYTPKARREVEGPQVGALELAGGPGAGGLEGPPQKRGIVEQCCASVCSLYQLENYCN' , 'QAYLQQSGAE
                                # LVRPGASVKMSCKASGYTFTSYNMHWVKQTPRQGLEWIGAIYPGNGDTSYNQKFKGKATLTVDKSSSTAYMQLSSLTSEDSAVYFC
                                # ARVVYYSNSYWYFDVWGTGTTVTVSAPSVYPLAPVCGDTTGSSVTLGCLVKGYFPEPVTLTWNSGSLSSGVHTFPAVLQSDLYTLS
                                # SSVTVTSSTWPSQSITCNVAHPASSTKVDKKIEPRGPTIKPCPPCKCPAPNLLGGPSVFIFPPKIKDVLMISLSPIVTCVVVDVSE
                                # DDPDVQISWFVNNVEVHTAQTQTHREDYNSTLRVVSALPIQHQDWMSGKEFKCKVNNKDLPAPIERTISKPKGSVRAPQVYVLPPP
                                # EEEMTKKQVTLTCMVTDFMPEDIYVEWTNNGKTELNYKNTEPVLDSDGSYFMYSKLRVEKKNWVERNSYSCSVVHEGLHNHHTTKS
                                # FSR' , 'MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAEDLQVGQVELGGGPGAGSLQ
                                # PLALEGSLQKRGIVEQCCTSICSLYQLENYCN' , 'MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFF
                                # YTPKTRREAEDLQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN' , 'MALWTRLRPLLALLALWPPP
                                # PARAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVGALELAGGPGAGGLEGPPQKRGIVEQCCASVCSLYQLENYCN'
                                #  , 'MYRMQLLSCIALSLALVTNSAPTSSSTKKTQLQLEHLLLDLQMILNGINNYKNPKLTRMLTFKFYMPKKATELKHLQCLEEE
                                # LKPLEEVLNLAQSKNFHLRPRDLISNINVIVLELKGSETTFMCEYADETATIVEFLNRWITFCQSIISTLT' , 'MVMMKLSALL
                                # IAYFLVICQMYSSHAAPARTGLESMTDQVTLTDYEARRLLNAIVKEFVQMTSEELEQQANEGNSLDRPMSKRCSNLSTCVLGKLSQ
                                # ELHKLQTYPRTNTGSGTPGKKRSLPESNRYASYGDSYDGI' , 'MKSIYFVAGLFVMLVQGSWQQDTEEKSRSLRSFSASQADPL
                                # SDPDQMNEDKRHSQGTFTSDYSKYLDSRRAQDFVQWLMNTKRNRNNIAKRHDEFERHAEGTFTSDVSSYLEGQAAKEFIAWLVKGR
                                # GRRDFPEEVAIVEELGRRHADGSFSDEMNTILDNLAARDFINWLIQTKITDRK' , 'MATGSRTSLLLAFGLLCLPWLQEGSAFP
                                # TIPLSRLFDNAMLRAHRLHQLAFDTYQEFEEAYIPKEQKYSFLQNPQTSLCFSESIPTPSNREETQQKSNLELLRISLLLIQSWLE
                                # PVQFLRSVFANSLVYGASDSNVYDLLKDLEEGIQTLMGRLEDGSPRTGQIFKQTYSKFDTNSHNDDALLKNYGLLYCFRKDMDKVE
                                # TFLRIVQCRSVEGSCGF'
                                'tax_id': 'NUMERIC',
                                # EXAMPLES:
                                # '9606' , '9913' , '10090' , '9606' , '9606' , '9913' , '9606' , '8018' , '9606' , '960
                                # 6'
                            }
                        },
                        'description': 'TEXT',
                        # EXAMPLES:
                        # 'Tissue-type plasminogen activator precursor (tPA) (t-PA) (t-plasminogen activator) (Alteplase
                        # ) (Reteplase)' , 'IGN-311 (mab)' , 'LMB-9 (mab)' , 'Bovine insulin isophane suspension' , 'MCS
                        # -110 (mab)' , 'Insulin aspart protamine recombinant' , 'PD-360324 (mab)' , 'Insulin lispro pro
                        # tamine recombinant' , 'PTI-6D2 (mab)' , 'SS1(dsFv)-PE38 (mab)'
                        'helm_notation': 'TEXT',
                        # EXAMPLES:
                        # 'PEPTIDE1{[X2102].V.[Sar].[meL].V.[meL].A.[dA].[meL].[meL].[meV]}$PEPTIDE1,PEPTIDE1,11:R2-1:R1
                        # $$$' , 'PEPTIDE1{Y.[dA].G.F.[meM].[am]}$$$$' , 'PEPTIDE1{[X751].[dH].P.[am]}$$$$' , 'PEPTIDE1{
                        # H.[X155].A.W.[dF].K.[am]}$$$$' , 'PEPTIDE1{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S
                        # .S.S.V.P.Y.I.H.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.A.T.S.A.L.A.S.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T
                        # .I.S.R.L.E.P.E.D.F.A.V.Y.Y.C.Q.Q.W.L.S.N.P.P.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S
                        # .D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S
                        # .K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|
                        # PEPTIDE2{E.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.E.S.L.K.I.S.C.K.G.S.G.R.T.F.T.S.Y.N.M.H.W.V.R.Q.M.P.G.K
                        # .G.L.E.W.M.G.A.I.Y.P.L.T.G.D.T.S.Y.N.Q.K.S.K.L.Q.V.T.I.S.A.D.K.S.I.S.T.A.Y.L.Q.W.S.S.L.K.A.S.D
                        # .T.A.M.Y.Y.C.A.R.S.T.Y.V.G.G.D.W.Q.F.D.V.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K
                        # .S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y
                        # .S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P
                        # .P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.I.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K
                        # .F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C
                        # .K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.Q.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L
                        # .V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S
                        # .R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G}|PEPTIDE3{E.V.Q.L.V.Q.S.G.A.E.V
                        # .K.K.P.G.E.S.L.K.I.S.C.K.G.S.G.R.T.F.T.S.Y.N.M.H.W.V.R.Q.M.P.G.K.G.L.E.W.M.G.A.I.Y.P.L.T.G.D.T
                        # .S.Y.N.Q.K.S.K.L.Q.V.T.I.S.A.D.K.S.I.S.T.A.Y.L.Q.W.S.S.L.K.A.S.D.T.A.M.Y.Y.C.A.R.S.T.Y.V.G.G.D
                        # .W.Q.F.D.V.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D
                        # .Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T
                        # .Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L
                        # .F.P.P.K.I.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T
                        # .K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I
                        # .S.K.Q.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S
                        # .N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E
                        # .A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G}|PEPTIDE4{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S
                        # .S.S.V.P.Y.I.H.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.A.T.S.A.L.A.S.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T
                        # .I.S.R.L.E.P.E.D.F.A.V.Y.Y.C.Q.Q.W.L.S.N.P.P.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S
                        # .D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S
                        # .K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$
                        # PEPTIDE2,PEPTIDE2,265:R3-325:R3|PEPTIDE4,PEPTIDE4,23:R3-87:R3|PEPTIDE1,PEPTIDE1,133:R3-193:R3|
                        # PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE1,224:R3-213:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|
                        # PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE3,PEPTIDE4,224:R3-213:R3|PEPTIDE4,PEPTIDE4,133:R3-193:R
                        # 3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE2,371:R3-429
                        # :R3|PEPTIDE3,PEPTIDE3,148:R3-204:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE1,PEPTIDE1,23:R3-87:R
                        # 3|PEPTIDE2,PEPTIDE2,148:R3-204:R3$$$' , 'PEPTIDE1{Q.I.V.L.S.Q.S.P.A.I.L.S.A.S.P.G.E.K.V.T.M.T.
                        # C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.S.S.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F.S.G.S.G.S.G.T.S.
                        # Y.S.L.T.I.S.R.V.E.A.E.D.A.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.
                        # F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.
                        # E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.
                        # G.E.C}|PEPTIDE2{Q.V.Q.L.Q.Q.P.G.A.E.L.V.K.P.G.A.S.V.K.M.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.
                        # T.P.G.R.G.L.E.W.I.G.A.I.Y.P.G.N.G.D.T.S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.K.S.S.S.T.A.Y.M.Q.L.S.S.L.
                        # T.S.E.D.S.A.V.Y.Y.C.A.R.S.T.Y.Y.G.G.D.W.Y.F.N.V.W.G.A.G.T.T.V.T.V.S.A.A.S.T.K.G.P.S.V.F.P.L.A.
                        # P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.
                        # S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.
                        # H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.
                        # P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.
                        # E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.
                        # L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.
                        # V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{Q.V.Q.L.Q.Q.
                        # P.G.A.E.L.V.K.P.G.A.S.V.K.M.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.T.P.G.R.G.L.E.W.I.G.A.I.Y.P.
                        # G.N.G.D.T.S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.K.S.S.S.T.A.Y.M.Q.L.S.S.L.T.S.E.D.S.A.V.Y.Y.C.A.R.S.T.
                        # Y.Y.G.G.D.W.Y.F.N.V.W.G.A.G.T.T.V.T.V.S.A.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.
                        # C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.
                        # S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.
                        # P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.
                        # H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.
                        # I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.
                        # V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.
                        # S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{Q.I.V.L.S.Q.S.P.A.I.L.S.A.S.P.G.E.K.V.T.
                        # M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.S.S.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F.S.G.S.G.S.G.
                        # T.S.Y.S.L.T.I.S.R.V.E.A.E.D.A.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.
                        # F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.
                        # V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.
                        # N.R.G.E.C}$PEPTIDE2,PEPTIDE2,371:R3-429:R3|PEPTIDE1,PEPTIDE1,133:R3-193:R3|PEPTIDE2,PEPTIDE1,2
                        # 24:R3-213:R3|PEPTIDE3,PEPTIDE3,148:R3-204:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE4,PEPTIDE4
                        # ,23:R3-87:R3|PEPTIDE3,PEPTIDE4,224:R3-213:R3|PEPTIDE2,PEPTIDE2,148:R3-204:R3|PEPTIDE3,PEPTIDE3
                        # ,371:R3-429:R3|PEPTIDE2,PEPTIDE2,265:R3-325:R3|PEPTIDE1,PEPTIDE1,23:R3-87:R3|PEPTIDE2,PEPTIDE3
                        # ,230:R3-230:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|PEPTIDE4,PEPTIDE4
                        # ,133:R3-193:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3$$$' , 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D
                        # .R.V.T.I.T.C.R.A.S.Q.D.V.N.T.A.V.A.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.I.Y.S.A.S.F.L.Y.S.G.V.P.S.R.F.S.G
                        # .S.R.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.H.Y.T.T.P.P.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A
                        # .A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N
                        # .S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V
                        # .T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.N.I.K.D.T.Y
                        # .I.H.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.R.I.Y.P.T.N.G.Y.T.R.Y.A.D.S.V.K.G.R.F.T.I.S.A.D.T.S.K.N.T.A.Y
                        # .L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.S.R.W.G.G.D.G.F.Y.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S
                        # .V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P
                        # .A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.P
                        # .K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V
                        # .D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q
                        # .D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L
                        # .T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F
                        # .L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3
                        # {E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.N.I.K.D.T.Y.I.H.W.V.R.Q.A.P.G.K.G.L.E.W
                        # .V.A.R.I.Y.P.T.N.G.Y.T.R.Y.A.D.S.V.K.G.R.F.T.I.S.A.D.T.S.K.N.T.A.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y
                        # .Y.C.S.R.W.G.G.D.G.F.Y.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G
                        # .T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V
                        # .V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A
                        # .P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y
                        # .V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N
                        # .K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F
                        # .Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q
                        # .G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S
                        # .V.G.D.R.V.T.I.T.C.R.A.S.Q.D.V.N.T.A.V.A.W.Y.Q.Q.K.P.G.K.A.P.K.L.L.I.Y.S.A.S.F.L.Y.S.G.V.P.S.R
                        # .F.S.G.S.R.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.H.Y.T.T.P.P.T.F.G.Q.G.T.K.V.E.I.K.R
                        # .T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q
                        # .S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S
                        # .S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE2,PEPTIDE2,371:R3-429:R3|PEPTID
                        # E4,PEPTIDE4,134:R3-194:R3|PEPTIDE1,PEPTIDE1,134:R3-194:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPT
                        # IDE3,PEPTIDE4,224:R3-214:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|PEPTIDE2,PEPTIDE2,265:R3-325:R3|PE
                        # PTIDE2,PEPTIDE2,147:R3-203:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE1,224:R3-214:R3|
                        # PEPTIDE3,PEPTIDE3,147:R3-203:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PE
                        # PTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3$$$' , 'PEPTIDE1{P.[Me_dL].G.[am]}$
                        # $$$' , 'PEPTIDE1{[ac].[dF].[dF].[H_OMe]}$$$$' , 'PEPTIDE1{[Aib].H.[dNal].[dF].K.[am]}$$$$'
                        'molecule_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL1201593' , 'CHEMBL2109501' , 'CHEMBL2109503' , 'CHEMBL1201545' , 'CHEMBL1201606' , 'CHE
                        # MBL2109512' , 'CHEMBL1201664' , 'CHEMBL2109513' , 'CHEMBL1201611' , 'CHEMBL2109514'
                    }
                },
                'black_box': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'chirality': 'NUMERIC',
                # EXAMPLES:
                # '2' , '1' , '0' , '2' , '2' , '2' , '2' , '1' , '2' , '1'
                'development_phase': 'NUMERIC',
                # EXAMPLES:
                # '4' , '4' , '4' , '0' , '0' , '4' , '2' , '0' , '0' , '4'
                'drug_type': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'first_approval': 'NUMERIC',
                # EXAMPLES:
                # '2017' , '2000' , '2016' , '1997' , '1995' , '1996' , '1997' , '1962' , '1999' , '1964'
                'first_in_class': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'True' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'helm_notation': 'TEXT',
                # EXAMPLES:
                # 'PEPTIDE1{[X2102].V.[Sar].[meL].V.[meL].A.[dA].[meL].[meL].[meV]}$PEPTIDE1,PEPTIDE1,11:R2-1:R1$$$' , '
                # PEPTIDE1{Y.[dA].G.F.[meM].[am]}$$$$' , 'PEPTIDE1{[X751].[dH].P.[am]}$$$$' , 'PEPTIDE1{H.[X155].A.W.[dF
                # ].K.[am]}$$$$' , 'PEPTIDE1{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S.S.S.V.P.Y.I.H.W.Y.Q.Q.K
                # .P.G.Q.A.P.R.L.L.I.Y.A.T.S.A.L.A.S.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.R.L.E.P.E.D.F.A.V.Y.Y.C.Q.Q
                # .W.L.S.N.P.P.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P
                # .R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y
                # .A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.E.S.L.K.I.S.C.K.G
                # .S.G.R.T.F.T.S.Y.N.M.H.W.V.R.Q.M.P.G.K.G.L.E.W.M.G.A.I.Y.P.L.T.G.D.T.S.Y.N.Q.K.S.K.L.Q.V.T.I.S.A.D.K.S
                # .I.S.T.A.Y.L.Q.W.S.S.L.K.A.S.D.T.A.M.Y.Y.C.A.R.S.T.Y.V.G.G.D.W.Q.F.D.V.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G
                # .P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V
                # .L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H
                # .T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.I.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F
                # .N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K
                # .A.L.P.A.P.I.E.K.T.I.S.K.Q.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I
                # .A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M
                # .H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G}|PEPTIDE3{E.V.Q.L.V.Q.S.G.A.E.V.K.K.P.G.E.S.L.K.I.S.C.K.G.S.G.R.T
                # .F.T.S.Y.N.M.H.W.V.R.Q.M.P.G.K.G.L.E.W.M.G.A.I.Y.P.L.T.G.D.T.S.Y.N.Q.K.S.K.L.Q.V.T.I.S.A.D.K.S.I.S.T.A
                # .Y.L.Q.W.S.S.L.K.A.S.D.T.A.M.Y.Y.C.A.R.S.T.Y.V.G.G.D.W.Q.F.D.V.W.G.K.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F
                # .P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S
                # .G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P
                # .C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.I.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V
                # .D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A
                # .P.I.E.K.T.I.S.K.Q.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W
                # .E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L
                # .H.N.H.Y.T.Q.K.S.L.S.L.S.P.G}|PEPTIDE4{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S.S.S.V.P.Y.I
                # .H.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.A.T.S.A.L.A.S.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.R.L.E.P.E.D.F.A
                # .V.Y.Y.C.Q.Q.W.L.S.N.P.P.T.F.G.Q.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L
                # .L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y
                # .E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE2,265:R3-325:R3|PEPTIDE4,PEP
                # TIDE4,23:R3-87:R3|PEPTIDE1,PEPTIDE1,133:R3-193:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,PEPTIDE1,224:
                # R3-213:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE3,PEPTIDE4,224:R3-213
                # :R3|PEPTIDE4,PEPTIDE4,133:R3-193:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PE
                # PTIDE2,PEPTIDE2,371:R3-429:R3|PEPTIDE3,PEPTIDE3,148:R3-204:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE1,P
                # EPTIDE1,23:R3-87:R3|PEPTIDE2,PEPTIDE2,148:R3-204:R3$$$' , 'PEPTIDE1{Q.I.V.L.S.Q.S.P.A.I.L.S.A.S.P.G.E.
                # K.V.T.M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.S.S.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F.S.G.S.G.S.G.T.
                # S.Y.S.L.T.I.S.R.V.E.A.E.D.A.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.
                # S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.
                # T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{Q.V.Q.
                # L.Q.Q.P.G.A.E.L.V.K.P.G.A.S.V.K.M.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.T.P.G.R.G.L.E.W.I.G.A.I.Y.P.G.
                # N.G.D.T.S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.K.S.S.S.T.A.Y.M.Q.L.S.S.L.T.S.E.D.S.A.V.Y.Y.C.A.R.S.T.Y.Y.G.G.D.
                # W.Y.F.N.V.W.G.A.G.T.T.V.T.V.S.A.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.
                # P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.
                # H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.
                # R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.
                # L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.
                # E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.
                # S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{Q.V.Q.L.Q.Q.
                # P.G.A.E.L.V.K.P.G.A.S.V.K.M.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.T.P.G.R.G.L.E.W.I.G.A.I.Y.P.G.N.G.D.
                # T.S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.K.S.S.S.T.A.Y.M.Q.L.S.S.L.T.S.E.D.S.A.V.Y.Y.C.A.R.S.T.Y.Y.G.G.D.W.Y.F.
                # N.V.W.G.A.G.T.T.V.T.V.S.A.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.
                # V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.
                # S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.
                # E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.
                # L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.
                # K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.
                # T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{Q.I.V.L.S.Q.S.P.A.
                # I.L.S.A.S.P.G.E.K.V.T.M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.S.S.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.
                # F.S.G.S.G.S.G.T.S.Y.S.L.T.I.S.R.V.E.A.E.D.A.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.
                # P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.
                # T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}
                # $PEPTIDE2,PEPTIDE2,371:R3-429:R3|PEPTIDE1,PEPTIDE1,133:R3-193:R3|PEPTIDE2,PEPTIDE1,224:R3-213:R3|PEPTI
                # DE3,PEPTIDE3,148:R3-204:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE4,PEPTIDE4,23:R3-87:R3|PEPTIDE3,PEPT
                # IDE4,224:R3-213:R3|PEPTIDE2,PEPTIDE2,148:R3-204:R3|PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE2,PEPTIDE2,2
                # 65:R3-325:R3|PEPTIDE1,PEPTIDE1,23:R3-87:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE2,22:R3-96:
                # R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|PEPTIDE4,PEPTIDE4,133:R3-193:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3$$$' ,
                #  'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.D.V.N.T.A.V.A.W.Y.Q.Q.K.P.G.K.A.P.K.L
                # .L.I.Y.S.A.S.F.L.Y.S.G.V.P.S.R.F.S.G.S.R.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.H.Y.T.T.P.P.T
                # .F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W
                # .K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q
                # .G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.N.I.K.D
                # .T.Y.I.H.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.R.I.Y.P.T.N.G.Y.T.R.Y.A.D.S.V.K.G.R.F.T.I.S.A.D.T.S.K.N.T.A.Y.L.Q
                # .M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.S.R.W.G.G.D.G.F.Y.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P
                # .S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S
                # .L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A
                # .P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V
                # .E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E
                # .K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N
                # .G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H
                # .Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.N.I.K.D.T.Y.I
                # .H.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.R.I.Y.P.T.N.G.Y.T.R.Y.A.D.S.V.K.G.R.F.T.I.S.A.D.T.S.K.N.T.A.Y.L.Q.M.N.S
                # .L.R.A.E.D.T.A.V.Y.Y.C.S.R.W.G.G.D.G.F.Y.A.M.D.Y.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K
                # .S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S
                # .V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L
                # .L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H
                # .N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I
                # .S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P
                # .E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q
                # .K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.D.V.N.T.A.V.A.W.Y.Q
                # .Q.K.P.G.K.A.P.K.L.L.I.Y.S.A.S.F.L.Y.S.G.V.P.S.R.F.S.G.S.R.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C
                # .Q.Q.H.Y.T.T.P.P.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F
                # .Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K
                # .V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE2,PEPTIDE2,371:
                # R3-429:R3|PEPTIDE4,PEPTIDE4,134:R3-194:R3|PEPTIDE1,PEPTIDE1,134:R3-194:R3|PEPTIDE3,PEPTIDE3,265:R3-325
                # :R3|PEPTIDE3,PEPTIDE4,224:R3-214:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|PEPTIDE2,PEPTIDE2,265:R3-325:R3|PE
                # PTIDE2,PEPTIDE2,147:R3-203:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE1,224:R3-214:R3|PEPTIDE3
                # ,PEPTIDE3,147:R3-203:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE3,PEPTIDE3,
                # 371:R3-429:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3$$$' , 'PEPTIDE1{P.[Me_dL].G.[am]}$$$$' , 'PEPTIDE1{[ac].[d
                # F].[dF].[H_OMe]}$$$$' , 'PEPTIDE1{[Aib].H.[dNal].[dF].K.[am]}$$$$'
                'indication_class': 'TEXT',
                # EXAMPLES:
                # 'Antifungal' , 'Anti-Infective, Topical; Pharmaceutic Aid (solvent)' , 'Anesthetic (inhalation)' , 'An
                # tibacterial' , 'Tranquilizer' , 'Antiviral' , 'Antiviral' , 'Anti-Inflammatory; Analgesic' , 'Antivira
                # l' , 'Relaxant (skeletal muscle)'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL279816' , 'CHEMBL608533' , 'CHEMBL277535' , 'CHEMBL612029' , 'CHEMBL609109' , 'CHEMBL582' , 'CH
                # EMBL16264' , 'CHEMBL606566' , 'CHEMBL275835' , 'CHEMBL607400'
                'molecule_properties': 
                {
                    'properties': 
                    {
                        'acd_logd': 'NUMERIC',
                        # EXAMPLES:
                        # '2.56' , '5.89' , '4.63' , '2.92' , '3.66' , '0.17' , '1.04' , '4.09' , '4.84' , '0.67'
                        'acd_logp': 'NUMERIC',
                        # EXAMPLES:
                        # '2.56' , '5.89' , '4.69' , '4.77' , '4.26' , '0.17' , '1.04' , '5.48' , '4.85' , '0.67'
                        'acd_most_apka': 'NUMERIC',
                        # EXAMPLES:
                        # '10.13' , '9.98' , '6.44' , '11.05' , '12.92' , '4.82' , '9.58' , '12.26' , '11.54' , '8.82'
                        'acd_most_bpka': 'NUMERIC',
                        # EXAMPLES:
                        # '6.55' , '9.23' , '7.66' , '8.81' , '8.74' , '6.29' , '5.19' , '2.72' , '1.39' , '8.47'
                        'alogp': 'NUMERIC',
                        # EXAMPLES:
                        # '2.5' , '5.91' , '5.19' , '3.4' , '3.18' , '0.39' , '1.04' , '4.66' , '3.92' , '0.9'
                        'aromatic_rings': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '6' , '4' , '1' , '2' , '0' , '0' , '1' , '1' , '0'
                        'full_molformula': 'TEXT',
                        # EXAMPLES:
                        # 'C2HCl3' , 'C35H30N4O4' , 'C22H18N2' , 'C17H28N2O2' , 'C22H30N4O2S2' , 'C3H8O' , 'C4H10O' , 'C
                        # 23H31NO' , 'C18H24N2O2S' , 'C11H20N2O2'
                        'full_mwt': 'NUMERIC',
                        # EXAMPLES:
                        # '131.39' , '570.65' , '310.4' , '292.42' , '446.64' , '60.1' , '74.12' , '337.51' , '332.47' ,
                        #  '212.29'
                        'hba': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '6' , '2' , '4' , '6' , '1' , '1' , '2' , '4' , '2'
                        'hba_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '8' , '2' , '4' , '6' , '1' , '1' , '2' , '4' , '4'
                        'hbd': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '1' , '0' , '1' , '0' , '1' , '0' , '1' , '2' , '1'
                        'hbd_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '1' , '0' , '1' , '0' , '1' , '0' , '1' , '3' , '2'
                        'heavy_atoms': 'NUMERIC',
                        # EXAMPLES:
                        # '5' , '43' , '24' , '21' , '30' , '4' , '5' , '25' , '23' , '15'
                        'molecular_species': 'TEXT',
                        # EXAMPLES:
                        # 'NEUTRAL' , 'NEUTRAL' , 'BASE' , 'NEUTRAL' , 'NEUTRAL' , 'BASE' , 'NEUTRAL' , 'NEUTRAL' , 'ZWI
                        # TTERION' , 'NEUTRAL'
                        'mw_freebase': 'NUMERIC',
                        # EXAMPLES:
                        # '131.39' , '570.65' , '310.4' , '292.42' , '446.64' , '60.1' , '74.12' , '337.51' , '332.47' ,
                        #  '212.29'
                        'mw_monoisotopic': 'NUMERIC',
                        # EXAMPLES:
                        # '129.9144' , '570.2267' , '310.147' , '292.2151' , '446.181' , '60.0575' , '74.0732' , '337.24
                        # 06' , '332.1558' , '212.1525'
                        'num_lipinski_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '2' , '1' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'num_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '2' , '1' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'psa': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '77.73' , '17.82' , '41.57' , '47.1' , '20.23' , '9.23' , '23.47' , '75.68' , '63.4'
                        'qed_weighted': 'NUMERIC',
                        # EXAMPLES:
                        # '0.47' , '0.29' , '0.51' , '0.53' , '0.68' , '0.43' , '0.48' , '0.79' , '0.76' , '0.74'
                        'ro3_pass': 'TEXT',
                        # EXAMPLES:
                        # 'Y' , 'N' , 'N' , 'N' , 'N' , 'Y' , 'Y' , 'N' , 'N' , 'N'
                        'rtb': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '3' , '4' , '10' , '6' , '0' , '2' , '2' , '1' , '5'
                    }
                },
                'molecule_structures': 
                {
                    'properties': 
                    {
                        'canonical_smiles': 'TEXT',
                        # EXAMPLES:
                        # 'ClC=C(Cl)Cl' , 'CO[C@@H]1[C@@H](C[C@H]2O[C@]1(C)n3c4ccccc4c5c6CNC(=O)c6c7c8ccccc8n2c7c35)N(C)
                        # C(=O)c9ccccc9' , 'c1ccc(cc1)C(c2ccc(cc2)c3ccccc3)n4ccnc4' , 'CCCCNc1ccc(cc1)C(=O)OCCN(CC)CC' ,
                        #  'CN(C)S(=O)(=O)c1ccc2Sc3ccccc3N(CCCN4CCN(C)CC4)c2c1' , 'CC(C)O' , 'CCOCC' , 'C[C@H]1CC(=C)C[C
                        # @]23CCN(CC4CCC4)[C@H](Cc5ccc(O)cc25)[C@H]13' , 'CC(C)(C)c1cc(\C=C\2/SC(=NC2=O)N)cc(c1O)C(C)(C)
                        # C' , 'CCC[C@H]1CN([C@@H](CC)C(=O)N)C(=O)C1'
                        'standard_inchi': 'TEXT',
                        # EXAMPLES:
                        # 'InChI=1S/C2HCl3/c3-1-2(4)5/h1H' , 'InChI=1S/C35H30N4O4/c1-35-32(42-3)25(37(2)34(41)19-11-5-4-
                        # 6-12-19)17-26(43-35)38-23-15-9-7-13-20(23)28-29-22(18-36-33(29)40)27-21-14-8-10-16-24(21)39(35
                        # )31(27)30(28)38/h4-16,25-26,32H,17-18H2,1-3H3,(H,36,40)/t25-,26-,32-,35+/m1/s1' , 'InChI=1S/C2
                        # 2H18N2/c1-3-7-18(8-4-1)19-11-13-21(14-12-19)22(24-16-15-23-17-24)20-9-5-2-6-10-20/h1-17,22H' ,
                        #  'InChI=1S/C17H28N2O2/c1-4-7-12-18-16-10-8-15(9-11-16)17(20)21-14-13-19(5-2)6-3/h8-11,18H,4-7,
                        # 12-14H2,1-3H3' , 'InChI=1S/C22H30N4O2S2/c1-23(2)30(27,28)18-9-10-22-20(17-18)26(19-7-4-5-8-21(
                        # 19)29-22)12-6-11-25-15-13-24(3)14-16-25/h4-5,7-10,17H,6,11-16H2,1-3H3' , 'InChI=1S/C3H8O/c1-3(
                        # 2)4/h3-4H,1-2H3' , 'InChI=1S/C4H10O/c1-3-5-4-2/h3-4H2,1-2H3' , 'InChI=1S/C23H31NO/c1-15-10-16(
                        # 2)22-21-11-18-6-7-19(25)12-20(18)23(22,13-15)8-9-24(21)14-17-4-3-5-17/h6-7,12,16-17,21-22,25H,
                        # 1,3-5,8-11,13-14H2,2H3/t16-,21+,22-,23+/m0/s1' , 'InChI=1S/C18H24N2O2S/c1-17(2,3)11-7-10(8-12(
                        # 14(11)21)18(4,5)6)9-13-15(22)20-16(19)23-13/h7-9,21H,1-6H3,(H2,19,20,22)/b13-9-' , 'InChI=1S/C
                        # 11H20N2O2/c1-3-5-8-6-10(14)13(7-8)9(4-2)11(12)15/h8-9H,3-7H2,1-2H3,(H2,12,15)/t8-,9+/m1/s1'
                        'standard_inchi_key': 'TEXT',
                        # EXAMPLES:
                        # 'XSTXAVWGXDQKEL-UHFFFAOYSA-N' , 'BMGQWWVMWDBQGC-IIFHNQTCSA-N' , 'OCAPBUJLXMYKEJ-UHFFFAOYSA-N' 
                        # , 'JQMCLLAJJLVYOC-UHFFFAOYSA-N' , 'VZYCZNZBPPHOFY-UHFFFAOYSA-N' , 'KFZMGEQAYNKOFK-UHFFFAOYSA-N
                        # ' , 'RTZKZFJDLAIYFH-UHFFFAOYSA-N' , 'AZJPPZHRNFQRRE-AZIXLERZSA-N' , 'AKTXOQVMWSFEBQ-LCYFTJDESA
                        # -N' , 'MSYKRHVOOPPJKU-BDAKNGLRSA-N'
                    }
                },
                'molecule_synonyms': 
                {
                    'properties': 
                    {
                        'molecule_synonym': 'TEXT',
                        # EXAMPLES:
                        # 'Chlorylen' , 'CGP-41251' , 'BAY-H-4502' , 'Thioproperazine' , '2-Propanol' , 'Diethyl ether' 
                        # , 'Xorphanol' , 'Darbufelone' , 'Brivaracetam' , 'Grepafloxacin'
                        'syn_type': 'TEXT',
                        # EXAMPLES:
                        # 'TRADE_NAME' , 'RESEARCH_CODE' , 'RESEARCH_CODE' , 'ATC' , 'OTHER' , 'ATC' , 'INN' , 'INN' , '
                        # ATC' , 'ATC'
                        'synonyms': 'TEXT',
                        # EXAMPLES:
                        # 'CHLORYLEN' , 'CGP 41251' , 'BAY H 4502' , 'THIOPROPERAZINE' , '2-Propanol' , 'DIETHYL ETHER' 
                        # , 'XORPHANOL' , 'DARBUFELONE' , 'BRIVARACETAM' , 'GREPAFLOXACIN'
                    }
                },
                'ob_patent': 'NUMERIC',
                # EXAMPLES:
                # '7973031' , '5690958' , '6784197' , '6352717' , '6645961' , '7122566' , '6730679' , '6017922' , '79276
                # 24' , '7828787'
                'oral': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'True' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'True'
                'parenteral': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'True'
                'prodrug': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'research_codes': 'TEXT',
                # EXAMPLES:
                # 'CGP-41251' , 'BAY-H-4502' , 'TR-5379M' , 'CI-1004' , 'UCB-34714' , 'OPC-17116' , 'MCN-X-181' , 'Ro-31
                # -8959-003' , 'MK-639' , 'BA-7602-06'
                'rule_of_five': 'BOOLEAN',
                # EXAMPLES:
                # 'True' , 'False' , 'False' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True'
                'sc_patent': 'TEXT',
                # EXAMPLES:
                # 'US-7973031-B2' , 'US-5690958-A' , 'US-6784197-B2' , 'US-6352717-B2' , 'US-6645961-B1' , 'US-7122566-B
                # 1' , 'US-6730679-B1' , 'US-6017922-A' , 'US-7927624-B2' , 'US-7828787-B2'
                'synonyms': 'TEXT',
                # EXAMPLES:
                # 'Trichloroethylene (INN, MI, NF)' , 'Midostaurin (FDA, INN, USAN)' , 'Bifonazole (BAN, INN, JAN, USAN)
                # ' , 'P-Butylaminobenzoyldiethylaminoethyl HCl (JAN)' , 'Thioproperazine Dimethanesulfonate (JAN)' , 'I
                # sopropanol (JAN)' , 'Ether (JAN, USP)' , 'Xorphanol (INN)' , 'Darbufelone mesylate (USAN)' , 'Brivarac
                # etam (FDA, INN, USAN)'
                'topical': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False' , 'False'
                'usan_stem': 'TEXT',
                # EXAMPLES:
                # '-fo-' , '-orphan-' , '-racetam' , '-oxacin' , '-vir' , '-vir' , '-ast' , '-vir' , '-vir' , '-dralazin
                # e'
                'usan_stem_definition': 'TEXT',
                # EXAMPLES:
                # 'phosphoro-derivatives' , 'narcotic antagonists/agonists (morphinan derivatives)' , 'nootropes (pirace
                # tam type)' , 'antibacterials (quinolone derivatives)' , 'antivirals: HIV protease inhibitors (saquinav
                # ir type)' , 'antivirals: HIV protease inhibitors (saquinavir type)' , 'antiasthmatics/antiallergics (n
                # ot acting primarily as antihistamines,leukotriene biosynthesis inhibitors)' , 'antivirals: HIV proteas
                # e inhibitors (saquinavir type)' , 'antivirals: HIV protease inhibitors (saquinavir type)' , 'antihyper
                # tensives (hydrazine-phthalazines)'
                'usan_stem_substem': 'TEXT',
                # EXAMPLES:
                # '-fo-(-fo-)' , '-orphan-(-orphan-)' , '-racetam(-racetam)' , '-oxacin(-oxacin)' , '-vir(-vir(-navir))'
                #  , '-vir(-vir(-navir))' , '-ast(-ast)' , '-vir(-vir(-navir))' , '-vir(-vir(-navir))' , '-dralazine(-dr
                # alazine)'
                'usan_year': 'NUMERIC',
                # EXAMPLES:
                # '2004' , '1981' , '1983' , '1998' , '2005' , '1995' , '1963' , '1994' , '1995' , '1979'
                'withdrawn_class': 'TEXT',
                # EXAMPLES:
                # 'Cardiotoxicity' , 'Carcinogenicity' , 'Cardiotoxicity' , 'Cardiotoxicity' , 'Hematological toxicity' 
                # , 'Dermatological toxicity; Misuse' , 'Cardiotoxicity' , 'Neurotoxicity; Psychiatric toxicity' , 'Hema
                # tological toxicity' , 'Hepatotoxicity'
                'withdrawn_country': 'TEXT',
                # EXAMPLES:
                # 'United States; United Kingdom; United States; Germany' , 'United Kingdom' , 'European Union' , 'Unite
                # d States; France; Oman; Saudi Arabia' , 'European Union' , 'United Kingdom; United States; Germany; Fr
                # ance' , 'France; Thailand' , 'Germany' , 'United States' , 'France; United States'
                'withdrawn_reason': 'TEXT',
                # EXAMPLES:
                # 'Cardiac repolarization; QTc interval prolongation' , 'Animal carcinogenicity (rodent)' , 'Prolonged Q
                # T interval; ventricular tachycardia' , 'Increased risk of ischaemic heart disease' , 'Agranulocytosis'
                #  , 'Abuse; Dependence; Severe Acne' , 'Cardiovascular' , 'Neuropsychiatric Reaction' , 'Hepatic toxici
                # ty' , 'Hemolytic Anemia'
                'withdrawn_year': 'NUMERIC',
                # EXAMPLES:
                # '1999' , '1965' , '2011' , '1998' , '2010' , '1970' , '1999' , '1969' , '1972' , '2012'
            }
        }
    }

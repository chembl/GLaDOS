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
                'biocomponents': 
                {
                    'properties': 
                    {
                        'component_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # '6548' , '6472' , '6478' , '6439' , '6365' , '6387' , '6333' , '6363' , '6304' , '6409'
                        'component_type': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' 
                        # , 'PROTEIN' , 'PROTEIN'
                        'description': DefaultMappings.TEXT_STD,
                        # EXAMPLES:
                        # 'Bevacizumab heavy chain' , 'Abciximab heavy chain' , 'Alemtuzumab heavy chain' , 'Omalizumab 
                        # heavy chain' , 'Tositumomab heavy chain' , 'Daclizumab heavy chain' , 'Ibritumomab tiuxetan he
                        # avy chain' , 'Rituximab heavy chain' , 'Muromonab-CD3 heavy chain' , 'Cetuximab heavy chain'
                        'organism': DefaultMappings.LOWER_CASE_KEYWORD,
                        # EXAMPLES:
                        # 'Mus musculus' , 'Mus musculus' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sap
                        # iens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens'
                        'sequence': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # 'EVQLVESGGGLVQPGGSLRLSCAASGYTFTNYGMNWVRQAPGKGLEWVGWINTYTGEPTYAADFKRRFTFSLDTSKSTAYLQMNSLRAEDTAV
                        # YYCAKYPHYYGSSHWYFDVWGQGTLVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYS
                        # LSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKF
                        # NWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSREEMTKNQVSLTCLV
                        # KGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'EVQLQQSGAEL
                        # VKPGASVKLSCTASGFNIKDTYVHWVKQRPEQGLEWIGRIDPANGYTKYDPKFQGKATITADTSSNTAYLQLSSLTSEDTAVYYCVRPLYDYYA
                        # MDYWGQGTSVTVSSAKTTAPSVYPLAPVCGDTTGSSVTLGCLVKGYFPEPVTLTWNSGSLSSGVHTFPAVLQSDLYTLSSSVTVTSSTWPSQSI
                        # TCNVAHPASSTKVDKKIEPRPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTK
                        # PREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESN
                        # GQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'QVQLQESGPGLVRPSQTLSLTCTVSG
                        # FTFTDFYMNWVRQPPGRGLEWIGFIRDKAKGYTTEYNPSVKGRVTMLVDTSKNQFSLRLSSVTAADTAVYYCAREGHTAAPFDYWGQGSLVTVS
                        # SASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTK
                        # VDKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVS
                        # VLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVL
                        # DSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'EVQLVESGGGLVQPGGSLRLSCAVSGYSITSGYSWNWIRQ
                        # APGKGLEWVASITYDGSTNYADSVKGRFTISRDDSKNTFYLQMNSLRAEDTAVYYCARGSHYFGHWHFAVWGQGTLVTVSSGPSVFPLAPSSKS
                        # TSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKAEPKSCDKTHTCPP
                        # CPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCK
                        # VSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSR
                        # WQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'QAYLQQSGAELVRPGASVKMSCKASGYTFTSYNMHWVKQTPRQGLEWIGAIYPGNGDT
                        # SYNQKFKGKATLTVDKSSSTAYMQLSSLTSEDSAVYFCARVVYYSNSYWYFDVWGTGTTVTVSGPSVFPLAPSSKSTSGGTAALGCLVKDYFPE
                        # PVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKAEPKSCDKTHTCPPCPAPELLGGPSVFLFPPK
                        # PKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAK
                        # GQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHN
                        # HYTQKSLSLSPGK' , 'QVQLVQSGAEVKKPGSSVKVSCKASGYTFTSYRMHWVRQAPGQGLEWIGYINPSTGYTEYNQKFKDKATITADEST
                        # NTAYMELSSLRSEDTAVYYCARGGGVFDYWGQGTTLTVSSGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQ
                        # SSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKAEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHE
                        # DPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQV
                        # SLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'QAYLQ
                        # QSGAELVRPGASVKMSCKASGYTFTSYNMHWVKQTPRQGLEWIGAIYPGNGDTSYNQKFKGKATLTVDKSSSTAYMQLSSLTSEDSAVYFCARV
                        # VYYSNSYWYFDVWGTGTTVTVSAPSVYPLAPVCGDTTGSSVTLGCLVKGYFPEPVTLTWNSGSLSSGVHTFPAVLQSDLYTLSSSVTVTSSTWP
                        # SQSITCNVAHPASSTKVDKKIEPRGPTIKPCPPCKCPAPNLLGGPSVFIFPPKIKDVLMISLSPIVTCVVVDVSEDDPDVQISWFVNNVEVHTA
                        # QTQTHREDYNSTLRVVSALPIQHQDWMSGKEFKCKVNNKDLPAPIERTISKPKGSVRAPQVYVLPPPEEEMTKKQVTLTCMVTDFMPEDIYVEW
                        # TNNGKTELNYKNTEPVLDSDGSYFMYSKLRVEKKNWVERNSYSCSVVHEGLHNHHTTKSFSR' , 'QVQLQQPGAELVKPGASVKMSCKASGY
                        # TFTSYNMHWVKQTPGRGLEWIGAIYPGNGDTSYNQKFKGKATLTADKSSSTAYMQLSSLTSEDSAVYYCARSTYYGGDWYFNVWGAGTTVTVSA
                        # ASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKV
                        # DKKVEPKSCDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSV
                        # LTVLHQDWLNGKEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLD
                        # SDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'QVQLQQSGAELARPGASVKMSCKASGYTFTRYTMHWVKQRP
                        # GQGLEWIGYINPSRGYTNYNQKFKDKATLTTDKSSSTAYMQLSSLTSEDSAVYYCARYYDDHYCLDYWGQGTTLTVSSAKTTAPSVYPLAPVCG
                        # GTTGSSVTLGCLVKGYFPEPVTLTWNSGSLSSGVHTFPAVLQSDLYTLSSSVTVTSSTWPSQSITCNVAHPASSTKVDKKIEPRPKSCDKTHTC
                        # PPCPAPELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYK
                        # CKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDK
                        # SRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'QVQLKQSGPGLVQPSQSLSITCTVSGFSLTNYGVHWVRQSPGKGLEWLGVIWSGGN
                        # TDYNTPFTSRLSINKDNSKSQVFFKMNSLQSNDTAIYYCARALTYYDYEFAYWGQGTLVTVSAASTKGPSVFPLAPSSKSTSGGTAALGCLVKD
                        # YFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKRVEPKSPKSCDKTHTCPPCPAPELLGGPS
                        # VFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIE
                        # KTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFSCSV
                        # MHEALHNHYTQKSLSLSPGK'
                        'tax_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # '10090' , '10090' , '10090' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9606'
                    }
                },
                'description': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Immunoglobulin G1, anti-(human antigen CD11a) (human-mouse monoclonal hu1124 gamma1-chain), disulfide
                #  with human-mouse monoclonal hu1124 light chain, dimer' , 'Immunoglobulin G 1 (human monoclonal D2E7 h
                # eavy chain anti-human tumor necrosis factor), disulfide with human monoclonal D2E7k-chain, dimer' , 'I
                # nfliximab (chimeric mab)' , 'Tetanus immune globulin (human)' , 'Immunoglobulin G 1 (human-mouse monoc
                # lonal rhuMAb-VEGF 7-chain anti-human vascular endothelial growth factor), disulfide with human-mouse m
                # onoclonal rhuMAb-VEGF light chain, dimer' , 'Abciximab (chimeric Fab)' , 'Immunoglobulin G 1 (human-mo
                # use monoclonal MEDI-493y1-chain anti­respiratory syncytial virus protein F), disulfide with human-mous
                # e monocional MEDI-493 x-chain, dimer' , 'Immunoglobulin G 1 (human-rat monodonal CAMPATH-1H 71-chain a
                # nti-human antigen CD52), disulfide with human-rat monoclonal CAMPATH-1H light chain, dimer' , 'Immunog
                # lobulin G, anti-(human immunoglobulin E Fc region) (human-mouse monoclonal E25 clone pSVIE26 y-chain),
                #  disulfide with human-mouse monoclonal E25 clone pSVIE26 x-chain, dimer' , 'Immune globulin (human)'
                'helm_notation': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.S.A.S.Q.D.I.S.N.Y.L.N.W.Y.Q.Q.K.P.G.K.A.P.K.V.
                # L.I.Y.F.T.S.S.L.H.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.Y.S.T.V.P.W.T.
                # F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.
                # K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.
                # G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.Y.T.F.T.N.
                # Y.G.M.N.W.V.R.Q.A.P.G.K.G.L.E.W.V.G.W.I.N.T.Y.T.G.E.P.T.Y.A.A.D.F.K.R.R.F.T.F.S.L.D.T.S.K.S.T.A.Y.L.Q.
                # M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.K.Y.P.H.Y.Y.G.S.S.H.W.Y.F.D.V.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.
                # L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.
                # L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.
                # P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.
                # G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.
                # I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.
                # S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.
                # N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.Y.T.F.T.N.Y.
                # G.M.N.W.V.R.Q.A.P.G.K.G.L.E.W.V.G.W.I.N.T.Y.T.G.E.P.T.Y.A.A.D.F.K.R.R.F.T.F.S.L.D.T.S.K.S.T.A.Y.L.Q.M.
                # N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.K.Y.P.H.Y.Y.G.S.S.H.W.Y.F.D.V.W.G.Q.G.T.L.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.
                # A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.
                # Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.
                # A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.
                # V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.
                # E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.
                # N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.
                # H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.L.S.A.S.V.G.D.R.V.T.I.T.C.S.A.S.Q.D.I.S.N.Y.L.
                # N.W.Y.Q.Q.K.P.G.K.A.P.K.V.L.I.Y.F.T.S.S.L.H.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.
                # T.Y.Y.C.Q.Q.Y.S.T.V.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.
                # L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.
                # E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE2,267:R3-327:R3|PEPTIDE3,PEPT
                # IDE3,267:R3-327:R3|PEPTIDE2,PEPTIDE3,232:R3-232:R3|PEPTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE2,PEPTIDE2,373
                # :R3-431:R3|PEPTIDE1,PEPTIDE1,134:R3-194:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3|PEPTIDE3,PEPTIDE3,150:R3-206:
                # R3|PEPTIDE2,PEPTIDE3,235:R3-235:R3|PEPTIDE2,PEPTIDE2,150:R3-206:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTI
                # DE3,PEPTIDE4,226:R3-214:R3|PEPTIDE4,PEPTIDE4,134:R3-194:R3|PEPTIDE2,PEPTIDE1,226:R3-214:R3|PEPTIDE3,PE
                # PTIDE3,373:R3-431:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R3$$$' , 'PEPTIDE1{Q.I.V.L.S.Q.S.P.A.I.L.S.A.S.P.G.E.K
                # .V.T.M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.S.S.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F.S.G.S.G.S.G.T.S
                # .Y.S.L.T.I.S.R.V.E.A.E.D.A.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S
                # .D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T
                # .Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{Q.V.Q.L
                # .Q.Q.P.G.A.E.L.V.K.P.G.A.S.V.K.M.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.T.P.G.R.G.L.E.W.I.G.A.I.Y.P.G.N
                # .G.D.T.S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.K.S.S.S.T.A.Y.M.Q.L.S.S.L.T.S.E.D.S.A.V.Y.Y.C.A.R.S.T.Y.Y.G.G.D.W
                # .Y.F.N.V.W.G.A.G.T.T.V.T.V.S.A.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P
                # .V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H
                # .K.P.S.N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R
                # .T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L
                # .T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E
                # .L.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S
                # .K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{Q.V.Q.L.Q.Q.P
                # .G.A.E.L.V.K.P.G.A.S.V.K.M.S.C.K.A.S.G.Y.T.F.T.S.Y.N.M.H.W.V.K.Q.T.P.G.R.G.L.E.W.I.G.A.I.Y.P.G.N.G.D.T
                # .S.Y.N.Q.K.F.K.G.K.A.T.L.T.A.D.K.S.S.S.T.A.Y.M.Q.L.S.S.L.T.S.E.D.S.A.V.Y.Y.C.A.R.S.T.Y.Y.G.G.D.W.Y.F.N
                # .V.W.G.A.G.T.T.V.T.V.S.A.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V
                # .S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S
                # .N.T.K.V.D.K.K.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E
                # .V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L
                # .H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.D.E.L.T.K
                # .N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T
                # .V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{Q.I.V.L.S.Q.S.P.A.I
                # .L.S.A.S.P.G.E.K.V.T.M.T.C.R.A.S.S.S.V.S.Y.I.H.W.F.Q.Q.K.P.G.S.S.P.K.P.W.I.Y.A.T.S.N.L.A.S.G.V.P.V.R.F
                # .S.G.S.G.S.G.T.S.Y.S.L.T.I.S.R.V.E.A.E.D.A.A.T.Y.Y.C.Q.Q.W.T.S.N.P.P.T.F.G.G.G.T.K.L.E.I.K.R.T.V.A.A.P
                # .S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T
                # .E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$
                # PEPTIDE2,PEPTIDE2,371:R3-429:R3|PEPTIDE1,PEPTIDE1,133:R3-193:R3|PEPTIDE2,PEPTIDE1,224:R3-213:R3|PEPTID
                # E3,PEPTIDE3,148:R3-204:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE4,PEPTIDE4,23:R3-87:R3|PEPTIDE3,PEPTI
                # DE4,224:R3-213:R3|PEPTIDE2,PEPTIDE2,148:R3-204:R3|PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE2,PEPTIDE2,26
                # 5:R3-325:R3|PEPTIDE1,PEPTIDE1,23:R3-87:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE2,PEPTIDE2,22:R3-96:R
                # 3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|PEPTIDE4,PEPTIDE4,133:R3-193:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3$$$' , 
                # 'PEPTIDE1{D.I.Q.M.T.Q.S.P.S.S.V.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.G.I.S.G.W.L.A.W.Y.Q.Q.K.P.G.K.A.P.K.F.
                # L.I.Y.A.A.S.T.L.Q.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.A.N.S.F.P.P.T.
                # F.G.G.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.
                # K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.
                # G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.
                # Y.N.M.N.W.V.R.Q.A.P.G.K.G.L.E.W.V.S.Y.I.S.S.S.S.S.T.I.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.S.L.Q.
                # M.N.S.L.R.D.E.D.T.A.V.Y.Y.C.A.R.A.Y.Y.Y.G.M.D.V.W.G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.
                # S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.
                # V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.
                # G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.
                # A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.
                # K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.
                # N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.
                # S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.S.Y.N.M.N.W.V.R.
                # Q.A.P.G.K.G.L.E.W.V.S.Y.I.S.S.S.S.S.T.I.Y.Y.A.D.S.V.K.G.R.F.T.I.S.R.D.N.A.K.N.S.L.S.L.Q.M.N.S.L.R.D.E.
                # D.T.A.V.Y.Y.C.A.R.A.Y.Y.Y.G.M.D.V.W.G.Q.G.T.T.V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.
                # A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.
                # S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.L.L.G.G.P.S.V.F.L.
                # F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.
                # E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y.K.C.K.V.S.N.K.A.L.P.A.P.I.E.K.T.I.S.K.A.K.G.Q.P.R.
                # E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.
                # P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.
                # K}|PEPTIDE4{D.I.Q.M.T.Q.S.P.S.S.V.S.A.S.V.G.D.R.V.T.I.T.C.R.A.S.Q.G.I.S.G.W.L.A.W.Y.Q.Q.K.P.G.K.A.P.K.
                # F.L.I.Y.A.A.S.T.L.Q.S.G.V.P.S.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.S.L.Q.P.E.D.F.A.T.Y.Y.C.Q.Q.A.N.S.F.P.P.
                # T.F.G.G.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.
                # W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.
                # Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE3,229:R3-229:R3|PEPTIDE2,PEPTIDE2,367:R3-425:R3|PEPTI
                # DE2,PEPTIDE3,226:R3-226:R3|PEPTIDE3,PEPTIDE3,261:R3-321:R3|PEPTIDE3,PEPTIDE4,220:R3-214:R3|PEPTIDE2,PE
                # PTIDE2,22:R3-96:R3|PEPTIDE3,PEPTIDE3,367:R3-425:R3|PEPTIDE1,PEPTIDE1,134:R3-194:R3|PEPTIDE4,PEPTIDE4,1
                # 34:R3-194:R3|PEPTIDE4,PEPTIDE4,23:R3-88:R3|PEPTIDE1,PEPTIDE1,23:R3-88:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3
                # |PEPTIDE3,PEPTIDE3,144:R3-200:R3|PEPTIDE2,PEPTIDE2,144:R3-200:R3|PEPTIDE2,PEPTIDE2,261:R3-321:R3|PEPTI
                # DE2,PEPTIDE1,220:R3-214:R3$$$' , 'PEPTIDE1{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T.L.S.C.R.A.S.Q.R.V.S
                # .S.S.Y.L.A.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.D.A.S.S.R.A.T.G.I.P.D.R.F.S.G.S.G.S.G.T.D.F.T.L.T.I.S.R.L.E.P
                # .E.D.F.A.V.Y.Y.C.Q.Q.Y.G.S.L.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S.D.E.Q.L.K.S.G.T.A.S
                # .V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T.Y.S.L.S.S.T.L.T.L.S
                # .K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}|PEPTIDE2{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P
                # .G.G.S.L.R.L.S.C.A.A.S.G.F.T.F.S.R.Y.W.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.N.I.K.Q.D.G.S.E.K.Y.Y.V.D.S.V.K
                # .G.R.F.T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.E.G.G.W.F.G.E.L.A.F.D.Y.W.G.Q.G.T.L
                # .V.T.V.S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L
                # .T.S.G.V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R
                # .V.E.P.K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.F.E.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D
                # .V.S.H.E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G
                # .K.E.Y.K.C.K.V.S.N.K.A.L.P.A.S.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C
                # .L.V.K.G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q
                # .Q.G.N.V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE3{E.V.Q.L.V.E.S.G.G.G.L.V.Q.P.G.G.S
                # .L.R.L.S.C.A.A.S.G.F.T.F.S.R.Y.W.M.S.W.V.R.Q.A.P.G.K.G.L.E.W.V.A.N.I.K.Q.D.G.S.E.K.Y.Y.V.D.S.V.K.G.R.F
                # .T.I.S.R.D.N.A.K.N.S.L.Y.L.Q.M.N.S.L.R.A.E.D.T.A.V.Y.Y.C.A.R.E.G.G.W.F.G.E.L.A.F.D.Y.W.G.Q.G.T.L.V.T.V
                # .S.S.A.S.T.K.G.P.S.V.F.P.L.A.P.S.S.K.S.T.S.G.G.T.A.A.L.G.C.L.V.K.D.Y.F.P.E.P.V.T.V.S.W.N.S.G.A.L.T.S.G
                # .V.H.T.F.P.A.V.L.Q.S.S.G.L.Y.S.L.S.S.V.V.T.V.P.S.S.S.L.G.T.Q.T.Y.I.C.N.V.N.H.K.P.S.N.T.K.V.D.K.R.V.E.P
                # .K.S.C.D.K.T.H.T.C.P.P.C.P.A.P.E.F.E.G.G.P.S.V.F.L.F.P.P.K.P.K.D.T.L.M.I.S.R.T.P.E.V.T.C.V.V.V.D.V.S.H
                # .E.D.P.E.V.K.F.N.W.Y.V.D.G.V.E.V.H.N.A.K.T.K.P.R.E.E.Q.Y.N.S.T.Y.R.V.V.S.V.L.T.V.L.H.Q.D.W.L.N.G.K.E.Y
                # .K.C.K.V.S.N.K.A.L.P.A.S.I.E.K.T.I.S.K.A.K.G.Q.P.R.E.P.Q.V.Y.T.L.P.P.S.R.E.E.M.T.K.N.Q.V.S.L.T.C.L.V.K
                # .G.F.Y.P.S.D.I.A.V.E.W.E.S.N.G.Q.P.E.N.N.Y.K.T.T.P.P.V.L.D.S.D.G.S.F.F.L.Y.S.K.L.T.V.D.K.S.R.W.Q.Q.G.N
                # .V.F.S.C.S.V.M.H.E.A.L.H.N.H.Y.T.Q.K.S.L.S.L.S.P.G.K}|PEPTIDE4{E.I.V.L.T.Q.S.P.G.T.L.S.L.S.P.G.E.R.A.T
                # .L.S.C.R.A.S.Q.R.V.S.S.S.Y.L.A.W.Y.Q.Q.K.P.G.Q.A.P.R.L.L.I.Y.D.A.S.S.R.A.T.G.I.P.D.R.F.S.G.S.G.S.G.T.D
                # .F.T.L.T.I.S.R.L.E.P.E.D.F.A.V.Y.Y.C.Q.Q.Y.G.S.L.P.W.T.F.G.Q.G.T.K.V.E.I.K.R.T.V.A.A.P.S.V.F.I.F.P.P.S
                # .D.E.Q.L.K.S.G.T.A.S.V.V.C.L.L.N.N.F.Y.P.R.E.A.K.V.Q.W.K.V.D.N.A.L.Q.S.G.N.S.Q.E.S.V.T.E.Q.D.S.K.D.S.T
                # .Y.S.L.S.S.T.L.T.L.S.K.A.D.Y.E.K.H.K.V.Y.A.C.E.V.T.H.Q.G.L.S.S.P.V.T.K.S.F.N.R.G.E.C}$PEPTIDE2,PEPTIDE
                # 2,265:R3-325:R3|PEPTIDE3,PEPTIDE3,148:R3-204:R3|PEPTIDE3,PEPTIDE3,371:R3-429:R3|PEPTIDE2,PEPTIDE2,22:R
                # 3-96:R3|PEPTIDE3,PEPTIDE4,224:R3-215:R3|PEPTIDE3,PEPTIDE3,265:R3-325:R3|PEPTIDE4,PEPTIDE4,23:R3-89:R3|
                # PEPTIDE1,PEPTIDE1,23:R3-89:R3|PEPTIDE2,PEPTIDE1,224:R3-215:R3|PEPTIDE3,PEPTIDE3,22:R3-96:R3|PEPTIDE2,P
                # EPTIDE2,148:R3-204:R3|PEPTIDE2,PEPTIDE3,230:R3-230:R3|PEPTIDE4,PEPTIDE4,135:R3-195:R3|PEPTIDE1,PEPTIDE
                # 1,135:R3-195:R3|PEPTIDE2,PEPTIDE3,233:R3-233:R3|PEPTIDE2,PEPTIDE2,371:R3-429:R3$$$' , 'PEPTIDE1{[dGlp]
                # .E.[dP].[am]}$$$$' , 'PEPTIDE1{D.F.G.Y.V.A.G}$$$$' , 'PEPTIDE1{[X802].L.F}$$$$' , 'PEPTIDE1{[X257].[dL
                # ].F.[dL].F}$$$$' , 'PEPTIDE1{[X12].[dP].Y.[Tle].L}$$$$' , 'PEPTIDE1{[X12].[dP].W.[Tle].[X454]}$$$$'
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1201575' , 'CHEMBL1201580' , 'CHEMBL1201581' , 'CHEMBL1201582' , 'CHEMBL1201583' , 'CHEMBL12015
                # 84' , 'CHEMBL1201586' , 'CHEMBL1201587' , 'CHEMBL1201589' , 'CHEMBL1201599'
            }
        }
    }

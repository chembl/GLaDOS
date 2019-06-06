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
                '_metadata': 
                {
                    'properties': 
                    {
                        'activity_count': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'compound_records': 
                        {
                            'properties': 
                            {
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
                                        'atc_classification': 
                                        {
                                            'properties': 
                                            {
                                            }
                                        },
                                        'biotherapeutic': 
                                        {
                                            'properties': 
                                            {
                                                'biocomponents': 
                                                {
                                                    'properties': 
                                                    {
                                                    }
                                                },
                                            }
                                        },
                                        'molecule_properties': 
                                        {
                                            'properties': 
                                            {
                                            }
                                        },
                                        'molecule_structures': 
                                        {
                                            'properties': 
                                            {
                                            }
                                        },
                                        'molecule_synonyms': 
                                        {
                                            'properties': 
                                            {
                                            }
                                        },
                                    }
                                },
                                'is_drug': 'BOOLEAN',
                                # EXAMPLES:
                                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False
                                # ' , 'False'
                            }
                        },
                        'es_completion': 'TEXT',
                        # EXAMPLES:
                        # '{'weight': 10, 'input': 'CHEMBL71226'}' , '{'weight': 10, 'input': 'CHEMBL302646'}' , '{'weig
                        # ht': 30, 'input': 'InChI=1S/C18H19ClN6O4/c19-12-6-4-10(5-7-12)14(9-15(26)27)23-18(29)25-24-16(
                        # 28)11-2-1-3-13(8-11)22-17(20)21/h1-8,14H,9H2,(H,24,28)(H,26,27)(H4,20,21,22)(H2,23,25,29)'}' ,
                        #  '{'weight': 90, 'input': 'C21H20ClF2N7O2'}' , '{'weight': 90, 'input': 'C13H14F3N'}' , '{'wei
                        # ght': 10, 'input': 'CHEMBL63780'}' , '{'weight': 30, 'input': 'C[C@@H](N)[C@H](O)CCCCCCCCCCCCC
                        # CC(=O)CCCCCCC[C@@H](O)[C@@H](N)CO'}' , '{'weight': 90, 'input': 'C17H23N3O'}' , '{'weight': 10
                        # , 'input': 'CHEMBL56285'}' , '{'weight': 90, 'input': 'C13H14F3N'}'
                        'related_targets': 
                        {
                            'properties': 
                            {
                                'count': 'NUMERIC',
                                # EXAMPLES:
                                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                            }
                        },
                    }
                },
                'atc_classifications': 'TEXT',
                # EXAMPLES:
                # 'N05AF05' , 'N01BX04' , 'N06AX09' , 'N06BX18' , 'M01AE12' , 'C03CA02' , 'C01BG07' , 'C01CX07' , 'N04BX
                # 02' , 'V03AF05'
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
                                # '6747' , '6714' , '6710' , '6690' , '6710' , '6673' , '6742' , '6413' , '6696' , '6754
                                # '
                                'component_type': 'TEXT',
                                # EXAMPLES:
                                # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'P
                                # ROTEIN' , 'PROTEIN' , 'PROTEIN'
                                'description': 'TEXT',
                                # EXAMPLES:
                                # 'Enfuvirtide peptide' , 'Vasopressin-neurophysin 2-copeptin' , 'Serum albumin precurso
                                # r' , 'Calcitonin precursor' , 'Serum albumin precursor' , 'Follitropin beta chain prec
                                # ursor' , 'Interleukin-1 receptor antagonist protein precursor' , 'Trastuzumab heavy ch
                                # ain' , 'Adenosine deaminase' , '[23-methionine]-23-163-fibroblast growth factor 7'
                                'organism': 'TEXT',
                                # EXAMPLES:
                                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , '
                                # Homo sapiens' , 'Bos taurus' , 'Homo sapiens' , 'Homo sapiens' , 'Bos taurus'
                                'sequence': 'TEXT',
                                # EXAMPLES:
                                # 'FWNWLSAWKDLELLEQENKEQQNQSEEILSHILSTY' , 'MPDTMLPACFLGLLAFSSACYFQNCPRGGKRAMSDLELRQCLPC
                                # GPGGKGRCFGPSICCADELGCFVGTAEALRCQEENYLPSPCQSGQKACGSGGRCAAFGVCCNDESCVTEPECREGFHRRARASDRS
                                # NATQLDGPAGALLLRLVQLAGAPEPFEPAQPDAY' , 'MKWVTFISLLFLFSSAYSRGVFRRDAHKSEVAHRFKDLGEENFKALV
                                # LIAFAQYLQQCPFEDHVKLVNEVTEFAKTCVADESAENCDKSLHTLFGDKLCTVATLRETYGEMADCCAKQEPERNECFLQHKDDN
                                # PNLPRLVRPEVDVMCTAFHDNEETFLKKYLYEIARRHPYFYAPELLFFAKRYKAAFTECCQAADKAACLLPKLDELRDEGKASSAK
                                # QRLKCASLQKFGERAFKAWAVARLSQRFPKAEFAEVSKLVTDLTKVHTECCHGDLLECADDRADLAKYICENQDSISSKLKECCEK
                                # PLLEKSHCIAEVENDEMPADLPSLAADFVESKDVCKNYAEAKDVFLGMFLYEYARRHPDYSVVLLLRLAKTYETTLEKCCAAADPH
                                # ECYAKVFDEFKPLVEEPQNLIKQNCELFEQLGEYKFQNALLVRYTKKVPQVSTPTLVEVSRNLGKVGSKCCKHPEAKRMPCAEDYL
                                # SVVLNQLCVLHEKTPVSDRVTKCCTESLVNRRPCFSALEVDETYVPKEFNAETFTFHADICTLSEKERQIKKQTALVELVKHKPKA
                                # TKEQLKAVMDDFAAFVEKCCKADDKETCFAEEGKKLVAASQAALGL' , 'MGFQKFSPFLALSILVLLQAGSLHAAPFRSALESS
                                # PADPATLSEDEARLLLAALVQDYVQMKASELEQEQEREGSSLDSPRSKRCGNLSTCMLGTYTQDFNKFHTFPQTAIGVGAPGKKRD
                                # MSSDLERDHRPHVSMPQNAN' , 'MKWVTFISLLFLFSSAYSRGVFRRDAHKSEVAHRFKDLGEENFKALVLIAFAQYLQQCPFE
                                # DHVKLVNEVTEFAKTCVADESAENCDKSLHTLFGDKLCTVATLRETYGEMADCCAKQEPERNECFLQHKDDNPNLPRLVRPEVDVM
                                # CTAFHDNEETFLKKYLYEIARRHPYFYAPELLFFAKRYKAAFTECCQAADKAACLLPKLDELRDEGKASSAKQRLKCASLQKFGER
                                # AFKAWAVARLSQRFPKAEFAEVSKLVTDLTKVHTECCHGDLLECADDRADLAKYICENQDSISSKLKECCEKPLLEKSHCIAEVEN
                                # DEMPADLPSLAADFVESKDVCKNYAEAKDVFLGMFLYEYARRHPDYSVVLLLRLAKTYETTLEKCCAAADPHECYAKVFDEFKPLV
                                # EEPQNLIKQNCELFEQLGEYKFQNALLVRYTKKVPQVSTPTLVEVSRNLGKVGSKCCKHPEAKRMPCAEDYLSVVLNQLCVLHEKT
                                # PVSDRVTKCCTESLVNRRPCFSALEVDETYVPKEFNAETFTFHADICTLSEKERQIKKQTALVELVKHKPKATKEQLKAVMDDFAA
                                # FVEKCCKADDKETCFAEEGKKLVAASQAALGL' , 'MKTLQFFFLFCCWKAICCNSCELTNITIAIEKEECRFCISINTTWCAGY
                                # CYTRDLVYKDPARPKIQKTCTFKELVYETVRVPGCAHHADSLYTYPVATQCHCGKCDSDSTDCTVRGLGPSYCSFGEMKE' , 'M
                                # EICRGLRSHLITLLLFLFHSETICRPSGRKSSKMQAFRIWDVNQKTFYLRNNQLVAGYLQGPNVNLEEKIDVVPIEPHALFLGIHG
                                # GKMCLSCVKSGDETRLQLEAVNITDLSENRKQDKRFAFIRSDSGPTTSFESAACPGWFLCTAMEADQPVSLTNMPDEGVMVTKFYF
                                # QEDE' , 'EVQLVESGGGLVQPGGSLRLSCAASGFNIKDTYIHWVRQAPGKGLEWVARIYPTNGYTRYADSVKGRFTISADTSKN
                                # TAYLQMNSLRAEDTAVYYCSRWGGDGFYAMDYWGQGTLVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNS
                                # GALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPPKSCDKTHTCPPCPAPELLGGPSVFLFPP
                                # KPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAP
                                # IEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRW
                                # QQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'AQTPAFNKPKVELHVHLDGAIKPETILYYGRKRGIALPADTPEELQNIIGM
                                # DKPLSLPEFLAKFDYYMPAIAGCREAVKRIAYEFVEMKAKDGVVYVEVRYSPHLLANSKVEPIPWNQAEGDLTPDEVVSLVNQGLQ
                                # EGERDFGVKVRSILCCMRHQPSWSSEVVELCKKYREQTVVAIDLAGDETIEGSSLFPGHVKAYAEAVKSGVHRTVHAGEVGSANVV
                                # KEAVDTLKTERLGHGYHTLEDATLYNRLRQENMHFEVCPWSSYLTGAWKPDTEHPVVRFKNDQVNYSLNTDDPLIFKSTLDTDYQM
                                # TKNEMGFTEEEFKRLNINAAKSSFLPEDEKKELLDLLYKAYGMPSPASAEQCL' , 'MSYDYMEGGDIRVRRLFCRTQWYLRIDK
                                # RGKVKGTQEMKNNYNIMEIRTVAVGIVAIKGVESEFYLAMNKEGKLYAKKECNEDCNFKELILENHYNTYASAKWTHNGGEMFVAL
                                # NQKGIPVRGKKTKKEQKTAHFLPMAIT'
                                'tax_id': 'NUMERIC',
                                # EXAMPLES:
                                # '9606' , '9606' , '9606' , '9606' , '9606' , '9606' , '9913' , '9606' , '9606' , '9913
                                # '
                            }
                        },
                        'description': 'TEXT',
                        # EXAMPLES:
                        # 'ENDOMORPHIN-1' , 'ACETYLPROLYLTHREONYLPROLYLSERINAMIDE(ACPTPSNH2)' , 'BRADYKININ' , 'MAGAININ
                        #  I' , 'LAMININ' , 'LIGNESFAL' , 'CYCLOSPORINE' , 'GLYCYLGLYCYLGLYCINE' , 'GASTRIN' , 'THYMOPEN
                        # TIN'
                        'helm_notation': 'TEXT',
                        # EXAMPLES:
                        # 'PEPTIDE1{[ac].[X1693].L.V.G.V.W}$$$$' , 'PEPTIDE1{M.[X113].[X113]}$$$$' , 'PEPTIDE1{[X238].A.
                        # A}$$$$' , 'PEPTIDE1{[X1670].[Abu].[Sar].[meL].V.[meL].A.[X1735].[meL].[meL].[meV]}$PEPTIDE1,PE
                        # PTIDE1,11:R2-1:R1$$$' , 'PEPTIDE1{[X371].F.F.S.Y.R.F.R.[dP].A}$$$$' , 'PEPTIDE1{D.R.C.Y.[dC].H
                        # .P.F}$PEPTIDE1,PEPTIDE1,5:R3-3:R3$$$' , 'PEPTIDE1{R.[dY].[dL].[dP].[lalloT]}$$$$' , 'PEPTIDE1{
                        # [ac].[X1693].L.E.G.I.W}$$$$' , 'PEPTIDE1{[ac].[Nal].F.F.S.Y.R.F.R.[dP].A}$$$$' , 'PEPTIDE1{[X3
                        # ].C.H.[dW].K.[dV].C.[X3].[am]}$PEPTIDE1,PEPTIDE1,7:R3-2:R3$$$'
                        'molecule_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL293180' , 'CHEMBL293837' , 'CHEMBL49134' , 'CHEMBL265358' , 'CHEMBL386689' , 'CHEMBL264
                        # 567' , 'CHEMBL305355' , 'CHEMBL304260' , 'CHEMBL438816' , 'CHEMBL407496'
                    }
                },
                'black_box_warning': 'NUMERIC',
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                'chebi_par_id': 'NUMERIC',
                # EXAMPLES:
                # '6956' , '34231' , '1911' , '17748' , '29036' , '34361' , '27667' , '51364' , '37837' , '17656'
                'chirality': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'cross_references': 
                {
                    'properties': 
                    {
                        'xref_id': 'TEXT',
                        # EXAMPLES:
                        # '85302060' , '24779641' , 'Mitragynine' , '29215473' , '47203754' , '144205113' , '522686' , '
                        # 26659459' , '26665134' , '11111876'
                        'xref_name': 'TEXT',
                        # EXAMPLES:
                        # 'SID: 85302060' , 'SID: 24779641' , 'SID: 29215473' , 'SID: 47203754' , 'SID: 144205113' , 'SI
                        # D: 522686' , 'SID: 26659459' , 'SID: 26665134' , 'SID: 11111876' , 'SID: 22415063'
                        'xref_src': 'TEXT',
                        # EXAMPLES:
                        # 'PubChem' , 'PubChem' , 'Wikipedia' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem
                        # ' , 'PubChem' , 'PubChem'
                    }
                },
                'dosed_ingredient': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'first_approval': 'NUMERIC',
                # EXAMPLES:
                # '2009' , '1955' , '1992' , '1983' , '1999' , '1995' , '1982' , '1993' , '1970' , '2015'
                'first_in_class': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'helm_notation': 'TEXT',
                # EXAMPLES:
                # 'PEPTIDE1{[ac].[X1693].L.V.G.V.W}$$$$' , 'PEPTIDE1{M.[X113].[X113]}$$$$' , 'PEPTIDE1{[X238].A.A}$$$$' 
                # , 'PEPTIDE1{[X1670].[Abu].[Sar].[meL].V.[meL].A.[X1735].[meL].[meL].[meV]}$PEPTIDE1,PEPTIDE1,11:R2-1:R
                # 1$$$' , 'PEPTIDE1{[X371].F.F.S.Y.R.F.R.[dP].A}$$$$' , 'PEPTIDE1{D.R.C.Y.[dC].H.P.F}$PEPTIDE1,PEPTIDE1,
                # 5:R3-3:R3$$$' , 'PEPTIDE1{R.[dY].[dL].[dP].[lalloT]}$$$$' , 'PEPTIDE1{[ac].[X1693].L.E.G.I.W}$$$$' , '
                # PEPTIDE1{[ac].[Nal].F.F.S.Y.R.F.R.[dP].A}$$$$' , 'PEPTIDE1{[X3].C.H.[dW].K.[dV].C.[X3].[am]}$PEPTIDE1,
                # PEPTIDE1,7:R3-2:R3$$$'
                'indication_class': 'TEXT',
                # EXAMPLES:
                # 'Antipsychotic' , 'Antineuralgic, Specific Pain Syndromes, Topical; Analgesic (topical)' , 'Adrenocort
                # ical Steroid,Glucocorticoid' , 'Antidepressant' , 'Sedative (veterinary); Analgesic (veterinary)' , 'A
                # nti-Inflammatory' , 'Diuretic' , 'Cardiac Depressant (anti-arrhythmic)' , 'Enzyme Inhibitor (aldose re
                # ductase)' , 'Stimulant (cardiac)'
                'inorganic_flag': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'max_phase': 'NUMERIC',
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL71226' , 'CHEMBL302646' , 'CHEMBL58367' , 'CHEMBL54281' , 'CHEMBL308587' , 'CHEMBL63780' , 'CHE
                # MBL422410' , 'CHEMBL58493' , 'CHEMBL56285' , 'CHEMBL70384'
                'molecule_hierarchy': 
                {
                    'properties': 
                    {
                        'molecule_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL71226' , 'CHEMBL302646' , 'CHEMBL58367' , 'CHEMBL54281' , 'CHEMBL308587' , 'CHEMBL63780
                        # ' , 'CHEMBL422410' , 'CHEMBL58493' , 'CHEMBL56285' , 'CHEMBL70384'
                        'parent_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL71226' , 'CHEMBL302646' , 'CHEMBL58367' , 'CHEMBL54281' , 'CHEMBL308587' , 'CHEMBL63780
                        # ' , 'CHEMBL422410' , 'CHEMBL58493' , 'CHEMBL56285' , 'CHEMBL70384'
                    }
                },
                'molecule_properties': 
                {
                    'properties': 
                    {
                        'acd_logd': 'NUMERIC',
                        # EXAMPLES:
                        # '3' , '-8.86' , '-2.28' , '4.32' , '1.2' , '0' , '0.55' , '3.34' , '2.56' , '0.73'
                        'acd_logp': 'NUMERIC',
                        # EXAMPLES:
                        # '4.78' , '-6.36' , '0.91' , '4.32' , '3.57' , '0.02' , '4.63' , '3.86' , '2.57' , '3.11'
                        'acd_most_apka': 'NUMERIC',
                        # EXAMPLES:
                        # '5.37' , '4.01' , '4.45' , '11.09' , '7.89' , '12.56' , '9.43' , '11.95' , '10.74' , '3.96'
                        'acd_most_bpka': 'NUMERIC',
                        # EXAMPLES:
                        # '9.65' , '13.36' , '10.14' , '2.87' , '9.86' , '9.55' , '7.3' , '6.03' , '9.88' , '8.69'
                        'alogp': 'NUMERIC',
                        # EXAMPLES:
                        # '6.24' , '-5.02' , '1.81' , '2.51' , '3.08' , '0.3' , '5.14' , '3.22' , '4.02' , '3.08'
                        'aromatic_rings': 'NUMERIC',
                        # EXAMPLES:
                        # '4' , '1' , '2' , '4' , '1' , '1' , '0' , '2' , '4' , '1'
                        'full_molformula': 'TEXT',
                        # EXAMPLES:
                        # 'C29H30Cl2N4O2' , 'C26H37N9O10S' , 'C18H19ClN6O4' , 'C21H20ClF2N7O2' , 'C13H14F3N' , 'C11H9FN4
                        # O3' , 'C28H58N2O4' , 'C17H23N3O' , 'C17H12N4O2' , 'C13H14F3N'
                        'full_mwt': 'NUMERIC',
                        # EXAMPLES:
                        # '537.49' , '667.7' , '418.84' , '475.89' , '241.26' , '264.22' , '486.78' , '285.39' , '304.31
                        # ' , '241.26'
                        'hba': 'NUMERIC',
                        # EXAMPLES:
                        # '5' , '10' , '4' , '8' , '1' , '3' , '6' , '4' , '4' , '1'
                        'hba_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '6' , '19' , '10' , '9' , '1' , '7' , '6' , '4' , '6' , '1'
                        'hbd': 'NUMERIC',
                        # EXAMPLES:
                        # '1' , '11' , '7' , '2' , '1' , '3' , '5' , '1' , '2' , '1'
                        'hbd_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '1' , '13' , '8' , '2' , '2' , '3' , '7' , '1' , '2' , '2'
                        'heavy_atoms': 'NUMERIC',
                        # EXAMPLES:
                        # '37' , '46' , '29' , '33' , '17' , '19' , '34' , '21' , '23' , '17'
                        'molecular_species': 'TEXT',
                        # EXAMPLES:
                        # 'ZWITTERION' , 'ZWITTERION' , 'ZWITTERION' , 'NEUTRAL' , 'BASE' , 'NEUTRAL' , 'BASE' , 'NEUTRA
                        # L' , 'NEUTRAL' , 'BASE'
                        'mw_freebase': 'NUMERIC',
                        # EXAMPLES:
                        # '537.49' , '667.7' , '418.84' , '475.89' , '241.26' , '264.22' , '486.78' , '285.39' , '304.31
                        # ' , '241.26'
                        'mw_monoisotopic': 'NUMERIC',
                        # EXAMPLES:
                        # '536.1746' , '667.2384' , '418.1156' , '475.1335' , '241.1078' , '264.0659' , '486.4397' , '28
                        # 5.1841' , '304.096' , '241.1078'
                        'num_lipinski_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '2' , '3' , '1' , '0' , '0' , '0' , '2' , '0' , '0' , '0'
                        'num_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '2' , '2' , '1' , '0' , '0' , '0' , '1' , '0' , '0' , '0'
                        'psa': 'NUMERIC',
                        # EXAMPLES:
                        # '61.6' , '325.09' , '169.43' , '110.75' , '26.02' , '90.54' , '129.8' , '41.29' , '80.05' , '2
                        # 6.02'
                        'qed_weighted': 'NUMERIC',
                        # EXAMPLES:
                        # '0.29' , '0.07' , '0.21' , '0.44' , '0.74' , '0.59' , '0.11' , '0.86' , '0.59' , '0.74'
                        'ro3_pass': 'TEXT',
                        # EXAMPLES:
                        # 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
                        'rtb': 'NUMERIC',
                        # EXAMPLES:
                        # '8' , '9' , '6' , '6' , '0' , '0' , '26' , '2' , '2' , '0'
                    }
                },
                'molecule_structures': 
                {
                    'properties': 
                    {
                        'canonical_smiles': 'TEXT',
                        # EXAMPLES:
                        # 'CN(CC(CCN1CCC(C1)n2c(O)nc3ccccc23)c4ccc(Cl)c(Cl)c4)C(=O)c5ccccc5' , 'NC(=N)NCCC[C@@H]1NC(=O)[
                        # C@H](Cc2ccc(O)cc2)NC(=O)C[S+]([O-])C[C@H](NC(=O)[C@H](CC(=O)O)NC(=O)CNC1=O)C(=O)N' , 'NC(=N)Nc
                        # 1cccc(c1)C(=O)NNC(=O)NC(CC(=O)O)c2ccc(Cl)cc2' , 'C[C@@H](NC(=O)c1cnc2c(c(C)nn2C)c1Cl)[C@](O)(C
                        # n3cncn3)c4ccc(F)cc4F' , 'N[C@H]1C2CCC1c3ccc(cc3C2)C(F)(F)F' , 'CN1C(=O)Nc2ccc(F)cc2[C@]13NC(=O
                        # )NC3=O' , 'C[C@@H](N)[C@H](O)CCCCCCCCCCCCCCC(=O)CCCCCCC[C@@H](O)[C@@H](N)CO' , 'C[C@H]1Cn2c(O)
                        # nc3ccc(C)c(CN1CC=C(C)C)c23' , 'O=C(Nc1ccc2ncoc2c1)Nc3ccnc4ccccc34' , 'N[C@H]1C2CCC1c3cccc(c3C2
                        # )C(F)(F)F'
                        'standard_inchi': 'TEXT',
                        # EXAMPLES:
                        # 'InChI=1S/C29H30Cl2N4O2/c1-33(28(36)20-7-3-2-4-8-20)18-22(21-11-12-24(30)25(31)17-21)13-15-34-
                        # 16-14-23(19-34)35-27-10-6-5-9-26(27)32-29(35)37/h2-12,17,22-23H,13-16,18-19H2,1H3,(H,32,37)' ,
                        #  'InChI=1S/C26H37N9O10S/c27-22(41)18-11-46(45)12-20(38)33-16(8-13-3-5-14(36)6-4-13)24(43)34-15
                        # (2-1-7-30-26(28)29)23(42)31-10-19(37)32-17(9-21(39)40)25(44)35-18/h3-6,15-18,36H,1-2,7-12H2,(H
                        # 2,27,41)(H,31,42)(H,32,37)(H,33,38)(H,34,43)(H,35,44)(H,39,40)(H4,28,29,30)/t15-,16-,17-,18-,4
                        # 6?/m0/s1' , 'InChI=1S/C18H19ClN6O4/c19-12-6-4-10(5-7-12)14(9-15(26)27)23-18(29)25-24-16(28)11-
                        # 2-1-3-13(8-11)22-17(20)21/h1-8,14H,9H2,(H,24,28)(H,26,27)(H4,20,21,22)(H2,23,25,29)' , 'InChI=
                        # 1S/C21H20ClF2N7O2/c1-11-17-18(22)14(7-26-19(17)30(3)29-11)20(32)28-12(2)21(33,8-31-10-25-9-27-
                        # 31)15-5-4-13(23)6-16(15)24/h4-7,9-10,12,33H,8H2,1-3H3,(H,28,32)/t12-,21-/m1/s1' , 'InChI=1S/C1
                        # 3H14F3N/c14-13(15,16)9-2-4-10-8(6-9)5-7-1-3-11(10)12(7)17/h2,4,6-7,11-12H,1,3,5,17H2/t7?,11?,1
                        # 2-/m0/s1' , 'InChI=1S/C11H9FN4O3/c1-16-10(19)13-7-3-2-5(12)4-6(7)11(16)8(17)14-9(18)15-11/h2-4
                        # H,1H3,(H,13,19)(H2,14,15,17,18)/t11-/m0/s1' , 'InChI=1S/C28H58N2O4/c1-24(29)27(33)21-17-13-9-7
                        # -5-3-2-4-6-8-11-15-19-25(32)20-16-12-10-14-18-22-28(34)26(30)23-31/h24,26-28,31,33-34H,2-23,29
                        # -30H2,1H3/t24-,26+,27-,28-/m1/s1' , 'InChI=1S/C17H23N3O/c1-11(2)7-8-19-10-14-12(3)5-6-15-16(14
                        # )20(9-13(19)4)17(21)18-15/h5-7,13H,8-10H2,1-4H3,(H,18,21)/t13-/m0/s1' , 'InChI=1S/C17H12N4O2/c
                        # 22-17(20-11-5-6-15-16(9-11)23-10-19-15)21-14-7-8-18-13-4-2-1-3-12(13)14/h1-10H,(H2,18,20,21,22
                        # )' , 'InChI=1S/C13H14F3N/c14-13(15,16)11-3-1-2-8-9-5-4-7(12(9)17)6-10(8)11/h1-3,7,9,12H,4-6,17
                        # H2/t7?,9?,12-/m0/s1'
                        'standard_inchi_key': 'TEXT',
                        # EXAMPLES:
                        # 'FPXIRXAXVYUYRD-UHFFFAOYSA-N' , 'RKSHZSNKMSLOIR-OBHJWUNDSA-N' , 'BGDLLUWAZFBMGD-UHFFFAOYSA-N' 
                        # , 'LGPNRNKNCSFAAB-XUSGNXJCSA-N' , 'WOHWQAPSLJHLKN-XYYUTVHRSA-N' , 'DSSUGKGGKJBYSZ-NSHDSACASA-N
                        # ' , 'MLAUFTDRZCCVCB-KCPYNUOSSA-N' , 'SRXHAHDKMWLWJV-ZDUSSCGKSA-N' , 'QQYLJWXEIDXLMW-UHFFFAOYSA
                        # -N' , 'GVBOIVFALSGRQZ-FMDDCXKFSA-N'
                    }
                },
                'molecule_synonyms': 
                {
                    'properties': 
                    {
                        'molecule_synonym': 'TEXT',
                        # EXAMPLES:
                        # 'Imidazole-1-Carboxylic Acid Diethylamide' , 'DMP-581' , 'sulfamidas16' , 'TCMDC-137350' , '3,
                        # 3,18,18-Tetramethyl-Icosanedioic Acid' , 'Thymidin' , 'Isoquinolin-5-ol' , 'NSC-9152' , 'BMS-1
                        # 83920' , 'AG-490'
                        'syn_type': 'TEXT',
                        # EXAMPLES:
                        # 'OTHER' , 'RESEARCH_CODE' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'RESEARCH_CODE' 
                        # , 'RESEARCH_CODE' , 'RESEARCH_CODE'
                        'synonyms': 'TEXT',
                        # EXAMPLES:
                        # 'Imidazole-1-Carboxylic Acid Diethylamide' , 'DMP-581' , 'sulfamidas16' , 'TCMDC-137350' , '3,
                        # 3,18,18-Tetramethyl-Icosanedioic Acid' , 'Thymidin' , 'Isoquinolin-5-ol' , 'NSC-9152' , 'BMS-1
                        # 83920' , 'AG-490'
                    }
                },
                'molecule_type': 'TEXT',
                # EXAMPLES:
                # 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small 
                # molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule' , 'Small molecule'
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
                # 'N-[(1E)-1-(5-methylpyrazin-2-yl)ethylidene]-3-azabicyclo[3.2.2]nonane-3-carbohydrazonothioic acid.chl
                # oro Cu(II)complex' , 'THYMIDINE' , 'RuCl2(clotrimazole)2' , 'COPPER' , '4'-HYDROXY-FLAVANONE' , 'b-D-G
                # ALACTOSE' , 'ZUCLOPENTHIXOL' , '2-NAPHTHYLACETIC ACID' , 'CAPSAICIN' , 'OXYPHYLLENODIOL A'
                'prodrug': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'structure_type': 'TEXT',
                # EXAMPLES:
                # 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL' , 'MOL'
                'therapeutic_flag': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'topical': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'usan_stem': 'TEXT',
                # EXAMPLES:
                # '-cort-' , '-stat' , '-xaban' , '-pidem' , '-pin(e)' , '-sartan' , 'vin-' , 'io-' , '-tidine' , 'gab-'
                'usan_stem_definition': 'TEXT',
                # EXAMPLES:
                # 'cortisone derivatives' , 'enzyme inhibitors: matrix metalloprotease inhibitors' , 'antithrombotic: bl
                # ood coagulation factor XA inhibitors' , 'hypnotics/sedatives (zolpidem type)' , 'tricyclic compounds' 
                # , 'angiotensin II receptor antagonists' , 'vinca alkaloids' , 'iodine-containing contrast media' , 'H2
                # -receptor antagonists (cimetidine type)' , 'gabamimetics'
                'usan_substem': 'TEXT',
                # EXAMPLES:
                # '-cort-' , '-stat(-mastat)' , '-xaban' , '-pidem' , '-pin(e)' , '-sartan' , 'vin-' , 'io-' , '-tidine'
                #  , 'gab-'
                'usan_year': 'NUMERIC',
                # EXAMPLES:
                # '2003' , '2004' , '1976' , '1981' , '1987' , '1973' , '1976' , '1981' , '2000' , '1976'
                'withdrawn_class': 'TEXT',
                # EXAMPLES:
                # 'Cardiotoxicity' , 'Hepatotoxicity' , 'Dermatological toxicity; Vascular toxicity' , 'Respiratory toxi
                # city' , 'Dermatological toxicity' , 'Cardiotoxicity; Neurotoxicity' , 'Immune system toxicity' , 'Derm
                # atological toxicity; Hematological toxicity; Hepatotoxicity' , 'Opthalmic toxicity' , 'Hepatotoxicity'
                'withdrawn_country': 'TEXT',
                # EXAMPLES:
                # 'United States' , 'France' , 'United Kingdom' , 'Germany' , 'United States' , 'Spain; Germany; France'
                #  , 'United States' , 'United States' , 'Germany; France' , 'Germany'
                'withdrawn_flag': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'withdrawn_reason': 'TEXT',
                # EXAMPLES:
                # 'Valvulopathy' , 'Hepatotoxicity' , 'Vasculitis; Rash' , 'Respiratory Reaction' , 'Stevens Johnson Syn
                # drome; Toxic Epidermal Necrolysis' , 'Risk for heart attack, stroke, and unstable angina' , 'Anaphylax
                # is' , 'Dermatologic, Hematologic and Hepatic Reactions' , 'Uveitis' , 'Unspecific Experimental Toxicit
                # y'
                'withdrawn_year': 'NUMERIC',
                # EXAMPLES:
                # '1987' , '1979' , '1989' , '1983' , '2007' , '1984' , '1988' , '1990' , '1984' , '1997'
            }
        }
    }

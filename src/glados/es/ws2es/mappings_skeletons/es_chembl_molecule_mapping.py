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
                        # '{'weight': 30, 'input': 'InChI=1S/C26H34N4O5/c1-18-15-25(33)29-30-26(18)20-5-7-21(8-6-20)28-2
                        # 4(32)11-13-27-16-22(31)17-35-23-9-3-19(4-10-23)12-14-34-2/h3-10,18,22,27,31H,11-17H2,1-2H3,(H,
                        # 28,32)(H,29,33)'}' , '{'weight': 30, 'input': 'CC1(C)C[C@@H](O)C[C@](C)(CNC(=O)c2ccccc2O)C1'}'
                        #  , '{'weight': 10, 'input': 'CHEMBL116932'}' , '{'weight': 90, 'input': 'C19H18Cl2N2O4S'}' , '
                        # {'weight': 10, 'input': 'CHEMBL333152'}' , '{'weight': 30, 'input': 'CC(C)Cn1c(=O)cc(C(=O)OC2C
                        # C3CCC(C2)N3C)c2ccccc21'}' , '{'weight': 10, 'input': 'CHEMBL115834'}' , '{'weight': 10, 'input
                        # ': 'CHEMBL323664'}' , '{'weight': 30, 'input': 'CN(C)CCCCCCC/N=C1\\CC(c2ccc(Cl)c(Cl)c2)Cc2c1c(
                        # =O)c1cc(Cl)ccc1n2O'}' , '{'weight': 90, 'input': 'C57H83N5O14Si2'}'
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
                # 'A06AX05' , 'R06AX27' , 'N06AX01' , 'D05AC51' , 'S02AA03' , 'A03AA04' , 'V03AB26' , 'D08AE04' , 'M01AB
                # 13' , 'C04AX02'
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
                                # '6700' , '6710' , '6365' , '6710' , '6731' , '6720' , '6726' , '6677' , '6720' , '6738
                                # '
                                'component_type': 'TEXT',
                                # EXAMPLES:
                                # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'P
                                # ROTEIN' , 'PROTEIN' , 'PROTEIN'
                                'description': 'TEXT',
                                # EXAMPLES:
                                # 'Fibrinogen alpha/alpha-E chain precursor' , 'Serum albumin precursor' , 'Tositumomab 
                                # heavy chain' , 'Serum albumin precursor' , 'Urokinase-type plasminogen activator precu
                                # rsor' , 'Purified bovine insulin zinc suspension' , 'Lutropin beta chain precursor' , 
                                # 'Purified semisynthetic human insulin zinc suspension' , 'Purified bovine insulin zinc
                                #  suspension' , 'Interleukin-11 precursor'
                                'organism': 'TEXT',
                                # EXAMPLES:
                                # 'Homo sapiens' , 'Homo sapiens' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens' , '
                                # Bos taurus' , 'Homo sapiens' , 'Homo sapiens' , 'Bos taurus' , 'Homo sapiens'
                                'sequence': 'TEXT',
                                # EXAMPLES:
                                # 'MFSMRIVCLVLSVVGTAWTADSGEGDFLAEGGGVRGPRVVERHQSACKDSDWPFCSDEDWNYKCPSGCRMKGLIDEVNQDFTNRI
                                # NKLKNSLFEYQKNNKDSHSLTTNIMEILRGDFSSANNRDNTYNRVSEDLRSRIEVLKRKVIEKVQHIQLLQKNVRAQLVDMKRLEV
                                # DIDIKIRSCRGSCSRALAREVDLKDYEDQQKQLEQVIAKDLLPSRDRQHLPLIKMKPVPDLVPGNFKSQLQKVPPEWKALTDMPQM
                                # RMELERPGGNEITRGGSTSYGTGSETESPRNPSSAGSWNSGSSGPGSTGNRNPGSSGTGGTATWKPGSSGPGSTGSWNSGSSGTGS
                                # TGNQNPGSPRPGSTGTWNPGSSERGSAGHWTSESSVSGSTGQWHSESGSFRPDSPGSGNARPNNPDWGTFEEVSGNVSPGTRREYH
                                # TEKLVTSKGDKELRTGKEKVTSGSTTTTRRSCSKTVTKTVIGPDGHKEVTKEVVTSEDGSDCPEAMDLGTLSGIGTLDGFRHRHPD
                                # EAAFFDTASTGKTFPGFFSPMLGEFVSETESRGSESGIFTNTKESSSHHPGIAEFPSRGKSSSYSKQFTSSTSYNRGDSTFESKSY
                                # KMADEAGSEADHEGTHSTKRGHAKSRPVRDCDDVLQTHPSGTQSGIFNIKLPGSSKIFSVYCDQETSLGGWLLIQQRMDGSLNFNR
                                # TWQDYKRGFGSLNDEGEGEFWLGNDYLHLLTQRGSVLRVELEDWAGNEAYAEYHFRVGSEAEGYALQVSSYEGTAGDALIEGSVEE
                                # GAEYTSHNNMQFSTFDRDADQWEENCAEVYGGGWWYNNCQAANLNGIYYPGGSYDPRNNSPYEIENGVVWVSFRGADYSLRAVRMK
                                # IRPLVTQ' , 'MKWVTFISLLFLFSSAYSRGVFRRDAHKSEVAHRFKDLGEENFKALVLIAFAQYLQQCPFEDHVKLVNEVTEFA
                                # KTCVADESAENCDKSLHTLFGDKLCTVATLRETYGEMADCCAKQEPERNECFLQHKDDNPNLPRLVRPEVDVMCTAFHDNEETFLK
                                # KYLYEIARRHPYFYAPELLFFAKRYKAAFTECCQAADKAACLLPKLDELRDEGKASSAKQRLKCASLQKFGERAFKAWAVARLSQR
                                # FPKAEFAEVSKLVTDLTKVHTECCHGDLLECADDRADLAKYICENQDSISSKLKECCEKPLLEKSHCIAEVENDEMPADLPSLAAD
                                # FVESKDVCKNYAEAKDVFLGMFLYEYARRHPDYSVVLLLRLAKTYETTLEKCCAAADPHECYAKVFDEFKPLVEEPQNLIKQNCEL
                                # FEQLGEYKFQNALLVRYTKKVPQVSTPTLVEVSRNLGKVGSKCCKHPEAKRMPCAEDYLSVVLNQLCVLHEKTPVSDRVTKCCTES
                                # LVNRRPCFSALEVDETYVPKEFNAETFTFHADICTLSEKERQIKKQTALVELVKHKPKATKEQLKAVMDDFAAFVEKCCKADDKET
                                # CFAEEGKKLVAASQAALGL' , 'QAYLQQSGAELVRPGASVKMSCKASGYTFTSYNMHWVKQTPRQGLEWIGAIYPGNGDTSYNQ
                                # KFKGKATLTVDKSSSTAYMQLSSLTSEDSAVYFCARVVYYSNSYWYFDVWGTGTTVTVSGPSVFPLAPSSKSTSGGTAALGCLVKD
                                # YFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKAEPKSCDKTHTCPPCPAPEL
                                # LGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYK
                                # CKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFL
                                # YSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'MKWVTFISLLFLFSSAYSRGVFRRDAHKSEVAHRFKDLGE
                                # ENFKALVLIAFAQYLQQCPFEDHVKLVNEVTEFAKTCVADESAENCDKSLHTLFGDKLCTVATLRETYGEMADCCAKQEPERNECF
                                # LQHKDDNPNLPRLVRPEVDVMCTAFHDNEETFLKKYLYEIARRHPYFYAPELLFFAKRYKAAFTECCQAADKAACLLPKLDELRDE
                                # GKASSAKQRLKCASLQKFGERAFKAWAVARLSQRFPKAEFAEVSKLVTDLTKVHTECCHGDLLECADDRADLAKYICENQDSISSK
                                # LKECCEKPLLEKSHCIAEVENDEMPADLPSLAADFVESKDVCKNYAEAKDVFLGMFLYEYARRHPDYSVVLLLRLAKTYETTLEKC
                                # CAAADPHECYAKVFDEFKPLVEEPQNLIKQNCELFEQLGEYKFQNALLVRYTKKVPQVSTPTLVEVSRNLGKVGSKCCKHPEAKRM
                                # PCAEDYLSVVLNQLCVLHEKTPVSDRVTKCCTESLVNRRPCFSALEVDETYVPKEFNAETFTFHADICTLSEKERQIKKQTALVEL
                                # VKHKPKATKEQLKAVMDDFAAFVEKCCKADDKETCFAEEGKKLVAASQAALGL' , 'MRALLARLLLCVLVVSDSKGSNELHQVP
                                # SNCDCLNGGTCVSNKYFSNIHWCNCPKKFGGQHCEIDKSKTCYEGNGHFYRGKASTDTMGRPCLPWNSATVLQQTYHAHRSDALQL
                                # GLGKHNYCRNPDNRRRPWCYVQVGLKPLVQECMVHDCADGKKPSSPPEELKFQCGQKTLRPRFKIIGGEFTTIENQPWFAAIYRRH
                                # RGGSVTYVCGGSLMSPCWVISATHCFIDYPKKEDYIVYLGRSRLNSNTQGEMKFEVENLILHKDYSADTLAHHNDIALLKIRSKEG
                                # RCAQPSRTIQTICLPSMYNDPQFGTSCEITGFGKENSTDYLYPEQLKMTVVKLISHRECQQPHYYGSEVTTKMLCAADPQWKTDSC
                                # QGDSGGPLVCSLQGRMTLTGIVSWGRGCALKDKPGVYTRVSHFLPWIRSHTKEENGLAL' , 'MALWTRLRPLLALLALWPPPPA
                                # RAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVGALELAGGPGAGGLEGPPQKRGIVEQCCASVCSLYQLENYCN' ,
                                #  'MEMLQGLLLLLLLSMGGAWASREPLRPWCHPINAILAVEKEGCPVCITVNTTICAGYCPTMMRVLQAVLPPLPQVVCTYRDVRF
                                # ESIRLPGCPRGVDPVVSFPVALSCRCGPCRRSTSDCGGPKDHPLTCDHPQLSGLLFL' , 'MALWMRLLPLLALLALWGPDPAAA
                                # FVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAEDLQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN
                                # ' , 'MALWTRLRPLLALLALWPPPPARAFVNQHLCGSHLVEALYLVCGERGFFYTPKARREVEGPQVGALELAGGPGAGGLEGPP
                                # QKRGIVEQCCASVCSLYQLENYCN' , 'MNCVCRLVLVVLSLWPDTAVAPGPPPGPPRVSPDPRAELDSTVLLTRSLLADTRQLA
                                # AQLRDKFPADGDHNLDSLPTLAMSAGALGALQLPGVLTRLRADLLSYLRHVQWLRRAGGSSLKTLEPELGTLQARLDRLLRRLQLL
                                # MSRLALPQPPPDPPAPPLAPPSSAWGGIRAAHAILGGLHLTLDWAVRGLLLLKTRL'
                                'tax_id': 'NUMERIC',
                                # EXAMPLES:
                                # '9606' , '9606' , '10090' , '9606' , '9606' , '9913' , '9606' , '9606' , '9913' , '960
                                # 6'
                            }
                        },
                        'description': 'TEXT',
                        # EXAMPLES:
                        # 'LAMININ' , 'ENDOMORPHIN 2' , 'LIGNESFAL' , 'KIFGSLAFL' , 'BRADYKININ' , 'SEGETALIN C' , 'VASO
                        # PRESSIN' , 'ARGIFIN' , 'MELATONAN' , 'SPINORPHIN'
                        'helm_notation': 'TEXT',
                        # EXAMPLES:
                        # 'PEPTIDE1{F.C.G.[X1124].C.[am]}$PEPTIDE1,PEPTIDE1,5:R3-2:R3$$$' , 'PEPTIDE1{[Cbz_L].L.[X2431]}
                        # $$$$' , 'PEPTIDE1{[Cbz_L].L.[X2439]}$$$$' , 'PEPTIDE1{[dC].[dY].S.[dD].T.[dL].[dC].[am]}$PEPTI
                        # DE1,PEPTIDE1,7:R3-1:R3$$$' , 'PEPTIDE1{[Glp].L.Y.E.N.K.P.R.R.[dP].Y.I.L}$$$$' , 'PEPTIDE1{A.A.
                        # K.C.R.A.A}$$$$' , 'PEPTIDE1{C.R.[dS].D.[dalloT].L.C.G.E.[am]}$PEPTIDE1,PEPTIDE1,7:R3-1:R3$$$' 
                        # , 'PEPTIDE1{D.C.R.[dS].D.[dalloT].L.C.G.E.[am]}$PEPTIDE1,PEPTIDE1,8:R3-2:R3$$$' , 'PEPTIDE1{R.
                        # L.M.K.Q.D.F.S.V}$$$$' , 'PEPTIDE1{[ac].Y.A.G.T.V.[lalloI].N.D.L}$$$$'
                        'molecule_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL113782' , 'CHEMBL325264' , 'CHEMBL331153' , 'CHEMBL407428' , 'CHEMBL384751' , 'CHEMBL11
                        # 6449' , 'CHEMBL323620' , 'CHEMBL384511' , 'CHEMBL386201' , 'CHEMBL413193'
                    }
                },
                'black_box_warning': 'NUMERIC',
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                'chebi_par_id': 'NUMERIC',
                # EXAMPLES:
                # '16113' , '45133' , '4918' , '36802' , '49019' , '62851' , '28826' , '36014' , '39931' , '50371'
                'chirality': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'cross_references': 
                {
                    'properties': 
                    {
                        'xref_id': 'TEXT',
                        # EXAMPLES:
                        # '26754461' , '144207623' , '505946' , '144209545' , 'Dosulepin' , '144211225' , '505645' , '49
                        # 3644' , 'Diminazen' , 'Fluoromethane'
                        'xref_name': 'TEXT',
                        # EXAMPLES:
                        # 'SID: 26754461' , 'SID: 144207623' , 'SID: 505946' , 'SID: 144209545' , 'SID: 144211225' , 'SI
                        # D: 505645' , 'SID: 493644' , 'SID: 144207353' , 'SID: 144208909' , 'SID: 144209633'
                        'xref_src': 'TEXT',
                        # EXAMPLES:
                        # 'PubChem' , 'PubChem' , 'PubChem' , 'PubChem' , 'Wikipedia' , 'PubChem' , 'PubChem' , 'PubChem
                        # ' , 'Wikipedia' , 'Wikipedia'
                    }
                },
                'dosed_ingredient': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'first_approval': 'NUMERIC',
                # EXAMPLES:
                # '2018' , '2001' , '1989' , '2002' , '1997' , '1991' , '1953' , '1999' , '1994' , '1995'
                'first_in_class': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'helm_notation': 'TEXT',
                # EXAMPLES:
                # 'PEPTIDE1{F.C.G.[X1124].C.[am]}$PEPTIDE1,PEPTIDE1,5:R3-2:R3$$$' , 'PEPTIDE1{[Cbz_L].L.[X2431]}$$$$' , 
                # 'PEPTIDE1{[Cbz_L].L.[X2439]}$$$$' , 'PEPTIDE1{[dC].[dY].S.[dD].T.[dL].[dC].[am]}$PEPTIDE1,PEPTIDE1,7:R
                # 3-1:R3$$$' , 'PEPTIDE1{[Glp].L.Y.E.N.K.P.R.R.[dP].Y.I.L}$$$$' , 'PEPTIDE1{A.A.K.C.R.A.A}$$$$' , 'PEPTI
                # DE1{C.R.[dS].D.[dalloT].L.C.G.E.[am]}$PEPTIDE1,PEPTIDE1,7:R3-1:R3$$$' , 'PEPTIDE1{D.C.R.[dS].D.[dalloT
                # ].L.C.G.E.[am]}$PEPTIDE1,PEPTIDE1,8:R3-2:R3$$$' , 'PEPTIDE1{R.L.M.K.Q.D.F.S.V}$$$$' , 'PEPTIDE1{[ac].Y
                # .A.G.T.V.[lalloI].N.D.L}$$$$'
                'indication_class': 'TEXT',
                # EXAMPLES:
                # 'Pharmaceutic Aid (emulsifying agent)' , 'Antihypertensive' , 'Antibacterial' , 'Antihypertensive' , '
                # Pharmaceutic Aid (aerosol propellant)' , 'Tranquilizer (minor)' , 'Anesthesia, Adjunct To' , 'Sweetene
                # r' , 'Antipsoriatic' , 'Relaxant (smooth muscle)'
                'inorganic_flag': 'NUMERIC',
                # EXAMPLES:
                # '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1' , '-1'
                'max_phase': 'NUMERIC',
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL119399' , 'CHEMBL325165' , 'CHEMBL116932' , 'CHEMBL118688' , 'CHEMBL333152' , 'CHEMBL113519' , 
                # 'CHEMBL115834' , 'CHEMBL323664' , 'CHEMBL324356' , 'CHEMBL429241'
                'molecule_hierarchy': 
                {
                    'properties': 
                    {
                        'molecule_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL119399' , 'CHEMBL325165' , 'CHEMBL116932' , 'CHEMBL118688' , 'CHEMBL333152' , 'CHEMBL11
                        # 3519' , 'CHEMBL115834' , 'CHEMBL323664' , 'CHEMBL324356' , 'CHEMBL429241'
                        'parent_chembl_id': 'TEXT',
                        # EXAMPLES:
                        # 'CHEMBL119399' , 'CHEMBL325165' , 'CHEMBL116932' , 'CHEMBL118688' , 'CHEMBL333152' , 'CHEMBL11
                        # 3519' , 'CHEMBL115834' , 'CHEMBL323664' , 'CHEMBL324356' , 'CHEMBL429241'
                    }
                },
                'molecule_properties': 
                {
                    'properties': 
                    {
                        'alogp': 'NUMERIC',
                        # EXAMPLES:
                        # '2.09' , '2.70' , '2.67' , '2.47' , '3.83' , '3.44' , '0.18' , '4.17' , '7.23' , '3.85'
                        'aromatic_rings': 'NUMERIC',
                        # EXAMPLES:
                        # '2' , '1' , '1' , '2' , '2' , '2' , '1' , '0' , '3' , '1'
                        'cx_logd': 'NUMERIC',
                        # EXAMPLES:
                        # '0.18' , '3.02' , '2.84' , '2.93' , '4.65' , '1.12' , '0.05' , '3.20' , '5.02' , '4.30'
                        'cx_logp': 'NUMERIC',
                        # EXAMPLES:
                        # '1.71' , '3.09' , '2.84' , '2.93' , '5.00' , '3.13' , '0.05' , '3.20' , '7.39' , '4.30'
                        'cx_most_apka': 'NUMERIC',
                        # EXAMPLES:
                        # '11.78' , '8.19' , '13.86' , '11.63' , '10.31' , '9.62' , '13.96' , '12.29' , '9.28' , '3.59'
                        'cx_most_bpka': 'NUMERIC',
                        # EXAMPLES:
                        # '8.93' , '7.48' , '9.42' , '9.79' , '9.93' , '9.94' , '5.27' , '5.85' , '0.42' , '4.15'
                        'full_molformula': 'TEXT',
                        # EXAMPLES:
                        # 'C26H34N4O5' , 'C17H25NO3' , 'C14H19NO3' , 'C19H18Cl2N2O4S' , 'C23H25Cl2N3O5S' , 'C22H28N2O3' 
                        # , 'C11H16N2O3' , 'C24H32O5' , 'C28H32Cl3N3O2' , 'C57H83N5O14Si2'
                        'full_mwt': 'NUMERIC',
                        # EXAMPLES:
                        # '482.58' , '291.39' , '249.31' , '441.34' , '526.44' , '368.48' , '224.26' , '400.52' , '548.9
                        # 4' , '1118.48'
                        'hba': 'NUMERIC',
                        # EXAMPLES:
                        # '7' , '3' , '3' , '4' , '7' , '5' , '4' , '5' , '5' , '2'
                        'hba_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '9' , '4' , '4' , '6' , '8' , '5' , '5' , '5' , '5' , '2'
                        'hbd': 'NUMERIC',
                        # EXAMPLES:
                        # '4' , '3' , '1' , '1' , '0' , '0' , '2' , '1' , '1' , '0'
                        'hbd_lipinski': 'NUMERIC',
                        # EXAMPLES:
                        # '4' , '3' , '1' , '1' , '0' , '0' , '2' , '1' , '1' , '0'
                        'heavy_atoms': 'NUMERIC',
                        # EXAMPLES:
                        # '35' , '21' , '18' , '28' , '34' , '27' , '16' , '29' , '36' , '16'
                        'molecular_species': 'TEXT',
                        # EXAMPLES:
                        # 'BASE' , 'NEUTRAL' , 'NEUTRAL' , 'NEUTRAL' , 'NEUTRAL' , 'BASE' , 'NEUTRAL' , 'NEUTRAL' , 'BAS
                        # E' , 'BASE'
                        'mw_freebase': 'NUMERIC',
                        # EXAMPLES:
                        # '482.58' , '291.39' , '249.31' , '441.34' , '526.44' , '368.48' , '224.26' , '400.52' , '548.9
                        # 4' , '1118.48'
                        'mw_monoisotopic': 'NUMERIC',
                        # EXAMPLES:
                        # '482.2529' , '291.1834' , '249.1365' , '440.0364' , '525.0892' , '368.2100' , '224.1161' , '40
                        # 0.2250' , '547.1560' , '1117.5475'
                        'num_lipinski_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '1' , '0' , '0' , '0' , '2' , '0'
                        'num_ro5_violations': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '1' , '0' , '0' , '0' , '2' , '0'
                        'psa': 'NUMERIC',
                        # EXAMPLES:
                        # '121.28' , '69.56' , '55.40' , '83.55' , '87.23' , '51.54' , '75.09' , '80.67' , '57.83' , '30
                        # .21'
                        'qed_weighted': 'NUMERIC',
                        # EXAMPLES:
                        # '0.32' , '0.80' , '0.76' , '0.72' , '0.55' , '0.78' , '0.75' , '0.72' , '0.23' , '0.66'
                        'ro3_pass': 'TEXT',
                        # EXAMPLES:
                        # 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
                        'rtb': 'NUMERIC',
                        # EXAMPLES:
                        # '13' , '3' , '7' , '5' , '5' , '4' , '2' , '3' , '9' , '7'
                    }
                },
                'molecule_structures': 
                {
                    'properties': 
                    {
                        'canonical_smiles': 'TEXT',
                        # EXAMPLES:
                        # 'COCCc1ccc(OCC(O)CNCCC(=O)Nc2ccc(C3=NNC(=O)CC3C)cc2)cc1' , 'CC1(C)C[C@@H](O)C[C@](C)(CNC(=O)c2
                        # ccccc2O)C1' , 'CCCC[C@@H](C=O)NC(=O)OCc1ccccc1' , 'CN1C(C(=O)N[C@H](C=O)Cc2ccccc2)Cc2cc(Cl)c(C
                        # l)cc2S1(=O)=O' , 'CC(C)c1cc(N2CCN(C)CC2)cc2c1C(=O)N(COC(=O)c1c(Cl)cccc1Cl)S2(=O)=O' , 'CC(C)Cn
                        # 1c(=O)cc(C(=O)OC2CC3CCC(C2)N3C)c2ccccc21' , 'Cc1cn(C2CCC(CO)C2)c(=O)[nH]c1=O' , 'CC(=O)OCC(=O)
                        # C1CCC2C3CCC4=CC(=O)[C@H](C)CC4(C)C3C(O)=CC12C' , 'CN(C)CCCCCCC/N=C1\CC(c2ccc(Cl)c(Cl)c2)Cc2c1c
                        # (=O)c1cc(Cl)ccc1n2O' , 'COc1ccc(Cn2c(=O)ccn([C@@H]3OC([C@H](O)[C@H](NCCCNC(=O)[C@@H](CC(=O)OCc
                        # 4ccccc4)NC(=O)OCc4ccccc4)C(=O)OC(C)(C)C)[C@@H](O[Si](C)(C)C(C)(C)C)[C@H]3O[Si](C)(C)C(C)(C)C)c
                        # 2=O)cc1'
                        'molfile': 'TEXT',
                        # EXAMPLES:
                        # '      RDKit          2D   35 37  0  0  0  0  0  0  0  0999 V2000     6.2750   -6.7167    0.00
                        # 00 N   0  0  0  0  0  0  0  0  0  0  0  0     5.5542   -6.3042    0.0000 C   0  0  0  0  0  0 
                        #  0  0  0  0  0  0     6.2667   -7.5417    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     5.
                        # 5542   -7.9542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.8417   -6.7167    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0     6.2750   -2.5917    0.0000 C   0  0  0  0  0  0  0
                        #   0  0  0  0  0     5.5542   -5.4792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.84
                        # 17   -7.5417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.5625   -3.0042    0.0000 N
                        #    0  0  0  0  0  0  0  0  0  0  0  0     6.2792   -1.7667    0.0000 C   0  0  0  0  0  0  0  
                        # 0  0  0  0  0     5.5500   -8.7792    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     6.9917
                        #    -3.0042    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     4.8417   -5.0667    0.0000 C  
                        #  0  0  0  0  0  0  0  0  0  0  0  0     6.2667   -5.0667    0.0000 C   0  0  0  0  0  0  0  0 
                        #  0  0  0  0     5.5542   -3.8292    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     9.2417  
                        #  -4.1875    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     9.2750   -5.0125    0.0000 C   0
                        #   0  0  0  0  0  0  0  0  0  0  0     8.4750   -2.9792    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0     8.5042   -3.8042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.8417   -
                        # 4.2417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.2667   -4.2417    0.0000 C   0  
                        # 0  0  0  0  0  0  0  0  0  0  0     7.7042   -1.7750    0.0000 N   0  0  0  0  0  0  0  0  0  
                        # 0  0  0     9.3417   -6.6542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     8.5750   -5.
                        # 4500    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    10.0042   -5.3875    0.0000 C   0  0 
                        #  0  0  0  0  0  0  0  0  0  0    10.0417   -6.2042    0.0000 C   0  0  0  0  0  0  0  0  0  0 
                        #  0  0     8.6042   -6.2750    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     9.1667   -2.53
                        # 75    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     6.9917   -1.3542    0.0000 C   0  0  0
                        #   0  0  0  0  0  0  0  0  0     4.1292   -6.3042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0
                        #   0     8.7167   -8.7500    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     7.7417   -2.6000
                        #     0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     9.3792   -7.4792    0.0000 C   0  0  0  
                        # 0  0  0  0  0  0  0  0  0     8.6792   -7.9250    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  
                        # 0     8.0167   -9.1917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   2  1  2  0   3  1  1
                        #   0   4  3  1  0   5  2  1  0   6  9  1  0   7  2  1  0   8  4  1  0   9 15  1  0  10  6  1  0
                        #   11  4  2  0  12  6  2  0  13  7  2  0  14  7  1  0  15 21  1  0  16 19  1  0  17 16  1  0  1
                        # 8 32  1  0  19 18  1  0  20 13  1  0  21 14  2  0  22 29  1  0  23 26  1  0  24 17  2  0  25 1
                        # 7  1  0  26 25  2  0  27 24  1  0  28 18  1  0  29 10  1  0  30  5  1  0  31 34  1  0  32 22  
                        # 1  0  33 23  1  0  34 33  1  0  35 31  1  0   5  8  1  0  20 15  2  0  27 23  2  0 M  END' , '
                        #       RDKit          2D   21 22  0  0  1  0  0  0  0  0999 V2000    -1.5708   -3.2000    0.000
                        # 0 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.8583   -2.7792    0.0000 C   0  0  0  0  0  0  
                        # 0  0  0  0  0  0    -0.1458   -3.1917    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     1.2
                        # 875   -3.1875    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.0000   -4.4250    0.0000 
                        # C   0  0  0  0  0  0  0  0  0  0  0  0    -2.2875   -2.7875    0.0000 C   0  0  0  0  0  0  0 
                        #  0  0  0  0  0    -0.8625   -1.9542    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     1.287
                        # 5   -4.0167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.5667   -2.7792    0.0000 C 
                        #   0  0  0  0  0  0  0  0  0  0  0  0     1.9917   -2.7750    0.0000 C   0  0  0  0  0  0  0  0
                        #   0  0  0  0     2.7125   -3.1875    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.7125 
                        #   -4.0042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.2958   -1.9667    0.0000 O   
                        # 0  0  0  0  0  0  0  0  0  0  0  0    -1.5708   -4.0292    0.0000 C   0  0  0  0  0  0  0  0  
                        # 0  0  0  0     3.4250   -2.7667    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     1.2792   
                        # -2.3625    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.4125   -5.0042    0.0000 C   0 
                        #  0  0  0  0  0  0  0  0  0  0  0     2.5792   -5.0042    0.0000 C   0  0  0  0  0  0  0  0  0 
                        #  0  0  0    -3.0000   -3.2000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.2875   -4
                        # .4417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -3.0000   -4.0292    0.0000 C   0  0
                        #   0  0  0  0  0  0  0  0  0  0   2  1  1  0   3  2  1  0   4  9  1  1   5  8  1  0   6  1  2  
                        # 0   7  2  2  0   8  4  1  0   9  3  1  0  10  4  1  0  11 10  1  0  12 11  1  0  13  6  1  0  
                        # 14  1  1  0  11 15  1  6   4 16  1  6  17  5  1  0  18  5  1  0  19  6  1  0  20 14  2  0  21 
                        # 20  1  0  19 21  2  0   5 12  1  0 M  END' , '      RDKit          2D   18 18  0  0  1  0  0  
                        # 0  0  0999 V2000     2.0667    0.3208    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.7
                        # 875    0.7333    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     2.0667   -0.5042    0.0000 
                        # O   0  0  0  0  0  0  0  0  0  0  0  0     1.3542    0.7333    0.0000 O   0  0  0  0  0  0  0 
                        #  0  0  0  0  0     4.9292    0.3208    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     4.216
                        # 7    0.7333    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.6417    0.3208    0.0000 C 
                        #   0  0  0  0  0  0  0  0  0  0  0  0     3.5000    0.3208    0.0000 C   0  0  0  0  0  0  0  0
                        #   0  0  0  0    -0.0708    0.7333    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.0708 
                        #    1.5583    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.7833    0.3208    0.0000 C   
                        # 0  0  0  0  0  0  0  0  0  0  0  0     3.5000   -0.5042    0.0000 C   0  0  0  0  0  0  0  0  
                        # 0  0  0  0     4.2167   -1.7417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.2167   
                        # -0.9167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.9292   -2.1542    0.0000 C   0 
                        #  0  0  0  0  0  0  0  0  0  0  0    -1.4958    0.7333    0.0000 C   0  0  0  0  0  0  0  0  0 
                        #  0  0  0    -0.7833    1.9708    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.4958    1
                        # .5583    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   2  1  1  0   3  1  2  0   4  1  1  0 
                        #   5  6  2  0   6  8  1  0   7  4  1  0   8  2  1  0   9  7  1  0  10  9  2  0  11  9  1  0   8
                        #  12  1  6  13 14  1  0  14 12  1  0  15 13  1  0  16 11  2  0  17 10  1  0  18 16  1  0  18 17
                        #   2  0 M  END' , '      RDKit          2D   28 30  0  0  1  0  0  0  0  0999 V2000     0.6375 
                        #   -2.0417    0.0000 S   0  0  0  0  0  0  0  0  0  0  0  0     1.3542   -1.6292    0.0000 N   
                        # 0  0  0  0  0  0  0  0  0  0  0  0     1.3542   -0.8000    0.0000 C   0  0  0  0  0  0  0  0  
                        # 0  0  0  0    -0.0833   -1.6250    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.0667   
                        # -0.3917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.0750   -0.8000    0.0000 C   0 
                        #  0  0  0  0  0  0  0  0  0  0  0    -0.7958   -2.0417    0.0000 C   0  0  0  0  0  0  0  0  0 
                        #  0  0  0     0.6375   -0.3792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.2167   -2
                        # .6167    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     0.0500   -2.6167    0.0000 O   0  0
                        #   0  0  0  0  0  0  0  0  0  0     2.7792   -0.8042    0.0000 N   0  0  0  0  0  0  0  0  0  0
                        #   0  0    -1.5083   -1.6292    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.7958   -0.3
                        # 875    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.5083   -0.8042    0.0000 C   0  0  
                        # 0  0  0  0  0  0  0  0  0  0     2.0667    0.4333    0.0000 O   0  0  0  0  0  0  0  0  0  0  
                        # 0  0     3.5000   -0.3917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.2125   -1.629
                        # 2    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     2.0667   -2.0417    0.0000 C   0  0  0 
                        #  0  0  0  0  0  0  0  0  0    -2.2208   -2.0417    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0 
                        #  0     4.2125   -0.8042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.2208   -0.3917 
                        #    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0  0     3.5000    0.4333    0.0000 C   0  0  0  0
                        #   0  0  0  0  0  0  0  0     4.2167    0.8458    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
                        #      4.2167    1.6625    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.9292    0.4250   
                        #  0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.6417    0.8333    0.0000 C   0  0  0  0  
                        # 0  0  0  0  0  0  0  0     4.9250    2.0833    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0  
                        #    5.6417    1.6583    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   2  1  1  0   3  2  1  0
                        #    4  1  1  0   5  3  1  0   6  4  1  0   7  4  2  0   8  6  1  0   9  1  2  0  10  1  2  0  1
                        # 1  5  1  0  12  7  1  0  13  6  2  0  14 12  2  0  15  5  2  0  16 11  1  0  17 20  2  0  18  
                        # 2  1  0  19 12  1  0  20 16  1  0  21 14  1  0  16 22  1  1  23 22  1  0  24 23  1  0  25 23  
                        # 2  0  26 25  1  0  27 24  2  0  28 26  2  0   3  8  1  0  13 14  1  0  27 28  1  0 M  END' , '
                        #       RDKit          2D   34 37  0  0  0  0  0  0  0  0999 V2000     2.6875   -0.3917    0.000
                        # 0 S   0  0  0  0  0  0  0  0  0  0  0  0     3.1667    0.2833    0.0000 N   0  0  0  0  0  0  
                        # 0  0  0  0  0  0     1.8917    0.6833    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.6
                        # 750    0.9458    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.9000   -0.1417    0.0000 
                        # C   0  0  0  0  0  0  0  0  0  0  0  0     1.1750    1.0958    0.0000 C   0  0  0  0  0  0  0 
                        #  0  0  0  0  0     1.1750   -0.5542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.991
                        # 7    0.2833    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.4625   -0.1417    0.0000 C 
                        #   0  0  0  0  0  0  0  0  0  0  0  0     5.6500   -1.1375    0.0000 C   0  0  0  0  0  0  0  0
                        #   0  0  0  0    -0.2583   -0.5542    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     0.4625 
                        #    0.6833    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.2375   -0.4292    0.0000 C   
                        # 0  0  0  0  0  0  0  0  0  0  0  0     2.1000   -0.9792    0.0000 O   0  0  0  0  0  0  0  0  
                        # 0  0  0  0     3.4000   -0.8042    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     4.4125   
                        # -0.4292    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -1.6958   -1.3625    0.0000 N   0 
                        #  0  0  0  0  0  0  0  0  0  0  0     2.9250    1.7333    0.0000 O   0  0  0  0  0  0  0  0  0 
                        #  0  0  0     5.2417   -1.8542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.4750   -1
                        # .1292    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.9708   -0.1292    0.0000 C   0  0
                        #   0  0  0  0  0  0  0  0  0  0    -0.2583   -1.3750    0.0000 C   0  0  0  0  0  0  0  0  0  0
                        #   0  0     5.6417    0.2875    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     1.1667    1.9
                        # 208    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.9833   -1.7792    0.0000 C   0  0  
                        # 0  0  0  0  0  0  0  0  0  0    -1.6833   -0.5375    0.0000 C   0  0  0  0  0  0  0  0  0  0  
                        # 0  0     6.8792   -0.4125    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0  0     4.4167   -1.850
                        # 0    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0  0    -2.4083   -1.7667    0.0000 C   0  0  0 
                        #  0  0  0  0  0  0  0  0  0     6.4792   -2.5625    0.0000 C   0  0  0  0  0  0  0  0  0  0  0 
                        #  0     5.6542   -2.5625    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.8917   -1.8375 
                        #    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.8792    2.3333    0.0000 C   0  0  0  0
                        #   0  0  0  0  0  0  0  0     0.4542    2.3333    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
                        #    2  1  1  0   3  5  1  0   4  2  1  0   5  1  1  0   6  3  2  0   7  5  2  0   8  2  1  0   
                        # 9  7  1  0  10 13  1  0  11  9  1  0  12  9  2  0  13 16  1  0  14  1  2  0  15  1  2  0  16  
                        # 8  1  0  17 25  1  0  18  4  2  0  19 10  2  0  20 10  1  0  21 11  1  0  22 11  1  0  23 13  
                        # 2  0  24  6  1  0  25 22  1  0  26 21  1  0  27 20  1  0  28 19  1  0  29 17  1  0  30 32  1  
                        # 0  31 19  1  0  32 20  2  0  33 24  1  0  34 24  1  0   4  3  1  0   6 12  1  0  26 17  1  0  
                        # 31 30  2  0 M  END' , '      RDKit          2D   27 30  0  0  0  0  0  0  0  0999 V2000    -0.
                        # 6333   -7.9167    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0    -0.6458   -6.2667    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0     0.0792   -7.5042    0.0000 C   0  0  0  0  0  0  0
                        #   0  0  0  0  0     0.0750   -6.6750    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.64
                        # 58   -5.4417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.3500   -7.5042    0.0000 C
                        #    0  0  0  0  0  0  0  0  0  0  0  0    -1.3500   -6.6792    0.0000 C   0  0  0  0  0  0  0  
                        # 0  0  0  0  0     2.0917   -2.8500    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     1.3500
                        #    -3.2667    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.7792   -3.7917    0.0000 C  
                        #  0  0  0  0  0  0  0  0  0  0  0  0    -0.0708   -4.0292    0.0000 C   0  0  0  0  0  0  0  0 
                        #  0  0  0  0    -0.0625   -4.8542    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     0.6250  
                        #  -3.6167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.2417   -3.0792    0.0000 C   0
                        #   0  0  0  0  0  0  0  0  0  0  0    -0.6375   -8.7417    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0     0.7917   -7.9125    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -1.4375   -
                        # 5.2292    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     1.9292   -4.6042    0.0000 C   0  
                        # 0  0  0  0  0  0  0  0  0  0  0     1.2875   -4.0917    0.0000 C   0  0  0  0  0  0  0  0  0  
                        # 0  0  0     2.6167   -2.2125    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.0708   -7.
                        # 9250    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.0708   -6.2667    0.0000 C   0  0 
                        #  0  0  0  0  0  0  0  0  0  0     0.0667   -9.1542    0.0000 C   0  0  0  0  0  0  0  0  0  0 
                        #  0  0     0.0667   -9.9792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.7875   -8.75
                        # 00    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.7833   -7.5125    0.0000 C   0  0  0
                        #   0  0  0  0  0  0  0  0  0    -2.7833   -6.6875    0.0000 C   0  0  0  0  0  0  0  0  0  0  0
                        #   0   2  7  1  0   3  1  1  0   4  3  1  0   5  2  1  0   6  1  1  0   7  6  1  0   8  9  1  0
                        #    9 14  1  0  10 13  1  0  11 12  1  0  12  5  1  0  13 11  1  0  14 11  1  0  15  1  1  0  1
                        # 6  3  2  0  17  5  2  0  18 10  1  0  19  9  1  0  20  8  1  0  21  6  2  0  22  7  2  0  23 1
                        # 5  1  0  24 23  1  0  25 23  1  0  26 21  1  0  27 26  2  0   4  2  2  0  22 27  1  0  10  8  
                        # 1  0  19 18  1  0 M  END' , '      RDKit          2D   16 17  0  0  0  0  0  0  0  0999 V2000 
                        #     4.2542   -3.7667    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.2542   -2.9417    
                        # 0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     4.9625   -4.1792    0.0000 N   0  0  0  0  0
                        #   0  0  0  0  0  0  0     5.6750   -2.9417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   
                        #   5.6750   -3.7667    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.9625   -2.5292    0.
                        # 0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.9542   -6.0042    0.0000 C   0  0  0  0  0  
                        # 0  0  0  0  0  0  0     3.5375   -4.1792    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     
                        # 4.9625   -1.7042    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     6.0167   -5.4792    0.00
                        # 00 C   0  0  0  0  0  0  0  0  0  0  0  0     5.3625   -6.8167    0.0000 C   0  0  0  0  0  0 
                        #  0  0  0  0  0  0     6.3917   -2.5292    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.
                        # 6750   -6.8167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.0792   -6.0042    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0     7.9000   -5.1792    0.0000 O   0  0  0  0  0  0  0
                        #   0  0  0  0  0     7.0750   -5.1792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   2  1  
                        # 1  0   3  1  1  0   4  5  2  0   5  3  1  0   6  2  1  0   7  3  1  0   8  1  2  0   9  6  2  
                        # 0  10  7  1  0  11  7  1  0  12  4  1  0  13 11  1  0  14 10  1  0  15 16  1  0  16 14  1  0  
                        #  6  4  1  0  13 14  1  0 M  END' , '      RDKit          2D   29 32  0  0  1  0  0  0  0  0999
                        #  V2000     5.3375   -3.1792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.7792   -4.0
                        # 625    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.3000   -3.7750    0.0000 C   0  0  
                        # 0  0  0  0  0  0  0  0  0  0     4.8250   -2.8792    0.0000 C   0  0  0  0  0  0  0  0  0  0  
                        # 0  0     4.3000   -3.1792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.7792   -4.666
                        # 7    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.8250   -4.0625    0.0000 C   0  0  0 
                        #  0  0  0  0  0  0  0  0  0     5.3375   -3.7750    0.0000 C   0  0  0  0  0  0  0  0  0  0  0 
                        #  0     5.9042   -3.0042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.2667   -4.9667 
                        #    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.2667   -3.7750    0.0000 C   0  0  0  0
                        #   0  0  0  0  0  0  0  0     2.7500   -4.6667    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
                        #      5.9042   -3.9542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.8250   -4.6667   
                        #  0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.2417   -3.4875    0.0000 C   0  0  0  0  
                        # 0  0  0  0  0  0  0  0     2.7500   -4.0625    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0  
                        #    5.9042   -2.3792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.3000   -4.9667    0
                        # .0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.4917   -2.0792    0.0000 C   0  0  0  0  0 
                        #  0  0  0  0  0  0  0     2.2667   -4.9375    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    
                        #  6.4292   -2.0667    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.9500   -2.3667    0.0
                        # 000 O   0  0  0  0  0  0  0  0  0  0  0  0     7.5042   -1.4792    0.0000 O   0  0  0  0  0  0
                        #   0  0  0  0  0  0     5.3625   -2.1125    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     3
                        # .7542   -2.8917    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     5.3375   -2.5667    0.000
                        # 0 C   0  0  0  0  0  0  0  0  0  0  0  0     3.7792   -3.4667    0.0000 C   0  0  0  0  0  0  
                        # 0  0  0  0  0  0     2.2375   -3.7542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     8.0
                        # 000   -2.3917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   2  3  1  0   3  7  1  0   4  
                        # 1  1  0   5  4  2  0   6 18  1  0   7  8  1  0   8  1  1  0   9  1  1  0  10  6  2  0  11  2  
                        # 1  0  12 10  1  0  13  8  1  0  14  7  1  0  15  9  1  0  16 11  1  0  17  9  1  0  18 14  1  
                        # 0  19 22  1  0  20 12  2  0  21 17  1  0  22 21  1  0  23 19  2  0  24 17  2  0  25  5  1  0  
                        # 26  1  1  0  27  2  1  0  16 28  1  6  29 19  1  0  13 15  1  0   5  3  1  0   6  2  1  0  12 
                        # 16  1  0 M  END' , '      RDKit          2D   36 39  0  0  0  0  0  0  0  0999 V2000     4.179
                        # 2   -2.2792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     4.1792   -3.1042    0.0000 C 
                        #   0  0  0  0  0  0  0  0  0  0  0  0     3.4667   -1.8625    0.0000 C   0  0  0  0  0  0  0  0
                        #   0  0  0  0     3.4667   -3.5167    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     2.7542 
                        #   -2.2792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.7500   -3.1042    0.0000 C   
                        # 0  0  0  0  0  0  0  0  0  0  0  0     4.9000   -1.8667    0.0000 C   0  0  0  0  0  0  0  0  
                        # 0  0  0  0     4.8917   -3.5167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.6042   
                        # -3.1125    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.6125   -2.2875    0.0000 C   0 
                        #  0  0  0  0  0  0  0  0  0  0  0     6.3167   -3.5250    0.0000 C   0  0  0  0  0  0  0  0  0 
                        #  0  0  0     2.0375   -3.5167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.7417   -3
                        # .5292    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.0292   -3.1167    0.0000 C   0  0
                        #   0  0  0  0  0  0  0  0  0  0     2.0375   -1.8667    0.0000 C   0  0  0  0  0  0  0  0  0  0
                        #   0  0     4.9000   -1.0417    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     3.4667   -1.0
                        # 375    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     7.7417   -4.3625    0.0000 C   0  0  
                        # 0  0  0  0  0  0  0  0  0  0     3.4625   -4.3417    0.0000 O   0  0  0  0  0  0  0  0  0  0  
                        # 0  0     6.3125   -4.3542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     7.0167   -4.766
                        # 7    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     1.3250   -2.2792    0.0000 C   0  0  0 
                        #  0  0  0  0  0  0  0  0  0     8.4542   -3.1167    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0 
                        #  0     1.3250   -3.1042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     8.4542   -4.7750 
                        #    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0  0    10.6000   -1.0417    0.0000 N   0  0  0  0
                        #   0  0  0  0  0  0  0  0     0.7375   -1.6917    0.0000 Cl  0  0  0  0  0  0  0  0  0  0  0  0
                        #      5.6125   -1.4542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     9.8875   -1.4542   
                        #  0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    11.3125   -1.4542    0.0000 C   0  0  0  0  
                        # 0  0  0  0  0  0  0  0    10.6000   -0.2167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0  
                        #    6.3250   -1.0417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     9.1750   -1.0417    0
                        # .0000 C   0  0  0  0  0  0  0  0  0  0  0  0     8.4625   -1.4542    0.0000 C   0  0  0  0  0 
                        #  0  0  0  0  0  0  0     7.0375   -1.4542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    
                        #  7.7500   -1.0417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0   2  1  2  0   3  1  1  0  
                        #  4  2  1  0   5  3  1  0   6  5  1  0   7  1  1  0   8  2  1  0   9 10  1  0  10  7  1  0  11 
                        #  9  1  0  12  6  2  0  13 14  2  0  14 11  1  0  15  5  2  0  16  7  2  0  17  3  2  0  18 21 
                        #  2  0  19  4  1  0  20 11  2  0  21 20  1  0  22 15  1  0  23 13  1  0  24 22  2  0  25 18  1 
                        #  0  26 29  1  0  27 22  1  0  28 16  1  0  29 33  1  0  30 26  1  0  31 26  1  0  32 28  1  0 
                        #  33 34  1  0  34 36  1  0  35 32  1  0  36 35  1  0   9  8  1  0   6  4  1  0  12 24  1  0  18
                        #  13  1  0 M  END' , '      RDKit          2D   78 82  0  0  1  0  0  0  0  0999 V2000     4.80
                        # 00   -2.2542    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     5.2917   -2.9167    0.0000 C
                        #    0  0  0  0  0  0  0  0  0  0  0  0     6.1125   -2.8167    0.0000 N   0  0  0  0  0  0  0  
                        # 0  0  0  0  0     3.9792   -2.1667    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.4292
                        #    -2.7792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.6750   -2.4542    0.0000 C  
                        #  0  0  0  0  0  0  0  0  0  0  0  0     2.7625   -1.6292    0.0000 C   0  0  0  0  0  0  0  0 
                        #  0  0  0  0     3.5625   -1.4542    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     5.1375  
                        #  -1.4917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.4417   -2.0667    0.0000 C   0
                        #   0  0  0  0  0  0  0  0  0  0  0     2.1417   -1.0917    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0     1.3625   -1.3417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.9500   -
                        # 1.4042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.7417   -0.8042    0.0000 C   0  
                        # 0  0  0  0  0  0  0  0  0  0  0     3.6125   -3.5917    0.0000 O   0  0  0  0  0  0  0  0  0  
                        # 0  0  0     2.2542   -3.1667    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     1.5417   -3.
                        # 5792    0.0000 Si  0  0  0  0  0  4  0  0  0  0  0  0     3.8250   -4.3917    0.0000 Si  0  0 
                        #  0  0  0  4  0  0  0  0  0  0    -3.8958   -2.6292    0.0000 C   0  0  0  0  0  0  0  0  0  0 
                        #  0  0    -1.8458   -3.3542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.4833   -2.84
                        # 17    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -3.2500   -3.1417    0.0000 N   0  0  0
                        #   0  0  0  0  0  0  0  0  0    -2.3583   -2.0292    0.0000 C   0  0  0  0  0  0  0  0  0  0  0
                        #   0     6.6042   -3.4917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.9708   -4.1792
                        #     0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.0375   -1.0542    0.0000 O   0  0  0  
                        # 0  0  0  0  0  0  0  0  0     4.9625   -3.6667    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  
                        # 0     1.5375   -4.4042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.8167   -5.2167  
                        #   0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.9042    0.0083    0.0000 O   0  0  0  0 
                        #  0  0  0  0  0  0  0  0     7.2625   -1.9667    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0 
                        #    -4.6625   -2.9292    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -3.0000   -1.5042    
                        # 0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     1.2375   -2.1542    0.0000 N   0  0  0  0  0
                        #   0  0  0  0  0  0  0    -3.7708   -1.8292    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0   
                        #  -0.5375   -0.3917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -1.3250   -4.6917    0.
                        # 0000 O   0  0  0  0  0  0  0  0  0  0  0  0    -2.7375   -4.4792    0.0000 O   0  0  0  0  0  
                        # 0  0  0  0  0  0  0    -1.5875   -1.7292    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0     
                        # 2.3042   -0.2792    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     6.2750   -4.2417    0.00
                        # 00 C   0  0  0  0  0  0  0  0  0  0  0  0     5.6167   -5.7542    0.0000 C   0  0  0  0  0  0 
                        #  0  0  0  0  0  0    -4.4083   -1.3167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -2.
                        # 9500   -5.2792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.7667   -4.9042    0.0000
                        #  C   0  0  0  0  0  0  0  0  0  0  0  0     5.4500   -4.3292    0.0000 C   0  0  0  0  0  0  0
                        #   0  0  0  0  0     5.1250   -5.0917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     6.44
                        # 17   -5.6542    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -3.7500   -5.4792    0.0000 C
                        #    0  0  0  0  0  0  0  0  0  0  0  0    -4.2833   -0.5167    0.0000 C   0  0  0  0  0  0  0  
                        # 0  0  0  0  0    -0.1750   -1.9417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.2875
                        #    -6.5042    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0     0.7417   -3.3542    0.0000 C  
                        #  0  0  0  0  0  0  0  0  0  0  0  0     3.0000   -4.3792    0.0000 C   0  0  0  0  0  0  0  0 
                        #  0  0  0  0     4.6500   -4.3917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     2.3375  
                        #  -3.7917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.4750   -2.4542    0.0000 C   0
                        #   0  0  0  0  0  0  0  0  0  0  0     2.2500   -4.8167    0.0000 C   0  0  0  0  0  0  0  0  0
                        #   0  0  0     0.7375   -4.1792    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     0.8167   -
                        # 4.8042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     3.1000   -5.6167    0.0000 C   0  
                        # 0  0  0  0  0  0  0  0  0  0  0     4.5250   -5.6292    0.0000 C   0  0  0  0  0  0  0  0  0  
                        # 0  0  0     3.0250   -4.9917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.9375   -2.
                        # 2417    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -0.2083    0.3583    0.0000 C   0  0 
                        #  0  0  0  0  0  0  0  0  0  0    -1.3583   -0.4917    0.0000 C   0  0  0  0  0  0  0  0  0  0 
                        #  0  0     0.2292   -0.0917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -4.3333   -4.89
                        # 17    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -3.9708   -6.2667    0.0000 C   0  0  0
                        #   0  0  0  0  0  0  0  0  0    -4.9250   -0.0042    0.0000 C   0  0  0  0  0  0  0  0  0  0  0
                        #   0    -3.5208   -0.2167    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0     5.7792   -7.1667
                        #     0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -4.7708   -6.4792    0.0000 C   0  0  0  
                        # 0  0  0  0  0  0  0  0  0    -3.3958    0.6083    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  
                        # 0    -4.8083    0.8083    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -5.1250   -5.0917  
                        #   0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0    -4.0375    1.1083    0.0000 C   0  0  0  0 
                        #  0  0  0  0  0  0  0  0    -5.3500   -5.8917    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0 
                        #   2  1  1  0   3  2  1  0   4  1  1  1   5  4  1  0   6  5  1  0   7  8  1  0   8  4  1  0   9
                        #   1  1  0  10 13  1  0  11  7  1  0  12 11  1  0  13  9  2  0  14 12  1  0   5 15  1  6   6 16
                        #   1  6  17 16  1  0  18 15  1  0  19 22  1  0  21 20  1  1  21 23  1  0  22 21  1  0  23 39  1
                        #   0  24  3  1  0  25 20  1  0  26 14  1  0  27  2  2  0  28 17  1  0  29 18  1  0  30 14  2  0
                        #   31 10  2  0  32 19  2  0  33 23  2  0  12 34  1  6  35 19  1  0  36 26  1  0  37 25  2  0  3
                        # 8 25  1  0  39 64  1  0  11 40  1  1  41 24  1  0  42 47  2  0  43 35  1  0  44 38  1  0  45 4
                        # 1  1  0  46 41  2  0  47 46  1  0  48 45  2  0  49 44  1  0  50 43  1  0  51 57  1  0  52 42  
                        # 1  0  53 17  1  0  54 18  1  0  55 18  1  0  56 17  1  0  57 34  1  0  58 28  1  0  59 28  1  
                        # 0  60 28  1  0  61 29  1  0  62 29  1  0  63 29  1  0  64 51  1  0  65 36  1  0  66 36  1  0  
                        # 67 36  1  0  68 49  2  0  69 49  1  0  70 50  2  0  71 50  1  0  72 52  1  0  73 69  2  0  74 
                        # 71  2  0  75 70  1  0  76 68  1  0  77 74  1  0  78 73  1  0  10  3  1  0   6  7  1  0  42 48 
                        #  1  0  75 77  2  0  78 76  2  0 M  END'
                        'standard_inchi': 'TEXT',
                        # EXAMPLES:
                        # 'InChI=1S/C26H34N4O5/c1-18-15-25(33)29-30-26(18)20-5-7-21(8-6-20)28-24(32)11-13-27-16-22(31)17
                        # -35-23-9-3-19(4-10-23)12-14-34-2/h3-10,18,22,27,31H,11-17H2,1-2H3,(H,28,32)(H,29,33)' , 'InChI
                        # =1S/C17H25NO3/c1-16(2)8-12(19)9-17(3,10-16)11-18-15(21)13-6-4-5-7-14(13)20/h4-7,12,19-20H,8-11
                        # H2,1-3H3,(H,18,21)/t12-,17+/m1/s1' , 'InChI=1S/C14H19NO3/c1-2-3-9-13(10-16)15-14(17)18-11-12-7
                        # -5-4-6-8-12/h4-8,10,13H,2-3,9,11H2,1H3,(H,15,17)/t13-/m0/s1' , 'InChI=1S/C19H18Cl2N2O4S/c1-23-
                        # 17(9-13-8-15(20)16(21)10-18(13)28(23,26)27)19(25)22-14(11-24)7-12-5-3-2-4-6-12/h2-6,8,10-11,14
                        # ,17H,7,9H2,1H3,(H,22,25)/t14-,17?/m0/s1' , 'InChI=1S/C23H25Cl2N3O5S/c1-14(2)16-11-15(27-9-7-26
                        # (3)8-10-27)12-19-20(16)22(29)28(34(19,31)32)13-33-23(30)21-17(24)5-4-6-18(21)25/h4-6,11-12,14H
                        # ,7-10,13H2,1-3H3' , 'InChI=1S/C22H28N2O3/c1-14(2)13-24-20-7-5-4-6-18(20)19(12-21(24)25)22(26)2
                        # 7-17-10-15-8-9-16(11-17)23(15)3/h4-7,12,14-17H,8-11,13H2,1-3H3' , 'InChI=1S/C11H16N2O3/c1-7-5-
                        # 13(11(16)12-10(7)15)9-3-2-8(4-9)6-14/h5,8-9,14H,2-4,6H2,1H3,(H,12,15,16)' , 'InChI=1S/C24H32O5
                        # /c1-13-10-23(3)15(9-19(13)26)5-6-16-17-7-8-18(21(28)12-29-14(2)25)24(17,4)11-20(27)22(16)23/h9
                        # ,11,13,16-18,22,27H,5-8,10,12H2,1-4H3/t13-,16?,17?,18?,22?,23?,24?/m1/s1' , 'InChI=1S/C28H32Cl
                        # 3N3O2/c1-33(2)13-7-5-3-4-6-12-32-24-15-19(18-8-10-22(30)23(31)14-18)16-26-27(24)28(35)21-17-20
                        # (29)9-11-25(21)34(26)36/h8-11,14,17,19,36H,3-7,12-13,15-16H2,1-2H3/b32-24+' , 'InChI=1S/C57H83
                        # N5O14Si2/c1-55(2,3)74-52(67)45(58-31-21-32-59-50(66)42(34-44(64)71-36-39-22-17-15-18-23-39)60-
                        # 53(68)72-37-40-24-19-16-20-25-40)46(65)47-48(75-77(11,12)56(4,5)6)49(76-78(13,14)57(7,8)9)51(7
                        # 3-47)61-33-30-43(63)62(54(61)69)35-38-26-28-41(70-10)29-27-38/h15-20,22-30,33,42,45-49,51,58,6
                        # 5H,21,31-32,34-37H2,1-14H3,(H,59,66)(H,60,68)/t42-,45+,46-,47?,48-,49-,51-/m1/s1'
                        'standard_inchi_key': 'TEXT',
                        # EXAMPLES:
                        # 'CJECYODSXWTYSY-UHFFFAOYSA-N' , 'HRXCLBHABYXFES-PXAZEXFGSA-N' , 'MVYMZCOVLGBDRV-ZDUSSCGKSA-N' 
                        # , 'WGAWTZRUUNHJGZ-MBIQTGHCSA-N' , 'ASHIQHBFXYKICH-UHFFFAOYSA-N' , 'WSZXSZFRGVOFAU-UHFFFAOYSA-N
                        # ' , 'RLYNPXSONXEUFO-UHFFFAOYSA-N' , 'CVPOSBHEMUUIBP-JOGSDJGCSA-N' , 'GHIHULPHFUWEAO-FEZSWGLMSA
                        # -N' , 'OHTRGUGBBLXOCG-SNOKGWGDSA-N'
                    }
                },
                'molecule_synonyms': 
                {
                    'properties': 
                    {
                        'molecule_synonym': 'TEXT',
                        # EXAMPLES:
                        # 'Cholesterin' , '2-Benzylsulfanyl-Benzooxazole' , '2,2-Dimethyl-Propionic Acid' , 'Octadecyl-A
                        # mmonium Chloride' , 'Methyleugenol' , 'Isofuranodiene' , 'Dothiepin' , 'Trimethyl-tetradecyl-a
                        # mmonium chloride' , 'UK-356618' , 'Diminazene Aceturate'
                        'syn_type': 'TEXT',
                        # EXAMPLES:
                        # 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'OTHER' , 'RESEARCH_CODE
                        # ' , 'OTHER'
                        'synonyms': 'TEXT',
                        # EXAMPLES:
                        # 'CHOLESTERIN' , '2-Benzylsulfanyl-Benzooxazole' , '2,2-Dimethyl-Propionic Acid' , 'Octadecyl-A
                        # mmonium Chloride' , 'Methyleugenol' , 'Isofuranodiene' , 'Dothiepin' , 'Trimethyl-tetradecyl-a
                        # mmonium chloride' , 'UK-356618' , 'Diminazene Aceturate'
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
                # 'CHOLESTEROL' , 'PIVALATE' , 'Bis(1,2,3,4,5,6,7,8-octahydroanthracene)technetium' , 'Bis(1,1,4,6,7-pen
                # tamethylindane)technetium' , 'METHYLEUGENOL' , 'ISOFURANODIENE' , 'DOTHIEPIN' , 'TRIMETHYL-TETRADECYL-
                # AMMONIUM CHLORIDE' , 'piperidine based analogue of cocaine' , 'DIMINAZEN ACETURATE'
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
                # '-ster-; -terol' , '-alol' , '-pride' , '-atadine' , '-ast' , '-glumide' , '-dil' , '-prost' , '-tript
                # an' , '-azepam'
                'usan_stem_definition': 'TEXT',
                # EXAMPLES:
                # 'steroids (androgens, anabolics); bronchodilators (phenethylamine derivatives)' , 'combined alpha and 
                # beta receptors' , 'sulpride derivatives' , 'tricyclic histaminic-H1 receptor antagonists, loratadine d
                # erivatives' , 'antiasthmatics/antiallergics (not acting primarily as antihistamines)' , 'CCK antagonis
                # ts, antiulcer, anxiolytic agent' , 'vasodilators (undefined group)' , 'prostaglandins' , 'antimigraine
                #  agents (5-HT1 receptor agonists),sumatriptan derivatives' , 'antianxiety agents (diazepam type)'
                'usan_substem': 'TEXT',
                # EXAMPLES:
                # '-ster-; -terol' , '-alol' , '-pride' , '-atadine' , '-ast' , '-glumide' , '-dil' , '-prost' , '-tript
                # an' , '-azepam'
                'usan_year': 'NUMERIC',
                # EXAMPLES:
                # '1979' , '2011' , '1998' , '1984' , '1976' , '1966' , '1971' , '2014' , '2005' , '2005'
                'withdrawn_class': 'TEXT',
                # EXAMPLES:
                # 'Cardiotoxicity; Neurotoxicity' , 'Hepatotoxicity' , 'Hepatotoxicity; Neurotoxicity' , 'Neurotoxicity'
                #  , 'Neurotoxicity; Psychiatric toxicity' , 'Hematological toxicity' , 'Dermatological toxicity' , 'Mis
                # use' , 'Hematological toxicity; Misuse' , 'Cardiotoxicity'
                'withdrawn_country': 'TEXT',
                # EXAMPLES:
                # 'United States' , 'United States' , 'Japan' , 'United Kingdom; France' , 'Spain; United Kingdom' , 'Un
                # ited States' , 'France; United States' , 'United Kingdom; Germany' , 'Spain; Germany; France' , 'Unite
                # d States'
                'withdrawn_flag': 'BOOLEAN',
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'withdrawn_reason': 'TEXT',
                # EXAMPLES:
                # 'Risk for heart attack, stroke, and unstable angina' , 'Drug Interactionwith 5-FU and Deaths' , 'Jaund
                # ice ' , 'Neurologic and Hepatic Toxicities' , 'Progressive multifocal leukoencephalopathy' , 'Neuropsy
                # chiatric Reaction' , 'Eosinophilic Myalgia Syndrome' , 'Stevens Johnson Syndrome; Toxic Epidermal Necr
                # olysis' , 'Abuse' , 'Off-Label Abuse; Hematologic Toxicity'
                'withdrawn_year': 'NUMERIC',
                # EXAMPLES:
                # '2007' , '1993' , '1964' , '1985' , '2009' , '1972' , '1989' , '1983' , '1996' , '1985'
            }
        }
    }

from glados.ws2es.es_util import DefaultMappings

# Properties mappings shared by compounds and drugs

biotherapeutic = {
    'properties':
    {
        'biocomponents':
        {
            'properties':
            {
                'component_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '6691' , '6507' , '6301' , '6398' , '6418' , '6533' , '6392' , '6365' , '6678' , '6702
                # '
                'component_type': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'PROTEIN' , 'P
                # ROTEIN' , 'PROTEIN' , 'PROTEIN'
                'description': DefaultMappings.ALT_NAME,
                # EXAMPLES:
                # 'Corticotropin-lipotropin precursor' , 'Orticumab heavy chain' , 'Solitomab' , 'Demciz
                # umab light chain' , 'Lampalizumab heavy chain' , 'Romosozumab heavy chain' , 'Blisibim
                # od fusion protein' , 'Tositumomab heavy chain' , 'Corticoliberin precursor' , 'Uricase
                # '
                'organism': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Mus musculus' , 'Mus musculus' , 'Homo sapiens' , '
                # Aspergillus flavus' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens
                # '
                'sequence': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'MPRSCCSRSGALLLALLLQASMEVRGWCLESSQCQDLTTESNLLECIRACKPDLSAETPMFPGNGDEQPLTENPRKYVMGHFRWD
                # RFGRRNSSSSGSSGAGQKREDVSAGEDCGPLPEGGPEPRSDGAKPGPREGKRSYSMEHFRWGKPVGKKRRPVKVYPNGAEDESAEA
                # FPLEFKRELTGQRLREGDGPDGPADDGAGAQADLEHSLLVAAEKKDEGPYRMEHFRWGSPPKDKRYGGFMTSEKSQTPLVTLFKNA
                # IIKNAYKKGE' , 'EVQLLESGGGLVQPGGSLRLSCAASGFTFSNAWMSWVRQAPGKGLEWVSSISVGGHRTYYADSVKGRSTIS
                # RDNSKNTLYLQMNSLRAEDTAVYYCARIRVGPSGGAFDYWGQGTLVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEP
                # VTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHTCPPCPAPELLGGPS
                # VFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSN
                # KALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLT
                # VDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'ELVMTQSPSSLTVTAGEKVTMSCKSSQSLLNSGNQKNYLTWYQQK
                # PGQPPKLLIYWASTRESGVPDRFTGSGSGTDFTLTISSVQAEDLAVYYCQNDYSYPLTFGAGTKLEIKGGGGSGGGGSGGGGSEVQ
                # LLEQSGAELVRPGTSVKISCKASGYAFTNYWLGWVKQRPGHGLEWIGDIFPGSGNIHYNEKFKGKATLTADKSSSTAYMQLSSLTF
                # EDSAVYFCARLRNWDEPMDYWGQGTTVTVSSGGGGSDVQLVQSGAEVKKPGASVKVSCKASGYTFTRYTMHWVRQAPGQGLEWIGY
                # INPSRGYTNYADSVKGRFTITTDKSTSTAYMELSSLRSEDTATYYCARYYDDHYCLDYWGQGTTVTVSSGEGTSTGSGGSGGSGGA
                # DDIVLTQSPATLSLSPGERATLSCRASQSVSYMNWYQQKPGKAPKRWIYDTSKVASGVPARFSGSGSGTDYSLTINSLEAEDAATY
                # YCQQWSSNPLTFGGGTKVEIKHHHHHH' , 'DIVMTQSPDSLAVSLGERATISCRASESVDNYGISFMKWFQQKPGQPPKLLIYA
                # ASNQGSGVPDRFSGSGSGTDFTLTISSLQAEDVAVYYCQQSKEVPWTFGGGTKVEIKRTVAAPSVFIFPPSDEQLKSGTASVVCLL
                # NNFYPREAKVQWKVDNALQSGNSQESVTEQDSKDSTYSLSSTLTLSKADYEKHKVYACEVTHQGLSSPVTKSFNRGEC' , 'EVQ
                # LVQSGPELKKPGASVKVSCKASGYTFTNYGMNWVRQAPGQGLEWMGWINTYTGETTYADDFKGRFVFSLDTSVSTAYLQISSLKAE
                # DTAVYYCEREGGVNNWGQGTLVTVSSASTKGPSVFPLAPSSKSTSGGTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSS
                # GLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKVEPKSCDKTHT' , 'EVQLVQSGAEVKKPGASVKVSCKASGYTFTDYN
                # MHWVRQAPGQGLEWMGEINPNSGGAGYNQKFKGRVTMTTDTSTSTAYMELRSLRSDDTAVYYCARLGYDDIYDDWYFDVWGQGTTV
                # TVSSASTKGPSVFPLAPCSRSTSESTAALGCLVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSNFGTQTYT
                # CNVDHKPSNTKVDKTVERKCCVECPPCPAPPVAGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVQFNWYVDGVEVHNAKT
                # KPREEQFNSTFRVVSVLTVVHQDWLNGKEYKCKVSNKGLPAPIEKTISKTKGQPREPQVYTLPPSREEMTKNQVSLTCLVKGFYPS
                # DIAVEWESNGQPENNYKTTPPMLDSDGSFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'GCKWDLLIK
                # QWVCDPLGSGSATGGSGSTASSGSGSATHMLPGCKWDLLIKQWVCDPLGGGGGVDKTHTCPPCPAPELLGGPSVFLFPPKPKDTLM
                # ISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNGKEYKCKVSNKALPAPIEKTISK
                # AKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDGSFFLYSKLTVDKSRWQQGNVFS
                # CSVMHEALHNHYTQKSLSLSPGK' , 'QAYLQQSGAELVRPGASVKMSCKASGYTFTSYNMHWVKQTPRQGLEWIGAIYPGNGDT
                # SYNQKFKGKATLTVDKSSSTAYMQLSSLTSEDSAVYFCARVVYYSNSYWYFDVWGTGTTVTVSGPSVFPLAPSSKSTSGGTAALGC
                # LVKDYFPEPVTVSWNSGALTSGVHTFPAVLQSSGLYSLSSVVTVPSSSLGTQTYICNVNHKPSNTKVDKKAEPKSCDKTHTCPPCP
                # APELLGGPSVFLFPPKPKDTLMISRTPEVTCVVVDVSHEDPEVKFNWYVDGVEVHNAKTKPREEQYNSTYRVVSVLTVLHQDWLNG
                # KEYKCKVSNKALPAPIEKTISKAKGQPREPQVYTLPPSRDELTKNQVSLTCLVKGFYPSDIAVEWESNGQPENNYKTTPPVLDSDG
                # SFFLYSKLTVDKSRWQQGNVFSCSVMHEALHNHYTQKSLSLSPGK' , 'MRLPLLVSAGVLLVALLPCPPCRALLSRGPVPGARQ
                # APQHPQPLDFFQPPPQSEQPQQPQARPVLLRMGEEYFLRLGNLNKSPAAPLSPASSLLAGGSGSRPSPEQATANFFRVLLQQLLLP
                # RRSLDSPAALAERGARNALGGHQEAPERERRSEEPPISLDLTFHLLREVLEMARAEQLAQQAHSNRKLMEIIGK' , 'SAVKAAR
                # YGKDNVRVYKVHKDEKTGVQTVYEMTVCVLLEGEIETSYTKADNSVIVATDSIKNTIYITAKQNPVTPPELFGSILGTHFIEKYNH
                # IHAAHVNIVCHRWTRMDIDGKPHPHSFIRDSEEKRNVQVDVVEGKGIDIKSSLSGLTVLKSTNSQFWGFLRDEYTTLKETWDRILS
                # TDVDATWQWKNFSGLQEVRSHVPKFDATWATAREVTLKTFAEDNSASVQATMYKMAEQILARQQLIETVEYSLPNKHYFEIDLSWH
                # KGLQNTGKNAEVFAPQSDPNGLIKCTVGRSSLKSKL'
                'tax_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '9606' , '9606' , '10090' , '10090' , '9606' , '5059' , '9606' , '9606' , '9606' , '96
                # 06'
            }
        },
        'description': DefaultMappings.TEXT_STD,
        # EXAMPLES:
        # 'SAUVAGINE' , 'NEUROPEPTIDE Y(NPY)' , 'DYNORPHIN A (1-17)' , 'GASTRIN' , 'NEUROKININ B' , 'CYC
        # LOLEONURIPEPTIDE E' , 'ENDOTHELIN' , 'FLUORO[HYDROXY(PHENYL)PHOSPHORYL]METHYL(PHENYL)PHOSPHINI
        # C ACID' , 'DRIGAQSGLGCNSFRY' , 'PROCTOLIN'
        'helm_notation': DefaultMappings.KEYWORD,
        # EXAMPLES:
        # 'PEPTIDE1{[Cbz_V].A.[X1486]}$$$$' , 'PEPTIDE1{[ac].[X1693].L.G.G.I.W}$$$$' , 'PEPTIDE1{[dP].R.
        # [Nal].G.[dY]}$PEPTIDE1,PEPTIDE1,5:R2-1:R1$$$' , 'PEPTIDE1{[dC].[dR].V.[dY].R.[dP].[dC].W.[dE].
        # [dV]}$PEPTIDE1,PEPTIDE1,7:R3-1:R3$$$' , 'PEPTIDE1{F.G.G.F.T.G.C.R.K.S.A.R.K.C.[am]}$PEPTIDE1,P
        # EPTIDE1,14:R3-7:R3$$$' , 'PEPTIDE1{[dY].[dC].F.W.K.T.C.[meT].[am]}$PEPTIDE1,PEPTIDE1,7:R3-2:R3
        # $$$' , 'PEPTIDE1{[Sar].R.V.[X539].V.H.[dP].F}$$$$' , 'PEPTIDE1{R.[dP].[dK].P.Q.[dQ].[dF].F.G.L
        # .M.[am]}$$$$' , 'PEPTIDE1{[Glp].G.P.P.I.S.I.D.L.P.L.E.L.L.R.K.M.I.E.I.E.K.Q.E.K.E.K.Q.Q.A.A.N.
        # N.R.L.L.L.D.T.I}$$$$' , 'PEPTIDE1{[dCha].P.[X2192].G.G.G.G.D.Y.E.P.[lalloI].P.E.E.Y.[Cha].D}$$
        # $$'
        'molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
        # EXAMPLES:
        # 'CHEMBL423324' , 'CHEMBL424227' , 'CHEMBL424826' , 'CHEMBL424915' , 'CHEMBL424934' , 'CHEMBL41
        # 3830' , 'CHEMBL413163' , 'CHEMBL413166' , 'CHEMBL414711' , 'CHEMBL414760'
    }
}

molecule_properties = {
    'properties':
    {
        'acd_logd': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '2.53' , '1.17' , '2.72' , '-1.84' , '-1.70' , '2.69' , '-1.54' , '1.16' , '3.94' , '0.59'
        'acd_logp': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '2.53' , '1.73' , '3.67' , '1.18' , '0.00' , '2.69' , '-1.53' , '2.93' , '4.53' , '5.31'
        'acd_most_apka': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '12.54' , '4.14' , '11.20' , '12.01' , '13.42' , '3.55' , '4.86' , '13.26' , '13.99' , '11.15'
        'acd_most_bpka': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '2.00' , '8.19' , '8.34' , '5.12' , '9.09' , '4.05' , '5.64' , '9.25' , '10.28' , '0.54'
        'alogp': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '2.02' , '1.91' , '4.62' , '2.81' , '0.78' , '3.25' , '-0.57' , '1.79' , '5.66' , '6.40'
        'aromatic_rings': DefaultMappings.INTEGER,
        # EXAMPLES:
        # '2' , '3' , '3' , '4' , '2' , '2' , '1' , '2' , '3' , '3'
        'full_molformula': DefaultMappings.KEYWORD,
        # EXAMPLES:
        # 'C16H17N5O' , 'C13H11ClN6S' , 'C23H22F2N2' , 'C28H27N5O4' , 'C23H22N4O5' , 'C19H17ClN2O2' , 'C
        # 16H22N4O4S' , 'C24H34N6O3' , 'C28H31Cl2N3O4' , 'C28H30O7S'
        'full_mwt': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '295.34' , '318.78' , '364.43' , '497.55' , '434.44' , '340.80' , '366.44' , '454.57' , '544.4
        # 7' , '510.60'
        'hba': DefaultMappings.INTEGER,
        # EXAMPLES:
        # '4' , '3' , '2' , '6' , '8' , '3' , '8' , '7' , '6' , '7'
        'hba_lipinski': DefaultMappings.INTEGER,
        # EXAMPLES:
        # '6' , '6' , '2' , '9' , '9' , '4' , '8' , '9' , '7' , '7'
        'hbd': DefaultMappings.INTEGER,
        # EXAMPLES:
        # '2' , '4' , '1' , '3' , '2' , '1' , '1' , '3' , '2' , '2'
        'hbd_lipinski': DefaultMappings.INTEGER,
        # EXAMPLES:
        # '2' , '5' , '2' , '3' , '3' , '1' , '2' , '3' , '2' , '2'
        'heavy_atoms': DefaultMappings.INTEGER,
        # EXAMPLES:
        # '22' , '20' , '27' , '37' , '32' , '24' , '25' , '33' , '37' , '36'
        'molecular_species': DefaultMappings.KEYWORD,
        # EXAMPLES:
        # 'NEUTRAL' , 'NEUTRAL' , 'NEUTRAL' , 'ACID' , 'BASE' , 'NEUTRAL' , 'NEUTRAL' , 'BASE' , 'BASE'
        # , 'ACID'
        'mw_freebase': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '295.34' , '282.32' , '364.43' , '497.55' , '434.44' , '340.80' , '366.44' , '454.57' , '544.4
        # 7' , '510.60'
        'mw_monoisotopic': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '295.1433' , '282.0688' , '364.1751' , '497.2063' , '434.1590' , '340.0979' , '366.1362' , '45
        # 4.2692' , '543.1692' , '510.1712'
        'num_lipinski_ro5_violations': DefaultMappings.SHORT,
        # EXAMPLES:
        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '1' , '1'
        'num_ro5_violations': DefaultMappings.SHORT,
        # EXAMPLES:
        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '2' , '2'
        'psa': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '90.70' , '142.60' , '29.26' , '118.63' , '127.34' , '41.57' , '140.78' , '110.69' , '83.92' ,
        #  '126.35'
        'qed_weighted': DefaultMappings.DOUBLE,
        # EXAMPLES:
        # '0.91' , '0.43' , '0.72' , '0.36' , '0.31' , '0.85' , '0.45' , '0.56' , '0.34' , '0.24'
        'ro3_pass': DefaultMappings.KEYWORD,
        # EXAMPLES:
        # 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N' , 'N'
        'rtb': DefaultMappings.INTEGER,
        # EXAMPLES:
        # '3' , '3' , '5' , '7' , '5' , '2' , '9' , '8' , '10' , '14'
    }
}

molecule_structures = {
    'properties':
    {
        'canonical_smiles': DefaultMappings.ID_REF,
        # EXAMPLES:
        # 'CC(C)(C)c1ccc(cc1NC(=O)Nc2cncnc2)C#N' , 'Cl.NC(=N)Nc1nc(cs1)c2c[nH]c3ccc(cc23)C#N' , 'N[C@H](
        # [C@@H]1CCN1C(c2ccccc2)c3ccccc3)c4cc(F)cc(F)c4' , 'CN(Cc1nc2ccccc2[nH]1)C(=O)c3ccc4N[C@@H](CC(=
        # O)O)C(=O)N(Cc5ccccc5)Cc4c3' , 'CC[C@@]1(O)C(=O)OCC2=C1C=C3N(Cc4c(\C=N\OCCN)c5ccccc5nc34)C2=O'
        # , 'Clc1ccc2NC(=O)\C(=C/c3ccc(cc3)N4CCOCC4)\c2c1' , 'CC(=O)OCC\C(=C(\C)/N(Cc1cnc(C)nc1N)C=O)\SC
        # (=O)C' , 'CC(C)CNc1cccnc1N2CCN(CC2)C(=O)c3ccc(cn3)C(=O)NC(C)(C)CO' , 'COc1ccc(cc1OCCc2ccc(Cl)c
        # c2Cl)C(=O)NCC3CCN(Cc4ccnc(O)c4)CC3' , 'OC(=O)CCc1cc(ccc1OCCCCCCc2ccccc2)S(=O)(=O)c3cccc(c3)C(=
        # O)O'
        'standard_inchi': DefaultMappings.ID_REF,
        # EXAMPLES:
        # 'InChI=1S/C16H17N5O/c1-16(2,3)13-5-4-11(7-17)6-14(13)21-15(22)20-12-8-18-10-19-9-12/h4-6,8-10H
        # ,1-3H3,(H2,20,21,22)' , 'InChI=1S/C13H10N6S.ClH/c14-4-7-1-2-10-8(3-7)9(5-17-10)11-6-20-13(18-1
        # 1)19-12(15)16;/h1-3,5-6,17H,(H4,15,16,18,19);1H' , 'InChI=1S/C23H22F2N2/c24-19-13-18(14-20(25)
        # 15-19)22(26)21-11-12-27(21)23(16-7-3-1-4-8-16)17-9-5-2-6-10-17/h1-10,13-15,21-23H,11-12,26H2/t
        # 21-,22-/m0/s1' , 'InChI=1S/C28H27N5O4/c1-32(17-25-30-22-9-5-6-10-23(22)31-25)27(36)19-11-12-21
        # -20(13-19)16-33(15-18-7-3-2-4-8-18)28(37)24(29-21)14-26(34)35/h2-13,24,29H,14-17H2,1H3,(H,30,3
        # 1)(H,34,35)/t24-/m0/s1' , 'InChI=1S/C23H22N4O5/c1-2-23(30)17-9-19-20-15(11-27(19)21(28)16(17)1
        # 2-31-22(23)29)14(10-25-32-8-7-24)13-5-3-4-6-18(13)26-20/h3-6,9-10,30H,2,7-8,11-12,24H2,1H3/b25
        # -10+/t23-/m0/s1' , 'InChI=1S/C19H17ClN2O2/c20-14-3-6-18-16(12-14)17(19(23)21-18)11-13-1-4-15(5
        # -2-13)22-7-9-24-10-8-22/h1-6,11-12H,7-10H2,(H,21,23)/b17-11-' , 'InChI=1S/C16H22N4O4S/c1-10(15
        # (25-13(4)23)5-6-24-12(3)22)20(9-21)8-14-7-18-11(2)19-16(14)17/h7,9H,5-6,8H2,1-4H3,(H2,17,18,19
        # )/b15-10+' , 'InChI=1S/C24H34N6O3/c1-17(2)14-26-19-6-5-9-25-21(19)29-10-12-30(13-11-29)23(33)2
        # 0-8-7-18(15-27-20)22(32)28-24(3,4)16-31/h5-9,15,17,26,31H,10-14,16H2,1-4H3,(H,28,32)' , 'InChI
        # =1S/C28H31Cl2N3O4/c1-36-25-5-3-22(15-26(25)37-13-9-21-2-4-23(29)16-24(21)30)28(35)32-17-19-7-1
        # 1-33(12-8-19)18-20-6-10-31-27(34)14-20/h2-6,10,14-16,19H,7-9,11-13,17-18H2,1H3,(H,31,34)(H,32,
        # 35)' , 'InChI=1S/C28H30O7S/c29-27(30)17-14-22-19-25(36(33,34)24-13-8-12-23(20-24)28(31)32)15-1
        # 6-26(22)35-18-7-2-1-4-9-21-10-5-3-6-11-21/h3,5-6,8,10-13,15-16,19-20H,1-2,4,7,9,14,17-18H2,(H,
        # 29,30)(H,31,32)'
        'standard_inchi_key': DefaultMappings.ID_REF,
        # EXAMPLES:
        # 'KJWLSAJZQJTBAB-UHFFFAOYSA-N' , 'RVUCTNPDPUECET-UHFFFAOYSA-N' , 'SUUJWXLFHRQIRQ-VXKWHMMOSA-N'
        # , 'XJIREEHRSUICRY-DEOSSOPVSA-N' , 'IBTISPLPBBHVSU-UVOOVGFISA-N' , 'DVKIICSQTRTPIE-BOPFTXTBSA-N
        # ' , 'ISIPQAHMLLFSFR-XNTDXEJSSA-N' , 'BHYLGMFIZXXPJS-UHFFFAOYSA-N' , 'JEROPZADNPCENF-UHFFFAOYSA
        # -N' , 'KDNMVHRYHFFDMT-UHFFFAOYSA-N'
    }
}

molecule_synonyms = {
    'properties':
    {
        'molecule_synonym': DefaultMappings.ALT_NAME,
        # EXAMPLES:
        # 'Acetiamine' , 'Quinazoline-2,4-Diol' , 'Parethoxycaine' , 'SID124892379' , 'SID11113057' , '3
        # -Epidigoxigenin' , 'SID103905191' , 'Caseanigrescen B' , '4-Epicycloeucalenone' , 'DU1301'
        'syn_type': DefaultMappings.KEYWORD,
        # EXAMPLES:
        # 'INN_DB' , 'OTHER' , 'INN_DB' , 'OTHER_PC' , 'OTHER_PC' , 'OTHER' , 'OTHER_PC' , 'TRADE_NAME_O
        # LD' , 'OTHER' , 'OTHER'
        'synonyms': DefaultMappings.ALT_NAME,
        # EXAMPLES:
        # 'ACETIAMINE' , 'Quinazoline-2,4-Diol' , 'PARETHOXYCAINE' , 'SID124892379' , 'SID11113057' , '3
        # -Epidigoxigenin' , 'SID103905191' , 'CASEANIGRESCEN B' , '4-Epicycloeucalenone' , 'DU1301'
    }
}

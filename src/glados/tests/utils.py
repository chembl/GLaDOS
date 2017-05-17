
# Longest molecule SMILES found in ChEMBL
LONGEST_CHEMBL_SMILES = r'CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC1OC(CO)C(O)C(O)C1O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+' \
                        r']OC(CO)C(O)C(OC2OC(CO)C(O)C(O)C2O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC3OC(CO' \
                        r')C(O)C(O)C3O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC4OC(CO)C(O)C(O)C4O)C(O)CO.C' \
                        r'CCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC5OC(CO)C(O)C(O)C5O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]' \
                        r'OC(CO)C(O)C(OC6OC(CO)C(O)C(O)C6O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC7OC(CO)' \
                        r'C(O)C(O)C7O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC8OC(CO)C(O)C(O)C8O)C(O)CO.CC' \
                        r'CCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC9OC(CO)C(O)C(O)C9O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]O' \
                        r'C(CO)C(O)C(OC%10OC(CO)C(O)C(O)C%10O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC%11O' \
                        r'C(CO)C(O)C(O)C%11O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC%12OC(CO)C(O)C(O)C%12' \
                        r'O)C(O)CO.CCCCCCCCCC(C(=O)NCCc%13ccc(OP(=S)(Oc%14ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-' \
                        r'])cc%14)N(C)\N=C\c%15ccc(Op%16(Oc%17ccc(\C=N\N(C)P(=S)(Oc%18ccc(CCNC(=O)C(CCCCCCCCC' \
                        r')P(=O)(O)[O-])cc%18)Oc%19ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%19)cc%17)np(Oc%20c' \
                        r'cc(\C=N\N(C)P(=S)(Oc%21ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%21)Oc%22ccc(CCNC(=O)' \
                        r'C(CCCCCCCCC)P(=O)(O)[O-])cc%22)cc%20)(Oc%23ccc(\C=N\N(C)P(=S)(Oc%24ccc(CCNC(=O)C(CC' \
                        r'CCCCCCC)P(=O)(O)[O-])cc%24)Oc%25ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%25)cc%23)np' \
                        r'(Oc%26ccc(\C=N\N(C)P(=S)(Oc%27ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%27)Oc%28ccc(C' \
                        r'CNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%28)cc%26)(Oc%29ccc(\C=N\N(C)P(=S)(Oc%30ccc(CCNC(' \
                        r'=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%30)Oc%31ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%31)c' \
                        r'c%29)n%16)cc%15)cc%13)P(=O)(O)[O-]'


SMILES_EXAMPLES = \
    [
        r'COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56',
        r'C\C(=C\C(=O)O)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C',
        r'COC1(CN2CCC1CC2)C#CC(C#N)(c3ccccc3)c4ccccc4',
        r'CN1C\C(=C/c2ccc(C)cc2)\C3=C(C1)C(C(=C(N)O3)C#N)c4ccc(C)cc4',
        r'COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56',
        r'CC(C)C[C@H](NC(=O)[C@@H](NC(=O)[C@H](Cc1c[nH]c2ccccc12)NC(=O)[C@H]3CCCN3C(=O)C(CCCCN)CCCCN)C(C)(C)C)C(=O)O',
        r'Cc1nnc2CN=C(c3ccccc3)c4cc(Cl)ccc4-n12',
        r'CN1C(=O)CN=C(c2ccccc2)c3cc(Cl)ccc13',
        r'c',
        r'ccc',
        r'cs',
        r'ccs',
        r'CC(C)(N)Cc1ccccc1',
        r'CCCc1nn(C)c2C(=O)NC(=Nc12)c3cc(ccc3OCC)S(=O)(=O)N4CCN(C)CC4.OC(=O)CC(O)(CC(=O)O)C(=O)O',
        r'CCOc1ccc(cc1)c2nn3nc(SC)ccc3c2c4ccc(cc4)S(=O)(=O)N',
        r'COc1cc2ncnc(Nc3cc(NC(=O)c4ccccc4)ccc3C)c2cc1OC',
        r'CC(=O)Nc1cccc(c1)c2cc(ccc2COCc3cncn3Cc4ccc(cc4)C#N)C#N',
        r'COc1cccc(c1)c2cc(ccc2COCc3cncn3Cc4ccc(nc4)C#N)C#N',
        r'Cc1cc(C)nc(NC(=O)CCc2c[nH]c3ccccc23)c1',
        r'COc1cc2ncnc(Nc3ccc(C)c(NC(=O)c4ccccc4)c3)c2cc1OC',
        r'COc1ccc2c(c3ccc(cc3)S(=O)(=O)C)c(nn2n1)c4ccc(F)cc4',
        r'Cc1ccccc1COc2ccc(cc2)S(=O)(=O)N3CCC[C@@](C)(O)[C@@H]3C(=O)NO',
        r'Cc1csc(c1)C(=O)NNC(=O)CN2CCCN(Cc3ccc(Cl)cc3)CC2',
        r'Clc1ccc(OCc2ccccc2)c(\C=C\3/SC(=O)NC3=O)c1',
        LONGEST_CHEMBL_SMILES
    ]

INCHI_EXAMPLES = \
    [
        'InChI=1S/C21H20N4O3S2/c1-3-28-16-8-4-15(5-9-16)21-20(14-6-10-17(11-7-14)30(22,26)27)18-12-13-19(29-2)23-25(18)'
        '24-21/h4-13H,3H2,1-2H3,(H2,22,26,27)',
        'InChI=1S/C24H22N4O3/c1-15-9-10-17(27-24(29)16-7-5-4-6-8-16)11-19(15)28-23-18-12-21(30-2)22(31-3)13-20(18)25-14'
        '-26-23/h4-14H,1-3H3,(H,27,29)(H,25,26,28)',
        'InChI=1S/C28H23N5O2/c1-20(34)32-26-4-2-3-24(12-26)28-11-23(14-30)9-10-25(28)17-35-18-27-15-31-19-33(27)16-22-7'
        '-5-21(13-29)6-8-22/h2-12,15,19H,16-18H2,1H3,(H,32,34)',
        'InChI=1S/C26H21N5O2/c1-32-25-4-2-3-21(10-25)26-9-19(11-27)5-7-22(26)16-33-17-24-14-29-18-31(24)15-20-6-8-23(12'
        '-28)30-13-20/h2-10,13-14,18H,15-17H2,1H3',
        'InChI=1S/C18H19N3O/c1-12-9-13(2)20-17(10-12)21-18(22)8-7-14-11-19-16-6-4-3-5-15(14)16/h3-6,9-11,19H,7-8H2,1-2H'
        '3,(H,20,21,22)',
        'InChI=1S/C24H22N4O3/c1-15-9-10-17(11-19(15)28-24(29)16-7-5-4-6-8-16)27-23-18-12-21(30-2)22(31-3)13-20(18)25-14'
        '-26-23/h4-14H,1-3H3,(H,28,29)(H,25,26,27)',
        'InChI=1S/C20H16FN3O3S/c1-27-18-12-11-17-19(13-5-9-16(10-6-13)28(2,25)26)20(23-24(17)22-18)14-3-7-15(21)8-4-14/'
        'h3-12H,1-2H3',
        'InChI=1S/C21H26N2O6S/c1-15-6-3-4-7-16(15)14-29-17-8-10-18(11-9-17)30(27,28)23-13-5-12-21(2,25)19(23)20(24)22-2'
        '6/h3-4,6-11,19,25-26H,5,12-14H2,1-2H3,(H,22,24)/t19-,21+/m0/s1',
        'InChI=1S/C20H25ClN4O2S/c1-15-11-18(28-14-15)20(27)23-22-19(26)13-25-8-2-7-24(9-10-25)12-16-3-5-17(21)6-4-16/h3'
        '-6,11,14H,2,7-10,12-13H2,1H3,(H,22,26)(H,23,27)',
        'InChI=1S/C17H12ClNO3S/c18-13 -6-7-14(22-10-11-4-2-1-3-5-11)12(8-13)9-15-16(20)19-17(21)23-15/h1-9H,10H2,(H,19,'
        '20,21)/b15-9-'
    ]

INCHI_KEY_EXAMPLES = \
    [
        'WQGOWYVBXVBECY-UHFFFAOYSA-N',
        'UVUISNWETBUMTN-UHFFFAOYSA-N',
        'NUPPXHWHRPUCIJ-UHFFFAOYSA-N',
        'JEFGVHRSOIKILD-UHFFFAOYSA-N',
        'UYAJKEYVAXYMNW-UHFFFAOYSA-N',
        'IYBAQZSLFMVGQZ-UHFFFAOYSA-N',
        'TZIFVBRWFVXOKP-UHFFFAOYSA-N',
        'FYNYGUYHKZWCAU-PZJWPPBQSA-N',
        'WVLXVIZBRPTUKG-UHFFFAOYSA-N',
        'OVELZDQGMGPZBH-DHDCSXOGSA-N'
    ]
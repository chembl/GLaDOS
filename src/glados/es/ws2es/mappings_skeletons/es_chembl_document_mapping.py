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
                        'es_completion': 'TEXT',
                        # EXAMPLES:
                        # '{'weight': 60, 'input': 'The 3-unsubstituted and substituted analogs of naltrindole (NTI) wer
                        # e synthesized using palladium-catalyzed transformations, and their binding affinity to opioid 
                        # receptors was determined. Although the 3-desoxy analog showed comparable delta selectivity wit
                        # h that of NTI, all of the novel compounds possessed low affinity for delta receptors indicatin
                        # g the important role of the 3-oxygen atom of NTI for interaction with delta-opioid receptors.'
                        # }' , '{'weight': 10, 'input': 'CHEMBL1152025'}' , '{'weight': 60, 'input': 'A series of new, h
                        # ighly potent and orally active "motilactides", 9-deoxo-4"-deoxy-6,9-epoxyerythromycin lactams 
                        # was designed, synthesized, and evaluated for their gastrointestinal motor stimulating activity
                        # . These compounds were acid stable and showed good oral efficacy.'}' , '{'weight': 100, 'input
                        # ': 'Ferkany J, Willetts J, Borosky D, Clissold E, Karbon, Hamilton G'}' , '{'weight': 100, 'in
                        # put': 'Tye CK, Kasinathan G, Barrett MP, Brun R, Doyle VE, Fairlamb AH, Weaver R, Gilbert IH.'
                        # }' , '{'weight': 10, 'input': '10.1016/S0960-894X(00)80088-8'}' , '{'weight': 100, 'input': 'L
                        # -374,087, an efficacious, orally bioavailable, pyridinone acetamide thrombin inhibitor.'}' , '
                        # {'weight': 10, 'input': 'CHEMBL1127097'}' , '{'weight': 10, 'input': '10.1016/s0960-894x(98)00
                        # 119-x'}' , '{'weight': 100, 'input': 'Malone TC, Ortwine DF, Johnson G, Probert AW'}'
                    }
                },
                'abstract': 'TEXT',
                # EXAMPLES:
                # '' , '' , '' , '' , '' , '' , '' , '' , '' , 'Novel isodideoxy nucleosides with exocyclic methylene we
                # re synthesized starting from L-xylose utilizing anomeric demethoxylation, Wittig reaction and Mitsunob
                # u reaction as key steps and evaluated for antiviral activity.'
                'authors': 'TEXT',
                # EXAMPLES:
                # 'Kubota H, Rothman RB, Dersch C, McCullough K, Pinto J, Rice KC.' , 'Hamilton G, Huang Z, Patch R, Nar
                # ayanan B, Ferkany J' , 'Faghih R, Nellans HN, Lartey PA, Petersen A, Marsh K, Bennani YL, Plattner JJ.
                # ' , 'Ferkany J, Willetts J, Borosky D, Clissold E, Karbon, Hamilton G' , 'Tye CK, Kasinathan G, Barret
                # t MP, Brun R, Doyle VE, Fairlamb AH, Weaver R, Gilbert IH.' , 'Bigge CF, Wu J, Malone TC, Taylor CP, V
                # artanian MG' , 'Sanderson PE, Cutrona KJ, Dorsey BD, Dyer DL, McDonough CM, Naylor-Olsen AM, Chen IW, 
                # Chen Z, Cook JJ, Gardell SJ, Krueger JA, Lewis SD, Lin JH, Lucas BJ, Lyle EA, Lynch JJ, Stranieri MT, 
                # Vastag K, Shafer JA, Vacca JP.' , 'Ornstein PL, Arnold M, Evrard D, Leander J, Lodge D, Schoepp DD' , 
                # 'Patel M, Bacheler LT, Rayner MM, Cordova BC, Klabe RM, Erickson-Viitanen S, Seitz SP.' , 'Malone TC, 
                # Ortwine DF, Johnson G, Probert AW'
                'doc_type': 'TEXT',
                # EXAMPLES:
                # 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLI
                # CATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1130776' , 'CHEMBL1152025' , 'CHEMBL1131560' , 'CHEMBL1127095' , 'CHEMBL1131358' , 'CHEMBL11270
                # 96' , 'CHEMBL1130777' , 'CHEMBL1127097' , 'CHEMBL1130778' , 'CHEMBL1152111'
                'doi': 'TEXT',
                # EXAMPLES:
                # '10.1016/s0960-894x(98)00105-x' , '10.1016/S0960-894X(00)80086-4' , '10.1016/s0960-894x(98)00111-5' , 
                # '10.1016/S0960-894X(00)80087-6' , '10.1016/s0960-894x(98)00095-x' , '10.1016/S0960-894X(00)80088-8' , 
                # '10.1016/s0960-894x(98)00117-6' , '10.1016/S0960-894X(00)80089-X' , '10.1016/s0960-894x(98)00119-x' , 
                # '10.1016/S0960-894X(00)80090-6'
                'first_page': 'NUMERIC',
                # EXAMPLES:
                # '799' , '27' , '805' , '33' , '811' , '39' , '817' , '43' , '823' , '49'
                'issue': 'NUMERIC',
                # EXAMPLES:
                # '7' , '1' , '7' , '1' , '7' , '1' , '7' , '1' , '7' , '1'
                'journal': 'TEXT',
                # EXAMPLES:
                # 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. C
                # hem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , '
                # Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg. Med. Chem. Lett.'
                'journal_full_title': 'TEXT',
                # EXAMPLES:
                # 'Bioorganic & medicinal chemistry letters.' , 'Bioorganic & medicinal chemistry letters.' , 'Bioorgani
                # c & medicinal chemistry letters.' , 'Bioorganic & medicinal chemistry letters.' , 'Bioorganic & medici
                # nal chemistry letters.' , 'Bioorganic & medicinal chemistry letters.' , 'Bioorganic & medicinal chemis
                # try letters.' , 'Bioorganic & medicinal chemistry letters.' , 'Bioorganic & medicinal chemistry letter
                # s.' , 'Bioorganic & medicinal chemistry letters.'
                'last_page': 'NUMERIC',
                # EXAMPLES:
                # '804' , '32' , '810' , '38' , '816' , '42' , '822' , '48' , '828' , '54'
                'patent_id': 'TEXT',
                # EXAMPLES:
                # 'US-8629135-B2' , 'US-8835445-B2' , 'US-9181185-B2' , 'US-9181187-B2' , 'US-8629167-B2' , 'US-8629282-
                # B2' , 'US-8633183-B2' , 'US-9181233-B2' , 'US-8841312-B2' , 'US-8633196-B2'
                'pubmed_id': 'NUMERIC',
                # EXAMPLES:
                # '9871544' , '9871545' , '9871546' , '9871547' , '9871548' , '9871549' , '9871550' , '9871551' , '98715
                # 52' , '9871553'
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'title': 'TEXT',
                # EXAMPLES:
                # 'Synthesis and biological activity of 3-substituted 3-desoxynaltrindole derivatives.' , 'Enzymatic asy
                # mmetric synthesis of (2R, 4R, 5S)-2-amino-4,5-(1,2-cyclohexyl)-7-phosphonoheptanoic acid, a potent, se
                # lective and competitive NMDA antagonist' , 'Preparation of 9-deoxo-4"-deoxy-6,9-epoxyerythromycin lact
                # ams "motilactides": potent and orally active prokinetic agents.' , 'Pharmacology of (2R, 4R, 5S)-2-ami
                # no-4,5-(1,2-cyclohexyl)-7-phosphonoheptanoic acid (NPC 17742); a selective, systemically active, compe
                # titive NMDA antagonist' , 'An approach to use an unusual adenosine transporter to selectively deliver 
                # polyamine analogues to trypanosomes.' , 'Synthesis and anticonvulsant activity of the (+)- and ()-enan
                # tiomers of 1,2,3,4-tetrahydro-5-(2-phosphonoethyl)-3-isoquinolinecarboxylic acid, a competitive NMDA a
                # ntagonist' , 'L-374,087, an efficacious, orally bioavailable, pyridinone acetamide thrombin inhibitor.
                # ' , 'Tetrazole amino acids as competitive NMDA antagonists' , 'The synthesis and evaluation of cyclic 
                # ureas as HIV protease inhibitors: modifications of the P1/P1' residues.' , 'Synthesis and biological a
                # ctivity of conformationally constrained 4a-phenanthreneamine derivatives as noncompetitive NMDA antago
                # nists'
                'volume': 'NUMERIC',
                # EXAMPLES:
                # '8' , '3' , '8' , '3' , '8' , '3' , '8' , '3' , '8' , '3'
                'year': 'NUMERIC',
                # EXAMPLES:
                # '1998' , '1993' , '1998' , '1993' , '1998' , '1993' , '1998' , '1993' , '1998' , '1993'
            }
        }
    }

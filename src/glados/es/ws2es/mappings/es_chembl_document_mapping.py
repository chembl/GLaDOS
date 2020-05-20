# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 0

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        'properties':
        {
            '_metadata':
            {
                'properties':
                {
                    'es_completion': DefaultMappings.COMPLETION_TYPE
                }
            },
            'abstract': DefaultMappings.TEXT_STD,
            # EXAMPLES:
            # 'Two new C-18 norwithanolides based on a C(27) skeleton, subtrifloralactones K (1) and L (2), a new C-
            # 18 oxygenated withanolide, 13 beta-hydroxymethylsubtrifloralactone E (3), and a new alpha-ionone deriv
            # ative, (+)-7 alpha,8 alpha-epoxyblumenol B (4), along with five known compounds, philadelphicalactone
            # A (5), (2S,3S,4R)-2-[(2R)-2'-hydroxytetracosanoylamino]-1,3,4-octadecanetriol (6), trans-N-feruloyltyr
            # amine, cis-N-feruloyltyramine, and (S)-coriolic acid, were isolated from additional active fractions o
            # f the chloroform-soluble extract of Deprea subtriflora, using a quinone reductase (QR) induction assay
            #  as a monitor. The structures of compounds 1-4 were characterized by spectroscopic data interpretation
            # . The potential cancer chemopreventive activities of all isolates in terms of their ability to induce
            # QR activity with cultured Hepa 1c1c7 mouse hepatoma cells were evaluated.' , '' , 'Bripiodionen (1), a
            #  new natural product, was isolated from Streptomyces sp. WC76599 during the screening of microbial fer
            # mentation extracts for their ability to inhibit human cytomegalovirus protease. The structure of 1 was
            #  elucidated by spectroscopic methods. Compound 1 displayed inhibitory activity against human cytomegal
            # ovirus protease with an IC50 value of 30 microM.' , 'New monomeric (korupensamine E, 6) and dimeric (m
            # ichellamines D-F, 7-9) naphthylisoquinoline alkaloids have been isolated from exracts of the tropical
            # liana Ancistrocladus korupensis. Structures were determined by spectroanalytical methods, and stereoch
            # emistry was defined through NOE correlations, chemical degradation, and CD spectroscopy. Michellamines
            #  D-F exhibited in vitro HIV-inhibitory activity comparable to michellamine B, and korupensamine E exhi
            # bited in vitro antimalarial activity comparable to korupensamines A-D.' , 'Two new benzoquinones with
            # antifungal, antibacterial, and cytotoxic activities have been isolated from liquid cultures of the cop
            # rophilous fungus Podospora anserina. The structures of anserinones A (1) and B (2) were assigned on th
            # e basis of MS and NMR results, and the absolute stereochemistry of 2 was deduced by analysis of 1H-NMR
            #  data for its (R)- and (S)-2-phenylbutyryl ester derivatives.' , 'Using antiplatelet aggregation as a
            # guide to fractionation, seven aporphines, actinodaphnine (1), N-methylactinodaphnine (2), launobine (3
            # ), dicentrine (4), O-methylbulbocapnine (5), hernovine (7), and bulbocapnine (9), and two oxoaporphine
            # s, dicentrinone (6) and liriodenine (8), were isolated from the stems of Illigera luzonensis. Among th
            # em, compounds 2, 4, 5, 8, and 9 were isolated for the first time from this species. Moreover, compound
            # s 1-5, and 8 showed significant antiplatelet aggregation and compounds 1 and 6 exhibited significant v
            # asorelaxant activities, respectively.' , 'A further investigation of Aster lingulatus has led to the i
            # solation of two additional novel triterpene saponins, asterlingulatoside C [3-O-beta-D-glucopyranosyl-
            # 3 beta, 16 alpha-dihydroxyolean-12-en-28-oic acid 28-O-beta-D-xylopyranosyl-(1-->4)-alpha-L-rhamnopyra
            # nosyl-(1-->2)-alpha- L- arabinopyranoside] (1) and asterlingulatoside D [3-O-beta-D-glucopyranosyl-3 b
            # eta,16 alpha-dihydroxyolean-12-en-28-oic acid 28-O-beta-D-xylopyranosyl-(1-->3)-beta-D-xylopyranosyl-(
            # 1-->4)-alpha-L- rhamnopyranosyl-(1-->2)-alpha-L-arabinopyranoside] (2). Elucidation of the structures
            # of 1 and 2 was mainly based on FABMS and 1D and 2D homonuclear and heteronuclear NMR techniques. Compo
            # unds 1 and 2 showed good inhibitory activity against DNA synthesis in human leukemia HL-60 cells with
            # IC50 values of 8.8 and 6.1 microM, respectively.' , 'Three new triterpenoids, designated as acinospesi
            # genin-A (1), -B (2), and -C (3), isolated from the berries of Phytolacca acinosa, have been characteri
            # zed as 3 beta-acetoxy-11 alpha,23-dihydroxytaraxer-14-en-28-oic acid, olean-12-en-23-al-2 beta,3 beta-
            # dihydroxy-30-methoxycarbonyl-28-oic acid and olean-12-en-23-al-2 beta,3 beta,11 alpha-trihydroxy-30-me
            # thoxycarbonyl-28-oic acid, respectively. The compounds have shown antiedemic activity (LD(50) 10-15 mg
            # /kg mass) in albino rats.' , 'We examined the effects of six xanthones from the pericarps of mangostee
            # n, Garcinia mangostana, on the cell growth inhibition of human leukemia cell line HL60. All xanthones
            # displayed growth inhibitory effects. Among them, alpha-mangostin showed complete inhibition at 10 micr
            # oM through the induction of apoptosis.' , 'Three new phenolic compounds (1-3), along with five known p
            # henolics, 4'-hydroxy-2'-methoxychalcone (4), latinone (5), dalbergiphenol (6), 7-hydroxyflavanone, and
            #  dalbergin (7), have been isolated from the stems of Dalbergia cochinchinensis. The structures of 1-3
            # were established by spectroscopic techniques including 1D and 2D NMR methods. The inhibitory activity
            # against testosterone 5 alpha-reductase, which causes androgen-dependent diseases, was also examined fo
            # r selected compounds.'
            'authors': DefaultMappings.PREF_NAME,
            # EXAMPLES:
            # 'Su BN, Park EJ, Nikolic D, Schunke Vigo J, Graham JG, Cabieses F, van Breemen RB, Fong HH, Farnsworth
            #  NR, Pezzuto JM, Kinghorn AD' , 'Shu YZ, Ye Q, Kolb JM, Huang S, Veitch JA, Lowe SE, Manly SP' , 'Hall
            # ock YF, Manfredi KP, Dai JR, Cardellina JH, Gulakowski RJ, McMahon JB, Schäffer M, Stahl M, Gulden KP,
            #  Bringmann G, François G, Boyd MR' , 'Wang H, Gloer KB, Gloer JB, Scott JA, Malloch D' , 'Chen KS, Wu
            # YC, Teng CM, Ko FN, Wu TS' , 'Shao Y, Ho CT, Chin CK, Poobrasert O, Yang SW, Cordell GA' , 'Koul S, Ra
            # zdan TK, Andotra CS' , 'Matsumoto K, Akao Y, Kobayashi E, Ohguchi K, Ito T, Tanaka T, Iinuma M, Nozawa
            #  Y' , 'Shirota O, Pathak V, Sekita S, Satake M, Nagashima Y, Hirayama Y, Hakamata Y, Hayashi T' , 'Oku
            #  N, Matsunaga S, van Soest RW, Fusetani N'
            'doc_type': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLI
            # CATION' , 'PUBLICATION' , 'PUBLICATION' , 'PUBLICATION'
            'document_chembl_id': DefaultMappings.CHEMBL_ID,
            # EXAMPLES:
            # 'CHEMBL1146572' , 'CHEMBL1146432' , 'CHEMBL1146433' , 'CHEMBL1146434' , 'CHEMBL1146435' , 'CHEMBL11464
            # 36' , 'CHEMBL1146437' , 'CHEMBL1146580' , 'CHEMBL1146581' , 'CHEMBL1146582'
            'doi': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # '10.1021/np970050q' , '10.1021/np970054v' , '10.1021/np9700679' , '10.1021/np970071k' , '10.1021/np970
            # 0735' , '10.1021/np970080t' , '10.1021/np970165u' , '10.1021/np970183b' , '10.1021/np970196p' , '10.10
            # 21/jm048999e'
            'first_page': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # '1089' , '814' , '529' , '677' , '629' , '645' , '743' , '1121' , '1124' , '1128'
            'issue': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # '8' , '8' , '5' , '7' , '6' , '6' , '7' , '8' , '8' , '8'
            'journal': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'J. Nat. Pro
            # d.' , 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'J. Nat. Prod.' , 'J. Nat. Prod.'
            'journal_full_title': DefaultMappings.TEXT_STD,
            # EXAMPLES:
            # 'Journal of medicinal chemistry.' , 'Journal of medicinal chemistry.' , 'Journal of medicinal chemistr
            # y.' , 'Journal of medicinal chemistry.' , 'Journal of medicinal chemistry.' , 'Journal of medicinal ch
            # emistry.' , 'Journal of medicinal chemistry.' , 'Journal of medicinal chemistry.' , 'Journal of medici
            # nal chemistry.' , 'Journal of medicinal chemistry.'
            'last_page': DefaultMappings.KEYWORD,
            # EXAMPLES:
            # '1093' , '816' , '532' , '683' , '631' , '647' , '746' , '1123' , '1127' , '1131'
            'patent_id': DefaultMappings.ID_REF,
            # EXAMPLES:
            # 'US-20130089624-A1' , 'US-20130102619-A1' , 'US-8470800-B2' , 'US-8470816-B2' , 'US-8470820-B2' , 'US-
            # 8470825-B2' , 'US-8470835-B2' , 'US-8470836-B2' , 'US-8470837-B2' , 'US-8470841-B2'
            'pubmed_id': DefaultMappings.ID_REF,
            # EXAMPLES:
            # '12932130' , '9170296' , '9249970' , '9214737' , '9214740' , '9249983' , '12932140' , '12932141' , '12
            # 932142' , '12932144'
            'src_id': DefaultMappings.ID_REF,
            # EXAMPLES:
            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            'title': DefaultMappings.TITLE,
            # EXAMPLES:
            # 'Isolation and characterization of miscellaneous secondary metabolites of Deprea subtriflora.' , 'Brip
            # iodionen, a new inhibitor of human cytomegalovirus protease from Streptomyces sp. WC76599.' , 'Michell
            # amines D-F, new HIV-inhibitory dimeric naphthylisoquinoline alkaloids, and korupensamine E, a new anti
            # malarial monomer, from Ancistrocladus korupensis.' , 'Anserinones A and B: new antifungal and antibact
            # erial benzoquinones from the coprophilous fungus Podospora anserina.' , 'Bioactive alkaloids from Illi
            # gera luzonensis.' , 'Asterlingulatosides C and D, cytotoxic triterpenoid saponins from Aster lingulatu
            # s.' , 'Acinospesigenin-A, -B, and -C: three new triterpenoids from Phytolacca acinosa.' , 'Induction o
            # f apoptosis by xanthones from mangosteen in human leukemia cell lines.' , 'Phenolic constituents from
            # Dalbergia cochinchinensis.' , 'Renieramycin J, a highly cytotoxic tetrahydroisoquinoline alkaloid, fro
            # m a marine sponge Neopetrosia sp..'
            'volume': DefaultMappings.INTEGER,
            # EXAMPLES:
            # '66' , '60' , '60' , '60' , '60' , '60' , '60' , '66' , '66' , '66'
            'year': DefaultMappings.SHORT,
            # EXAMPLES:
            # '2003' , '1997' , '1997' , '1997' , '1997' , '1997' , '1997' , '2003' , '2003' , '2003'
        }
    }

autocomplete_settings = {
    'abstract': 60,
    'authors': 100,
    'document_chembl_id': 10,
    'doi': 10,
    'patent_id': 10,
    'pubmed_id': 10,
    'title': 100,
    'year': 1
}

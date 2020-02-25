# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings
import glados.es.ws2es.mappings.es_chembl_molecule_n_drug_shared_mapping as molecule_n_drug_mapping

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 0

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        '_doc':
        {
            'properties': 
            {
                'applicants': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Lilly' , 'Arpida Ag' , 'Takeda Pharmaceuticals Usa Inc' , 'Eisai Inc' , 'Mission Pharmacal Co' , 'Ist
                # ituto Chemioterapico Italiano, Italy' , 'Janssen Pharmaceutica, Belgium' , 'Hoffmann-Laroche' , 'Hoffm
                # ann-Laroche' , 'Ranbaxy Laboratories Inc'
                'atc_classification': 
                {
                    'properties': 
                    {
                        'code': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # 'J01EA03' , 'N05CH02' , 'A02BC04' , 'J01XD02' , 'G01AF13' , 'C01DX11' , 'D01AC09' , 'N05CF01' 
                        # , 'A16AX01' , 'R06AX18'
                        'description': DefaultMappings.TEXT_STD,
                        # EXAMPLES:
                        # 'Antiinfectives For Systemic Use:Antibacterials For Systemic Use:Sulfonamides And Trimethoprim
                        # :Trimethoprim and derivatives' , 'Nervous System:Psycholeptics:Hypnotics And Sedatives:Melaton
                        # in receptor agonists' , 'Alimentary Tract And Metabolism:Drugs For Acid Related Disorders:Drug
                        # s For Peptic Ulcer And Gastro-Oesophageal Reflux Disease (Gord):Proton pump inhibitors' , 'Ant
                        # iinfectives For Systemic Use:Antibacterials For Systemic Use:Other Antibacterials:Imidazole de
                        # rivatives' , 'Genito Urinary System And Sex Hormones:Gynecological Antiinfectives And Antisept
                        # ics:Antiinfectives And Antiseptics, Excl. Combinations:Imidazole derivatives' , 'Cardiovascula
                        # r System:Cardiac Therapy:Vasodilators Used In Cardiac Diseases:Other vasodilators used in card
                        # iac diseases' , 'Dermatologicals:Antifungals For Dermatological Use:Antifungals For Topical Us
                        # e:Imidazole and triazole derivatives' , 'Nervous System:Psycholeptics:Hypnotics And Sedatives:
                        # Benzodiazepine related drugs' , 'Alimentary Tract And Metabolism:Other Alimentary Tract And Me
                        # tabolism Products:Other Alimentary Tract And Metabolism Products:Various alimentary tract and 
                        # metabolism products' , 'Respiratory System:Antihistamines For Systemic Use:Antihistamines For 
                        # Systemic Use:Other antihistamines for systemic use'
                    }
                },
                'availability_type': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '-1' , '1' , '1' , '-2' , '1' , '1'
                'biotherapeutic': molecule_n_drug_mapping.biotherapeutic,
                'black_box': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'True' , 'False' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False'
                'chirality': DefaultMappings.SHORT,
                # EXAMPLES:
                # '0' , '0' , '0' , '1' , '2' , '1' , '2' , '0' , '1' , '2'
                'development_phase': DefaultMappings.SHORT,
                # EXAMPLES:
                # '0' , '2' , '3' , '4' , '0' , '0' , '1' , '4' , '0' , '4'
                'drug_type': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '7' , '1'
                'first_approval': DefaultMappings.SHORT,
                # EXAMPLES:
                # '2005' , '1999' , '2004' , '1985' , '1994' , '2009' , '1960' , '1999' , '2014' , '1975'
                'first_in_class': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'helm_notation': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'PEPTIDE1{[ac].S.Y.S.M.E.H.F.R.W.G.K.P.V.[am]}$$$$' , 'PEPTIDE1{H.S.Q.G.T.F.T.S.D.Y.S.K.Y.L.D.S.R.R.A.
                # Q.D.F.V.Q.W.L.M.N.T}$$$$' , 'PEPTIDE1{[Glp].W.P.R.P.Q.I.P.P}$$$$' , 'PEPTIDE1{[meL].[meV].[X1670].[Abu
                # ].[Sar].[meL].V.[meL].A.[dA].[meL]}$PEPTIDE1,PEPTIDE1,11:R2-1:R1$$$' , 'PEPTIDE1{[X1670].[Abu].[Sar].[
                # meL].V.[meL].A.[X1816].[meL].[meL].[meV]}$PEPTIDE1,PEPTIDE1,11:R2-1:R1$$$' , 'PEPTIDE1{[Sar].R.V.Y.V.H
                # .P.A}$$$$' , 'PEPTIDE1{[Aib].H.[dNal].[dF].K.[am]}$$$$' , 'PEPTIDE1{N.R.V.Y.V.H.P.F}$$$$' , 'PEPTIDE1{
                # [Glp].H.W.S.Y.G.L.R.P.G.[am]}$$$$' , 'PEPTIDE1{[meA].Y.[dW].K.V.F}$PEPTIDE1,PEPTIDE1,6:R2-1:R1$$$'
                'indication_class': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Suppressant (inflammatory bowel disease)' , 'Aerosol Propellant' , 'Aerosol Propellant' , 'Anti-Ulcer
                # ative; Gastric Acid Pump Inhibitor' , 'Antiprotozoal' , 'Antiprotozoal' , 'Antiprotozoal' , 'Antiproto
                # zoal (histomonas)' , 'Anti-Allergic' , 'Antifungal'
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID,
                # EXAMPLES:
                # 'CHEMBL132991' , 'CHEMBL337612' , 'CHEMBL134561' , 'CHEMBL1218' , 'CHEMBL135416' , 'CHEMBL132468' , 'C
                # HEMBL134702' , 'CHEMBL1219' , 'CHEMBL435191' , 'CHEMBL1220'
                'molecule_properties': molecule_n_drug_mapping.molecule_properties,
                'molecule_structures': molecule_n_drug_mapping.molecule_structures,
                'molecule_synonyms': molecule_n_drug_mapping.molecule_synonyms,
                'ob_patent': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '6034239' , '5753677' , '5763483' , '6503745' , '5674895' , '6534070' , '6653286' , '5925730' , '58439
                # 01' , '8450338'
                'oral': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'False' , 'False' , 'True' , 'True' , 'True' , 'True' , 'False'
                'parenteral': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'True'
                'prodrug': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False' , 'True'
                'research_codes': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'LY-213829' , 'AR-100' , 'TAK-375' , 'LY-307640' , 'PF-804950' , 'CP-12574' , 'R-25831 [As the free ba
                # se]' , 'Ro-71554' , 'Ro-223747000' , 'AR-12008'
                'rule_of_five': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'True' , 'False' , 'True'
                'sc_patent': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'US-6034239-A' , 'US-5753677-A' , 'US-5763483-A' , 'US-6503745-B1' , 'US-5674895-A' , 'US-6534070-B1' 
                # , 'US-6653286-B1' , 'US-5925730-A' , 'US-5843901-A' , 'US-8450338-B2'
                'synonyms': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Tazofelone (INN, USAN)' , 'Dimiracetam (INN)' , 'Iclaprim (INN, USAN)' , 'Ramelteon (FDA, INN, USAN)'
                #  , 'Propane (NF)' , 'Cetefloxacin (INN)' , 'Butane (NF)' , 'Rabeprazole (BAN, INN)' , 'Edotecarin (INN
                # , USAN)' , 'Tinidazole (BAN, FDA, INN, JAN, USAN, USP)'
                'topical': DefaultMappings.BOOLEAN,
                # EXAMPLES:
                # 'False' , 'False' , 'False' , 'True' , 'False' , 'False' , 'False' , 'False' , 'False' , 'False'
                'usan_stem': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '-racetam' , '-prim' , '-melteon' , '-oxacin' , '-prazole' , '-tecarin' , '-nidazole' , '-nidazole' , 
                # '-nidazole' , '-nidazole'
                'usan_stem_definition': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'nootropes (piracetam type)' , 'antibacterials (trimethoprim type)' , 'selective melatonin receptor ag
                # onist' , 'antibacterials (quinolone derivatives)' , 'antiulcer agents (benzimidazole derivatives)' , '
                # antineoplastics (rebeccamycin derivatives)' , 'antiprotozoal substances (metronidazole type)' , 'antip
                # rotozoal substances (metronidazole type)' , 'antiprotozoal substances (metronidazole type)' , 'antipro
                # tozoal substances (metronidazole type)'
                'usan_stem_substem': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '-racetam' , '-prim' , '-melteon' , '-oxacin' , '-prazole' , '-tecarin' , '-nidazole' , '-nidazole' , 
                # '-nidazole' , '-nidazole'
                'usan_year': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1994' , '2008' , '2004' , '1995' , '2005' , '1970' , '1977' , '1974' , '1969' , '1984'
                'withdrawn_class': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Hepatotoxicity' , 'Hepatotoxicity' , 'Gastrotoxicity' , 'Hepatotoxicity' , 'Misuse' , 'Misuse' , 'Mis
                # use' , 'Misuse' , 'Hepatotoxicity' , 'Teratogenicity'
                'withdrawn_country': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'United Kingdom; United States; Germany; France' , 'United Kingdom' , 'European Union' , 'France' , 'G
                # ermany' , 'Germany; France' , 'France' , 'United Kingdom' , 'France' , 'European Union; Canada; Irelan
                # d; Portugal; Australia'
                'withdrawn_reason': DefaultMappings.TEXT_STD,
                # EXAMPLES:
                # 'Blood Dyscrasis; Steven Johnson Syndrome' , 'Hepatotoxicity; Jaundice' , 'Increased risk of abuse or 
                # addiction, intoxication and events related to psychomotor impairment' , 'Hepatotoxicity' , 'Dermatolog
                # ic, Hematologic and Hepatic Reactions' , 'Anaphylaxis' , 'Unspecific Experimental Toxicity' , 'Uveitis
                # ' , 'Necrotic Hepatitis' , 'Hepatotoxicity'
                'withdrawn_year': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1984' , '1968' , '2007' , '1987' , '1988' , '1984' , '1984' , '1990' , '1993' , '1998'
            }
        }
    }

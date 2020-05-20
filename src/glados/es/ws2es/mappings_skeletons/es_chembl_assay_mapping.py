# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 1

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        'properties': 
        {
            '_metadata': 
            {
                'properties': 
                {
                    'assay_generated': 
                    {
                        'properties': 
                        {
                            'confidence_label': 'TEXT',
                            # EXAMPLES:
                            # '0 - Default value - Target unknown or has yet to be assigned' , '8 - Homologous single pr
                            # otein target assigned' , '0 - Default value - Target unknown or has yet to be assigned' , 
                            # '0 - Default value - Target unknown or has yet to be assigned' , '0 - Default value - Targ
                            # et unknown or has yet to be assigned' , '0 - Default value - Target unknown or has yet to 
                            # be assigned' , '0 - Default value - Target unknown or has yet to be assigned' , '0 - Defau
                            # lt value - Target unknown or has yet to be assigned' , '0 - Default value - Target unknown
                            #  or has yet to be assigned' , '8 - Homologous single protein target assigned'
                            'relationship_label': 'TEXT',
                            # EXAMPLES:
                            # 'U - Default value - Target has yet to be curated' , 'H - Homologous protein target assign
                            # ed' , 'U - Default value - Target has yet to be curated' , 'U - Default value - Target has
                            #  yet to be curated' , 'U - Default value - Target has yet to be curated' , 'U - Default va
                            # lue - Target has yet to be curated' , 'U - Default value - Target has yet to be curated' ,
                            #  'U - Default value - Target has yet to be curated' , 'U - Default value - Target has yet 
                            # to be curated' , 'H - Homologous protein target assigned'
                            'type_label': 'TEXT',
                            # EXAMPLES:
                            # 'F - Functional' , 'F - Functional' , 'F - Functional' , 'F - Functional' , 'F - Functiona
                            # l' , 'F - Functional' , 'F - Functional' , 'F - Functional' , 'F - Functional' , 'F - Func
                            # tional'
                        }
                    },
                    'document_data': 
                    {
                        'properties': 
                        {
                            'doi': 'TEXT',
                            # EXAMPLES:
                            # '10.1016/j.bmc.2015.10.015' , '10.1016/j.bmcl.2011.12.065' , '10.1016/j.bmc.2017.10.014' ,
                            #  '10.1021/jm00019a001' , '10.1016/j.bmc.2007.07.039' , '10.1021/jm300673z' , '10.1016/j.ej
                            # mech.2016.10.065' , '10.1021/jm100022r' , '10.1021/jm9601563' , '10.1124/dmd.111.043356'
                            'first_page': 'NUMERIC',
                            # EXAMPLES:
                            # '7189' , '801' , '6404' , '3681' , '7087' , '7163' , '874' , '2666' , '5208' , '734'
                            'journal': 'TEXT',
                            # EXAMPLES:
                            # 'Bioorg. Med. Chem.' , 'Bioorg. Med. Chem. Lett.' , 'Bioorg Med Chem' , 'J. Med. Chem.' , 
                            # 'Bioorg. Med. Chem.' , 'J. Med. Chem.' , 'Eur J Med Chem' , 'J. Med. Chem.' , 'J. Med. Che
                            # m.' , 'Drug Metab. Dispos.'
                            'last_page': 'NUMERIC',
                            # EXAMPLES:
                            # '7198' , '805' , '6411' , '3716' , '7097' , '7172' , '884' , '2670' , '5214' , '741'
                            'pubmed_id': 'NUMERIC',
                            # EXAMPLES:
                            # '26494582' , '22209486' , '29089258' , '7562902' , '17869116' , '22822908' , '27836198' , 
                            # '20184326' , '8978849' , '22238289'
                            'title': 'TEXT',
                            # EXAMPLES:
                            # 'PubChem BioAssay data set' , 'PubChem BioAssay data set' , 'PubChem BioAssay data set' , 
                            # 'PubChem BioAssay data set' , 'PubChem BioAssay data set' , 'PubChem BioAssay data set' , 
                            # 'PubChem BioAssay data set' , 'PubChem BioAssay data set' , 'PubChem BioAssay data set' , 
                            # 'PubChem BioAssay data set'
                            'volume': 'NUMERIC',
                            # EXAMPLES:
                            # '23' , '22' , '25' , '38' , '15' , '55' , '127' , '53' , '39' , '40'
                            'year': 'NUMERIC',
                            # EXAMPLES:
                            # '2015' , '2012' , '2017' , '1995' , '2007' , '2012' , '2017' , '2010' , '1996' , '2012'
                        }
                    },
                    'es_completion': 'TEXT',
                    # EXAMPLES:
                    # '{'weight': 80, 'input': 'PubChem BioAssay. PGC-1a: Gene expression assay to measure PGC-1a target
                    #  levels in C2C12 myotubes, using qPCR, PDK4 Measured in Cell-Based System Using RT-PCR - 2139-06_I
                    # nhibitor_Dose_CherryPick_Activity. (absACnn = the concentration at which the curve crosses thresho
                    # ld nn uM)  (Class of assay: confirmatory) '}' , '{'weight': 10, 'input': 'BAO_0000019'}' , '{'weig
                    # ht': 10, 'input': 'BAO_0000219'}' , '{'weight': 10, 'input': 'BAO_0000019'}' , '{'weight': 80, 'in
                    # put': 'PubChem BioAssay. C2C12 HRAS Target ID Apoptosis Mulitlpe Timepoints Caspase 3/7 Measured i
                    # n Cell-Based System Using Plate Reader - 2156-27_Inhibitor_Dose_DryPowder_Activity. (absACnn = the
                    #  concentration at which the curve crosses threshold nn uM)  (Class of assay: confirmatory) '}' , '
                    # {'weight': 10, 'input': 'BAO_0000219'}' , '{'weight': 10, 'input': 'BAO_0000019'}' , '{'weight': 1
                    # 0, 'input': 'BAO_0000219'}' , '{'weight': 80, 'input': 'PubChem BioAssay. SNB-75 HRAS Target ID Ap
                    # optosis Mulitlpe Timepoints Caspase 3/7 Measured in Cell-Based System Using Plate Reader - 2156-24
                    # _Inhibitor_Dose_DryPowder_Activity. (absACnn = the concentration at which the curve crosses thresh
                    # old nn uM)  (Class of assay: confirmatory) '}' , '{'weight': 10, 'input': 'BAO_0000219'}'
                    'organism_taxonomy': 
                    {
                        'properties': 
                        {
                            'l1': 'TEXT',
                            # EXAMPLES:
                            # 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 
                            # 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes'
                            'l2': 'TEXT',
                            # EXAMPLES:
                            # 'Mammalia' , 'Arthropoda' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia'
                            #  , 'Mammalia' , 'Mammalia' , 'Mammalia'
                            'l3': 'TEXT',
                            # EXAMPLES:
                            # 'Primates' , 'Diptera' , 'Primates' , 'Primates' , 'Primates' , 'Primates' , 'Primates' , 
                            # 'Rodentia' , 'Rodentia' , 'Primates'
                            'oc_id': 'NUMERIC',
                            # EXAMPLES:
                            # '7' , '1106' , '7' , '7' , '7' , '7' , '7' , '46' , '42' , '7'
                            'tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '9606' , '7215' , '9606' , '9606' , '9606' , '9606' , '9606' , '10141' , '10116' , '9606'
                        }
                    },
                    'related_activities': 
                    {
                        'properties': 
                        {
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '11' , '4' , '1' , '2' , '1' , '7' , '42' , '4' , '1' , '1'
                        }
                    },
                    'related_compounds': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL2041086 CHEMBL132530 CHEMBL2041092 CHEMBL2041096 CHEMBL2041087 CHEMBL2041091 CHEMBL
                            # 2041088 CHEMBL2041089 CHEMBL2041084 CHEMBL2041094 CHEMBL53463' , 'CHEMBL2057254 CHEMBL6966
                            #  CHEMBL2057255 CHEMBL2046690' , 'CHEMBL4214782' , 'CHEMBL460574 CHEMBL1160723' , 'CHEMBL39
                            # 4052' , 'CHEMBL2171117 CHEMBL2171120 CHEMBL2171118 CHEMBL2171119 CHEMBL2171116 CHEMBL21711
                            # 14 CHEMBL2171115' , 'CHEMBL4066875 CHEMBL4074589 CHEMBL4092622 CHEMBL1076771 CHEMBL4069301
                            #  CHEMBL4071839 CHEMBL529 CHEMBL4094110 CHEMBL4090027 CHEMBL4102762 CHEMBL4067703 CHEMBL409
                            # 7478 CHEMBL4067582 CHEMBL4079547 CHEMBL4095002 CHEMBL4094217 CHEMBL4102880 CHEMBL4104520 C
                            # HEMBL4085814 CHEMBL4089093 CHEMBL4078485 CHEMBL4105179 CHEMBL4078772 CHEMBL4104807 CHEMBL4
                            # 101294 CHEMBL4084859 CHEMBL4063208 CHEMBL4065000 CHEMBL4094371 CHEMBL4096797 CHEMBL4078600
                            #  CHEMBL4095121 CHEMBL1741 CHEMBL4099009 CHEMBL4079444 CHEMBL4103737 CHEMBL4073467 CHEMBL40
                            # 86625 CHEMBL4087324 CHEMBL4093561 CHEMBL4086455 CHEMBL4067882' , 'CHEMBL1087302 CHEMBL1086
                            # 657 CHEMBL1086656' , 'CHEMBL150105' , 'CHEMBL290916'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '11' , '4' , '1' , '2' , '1' , '7' , '42' , '3' , '1' , '1'
                        }
                    },
                    'related_documents': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3632566' , 'CHEMBL2057161' , 'CHEMBL4177642' , 'CHEMBL1128729' , 'CHEMBL1140485' , 
                            # 'CHEMBL2169796' , 'CHEMBL3994579' , 'CHEMBL1155429' , 'CHEMBL1129059' , 'CHEMBL3526061'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                        }
                    },
                    'related_targets': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL384' , 'CHEMBL4302' , 'CHEMBL612545' , 'CHEMBL5471' , 'CHEMBL376' , 'CHEMBL614335' 
                            # , 'CHEMBL348' , 'CHEMBL376' , 'CHEMBL375' , 'CHEMBL4978'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                        }
                    },
                    'source': 
                    {
                        'properties': 
                        {
                            'src_description': 'TEXT',
                            # EXAMPLES:
                            # 'PubChem BioAssays' , 'PubChem BioAssays' , 'PubChem BioAssays' , 'PubChem BioAssays' , 'P
                            # ubChem BioAssays' , 'PubChem BioAssays' , 'PubChem BioAssays' , 'PubChem BioAssays' , 'Pub
                            # Chem BioAssays' , 'PubChem BioAssays'
                            'src_id': 'NUMERIC',
                            # EXAMPLES:
                            # '7' , '7' , '7' , '7' , '7' , '7' , '7' , '7' , '7' , '7'
                            'src_short_name': 'TEXT',
                            # EXAMPLES:
                            # 'PUBCHEM_BIOASSAY' , 'PUBCHEM_BIOASSAY' , 'PUBCHEM_BIOASSAY' , 'PUBCHEM_BIOASSAY' , 'PUBCH
                            # EM_BIOASSAY' , 'PUBCHEM_BIOASSAY' , 'PUBCHEM_BIOASSAY' , 'PUBCHEM_BIOASSAY' , 'PUBCHEM_BIO
                            # ASSAY' , 'PUBCHEM_BIOASSAY'
                        }
                    }
                }
            },
            'assay_category': 'TEXT',
            # EXAMPLES:
            # 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'con
            # firmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory'
            'assay_cell_type': 'TEXT',
            # EXAMPLES:
            # 'Hepatocyte' , 'CHO' , 'CHO' , 'HEp-2' , 'NIH3T3' , 'HT-29' , 'Caco-2' , 'MDA-MB-468' , 'A549' , 'Keratino
            # cyte'
            'assay_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3214883' , 'CHEMBL3214890' , 'CHEMBL3214942' , 'CHEMBL3215000' , 'CHEMBL3215026' , 'CHEMBL3215057' 
            # , 'CHEMBL3215080' , 'CHEMBL3215111' , 'CHEMBL3215125' , 'CHEMBL3215133'
            'assay_classifications': 
            {
                'properties': 
                {
                    'assay_class_id': 'NUMERIC',
                    # EXAMPLES:
                    # '82' , '115' , '157' , '339' , '91' , '115' , '341' , '87' , '115' , '172'
                    'class_type': 'TEXT',
                    # EXAMPLES:
                    # 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo effic
                    # acy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In viv
                    # o efficacy'
                    'l1': 'TEXT',
                    # EXAMPLES:
                    # 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'CAR
                    # DIOVASCULAR SYSTEM' , 'NERVOUS SYSTEM' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'ANTINEOPL
                    # ASTIC AND IMMUNOMODULATING AGENTS' , 'NERVOUS SYSTEM' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENT
                    # S' , 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'CARDIOVASCULAR SYSTEM'
                    'l2': 'TEXT',
                    # EXAMPLES:
                    # 'Carcinoma Oncology Models' , 'Neoplasm Oncology Models' , 'Cardiovascular Analysis' , 'Anti-Epile
                    # ptic Activity' , 'Melanoma Oncology Models' , 'Neoplasm Oncology Models' , 'Anti-Epileptic Activit
                    # y' , 'Leukemia Oncology Models' , 'Neoplasm Oncology Models' , 'Cardiovascular Safety Pharmacology
                    # '
                    'l3': 'TEXT',
                    # EXAMPLES:
                    # 'Carcinoma' , 'Neoplasms' , 'General Anti-Hypertensive Activity' , 'Electroshock in Mice' , 'Exper
                    # imental Melanoma' , 'Neoplasms' , 'General Anti-Convulsant Activity' , 'General Leukemia' , 'Neopl
                    # asms' , 'Cardiovascular Safety Pharmacology: Mean Blood Pressure or Mean Arteral Blood Pressure'
                    'source': 'TEXT',
                    # EXAMPLES:
                    # 'phenotype' , 'phenotype' , 'phenotype' , 'Hock_2016' , 'phenotype' , 'phenotype' , 'phenotype' , 
                    # 'phenotype' , 'phenotype' , 'Vogel_2013_SafetyPharmacology'
                }
            },
            'assay_organism': 'TEXT',
            # EXAMPLES:
            # 'Homo sapiens' , 'Drosophila' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo 
            # sapiens' , 'Cavia porcellus' , 'Rattus norvegicus' , 'Homo sapiens'
            'assay_parameters': 
            {
                'properties': 
                {
                    'active': 'NUMERIC',
                    # EXAMPLES:
                    # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                    'comments': 'TEXT',
                    # EXAMPLES:
                    # 'Is the measured interaction considered due to direct binding to target?' , 'Is the measured inter
                    # action considered due to direct binding to target?' , 'Is the measured interaction considered due 
                    # to direct binding to target?' , 'Is the measured interaction considered due to direct binding to t
                    # arget?' , 'Is the measured interaction considered due to direct binding to target?' , 'Is the meas
                    # ured interaction considered due to direct binding to target?' , 'Is the measured interaction consi
                    # dered due to direct binding to target?' , 'Is the measured interaction considered due to direct bi
                    # nding to target?' , 'Is the measured interaction considered due to direct binding to target?' , 'I
                    # s the measured interaction considered due to direct binding to target?'
                    'relation': 'TEXT',
                    # EXAMPLES:
                    # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                    'standard_relation': 'TEXT',
                    # EXAMPLES:
                    # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                    'standard_text_value': 'TEXT',
                    # EXAMPLES:
                    # 'Intravenous' , 'Intraperitoneal' , 'Intravenous' , 'Oral' , 'Oral' , 'Intravenous' , 'Intraperito
                    # neal' , 'Oral' , 'Oral' , 'Oral'
                    'standard_type': 'TEXT',
                    # EXAMPLES:
                    # 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                    'standard_type_fixed': 'NUMERIC',
                    # EXAMPLES:
                    # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                    'standard_units': 'TEXT',
                    # EXAMPLES:
                    # 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'm
                    # g.kg-1' , 'mg.kg-1'
                    'standard_value': 'NUMERIC',
                    # EXAMPLES:
                    # '5.0' , '25.0' , '20.0' , '50.0' , '10.0' , '30.0' , '0.05' , '8.0' , '10.0' , '10.0'
                    'text_value': 'TEXT',
                    # EXAMPLES:
                    # 'Intravenous' , 'Intraperitoneal' , 'Intravenous' , 'Oral' , 'Oral' , 'Intravenous' , 'Intraperito
                    # neal' , 'Oral' , 'Oral' , 'Oral'
                    'type': 'TEXT',
                    # EXAMPLES:
                    # 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                    'units': 'TEXT',
                    # EXAMPLES:
                    # 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg'
                    'value': 'NUMERIC',
                    # EXAMPLES:
                    # '5.0' , '25.0' , '20.0' , '50.0' , '10.0' , '30.0' , '0.05' , '8.0' , '10.0' , '10.0'
                }
            },
            'assay_strain': 'TEXT',
            # EXAMPLES:
            # 'Sprague-Dawley' , 'ATCC 27853' , 'isolate HM580' , 'Wistar' , 'Wistar' , 'NCTN9632' , 'ICR-CD1' , 'Wistar
            # ' , 'Swiss' , 'BY4741'
            'assay_subcellular_fraction': 'TEXT',
            # EXAMPLES:
            # 'Proteasome' , 'Cell lysate' , 'Brain membranes' , ' microsome' , 'Microsome' , 'Membrane' , 'microsome' ,
            #  'Microsome' , ' microsome' , 'Microsome'
            'assay_tax_id': 'NUMERIC',
            # EXAMPLES:
            # '9606' , '7215' , '9606' , '9606' , '9606' , '9606' , '9606' , '10141' , '10116' , '9606'
            'assay_test_type': 'TEXT',
            # EXAMPLES:
            # 'In vitro' , 'In vivo' , 'In vivo' , 'In vitro' , 'In vivo' , 'In vivo' , 'In vitro' , 'In vivo' , 'In viv
            # o' , 'In vivo'
            'assay_tissue': 'TEXT',
            # EXAMPLES:
            # 'Cardiac atrium' , 'Cingulate cortex' , 'Serum' , 'Plasma' , 'Hippocampus' , 'Thoracic aorta' , 'Muscle ti
            # ssue' , 'Liver' , 'Intestine' , 'Liver'
            'assay_type': 'TEXT',
            # EXAMPLES:
            # 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F' , 'F'
            'assay_type_description': 'TEXT',
            # EXAMPLES:
            # 'Functional' , 'Functional' , 'Functional' , 'Functional' , 'Functional' , 'Functional' , 'Functional' , '
            # Functional' , 'Functional' , 'Functional'
            'bao_format': 'TEXT',
            # EXAMPLES:
            # 'BAO_0000219' , 'BAO_0000019' , 'BAO_0000219' , 'BAO_0000019' , 'BAO_0000219' , 'BAO_0000219' , 'BAO_00000
            # 19' , 'BAO_0000219' , 'BAO_0000219' , 'BAO_0000219'
            'bao_label': 'TEXT',
            # EXAMPLES:
            # 'cell-based format' , 'assay format' , 'cell-based format' , 'assay format' , 'cell-based format' , 'cell-
            # based format' , 'assay format' , 'cell-based format' , 'cell-based format' , 'cell-based format'
            'cell_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3308022' , 'CHEMBL3308072' , 'CHEMBL3308072' , 'CHEMBL3307694' , 'CHEMBL3307716' , 'CHEMBL3307768' 
            # , 'CHEMBL3307519' , 'CHEMBL3308424' , 'CHEMBL3307651' , 'CHEMBL3307503'
            'confidence_description': 'TEXT',
            # EXAMPLES:
            # 'Default value - Target unknown or has yet to be assigned' , 'Homologous single protein target assigned' ,
            #  'Default value - Target unknown or has yet to be assigned' , 'Default value - Target unknown or has yet t
            # o be assigned' , 'Default value - Target unknown or has yet to be assigned' , 'Default value - Target unkn
            # own or has yet to be assigned' , 'Default value - Target unknown or has yet to be assigned' , 'Default val
            # ue - Target unknown or has yet to be assigned' , 'Default value - Target unknown or has yet to be assigned
            # ' , 'Homologous single protein target assigned'
            'confidence_score': 'NUMERIC',
            # EXAMPLES:
            # '0' , '8' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '8'
            'description': 'TEXT',
            # EXAMPLES:
            # 'PubChem BioAssay. Discovery of Novel Antagonists of Muscarinic Receptor M5: Counterscreen against human M
            # 1.   (Class of assay: confirmatory) ' , 'PubChem BioAssay. Vero 76 Cytoxicity Assay for VEEV Compounds (7)
            # .   (Class of assay: confirmatory) ' , 'PubChem BioAssay. Secondary Screen for Probes of the Flavivirus RN
            # A Guanylyltransferase in Dengue Virus Antiviral Screen.   (Class of assay: confirmatory) ' , 'PubChem BioA
            # ssay. PGC-1a: Effect of activators of PGC-1a acetylation of target gene expression PCK1 in hepatocytes, us
            # ing qPCR Measured in Cell-Based System Using RT-PCR - 2139-04_Activator_Dose_CherryPick_Activity.   (Class
            #  of assay: confirmatory) ' , 'PubChem BioAssay. Discovery of Selective Novel Positive Allosteric Modulator
            # s (PAM) of the Muscarinic Receptor (M5) in CHO cells expressing Rattus Norvegicus M2 receptor.   (Class of
            #  assay: confirmatory) ' , 'PubChem BioAssay. Vero 76 Cytoxicity Assay for VEEV Compounds (5).   (Class of 
            # assay: confirmatory) ' , 'PubChem BioAssay. qHTS for Inhibitors of KCHN2 3.1: Wildtype qHTS.   (Class of a
            # ssay: confirmatory) ' , 'PubChem BioAssay. Discovery of Selective Novel Positive Allosteric Modulators (PA
            # M) of the Muscarinic Receptor (M5) in CHO cells expressing human M3 receptor.   (Class of assay: confirmat
            # ory) ' , 'PubChem BioAssay. Bacterial Growth Inhibition Counterscreen using BacTiter-Glo Measured in Micro
            # organism System Using Plate Reader - 2093-02_Inhibitor_Dose_DryPowder_Activity. (Class of assay: confirmat
            # ory) ' , 'PubChem BioAssay. qHTS for Activators of Human Muscle Isoform Pyruvate Kinase: Extended Characte
            # rization against Liver Pyruvate Kinase Probe 2. (Class of assay: confirmatory) '
            'document_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL1201862' , 'CHEMBL1201862' , 'CHEMBL1201862' , 'CHEMBL1201862' , 'CHEMBL1201862' , 'CHEMBL1201862' 
            # , 'CHEMBL1201862' , 'CHEMBL1201862' , 'CHEMBL1201862' , 'CHEMBL1201862'
            'relationship_description': 'TEXT',
            # EXAMPLES:
            # 'Default value - Target has yet to be curated' , 'Homologous protein target assigned' , 'Default value - T
            # arget has yet to be curated' , 'Default value - Target has yet to be curated' , 'Default value - Target ha
            # s yet to be curated' , 'Default value - Target has yet to be curated' , 'Default value - Target has yet to
            #  be curated' , 'Default value - Target has yet to be curated' , 'Default value - Target has yet to be cura
            # ted' , 'Homologous protein target assigned'
            'relationship_type': 'TEXT',
            # EXAMPLES:
            # 'U' , 'H' , 'U' , 'U' , 'U' , 'U' , 'U' , 'U' , 'U' , 'H'
            'src_assay_id': 'NUMERIC',
            # EXAMPLES:
            # '743468' , '743108' , '743334' , '624450' , '720627' , '720614' , '624071' , '743465' , '720629' , '651929
            # '
            'src_id': 'NUMERIC',
            # EXAMPLES:
            # '7' , '7' , '7' , '7' , '7' , '7' , '7' , '7' , '7' , '7'
            'target_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL612545' , 'CHEMBL216' , 'CHEMBL612545' , 'CHEMBL612545' , 'CHEMBL612545' , 'CHEMBL612545' , 'CHEMBL
            # 612545' , 'CHEMBL612545' , 'CHEMBL612545' , 'CHEMBL309'
            'tissue_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL3638237' , 'CHEMBL3638259' , 'CHEMBL3638229' , 'CHEMBL3559721' , 'CHEMBL3638273' , 'CHEMBL3638215' 
            # , 'CHEMBL3638254' , 'CHEMBL3559723' , 'CHEMBL3638176' , 'CHEMBL3559723'
        }
    }

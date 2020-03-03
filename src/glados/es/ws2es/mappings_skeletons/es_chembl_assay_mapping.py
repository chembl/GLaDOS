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
                        # '{'weight': 30, 'input': 'Aspergillus fumigatus'}' , '{'weight': 30, 'input': 'Staphylococcus 
                        # aureus'}' , '{'weight': 30, 'input': 'Mus musculus'}' , '{'weight': 30, 'input': 'Hepatitis C 
                        # virus (isolate Con1)'}' , '{'weight': 10, 'input': 'BAO_0000218'}' , '{'weight': 10, 'input': 
                        # 'CHEMBL1250528'}' , '{'weight': 30, 'input': 'Mus musculus'}' , '{'weight': 30, 'input': 'Salm
                        # onella enterica subsp. enterica serovar Hadar'}' , '{'weight': 10, 'input': 'CHEMBL1245071'}' 
                        # , '{'weight': 10, 'input': 'BAO_0000357'}'
                    }
                },
                'assay_category': 'TEXT',
                # EXAMPLES:
                # 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory' , 
                # 'confirmatory' , 'confirmatory' , 'confirmatory' , 'confirmatory'
                'assay_cell_type': 'TEXT',
                # EXAMPLES:
                # 'RAW' , 'HB1' , 'HT-29' , 'HT-29' , 'HEK293' , 'HEp-2' , 'CV-1' , 'HT-29' , 'HT-29' , 'HT-29'
                'assay_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1263248' , 'CHEMBL1266962' , 'CHEMBL1274648' , 'CHEMBL1250177' , 'CHEMBL1265014' , 'CHEMBL12511
                # 05' , 'CHEMBL1274416' , 'CHEMBL1247649' , 'CHEMBL1245071' , 'CHEMBL1251106'
                'assay_classifications': 
                {
                    'properties': 
                    {
                        'assay_class_id': 'NUMERIC',
                        # EXAMPLES:
                        # '296' , '296' , '401' , '401' , '115' , '339' , '341' , '341' , '140' , '296'
                        'class_type': 'TEXT',
                        # EXAMPLES:
                        # 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo e
                        # fficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' , 'In vivo efficacy' ,
                        #  'In vivo efficacy'
                        'l1': 'TEXT',
                        # EXAMPLES:
                        # 'MUSCULO-SKELETAL SYSTEM' , 'MUSCULO-SKELETAL SYSTEM' , 'NERVOUS SYSTEM' , 'NERVOUS SYSTEM' , 
                        # 'ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS' , 'NERVOUS SYSTEM' , 'NERVOUS SYSTEM' , 'NERVOUS 
                        # SYSTEM' , 'CARDIOVASCULAR SYSTEM' , 'MUSCULO-SKELETAL SYSTEM'
                        'l2': 'TEXT',
                        # EXAMPLES:
                        # 'Anti-Inflammatory Activity' , 'Anti-Inflammatory Activity' , 'Learning and Memory' , 'Learnin
                        # g and Memory' , 'Neoplasm Oncology Models' , 'Anti-Epileptic Activity' , 'Anti-Epileptic Activ
                        # ity' , 'Anti-Epileptic Activity' , 'Anti-Arrhythmic Activity' , 'Anti-Inflammatory Activity'
                        'l3': 'TEXT',
                        # EXAMPLES:
                        # 'General Anti-Inflammatory Models' , 'General Anti-Inflammatory Models' , 'General Anti-Alzhei
                        # mer Activity' , 'General Anti-Alzheimer Activity' , 'Neoplasms' , 'Electroshock in Mice' , 'Ge
                        # neral Anti-Convulsant Activity' , 'General Anti-Convulsant Activity' , 'General Anti-Arrhythmi
                        # c Activity' , 'General Anti-Inflammatory Models'
                        'source': 'TEXT',
                        # EXAMPLES:
                        # 'phenotype' , 'phenotype' , 'phenotype' , 'phenotype' , 'phenotype' , 'Hock_2016' , 'phenotype
                        # ' , 'phenotype' , 'phenotype' , 'phenotype'
                    }
                },
                'assay_organism': 'TEXT',
                # EXAMPLES:
                # 'Aspergillus fumigatus' , 'Staphylococcus aureus' , 'Mus musculus' , 'Hepatitis C virus (isolate Con1)
                # ' , 'Salmonella enterica subsp. enterica serovar Typhimurium' , 'Mus musculus' , 'Salmonella enterica 
                # subsp. enterica serovar Hadar' , 'Hepatitis C virus' , 'Homo sapiens' , 'Staphylococcus aureus'
                'assay_parameters': 
                {
                    'properties': 
                    {
                        'active': 'NUMERIC',
                        # EXAMPLES:
                        # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                        'comments': 'TEXT',
                        # EXAMPLES:
                        # '+/- 0.0000033 (Mca-RPKPVE-Nval-WRK(Dnp)-NH2; ES002 from R&D Systems)' , '+/- 0.0000033 (Mca-R
                        # PKPVE-Nval-WRK(Dnp)-NH2; ES002 from R&D Systems)' , 'Is the measured interaction considered du
                        # e to direct binding to target?' , 'Is the measured interaction considered due to direct bindin
                        # g to target?' , 'Is the measured interaction considered due to direct binding to target?' , 'I
                        # s the measured interaction considered due to direct binding to target?' , 'Is the measured int
                        # eraction considered due to direct binding to target?' , 'Is the measured interaction considere
                        # d due to direct binding to target?' , 'Is the measured interaction considered due to direct bi
                        # nding to target?' , 'Is the measured interaction considered due to direct binding to target?'
                        'relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_relation': 'TEXT',
                        # EXAMPLES:
                        # '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '=' , '='
                        'standard_text_value': 'TEXT',
                        # EXAMPLES:
                        # 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Intravenous' , 'Oral' , 'Intravenous' , 'Intrave
                        # nous' , 'Intravenous'
                        'standard_type': 'TEXT',
                        # EXAMPLES:
                        # 'DOSE' , 'DOSE' , 'ROUTE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                        'standard_type_fixed': 'NUMERIC',
                        # EXAMPLES:
                        # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                        'standard_units': 'TEXT',
                        # EXAMPLES:
                        # 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' , 'mg.kg-1' 
                        # , 'mg.kg-1' , 'mg.kg-1'
                        'standard_value': 'NUMERIC',
                        # EXAMPLES:
                        # '5.0' , '5.0' , '100.0' , '100.0' , '5.0' , '30.0' , '5.0' , '5.0' , '5.0' , '5.0'
                        'text_value': 'TEXT',
                        # EXAMPLES:
                        # 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Oral' , 'Intravenous' , 'Oral' , 'Intravenous' , 'Intrave
                        # nous' , 'Intravenous'
                        'type': 'TEXT',
                        # EXAMPLES:
                        # 'DOSE' , 'DOSE' , 'ROUTE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE' , 'DOSE'
                        'units': 'TEXT',
                        # EXAMPLES:
                        # 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/kg' , 'mg/
                        # kg'
                        'value': 'NUMERIC',
                        # EXAMPLES:
                        # '5.0' , '5.0' , '100.0' , '100.0' , '5.0' , '30.0' , '5.0' , '5.0' , '5.0' , '5.0'
                    }
                },
                'assay_strain': 'TEXT',
                # EXAMPLES:
                # '25' , 'ddY' , 'ATCC 14028' , 'ddY' , 'VA5649' , '510' , 'ddY' , 'ddY' , 'ddY' , 'ATCC 14028'
                'assay_subcellular_fraction': 'TEXT',
                # EXAMPLES:
                # 'Membrane' , 'Membrane' , 'Membrane' , 'Mitochondria' , 'Microsome' , 'Microsome' , 'Microsome' , 'Mic
                # rosome' , 'Microsome' , 'Microsome'
                'assay_tax_id': 'NUMERIC',
                # EXAMPLES:
                # '746128' , '1280' , '10090' , '333284' , '90371' , '10090' , '149385' , '11103' , '9606' , '1280'
                'assay_test_type': 'TEXT',
                # EXAMPLES:
                # 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vivo' , 'In vitro' , 'In v
                # ivo' , 'In vivo'
                'assay_tissue': 'TEXT',
                # EXAMPLES:
                # 'Blood' , 'Liver' , 'Kidney' , 'Stomach' , 'Spleen' , 'Heart' , 'Brain' , 'Kidney' , 'Brain' , 'Plasma
                # '
                'assay_type': 'TEXT',
                # EXAMPLES:
                # 'F' , 'B' , 'A' , 'F' , 'F' , 'B' , 'A' , 'F' , 'F' , 'B'
                'assay_type_description': 'TEXT',
                # EXAMPLES:
                # 'Functional' , 'Binding' , 'ADME' , 'Functional' , 'Functional' , 'Binding' , 'ADME' , 'Functional' , 
                # 'Functional' , 'Binding'
                'bao_format': 'TEXT',
                # EXAMPLES:
                # 'BAO_0000218' , 'BAO_0000019' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000218' , 'BAO_0000019' , 'BAO_0
                # 000218' , 'BAO_0000019' , 'BAO_0000218' , 'BAO_0000357'
                'bao_label': 'TEXT',
                # EXAMPLES:
                # 'organism-based format' , 'assay format' , 'organism-based format' , 'organism-based format' , 'organi
                # sm-based format' , 'assay format' , 'organism-based format' , 'assay format' , 'organism-based format'
                #  , 'single protein format'
                'cell_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3307413' , 'CHEMBL3307768' , 'CHEMBL3307768' , 'CHEMBL3307715' , 'CHEMBL3307694' , 'CHEMBL33080
                # 33' , 'CHEMBL3307768' , 'CHEMBL3307768' , 'CHEMBL3307768' , 'CHEMBL3307768'
                'confidence_description': 'TEXT',
                # EXAMPLES:
                # 'Target assigned is non-molecular' , 'Default value - Target unknown or has yet to be assigned' , 'Tar
                # get assigned is non-molecular' , 'Target assigned is non-molecular' , 'Target assigned is non-molecula
                # r' , 'Default value - Target unknown or has yet to be assigned' , 'Target assigned is non-molecular' ,
                #  'Target assigned is non-molecular' , 'Target assigned is non-molecular' , 'Direct single protein targ
                # et assigned'
                'confidence_score': 'NUMERIC',
                # EXAMPLES:
                # '1' , '0' , '1' , '1' , '1' , '0' , '1' , '1' , '1' , '9'
                'description': 'TEXT',
                # EXAMPLES:
                # 'Antimicrobial activity against itraconazole-susceptible Aspergillus fumigatus clinical isolate expres
                # sing cyp51A F46Y, G89G, M172V, N248T, D255E, E427K mutant gene by CLSI method' , 'Binding affinity to 
                # against methicillin-, daptomycin-resistant, vancomycin-intermediate, beta-lactamase-positive Staphyloc
                # occus aureus 25 PBP2 by competitive binding assay' , 'Biodistribution in ddY mouse blood assessed per 
                # gram of tissue at 14.8 kBq, iv after 180 mins' , 'Antiviral activity against Hepatitis C virus (isolat
                # e Con1) genotype 1b in human Huh-7/3-1 replicon cells assessed as inhibition of [14C]sphingomyelin syn
                # thesis after 48 hrs by TLC' , 'Antibacterial activity against Salmonella enterica serovars Typhimurium
                #  ATCC 14028 at pH 7.0 by broth dilution method' , 'Selectivity ratio of p38alpha over nonreceptor tyro
                # sine kinase' , 'Biodistribution in ddY mouse liver assessed per gram of tissue at 14.8 kBq, iv after 1
                # 80 mins' , 'Antibacterial activity against Salmonella enterica serovar Hadar VA5649 harboring wild typ
                # e ramR-2313 gene by Etest method' , 'Antiviral activity against Hepatitis C virus containing NS3/A156T
                #  protease mutant activity by TaqMan-based assay' , 'Inhibition of human ERG at 30 uM'
                'document_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1255497' , 'CHEMBL1255453' , 'CHEMBL1268917' , 'CHEMBL1240304' , 'CHEMBL1255258' , 'CHEMBL12505
                # 28' , 'CHEMBL1268917' , 'CHEMBL1240379' , 'CHEMBL1240347' , 'CHEMBL1250528'
                'relationship_description': 'TEXT',
                # EXAMPLES:
                # 'Non-molecular target assigned' , 'Default value - Target has yet to be curated' , 'Non-molecular targ
                # et assigned' , 'Non-molecular target assigned' , 'Non-molecular target assigned' , 'Default value - Ta
                # rget has yet to be curated' , 'Non-molecular target assigned' , 'Non-molecular target assigned' , 'Non
                # -molecular target assigned' , 'Direct protein target assigned'
                'relationship_type': 'TEXT',
                # EXAMPLES:
                # 'N' , 'U' , 'N' , 'N' , 'N' , 'U' , 'N' , 'N' , 'N' , 'D'
                'src_assay_id': 'NUMERIC',
                # EXAMPLES:
                # '937' , '1898' , '1278' , '463086' , '924' , '1259' , '2195' , '2763' , '994' , '992'
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL363' , 'CHEMBL612545' , 'CHEMBL613561' , 'CHEMBL379' , 'CHEMBL351' , 'CHEMBL612545' , 'CHEMBL61
                # 3580' , 'CHEMBL3879801' , 'CHEMBL379' , 'CHEMBL240'
                'tissue_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3638178' , 'CHEMBL3559723' , 'CHEMBL3638241' , 'CHEMBL3638185' , 'CHEMBL3559722' , 'CHEMBL36381
                # 87' , 'CHEMBL3638188' , 'CHEMBL3638241' , 'CHEMBL3638188' , 'CHEMBL3559721'
            }
        }
    }

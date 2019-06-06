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
                'in_training': DefaultMappings.SHORT,
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0' , '0'
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL15891' , 'CHEMBL15891' , 'CHEMBL15891' , 'CHEMBL15891' , 'CHEMBL15891' , 'CHEMBL15891' , 'CHEMB
                # L15891' , 'CHEMBL15891' , 'CHEMBL15891' , 'CHEMBL15891'
                'pred_id': DefaultMappings.ID,
                # EXAMPLES:
                # '19001' , '19002' , '19003' , '19004' , '19006' , '19008' , '19009' , '19014' , '19015' , '19016'
                'probability': DefaultMappings.DOUBLE,
                # EXAMPLES:
                # '0.1961454787' , '0.0588913683' , '0.05630587749' , '0.04249338511' , '0.02712702823' , '0.02488420079
                # ' , '0.02411605722' , '0.01553038193' , '0.01423059225' , '0.01398440636'
                'target_accession': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'P35372' , 'P41145' , 'P41143' , 'Q9JI35' , 'P33535' , 'P51450' , 'P00811' , 'P10636' , 'Q16790' , 'P4
                # 3235'
                'target_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL233' , 'CHEMBL237' , 'CHEMBL236' , 'CHEMBL5076' , 'CHEMBL270' , 'CHEMBL1293231' , 'CHEMBL2026' 
                # , 'CHEMBL1293224' , 'CHEMBL3594' , 'CHEMBL268'
                'target_organism': DefaultMappings.LOWER_CASE_KEYWORD,
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Cavia porcellus' , 'Rattus norvegicus' , 'Mus musc
                # ulus' , 'Escherichia coli K-12' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens'
                'target_pref_name': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # 'Dopamine D3 receptor' , 'Hepatocyte growth factor receptor' , 'cAMP and cAMP-inhibited cGMP 3',5'-cyc
                # lic phosphodiesterase 10A' , 'MAP kinase-activated protein kinase 5' , 'Plasma retinol-binding protein
                # ' , 'DNA polymerase beta' , 'Beta-lactamase AmpC' , 'Hypoxia-inducible factor 1 alpha' , 'C-C chemokin
                # e receptor type 5' , 'Mu opioid receptor'
                'target_tax_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '9606' , '9606' , '9606' , '10141' , '10116' , '10090' , '83333' , '9606' , '9606' , '9606'
                'value': DefaultMappings.SHORT,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            }
        }
    }

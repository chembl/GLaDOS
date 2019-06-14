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
                'in_training': 'NUMERIC',
                # EXAMPLES:
                # '0' , '0' , '0' , '0' , '0' , '0' , '0' , '1' , '0' , '0'
                'molecule_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL12531' , 'CHEMBL417' , 'CHEMBL275803' , 'CHEMBL55' , 'CHEMBL465' , 'CHEMBL10316' , 'CHEMBL27580
                # 3' , 'CHEMBL419' , 'CHEMBL36' , 'CHEMBL12608'
                'pred_id': 'NUMERIC',
                # EXAMPLES:
                # '12444' , '2166' , '12709' , '6898' , '7313' , '9984' , '12711' , '2319' , '3974' , '12862'
                'probability': 'NUMERIC',
                # EXAMPLES:
                # '0.00001300407' , '0.00003160697' , '0.10625828539' , '0.00060562871' , '0.20662705953' , '0.005792153
                # ' , '0.05108572522' , '0.99933357954' , '0.00414883273' , '0.24422970916'
                'target_accession': 'TEXT',
                # EXAMPLES:
                # 'P09619' , 'Q9H0K1' , 'P33261' , 'Q16853' , 'Q9NUW8' , 'P61169' , 'P08684' , 'Q99N23' , 'O00329' , 'P1
                # 0635'
                'target_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL1913' , 'CHEMBL5699' , 'CHEMBL3622' , 'CHEMBL3437' , 'CHEMBL1075138' , 'CHEMBL339' , 'CHEMBL340
                # ' , 'CHEMBL5973' , 'CHEMBL3130' , 'CHEMBL289'
                'target_organism': 'TEXT',
                # EXAMPLES:
                # 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Homo sapiens' , 'Rattus norvegicu
                # s' , 'Homo sapiens' , 'Mus musculus' , 'Homo sapiens' , 'Homo sapiens'
                'target_tax_id': 'NUMERIC',
                # EXAMPLES:
                # '9606' , '9606' , '9606' , '9606' , '9606' , '10116' , '9606' , '10090' , '9606' , '9606'
                'value': 'NUMERIC',
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            }
        }
    }

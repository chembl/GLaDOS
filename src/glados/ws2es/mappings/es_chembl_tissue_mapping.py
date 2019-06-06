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
                '_metadata':
                {
                    'properties':
                    {
                        'es_completion': DefaultMappings.COMPLETION_TYPE
                    }
                },
                'bto_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'BTO:0001073' , 'BTO:0000784' , 'BTO:0000648' , 'BTO:0000068' , 'BTO:0000089' , 'BTO:0000503' , 'BTO:0
                # 000928' , 'BTO:0001167' , 'BTO:0001376' , 'BTO:0001363'
                'caloha_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'TS-0798' , 'TS-0579' , 'TS-0490' , 'TS-0034' , 'TS-0079' , 'TS-1307' , 'TS-1157' , 'TS-2039' , 'TS-10
                # 30' , 'TS-0980'
                'efo_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'UBERON:0001897' , 'UBERON:0001969' , 'UBERON:0002106' , 'UBERON:0002107' , 'UBERON:0000956' , 'UBERON
                # :0000007' , 'UBERON:0000014' , 'UBERON:0000029' , 'UBERON:0000160' , 'UBERON:0000178'
                'pref_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'Thalamus' , 'Plasma' , 'Spleen' , 'Liver' , 'Cerebral cortex' , 'Pituitary gland' , 'Zone of skin' , 
                # 'Lymph node' , 'Intestine' , 'Amniotic fluid'
                'tissue_chembl_id': DefaultMappings.CHEMBL_ID,
                # EXAMPLES:
                # 'CHEMBL3638280' , 'CHEMBL3559721' , 'CHEMBL3559722' , 'CHEMBL3559723' , 'CHEMBL3559724' , 'CHEMBL36381
                # 73' , 'CHEMBL3638174' , 'CHEMBL3638175' , 'CHEMBL3638176' , 'CHEMBL3638177'
                'uberon_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # 'UBERON:0001969' , 'UBERON:0002106' , 'UBERON:0002107' , 'UBERON:0000956' , 'UBERON:0000007' , 'UBERON
                # :0000014' , 'UBERON:0000029' , 'UBERON:0000160' , 'UBERON:0000173' , 'UBERON:0000178'
            }
        }
    }

autocomplete_settings = {
    'bto_id': 10,
    'caloha_id': 10,
    'efo_id': 10,
    'pref_name': 100,
    'tissue_chembl_id': 10,
    'uberon_id': 10
}

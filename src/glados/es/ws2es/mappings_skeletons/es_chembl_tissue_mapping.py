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
                        # '{'weight': 10, 'input': 'UBERON:0000002'}' , '{'weight': 10, 'input': 'UBERON:0000004'}' , '{
                        # 'weight': 10, 'input': 'CHEMBL4296343'}' , '{'weight': 100, 'input': 'Pituitary gland'}' , '{'
                        # weight': 10, 'input': 'CHEMBL3987982'}' , '{'weight': 10, 'input': 'CHEMBL3638174'}' , '{'weig
                        # ht': 100, 'input': 'Wing'}' , '{'weight': 10, 'input': 'UBERON:0000025'}' , '{'weight': 10, 'i
                        # nput': 'CHEMBL3638175'}' , '{'weight': 100, 'input': 'Lamina propria'}'
                    }
                },
                'bto_id': 'TEXT',
                # EXAMPLES:
                # 'BTO:0001073' , 'BTO:0000784' , 'BTO:0000648' , 'BTO:0000068' , 'BTO:0000089' , 'BTO:0000503' , 'BTO:0
                # 000928' , 'BTO:0001167' , 'BTO:0001376' , 'BTO:0001363'
                'caloha_id': 'TEXT',
                # EXAMPLES:
                # 'TS-0798' , 'TS-0579' , 'TS-0490' , 'TS-0034' , 'TS-0079' , 'TS-1307' , 'TS-1157' , 'TS-2039' , 'TS-10
                # 30' , 'TS-0980'
                'efo_id': 'TEXT',
                # EXAMPLES:
                # 'UBERON:0000007' , 'UBERON:0000014' , 'UBERON:0000029' , 'UBERON:0000160' , 'UBERON:0000178' , 'UBERON
                # :0000362' , 'EFO:0001943' , 'UBERON:0000473' , 'UBERON:0000945' , 'UBERON:0000947'
                'pref_name': 'TEXT',
                # EXAMPLES:
                # 'Uterine cervix' , 'Nose' , 'Islets of langerhans' , 'Pituitary gland' , 'Submucosa' , 'Zone of skin' 
                # , 'Wing' , 'Tube' , 'Lymph node' , 'Lamina propria'
                'tissue_chembl_id': 'TEXT',
                # EXAMPLES:
                # 'CHEMBL3988026' , 'CHEMBL3987869' , 'CHEMBL4296343' , 'CHEMBL3638173' , 'CHEMBL3987982' , 'CHEMBL36381
                # 74' , 'CHEMBL3988049' , 'CHEMBL3988015' , 'CHEMBL3638175' , 'CHEMBL3987795'
                'uberon_id': 'TEXT',
                # EXAMPLES:
                # 'UBERON:0000002' , 'UBERON:0000004' , 'UBERON:0000006' , 'UBERON:0000007' , 'UBERON:0000009' , 'UBERON
                # :0000014' , 'UBERON:0000023' , 'UBERON:0000025' , 'UBERON:0000029' , 'UBERON:0000030'
            }
        }
    }

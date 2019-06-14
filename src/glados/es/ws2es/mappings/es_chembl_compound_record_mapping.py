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
                'compound_key': DefaultMappings.KEYWORD,
                # EXAMPLES:
                # '48' , '43' , '42' , '40' , '39' , '38' , '36' , '32' , '30' , '5-iodo-2'-deoxyuridine'
                'compound_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # '2-(2-Phenanthren-9-yl-1H-imidazol-4-yl)-ethylamine' , '2-[2-(3-Trifluoromethyl-benzyl)-1H-imidazol-4-
                # yl]-ethylamine' , '2-[2-(2-Trifluoromethyl-benzyl)-1H-imidazol-4-yl]-ethylamine' , '2-[2-(4-Trifluorom
                # ethyl-phenyl)-1H-imidazol-4-yl]-ethylamine' , '2-[2-(3-Trifluoromethyl-phenyl)-1H-imidazol-4-yl]-ethyl
                # amine' , '2-[2-(2-Trifluoromethyl-phenyl)-1H-imidazol-4-yl]-ethylamine' , '2-[2-(3-Iodo-phenyl)-1H-imi
                # dazol-4-yl]-ethylamine' , '2-(2-Thiophen-3-ylmethyl-1H-imidazol-4-yl)-ethylamine' , '2-[2-(5-Bromo-thi
                # ophen-3-yl)-1H-imidazol-4-yl]-ethylamine' , '1-(4-Hydroxy-5-hydroxymethyl-tetrahydro-furan-2-yl)-5-iod
                'document_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL1128295' , 'CHEMBL1128295' , 'CHEMBL1128295' , 'CHEMBL1128295' , 'CHEMBL1128295' , 'CHEMBL11282
                # 95' , 'CHEMBL1128295' , 'CHEMBL1128295' , 'CHEMBL1128295' , 'CHEMBL1124493'
                'molecule_chembl_id': DefaultMappings.CHEMBL_ID_REF,
                # EXAMPLES:
                # 'CHEMBL23269' , 'CHEMBL24709' , 'CHEMBL23687' , 'CHEMBL23359' , 'CHEMBL24665' , 'CHEMBL26110' , 'CHEMB
                # L287367' , 'CHEMBL24378' , 'CHEMBL24346' , 'CHEMBL788'
                'record_id': DefaultMappings.ID,
                # EXAMPLES:
                # '33541' , '33546' , '33547' , '33549' , '33550' , '33551' , '33552' , '33554' , '33555' , '33559'
                'src_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1'
            }
        }
    }

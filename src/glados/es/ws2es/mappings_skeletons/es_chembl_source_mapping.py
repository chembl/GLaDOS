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
                'src_description': 'TEXT',
                # EXAMPLES:
                # 'Undefined' , 'Scientific Literature' , 'GSK Malaria Screening' , 'Novartis Malaria Screening' , 'St J
                # ude Malaria Screening' , 'Sanger Institute Genomics of Drug Sensitivity in Cancer' , 'PDBe Ligands' , 
                # 'PubChem BioAssays' , 'Clinical Candidates' , 'Orange Book'
                'src_id': 'NUMERIC',
                # EXAMPLES:
                # '0' , '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9'
                'src_short_name': 'TEXT',
                # EXAMPLES:
                # 'UNDEFINED' , 'LITERATURE' , 'GSK_TCMDC' , 'NOVARTIS' , 'ST_JUDE' , 'SANGER' , 'PDBE' , 'PUBCHEM_BIOAS
                # SAY' , 'CANDIDATES' , 'ORANGE_BOOK'
            }
        }
    }

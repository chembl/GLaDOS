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
                'l1': 'TEXT',
                # EXAMPLES:
                # 'Viruses' , 'Eukaryotes' , 'Viruses' , 'Bacteria' , 'Viruses' , 'Eukaryotes' , 'Viruses' , 'Eukaryotes
                # ' , 'Viruses' , 'Fungi'
                'l2': 'TEXT',
                # EXAMPLES:
                # 'ssRNA' , 'Viridiplantae' , 'ssRNA' , 'Gram-Negative' , 'ssRNA' , 'Arthropoda' , 'ssRNA' , 'Arthropoda
                # ' , 'ssRNA' , 'Ascomycota'
                'l3': 'TEXT',
                # EXAMPLES:
                # 'Monocotyledons' , 'Pseudomonas' , 'ssRNA negative-strand viruses' , 'Lepidoptera' , 'Lepidoptera' , '
                # Dothideomycetes' , 'Sordariomycetes' , 'Monocotyledons' , 'ssRNA negative-strand viruses' , 'Eudicotyl
                # edons'
                'l4_synonyms': 'TEXT',
                # EXAMPLES:
                # 'Human rhinovirus B' , 'Human rhinovirus' , 'Influenza virus type A' , 'Influenza A virus (A/Puerto Ri
                # co/8/1934(H0N1))' , 'H5N1 subtype' , 'Influenza A virus (A/Udorn/307/72 (H3N2))' , 'Influenza A virus 
                # (STRAIN X-31)' , 'Influenza virus type B' , 'Influenza B virus (B/Lee/40)' , 'Japanese encephalitis vi
                # rus JEV'
                'oc_id': 'NUMERIC',
                # EXAMPLES:
                # '762' , '3580' , '763' , '3581' , '764' , '3582' , '765' , '3583' , '766' , '3584'
                'tax_id': 'NUMERIC',
                # EXAMPLES:
                # '147712' , '89674' , '169066' , '319' , '11320' , '129554' , '211044' , '82600' , '102793' , '420778'
            }
        }
    }

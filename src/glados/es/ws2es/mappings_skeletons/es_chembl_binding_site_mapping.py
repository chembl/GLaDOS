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
            'site_components': 
            {
                'properties': 
                {
                    'component_id': 'NUMERIC',
                    # EXAMPLES:
                    # '4909' , '5575' , '118' , '397' , '218' , '1835' , '2632' , '873' , '970' , '3106'
                    'domain': 
                    {
                        'properties': 
                        {
                            'domain_id': 'NUMERIC',
                            # EXAMPLES:
                            # '2781' , '2683' , '2922' , '2627' , '2788' , '3719' , '2627' , '2683' , '4003' , '2776'
                            'domain_name': 'TEXT',
                            # EXAMPLES:
                            # 'UDPGT' , 'Pkinase' , 'IMPDH' , '7tm_1' , 'SNF' , 'PAF-AH_p_II' , '7tm_1' , 'Pkinase' , 'P
                            # kinase_Tyr' , 'Carb_anhydrase'
                            'domain_type': 'TEXT',
                            # EXAMPLES:
                            # 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'P
                            # fam-A' , 'Pfam-A'
                            'source_domain_id': 'TEXT',
                            # EXAMPLES:
                            # 'PF00201' , 'PF00069' , 'PF00478' , 'PF00001' , 'PF00209' , 'PF03403' , 'PF00001' , 'PF000
                            # 69' , 'PF07714' , 'PF00194'
                        }
                    },
                    'sitecomp_id': 'NUMERIC',
                    # EXAMPLES:
                    # '4' , '1503' , '1077' , '432' , '654' , '435' , '438' , '226' , '229' , '232'
                }
            },
            'site_id': 'NUMERIC',
            # EXAMPLES:
            # '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '10' , '11'
            'site_name': 'TEXT',
            # EXAMPLES:
            # 'UDP-glucuronosyltransferase 1-10, UDPGT domain' , 'Mitogen-activated protein kinase 8, Pkinase domain' , 
            # 'Inosine-5'-monophosphate dehydrogenase 1, IMPDH domain' , 'Dopamine D1 receptor, 7tm_1 domain' , 'GABA tr
            # ansporter 1, SNF domain' , 'LDL-associated phospholipase A2, PAF-AH_p_II domain' , 'Purinergic receptor P2
            # Y1, 7tm_1 domain' , '3-phosphoinositide dependent protein kinase-1, Pkinase domain' , 'Tyrosine-protein ki
            # nase CSK, Pkinase_Tyr domain' , 'Carbonic anhydrase VA, Carb_anhydrase domain'
        }
    }

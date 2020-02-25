# Elastic search mapping definition for the Molecule entity
from glados.es.ws2es.es_util import DefaultMappings

# Shards size - can be overridden from the default calculated value here
# shards = 3,
replicas = 0

analysis = DefaultMappings.COMMON_ANALYSIS

mappings = \
    {
        '_doc': 
        {
            'properties': 
            {
                'site_components': 
                {
                    'properties': 
                    {
                        'component_id': DefaultMappings.KEYWORD,
                        # EXAMPLES:
                        # '4909' , '5575' , '118' , '397' , '218' , '1835' , '2632' , '873' , '970' , '3106'
                        'domain': 
                        {
                            'properties': 
                            {
                                'domain_id': DefaultMappings.ID_REF,
                                # EXAMPLES:
                                # '2781' , '2683' , '2922' , '2627' , '2788' , '3719' , '2627' , '2683' , '4003' , '2776
                                # '
                                'domain_name': DefaultMappings.KEYWORD,
                                # EXAMPLES:
                                # 'UDPGT' , 'Pkinase' , 'IMPDH' , '7tm_1' , 'SNF' , 'PAF-AH_p_II' , '7tm_1' , 'Pkinase' 
                                # , 'Pkinase_Tyr' , 'Carb_anhydrase'
                                'domain_type': DefaultMappings.KEYWORD,
                                # EXAMPLES:
                                # 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' 
                                # , 'Pfam-A' , 'Pfam-A'
                                'source_domain_id': DefaultMappings.ID_REF,
                                # EXAMPLES:
                                # 'PF00201' , 'PF00069' , 'PF00478' , 'PF00001' , 'PF00209' , 'PF03403' , 'PF00001' , 'P
                                # F00069' , 'PF07714' , 'PF00194'
                            }
                        },
                        'sitecomp_id': DefaultMappings.ID_REF,
                        # EXAMPLES:
                        # '4' , '1503' , '1077' , '432' , '654' , '435' , '438' , '226' , '229' , '232'
                    }
                },
                'site_id': DefaultMappings.ID_REF,
                # EXAMPLES:
                # '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '10' , '11'
                'site_name': DefaultMappings.PREF_NAME,
                # EXAMPLES:
                # 'UDP-glucuronosyltransferase 1-10, UDPGT domain' , 'Mitogen-activated protein kinase 8, Pkinase domain
                # ' , 'Inosine-5'-monophosphate dehydrogenase 1, IMPDH domain' , 'Dopamine D1 receptor, 7tm_1 domain' , 
                # 'GABA transporter 1, SNF domain' , 'LDL-associated phospholipase A2, PAF-AH_p_II domain' , 'Purinergic
                #  receptor P2Y1, 7tm_1 domain' , '3-phosphoinositide dependent protein kinase-1, Pkinase domain' , 'Tyr
                # osine-protein kinase CSK, Pkinase_Tyr domain' , 'Carbonic anhydrase VA, Carb_anhydrase domain'
            }
        }
    }

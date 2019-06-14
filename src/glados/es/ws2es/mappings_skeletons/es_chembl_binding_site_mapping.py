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
                'site_components': 
                {
                    'properties': 
                    {
                        'component_id': 'NUMERIC',
                        # EXAMPLES:
                        # '694' , '26' , '4524' , '1594' , '402' , '3413' , '2389' , '3506' , '3413' , '2389'
                        'domain': 
                        {
                            'properties': 
                            {
                                'domain_id': 'NUMERIC',
                                # EXAMPLES:
                                # '2712' , '3658' , '2683' , '3173' , '2712' , '2951' , '2683' , '2788' , '2951' , '2683
                                # '
                                'domain_name': 'TEXT',
                                # EXAMPLES:
                                # 'Hormone_recep' , 'Neur_chan_LBD' , 'Pkinase' , 'Na_H_Exchanger' , 'Hormone_recep' , '
                                # Ion_trans' , 'Pkinase' , 'SNF' , 'Ion_trans' , 'Pkinase'
                                'domain_type': 'TEXT',
                                # EXAMPLES:
                                # 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' , 'Pfam-A' 
                                # , 'Pfam-A' , 'Pfam-A'
                                'source_domain_id': 'TEXT',
                                # EXAMPLES:
                                # 'PF00104' , 'PF02931' , 'PF00069' , 'PF00999' , 'PF00104' , 'PF00520' , 'PF00069' , 'P
                                # F00209' , 'PF00520' , 'PF00069'
                            }
                        },
                        'sitecomp_id': 'NUMERIC',
                        # EXAMPLES:
                        # '1937' , '12606' , '8933' , '7692' , '8784' , '5283' , '3965' , '835' , '11502' , '7632'
                    }
                },
                'site_id': 'NUMERIC',
                # EXAMPLES:
                # '1930' , '5139' , '8139' , '4187' , '7190' , '4888' , '7889' , '1679' , '4889' , '7890'
                'site_name': 'TEXT',
                # EXAMPLES:
                # 'Vitamin D receptor, Hormone_recep domain' , 'Neuronal acetylcholine receptor; alpha2/beta4, Neur_chan
                # _LBD domain' , 'Cyclin-C/Cyclin-dependent kinase 19, Pkinase domain' , 'Sodium/hydrogen exchanger 3, N
                # a_H_Exchanger domain' , 'Retinoic acid receptor RXR-alpha/oxysterols receptor LXR-beta, Hormone_recep 
                # domain' , 'Voltage-gated N-type calcium channel alpha-1B subunit, Ion_trans domain' , 'Casein kinase I
                # I alpha'/ beta, Pkinase domain' , 'GABA transporter 3, SNF domain' , 'Voltage-gated N-type calcium cha
                # nnel alpha-1B subunit, Ion_trans domain' , 'Casein kinase II alpha'/ beta, Pkinase domain'
            }
        }
    }

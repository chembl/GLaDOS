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
            '_metadata': 
            {
                'properties': 
                {
                    'es_completion': 'TEXT',
                    # EXAMPLES:
                    # '{'weight': 100, 'input': 'Retina/plasma'}' , '{'weight': 10, 'input': 'CHEMBL3987832'}' , '{'weig
                    # ht': 10, 'input': 'UBERON:0001066'}' , '{'weight': 100, 'input': 'Intraorbital lacrimal gland'}' ,
                    #  '{'weight': 10, 'input': 'CHEMBL3833873'}' , '{'weight': 10, 'input': 'CHEMBL3987959'}' , '{'weig
                    # ht': 10, 'input': 'CHEMBL3988202'}' , '{'weight': 10, 'input': 'BTO:0001442'}' , '{'weight': 10, '
                    # input': 'UBERON:0000200'}' , '{'weight': 100, 'input': 'Aortic valve'}'
                    'organism_taxonomy': 
                    {
                        'properties': 
                        {
                            'l1': 'TEXT',
                            # EXAMPLES:
                            # 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 'Eukaryotes' , 
                            # 'Eukaryotes' , 'Eukaryotes' , 'Bacteria' , 'Bacteria'
                            'l2': 'TEXT',
                            # EXAMPLES:
                            # 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' , 'Mammalia' ,
                            #  'Mammalia' , 'Gram-Positive' , 'Gram-Positive'
                            'l3': 'TEXT',
                            # EXAMPLES:
                            # 'Rodentia' , 'Primates' , 'Rodentia' , 'Rodentia' , 'Primates' , 'Lagomorpha' , 'Rodentia'
                            #  , 'Rodentia' , 'Streptococcus' , 'Staphylococcus'
                            'oc_id': 'NUMERIC',
                            # EXAMPLES:
                            # '42' , '7' , '42' , '42' , '60' , '69' , '42' , '42' , '590' , '561'
                            'tax_id': 'NUMERIC',
                            # EXAMPLES:
                            # '10116' , '9606' , '10116' , '10116' , '9544' , '9986' , '10116' , '10116' , '1313' , '128
                            # 0'
                        }
                    },
                    'related_activities': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # '' , '' , '' , '' , '' , '' , '' , '' , '' , ''
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '5' , '1' , '4' , '1' , '63' , '15' , '1' , '2' , '110' , '31'
                        }
                    },
                    'related_assays': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3271354 CHEMBL3271351 CHEMBL3271352 CHEMBL3271353 CHEMBL3749611' , 'CHEMBL3266981' 
                            # , 'CHEMBL3231741 CHEMBL3232032 CHEMBL3232142 CHEMBL3232050' , 'CHEMBL2212114' , 'CHEMBL102
                            # 2344 CHEMBL1275020 CHEMBL1274863 CHEMBL1274891 CHEMBL1274030 CHEMBL1022341 CHEMBL1011798 C
                            # HEMBL1019674 CHEMBL1274912 CHEMBL1274662 CHEMBL1017034 CHEMBL1274842 CHEMBL1274933 CHEMBL1
                            # 275069 CHEMBL1274558 CHEMBL1274898 CHEMBL1017033 CHEMBL1274849 CHEMBL1274565 CHEMBL1274593
                            #  CHEMBL1274683 CHEMBL4000834 CHEMBL1011797 CHEMBL1274856 CHEMBL1274572 CHEMBL964747 CHEMBL
                            # 1275027 CHEMBL1274037 CHEMBL1274551 CHEMBL964745 CHEMBL1274926 CHEMBL1274919 CHEMBL1274690
                            #  CHEMBL1275034 CHEMBL1274877 CHEMBL1274669 CHEMBL1275048 CHEMBL1274884 CHEMBL1017010 CHEMB
                            # L1017032 CHEMBL1022342 CHEMBL1022346 CHEMBL1017035 CHEMBL1275076 CHEMBL1275090 CHEMBL10170
                            # 09 CHEMBL1275062 CHEMBL1274579 CHEMBL1274905 CHEMBL1274676 CHEMBL1019675 CHEMBL1274586 CHE
                            # MBL964744 CHEMBL1274655 CHEMBL1022345 CHEMBL1275055 CHEMBL1011799 CHEMBL1275041 CHEMBL1275
                            # 083 CHEMBL1022343 CHEMBL964746 CHEMBL1274870 CHEMBL1274544' , 'CHEMBL3862853 CHEMBL3862825
                            #  CHEMBL3862826' , 'CHEMBL3373694' , 'CHEMBL4054773 CHEMBL4054770' , 'CHEMBL1827722 CHEMBL3
                            # 583725 CHEMBL3389745 CHEMBL935349 CHEMBL3091242 CHEMBL3583724 CHEMBL3091255 CHEMBL3583723 
                            # CHEMBL940282 CHEMBL3738486 CHEMBL1926063 CHEMBL1055389 CHEMBL1924493 CHEMBL3736923 CHEMBL3
                            # 736913 CHEMBL3583729 CHEMBL1924492 CHEMBL3738482 CHEMBL3737062 CHEMBL1924491 CHEMBL3389206
                            #  CHEMBL1260643 CHEMBL935348 CHEMBL3389742 CHEMBL3389743 CHEMBL936043 CHEMBL3583728 CHEMBL1
                            # 805837 CHEMBL3606187 CHEMBL3389744 CHEMBL3736767 CHEMBL948103 CHEMBL1924490 CHEMBL940281 C
                            # HEMBL935351 CHEMBL3362796 CHEMBL935350 CHEMBL3606186 CHEMBL3389205 CHEMBL3583726 CHEMBL373
                            # 6765 CHEMBL1273661 CHEMBL1055388 CHEMBL1273660 CHEMBL1067241 CHEMBL1924489 CHEMBL935352 CH
                            # EMBL2214928 CHEMBL1067242' , 'CHEMBL994370 CHEMBL1218348 CHEMBL994358 CHEMBL994366 CHEMBL9
                            # 94362 CHEMBL994369 CHEMBL1218345 CHEMBL994359 CHEMBL1657220 CHEMBL1657221 CHEMBL1653373 CH
                            # EMBL1655162 CHEMBL994372 CHEMBL1218462 CHEMBL1654323 CHEMBL994371 CHEMBL1654028 CHEMBL1654
                            # 324 CHEMBL994368 CHEMBL1218349 CHEMBL1218341 CHEMBL994367 CHEMBL994363 CHEMBL1654322 CHEMB
                            # L994365 CHEMBL1654030 CHEMBL1654029'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '5' , '1' , '4' , '1' , '63' , '3' , '1' , '2' , '49' , '27'
                        }
                    },
                    'related_cell_lines': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3833683' , 'CHEMBL3307768' , 'CHEMBL3307627' , 'CHEMBL3307355' , 'CHEMBL3307965' , 
                            # 'CHEMBL3307651' , 'CHEMBL3307762' , 'CHEMBL3307627' , 'CHEMBL3308019 CHEMBL3307570 CHEMBL3
                            # 307965 CHEMBL3307564' , 'CHEMBL3307383'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '1' , '1' , '1' , '1' , '1' , '1' , '1' , '1' , '4' , '1'
                        }
                    },
                    'related_compounds': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL2420629 CHEMBL3746776 CHEMBL3260358' , 'CHEMBL3260771' , 'CHEMBL3229240 CHEMBL32292
                            # 38' , 'CHEMBL2203701' , 'CHEMBL395998 CHEMBL2017983 CHEMBL1270517' , 'CHEMBL2403888 CHEMBL
                            # 3922006 CHEMBL3895075 CHEMBL3948952 CHEMBL3905199 CHEMBL3933212 CHEMBL3906900 CHEMBL210573
                            # 5 CHEMBL3921126' , 'CHEMBL3358920' , 'CHEMBL4074669' , 'CHEMBL3604813 CHEMBL188635 CHEMBL1
                            # 922318 CHEMBL1922327 CHEMBL2441068 CHEMBL1922489 CHEMBL510944 CHEMBL1922481 CHEMBL2206420 
                            # CHEMBL3086523 CHEMBL1922499 CHEMBL1922323 CHEMBL1922328 CHEMBL1923420 CHEMBL1922486 CHEMBL
                            # 1922494 CHEMBL3580908 CHEMBL3580926 CHEMBL1922490 CHEMBL1922336 CHEMBL3735824 CHEMBL497 CH
                            # EMBL1922480 CHEMBL1922337 CHEMBL1922326 CHEMBL1922482 CHEMBL1258462 CHEMBL581906 CHEMBL192
                            # 2333 CHEMBL1922315 CHEMBL1922496 CHEMBL1922477 CHEMBL1272278 CHEMBL1922321 CHEMBL1922316 C
                            # HEMBL1822871 CHEMBL1922484 CHEMBL1922487 CHEMBL1272227 CHEMBL1922332 CHEMBL1922330 CHEMBL4
                            # 5 CHEMBL286615 CHEMBL1922479 CHEMBL411440 CHEMBL1922478 CHEMBL1922322 CHEMBL161 CHEMBL3876
                            # 75 CHEMBL1922500 CHEMBL1922335 CHEMBL1922324 CHEMBL1922497 CHEMBL551359 CHEMBL3580919 CHEM
                            # BL1922491 CHEMBL1922317 CHEMBL1922325 CHEMBL1922493 CHEMBL1922331 CHEMBL1922319 CHEMBL1922
                            # 483 CHEMBL75267 CHEMBL465372 CHEMBL1922488 CHEMBL1922498 CHEMBL1922329 CHEMBL1922334 CHEMB
                            # L1800922 CHEMBL3580916 CHEMBL502 CHEMBL1922492 CHEMBL1922320 CHEMBL1922495 CHEMBL1922485 C
                            # HEMBL2206412' , 'CHEMBL262777 CHEMBL520642 CHEMBL501122 CHEMBL32 CHEMBL126 CHEMBL387675'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '3' , '1' , '2' , '1' , '3' , '9' , '1' , '1' , '76' , '6'
                        }
                    },
                    'related_documents': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL3745705 CHEMBL3259558' , 'CHEMBL3259671' , 'CHEMBL3227952' , 'CHEMBL2203285' , 'CHE
                            # MBL1151757 CHEMBL1268908 CHEMBL4000173' , 'CHEMBL3861981' , 'CHEMBL3352115' , 'CHEMBL40526
                            # 43' , 'CHEMBL3603820 CHEMBL1921774 CHEMBL3734674 CHEMBL1143818 CHEMBL3085641 CHEMBL1156916
                            #  CHEMBL3351484 CHEMBL1151477 CHEMBL1255186 CHEMBL3352025 CHEMBL1149049 CHEMBL1821588 CHEMB
                            # L3580567 CHEMBL1142351 CHEMBL2203249 CHEMBL1921784 CHEMBL1800034 CHEMBL1269010' , 'CHEMBL1
                            # 155768 CHEMBL1649142 CHEMBL1649273 CHEMBL1212779'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '2' , '1' , '1' , '1' , '3' , '1' , '1' , '1' , '18' , '4'
                        }
                    },
                    'related_targets': 
                    {
                        'properties': 
                        {
                            'all_chembl_ids': 'TEXT',
                            # EXAMPLES:
                            # 'CHEMBL612558 CHEMBL345' , 'CHEMBL1836' , 'CHEMBL612558' , 'CHEMBL612558' , 'CHEMBL612545 
                            # CHEMBL612558' , 'CHEMBL612546' , 'CHEMBL376' , 'CHEMBL612545' , 'CHEMBL2574 CHEMBL375 CHEM
                            # BL612545 CHEMBL612546 CHEMBL612670 CHEMBL376 CHEMBL612558 CHEMBL613631 CHEMBL347' , 'CHEMB
                            # L352 CHEMBL374 CHEMBL362'
                            'count': 'NUMERIC',
                            # EXAMPLES:
                            # '2' , '1' , '1' , '1' , '2' , '1' , '1' , '1' , '9' , '3'
                        }
                    }
                }
            },
            'bto_id': 'TEXT',
            # EXAMPLES:
            # 'BTO:0001442' , 'BTO:0001279' , 'BTO:0000156' , 'BTO:0001388' , 'BTO:0000928' , 'BTO:0000573' , 'BTO:00010
            # 67' , 'BTO:0000493' , 'BTO:0004345' , 'BTO:0001063'
            'caloha_id': 'TEXT',
            # EXAMPLES:
            # 'TS-0953' , 'TS-0099' , 'TS-1060' , 'TS-1307' , 'TS-0054' , 'TS-0394' , 'TS-0309' , 'TS-0813' , 'TS-1047' 
            # , 'TS-0469'
            'efo_id': 'TEXT',
            # EXAMPLES:
            # 'EFO:0001914' , 'UBERON:0002240' , 'UBERON:0001348' , 'UBERON:0003126' , 'UBERON:0001637' , 'UBERON:000211
            # 0' , 'UBERON:0002728' , 'UBERON:0000970' , 'UBERON:0001851' , 'UBERON:0000988'
            'pref_name': 'TEXT',
            # EXAMPLES:
            # 'Retina/plasma' , 'Meningeal artery' , 'Intervertebral disk' , 'Intraorbital lacrimal gland' , 'Occipital 
            # lobe' , 'Sinoatrial node' , 'Ankle/Knee' , 'Brain ventricle' , 'Gyrus' , 'Aortic valve'
            'tissue_chembl_id': 'TEXT',
            # EXAMPLES:
            # 'CHEMBL4296362' , 'CHEMBL3987832' , 'CHEMBL3987785' , 'CHEMBL3987787' , 'CHEMBL3833873' , 'CHEMBL3987959' 
            # , 'CHEMBL3988202' , 'CHEMBL4296347' , 'CHEMBL3987758' , 'CHEMBL3987638'
            'uberon_id': 'TEXT',
            # EXAMPLES:
            # 'UBERON:0003474' , 'UBERON:0001066' , 'UBERON:0019324' , 'UBERON:0002021' , 'UBERON:0002351' , 'UBERON:000
            # 4086' , 'UBERON:0000200' , 'UBERON:0002137' , 'UBERON:0001881' , 'UBERON:0002240'
        }
    }

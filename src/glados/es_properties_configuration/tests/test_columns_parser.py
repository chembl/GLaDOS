from django.test import TestCase
from glados.es_properties_configuration import columns_parser


class ColumnsParserTester(TestCase):
    def test_parses_one_property(self):
        original_value = [
            {
                'synonyms': 'Carbilev',
                'molecule_synonym': 'Carbilev',
                'syn_type': 'OTHER'
            },
            {
                'synonyms': 'DOPAMINE',
                'molecule_synonym': 'Dopamine',
                'syn_type': 'ATC'
            },
            {
                'synonyms': 'DOPAMINE',
                'molecule_synonym': 'Dopamine',
                'syn_type': 'BAN'
            },
            {
                'synonyms': 'DOPAMINE',
                'molecule_synonym': 'Dopamine',
                'syn_type': 'INN'
            },
            {
                'synonyms': 'Dopamine',
                'molecule_synonym': 'Dopamine',
                'syn_type': 'FDA'
            },
            {
                'synonyms': 'Intropin',
                'molecule_synonym': 'Intropin',
                'syn_type': 'OTHER'
            },
            {
                'synonyms': 'Parcopa',
                'molecule_synonym': 'Parcopa',
                'syn_type': 'OTHER'
            },
            {
                'synonyms': 'Sinemet',
                'molecule_synonym': 'Sinemet',
                'syn_type': 'OTHER'
            }
        ]

        index_name = 'chembl_molecule'
        property_name = 'molecule_synonyms'

        parsed_value_got = columns_parser.parse_property(original_value, index_name, property_name)
        parsed_value_must_be = columns_parser.parse_synonyms(original_value)
        self.assertEqual(parsed_value_got, parsed_value_must_be, 'A value was not parser correctly.')
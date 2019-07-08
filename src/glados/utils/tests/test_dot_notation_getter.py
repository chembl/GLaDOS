from django.test import TestCase
from glados.utils.dot_notation_getter import DotNotationGetter


class DotNotationGetterTester(TestCase):
    test_dict = {
        'brand': 'Ford',
        'model': 'Mustang',
        'year': 1964,
        'owner': {
            'name': 'One',
            'profession': 'Key Presser',
            'date_of_birth': 1989,
            'hometown': {
                'name': 'Bogotá',
                'country': 'Colombia'
            }

        }
    }

    def test_gets_one_simple_property(self):
        dot_notation_getter = DotNotationGetter(self.test_dict)
        property_to_get = 'brand'

        value_got = dot_notation_getter.get_from_string(property_to_get)
        self.assertEqual(value_got, 'Ford', 'A simple property was not obtained!')

    def test_gets_a_nested_property(self):
        dot_notation_getter = DotNotationGetter(self.test_dict)
        property_to_get = 'owner.hometown.country'

        value_got = dot_notation_getter.get_from_string(property_to_get)
        self.assertEqual(value_got, 'Colombia', 'A nested property was not obtained!')

    def test_gets_the_default_null_value(self):
        dot_notation_getter = DotNotationGetter(self.test_dict)
        property_to_get = 'does_not_exist'

        value_got = dot_notation_getter.get_from_string(property_to_get)
        self.assertEqual(value_got, DotNotationGetter.DEFAULT_NULL_LABEL, 'A nested property was not obtained!')

from arpeggio import OneOrMore, Optional, And, EOF
from arpeggio import RegExMatch as _
import glados.grammar.common as common
import re


def version():
    return common.integer_number, Optional(common.ascii_letter_sequence)


def layer():
    return '/', common.correctly_parenthesised_non_space_char_sequence


def inchi():
    return 'InChI=', version, OneOrMore(layer), common.term_end_lookahead

__INCHI_KEY_REGEX_STR = r'[A-Z]{14}-[A-Z]{10}-[A-Z]'
__INCHI_KEY_REGEX = re.compile(__INCHI_KEY_REGEX_STR)


def inchi_key():
    return _(__INCHI_KEY_REGEX_STR), common.term_end_lookahead


def is_inchi_key(inchi_key_str: str):
    return __INCHI_KEY_REGEX.match(inchi_key_str) is not None

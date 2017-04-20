from arpeggio import OneOrMore, Optional, And, EOF
from arpeggio import RegExMatch as _
import glados.grammar.common as common


def version():
    return common.integer_number, Optional(common.ascii_letter_sequence)


def layer():
    return '/', common.not_space_sequence


def inchi():
    return 'InChI=', version, OneOrMore(layer), common.term_end_lookahead


def inchi_key():
    return _(r'[A-Z]{14}-[A-Z]{10}-[A-Z]'), common.term_end_lookahead

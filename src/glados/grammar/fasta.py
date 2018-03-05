from arpeggio import Optional, OneOrMore, ZeroOrMore, Not
from arpeggio import RegExMatch as _
import glados.grammar.common as common


def protein_sequence():
    return OneOrMore(_(r'[A-Z-*]'))


def sequence_id():
    return '>', _(r'[^\n]*'), '\n'


def fasta():
    return Optional(sequence_id), protein_sequence(), common.term_end_lookahead


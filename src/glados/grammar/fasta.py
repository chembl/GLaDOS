from arpeggio import Optional, OneOrMore, ZeroOrMore, Not, Repetition
from arpeggio import RegExMatch as _
import glados.grammar.common as common


def sequence_part():
    return _(r'[A-Z-*]')


def protein_sequence():
    min_ten = (sequence_part,)*10
    continuation = (OneOrMore(sequence_part), )
    complete_tuple = min_ten + continuation
    return complete_tuple


def sequence_id():
    return '>', _(r'[^\n]*'), '\n'


def fasta():
    return Optional(sequence_id), protein_sequence(), common.term_end_lookahead

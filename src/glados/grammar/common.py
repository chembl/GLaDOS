from arpeggio import RegExMatch as _
from arpeggio import And, OneOrMore, ZeroOrMore, EOF


def reverse_regex_or_clause(regex_or_clause: str) -> str:
    """
    Reverses a regex or clause
    :param regex_or_clause: an or regex clause eg. H|He|Hf|Zn|As
    :return: reversed regex clause eg. Zn|Hf|He|H|As
    """
    reversed_clause = '|'.join(reversed(sorted(regex_or_clause.split('|'))))
    return reversed_clause


def term_end_lookahead():
    return And([space, ')', EOF])


def space():
    return _(r'\s')


def space_sequence():
    return _(r'\s+')


def not_space():
    return _(r'[^\s]')


def not_space_sequence():
    return _(r'[^\s]+')


def ascii_letter():
    return _(r'[A-Za-z]')


def ascii_letter_sequence():
    return _(r'[A-Za-z]+')


def integer_number():
    return _(r'\d+')


def digit():
    return _(r'\d')


def float_number():
    return _(r'\d+\.\d+')


def non_space_or_parenthesis_sequence():
    return _(r'[^\s()\[\]]')


def correctly_parenthesised_non_space_char_sequence():
    return (
        OneOrMore([
                non_space_or_parenthesis_sequence,
                ('(', correctly_parenthesised_non_space_char_sequence, ')'),
                ('[', correctly_parenthesised_non_space_char_sequence, ']')
            ]
        )
    )
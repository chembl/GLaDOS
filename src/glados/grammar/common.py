from arpeggio import RegExMatch as _
from arpeggio import And, EOF


def reverse_regex_or_clause(regex_or_clause: str) -> str:
    """
    Reverses a regex or clause
    :param regex_or_clause: an or regex clause eg. H|He|Hf|Zn|As
    :return: reversed regex clause eg. Zn|Hf|He|H|As
    """
    reversed_clause = '|'.join(reversed(sorted(regex_or_clause.split('|'))))
    print(reversed_clause)
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

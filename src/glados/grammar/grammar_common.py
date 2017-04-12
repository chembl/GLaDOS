from arpeggio import RegExMatch as _


def reverse_regex_or_clause(regex_or_clause: str) -> str:
    """
    Reverses a regex or clause
    :param regex_or_clause: an or regex clause eg. H|He|Hf|Zn|As
    :return: reversed regex clause eg. Zn|Hf|He|H|As
    """
    reversed_clause = '|'.join(reversed(sorted(regex_or_clause.split('|'))))
    print(reversed_clause)
    return reversed_clause


def integer_number():
    return _(r'\d+')


def digit():
    return _(r'\d')


def float_number():
    return _(r'\d+\.\d+')

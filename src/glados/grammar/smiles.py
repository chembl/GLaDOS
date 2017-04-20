from arpeggio import Optional, ZeroOrMore, And, EOF
from arpeggio import RegExMatch as _
import glados.grammar.common as common


def aliphatic_organic():
    return _(common.reverse_regex_or_clause(r'B|C|N|O|S|P|F|Cl|Br|I'))


def aromatic_organic():
    return _(common.reverse_regex_or_clause(r'b|c|n|o|s|p'))


def element_symbol():
    return _(
        common.reverse_regex_or_clause(
            r'H|He|'
            r'Li|Be|B|C|N|O|F|Ne|'
            r'Na|Mg|Al|Si|P|S|Cl|Ar|'
            r'K|Ca|Sc|Ti|V|Cr|Mn|Fe|Co|Ni|Cu|Zn|Ga|Ge|As|Se|Br|Kr|'
            r'Rb|Sr|Y|Zr|Nb|Mo|Tc|Ru|Rh|Pd|Ag|Cd|In|Sn|Sb|Te|I|Xe|'
            r'Cs|Ba|Hf|Ta|W|Re|Os|Ir|Pt|Au|Hg|Tl|Pb|Bi|Po|At|Rn|'
            r'Fr|Ra|Rf|Db|Sg|Bh|Hs|Mt|Ds|Rg|Cn|Fl|Lv|'
            r'La|Ce|Pr|Nd|Pm|Sm|Eu|Gd|Tb|Dy|Ho|Er|Tm|Yb|Lu|'
            r'Ac|Th|Pa|U|Np|Pu|Am|Cm|Bk|Cf|Es|Fm|Md|No|Lr'
        )
      )


def aromatic_symbol():
    return _(common.reverse_regex_or_clause(r'b|c|n|o|p|s|se|as'))


def bracket_atom_symbol():
    return [element_symbol, aromatic_symbol, r'*']


def chiral():
    return [
                '@', '@@', '@TH1', '@TH2', '@AL1', '@AL2', '@SP1', '@SP2', '@SP3',
                ('@TB', common.digit, Optional(common.digit)),
                ('@OH', common.digit, Optional(common.digit))
            ]


def h_count():
    return 'H', Optional(common.digit)


def charge():
    return [
                (
                    '-',
                    Optional([
                        '-',
                        (common.digit, Optional(common.digit))
                    ])
                 ),
                (
                    '+',
                    Optional([
                        '+',
                        (common.digit, Optional(common.digit))
                    ])
                 )
            ]


def atom_class():
    return ':', common.integer_number


def bracket_atom():
    """
      http://opensmiles.org/opensmiles.html
      bracket_atom ::= '[' isotope? symbol chiral? hcount? charge? class? ']'
    """
    return r'[', Optional(common.integer_number), bracket_atom_symbol, \
           Optional(chiral), Optional(h_count), Optional(charge), Optional(atom_class), r']'


def atom():
    return [bracket_atom, aliphatic_organic, aromatic_organic, '*']


def dot():
    return '.'


def bond():
    return ['-', '=', '#', '$', ':', '/', '\\']


def branched_atom():
    return atom, ZeroOrMore(ring_bond), ZeroOrMore(branch)


def ring_bond():
    return Optional(bond), Optional('%'), common.digit, Optional(common.digit)


def branch():
    return \
        [
            ('(', chain, ')'),
            ('(', bond, chain, ')'),
            ('(', dot, chain, ')')
        ]


def chain():
    return \
        (
            branched_atom,
            Optional(
                (
                    Optional([bond, dot]), chain
                )
            )
        )


def smiles():
    return chain, common.term_end_lookahead


from arpeggio import Optional, PTNodeVisitor, OneOrMore, EOF
from arpeggio import ParserPython
import arpeggio

import glados.grammar.common as common
import glados.grammar.smiles as smiles
import glados.grammar.inchi as inchi
import re


def single_term():
    return [smiles.smiles, inchi.inchi_key, inchi.inchi]


def expression_term():
    return [parenthesised_expression, single_term]


def parenthesised_expression():
    return '(', expression, ')'


def expression():
    return \
        (
            Optional(common.space_sequence),
            expression_term,
            OneOrMore(
                Optional(
                    (common.space_sequence, ['and', 'or'])
                ),
                common.space_sequence,
                expression_term,
                common.term_end_lookahead
            )
        )


parser = ParserPython(expression, skipws=False)


class TermsVisitor(PTNodeVisitor):

    def __init__(self):
        super().__init__()
        self.smiles = []
        self.inchi = []
        self.inchi_key = []

    def visit__default__(self, node, children):
        """
        Called if no visit method is defined for the node.

        Args:
            node(ParseTreeNode):
            children(processed children ParseTreeNode-s):
        """
        if isinstance(node, arpeggio.Terminal):
            return arpeggio.text(node)
        else:
            return ''.join([str(child_i) for child_i in children])

    # def visit_single_term(self, node, children):
    #     return ''.join(list(map(lambda x: str(x), children)))

    def visit_expression(self, node, children):
        return {
            'smiles': self.smiles,
            'inchi': self.inchi,
            'inchi_key': self.inchi_key
        }

    def visit_smiles(self, node, children):
        self.smiles.append(''.join(children))

    def visit_inchi(self, node, children):
        self.inchi.append(''.join(children))

    def visit_inchi_key(self, node, children):
        self.inchi_key.append(''.join(children))


def parse_query_str(query_string: str):
    query_string = re.sub(r'\s+', ' ', query_string)
    print(query_string)
    pt = parser.parse(query_string)
    result = arpeggio.visit_parse_tree(pt, TermsVisitor())
    print(result)


parse_query_str('[12H]-[He] [He]  [Cu]-[Zn]')

parse_query_str(
    """    InChI=1/BrH/h1H/i1-1
    (CCc1nn(C)c2c(=O)[nH]c(nc12)c3cc(ccc3OCC)S(=O)(=O)N4CCN(C)CC4 or
    Cc1nnc2CN=C(c3ccccc3)c4cc(Cl)ccc4-n12 and CN1C(=O)CN=C(c2ccccc2)c3cc(Cl)ccc13)
    CC(C)(N)Cc1ccccc1
    CCCc1nn(C)c2C(=O)NC(=Nc12)c3cc(ccc3OCC)S(=O)(=O)N4CCN(C)CC4.OC(=O)CC(O)(CC(=O)O)C(=O)O

    VYFYYTLLBUKUHU-UHFFFAOYSA-N


    InChI=1/BrH/h1H/i1+1

    """
)
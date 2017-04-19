from arpeggio import Not, Optional, PTNodeVisitor, ZeroOrMore, OneOrMore, EOF
from arpeggio import RegExMatch as _
from arpeggio import ParserPython
import arpeggio

import glados.grammar.grammar_smiles as gs


def single_term():
    return gs.smiles


def search_terms():
    return Optional(_(r'\s+')), OneOrMore(single_term, [_(r'\s+'), EOF])


parser = ParserPython(search_terms, skipws=False)


class TermsVisitor(PTNodeVisitor):

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
            return ''.join(children)

    # def visit_single_term(self, node, children):
    #     return ''.join(list(map(lambda x: str(x), children)))

    def visit_search_terms(self, node, children):
        return list(filter(lambda x: len(x.strip()) > 0, children))


parser_tree = parser.parse('[H]-2([He])')
result = arpeggio.visit_parse_tree(parser_tree, TermsVisitor())
print(result)
parser_tree = parser.parse('[12H]-[He] [He]  [Cu]-[Zn]')
result = arpeggio.visit_parse_tree(parser_tree, TermsVisitor())
print(result)

parser_tree = parser.parse(
    """
    CCc1nn(C)c2c(=O)[nH]c(nc12)c3cc(ccc3OCC)S(=O)(=O)N4CCN(C)CC4
    Cc1nnc2CN=C(c3ccccc3)c4cc(Cl)ccc4-n12 CN1C(=O)CN=C(c2ccccc2)c3cc(Cl)ccc13
    CC(C)(N)Cc1ccccc1
    CCCc1nn(C)c2C(=O)NC(=Nc12)c3cc(ccc3OCC)S(=O)(=O)N4CCN(C)CC4.OC(=O)CC(O)(CC(=O)O)C(=O)O
    """
)
result = arpeggio.visit_parse_tree(parser_tree, TermsVisitor())
print(result)
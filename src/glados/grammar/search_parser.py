from arpeggio import Not, Optional, PTNodeVisitor, ZeroOrMore, OneOrMore, EOF
from arpeggio import RegExMatch as _
from arpeggio import ParserPython
import arpeggio

import glados.grammar.grammar_smiles as gs


def single_term():
    return gs.smiles


def search_terms():
    return OneOrMore(single_term, [_(r'\s+'), EOF])


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


parser_tree = parser.parse('[H]-[He]')
result = arpeggio.visit_parse_tree(parser_tree, TermsVisitor())
print(result)
parser_tree = parser.parse('[12H]-[He] [He]  [Cu]-[Zn]')
result = arpeggio.visit_parse_tree(parser_tree, TermsVisitor())
print(result)

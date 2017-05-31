from arpeggio import Optional, PTNodeVisitor, ZeroOrMore, EOF
from arpeggio import ParserPython
import arpeggio

import glados.grammar.common as common
import glados.grammar.smiles as smiles
import glados.grammar.inchi as inchi
import re
import json


def word_term():
    return


def property_term():
    return(
        Optional(['+', '-']),
        json_property_path_segment, ZeroOrMore('.', json_property_path_segment), ':'
        [
           ('"', _('[^"]'), '"'),
           ("'", _("[^']"), "'")
        ],
        common.term_end_lookahead
    )

def number_value():
    return


def json_property_path_segment():
    return _(r'[a-zA-Z0-9_\-]')

def exact_match_term():
    return (
        Optional(['+', '-']),
        [
           ('"', _('[^"]'), '"'),
           ("'", _("[^']"), "'")
        ],
        common.term_end_lookahead
    )


def expression_term():
    return [parenthesised_expression, smiles.smiles, inchi.inchi_key, inchi.inchi]


def parenthesised_expression():
    return '(', expression, ')', common.term_end_lookahead


def expression():
    return \
        (
            Optional(common.space_sequence),
            expression_term,
            ZeroOrMore(
                Optional(
                    (common.space_sequence, ['and', 'or'])
                ),
                common.space_sequence,
                expression_term,
                common.term_end_lookahead
            ),
            Optional(common.space_sequence)
        )


parser = ParserPython(expression, skipws=False)


class TermsVisitor(PTNodeVisitor):

    def __init__(self):
        super().__init__()

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

    def visit_expression_term(self, node, children):
        return children[0]

    def visit_parenthesised_expression(self, node, children):
        return children[1]

    def visit_expression(self, node, children):
        exp = {'or': []}
        last_was_and = False
        for child_i in children:
            str_child_i = str(child_i).strip()
            if len(str_child_i) > 0:
                if str_child_i == 'and':
                    last_was_and = True
                elif str_child_i != 'or':
                    if last_was_and:
                        if type(exp['or'][-1]) == dict and 'and' in exp['or'][-1]:
                            exp['or'][-1]['and'].append(child_i)
                        else:
                            exp['or'][-1] = {'and': [exp['or'][-1], child_i]}

                        last_was_and = False
                    else:
                        exp['or'].append(child_i)
        return exp

    def visit_smiles(self, node, children):
        return 'SMILES:'+''.join(children)

    def visit_inchi(self, node, children):
        return 'inchi:'+''.join(children)

    def visit_inchi_key(self, node, children):
        return 'inchi_key:'+''.join(children)


def parse_query_str(query_string: str):
    query_string = re.sub(r'\s+', ' ', query_string)
    print(query_string)
    pt = parser.parse(query_string)
    result = arpeggio.visit_parse_tree(pt, TermsVisitor())
    json_result = json.dumps(result, indent=4)
    print(json_result)


parse_query_str('[12H]-[He] [He]  [Cu]-[Zn]')

longest_chembl_smiles = r"CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC1OC(CO)C(O)C(O)C1O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+" \
                        r"]OC(CO)C(O)C(OC2OC(CO)C(O)C(O)C2O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC3OC(CO" \
                        r")C(O)C(O)C3O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC4OC(CO)C(O)C(O)C4O)C(O)CO.C" \
                        r"CCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC5OC(CO)C(O)C(O)C5O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]" \
                        r"OC(CO)C(O)C(OC6OC(CO)C(O)C(O)C6O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC7OC(CO)" \
                        r"C(O)C(O)C7O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC8OC(CO)C(O)C(O)C8O)C(O)CO.CC" \
                        r"CCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC9OC(CO)C(O)C(O)C9O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]O" \
                        r"C(CO)C(O)C(OC%10OC(CO)C(O)C(O)C%10O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC%11O" \
                        r"C(CO)C(O)C(O)C%11O)C(O)CO.CCCCCCCCCCCCCCCC[NH2+]OC(CO)C(O)C(OC%12OC(CO)C(O)C(O)C%12" \
                        r"O)C(O)CO.CCCCCCCCCC(C(=O)NCCc%13ccc(OP(=S)(Oc%14ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-" \
                        r"])cc%14)N(C)\N=C\c%15ccc(Op%16(Oc%17ccc(\C=N\N(C)P(=S)(Oc%18ccc(CCNC(=O)C(CCCCCCCCC" \
                        r")P(=O)(O)[O-])cc%18)Oc%19ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%19)cc%17)np(Oc%20c" \
                        r"cc(\C=N\N(C)P(=S)(Oc%21ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%21)Oc%22ccc(CCNC(=O)" \
                        r"C(CCCCCCCCC)P(=O)(O)[O-])cc%22)cc%20)(Oc%23ccc(\C=N\N(C)P(=S)(Oc%24ccc(CCNC(=O)C(CC" \
                        r"CCCCCCC)P(=O)(O)[O-])cc%24)Oc%25ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%25)cc%23)np" \
                        r"(Oc%26ccc(\C=N\N(C)P(=S)(Oc%27ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%27)Oc%28ccc(C" \
                        r"CNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%28)cc%26)(Oc%29ccc(\C=N\N(C)P(=S)(Oc%30ccc(CCNC(" \
                        r"=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%30)Oc%31ccc(CCNC(=O)C(CCCCCCCCC)P(=O)(O)[O-])cc%31)c" \
                        r"c%29)n%16)cc%15)cc%13)P(=O)(O)[O-]"



parse_query_str(
    """
    COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56

and

C\C(=C\C(=O)O)\C=C\C=C(/C)\C=C\C1=C(C)CCCC1(C)C

and (COC1(CN2CCC1CC2)C#CC(C#N)(c3ccccc3)c4ccccc4 or CN1C\C(=C/c2ccc(C)cc2)\C3=C(C1)C(C(=C(N)O3)C#N)c4ccc(C)cc4)

COc1ccc2[C@@H]3[C@H](COc2c1)C(C)(C)OC4=C3C(=O)C(=O)C5=C4OC(C)(C)[C@@H]6COc7cc(OC)ccc7[C@H]56

CC(C)C[C@H](NC(=O)[C@@H](NC(=O)[C@H](Cc1c[nH]c2ccccc12)NC(=O)[C@H]3CCCN3C(=O)C(CCCCN)CCCCN)C(C)(C)C)C(=O)O

    (InChI=1/BrH/h1H/i1[-]1)
    ( Cc1nnc2CN=C(c3ccccc3)c4cc(Cl)ccc4-n12 or CN1C(=O)CN=C(c2ccccc2)c3cc(Cl)ccc13 and c and ccc cs or ccs or InChI=1s/BrH and c)
    CC(C)(N)Cc1ccccc1
    CCCc1nn(C)c2C(=O)NC(=Nc12)c3cc(ccc3OCC)S(=O)(=O)N4CCN(C)CC4.OC(=O)CC(O)(CC(=O)O)C(=O)O

    VYFYYTLLBUKUHU-UHFFFAOYSA-N


    InChI=1/BrH/h1H/i1+1

    """ + longest_chembl_smiles
)

parse_query_str(longest_chembl_smiles)


print('C'*14+'-'+'C'*10+'-C')
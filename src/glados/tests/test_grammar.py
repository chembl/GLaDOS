import unittest
import glados.tests.utils as utils
import glados.grammar.smiles as smiles
import glados.grammar.inchi as inchi
from arpeggio import ParserPython


class GrammarTester(unittest.TestCase):

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def try_parsing(self, parser: ParserPython, text_to_parse: str):
        # noinspection PyBroadException
        try:
            parser.parse(text_to_parse)
        except:
            self.fail("Could not parse {0} using the {1} parser!".format(text_to_parse, parser.__class__))

    # ------------------------------------------------------------------------------------------------------------------
    # Simple Grammars Tests
    # ------------------------------------------------------------------------------------------------------------------

    def test_smiles_parsing(self):
        # noinspection PyBroadException
        try:
            parser = ParserPython(smiles.smiles, skipws=False)
        except:
            self.fail("Could not instantiate the SMILES parser!")
        if parser:
            for smiles_i in utils.SMILES_EXAMPLES:
                self.try_parsing(parser, smiles_i)

    def test_inchi_parsing(self):
        # noinspection PyBroadException
        try:
            parser = ParserPython(inchi.inchi, skipws=False)
        except:
            self.fail("Could not instantiate the InChI parser!")
        if parser:
            for inchi_i in utils.INCHI_EXAMPLES:
                self.try_parsing(parser, inchi_i)

    def test_inchi_key_parsing(self):
        # noinspection PyBroadException
        try:
            parser = ParserPython(inchi.inchi_key, skipws=False)
        except:
            self.fail("Could not instantiate the InChI KEY parser!")
        if parser:
            for inchi_key_i in utils.INCHI_KEY_EXAMPLES:
                self.try_parsing(parser, inchi_key_i)
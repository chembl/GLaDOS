from selenium import webdriver
import unittest
import time
import re

HOST = '127.0.0.1:8000'
SLEEP_TIME = 0.2


class CompoundReportCardTest(unittest.TestCase):
  # tweak this if the web services are taking a bit longer to load the compound.
  IMPLICIT_WAIT = 10

  def setUp(self):
    self.browser = webdriver.PhantomJS()
    self.browser.implicitly_wait(self.IMPLICIT_WAIT)

  def tearDown(self):
    self.browser.quit()

  def getURL(self, url, sleeptime):
    self.browser.get(url)
    time.sleep(sleeptime)

  # --------------------------------------
  # Compound Name and Classification
  # --------------------------------------

  def test_compound_image(self):

    # Normal structure image
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL25', SLEEP_TIME)
    img = self.browser.find_element_by_id('Bck-COMP_IMG')
    self.assertEqual(img.get_attribute('src'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL25.svg')

    # structure not available
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL6963', SLEEP_TIME)
    img = self.browser.find_element_by_id('Bck-COMP_IMG')
    self.assertEqual(img.get_attribute('src'), 'http://127.0.0.1:8000/static/img/structure_not_available.png')

    # protein sctructure
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL2108680', SLEEP_TIME)
    img = self.browser.find_element_by_id('Bck-COMP_IMG')
    self.assertEqual(img.get_attribute('src'), 'http://127.0.0.1:8000/static/img/protein_structure.png')

  def test_compound_name(self):
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL25', SLEEP_TIME)
    name_td = self.browser.find_element_by_id('Bck-PREF_NAME')
    self.assertEqual('ASPIRIN', name_td.text)

    # this one has a null name
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL6939', SLEEP_TIME)
    name_td = self.browser.find_element_by_id('Bck-PREF_NAME')
    self.assertEqual('Undefined', name_td.text)

  def test_compound_phase(self):
    # Max Phase 4
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL25', SLEEP_TIME)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('4 Approved', phase_td.text)

    # Max Phase 3
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL2109588', SLEEP_TIME)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('3 Phase III', phase_td.text)

    # Max Phase 2
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL1742989', SLEEP_TIME)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('2 Phase II', phase_td.text)

    # Max Phase 1
    self.getURL('http:/' + HOST + '/compound_report_card/CHEMBL1742987', SLEEP_TIME)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('1 Phase I', phase_td.text)

    # Max Phase 0
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL6963', SLEEP_TIME)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('0', phase_td.text)

  def test_molecular_formula(self):
    # Molecular formula of aspirin is C9H8O4
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL25', SLEEP_TIME)
    molformula_td = self.browser.find_element_by_id('Bck-MOLFORMULA')
    self.assertEqual('C9H8O4', molformula_td.text)

    # When there is no formula availavle the row should not be shown at all.
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL2109588', SLEEP_TIME)
    molformula_td = self.browser.find_element_by_id('Bck-MOLFORMULA')
    molformula_tr = molformula_td.find_element_by_xpath('..')
    self.assertFalse(molformula_tr.is_displayed())

  def test_synonyms_and_tradenames(self):
    # Synonyms should present only entries that are not trade names.
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL55/', SLEEP_TIME)
    synonyms_td = self.browser.find_element_by_id('CompNameClass-synonyms')
    tradenames_td = self.browser.find_element_by_id('CompNameClass-tradenames')

    self.assertEqual(
      'GNF-Pf-3680 MB-800 MB-800 [as isethionate] Pentamidine Pentamidine Isetionate RP-2512 RP-2512 [as isethionate]',
      synonyms_td.text)

    self.assertEqual(
      'Nebupent [as isethionate] Pentacarinat [as isethionate] Pentam 300 [as isethionate]',
      tradenames_td.text)

    # if trade names or synonyms are empty, don't show this row at all

    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL6939/', SLEEP_TIME)
    synonyms_td = self.browser.find_element_by_id('CompNameClass-synonyms')
    synonyms_tr = synonyms_td.find_element_by_xpath('..')
    self.assertFalse(synonyms_tr.is_displayed())

    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL2109588/', SLEEP_TIME)
    tradenames_td = self.browser.find_element_by_id('CompNameClass-tradenames')
    tradenames_tr = tradenames_td.find_element_by_xpath('..')
    self.assertFalse(tradenames_tr.is_displayed())

  def test_load_non_existent_compound(self):
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL7/', SLEEP_TIME)

    error_msg_p = self.browser.find_element_by_id('CNCCard').find_element_by_class_name('Bck-errormsg')
    self.assertRegexpMatches(error_msg_p.text,
                             'No compound found with id CHEMBL7|There was an error while loading the compound \(0 error\)')

  def test_png_download_button(self):
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL55/', SLEEP_TIME)
    download_png_buttons = self.browser.find_elements_by_class_name(
      'CNC-download-png')

    for button in download_png_buttons:
      self.assertEqual(button.get_attribute('href'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL55.png')

    download_svg_buttons = self.browser.find_elements_by_class_name(
      'CNC-download-svg')

    for button in download_svg_buttons:
      self.assertEqual(button.get_attribute('href'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL55.svg')

  # --------------------------------------
  # Compound Representations
  # --------------------------------------

  def test_canonical_smiles(self):
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL25/', SLEEP_TIME)
    canonical_smiles_input = self.browser.find_element_by_id('CompReps-canonicalSmiles')
    canonical_smiles_div = canonical_smiles_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(canonical_smiles_div.get_attribute('data-original-value'), 'CC(=O)Oc1ccccc1C(=O)O')

    canonical_smiles_input = self.browser.find_element_by_id('CompReps-canonicalSmiles-small')
    canonical_smiles_div = canonical_smiles_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(canonical_smiles_div.get_attribute('data-original-value'), 'CC(=O)Oc1ccccc1C(=O)O')

  def test_standard_inchi(self):
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL25/', SLEEP_TIME)
    standard_inchi_input = self.browser.find_element_by_id('CompReps-standardInchi')
    standard_inchi_div = standard_inchi_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_div.get_attribute('data-original-value'),
                     'InChI=1S/C9H8O4/c1-6(10)13-8-5-3-2-4-7(8)9(11)12/h2-5H,1H3,(H,11,12)')

    standard_inchi_input = self.browser.find_element_by_id('CompReps-standardInchi-small')
    standard_inchi_div = standard_inchi_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_div.get_attribute('data-original-value'),
                     'InChI=1S/C9H8O4/c1-6(10)13-8-5-3-2-4-7(8)9(11)12/h2-5H,1H3,(H,11,12)')

  def test_standard_inchi_key(self):

    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL25/', SLEEP_TIME)
    standard_inchi_key_input = self.browser.find_element_by_id('CompReps-standardInchiKey')
    standard_inchi_key_div = standard_inchi_key_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_key_div.get_attribute('data-original-value'),
                     'BSYNRYMUTXBXSQ-UHFFFAOYSA-N')

    standard_inchi_key_input = self.browser.find_element_by_id('CompReps-standardInchiKey-small')
    standard_inchi_key_div = standard_inchi_key_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_key_div.get_attribute('data-original-value'),
                     'BSYNRYMUTXBXSQ-UHFFFAOYSA-N')

  # --------------------------------------
  # Mechanism of action
  # --------------------------------------
  def test_mechanism_of_action(self):
    self.getURL('http://' + HOST + '/compound_report_card/CHEMBL17/', SLEEP_TIME)
    mechanisms_of_action_table = self.browser.find_element_by_id('MechOfActCard').find_element_by_tag_name('table')
    mechanisms_of_action_trs = mechanisms_of_action_table.find_elements_by_tag_name('tr')

    texts = [row.text for row in mechanisms_of_action_trs]

    self.assertIn('Carbonic anhydrase I inhibitor CHEMBL261 PubMed', texts)
    self.assertIn('Carbonic anhydrase II inhibitor CHEMBL205 PubMed', texts)
    self.assertIn('Carbonic anhydrase XII inhibitor CHEMBL3242 PubMed', texts)
    self.assertIn('Carbonic anhydrase IV inhibitor CHEMBL3729 PubMed', texts)


if __name__ == '__main__':
  unittest.main()

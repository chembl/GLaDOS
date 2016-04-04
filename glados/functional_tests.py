from selenium import webdriver
import unittest
import time

HOST = 'http://127.0.0.1:8000'
SLEEP_TIME = 1


class CompoundReportCardTest(unittest.TestCase):
  # tweak this if the web services are taking a bit longer to load the compound.
  IMPLICIT_WAIT = 10

  def setUp(self):
    self.browser = webdriver.Firefox()
    self.browser.set_window_size(1024, 768)
    self.browser.implicitly_wait(self.IMPLICIT_WAIT)

  def tearDown(self):
    self.browser.quit()

  def getURL(self, url, sleeptime):
    self.browser.get(url)
    time.sleep(sleeptime)

  def assert_molecule_feature(self, elem_id, should_be_active, img_src, img_tooltip, mobile_description,
                              tooltip_position):

    molecule_type_div = self.browser.find_element_by_id(elem_id)
    icon_div = molecule_type_div.find_element_by_class_name('feat-icon')

    if should_be_active:
      self.assertIn('active', icon_div.get_attribute('class'))
    else:
      self.assertNotIn('active', icon_div.get_attribute('class'))

    molecule_type_img = molecule_type_div.find_element_by_tag_name('img')
    self.assertEqual(molecule_type_img.get_attribute('src'),
                     img_src)
    self.assertEqual(molecule_type_img.get_attribute('data-tooltip'),
                     img_tooltip),
    self.assertEqual(molecule_type_img.get_attribute('data-position'),
                     tooltip_position)
    molecule_type_p = molecule_type_div.find_element_by_class_name('mol-features-detail')
    self.assertEqual(molecule_type_p.get_attribute('innerHTML'),
                     mobile_description)

  def test_compound_report_card_scenario_1(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL25', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Normal structure image
    img = self.browser.find_element_by_id('Bck-COMP_IMG')
    self.assertEqual(img.get_attribute('src'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL25.svg')

    # Normal compound name
    name_td = self.browser.find_element_by_id('Bck-PREF_NAME')
    self.assertEqual('ASPIRIN', name_td.text)

    # Max Phase 4
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('4 Approved', phase_td.text)

    # Normal molecular formula (C9H8O4)
    molformula_td = self.browser.find_element_by_id('Bck-MOLFORMULA')
    self.assertEqual('C9H8O4', molformula_td.text)

    # --------------------------------------
    # Compound Representations
    # --------------------------------------

    # normal canonical smiles
    canonical_smiles_input = self.browser.find_element_by_id('CompReps-canonicalSmiles')
    canonical_smiles_div = canonical_smiles_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(canonical_smiles_div.get_attribute('data-original-value'), 'CC(=O)Oc1ccccc1C(=O)O')

    canonical_smiles_input = self.browser.find_element_by_id('CompReps-canonicalSmiles-small')
    canonical_smiles_div = canonical_smiles_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(canonical_smiles_div.get_attribute('data-original-value'), 'CC(=O)Oc1ccccc1C(=O)O')

    # normal standard inchi
    standard_inchi_input = self.browser.find_element_by_id('CompReps-standardInchi')
    standard_inchi_div = standard_inchi_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_div.get_attribute('data-original-value'),
                     'InChI=1S/C9H8O4/c1-6(10)13-8-5-3-2-4-7(8)9(11)12/h2-5H,1H3,(H,11,12)')

    standard_inchi_input = self.browser.find_element_by_id('CompReps-standardInchi-small')
    standard_inchi_div = standard_inchi_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_div.get_attribute('data-original-value'),
                     'InChI=1S/C9H8O4/c1-6(10)13-8-5-3-2-4-7(8)9(11)12/h2-5H,1H3,(H,11,12)')

    # normal standard inchi key
    standard_inchi_key_input = self.browser.find_element_by_id('CompReps-standardInchiKey')
    standard_inchi_key_div = standard_inchi_key_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_key_div.get_attribute('data-original-value'),
                     'BSYNRYMUTXBXSQ-UHFFFAOYSA-N')

    standard_inchi_key_input = self.browser.find_element_by_id('CompReps-standardInchiKey-small')
    standard_inchi_key_div = standard_inchi_key_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(standard_inchi_key_div.get_attribute('data-original-value'),
                     'BSYNRYMUTXBXSQ-UHFFFAOYSA-N')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this is a small molecule
    self.assert_molecule_feature('Bck-MolType', True, HOST + '/static/img/molecule_features/mt_small_molecule.svg',
                                 'Molecule Type: small molecule', 'Small Molecule', 'top')
    # Rule of five: No. false
    self.assert_molecule_feature('Bck-RuleOfFive', True, HOST + '/static/img/molecule_features/rule_of_five.svg',
                                 'Rule Of Five: Yes', 'Rule Of Five', 'top')

    # this compound is not first in class
    self.assert_molecule_feature('Bck-FirstInClass', False, HOST + '/static/img/molecule_features/first_in_class.svg',
                                 'First in Class: No', 'First in Class', 'top')

    # Chirality: single stereoisomer: 1
    self.assert_molecule_feature('Bck-Chirality', True, HOST + '/static/img/molecule_features/chirality_1.svg',
                                 'Chirality: Single Stereoisomner', 'Single Stereoisomner', 'top')

    # Ora yes: 'true'
    self.assert_molecule_feature('Bck-Oral', True, HOST + '/static/img/molecule_features/oral.svg',
                                 'Oral: Yes', 'Oral', 'bottom')

    # Topical No: false
    self.assert_molecule_feature('Bck-Topical', False, HOST + '/static/img/molecule_features/topical.svg',
                                 'Topical: No', 'Topical', 'bottom')

    # Black Box No: 0
    self.assert_molecule_feature('Bck-BlackBox', False, HOST + '/static/img/molecule_features/black_box.svg',
                                 'Black Box: No', 'Black Box', 'bottom')

    # Availability Type: Over the counter: 2
    self.assert_molecule_feature('Bck-Availability', True, HOST + '/static/img/molecule_features/availability_2.svg',
                                 'Availability: Over the Counter', 'Over the Counter', 'bottom')

  def test_compound_report_card_scenario_2(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL6963', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # structure not available
    img = self.browser.find_element_by_id('Bck-COMP_IMG')
    self.assertEqual(img.get_attribute('src'), HOST + '/static/img/structure_not_available.png')

    # Max Phase 0
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('0', phase_td.text)

    # --------------------------------------
    # Compound Representations
    # --------------------------------------

    # compound_representations is null, the section must not be shown
    comp_reps_div = self.browser.find_element_by_id('CompoundRepresentations')
    self.assertFalse(comp_reps_div.is_displayed())

    # there are not mechanisms of action, the section must not be shown
    mech_act_div = self.browser.find_element_by_id('MechanismOfAction')
    self.assertFalse(mech_act_div.is_displayed())

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # First in class is undefined: -1
    self.assert_molecule_feature('Bck-FirstInClass', False, HOST + '/static/img/molecule_features/first_in_class.svg',
                                 'First in Class: Undefined', 'First in Class', 'top')

    # Chirality Undefined: -1
    self.assert_molecule_feature('Bck-Chirality', False, HOST + '/static/img/molecule_features/chirality_0.svg',
                                 'Chirality: Undefined', 'Chirality: Undefined', 'top')

    # Prodrug Undefined: -1
    self.assert_molecule_feature('Bck-Prodrug', False, HOST + '/static/img/molecule_features/prodrug.svg',
                                 'Prodrug: Undefined', 'Prodrug', 'top')

    # Availability Type is Undefined: -1
    self.assert_molecule_feature('Bck-Availability', False, HOST + '/static/img/molecule_features/availability_0.svg',
                                 'Availability: Undefined', 'Availability: Undefined', 'bottom')



  def test_compund_report_card_scenario_3(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL2108680', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # protein sctructure
    img = self.browser.find_element_by_id('Bck-COMP_IMG')
    self.assertEqual(img.get_attribute('src'), HOST + '/static/img/protein_structure.png')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this is an Antibody
    self.assert_molecule_feature('Bck-MolType', True, HOST + '/static/img/molecule_features/mt_antibody.svg',
                                 'Molecule Type: Antibody', 'Antibody', 'top')

  def test_compound_report_card_scenario_4(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL6939', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # null name
    name_td = self.browser.find_element_by_id('Bck-PREF_NAME')
    self.assertEqual('Undefined', name_td.text)

    # if synonyms are empty, don't show this row at all
    synonyms_td = self.browser.find_element_by_id('CompNameClass-synonyms')
    synonyms_tr = synonyms_td.find_element_by_xpath('..')
    self.assertFalse(synonyms_tr.is_displayed())

  def test_compound_report_card_scenario_5(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL2109588', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Max Phase 3
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('3 Phase III', phase_td.text)

    # When there is no formula available the row should not be shown at all.
    molformula_td = self.browser.find_element_by_id('Bck-MOLFORMULA')
    molformula_tr = molformula_td.find_element_by_xpath('..')
    self.assertFalse(molformula_tr.is_displayed())

    # If tradenames are empty, don't show that row.
    tradenames_td = self.browser.find_element_by_id('CompNameClass-tradenames')
    tradenames_tr = tradenames_td.find_element_by_xpath('..')
    self.assertFalse(tradenames_tr.is_displayed())

    # if synonyms are empty, don't show this row at all
    tradenames_td = self.browser.find_element_by_id('CompNameClass-tradenames')
    tradenames_tr = tradenames_td.find_element_by_xpath('..')
    self.assertFalse(tradenames_tr.is_displayed())

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Rule of five: No. false
    self.assert_molecule_feature('Bck-RuleOfFive', False, HOST + '/static/img/molecule_features/rule_of_five.svg',
                                 'Rule Of Five: No', 'Rule Of Five', 'top')

  def test_compound_report_card_scenario_6(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL1742989', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Max Phase 2
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('2 Phase II', phase_td.text)

  def test_compound_report_card_scenario_7(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL1742987', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Max Phase 1
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('1 Phase I', phase_td.text)

  def test_compound_report_card_scenario_8(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL55/', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Synonyms should present only entries that are not trade names.
    synonyms_td = self.browser.find_element_by_id('CompNameClass-synonyms')
    tradenames_td = self.browser.find_element_by_id('CompNameClass-tradenames')

    self.assertEqual(
      'GNF-Pf-3680 MB-800 MB-800 [as isethionate] Pentamidine Pentamidine Isetionate RP-2512 RP-2512 [as isethionate]',
      synonyms_td.text)

    self.assertEqual(
      'Nebupent [as isethionate] Pentacarinat [as isethionate] Pentam 300 [as isethionate]',
      tradenames_td.text)

    # Normal download buttons
    download_png_buttons = self.browser.find_elements_by_class_name(
      'CNC-download-png')

    for button in download_png_buttons:
      self.assertEqual(button.get_attribute('href'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL55.png')

    download_svg_buttons = self.browser.find_elements_by_class_name(
      'CNC-download-svg')

    for button in download_svg_buttons:
      self.assertEqual(button.get_attribute('href'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL55.svg')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Chirality: achiral molecule: 2
    self.assert_molecule_feature('Bck-Chirality', False, HOST + '/static/img/molecule_features/chirality_1.svg',
                                 'Chirality: Achiral Molecule', 'Achiral Molecule', 'top')

    # Oral No: false
    self.assert_molecule_feature('Bck-Oral', False, HOST + '/static/img/molecule_features/oral.svg',
                                 'Oral: No', 'Oral', 'bottom')

    # Parenteral Yes: true
    self.assert_molecule_feature('Bck-Parenteral', True, HOST + '/static/img/molecule_features/parenteral.svg',
                                 'Parenteral: Yes', 'Parenteral', 'bottom')

    # Topical Yes: true
    self.assert_molecule_feature('Bck-Topical', True, HOST + '/static/img/molecule_features/topical.svg',
                                 'Topical: Yes', 'Topical', 'bottom')

    # Black Box Warning No: 0
    self.assert_molecule_feature('Bck-Topical', True, HOST + '/static/img/molecule_features/topical.svg',
                                 'Topical: Yes', 'Topical', 'bottom')

    # Availability Type: Prescription Only: 1
    self.assert_molecule_feature('Bck-Availability', True, HOST + '/static/img/molecule_features/availability_1.svg',
                                 'Availability: Prescription Only', 'Prescription Only', 'bottom')

  def test_compound_report_card_scenario_9(self):

    # this compound does not exist!
    self.getURL(HOST + '/compound_report_card/CHEMBL7/', SLEEP_TIME)

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------
    error_msg_p = self.browser.find_element_by_id('CNCCard').find_element_by_class_name('Bck-errormsg')
    self.assertEquals(error_msg_p.text, 'No compound found with id CHEMBL7')

    # --------------------------------------
    # Compound Representations
    # --------------------------------------
    error_msg_p = self.browser.find_element_by_id('CompRepsCard').find_element_by_class_name('Bck-errormsg')
    self.assertEquals(error_msg_p.text, 'No compound found with id CHEMBL7')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------
    error_msg_p = self.browser.find_element_by_id('MoleculeFeaturesCard').find_element_by_class_name('Bck-errormsg')
    self.assertEquals(error_msg_p.text, 'No compound found with id CHEMBL7')

  def test_compound_report_card_scenario_10(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL17/', SLEEP_TIME)

    # --------------------------------------
    # Mechanism of action
    # --------------------------------------

    # 4 mechanisms of action
    mechanisms_of_action_table = self.browser.find_element_by_id('MechOfActCard').find_element_by_tag_name('table')
    mechanisms_of_action_trs = mechanisms_of_action_table.find_elements_by_tag_name('tr')

    texts = [row.text for row in mechanisms_of_action_trs]

    self.assertIn('Carbonic anhydrase I inhibitor CHEMBL261 PubMed', texts)
    self.assertIn('Carbonic anhydrase II inhibitor CHEMBL205 PubMed', texts)
    self.assertIn('Carbonic anhydrase XII inhibitor CHEMBL3242 PubMed', texts)
    self.assertIn('Carbonic anhydrase IV inhibitor CHEMBL3729 PubMed', texts)

  def test_compound_report_card_scenario_11(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL1201822/', SLEEP_TIME)

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this is an Enzyme
    self.assert_molecule_feature('Bck-MolType', True, HOST + '/static/img/molecule_features/mt_enzyme.svg',
                                 'Molecule Type: Enzyme', 'Enzyme', 'top')

    # Availability Type: Discontinued: 0
    self.assert_molecule_feature('Bck-Availability', True, HOST + '/static/img/molecule_features/availability_0.svg',
                                 'Availability: Discontinued', 'Discontinued', 'bottom')

  def test_compound_report_card_scenario_12(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL254328/', SLEEP_TIME)

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this compound is first in class
    self.assert_molecule_feature('Bck-FirstInClass', True, HOST + '/static/img/molecule_features/first_in_class.svg',
                                 'First in Class: Yes', 'First in Class', 'top')

  def test_compound_report_card_scenario_13(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL6995/', SLEEP_TIME)

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Chirality: achiral molecule: 0
    self.assert_molecule_feature('Bck-Chirality', True, HOST + '/static/img/molecule_features/chirality_0.svg',
                                 'Chirality: Racemic Mixture', 'Racemic Mixture', 'top')

    # Is no prodrug: 0
    self.assert_molecule_feature('Bck-Prodrug', False, HOST + '/static/img/molecule_features/prodrug.svg',
                                 'Prodrug: No', 'Prodrug', 'top')

  def test_compound_report_card_scenario_13(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL2106520/', SLEEP_TIME)

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Is prodrug: 1
    self.assert_molecule_feature('Bck-Prodrug', True, HOST + '/static/img/molecule_features/prodrug.svg',
                                 'Prodrug: Yes', 'Prodrug', 'top')

  def test_compound_report_card_scenario_14(self):

    self.getURL(HOST + '/compound_report_card/CHEMBL35/', SLEEP_TIME)

     # --------------------------------------
    # Molecule Features
    # --------------------------------------

     # Black Box No: 0
    self.assert_molecule_feature('Bck-BlackBox', True, HOST + '/static/img/molecule_features/black_box.svg',
                                 'Black Box: Yes', 'Black Box', 'bottom')


if __name__ == '__main__':
  unittest.main()

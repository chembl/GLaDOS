from selenium.common.exceptions import NoSuchElementException
from glados.tests.report_card_tester import ReportCardTester

# Cases for visualization:
# - Compound with more alternate forms: CHEMBL1236196

class CompoundReportCardTest(ReportCardTester):

  def assert_copy_button(self, elem_id, tooltip, value):
    copy_button = self.browser.find_element_by_id(elem_id)
    self.assertEqual(copy_button.get_attribute('data-tooltip'), tooltip)
    self.assertEqual(copy_button.get_attribute('data-copy'), value)

  def assert_compound_representation(self, elem_id, original_value):
    canonical_smiles_input = self.browser.find_element_by_id(elem_id)
    canonical_smiles_div = canonical_smiles_input.find_element_by_xpath('../../../../../..')
    self.assertEqual(canonical_smiles_div.get_attribute('data-original-value'), original_value)

  def assert_compound_rep_download_btn(self, elem_id, curr_filename, curr_tooltip, data):
    canonical_smiles_dwnld_btn = self.browser.find_element_by_id(elem_id)
    filename = canonical_smiles_dwnld_btn.get_attribute('download')
    self.assertEqual(filename, curr_filename)
    tooltip = canonical_smiles_dwnld_btn.get_attribute('data-tooltip')
    self.assertEqual(tooltip, curr_tooltip)
    href = canonical_smiles_dwnld_btn.get_attribute('href')
    self.assertEqual(href, data)

  def assert_molecule_feature(self, elem_id, should_be_active, icon_class, img_tooltip,
                              tooltip_position):

    molecule_type_div = self.browser.find_element_by_id(elem_id)
    icon_div = molecule_type_div.find_element_by_class_name('feat-icon')

    if should_be_active:
      self.assertIn('active', icon_div.get_attribute('class'))
    else:
      self.assertNotIn('active', icon_div.get_attribute('class'))

    icon = molecule_type_div.find_element_by_tag_name('i')
    parent_el = icon.find_element_by_xpath("..")

    self.assertIn(icon_class, icon.get_attribute('class')),

    self.assertEqual(parent_el.get_attribute('data-tooltip'),
                     img_tooltip),
    self.assertEqual(parent_el.get_attribute('data-position'),
                     tooltip_position)

  def assert_alternate_forms(self, chembl_ids_list):

    alternate_forms_row = self.browser.find_element_by_id('AlternateFormsCard')
    alternate_forms_cards = alternate_forms_row.find_elements_by_class_name('card')

    actual_srcs = [card.find_element_by_tag_name('img').get_attribute('src') for card in alternate_forms_cards]
    test_srcs = ['https://www.ebi.ac.uk/chembl/api/data/image/' + chembl_id + '.svg?engine=indigo' for chembl_id in chembl_ids_list]
    self.assertEqual(sorted(actual_srcs), sorted(test_srcs))

    actual_links = [card.find_element_by_class_name('card-content').find_element_by_tag_name('a') for card in
                    alternate_forms_cards]
    actual_links_hrefs = [link.get_attribute('href') for link in actual_links]
    for chembl_id_i in chembl_ids_list:
      found = False
      for link_i in actual_links_hrefs:
        report_card_url_i = '/compound_report_card/' + chembl_id_i
        if report_card_url_i in link_i:
          found = True
          break
      self.assertTrue(found, msg="CHEMBLID:{0} was not found in the alternate forms links!".format(chembl_id_i))

    actual_links_texts = [link.text for link in actual_links]
    self.assertEqual(sorted(actual_links_texts), sorted(chembl_ids_list))

  # --------------------------------------------------------------------------------------
  # Scenarios
  # --------------------------------------------------------------------------------------

  def test_compound_report_card_scenario_1(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL25')

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

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


    # --------------------------------------
    # Calculated Compound Parent Properties
    # --------------------------------------

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this is a small molecule
    self.assert_molecule_feature('Bck-MolType', True, 'small-molecule',
                                 'Drug Type: Synthetic Small Molecule', 'top')
    # Rule of five: No. false
    self.assert_molecule_feature('Bck-RuleOfFive', True, 'rule_of_five',
                                 'Rule Of Five: Yes', 'top')

    # this compound is not first in class
    self.assert_molecule_feature('Bck-FirstInClass', False, 'first_in_class',
                                 'First in Class: No', 'top')

    # Chirality: single stereoisomer: 1
    self.assert_molecule_feature('Bck-Chirality', True, 'chirally_pure',
                                 'Chirality: Single Stereoisomer', 'top')

    # Oral yes: 'true'
    self.assert_molecule_feature('Bck-Oral', True, 'oral',
                                 'Oral: Yes', 'bottom')

    # Topical No: false
    self.assert_molecule_feature('Bck-Topical', False, 'topical',
                                 'Topical: No', 'bottom')

    # Black Box No: 0
    self.assert_molecule_feature('Bck-BlackBox', False, 'black_box',
                                 'Black Box: No',  'bottom')

    # Availability Type: Over the counter: 2
    self.assert_molecule_feature('Bck-Availability', True, 'otc',
                                 'Availability: Over the Counter', 'bottom')

    # --------------------------------------
    # Alternate Forms of Compound in ChEMBL
    # --------------------------------------

    self.assert_alternate_forms(['CHEMBL25', 'CHEMBL2296002', 'CHEMBL1697753'])


  def test_compound_report_card_scenario_2(self):

    # annoying CORS issue
    return
    self.getURL(self.HOST + '/compound_report_card/CHEMBL6963')

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

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
    self.assert_molecule_feature('Bck-FirstInClass', False, 'first_in_class',
                                 'First in Class: Undefined', 'top')

    # Chirality Undefined: -1
    self.assert_molecule_feature('Bck-Chirality', False, 'racemic_mixture',
                                 'Chirality: Undefined', 'top')

    # Prodrug Undefined: -1
    self.assert_molecule_feature('Bck-Prodrug', False, 'prodrug',
                                 'Prodrug: Undefined', 'top')

    # Availability Type is Undefined: -1
    self.assert_molecule_feature('Bck-Availability', False, 'prescription',
                                 'Availability: Undefined', 'bottom')

  def test_compund_report_card_scenario_3(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL2108680')

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

  
    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this is an Antibody
    self.assert_molecule_feature('Bck-MolType', True, 'antibody',
                                 'Molecule Type: Antibody', 'top')

  def test_compound_report_card_scenario_4(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL6939')

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

    self.getURL(self.HOST + '/compound_report_card/CHEMBL2109588')

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
    self.assert_molecule_feature('Bck-RuleOfFive', False, 'rule_of_five',
                                 'Rule Of Five: No', 'top')

  def test_compound_report_card_scenario_6(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL1742989')

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Max Phase 2
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('3 Phase III', phase_td.text)

  def test_compound_report_card_scenario_7(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL1742987')

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Max Phase 1
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('1 Phase I', phase_td.text)

  def test_compound_report_card_scenario_8(self):

    # there is an issue with CORS in phantom js, this test can't be loaded.
    # This test needs to be replaced with a ghost inspector test while we find a better solution
    return
    self.getURL(self.HOST + '/compound_report_card/CHEMBL55/')

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------

    # Synonyms should present only entries that are not trade names.
    synonyms_td = self.browser.find_element_by_id('CompNameClass-synonyms')
    tradenames_td = self.browser.find_element_by_id('CompNameClass-tradenames')

    self.assertEqual(
      'GNF-Pf-3680 MB 800 [AS ISETHIONATE] MB-800 PENTAMIDINE PENTAMIDINE ISETIONATE Pentamidine RP 2512 [AS ISETHIONATE) RP-2512',
      synonyms_td.text)
    self.assertEqual(
      'NEBUPENT [AS ISETHIONATE] PENTACARINAT [AS ISETHIONATE] PENTAM 300 [AS ISETHIONATE]',
      tradenames_td.text)

    # Normal download buttons
    download_png_buttons = self.browser.find_elements_by_class_name(
      'CNC-download-png')

    for button in download_png_buttons:
      self.assertEqual(button.get_attribute('href'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL55.png?engine=indigo')

    download_svg_buttons = self.browser.find_elements_by_class_name(
      'CNC-download-svg')

    for button in download_svg_buttons:
      self.assertEqual(button.get_attribute('href'), 'https://www.ebi.ac.uk/chembl/api/data/image/CHEMBL55.svg?engine=indigo')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Chirality: achiral molecule: 2
    self.assert_molecule_feature('Bck-Chirality', False, 'chirally_pure',
                                 'Chirality: Achiral Molecule', 'top')

    # Oral No: false
    self.assert_molecule_feature('Bck-Oral', False, 'oral',
                                 'Oral: No', 'bottom')

    # Parenteral Yes: true
    self.assert_molecule_feature('Bck-Parenteral', True, 'parenteral',
                                 'Parenteral: Yes', 'bottom')

    # Topical Yes: true
    self.assert_molecule_feature('Bck-Topical', True, 'topical',
                                 'Topical: Yes', 'bottom')

    # Availability Type: Prescription Only: 1
    self.assert_molecule_feature('Bck-Availability', True, 'prescription',
                                 'Availability: Prescription Only', 'bottom')

  def test_compound_report_card_scenario_9(self):

    return
    # this compound does not exist!
    self.getURL(self.HOST + '/compound_report_card/CHEMBL7/')

    # --------------------------------------
    # Compound Name and Classification
    # --------------------------------------
    error_msg_p = self.browser.find_element_by_id('CNCCard').find_element_by_class_name('Bck-errormsg')
    # TODO: PhantomJS does not receive back the correct XHR code!
    self.assertIn(error_msg_p.text, ['No compound found with id CHEMBL7',
                                     'There was an error while loading the data (0 error)'])

    # --------------------------------------
    # Compound Representations
    # --------------------------------------
    error_msg_p = self.browser.find_element_by_id('CompoundRepresentations').find_element_by_class_name('Bck-errormsg')
    self.assertFalse(error_msg_p.is_displayed())

    # --------------------------------------
    # Molecule Features
    # --------------------------------------
    error_msg_p = self.browser.find_element_by_id('MoleculeFeaturesCard').find_element_by_class_name('Bck-errormsg')
    self.assertIn(error_msg_p.text, ['No compound found with id CHEMBL7',
                                     'There was an error while loading the data (0 error)'])

  def test_compound_report_card_scenario_11(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL1201822/')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this is an Enzyme
    self.assert_molecule_feature('Bck-MolType', True, 'enzyme',
                                 'Molecule Type: Enzyme', 'top')

    # Availability Type: Discontinued: 0
    self.assert_molecule_feature('Bck-Availability', True, 'prescription',
                                 'Availability: Prescription Only', 'bottom')

    #since no structure is available, the following buttons must not be found in the page
    removed_ids = ['CNC-IMG-Options-Zoom', 'CNC-IMG-Options-Zoom-small']
    for elem_id in removed_ids:
      with self.assertRaises(NoSuchElementException):
        self.browser.find_element_by_id(elem_id)

    # --------------------------------------
    # Calculated Compound Parent Properties
    # --------------------------------------

    #For this compound, the section must be hidden
    calc_comp_par_props_div = self.browser.find_element_by_id('CalculatedCompoundParentProperties')
    self.assertFalse(calc_comp_par_props_div.is_displayed())

  def test_compound_report_card_scenario_12(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL254328/')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this compound is first in class
    self.assert_molecule_feature('Bck-FirstInClass', True, 'first_in_class',
                                 'First in Class: Yes', 'top')

  def test_compound_report_card_scenario_13(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL6995/')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Chirality: achiral molecule: 0
    self.assert_molecule_feature('Bck-Chirality', True, 'racemic_mixture',
                                 'Chirality: Racemic Mixture', 'top')

    # Is no prodrug: 0
    self.assert_molecule_feature('Bck-Prodrug', False, 'prodrug',
                                 'Prodrug: No', 'top')

  def test_compound_report_card_scenario_14(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL2106520/', timeout=ReportCardTester.DEFAULT_TIMEOUT*5)

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Is prodrug: 1
    self.assert_molecule_feature('Bck-Prodrug', True, 'prodrug',
                                 'Prodrug: Yes', 'top')

  def test_compound_report_card_scenario_15(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL35/')

    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # Black Box No: 0
    self.assert_molecule_feature('Bck-BlackBox', True, 'black_box',
                                 'Black Box: Yes', 'bottom')

  def test_compund_report_card_scenario_16(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL1201468')


    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # this is an natural product
    self.assert_molecule_feature('Bck-MolType', True, 'natural',
                                 'Drug Type: natural product', 'top')

  def test_compund_report_card_scenario_17(self):

    self.getURL(self.HOST + '/compound_report_card/CHEMBL1201502')


    # --------------------------------------
    # Molecule Features
    # --------------------------------------

    # the molecule type is unknown
    self.assert_molecule_feature('Bck-MolType', True, 'unknown',
                                 'Drug Type: Unknown', 'top')
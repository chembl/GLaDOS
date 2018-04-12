from glados.tests.report_card_tester import ReportCardTester
from selenium.webdriver.common.by import By

class TargetReportCardTest(ReportCardTester):
  # --------------------------------------------------------------------------------------
  # Scenarios
  # --------------------------------------------------------------------------------------

  def test_target_report_card_scenario_1(self):
    self.getURL(self.HOST + '/target_report_card/CHEMBL223')

    # --------------------------------------
    # Target Name and Classification
    # --------------------------------------

    # Id is CHEMBL223
    id_field = self.browser.find_element_by_id('Bck-Target_ID')
    self.assertEqual(id_field.text, 'CHEMBL223')

    # Target Type is SINGLE PROTEIN
    target_type = self.browser.find_element_by_id('Bck-Target_Type')
    self.assertEqual(target_type.text, 'SINGLE PROTEIN')

    # Prefered name is Alpha-1d adrenergic receptor
    pref_name = self.browser.find_element_by_id('Bck-Target_Pref_Name')
    self.assertEqual(pref_name.text, 'Alpha-1d adrenergic receptor')

    synonyms = self.browser.find_element_by_id('Bck-Target_Synonyms')
    # self.assertEqual(synonyms.text,
    #                  'ADRA1A ADRA1D Alpha-1D adrenergic receptor Alpha-1A adrenergic receptor'
    #                   ' Alpha-1D adrenoceptor Alpha-1D adrenoreceptor Alpha-adrenergic receptor 1a')

    organism = self.browser.find_element_by_id('Bck-Target_Organism')
    self.assertEqual(organism.text, 'Homo sapiens')

    # it is not a species group
    specs_group = self.browser.find_element_by_id('Bck-Target_SpecsGroup')
    self.assertEqual(specs_group.text, 'No')

    # Protein target classification
    protein_target_classification = self.browser.find_element_by_id('Bck-Target-Classification')
    self.assertEqual(protein_target_classification.text,
                     '- Membrane receptor > Family A G protein-coupled receptor > '
                     'Small molecule receptor (family A GPCR) > Monoamine receptor > Adrenergic receptor')

    # --------------------------------------
    # Approved Drugs and Clinical Candidates
    # --------------------------------------

    # for this one this section muse be hidden
    adcc_div = self.browser.find_element_by_id('ApprovedDrugsAndClinicalCandidates')
    self.assertFalse(adcc_div.is_displayed())

  def test_target_report_card_scenario_2(self):
    self.getURL(self.HOST + '/target_report_card/CHEMBL2364672')

    # --------------------------------------
    # Target Name and Classification
    # --------------------------------------

    # This is a species group
    specs_group = self.browser.find_element_by_id('Bck-Target_SpecsGroup')
    self.assertEqual(specs_group.text, 'Yes')

    # --------------------------------------
    # Approved Drugs and Clinical Candidates
    # --------------------------------------

    # adcc_table = self.browser.find_element_by_id('ADCCTable-large')
    # texts_should_be = ['CHEMBL1617 RIFABUTIN Bacterial DNA-directed RNA polymerase inhibitor 4',
    #                    'CHEMBL1660 RIFAMPICIN Bacterial DNA-directed RNA polymerase inhibitor 4',
    #                    'CHEMBL374478 RIFAXIMIN Bacterial DNA-directed RNA polymerase inhibitor 4',
    #                    'CHEMBL444633 RIFAPENTINE Bacterial DNA-directed RNA polymerase inhibitor 4']
    # self.assert_table_any_order(adcc_table,texts_should_be)




  def test_target_report_card_scenario_3(self):
    self.getURL(self.HOST + '/target_report_card/CHEMBL2363053')

    # --------------------------------------
    # Target Name and Classification
    # --------------------------------------

    # this has no synonyms
    synonyms = self.browser.find_element_by_id('Bck-Target_Synonyms')
    self.assertEqual(synonyms.text, '---')

    # this has no organism defined
    synonyms = self.browser.find_element_by_id('Bck-Target_Organism')
    self.assertEqual(synonyms.text, '---')

     # Protein target classification
    protein_target_classification = self.browser.find_element_by_id('Bck-Target-Classification')
    self.assertEqual(protein_target_classification.text,
                     'Not Applicable')

    # --------------------------------------
    # Target Components
    # --------------------------------------

    # There are no target components for this one
    components_section = self.browser.find_element_by_id('TargetComponents')
    self.assertEqual(components_section.value_of_css_property('display'), 'none')

  def test_target_report_card_scenario_4(self):
    self.getURL(self.HOST + '/target_report_card/CHEMBL2363965')

    # Protein target classification
    # This one has 60 target components (the highest number in the database), and it only has 2 classifications
    protein_target_classification = self.browser.find_element_by_id('Bck-Target-Classification')
    self.assertEqual(protein_target_classification.text,
                     '- Other cytosolic protein\n'
                     '- Unclassified protein')




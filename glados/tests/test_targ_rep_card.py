from report_card_tester import ReportCardTester
from selenium.webdriver.common.by import By



class TargetReportCardTest(ReportCardTester):

  # --------------------------------------------------------------------------------------
  # Scenarios
  # --------------------------------------------------------------------------------------

  def test_compound_report_card_scenario_1(self):
    self.getURL(self.HOST + '/target_report_card/CHEMBL223', self.SLEEP_TIME)

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
    self.assertEqual(synonyms.text,
                     'ADRA1A ADRA1D Alpha-1A adrenergic receptor Alpha-1D adrenergic receptor Alpha-1D adrenoceptor Alpha-1D adrenoreceptor Alpha-adrenergic receptor 1a')

    organism = self.browser.find_element_by_id('Bck-Target_Organism')
    self.assertEqual(organism.text, 'Homo sapiens')

    # it is not a species group
    specs_group = self.browser.find_element_by_id('Bck-Target_SpecsGroup')
    self.assertEqual(specs_group.text, 'No')

    # Embed trigger
    self.assert_embed_trigger('TNameClassificationCard', 'target', 'name_and_classification', 'CHEMBL223')



  def test_compound_report_card_scenario_2(self):
    self.getURL(self.HOST + '/target_report_card/CHEMBL2364672', self.SLEEP_TIME)

    # --------------------------------------
    # Target Name and Classification
    # --------------------------------------

    # This is a species group
    specs_group = self.browser.find_element_by_id('Bck-Target_SpecsGroup')
    self.assertEqual(specs_group.text, 'Yes')

    # --------------------------------------
    # Target Components
    # --------------------------------------
    components_table = self.browser.find_element_by_id('BCK-Components-large')
    rows = components_table.find_elements(By.TAG_NAME, "tr")[1::]
    accessions_should_be = ['P0A7Z4', 'P0A8V2', 'P0A8T7', 'P0A800']

    # Here we need to add the other lists for the other properties qhen they are available in the web services.
    for row, accession in zip(rows, accessions_should_be):
      accestion_td = row.find_element_by_class_name('Bck-Target-Component-Accession')
      self.assertEqual(accestion_td.text, accession)


  def test_compound_report_card_scenario_3(self):
    self.getURL(self.HOST + '/target_report_card/CHEMBL2363053', self.SLEEP_TIME)

    # --------------------------------------
    # Target Name and Classification
    # --------------------------------------

    #this has no synonyms
    synonyms = self.browser.find_element_by_id('Bck-Target_Synonyms')
    self.assertEqual(synonyms.text,'---')

    #this has no organism defined
    synonyms = self.browser.find_element_by_id('Bck-Target_Organism')
    self.assertEqual(synonyms.text,'---')

    # --------------------------------------
    # Target Components
    # --------------------------------------

    # There are no target components for this one
    components_section = self.browser.find_element_by_id('TargetComponents')
    self.assertEqual(components_section.value_of_css_property('display'), 'none')


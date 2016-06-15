from selenium import webdriver
import unittest
import time
from selenium.common.exceptions import NoSuchElementException

HOST = 'http://127.0.0.1:8000'
SLEEP_TIME = 0.5


class TargetReportCardTest(unittest.TestCase):
  IMPLICIT_WAIT = 1

  def setUp(self):
    self.browser = webdriver.Firefox()
    self.browser.set_window_size(1024, 768)
    self.browser.implicitly_wait(self.IMPLICIT_WAIT)

  def tearDown(self):
    self.browser.quit()

  def getURL(self, url, sleeptime):
    print('\nScenario:')
    print(url)
    self.browser.get(url)
    time.sleep(sleeptime)

  def assert_embed_trigger(self, card_id, resource_type, section_name, chembl_id):

    card = self.browser.find_element_by_id(card_id)
    embed_trigger = card.find_element_by_class_name('embed-btn')
    self.assertEqual(embed_trigger.get_attribute('href'), '%s/%s_report_card/%s/#embed-modal-for-%s' % (HOST, resource_type, chembl_id, card_id) )
    self.assertEqual(embed_trigger.get_attribute('data-embed-sect-name'), section_name)
    self.assertEqual(embed_trigger.get_attribute('data-resource-type'), resource_type)


  # --------------------------------------------------------------------------------------
  # Scenarios
  # --------------------------------------------------------------------------------------

  def test_compound_report_card_scenario_1(self):
    self.getURL(HOST + '/target_report_card/CHEMBL223', SLEEP_TIME)

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

    # --------------------------------------
    # Embed trigger
    # --------------------------------------

    self.assert_embed_trigger('TNameClassificationCard', 'target', 'name_and_classification', 'CHEMBL223')


  def test_compound_report_card_scenario_2(self):
    self.getURL(HOST + '/target_report_card/CHEMBL2364672', SLEEP_TIME)

    # --------------------------------------
    # Target Name and Classification
    # --------------------------------------

    # This is a species group
    specs_group = self.browser.find_element_by_id('Bck-Target_SpecsGroup')
    self.assertEqual(specs_group.text, 'Yes')


  def test_compound_report_card_scenario_3(self):
    self.getURL(HOST + '/target_report_card/CHEMBL2363053', SLEEP_TIME)

    # --------------------------------------
    # Target Name and Classification
    # --------------------------------------

    #this has no synonyms
    synonyms = self.browser.find_element_by_id('Bck-Target_Synonyms')
    self.assertEqual(synonyms.text,'---')

    #this has no organism defined
    synonyms = self.browser.find_element_by_id('Bck-Target_Organism')
    self.assertEqual(synonyms.text,'---')



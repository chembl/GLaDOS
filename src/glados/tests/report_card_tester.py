import unittest
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
import traceback
import sys

class ReportCardTester(unittest.TestCase):

  HOST = 'http://127.0.0.1:8000'
  DEFAULT_TIMEOUT = 60

  IMPLICIT_WAIT = 1

  def setUp(self):
    try:
      self.browser = webdriver.Firefox()
      self.browser.set_window_size(1024, 768)
      self.browser.implicitly_wait(self.IMPLICIT_WAIT)
    except:
      print("CRITICAL ERROR: It was not possible to start the Firefox Selenium driver due to:", file=sys.stderr)
      traceback.print_exc();
      sys.exit(1)

  def tearDown(self):
    self.browser.quit()

  def getURL(self, url, timeout=DEFAULT_TIMEOUT, wait_for_glados_ready=True):
    print('\nScenario:')
    print(url)
    self.browser.get(url)
    start_time = time.time()
    if wait_for_glados_ready:
      loaded = False
      while not loaded and time.time()-start_time < timeout:
        try:
          elem = self.browser.find_element_by_id("GLaDOS-page-loaded")
          if elem.get_property('innerHTML') == 'YES':
            loaded = True
          else:
            print("Loading '{0}' ...".format(url))
        except:
          self.fail("Error: Div element 'GLaDOS-page-loaded' is missing!")
        time.sleep(1)
      self.assertTrue(loaded, "Error: '{0}' failed to load under {1} seconds!".format(url, timeout))

  def assert_embed_trigger(self, card_id, resource_type, section_name, chembl_id):

    card = self.browser.find_element_by_id(card_id)
    embed_trigger = card.find_element_by_class_name('embed-btn')
    self.assertEqual(embed_trigger.get_attribute('href'), '%s/%s_report_card/%s/#embed-modal-for-%s' % (self.HOST, resource_type, chembl_id, card_id) )
    self.assertEqual(embed_trigger.get_attribute('data-embed-sect-name'), section_name)
    self.assertEqual(embed_trigger.get_attribute('data-resource-type'), resource_type)

  def assert_table(self, table, texts_should_be):

    rows = table.find_elements(By.TAG_NAME, "tr")[1::]
    for row, text in zip(rows, texts_should_be):
      self.assertEqual(row.text, text)

  def assert_table_any_order(self, table, texts_should_be):
    rows = table.find_elements(By.TAG_NAME, "tr")[1::]
    for row in rows:
      self.assertIn(row.text, texts_should_be)

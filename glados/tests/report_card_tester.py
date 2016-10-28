import unittest
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
import traceback
import sys

class ReportCardTester(unittest.TestCase):

  HOST = 'http://127.0.0.1:8000'
  SLEEP_TIME = 2

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

  def getURL(self, url, sleeptime):
    print('\nScenario:')
    print(url)
    self.browser.get(url)
    time.sleep(sleeptime)

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

from selenium import webdriver
import unittest

class CompoundReportCardTest(unittest.TestCase):

  def setUp(self):
    self.browser = webdriver.Firefox()
    self.browser.implicitly_wait(3)

  def tearDown(self):
    self.browser.quit()

  def test_title_is_correct(self):
    self.browser.get('http://127.0.0.1:8000/compound_report_card/')
    self.assertIn('Compound Report Card', self.browser.title)

if __name__ == '__main__':
  unittest.main()
from selenium import webdriver
import unittest

class CompoundReportCardTest(unittest.TestCase):

  def setUp(self):
    self.browser = webdriver.Firefox()
    self.browser.implicitly_wait(3)

  def tearDown(self):
    self.browser.quit()

  def test_compound_name(self):

    self.browser.get('http://127.0.0.1:8000/compound_report_card/CHEMBL25')
    name_td = self.browser.find_element_by_id('Bck-PREF_NAME')
    self.assertEqual('ASPIRIN', name_td.text)

    # this one has a null name
    self.browser.get('http://127.0.0.1:8000/compound_report_card/CHEMBL6939')
    self.browser.implicitly_wait(3)
    name_td = self.browser.find_element_by_id('Bck-PREF_NAME')
    self.assertEqual('Undefined', name_td.text)

  def test_compound_phase(self):

    # Max Phase 4
    self.browser.get('http://127.0.0.1:8000/compound_report_card/CHEMBL25')
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('4 Approved', phase_td.text)

    # Max Phase 3
    self.browser.get('http://127.0.0.1:8000/compound_report_card/CHEMBL2109588')
    self.browser.implicitly_wait(3)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('3 Phase III', phase_td.text)

    # Max Phase 2
    self.browser.get('http://127.0.0.1:8000/compound_report_card/CHEMBL1742989')
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('2 Phase II', phase_td.text)

    # Max Phase 1
    self.browser.get('http://127.0.0.1:8000/compound_report_card/CHEMBL1742987')
    self.browser.implicitly_wait(3)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('1 Phase I', phase_td.text)

    # Max Phase 0
    self.browser.get('http://127.0.0.1:8000/compound_report_card/CHEMBL6963')
    self.browser.implicitly_wait(3)
    phase_td = self.browser.find_element_by_id('Bck-MAX_PHASE')
    self.assertEqual('0', phase_td.text)








if __name__ == '__main__':
  unittest.main()
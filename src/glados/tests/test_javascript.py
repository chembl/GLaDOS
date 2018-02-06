from glados.tests.report_card_tester import ReportCardTester
import time


# The tests for the javascript code only (not backbone views and DOM) can be seen just by browsing <host>/js_tests/
# This file automates the process of looking at the page and checking if it is correct
class JavascriptTest(ReportCardTester):

  def tearDown(self):
    self.browser.quit()
    ReportCardTester.SINGLETON_BROWSER = None

  def test_javascript_code_only(self):
    url = self.HOST + '/js_tests/'
    self.getURL(url, wait_for_glados_ready=False)
    timeout = ReportCardTester.DEFAULT_TIMEOUT*2
    loaded = False
    start_time = time.time()
    jasmine_alert_elem = None
    jasmine_failed_elem = None
    jasmine_passed_elem = None

    while not loaded and time.time() - start_time < timeout:
      if jasmine_alert_elem is None:
        try:
          jasmine_alert_elem = self.browser.find_element_by_class_name('jasmine-alert')
        except:
          pass
      else:
        try:
          jasmine_failed_elem = jasmine_alert_elem.find_element_by_class_name('jasmine-failed')
          loaded = jasmine_failed_elem is not None
        except:
          pass
        try:
          jasmine_passed_elem = jasmine_alert_elem.find_element_by_class_name('jasmine-passed')
          loaded = jasmine_passed_elem is not None
        except:
          pass
        if not loaded:
          print("Loading {0} ...".format(url))
          time.sleep(1)

    self.assertTrue(loaded, "Error: '{0}' failed to load under {1} seconds!".format(url, timeout))

    if jasmine_failed_elem is not None:
      failures_parent = self.browser.find_element_by_class_name('jasmine-failures')
      fails = failures_parent.find_elements_by_class_name('jasmine-failed')
      errors = ''
      for fail_i in fails:
        desc = self.browser.find_element_by_class_name('jasmine-description').find_element_by_tag_name('a').text
        msg = self.browser.find_element_by_class_name('jasmine-result-message').text
        stack = self.browser.find_element_by_class_name('jasmine-stack-trace').text
        errors += "ERROR_DESC:{0}\nERROR_MSG:{1}\nERROR_STACK:\n{2}\n".format(desc, msg, stack)

      self.fail("Jasmine test failed:\n{0}\n{1}".format(getattr(jasmine_failed_elem, 'text', 'Unknown error text!'), errors))

    elif jasmine_passed_elem is not None:
      summary_text = jasmine_passed_elem.text
      self.assertIn(', 0 failures', summary_text, 'Check the javascript tests out! ' + self.HOST + '/js_tests/' )
    else:
      self.fail("Could not find jasmine passed nor failed output!")




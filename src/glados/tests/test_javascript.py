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
    tests_summary = None
    timeout = ReportCardTester.DEFAULT_TIMEOUT*2
    loaded = False
    start_time = time.time()
    while not loaded and time.time() - start_time < timeout:
      try:
        elem = self.browser.find_element_by_class_name('jasmine-alert')\
          .find_element_by_class_name('jasmine-failed')
        loaded = True
      except:
        pass
      try:
        elem = self.browser.find_element_by_class_name('jasmine-alert')\
          .find_element_by_class_name('jasmine-passed')
        loaded = True
      except:
        pass
      print("Loading {0} ...".format(url))
      time.sleep(1)
    self.assertTrue(loaded, "Error: '{0}' failed to load under {1} seconds!".format(url, timeout))
    try:
      tests_summary = self.browser.find_element_by_class_name('jasmine-alert')\
        .find_element_by_class_name('jasmine-failed')
    except:
      pass
    # Fails if the jasmine tests failed
    if tests_summary and tests_summary.text:
      failures_parent = self.browser.find_element_by_class_name('jasmine-failures')
      fails = failures_parent.find_elements_by_class_name('jasmine-failed')
      errors = ''
      for fail_i in fails:
        desc = self.browser.find_element_by_class_name('jasmine-description').find_element_by_tag_name('a').text
        msg = self.browser.find_element_by_class_name('jasmine-result-message').text
        stack = self.browser.find_element_by_class_name('jasmine-stack-trace').text
        errors += "ERROR_DESC:{0}\nERROR_MSG:{1}\nERROR_STACK:\n{2}\n".format(desc, msg, stack)

      self.fail("Jasmine test failed:\n{0}\n{1}".format(tests_summary.text, errors))

    try:
      tests_summary = self.browser.find_element_by_class_name('jasmine-alert')\
        .find_element_by_class_name('jasmine-passed')
    except:
      self.fail("Could not find jasmine passed output!")

    summary_text = tests_summary.text

    self.assertIn(', 0 failures', summary_text, 'Check the javascript tests out! ' + self.HOST + '/js_tests/' )




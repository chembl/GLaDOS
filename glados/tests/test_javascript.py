from glados.tests.report_card_tester import ReportCardTester
import traceback

# The tests for the javascript code only (not backbone views and DOM) can be seen just by browsing <host>/js_tests/
# This file automates the process of looking at the page and checking if it is correct
class JavascriptTest(ReportCardTester):

  def test_javascript_code_only(self):

    self.getURL(self.HOST + '/js_tests/', ReportCardTester.SLEEP_TIME * 20)
    tests_summary = None
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




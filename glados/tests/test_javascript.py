from report_card_tester import ReportCardTester

# The tests for the javascript code only (not backbone views and DOM) can be seen just by browsing <host>/js_tests/
# This file automates the process of looking at the page and checking if it is correct
class JavascriptTest(ReportCardTester):

  def test_javascript_code_only(self):

    self.getURL(self.HOST + '/js_tests/', self.SLEEP_TIME * 10)

    tests_summary = self.browser.find_element_by_class_name('jasmine-alert').find_element_by_class_name('jasmine-passed')

    summary_text = tests_summary.text

    self.assertIn(', 0 failures', summary_text, 'Check the javascript tests out! ' + self.HOST + '/js_tests/' )



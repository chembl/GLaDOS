import unittest
import time
import traceback
import sys
from selenium.webdriver import Firefox
from selenium.webdriver.firefox.options import Options


# The tests for the javascript code only (not backbone views and DOM) can be seen just by browsing <host>/js_tests/
# This file automates the process of looking at the page and checking if it is correct
class JavascriptTest(unittest.TestCase):

    FIREFOX_OPTIONS = Options()
    FIREFOX_OPTIONS.add_argument('--headless')
    SINGLETON_BROWSER = None
    DEFAULT_TIMEOUT = 60
    HOST = 'http://127.0.0.1:8000'

    @classmethod
    def instantiateBrowser(cls):
        if JavascriptTest.SINGLETON_BROWSER is None:
            retries = 0
            created = False
            while not created and retries < 3:
                try:
                    JavascriptTest.SINGLETON_BROWSER = Firefox(firefox_options=cls.FIREFOX_OPTIONS)
                    created = True
                except:
                    retries += 1
                    print("CRITICAL ERROR: It was not possible to start the Browser Selenium driver due to:",
                          file=sys.stderr)
                    time.sleep(5)
                    traceback.print_exc()
            if not created:
                raise Exception('Unable to start browser after {0} retries.'.format(retries))

    def setUp(self):
        JavascriptTest.instantiateBrowser()
        self.browser = JavascriptTest.SINGLETON_BROWSER

    def getURL(self, url):
        print('\nGetting Url:')
        print(url)
        self.browser.get(url)

    def test_javascript_code_only(self):
        print('Testing javascript')
        url = self.HOST + '/js_tests/'
        self.getURL(url)
        timeout = JavascriptTest.DEFAULT_TIMEOUT * 2
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

            self.fail(
                "Jasmine test failed:\n{0}\n{1}".format(getattr(jasmine_failed_elem, 'text', 'Unknown error text!'),
                                                        errors))

        elif jasmine_passed_elem is not None:
            summary_text = jasmine_passed_elem.text
            print('---------------------------------------------------------------------------------------------------')
            print('Tests results summary:')
            print(summary_text)
            print('---------------------------------------------------------------------------------------------------')
            self.assertIn(', 0 failures', summary_text, 'Check the javascript tests out! ' + self.HOST + '/js_tests/')
        else:
            self.fail("Could not find jasmine passed nor failed output!")


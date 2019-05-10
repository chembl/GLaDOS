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

    def test_javascript_code_only(self):
        print('Testing javascript')
        url = self.HOST + '/js_tests/'
        self.getURL(url)

    def getURL(self, url):
        print('\nGetting Url:')
        print(url)
        self.browser.get(url)
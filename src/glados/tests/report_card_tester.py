import unittest
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
import traceback
import sys
import atexit


class ReportCardTester(unittest.TestCase):

  # set the window size and headless mode
  CHROME_OPTIONS = webdriver.ChromeOptions()
  CHROME_OPTIONS.add_argument('--headless')
  CHROME_OPTIONS.add_argument('--no-sandbox')
  CHROME_OPTIONS.add_argument('--disable-gpu')
  CHROME_OPTIONS.add_argument('--window-size=1200x600')

  HOST = 'http://127.0.0.1:8000'
  DEFAULT_TIMEOUT = 60

  IMPLICIT_WAIT = 1

  SINGLETON_BROWSER = None

  SUITE = unittest.TestSuite()

  NUM_BROWSER_CALLS = 0

  @classmethod
  def instantiateBrowser(cls):
    if ReportCardTester.SINGLETON_BROWSER is None:
      retries = 0
      created = False
      while not created and retries < 3:
        try:
          ReportCardTester.SINGLETON_BROWSER = webdriver.Chrome(chrome_options=cls.CHROME_OPTIONS)
          ReportCardTester.SINGLETON_BROWSER.implicitly_wait(ReportCardTester.IMPLICIT_WAIT)
          ReportCardTester.NUM_BROWSER_CALLS = 0
          created = True
        except:
          retries += 1
          print("CRITICAL ERROR: It was not possible to start the Browser Selenium driver due to:", file=sys.stderr)
          time.sleep(5)
          traceback.print_exc()
      if not created:
        raise Exception('Unable to start browser after {0} retries.'.format(retries))

  @staticmethod
  @atexit.register
  def closeBrowser():
    if ReportCardTester.SINGLETON_BROWSER is not None:
      try:
        ReportCardTester.SINGLETON_BROWSER.quit()
      except:
        pass
      ReportCardTester.SINGLETON_BROWSER = None

  def setUp(self):
    # instantiates the singleton browser
    ReportCardTester.instantiateBrowser()
    self.browser = ReportCardTester.SINGLETON_BROWSER

  def tearDown(self):
    if ReportCardTester.NUM_BROWSER_CALLS > 10:
      ReportCardTester.closeBrowser()

  def getURL(self, url, timeout=DEFAULT_TIMEOUT, wait_for_glados_ready=True, retries=3):
    ReportCardTester.NUM_BROWSER_CALLS += 1
    if retries == 0:
      self.fail("ERROR: {0} failed to load after 3 retries.")
    print('\nScenario:')
    print(url)
    self.browser.get(url)
    start_time = time.time()
    if wait_for_glados_ready:
      loaded = False
      while not loaded and time.time()-start_time < timeout:
        try:
          elem = self.browser.find_element_by_id("GLaDOS-page-loaded")
          if elem.get_attribute('innerHTML') == 'YES':
            loaded = True
          else:
            print("Loading {0} ...".format(url))
        except:
          traceback.print_exc()
          print("{0} Waiting for 'GLaDOS-page-loaded' ...".format(url))
          if time.time() - start_time > timeout/3:
            print("Travis Browser might be stalled ...")
            print("Closing Browser ...")
            ReportCardTester.closeBrowser()
            print("Giving travis some free relaxation time 30 secs ...")
            time.sleep(30)
            print("Starting Browser ...")
            ReportCardTester.instantiateBrowser()
            self.browser = ReportCardTester.SINGLETON_BROWSER
            self.getURL(url, timeout=timeout, wait_for_glados_ready=wait_for_glados_ready, retries=retries-1)
            return
        time.sleep(1)
      self.assertTrue(loaded, "Error: '{0}' failed to load under {1} seconds!".format(url, timeout))

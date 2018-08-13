from glados.tests.report_card_tester import ReportCardTester

class DocumentReportCardTest(ReportCardTester):

  # --------------------------------------------------------------------------------------
  # Scenarios
  # --------------------------------------------------------------------------------------

  def test_document_report_card_scenario_1(self):
    url = self.HOST + '/document_report_card/NOT_EXISTS/'
    self.getURL(url)

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    error_msg_p = self.browser.find_element_by_id('DBasicInformation').find_element_by_class_name('Bck-errormsg')
    # TODO: PhantomJS does not receive back the correct XHR code!
    self.assertIn(error_msg_p.text, ['No document found with id NOT_EXISTS',
                                     'There was an error while loading the data (0 error)'])

  def test_assay_report_card_scenario_2(self):

    self.getURL(self.HOST + '/document_report_card/CHEMBL1151960/')

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    id_field = self.browser.find_element_by_id('Bck-Doc_ID')
    self.assertEqual(id_field.text, 'CHEMBL1151960')

    type_field = self.browser.find_element_by_id('Bck-Journal')
    self.assertEqual(type_field.text, 'J. Med. Chem. (2009) 52:5058-5068')

    desc_field = self.browser.find_element_by_id('Bck-Cite_Explore')
    self.assertEqual(desc_field.text,
                     '20560642')

    format_field = self.browser.find_element_by_id('Bck-DOI')
    self.assertEqual(format_field.text, '10.1021/jm900587h')
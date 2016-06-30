from selenium.common.exceptions import NoSuchElementException
from report_card_tester import ReportCardTester

class CellLineReportCardTest(ReportCardTester):

  # --------------------------------------------------------------------------------------
  # Scenarios
  # --------------------------------------------------------------------------------------

  def test_celline_report_card_scenario_1(self):

    self.getURL(self.HOST + '/cell_line_report_card/CHEMBL3307242/', self.SLEEP_TIME)

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    # This one has all the information available

    # Id is CHEMBL3307242
    id_field = self.browser.find_element_by_id('Bck-CellLine_ID')
    self.assertEqual(id_field.text, 'CHEMBL3307242')

    name_field = self.browser.find_element_by_id('Bck-CellLine_Name')
    self.assertEqual(name_field.text, 'P3HR-1')

    desc_field = self.browser.find_element_by_id('Bck-CellLine_Desc')
    self.assertEqual(desc_field.text, 'P3HR-1')

    source_t_field = self.browser.find_element_by_id('Bck-CellLine_SourceT')
    self.assertEqual(source_t_field.text, 'Lyphoma')

    source_o_field = self.browser.find_element_by_id('Bck-CellLine_SourceO')
    self.assertEqual(source_o_field.text, 'Homo sapiens')

    source_tx_field = self.browser.find_element_by_id('Bck-CellLine_SourceTx')
    self.assertEqual(source_tx_field.text, '9606')

    source_clo_field = self.browser.find_element_by_id('Bck-CellLine_CLO')
    self.assertEqual(source_clo_field.text, 'CLO_0008331')

    source_efo_field = self.browser.find_element_by_id('Bck-CellLine_EFO')
    self.assertEqual(source_efo_field.text, 'EFO_0002312')

    source_efo_field = self.browser.find_element_by_id('Bck-CellLine_Cellosaurus')
    self.assertEqual(source_efo_field.text, 'CVCL_2676')


  def test_celline_report_card_scenario_2(self):

    self.getURL(self.HOST + '/cell_line_report_card/CHEMBL3307786/', self.SLEEP_TIME)

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    # This one has no Source Tissue, Source Organism, Source Taxid, CLO id, EFO id, or Cellosaurus Id
    source_t_field = self.browser.find_element_by_id('Bck-CellLine_SourceT')
    self.assertEqual(source_t_field.text, '---')

    source_o_field = self.browser.find_element_by_id('Bck-CellLine_SourceO')
    self.assertEqual(source_o_field.text, '---')

    source_tx_field = self.browser.find_element_by_id('Bck-CellLine_SourceTx')
    self.assertEqual(source_tx_field.text, '---')

    source_clo_field = self.browser.find_element_by_id('Bck-CellLine_CLO')
    self.assertEqual(source_clo_field.text, '---')

    source_efo_field = self.browser.find_element_by_id('Bck-CellLine_EFO')
    self.assertEqual(source_efo_field.text, '---')

    source_efo_field = self.browser.find_element_by_id('Bck-CellLine_Cellosaurus')
    self.assertEqual(source_efo_field.text, '---')

  def test_celline_report_card_scenario_3(self):

    self.getURL(self.HOST + '/cell_line_report_card/NOT_EXISTS/', self.SLEEP_TIME)
    # This one doesn't exist!

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    error_msg_p = self.browser.find_element_by_id('CBasicInformation').find_element_by_class_name('Bck-errormsg')
    self.assertEquals(error_msg_p.text, 'No cell line found with id NOT_EXISTS')
from glados.tests.report_card_tester import ReportCardTester

class AssayReportCardTest(ReportCardTester):

  # --------------------------------------------------------------------------------------
  # Scenarios
  # --------------------------------------------------------------------------------------

  def test_assay_report_card_scenario_1(self):

    self.getURL(self.HOST + '/assay_report_card/NOT_EXISTS/')

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    error_msg_p = self.browser.find_element_by_id('ABasicInformation').find_element_by_class_name('Bck-errormsg')
    # TODO: PhantomJS does not receive back the correct XHR code!
    self.assertIn(error_msg_p.text, ['No assay found with id NOT_EXISTS',
                                     'There was an error while loading the data (0 error)'])

  def test_assay_report_card_scenario_2(self):

    self.getURL(self.HOST + '/assay_report_card/CHEMBL615155/')

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    id_field = self.browser.find_element_by_id('Bck-Assay_ID')
    self.assertEqual(id_field.text, 'CHEMBL615155')

    type_field = self.browser.find_element_by_id('Bck-Assay_Type')
    self.assertEqual(type_field.text, 'Binding')

    desc_field = self.browser.find_element_by_id('Bck-Assay_Desc')
    self.assertEqual(desc_field.text,
                     'Inhibitory activity against human placenta 17-beta-hydroxysteroid dehydrogenase type 2 (17-beta-HSD type 2)')

    format_field = self.browser.find_element_by_id('Bck-Assay_Format')
    self.assertEqual(format_field.text, 'BAO_0000019')

    organism_field = self.browser.find_element_by_id('Bck-Assay_Organism')
    self.assertEqual(organism_field.text, '---')

    strain_field = self.browser.find_element_by_id('Bck-Assay_Strain')
    self.assertEqual(strain_field.text, '---')

    tissue_field = self.browser.find_element_by_id('Bck-Assay_Tissue')
    self.assertEqual(tissue_field.text, '---')

    cell_type_field = self.browser.find_element_by_id('Bck-Assay_CellType')
    self.assertEqual(cell_type_field.text, '---')

    sub_cell_type_field = self.browser.find_element_by_id('Bck-Assay_SubCellFrac')
    self.assertEqual(sub_cell_type_field.text, '---')

    # --------------------------------------
    # Curation Summary
    # --------------------------------------

    target_name_td = self.browser.find_element_by_id('BCK-Assay-Target-Name')
    self.assertEqual(target_name_td.text, 'Estradiol 17-beta-dehydrogenase 2 (CHEMBL2789)')

    target_name_link = target_name_td.find_element_by_tag_name('a')
    self.assertEqual(target_name_link.get_attribute('href'), self.HOST + '/target_report_card/CHEMBL2789')

    target_assay_td = self.browser.find_element_by_id('BCK-Assay-Target-Type')
    self.assertEqual(target_assay_td.text, 'SINGLE PROTEIN')


  def test_assay_report_card_scenario_3(self):

    self.getURL(self.HOST + '/assay_report_card/CHEMBL931654/')

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    organism_field = self.browser.find_element_by_id('Bck-Assay_Organism')
    self.assertEqual(organism_field.text, 'Influenza A virus')

    strain_field = self.browser.find_element_by_id('Bck-Assay_Strain')
    self.assertEqual(strain_field.text, 'H3N2')

  def test_assay_report_card_scenario_4(self):

    self.getURL(self.HOST + '/assay_report_card/CHEMBL615207/')

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    tissue_field = self.browser.find_element_by_id('Bck-Assay_Tissue')
    self.assertEqual(tissue_field.text, 'Liver')

    strain_field = self.browser.find_element_by_id('Bck-Assay_SubCellFrac')
    self.assertEqual(strain_field.text, 'Microsome')

  def test_assay_report_card_scenario_5(self):

    self.getURL(self.HOST + '/assay_report_card/CHEMBL615160/')

    # --------------------------------------
    # Basic Information
    # --------------------------------------

    cell_type_field = self.browser.find_element_by_id('Bck-Assay_CellType')
    self.assertEqual(cell_type_field.text, 'CHO')
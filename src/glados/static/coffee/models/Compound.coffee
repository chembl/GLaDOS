Compound = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'molecule/' + @get('molecule_chembl_id') + '.json'

  parse: (response) ->

    containsMetals = (molformula) ->

      nonMetals = ['H', 'C', 'N', 'O', 'P', 'S', 'F', 'Cl', 'Br', 'I']

      testMolformula = response.molecule_properties.full_molformula
      testMolformula = testMolformula.replace(/[0-9]+/g, '')
      testMolformula = testMolformula.replace('.', '')

      for element in nonMetals
        testMolformula = testMolformula.replace(element, '')

      testMolformula = testMolformula.replace(element, '')

      return testMolformula.length > 0


    # Calculate the rule of five from other properties
    if response.molecule_properties?
      response.ro5 = response.molecule_properties.num_ro5_violations == 0
    else
      response.ro5 = false

    # Computed Image and report card URL's for Compounds
    response.structure_image = false
    if response.structure_type == 'NONE' or response.structure_type == 'SEQ'
      # see the cases here: https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?spaceKey=CHEMBL&title=ChEMBL+Interface
      # in the section Placeholder Compound Images

      if response.molecule_properties?
        if containsMetals(response.molecule_properties.full_molformula)
          response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/metalContaining.png'
      else if response.molecule_type == 'Oligosaccharide'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligosaccharide.png'
      else if response.molecule_type == 'Small molecule'

        if response.natural_product == '1'
          response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/naturalProduct.png'
        else if response.polymer_flag == true
          response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolPolymer.png'
        else
          response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolecule.png'

      else if response.molecule_type == 'Antibody'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/antibody.png'
      else if response.molecule_type == 'Protein'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/peptide.png'
      else if response.molecule_type == 'Oligonucleotide'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligonucleotide.png'
      else if response.molecule_type == 'Enzyme'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/enzyme.png'
      else if response.molecule_type == 'Cell'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/cell.png'
      else #if response.molecule_type == 'Unclassified' or response.molecule_type = 'Unknown' or not response.molecule_type?
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/unknown.png'


      #response.image_url = glados.Settings.OLD_DEFAULT_IMAGES_BASE_URL + response.molecule_chembl_id
    else
      response.image_url = glados.Settings.WS_BASE_URL + 'image/' + response.molecule_chembl_id + '.svg?engine=indigo'
      response.image_url_png = glados.Settings.WS_BASE_URL + 'image/' + response.molecule_chembl_id \
          + '.png?engine=indigo'
      response.structure_image = true

    response.report_card_url = Compound.get_report_card_url(response.molecule_chembl_id )

    return response;


Compound.get_report_card_url = (chembl_id)->
  return glados.Settings.GLADOS_BASE_PATH_REL+'compound_report_card/'+chembl_id

Compound.COLUMNS = {
  CHEMBL_ID: {
      'name_to_show': 'ChEMBL ID'
      'comparator': 'molecule_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
      'image_base_url': 'image_url'
    }
  PREF_NAME: {
      'name_to_show': 'Name'
      'comparator': 'pref_name'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  MOLECULE_TYPE: {
      'name_to_show': 'Molecule Type'
      'comparator': 'molecule_type'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  MAX_PHASE: {
      'name_to_show': 'Max Phase'
      'comparator': 'max_phase'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  DOSED_INGREDIENT: {
      'name_to_show': 'Dosed Ingredient'
      'comparator': 'dosed_ingredient'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  SIMILARITY: {
      'name_to_show': 'Similarity'
      'comparator': 'similarity'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'custom_field_template': '<b>{{val}}</b>'
    }
}

Compound.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    Compound.COLUMNS.CHEMBL_ID,
    Compound.COLUMNS.MOLECULE_TYPE,
    Compound.COLUMNS.PREF_NAME,
    Compound.COLUMNS.MAX_PHASE,
    Compound.COLUMNS.DOSED_INGREDIENT,
  ]
  RESULTS_LIST_SIMILARITY:[
    Compound.COLUMNS.CHEMBL_ID,
    Compound.COLUMNS.SIMILARITY,
    Compound.COLUMNS.MOLECULE_TYPE,
    Compound.COLUMNS.PREF_NAME,
  ]
  RESULTS_LIST_REPORT_CARD_CAROUSEL: [
    Compound.COLUMNS.CHEMBL_ID,
  ]
}

Compound = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'molecule/' + @get('molecule_chembl_id') + '.json'

  parse: (response) ->

    # Lazy definition for sdf content retrieving
    response.sdf_url = glados.Settings.WS_BASE_URL + 'molecule/' + response.molecule_chembl_id + '.sdf'
    response.sdf_promise = null
    response.get_sdf_content_promise = ->
      if not response.sdf_promise
        response.sdf_promise = $.ajax(response.sdf_url)
      return response.sdf_promise

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
          response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/naturalProduct.svg'
        else if response.polymer_flag == true
          response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolPolymer.png'
        else
          response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolecule.svg'

      else if response.molecule_type == 'Antibody'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/antibody.svg'
      else if response.molecule_type == 'Protein'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/peptide.png'
      else if response.molecule_type == 'Oligonucleotide'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligonucleotide.png'
      else if response.molecule_type == 'Enzyme'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/enzyme.svg'
      else if response.molecule_type == 'Cell'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/cell.png'
      else #if response.molecule_type == 'Unclassified' or response.molecule_type = 'Unknown' or not response.molecule_type?
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/unknown.svg'


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
  SYNONYMS: {
      'name_to_show': 'Synonyms'
      'comparator': 'molecule_synonyms'
      'sort_disabled': true
      'parse_function': (values) -> _.uniq(v.molecule_synonym for v in values).join(', ')
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
  STRUCTURE_TYPE:{
    'name_to_show': 'Structure Type'
    'comparator': 'structure_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  INORGANIC_FLAG:{
    'name_to_show': 'Inorganic Flag'
    'comparator': 'inorganic_flag'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  FULL_MWT:{
    'name_to_show': 'Molecular Weight'
    'comparator': 'molecule_properties.full_mwt'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  FULL_MWT_CARD:{
    'name_to_show': 'MWt'
    'comparator': 'molecule_properties.full_mwt'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ALOGP:{
    'name_to_show': 'ALogP'
    'comparator': 'molecule_properties.alogp'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  HBA:{
    'name_to_show': 'HBA'
    'comparator': 'molecule_properties.hba'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  HBD:{
    'name_to_show': 'HBD'
    'comparator': 'molecule_properties.hbd'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  HEAVY_ATOMS:{
    'name_to_show': 'Heavy Atoms'
    'comparator': 'molecule_properties.heavy_atoms'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  PSA:{
    'name_to_show': 'PSA'
    'comparator': 'molecule_properties.psa'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  RO5:{
    'name_to_show': '#RO5 Violations'
    'comparator': 'molecule_properties.num_ro5_violations'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  RO5_CARD:{
    'name_to_show': '#RO5'
    'comparator': 'molecule_properties.num_ro5_violations'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ROTATABLE_BONDS:{
    'name_to_show': '#Rotatable Bonds'
    'comparator': 'molecule_properties.rtb'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ROTATABLE_BONDS_CARD:{
    'name_to_show': '#RTB'
    'comparator': 'molecule_properties.rtb'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  RULE_OF_THREE_PASS:{
    'name_to_show': 'RO3'
    'comparator': 'molecule_properties.ro3_pass'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  RULE_OF_THREE_PASS_CARD:{
    'name_to_show': 'Passes Rule of Three'
    'comparator': 'molecule_properties.ro3_pass'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  QED_WEIGHTED:{
    'name_to_show': 'QUED Weighted'
    'comparator': 'molecule_properties.qed_weighted'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  APKA:{
    'name_to_show': 'ACD ApKa'
    'comparator': 'molecule_properties.acd_most_apka'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  BPKA:{
    'name_to_show': 'ACD BpKa'
    'comparator': 'molecule_properties.acd_most_bpka'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ACD_LOGP:{
    'name_to_show': 'ACD LogP'
    'comparator': 'molecule_properties.acd_logp'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ACD_LOGD:{
    'name_to_show': 'ACD Logd'
    'comparator': 'molecule_properties.acd_logd'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  AROMATIC_RINGS:{
    'name_to_show': 'Aromatic Rings'
    'comparator': 'molecule_properties.aromatic_rings'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  HEAVY_ATOMS:{
    'name_to_show': 'Heavy Atoms'
    'comparator': 'molecule_properties.heavy_atoms'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  HBA_LIPINSKI:{
    'name_to_show': 'HBA Lipinski'
    'comparator': 'molecule_properties.hba_lipinski'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  HBD_LIPINSKI:{
    'name_to_show': 'HBD Lipinski'
    'comparator': 'molecule_properties.hbd_lipinski'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  RO5_LIPINSKI:{
    'name_to_show': '#RO5 Violations (Lipinski)'
    'comparator': 'molecule_properties.num_lipinski_ro5_violations'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  MWT_MONOISOTOPIC:{
    'name_to_show': 'Molecular Weight (Monoisotopic)'
    'comparator': 'molecule_properties.mw_monoisotopic'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  MOLECULAR_SPECIES:{
    'name_to_show': 'Molecular Species'
    'comparator': 'molecule_properties.molecular_species'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  FULL_MOLFORMULA:{
    'name_to_show': 'Full molformula'
    'comparator': 'molecule_properties.full_molformula'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  NUM_TARGETS:{
    'name_to_show': 'Targets'
    'comparator': '_metadata.related_targets.count'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'format_as_number': true
  }

}

Compound.ID_COLUMN = Compound.COLUMNS.CHEMBL_ID

Compound.COLUMNS_SETTINGS = {
  RESULTS_LIST_TABLE: [
    Compound.COLUMNS.CHEMBL_ID,
    Compound.COLUMNS.SYNONYMS,
    Compound.COLUMNS.MAX_PHASE,
    Compound.COLUMNS.FULL_MWT,
    Compound.COLUMNS.ALOGP,
    Compound.COLUMNS.PSA,
    Compound.COLUMNS.HBA,
    Compound.COLUMNS.HBD,
    Compound.COLUMNS.RO5,
    Compound.COLUMNS.ROTATABLE_BONDS,
    Compound.COLUMNS.RULE_OF_THREE_PASS,
    Compound.COLUMNS.QED_WEIGHTED,
    Compound.COLUMNS.NUM_TARGETS

  ]
  RESULTS_LIST_REPORT_CARD:[
    Compound.COLUMNS.CHEMBL_ID,
    Compound.COLUMNS.PREF_NAME,
    Compound.COLUMNS.MAX_PHASE,
    Compound.COLUMNS.FULL_MWT_CARD,
    Compound.COLUMNS.RO5_CARD,
    Compound.COLUMNS.ALOGP,
    Compound.COLUMNS.NUM_TARGETS
  ]
  RESULTS_LIST_REPORT_CARD_ADDITIONAL:[
    Compound.COLUMNS.APKA,
    Compound.COLUMNS.BPKA,
    Compound.COLUMNS.ACD_LOGP,
    Compound.COLUMNS.ACD_LOGD,
    Compound.COLUMNS.AROMATIC_RINGS,
    Compound.COLUMNS.STRUCTURE_TYPE,
    Compound.COLUMNS.INORGANIC_FLAG,
    Compound.COLUMNS.HEAVY_ATOMS,
    Compound.COLUMNS.HBA_LIPINSKI,
    Compound.COLUMNS.HBD_LIPINSKI,
    Compound.COLUMNS.RO5_LIPINSKI,
    Compound.COLUMNS.MWT_MONOISOTOPIC,
    Compound.COLUMNS.MOLECULAR_SPECIES,
    Compound.COLUMNS.FULL_MOLFORMULA,
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

Compound.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'
  COLUMNS: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD

Compound.getCompoundsListURL = (filter) ->

  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'compounds/filter/' + filter
  else
    return glados.Settings.GLADOS_BASE_PATH_REL + 'compounds'
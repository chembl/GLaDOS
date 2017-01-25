Compound = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'molecule/' + @get('molecule_chembl_id') + '.json'

  parse: (response) ->

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

      #Oligosaccharide
      if response.molecule_type == 'Oligosaccharide'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligosaccharide.png'
      else if response.molecule_type == 'Small molecule'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolecule.png'
      else if response.molecule_type == 'Antibody'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/antibody.png'
      else if response.molecule_type == 'Protein'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/peptide.png'
      else if response.molecule_type == 'Oligonucleotide'
        response.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligonucleotide.png'

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


Compound.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    {
      'name_to_show': 'ChEMBL ID'
      'comparator': 'molecule_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
      'image_base_url': 'image_url'
    }
    {
      'name_to_show': 'Molecule Type'
      'comparator': 'molecule_type'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Name'
      'comparator': 'pref_name'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Max Phase'
      'comparator': 'max_phase'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Dosed Ingredient:'
      'comparator': 'dosed_ingredient'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  ]
  RESULTS_LIST_SIMILARITY:[
    {
      'name_to_show': 'ChEMBL ID'
      'comparator': 'molecule_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
      'image_base_url': 'image_url'
    }
    {
      'name_to_show': 'Similarity:'
      'comparator': 'similarity'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'custom_field_template': '<b>{{val}}</b>'
    }
    {
      'name_to_show': 'Molecule Type'
      'comparator': 'molecule_type'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Name'
      'comparator': 'pref_name'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  ]
  RESULTS_LIST_REPORT_CARD_CAROUSEL: [
    {
      'name_to_show': 'ChEMBL ID'
      'comparator': 'molecule_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
      'image_base_url': 'image_url'
    }
  ]
}
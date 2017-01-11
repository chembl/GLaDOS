Assay = Backbone.RelationalModel.extend

  idAttribute: 'assay_chembl_id'

  initialize: ->
    # it seems that the autoFetch property doesn't work
    @on 'change', @fetchRelatedModels, @

    @url = glados.Settings.WS_BASE_URL + 'assay/' + @get('assay_chembl_id') + '.json'

  relations: [{
    type: Backbone.HasOne
    key: 'target'
    relatedModel: 'Target'
  }]

  fetchRelatedModels: ->

    @getAsync('target')

  parse: (data) ->

    parsed = data
    parsed.target = data.target_chembl_id

    return parsed

Assay.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    {
      'name_to_show': 'CHEMBL_ID'
      'comparator': 'assay_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': '/assay_report_card/$$$'
    }
    {
      'name_to_show': 'Strain'
      'comparator': 'assay_strain'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'custom_field_template': '<i>{{val}}</i>'
    }
    {
      'name_to_show': 'Description'
      'comparator': 'description'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Type'
      'comparator': 'assay_type_description'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Organism'
      'comparator': 'assay_organism'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  ]
}
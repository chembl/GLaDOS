glados.useNameSpace 'glados.models.base',
  # Model to support the creation of links for report cards
  ReportCardEntity:
    color : 'teal'
    reportCardPath : 'unknown/path'

    get_colored_report_card_url : (chembl_id)->
      return {
        'color': @color
        'href': @get_report_card_url(chembl_id)
        'text': (if _.has(@prototype, 'entityName') then @prototype.entityName + ' ' else '') + chembl_id
      }


    get_report_card_url : (chembl_id)->
      return glados.Settings.GLADOS_BASE_PATH_REL + @reportCardPath + chembl_id
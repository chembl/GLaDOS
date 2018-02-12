glados.useNameSpace 'glados.views.ReportCards',
  SectionView: CardView.extend
    initialize: ->

      $sectionHeader = $(@el).find('.BCK-Section-header')
      glados.Utils.fillContentForElement $sectionHeader,
        title: @model.get('title')
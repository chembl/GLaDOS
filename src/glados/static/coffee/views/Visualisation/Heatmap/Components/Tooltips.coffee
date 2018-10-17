glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Tooltips:

    #-------------------------------------------------------------------------------------------------------------------
    # Rows /Cols Headers tooltips
    #-------------------------------------------------------------------------------------------------------------------
    generateTooltipFunction: (sourceEntity, matrixView, isCol=true) ->

      return (d) ->

        $clickedElem = $(@)
        chemblID = d.id
        if $clickedElem.attr('data-qtip-configured')
          return

        miniRepCardID = 'BCK-MiniReportCard-' + chemblID

        qtipConfig =
          content:
            text: '<div id="' + miniRepCardID + '"></div>'
          show:
            solo: true
          hide:
            fixed: true,
            delay: glados.Settings.TOOLTIPS.DEFAULT_MERCY_TIME
          style:
            classes:'matrix-qtip qtip-light qtip-shadow'

        if isCol
          qtipConfig.position =
            my: 'top left'
            at: 'bottom left'
        else
          qtipConfig.position =
            my: 'top left'
            at: 'bottom right'

        $clickedElem.qtip qtipConfig

        $clickedElem.qtip('api').show()
        $clickedElem.attr('data-qtip-configured', 'yes')

        $newMiniReportCardContainer = $('#' + miniRepCardID)
        $newMiniReportCardContainer.hover ->
          $clickedElem.attr('data-qtip-have-mercy', 'yes')

        if sourceEntity == 'Target'
          ReportCardApp.initMiniReportCard(Entity=Target, $newMiniReportCardContainer, chemblID)
        else
          ReportCardApp.initMiniReportCard(Entity=Compound, $newMiniReportCardContainer, chemblID)

    destroyAllTooltipsIfNecessary: (event) ->

      mouseX = event.clientX
      mouseY = event.clientY
      $elementLeft = $(event.currentTarget)
      glados.Utils.Tooltips.destroyAllTooltipsWhenMouseIsOut($elementLeft, mouseX, mouseY)

    #---------------------------------------------------------------------------------------------------------------------
    # cells tooltips
    #---------------------------------------------------------------------------------------------------------------------
    summoningMe: ->

      if @KEYS_PRESSED.length != @GLADOS.length
        return false

      for i in [0..@KEYS_PRESSED.length-1]
        keyIs = @KEYS_PRESSED[i]
        keyMustBe = @GLADOS[i]
        if keyIs != keyMustBe
          return false

      return true

    showCellTooltip: ($clickedElem, d)  ->

      summoningMe = @summoningMe()
      if $clickedElem.attr('data-qtip-configured') and not summoningMe
          return

      cardID = d.row_id + '_' + d.col_id
      miniRepCardID = 'BCK-MiniReportCard-' + cardID
      htmlContent = '<div id="' + miniRepCardID + '"></div>'

      if summoningMe
        htmlContent = Handlebars.compile($('#Handlebars-Common-GladosSummoned').html())()

      qtipConfig =
        content:
          text: htmlContent
          button: 'close'
        show:
          event: 'click'
          solo: true
        hide: 'click'
        style:
          classes:'matrix-qtip qtip-light qtip-shadow'
        position:
          my: 'top left'
          at: 'bottom center'

      $clickedElem.qtip qtipConfig
      $clickedElem.qtip('api').show()
      $clickedElem.attr('data-qtip-configured', true)

      if summoningMe
        return

      $newMiniReportCardContainer = $('#' + miniRepCardID)
      glados.apps.Activity.ActivitiesBrowserApp.initMatrixCellMiniReportCard($newMiniReportCardContainer, d,
        @config.rows_entity_name == 'Compounds')


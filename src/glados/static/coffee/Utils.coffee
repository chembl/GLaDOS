glados.useNameSpace 'glados',
  Utils:
    Pagination:
      calculatePaginatorParams: (num_pages, current_page) ->
        show_previous_ellipsis = false
        show_next_ellipsis = false
        if num_pages <= 5
          first_page_to_show = 1
          last_page_to_show = num_pages
        else if current_page + 2 <= 5
          first_page_to_show = 1
          last_page_to_show = 5
          show_next_ellipsis = true
        else if current_page + 2 < num_pages
          first_page_to_show = current_page - 2
          last_page_to_show = current_page + 2
          show_previous_ellipsis = true
          show_next_ellipsis = true
        else
          first_page_to_show = num_pages - 4
          last_page_to_show = num_pages
          show_previous_ellipsis = true

        return [show_previous_ellipsis, show_next_ellipsis, first_page_to_show, last_page_to_show]

    escapeRegExp: (strToEscape)->
      return strToEscape.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); # $& means the whole matched string


    showErrorModalMessage: (message, redirection_link) ->
      if not glados.Utils.modalErrorTemplate?
        glados.Utils.modalErrorTemplate = Handlebars.compile($('#Handlebars-Common-RedCardError').html())
      compiledErrorMessage = glados.Utils.modalErrorTemplate
        msg: message
        redirect_link: redirection_link
      $('#glados-messages .modal-content').html(compiledErrorMessage)
      $('#glados-messages').modal
        ready: (modal, trigger)->
          secsForRedirect = 10
          callRedirect = ->
            setTimeout ->
              $(modal).find('.redirect-time').html(secsForRedirect+'s')
              secsForRedirect -= 1
              if secsForRedirect <= 0
                window.location.replace(redirection_link)
              else
                setTimeout ->
                  callRedirect()
                , 1000
          callRedirect()
      $('#glados-messages').modal('open')


    checkReportCardByChemblId: (chemblId) ->
      chemblId = chemblId.toUpperCase()
      lookup_url = glados.models.paginatedCollections.Settings.ES_BASE_URL
      lookup_url += '/chembl_chembl_id_lookup/_search?q=status:ACTIVE%20AND%20chembl_id:'
      lookup_url += chemblId
      ajax_deferred = $.post lookup_url
      ajax_deferred.then (data) ->
        if data.hits.hits.length > 0
          entityName = data.hits.hits[0]._source.entity_type
          correctEntity = glados.Utils.getEntityFromName(entityName)
          rcUrl = correctEntity.get_report_card_url(chemblId)
          if not window.location.pathname.includes(rcUrl)
            entityName = glados.Utils.getEntityByReportCardURL().prototype.entityName
            message = chemblId+' is not a '+entityName+' registered in ChEMBL. <br> However, '+chemblId+' is a '
            message += correctEntity.prototype.entityName + '.'
            glados.Utils.showErrorModalMessage(
              message,
              glados.Settings.GLADOS_BASE_URL_FULL+rcUrl.substring(1)
            )

    getEntityByReportCardURL: (reportCardURL=window.location.pathname)->
      if reportCardURL.includes(Compound.reportCardPath)
        return Compound
      else if reportCardURL.includes(Target.reportCardPath)
        return Target
      else if reportCardURL.includes(Assay.reportCardPath)
        return Assay
      else if reportCardURL.includes(Document.reportCardPath)
        return Document
      else if reportCardURL.includes(CellLine.reportCardPath)
        return CellLine
      else if reportCardURL.includes(glados.models.Tissue.reportCardPath)
        return glados.models.Tissue
      return null

    getEntityFromName: (entityName) ->
      entityName = entityName.toLowerCase()
      switch
        when entityName == Compound.prototype.entityName.toLowerCase() then Compound
        when entityName == Target.prototype.entityName.toLowerCase() then Target
        when entityName == Assay.prototype.entityName.toLowerCase() then Assay
        when entityName == Document.prototype.entityName.toLowerCase() then Document
        when entityName == CellLine.prototype.entityName.toLowerCase() or entityName == 'cell' then CellLine
        when entityName == glados.models.Tissue.prototype.entityName.toLowerCase() then glados.models.Tissue

    # Will round a number to the closest 10*, 20* or 50*
    # Check the next function to get some examples about how this function works
    roundNumber: (n, isSmallFloat=false, downwards=false)->
      if isSmallFloat
        n *= Math.pow(10, 20)
      curLevel = -1
      curNum = Math.abs(n)
      loop
        curLevel += 1
        lastNum = curNum
        curNum /= 10.0
        curNum = if downwards and Math.sign(n) > 0 then Math.floor(curNum) else Math.ceil(curNum)
        if curNum == 1 or curNum == 0
          break
      if lastNum >= 10
        curLevel++
        lastNum = 1

      if downwards and Math.sign(n) > 0
        if lastNum < 2
          lastNum = 1
          if curLevel <= 0 and lastNum == 1
            lastNum = 0
        else if lastNum < 5
          lastNum = 2
        else
          lastNum = 5
      else
        if lastNum > 5
          curLevel++
          lastNum = 1
        else if lastNum > 2
          lastNum = 5
        else if lastNum > 1
          lastNum = 2
        else
          lastNum = 1
      n = Math.sign(n) * lastNum * Math.pow(10, curLevel)
      if isSmallFloat
        n /= Math.pow(10, 20)
      return n

    getFormattedNumber: (numberToFormat, exponentialAfter=Math.pow(10, 9), year=false)->
      if numberToFormat == 0
        return '0'
      if year
        return ''+numberToFormat
      if Math.abs(numberToFormat) < exponentialAfter
        return numeral(numberToFormat).format('0,[.]00')
      return numeral(numberToFormat).format('0.[0000]e+0')

    # this is to support using dots for nested properties in the list settings
    #for example, if you have the following object
    # a = {
    #    b: {
    #      c: 2
    #       }
    #     }
    # you can use the function like this getNestedValue(a, 'b.c'.split('.'))
    getNestedValue: (nestedObj, nestedComparatorsStr, forceAsNumber=false, customNullValueLabel,
      returnUndefined=false) ->

      if returnUndefined
        nullValueLabel = undefined
      else
        nullValueLabel = customNullValueLabel
        nullValueLabel ?= glados.Settings.DEFAULT_NULL_VALUE_LABEL
        nullReturnVal = if forceAsNumber then -Number.MAX_VALUE else nullValueLabel

      nestedComparatorsList = nestedComparatorsStr.split('.')
      if nestedComparatorsList.length == 1
        value = nestedObj[(nestedComparatorsList.shift())]
        if not value?
          return nullReturnVal
        if forceAsNumber
          return parseFloat(value)
        else
          return value
      else
        prop = nestedComparatorsList.shift()
        newObj = nestedObj[(prop)]
        if !newObj?
          return nullReturnVal

        return @getNestedValue(newObj, nestedComparatorsList.join('.'))


    Columns:
      getHighlights: (model)->

        included = new Set()

        highlights = null
        if model.get('_highlights')? and included.size == 0
          highlights = []
          for comparator, hlData of model.get('_highlights')
            if not included.has(comparator)
              highlights.push hlData
              if highlights.length >= 1
                break

        return [highlights, included]

      addColID: (returnCol, colDescription)->

        returnCol.id = colDescription.id
        if returnCol.id?
          returnCol.template_id = returnCol.id.replace(/\./g, '_dot_')

      addNameToShow: (returnCol, colDescription, model) ->

        nameToShowFunction = colDescription.name_to_show_function
        if nameToShowFunction?
          returnCol.name_to_show = nameToShowFunction(model)
        else
          returnCol.name_to_show = colDescription['name_to_show']

        if colDescription.name_to_show_short?
          returnCol.name_to_show_short = colDescription.name_to_show_short
        else
          returnCol.name_to_show_short = colDescription.name_to_show

      getColValue: (colDescription, model, highlights) ->

        colValueFunction = colDescription.col_value_function
        if colValueFunction?
          return colValueFunction(model)

        if colDescription.search_hit_highlight_column
          colValue = highlights
        else
          colValue = glados.Utils.getNestedValue(model.attributes, colDescription.comparator, forceAsNumber=false,\
            customNullValueLabel=colDescription.custom_null_vale_label)

        if colDescription.num_decimals? and colDescription.format_as_number\
        and colValue != glados.Settings.DEFAULT_NULL_VALUE_LABEL

          colValue = colValue.toFixed(colDescription.num_decimals)

        return colValue


    # given an model and a list of columns to show, it gives an object ready to be passed to a
    # handlebars template, with the corresponding values for each column
    # handlebars only allow very simple logic, we have to help the template here and
    # give it everything as ready as possible
    getColumnsWithValuesAndHighlights: (columns, model) ->


      [highlights, included] = glados.Utils.Columns.getHighlights(model)

      columnsToReturn = columns.map (colDescription) ->

        returnCol = {}
        glados.Utils.Columns.addColID(returnCol, colDescription)
        glados.Utils.Columns.addNameToShow(returnCol, colDescription, model)


        returnCol.show = colDescription.show
        returnCol.search_hit_highlight_column = colDescription.search_hit_highlight_column || false
        returnCol.comparator = colDescription.comparator
        returnCol['format_class'] = colDescription.format_class

        colValue = glados.Utils.Columns.getColValue(colDescription, model, highlights)


        # this will now be 'setColValue'
        if _.isBoolean(colValue)
          returnCol['value'] = if colValue then 'Yes' else 'No'
        else
          returnCol['value'] = colValue

        if _.has(colDescription, 'parse_function')
          returnCol['value'] = colDescription['parse_function'](colValue)

        if _.has(colDescription, 'additional_parsing')

          for key in Object.keys(colDescription.additional_parsing)
            parserFunction = colDescription.additional_parsing[key]
            returnCol[key] = parserFunction colValue

        returnCol['has_link'] = _.has(colDescription, 'link_base') or _.has(colDescription, 'link_function')
        returnCol['has_multiple_links'] = colDescription.multiple_links == true

        returnCol['hide_label'] = colDescription.hide_label == true
        returnCol['is_function_link'] = colDescription.function_link == true
        returnCol['execute_on_render'] = colDescription.execute_on_render == true

        if returnCol['is_function_link']

          if colDescription.function_parameters?
            returnCol['function_parameters'] = (glados.Utils.getNestedValue(model.attributes, paramComp) \
            for paramComp in colDescription.function_parameters).join(',')

          returnCol['function_constant_parameters'] = colDescription.function_constant_parameters
          returnCol['function_key'] = colDescription.function_key

          if colDescription.function_object_parameter?
            fObjectParam = colDescription.function_object_parameter
            returnCol['function_object_parameter'] = JSON.stringify(fObjectParam(model.attributes))

          returnCol['hide_value'] = colDescription.hide_value
          returnCol['table_cell_width'] = colDescription.table_cell_width
          returnCol['table_cell_width_medium'] = colDescription.table_cell_width_medium
          returnCol['remove_link_after_click'] = colDescription.remove_link_after_click

        if returnCol['has_link']
          if colDescription['link_base']?
            returnCol['link_url'] = model.get(colDescription['link_base'])
          if colDescription['link_function']?
            returnCol['link_url'] = colDescription['link_function'] colValue

        else if returnCol['has_multiple_links']
          returnCol['links_values'] = colDescription['multiple_links_function'] colValue

        if _.has(colDescription, 'image_base_url')
          img_url = model.get(colDescription['image_base_url'])
          returnCol['img_url'] = img_url
        if _.has(colDescription, 'custom_field_template')
          returnCol['custom_html'] = Handlebars.compile(colDescription['custom_field_template'])
            val: returnCol['value']

        if colDescription.show
          # Include highlight data in the column
          returnCol.has_highlight = model.get('_highlights')? and\
              _.has(model.get('_highlights'), colDescription.comparator)
          if returnCol.has_highlight
            included.add colDescription.comparator
            returnCol.highlighted_value = model.get('_highlights')[colDescription.comparator].value

        # This method should return a value based on the parameter, not modify the parameter
        return returnCol

      return [columnsToReturn, highlights]


    #gets the image url from the first column with values that has a 'img_url'
    getImgURL: (columnsWithValues) ->

      for col in columnsWithValues
        if col['img_url']?
          return col['img_url']
      return null

    cachedTemplateFunctions: {}
    # the element must define a data-hb-template, which is the id of the handlebars template to be used
    fillContentForElement: ($element, paramsObj={}, customTemplate, fillWithPreloader=false)->


      if customTemplate?
        templateSelector = '#' + customTemplate
      else
        if fillWithPreloader
          templateSelector = '#' + $element.attr('data-hb-preloader-template')
        else
          templateSelector = '#' + $element.attr('data-hb-template')

      if not glados.Utils.cachedTemplateFunctions[templateSelector]?
        templateFunction = Handlebars.compile($(templateSelector).html())
        glados.Utils.cachedTemplateFunctions[templateSelector] = templateFunction
      else
        templateFunction = glados.Utils.cachedTemplateFunctions[templateSelector]

      $element.html templateFunction(paramsObj)

    getContentFromTemplate: (templateID, paramsObj={}, customTemplateContent) ->

      templateSelector = '#' + templateID

      if not glados.Utils.cachedTemplateFunctions[templateSelector]? or customTemplateContent?
        if customTemplateContent?
          templateContent = customTemplateContent
        else
          templateContent = $(templateSelector).html()
        templateFunction = Handlebars.compile(templateContent)
        glados.Utils.cachedTemplateFunctions[templateSelector] = templateFunction
      else
        templateFunction = glados.Utils.cachedTemplateFunctions[templateSelector]

      return templateFunction(paramsObj)


    # Helper function to prevent links from navigating to an url that is inside the same js page
    # If key_up is true will override for enter listening on links
    # If key_up is false will override for click listening on links
    # callback should be a function that receives the href of the link and knows how to handle it
    getNavigateOnlyOnNewTabLinkEventHandler: (key_up, callback)->
      handler = (event)->
        # Disables link navigation by click or enter, unless it redirects to a non results page
        if $(this).attr("target") != "_blank" and \
          (not key_up or event.keyCode == 13) and \
          not(event.ctrlKey or GlobalVariables.IS_COMMAND_KEY_DOWN)
            event.preventDefault()
            callback($(this).attr("href"))
      return handler

    overrideHrefNavigationUnlessTargetBlank: ($jquery_element, callback)->
      $jquery_element.click(
        glados.Utils.getNavigateOnlyOnNewTabLinkEventHandler(false, callback)
      )
      $jquery_element.keyup(
        glados.Utils.getNavigateOnlyOnNewTabLinkEventHandler(true, callback)
      )

    # for server side collections, it assumes that all the results are already on the client
    pluckFromListItems: (list, propertyName) ->

      if list.allResults?
        return (glados.Utils.getNestedValue(model, propertyName) for model in list.allResults)
      else
        return (glados.Utils.getNestedValue(model.attributes, propertyName) for model in list.models)

    renderLegendForProperty: (property, collection, $legendContainer, enableSelection=true, legendConfig) ->

      if not property.legendModel?
        property.legendModel = new glados.models.visualisation.LegendModel
          property: property
          collection: collection
          enable_selection: enableSelection

      if not property.legendView?
        property.legendView = new LegendView
          model: property.legendModel
          el: $legendContainer
          config: legendConfig
      else
        property.legendView.render()

      $legendContainer.find('line, path').css('fill', 'none')

    getDegreesFromRadians: (radians) -> radians * 180 / Math.PI
    getRadiansFromDegrees: (degrees) -> (degrees * Math.PI) / 180

    Buckets:
      mergeBuckets: (buckets, maxCategories, model, aggName, subBuckets=false) ->

        if buckets.length > maxCategories
          start = maxCategories - 1
          stop = buckets.length - 1
          bucketsToMerge = buckets[start..stop]

          if model?
            mergedLink = model.getMergedLink(bucketsToMerge, aggName)
          else
            mergedLink = ''

          if subBuckets
            othersBucket =
              key: glados.Visualisation.Activity.OTHERS_LABEL
              doc_count: _.reduce(_.pluck(bucketsToMerge, 'doc_count'), ((a, b) -> a + b))
              pos: Number.MAX_VALUE
              link: mergedLink
              parent_key: bucketsToMerge[0].parent_key
          else
            othersBucket =
              doc_count: _.reduce(_.pluck(bucketsToMerge, 'doc_count'), ((a, b) -> a + b))
              key: glados.Visualisation.Activity.OTHERS_LABEL
              link: mergedLink

          buckets = buckets[0..start-1]
          buckets.push(othersBucket)

        return buckets

      getElasticRanges: (minValue, maxValue, numCols) ->

        interval = parseFloat((Math.ceil(Math.abs(maxValue - minValue)) / numCols).toFixed(2))
        if interval == 0
          interval = 0.01

        ranges = []
        from = minValue
        to = minValue + interval
        for col in [0..numCols-1]
          from = parseFloat(from.toFixed(2))
          to = parseFloat(to.toFixed(2))
          ranges.push
            from: from
            to: to

          from += interval
          to += interval

        return ranges

      getIntervalSize: (maxValue, minValue, numColumns) ->
        parseFloat((Math.ceil(Math.abs(maxValue - minValue)) / numColumns).toFixed(2))

      getBucketsList: (elasticBucketsObj) ->

        buckets = []
        for key, bucket of elasticBucketsObj
          bucket.key = key
          buckets.push bucket

        return buckets

#     returns ordered list of sub buckets odc count
      getSubBucketsOrder: (buckets, subBucketsAggName) ->
        internalBucketsCounts = {}

        for bucket in buckets
          splitSeriesBuckets = bucket[subBucketsAggName].buckets

          for splitSeriesBucket in splitSeriesBuckets
            bucketKey = splitSeriesBucket.key

#            adds the sub bucket to the list
            if not internalBucketsCounts[bucketKey]
              internalBucketsCounts[bucketKey] = 0

#           adds the doc count to the bucket name
            internalBucketsCounts[bucketKey] += splitSeriesBucket.doc_count

        sortingList = []
        for key, value of internalBucketsCounts
          sortingList.push
            key: key
            count: value

        sortedList = _.sortBy sortingList, (item) -> -item.count

        InternalBucketsWithPosition = {}
        for item, pos in sortedList
          InternalBucketsWithPosition[item.key] =
            key: item.key
            count: item.count
            pos: pos

        return InternalBucketsWithPosition

    ErrorMessages:

      getJQXHRErrorText: (jqXHR) ->
        if jqXHR.status == 0
          return console.log jqXHR.getAllResponseHeaders()
        else
          jqXHR.status + ': ' + jqXHR.statusText

      showLoadingErrorMessageGen: ($progressElem) ->
        return (jqXHR, textStatus, errorThrown) ->
          errorDetails = glados.Utils.ErrorMessages.getJQXHRErrorText(jqXHR)
          $progressElem.html 'Error loading data (' + errorDetails + ')'

      getErrorCardContent: (jqXHR) ->
        errorDetails = glados.Utils.ErrorMessages.getJQXHRErrorText(jqXHR)
        return Handlebars.compile($('#Handlebars-Common-ErrorInCard').html())
          msg: errorDetails

      getCollectionErrorContent: (jqXHR, customExplanation) ->
        errorDetails = glados.Utils.ErrorMessages.getJQXHRErrorText(jqXHR)
        return Handlebars.compile($('#Handlebars-Common-CollectionErrorMsg').html())
          msg: errorDetails
          custom_explanation: customExplanation

      getErrorImageContent: (jqXHR) ->
        errorDetails = glados.Utils.ErrorMessages.getJQXHRErrorText(jqXHR)
        return Handlebars.compile($('#Handlebars-Common-ErrorInImage').html())
          msg: errorDetails

      fillErrorForElement: ($element, paramsObj={}) ->

        templateID = $element.attr('data-hb-error-template')
        glados.Utils.fillContentForElement($element, paramsObj, templateID)

    Text:
      getTextForEllipsis: (originalText, originalWidth, containerLimit) ->
        if originalWidth > containerLimit
          numChars = originalText.length
          charLength = originalWidth / numChars
          # reduce by num numchars because font characters are not all of the same width
          numChars = Math.ceil(containerLimit / charLength) - 2
          textLimit = numChars - 4
          textLimit = if textLimit < 0 then 0 else textLimit
          return originalText[0..textLimit] + '...'
        else return originalText

    QueryStrings:
      getQueryStringForItemsList: (chemblIDs, idAttribute) ->
        return idAttribute + ':(' + ('"' + id + '"' for id in chemblIDs).join(' OR ') + ')'

    Tooltips:

      cssTooltippedOnOverflownOnly: (element)->
        $elem = $(element)
        checkedWidth = parseInt($elem.attr('css-tooltipped-checked-width') || '0')
        if $elem.width() != checkedWidth
          $elem.removeClass 'active-tooltip'
          ellipsisElem = $elem.find('.p-oneline')[0]
          if ellipsisElem?
            if ellipsisElem.scrollWidth > ellipsisElem.clientWidth
              $elem.addClass 'active-tooltip'
          $elem.attr('css-tooltipped-checked-width', $elem.width())

      # removes all qtips from and element, the elements that have a tooltip must have the property
      # data-qtip-configured set to 'yes'
      destroyAllTooltips: ($elem, withMercy) ->

        $elemsWithToolTip = $($elem).find('[data-qtip-configured=yes],[data-qtip-configured=true]')
        $elemsWithToolTip.each (index, elem) ->
          if $(elem).attr('data-qtip-have-mercy') == 'yes' and withMercy
            # I have mercy only once
            $(elem).attr('data-qtip-have-mercy', undefined)
            return

          $(elem).qtip('destroy', true)
          $(elem).attr('data-qtip-configured', null )

      getQltipSafePostion: ($jqueryElement, $tooltipContent=null) ->
        screenWidth = $( window ).width()
        screenHeight = $( window ).height()
        offset = $jqueryElement.offset()
        elemCenterX = offset.left - $( window ).scrollLeft() + $jqueryElement.width()/2
        elemCenterY = offset.top - $( window ).scrollTop() + $jqueryElement.height()/2

        horizontalPos = null
        if elemCenterX < screenWidth/4
          horizontalPos = 'left'
        else if elemCenterX >= screenWidth/4 and elemCenterX <= 3*screenWidth/4
          horizontalPos = 'center'
        else
          horizontalPos = 'right'

        myVert = null
        atVert = null
        if elemCenterY <= screenHeight/2
          myVert = 'top'
          atVert = 'bottom'
        else
          myVert = 'bottom'
          atVert = 'top'
        if $tooltipContent and $tooltipContent.height() >= offset.top
          myVert = 'top'
          atVert = 'bottom'
        return {
          my: myVert+' '+horizontalPos
          at: atVert+' '+horizontalPos
        }

      destroyAllTooltipsWhenMouseIsOut: ($container, mouseX, mouseY)->
        # This function destroys all tooltips immediately if the mouse is outside the element that the mouse left

        scrollTop = $(window).scrollTop()
        scrollLeft = $(window).scrollLeft()
        itemsContainerOffset = $container.offset().top

        containerYUpperLimit =  itemsContainerOffset - scrollTop
        containerYLowerLimit = (itemsContainerOffset + $container.height()) - scrollTop
        containerLeftLimit = $container.offset().left - scrollLeft
        containerRightLimit = ($container.offset().left + $container.width()) - scrollLeft

        xIsOut = (mouseX < containerLeftLimit) or (mouseX > containerRightLimit)
        yIsOut = (mouseY < containerYUpperLimit) or (mouseY > containerYLowerLimit)

        if xIsOut or yIsOut
          glados.Utils.Tooltips.destroyAllTooltips($($container))

      destroyAllTooltipsWhitMercy: ($container)->
        # With mercy means that it waits some time (defined in settings) before destroy the tooltips in $container
        # If an element is saved it is not destroyed. An tooltip is saved when the mouse hovers over it.

        setTimeout (-> glados.Utils.Tooltips.destroyAllTooltips($($container), withMercy=true)),
          glados.Settings.TOOLTIPS.DEFAULT_MERCY_TIME


    Fetching:
      fetchModelOnce: (model) ->

        timesFetched = model.get('glados_times_fetched')
        timesFetched ?= 0

        if timesFetched < 1
          model.set
            glados_times_fetched: 1
          model.fetch()

    URLS:
      shortenLinkIfTooLongAndOpen: (url) ->

        if glados.Utils.URLS.URLNeedsShortening(url)

          $('#GladosMainSplashScreen').show()
          urlToShorten = url.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]

          paramsDict =
            long_url: urlToShorten

          shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)
          shortenURL.then (data) ->

            hashGot = data.hash
            newHref = glados.Settings.SHORTENED_URL_GENERATOR
                hash: hashGot

            # check until I am sure that the has is accessible
            openLink = ->
              $('#GladosMainSplashScreen').hide()
              window.open newHref

            openIfReady = (data) ->


              if data.long_url?
                setTimeout openLink, 2000
              else
                setTimeout ->
                  checkIfURLReady = $.getJSON("#{glados.Settings.EXTEND_URLS_ENDPOINT_URL}/#{hashGot}")
                  checkIfURLReady.then openIfReady
                , 1000

            checkIfURLReady = $.getJSON("#{glados.Settings.EXTEND_URLS_ENDPOINT_URL}/#{hashGot}")
            checkIfURLReady.then openIfReady

        else
          window.open url

      getShortenedEmbebURLPromise: (url) ->

        urlToShorten = url.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]
        paramsDict =
          long_url: urlToShorten

        return glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)

      shortenHTMLLinkIfNecessary: ($anchor) ->
        if $anchor.attr('data-shortening-checked') != 'yes'

          href = $anchor.attr('href')
          if glados.Utils.URLS.URLNeedsShortening(href)
            $anchor.attr('data-original-href', $anchor.attr('href'))
            $anchor.attr('data-url-shortening-status', glados.Settings.URL_SHORTENING_STATUSES.REQUESTING_HASH)
            $anchor.removeAttr('href')
            $anchor.click(glados.Utils.URLS.handleShortenedAnchorClick)

            urlToShorten = href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]
            paramsDict =
              long_url: urlToShorten

            shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)
            shortenURL.then (data) ->
              newHref = glados.Settings.SHORTENED_URL_GENERATOR
                hash: data.hash
              $anchor.attr('href', newHref)
              $anchor.attr('data-url-shortening-status', glados.Settings.URL_SHORTENING_STATUSES.SUCCESS)
              $anchor.unbind('click', glados.Utils.URLS.handleShortenedAnchorClick)

            shortenURL.error ->
              $anchor.attr('data-url-shortening-status', glados.Settings.URL_SHORTENING_STATUSES.REQUESTING_ERROR)

          $anchor.attr('data-shortening-checked', 'yes')

      handleShortenedAnchorClick: (event) ->

        $clickedElem = $(event.currentTarget)
        if $clickedElem.attr('data-url-shortening-status') == glados.Settings.URL_SHORTENING_STATUSES.REQUESTING_HASH
          if $clickedElem.attr('data-qtip-configured') != 'yes'

            $qtipContent = $('<div>This url is too long. It is being shortened for you...</div>')
            qtipConfig =
              content:
                text: $qtipContent
              style:
                classes:'matrix-qtip qtip-light qtip-shadow'
              position: glados.Utils.Tooltips.getQltipSafePostion($clickedElem, $qtipContent)

            $clickedElem.qtip qtipConfig
            $clickedElem.qtip('api').show()
            $clickedElem.attr('data-qtip-configured', 'yes')

        else if $clickedElem.attr('data-url-shortening-status') == glados.Settings.URL_SHORTENING_STATUSES.REQUESTING_ERROR

          $clickedElem.qtip('destroy', true)

          $qtipContent = $('<div>This url is too long. However there was an error while shortening it...</div>')
          qtipConfig =
            content:
              text: $qtipContent
            style:
              classes:'matrix-qtip qtip-light qtip-shadow'
            position: glados.Utils.Tooltips.getQltipSafePostion($clickedElem, $qtipContent)

          $clickedElem.qtip qtipConfig
          $clickedElem.qtip('api').show()
          $clickedElem.attr('data-qtip-configured', 'yes')


      URLNeedsShortening: (url='', customMaxLength) ->

        maxLength = customMaxLength
        maxLength ?= glados.Settings.MAX_GENERATED_URL_LENGTH
        if url.length > maxLength
          matches = url.match(glados.Settings.NEEDS_SHORTENING_REGEXP)
          if matches?
            return true
        return false

      getCurrentModelChemblID: ->

        if GlobalVariables['CURRENT_MODEL_CHEMBL_ID']?
          return GlobalVariables['CURRENT_MODEL_CHEMBL_ID']

        if GlobalVariables['EMBEDED']
          return URLProcessor.getRequestedChemblIDWhenEmbedded()
        else
          return URLProcessor.getRequestedChemblID()

    Compounds:
      containsMetals: (molformula) ->

        nonMetals = ['H', 'C', 'N', 'O', 'P', 'S', 'F', 'Cl', 'Br', 'I']

        testMolformula = molformula
        testMolformula = testMolformula.replace(/[0-9]+/g, '')
        testMolformula = testMolformula.replace('.', '')

        for element in nonMetals
          testMolformula = testMolformula.replace(element, '')

        testMolformula = testMolformula.replace(element, '')

        return testMolformula.length > 0
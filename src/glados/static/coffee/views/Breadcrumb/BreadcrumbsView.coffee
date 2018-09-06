glados.useNameSpace 'glados.views.Breadcrumb',
  BreadcrumbsView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @
      @hideFilterMenu()

    render: ->

      @shortenedURL = undefined 
      $breadcrumbsContainer = $(@el).find('.BCK-dynamic-breadcrumbs')
      breadcrumbsList = @model.get('breadcrumbs_list')
      hideShareButton = @model.get('hide_share_button')
      glados.Utils.fillContentForElement $breadcrumbsContainer,
        breadcrumbs: breadcrumbsList
        hide_share_button: hideShareButton
        share_modal_id: @shareModalID

      $longFilterContent = $(@el).find('.BCK-filter-explain')
      longFilter = @model.get('long_filter')
      glados.Utils.fillContentForElement $longFilterContent,
        long_filter: longFilter

      @hideFilterMenu()
      @renderShareComponent()

    renderShareComponent: ->

      hideShareButton = @model.get('hide_share_button')
      askBeforeShortening = @model.get('ask_before_sortening')

      if not hideShareButton
        $modalTrigger = $(@el).find('.BCK-open-share-modal')

        templateParams =
          link_to_share: @model.get('long_filter_url')

        if not @$sharePageModal?
          @$sharePageModal = ButtonsHelper.generateModalFromTemplate($modalTrigger, 'Handlebars-share-page-modal',
            startingTop=undefined , endingTop=undefined, customID=undefined, templateParams=templateParams)
          @shareModalID = @$sharePageModal.attr('id')

        needsShortening = glados.Utils.URLS.URLNeedsShortening(window.location.href, 100)
        match = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)

        @renderURLContainer(window.location.href)

        if needsShortening and match?

          if askBeforeShortening
            $shortenBtnContainer = @$sharePageModal.find('.BCK-shortenBtnContainer')
            glados.Utils.fillContentForElement($shortenBtnContainer)
            $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')
            @shortenLinkBound = @shortenURL.bind(@)
            $shortenBTN.click(@shortenLinkBound)
          else

            $shorteningInfo = @$sharePageModal.find('.BCK-shortening-info')

            urlToShorten = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]
            paramsDict =
              long_url: urlToShorten
            shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)

            thisView = @
            shortenURL.then (data) ->
              newHref = glados.Settings.SHORTENED_URL_GENERATOR
                hash: data.hash
                absolute: true
              glados.Utils.fillContentForElement($shorteningInfo, {}, customTemplate=undefined, fillWithPreloader=true)
              $shorteningInfo.empty()
              thisView.renderURLContainer(newHref)

    events:
      'click .BCK-open-filter-explain': 'toggleFilterMenu'

    renderURLContainer: (link) ->

      $inkToShareContainer = @$sharePageModal.find('.BCK-LinkToShare')

      config =
        value: link

      ButtonsHelper.initCroppedContainer($inkToShareContainer, config, cleanup=true)

    toggleFilterMenu: -> $(@el).find('.BCK-filter-explain').slideToggle()
    openFilterMenu: -> $(@el).find('.BCK-filter-explain').show()
    hideFilterMenu: -> $(@el).find('.BCK-filter-explain').hide()

    shortenURL: ->

      $shorteningInfo = @$sharePageModal.find('.BCK-shortening-info')
      $shortenBtnContainer = @$sharePageModal.find('.BCK-shortenBtnContainer')
      $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')

      if $shortenBTN.hasClass('disabled')
        return

      if @shortenedURL?

        @renderURLContainer(@shortenedURL)
        @setButtonStatusAsExpanding()
        return

      $shortenBTN.addClass('disabled')
      glados.Utils.fillContentForElement($shorteningInfo, {}, customTemplate=undefined, fillWithPreloader=true)

      urlToShorten = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]

      paramsDict =
        long_url: urlToShorten

      shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)

      thisView = @
      shortenURL.then (data) ->
        newHref = glados.Settings.SHORTENED_URL_GENERATOR
          hash: data.hash
          absolute: true

        thisView.setButtonStatusAsExpanding()
        thisView.shortenedURL = newHref
        $shorteningInfo.empty()
        thisView.renderURLContainer(newHref)

      shortenURL.fail  ->

        glados.Utils.fillContentForElement($shorteningInfo, {msg: 'There was an error while shortening the URL.'})

    setButtonStatusAsExpanding: ->

      $shortenBtnContainer = @$sharePageModal.find('.BCK-shortenBtnContainer')
      $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')

      $shortenBTN.removeClass('disabled')
      $shortenBTN.text('Expand Link')
      $shortenBTN.off('click', @shortenLinkBound)

      @expandLinkBound = @expandURL.bind(@)
      $shortenBTN.click(@expandLinkBound)


    expandURL: ->

      @renderURLContainer(window.location.href)
      $shortenBtnContainer = @$sharePageModal.find('.BCK-shortenBtnContainer')
      $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')
      $shortenBTN.text('Shorten Link')
      $shortenBTN.off('click', @expandLinkBound)
      $shortenBTN.click(@shortenLinkBound)


# ----------------------------------------------------------------------------------------------------------------------
# Singleton
# ----------------------------------------------------------------------------------------------------------------------
glados.views.Breadcrumb.BreadcrumbsView.getInstance = ->
  if not glados.views.Breadcrumb.BreadcrumbsView.__view_instance?
    $breadcrumbsContainer = $('#BCK-breadcrumbs')
    glados.apps.Main.MainGladosApp.setUpLinkShortenerListener($breadcrumbsContainer[0])
    glados.views.Breadcrumb.BreadcrumbsView.__view_instance = new glados.views.Breadcrumb.BreadcrumbsView
      el: $breadcrumbsContainer
      model: glados.models.Breadcrumb.BreadcrumbModel.getInstance()

  return glados.views.Breadcrumb.BreadcrumbsView.__view_instance

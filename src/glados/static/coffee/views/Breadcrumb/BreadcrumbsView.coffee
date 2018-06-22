glados.useNameSpace 'glados.views.Breadcrumb',
  BreadcrumbsView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @
      @hideFilterMenu()

    render: ->

      $breadcrumbsContainer = $(@el).find('.BCK-dynamic-breadcrumbs')
      breadcrumbsList = @model.get('breadcrumbs_list')
      hideShareButton = @model.get('hide_share_button')
      glados.Utils.fillContentForElement $breadcrumbsContainer,
        breadcrumbs: breadcrumbsList
        hide_share_button: hideShareButton

      $longFilterContent = $(@el).find('.BCK-filter-explain')
      longFilter = @model.get('long_filter')
      glados.Utils.fillContentForElement $longFilterContent,
        long_filter: longFilter

      @hideFilterMenu()

      if not hideShareButton
        $modalTrigger = $(@el).find('.BCK-open-share-modal')

        templateParams =
          link_to_share: @model.get('long_filter_url')
        $editorModal = ButtonsHelper.generateModalFromTemplate($modalTrigger, 'Handlebars-share-page-modal',
          startingTop=undefined , endingTop=undefined, customID=undefined, templateParams=templateParams)

        needsShortening = glados.Utils.URLS.URLNeedsShortening(window.location.href, 100)
        match = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)

        $inkToShareContainer = $editorModal.find('.BCK-LinkToShare')

        config =
          value: window.location.href

        ButtonsHelper.initCroppedContainer($inkToShareContainer, config)

        if needsShortening and match?

          $shortenBtnContainer = $editorModal.find('.BCK-shortenBtnContainer')
          glados.Utils.fillContentForElement($shortenBtnContainer)
          return
          urlToShorten = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]
          $linkToShareURL.text('Loading...')
          paramsDict =
            long_url: urlToShorten

          shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)

          shortenURL.then (data) ->
            newHref = glados.Settings.SHORTENED_URL_GENERATOR
              hash: data.hash
              absolute: true
            $linkToShareURL.text(newHref)


    events:
      'click .BCK-open-filter-explain': 'toggleFilterMenu'

    toggleFilterMenu: -> $(@el).find('.BCK-filter-explain').slideToggle()
    openFilterMenu: -> $(@el).find('.BCK-filter-explain').show()
    hideFilterMenu: -> $(@el).find('.BCK-filter-explain').hide()

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

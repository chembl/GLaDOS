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
        @$sharePageModal = ButtonsHelper.generateModalFromTemplate($modalTrigger, 'Handlebars-share-page-modal',
          startingTop=undefined , endingTop=undefined, customID=undefined, templateParams=templateParams)

        needsShortening = glados.Utils.URLS.URLNeedsShortening(window.location.href, 100)
        match = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)

        @renderURLContainer(window.location.href)

        if needsShortening and match?

          $shortenBtnContainer = @$sharePageModal.find('.BCK-shortenBtnContainer')
          glados.Utils.fillContentForElement($shortenBtnContainer)
          $shortenBTN = $shortenBtnContainer.find('.BCK-Shorten-link')
          $shortenBTN.click(@shortenURL.bind(@))

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

      $shortenBTN.addClass('disabled')
      glados.Utils.fillContentForElement($shorteningInfo, {}, customTemplate=undefined, fillWithPreloader=true)
      urlToShorten = window.location.href.match(glados.Settings.SHORTENING_MATCH_REPEXG)[0]

      paramsDict =
        long_url: urlToShorten

      alert('shortening url')
      shortenURL = glados.doCSRFPost(glados.Settings.SHORTEN_URLS_ENDPOINT, paramsDict)

      thisView = @
      shortenURL.then (data) ->
        newHref = glados.Settings.SHORTENED_URL_GENERATOR
          hash: data.hash
          absolute: true

        $shortenBTN.removeClass('disabled')
        $shorteningInfo.empty()
        thisView.renderURLContainer(newHref)

      shortenURL.fail  ->

        glados.Utils.fillContentForElement($shorteningInfo, {msg: 'There was an error while shortening the URL.'})


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

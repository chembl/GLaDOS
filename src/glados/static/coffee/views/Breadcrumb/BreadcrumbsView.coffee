glados.useNameSpace 'glados.views.Breadcrumb',
  BreadcrumbsView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @

    render: ->

      @shortenedURL = undefined 
      $breadcrumbsContainer = $(@el).find('.BCK-dynamic-breadcrumbs')
      breadcrumbsList = @model.get('breadcrumbs_list')
      glados.Utils.fillContentForElement $breadcrumbsContainer,
        breadcrumbs: breadcrumbsList
        share_modal_id: @shareModalID

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

# Requires:
class LazyIFramesHelper

  # this initialises the links that you set up to load lazily an iframe
  # I need data-if-id and data-if-src, for example:
  #
  #  data-if-id="if_database_schema"
  #  data-if-src=glados.Settings.STATIC_URL+"chembl_schema_diagrams/src/schema.html
  #
  # I also need that the element is of the class iframe-lazy-loader
  #
  @initLazyIFrames = ->

    $('.iframe-lazy-loader').each ->

      currentLink = $(this)

      currentLink.click ->

        if !$(@).attr('data-if-loaded')?

          iframe_id = $(@).attr('data-if-id')
          $('#' + iframe_id).attr('src', $(@).attr('data-if-src'))
          $(@).attr('data-if-loaded', true)


  ### *
    * Bind the element's click event to the fetch function of the backbone object
    * this can be used when you need some data to be loaded only when a tab is opened.
    * @param {Jquery} element for which the click event will be bound
    * @param {Model} model to fetch
    *
  ###
  @loadObjectOnceOnClick = (elem, obj) ->


    elem.click ->
     if !$(@).attr('data-loaded')?
       obj.fetch()
       $(@).attr('data-loaded', true)


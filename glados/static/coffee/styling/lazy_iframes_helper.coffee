# Requires:
class LazyIFramesHelper

  # this initialises the links that you set up to load lazily an iframe
  # I need data-if-id and data-if-src, for example:
  #
  #  data-if-id="if_database_schema"
  #  data-if-src="/static/chembl_schema_diagrams/src/schema.html
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



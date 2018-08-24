glados.useNameSpace 'glados.helpers',
  URLHelper: class URLHelper

    @MODES:
      SEARCH_RESULTS: 'SEARCH_RESULTS'

    constructor: (@mode) ->

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------
glados.helpers.URLHelper.initInstance = (mode) ->

  if not mode?
    throw "You must specify a mode!"

  if not (mode in _.keys(@MODES))
    throw "Mode '#{mode}' is not valid"

  glados.helpers.URLHelper.__model_instance = new glados.helpers.URLHelper(mode)

glados.helpers.URLHelper.getInstance = -> glados.helpers.URLHelper.__model_instance

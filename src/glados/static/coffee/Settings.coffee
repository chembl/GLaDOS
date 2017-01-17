# ----------------------------------------------------------------------------------------------------------------------
# Name Space Utils
# ----------------------------------------------------------------------------------------------------------------------

baseNameSpace = {glados:{}}
#glados will be available directly on the global
glados = baseNameSpace.glados
#loaded extensions in the base namespace
baseNSLoadedPaths = []

# finds the specified namespace
glados.getNameSpace = (nameSpace) ->
  nsParts = nameSpace.split '.'
  curNS = baseNameSpace
  for nsI in nsParts
    if nsI not in _.keys(curNS)
      curNS[nsI] = {}
    curNS = curNS[nsI]
  return curNS

# search for an object from an specified namespace and returns it
glados.importFromNameSpace = (nameSpace,objectName) ->
  ns = glados.getNameSpace(nameSpace)
  return ns[objectName]

# include the specified extension definition in the specified namespace
# overriding any previous definitions using the same names
glados.useNameSpace = (nameSpace,extension) ->
  ns = glados.getNameSpace(nameSpace)
  for extIName in _.keys(extension)
    ns[extIName] = extension[extIName]
    baseNSLoadedPaths.push(nameSpace+"."+extIName+":"+typeof extension[extIName])

# logs the information of the objects loaded in the namespace tree
glados.logNameSpaceTree = ()->
  for loadedNS in baseNSLoadedPaths
    console.log(loadedNS)
  return null

# gets the screen type, LARGE, MEDIUM, or SMALL
glados.getScreenType = ->

  screenWidth = $( window ).width()

  return switch
    when screenWidth <= glados.Settings.SMALL_SCREEN_SIZE then glados.Settings.SMALL_SCREEN
    when glados.Settings.SMALL_SCREEN_SIZE < screenWidth <= glados.Settings.LARGE_SCREEN_SIZE then glados.Settings.MEDIUM_SCREEN
    when screenWidth > glados.Settings.LARGE_SCREEN_SIZE then glados.Settings.LARGE_SCREEN

# ----------------------------------------------------------------------------------------------------------------------
# Application Settings
# ----------------------------------------------------------------------------------------------------------------------

glados.useNameSpace 'glados',
  Settings :
    WS_HOSTNAME: 'https://www.ebi.ac.uk/'
    WS_BASE_URL: 'https://www.ebi.ac.uk/chembl/api/data/'
    BEAKER_BASE_URL: 'https://www.ebi.ac.uk/chembl/api/utils/'
    WS_DEV_BASE_URL: 'https://wwwdev.ebi.ac.uk/chembl/api/data/'
    # Searches
    SEARCH_INPUT_DEBOUNCE_TIME: 600
    # Paginated Collections
    TABLE_PAGE_SIZES: [5, 10, 20, 25, 50, 100]
    CARD_PAGE_SIZES: [6, 12]
    EMBL_GREEN: '#9fcc3b'
    EMBL_BLUE: '#008cb5'
    VISUALISATION_RED_MIN: '#f44336' # red lighten-5
    VISUALISATION_RED_MAX: '#b71c1c' # red darken-4
    VISUALISATION_TEAL_MIN: '#e0f2f1' #teal lighten-5
    VISUALISATION_TEAL_MAX: '#004d40' #teal darken-4
    VISUALISATION_GREY_BASE: '#9e9e9e' #grey
    VISUALISATION_CARD_GREY: '#fafafa' #fafafa grey lighten-5
    VISUALISATION_GREEN_MIN: '#e8f5e9' #e8f5e9 green lighten-5
    # for a responsive visualisation, the time that it waits for the container size
    RESPONSIVE_REPAINT_WAIT: 400
    # by default the debug is deactivated
    DEBUG: false
    DEFAULT_SIMILARITY_THRESHOLD: 70
    LARGE_SCREEN_SIZE: 992
    SMALL_SCREEN_SIZE: 600
    SMALL_SCREEN: 'SMALL_SCREEN'
    MEDIUM_SCREEN: 'MEDIUM_SCREEN'
    LARGE_SCREEN: 'LARGE_SCREEN'
    DEFAULT_CAROUSEL_SIZES:
      'SMALL_SCREEN': 1
      'MEDIUM_SCREEN': 2
      'LARGE_SCREEN': 3


# SERVER LOADED URLS / must be defined by the server configuration
glados.loadURLPaths = (request_root, app_root, static_root)->
  if request_root[request_root.length-1] == '/'
    request_root = request_root.substr(0, request_root.length-1)
  # Application URLS
  glados.Settings.STATIC_URL = static_root
  glados.Settings.GLADOS_BASE_PATH_REL = app_root
  glados.Settings.GLADOS_BASE_URL_FULL = request_root+app_root

  # the search url is expected to be search_results/[advanced/]:query_string
  glados.Settings.SEARCH_RESULTS_PAGE = glados.Settings.GLADOS_BASE_PATH_REL+'search_results'
  glados.Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH = 'advanced_search'
  glados.Settings.SEARCH_RESULT_URL_REGEXP = new RegExp('^'+glados.Settings.SEARCH_RESULTS_PAGE+
          '(/'+glados.Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH+')?/(.*?)$')
  glados.Settings.DEFAULT_CARD_PAGE_CONTENT_TEMPLATE_PATH = glados.Settings.GLADOS_BASE_PATH_REL+
          'templates/default_card_page_content.tmpl'

  glados.Settings.SUBSTRUCTURE_SEARCH_RESULTS_PAGE = glados.Settings.GLADOS_BASE_PATH_REL+'substructure_search_results/'
  glados.Settings.WS_BASE_SUBSTRUCTURE_SEARCH_URL = 'https://www.ebi.ac.uk/chembl/api/data/substructure/'

  glados.Settings.SIMILARITY_SEARCH_RESULTS_PAGE = glados.Settings.GLADOS_BASE_PATH_REL+'similarity_search_results/'
  glados.Settings.WS_BASE_SIMILARITY_SEARCH_URL = 'https://www.ebi.ac.uk/chembl/api/data/similarity/'

# Logs the JavaScript environment details
glados.logGladosSettings = () ->
  if glados.Settings.DEBUG
    console.log("---BEGIN GLaDOS JS ENVIRONMENT SETTINGS----------------------------------------------------------------")
    for keyI in _.keys(glados.Settings)
      console.log(keyI+":"+glados.Settings[keyI])
    console.log("---END GLaDOS JS ENVIRONMENT SETTINGS------------------------------------------------------------------")
    console.log("---BEGIN GLaDOS LOADED NAMESPACES----------------------------------------------------------------------")
    glados.logNameSpaceTree()
    console.log("---END GLaDOS LOADED NAMESPACES------------------------------------------------------------------------")
    console.log("Play nice and there will be CAKE!\n.\n.\n.\nThe CAKE is real, I promise!")

  GlobalVariables.CURRENT_SCREEN_TYPE = glados.getScreenType()
  GlobalVariables.CURRENT_SCREEN_TYPE_CHANGED = false

  # update screen type when resizing
  updateScreenType = ->
    newSType = glados.getScreenType()
    if newSType != GlobalVariables.CURRENT_SCREEN_TYPE
      GlobalVariables.CURRENT_SCREEN_TYPE = newSType
      GlobalVariables.CURRENT_SCREEN_TYPE_CHANGED = true
    else
      GlobalVariables.CURRENT_SCREEN_TYPE_CHANGED = false


  $(window).resize updateScreenType

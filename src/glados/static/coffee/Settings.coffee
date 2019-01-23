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
  Settings:
    MAX_GENERATED_URL_LENGTH: 1000
    URL_SHORTENING_STATUSES:
      REQUESTING_HASH: 'REQUESTING_HASH'
      REQUESTING_ERROR: 'REQUESTING_ERROR'
      SUCCESS: 'SUCCESS'
    PIECHARTS:
      MAX_CATEGORIES: 10
    VIS_COLORS:

      TEAL1: '#0D343A'
      TEAL2: '#025C5E'
      TEAL3: '#09979B'
      TEAL4: '#75D8D5'
      TEAL5: '#C4E6E5'
      TEAL6: '#D4FAF7'


      RED1: '#65323E'
      RED2: '#D33C60'
      RED3: '#FE7F9D'
      RED4: '#FFC0CB'
      RED5: '#F1D6DB'

      BLUE1: '#02355C'
      BLUE2: '#0F77C9'
      BLUE3: '#4EB1FF'
      BLUE4: '#94D0FF'
      BLUE5: '#C0E3FF'

      ORANGE1: '#A0221D'
      ORANGE2: '#EE4F4F'
      ORANGE3: '#FF855A'
      ORANGE4: '#FFB89E'
      ORANGE5: '#FFD5C5'

      YELLOW2: '#FDA420'
      YELLOW3: '#FFC107'
      YELLOW4: '#FFDE7C'
      YELLOW5: '#FCECBE'

      PURPLE1: '#3A49A2'
      PURPLE2: '#8795E8'


      GREY1: '#bbbbbb'
      GREY2: '#e4e4e4'
      GREY3: '#f1f1f1'
      WHITE: '#fff'

      LIGHT_GREEN5: '#f1f8e9'

    GLADOS_STRINGS_PREFIX: 'glados_es_gs__'
    WS_HOSTNAME: 'https://www.ebi.ac.uk/'
    WS_BASE_URL: 'https://www.ebi.ac.uk/chembl/api/data/'
    BEAKER_BASE_URL: 'https://www.ebi.ac.uk/chembl/api/utils/'
    # Searches
    SEARCH_INPUT_DEBOUNCE_TIME: 600
    # Paginated Collections
    TABLE_PAGE_SIZES: [5, 10, 20, 25, 50, 100]
    CARD_PAGE_SIZES: [6, 12, 24, 48, 96]
    EMBL_GREEN: '#9fcc3b'
    EMBL_BLUE: '#008cb5'
    VISUALISATION_SELECTED: '#4caf50' #4caf50 green
    VISUALISATION_RED_MIN: '#f44336' # red lighten-5
    VISUALISATION_RED_BASE: '#f44336' # red
    VISUALISATION_RED_MAX: '#b71c1c' # red darken-4
    VISUALISATION_LIGHT_GREEN_MIN: '#f1f8e9' # green lighten-5
    VISUALISATION_LIGHT_GREEN_BASE: '#8bc34a' # light-green base
    VISUALISATION_LIGHT_GREEN_MAX: '#33691e' # green darken-4
    VISUALISATION_GREEN_MIN: '#e8f5e9' # green lighten-5
    VISUALISATION_GREEN_BASE: '#4caf50' # green
    VISUALISATION_GREEN_MAX: '#1b5e20' # green darken-4
    VISUALISATION_TEAL_MIN: '#e0f2f1' #teal lighten-5
    VISUALISATION_TEAL_BASE: '#009688' #teal
    VISUALISATION_TEAL_MAX: '#004d40' #teal darken-4
    VISUALISATION_TEAL_ACCENT_4: '#00bfa5' #teal accent-4
    VISUALISATION_GREY_BASE: '#9e9e9e' #grey
    VISUALISATION_DARKEN_2: '#616161' #grey darken-2
    VISUALISATION_CARD_GREY: '#fafafa' #fafafa grey lighten-5
    VISUALISATION_BLUE_MIN: '#e3f2fd' # blue lighten-5
    VISUALISATION_BLUE_BASE: '#2196f3' #2196f3 blue
    VISUALISATION_BLUE_MAX: '#0d47a1' # blue darken-4
    VISUALISATION_LIGHT_BLUE_MIN: '#e1f5fe' # light-blue lighten-5
    VISUALISATION_LIGHT_BLUE_MAX: '#01579b' # light-blue darken-4
    VISUALISATION_AMBER_BASE: '#ffc107' # amber
    VISUALISATION_GRID_EXTERNAL_BORDER: '#D2D2D2'
    VISUALISATION_GRID_DIVIDER_LINES: '#bdbdbd' #grey lighten-1
    VISUALISATION_GRID_UNDEFINED: '#d9d9d9' #grey
    VISUALISATION_GRID_NO_DATA: '#eeeeee' #grey lighten-3
    VISUALISATION_GRID_PANELS: 'white' #grey lighten-4
    VISUALISATION_LEGEND_HEIGHT: 100
    VISUALISATION_LEGEND_RECT_HEIGHT: 20
    # for a responsive visualisation, the time that it waits for the container size
    RESPONSIVE_REPAINT_WAIT: 100
    RESPONSIVE_SIZE_CHECK_WAIT: 300
    # by default the debug is deactivated
    DEBUG: false
    DEFAULT_SIMILARITY_THRESHOLD: 85
    LARGE_SCREEN_SIZE: 992
    SMALL_SCREEN_SIZE: 600
    SMALL_SCREEN: 'SMALL_SCREEN'
    MEDIUM_SCREEN: 'MEDIUM_SCREEN'
    LARGE_SCREEN: 'LARGE_SCREEN'
    DEFAULT_CAROUSEL_SIZES:
      'SMALL_SCREEN': 1
      'MEDIUM_SCREEN': 2
      'LARGE_SCREEN': 3
    DEFAULT_FILE_FORMAT_NAMES:
      'CSV': 'CSV'
      'TSV': 'TSV'
      'SDF': 'SDF'
    DEFAULT_RESULTS_VIEWS_NAMES:
      'Matrix': 'Matrix'
      'Graph': 'Graph'
      'Table': 'Table'
      'Cards': 'Cards'
      'Infinite': 'Infinite'
      Heatmap: 'Heatmap'
    DEFAULT_RESULTS_VIEWS_ICONS:
      'Matrix': 'fa-th'
      'Graph': 'fa-area-chart'
      'Table': 'fa-table'
      'Cards': 'fa-newspaper-o'
      'Infinite': 'fa-ellipsis-v'
      Heatmap: 'fa-th'
    DEFAULT_NULL_VALUE_LABEL: 'No Data'
    DEFAULT_NULL_VALUE_LABEL_LEGEND: '---'
    INCOMPLETE_SELECTION_LIST_LABEL: 'INCOMPLETE_SELECTION_LIST'
     # If there is a value here, it means that the view is enable only if there is a certain number of items selected.
    # ranges include both numbers
    VIEW_SELECTION_THRESHOLDS:
      Heatmap: [0,1024, 300]
    VIEWS_DISABLED_WHILE_STREAMING: ['Heatmap', 'Graph']
    TOOLTIPS:
      DEFAULT_MERCY_TIME: 100
  Events:
    Collections:
      ALL_ITEMS_DOWNLOADED: 'ALL_ITEMS_DOWNLOADED'
      SELECTION_UPDATED: 'selection-changed'
      Params:
        ALL_SELECTED:'all-selected'
        ALL_UNSELECTED: 'all-unselected'
        SELECTED: 'select'
        UNSELECTED: 'unselect'
        BULK_SELECTED: 'bulk-selected'
        BULK_UNSELECTED: 'bulk-unselected'
    Compound:
      SIMILARITY_MAP_ERROR: 'SIMILARITY_MAP_ERROR'
      SIMILARITY_MAP_READY: 'SIMILARITY_MAP_READY'
      STRUCTURE_HIGHLIGHT_READY: 'STRUCTURE_HIGHLIGHT_READY'
      STRUCTURE_HIGHLIGHT_ERROR: 'STRUCTURE_HIGHLIGHT_ERROR'
    Legend:
      VALUE_SELECTED: 'value-selected'
      VALUE_UNSELECTED: 'value-unselected'
      RANGE_SELECTED: 'range-selected'
      RANGE_SELECTION_INVALID: 'range-selected-invalid'
  Visualisation:
    CATEGORICAL:'CATEGORICAL'
    CONTINUOUS:'CONTINUOUS'
    THRESHOLD:'THRESHOLD'
    Activity:
      OTHERS_LABEL:'Other'

# SERVER LOADED URLS / must be defined by the server configuration
glados.loadURLPaths = (request_root, app_root, static_root)->
  if request_root[request_root.length-1] == '/'
    request_root = request_root.substr(0, request_root.length-1)
  # Application URLS
  glados.Settings.STATIC_URL = static_root
  glados.Settings.GLADOS_BASE_PATH_REL = app_root
  glados.Settings.GLADOS_BASE_URL_DOMAIN = request_root+'/'
  glados.Settings.GLADOS_BASE_URL_FULL = request_root+app_root
  glados.Settings.NO_SIDE_NAV_PLACEHOLDER = 'g'
  glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL = glados.Settings.GLADOS_BASE_URL_FULL +
    glados.Settings.NO_SIDE_NAV_PLACEHOLDER + '/#'

  glados.Settings.STATIC_IMAGES_URL = static_root + 'img/'

  # Marvin full screen URL
  glados.Settings.MARVIN_FULL_SCREEN_PAGE = glados.Settings.GLADOS_BASE_PATH_REL+'marvin_search_fullscreen/'

  glados.Settings.SUBSTRUCTURE_SEARCH_RESULTS_PAGE = glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL +
    'substructure_search_results/'
  glados.Settings.WS_BASE_SUBSTRUCTURE_SEARCH_URL = 'https://www.ebi.ac.uk/chembl/api/data/substructure.json'

  glados.Settings.SIMILARITY_SEARCH_RESULTS_PAGE = glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL +
    'similarity_search_results/'
  glados.Settings.WS_BASE_SIMILARITY_SEARCH_URL = 'https://www.ebi.ac.uk/chembl/api/data/similarity.json'

  glados.Settings.FLEXMATCH_SEARCH_RESULTS_PAGE = glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL +
    'flexmatch_search_results/'
  glados.Settings.WS_BASE_FLEXMATCH_SEARCH_URL = 'https://www.ebi.ac.uk/chembl/api/data/molecule.json'

  glados.Settings.BASE_COMPOUND_METABOLISM_FS_URL = '/compound_metabolism/'

  glados.Settings.OLD_DEFAULT_IMAGES_BASE_URL = 'https://www.ebi.ac.uk/chembl/compound/displayimage_large/'

  glados.Settings.NEEDS_SHORTENING_REGEXP = \
  new RegExp("#{glados.Settings.GLADOS_BASE_PATH_REL}#{glados.Settings.NO_SIDE_NAV_PLACEHOLDER}(/)?#")

  glados.Settings.SHORTENING_MATCH_REPEXG = new RegExp("#.*$")

# tells if the page is being run from ebi servers
glados.isInEBIProdServers = -> glados.Settings.GLADOS_BASE_URL_DOMAIN.match(/http[s]?:\/\/www\.ebi\.ac\.uk\//g)?

# Loads the GLaDOS Top S3cre7 data, do not remove or js calls to post method in the django server will fail
glados.loadGLaDOSTopS3cre7 = ()->
  glados.GLaDOSTopS3cre7 =
    CSRF:
      name: 'csrfmiddlewaretoken'
      value:  $('.GLaDOS-top-s3cre7').find("[name=\"csrfmiddlewaretoken\"]").val()

glados.doCSRFPost = (gladosServicePath, paramsDict)->
  formData = new FormData()
  formData.append glados.GLaDOSTopS3cre7.CSRF.name, glados.GLaDOSTopS3cre7.CSRF.value
  for param, value of paramsDict
    formData.append param, value
  ajax_deferred = $.post
    url: glados.Settings.GLADOS_BASE_URL_FULL + gladosServicePath
    data: formData
    enctype: 'multipart/form-data'
    processData: false
    contentType: false
    cache: false
  return ajax_deferred

# This function must be called after loadURLPaths and glados.models.paginatedCollections.Settings has loaded
glados.loadSearchResultsURLS = ()->

  # the search url is expected to be search_results/[(compounds|targets ... et al)/][advanced/]:query_string
  elastic_search_paths = []
  glados.Settings.SEARCH_PATH_2_ES_KEY = {}
  glados.Settings.ES_KEY_2_SEARCH_PATH = {}
  for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES
    path_i = val_i.LABEL.toLowerCase()
    elastic_search_paths.push(path_i)
    glados.Settings.SEARCH_PATH_2_ES_KEY[path_i] = key_i
    glados.Settings.ES_KEY_2_SEARCH_PATH[key_i] = path_i

  glados.Settings.ENTITY_NAME_TO_ENTITY = {}
  for Entity in [Compound, Target, Assay, Document, CellLine, glados.models.Tissue, Assay, Activity]
    glados.Settings.ENTITY_NAME_TO_ENTITY[Entity.prototype.entityName] = Entity

  glados.Settings.GENERATE_SERVER_SIDE_DOWNLOAD_ENDPOINT = 'generate-download'
  glados.Settings.SEARCH_RESULTS_PARSER_ENDPOINT = 'search_results_parser'
  glados.Settings.SHORTEN_URLS_ENDPOINT = 'shorten_url'
  glados.Settings.EXTEND_URLS_ENDPOINT = 'extend_url'
  glados.Settings.ELASTICSEARCH_CACHE = 'elasticsearch_cache'
  glados.Settings.REGISTER_USAGE_ENDPOINT = 'register_usage'
  glados.Settings.SHORTEN_URLS_URL = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{glados.Settings.SHORTEN_URLS_ENDPOINT}"
  glados.Settings.EXTEND_URLS_ENDPOINT_URL = "#{glados.Settings.GLADOS_BASE_PATH_REL}#{glados.Settings.EXTEND_URLS_ENDPOINT}"
  glados.Settings.SHORTENED_URL_GENERATOR =
  Handlebars.compile("{{#if absolute}}#{glados.Settings.GLADOS_BASE_URL_FULL}{{else}}#{glados.Settings.GLADOS_BASE_PATH_REL}{{/if}}#{glados.Settings.NO_SIDE_NAV_PLACEHOLDER}/tiny/{{{hash}}}")

  glados.Settings.SHORTENED_EMBED_URL_GENERATOR =
  Handlebars.compile("#{glados.Settings.GLADOS_BASE_URL_FULL}embed/tiny/{{{hash}}}")

  glados.Settings.ENTITY_BROWSERS_URL_TEMPLATE = "{{#if fragment_only}}\#{{else}}#{glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL}{{/if}}" +
    "browse/{{entity}}" +
    "{{#if filter}}" +
      "{{#if is_full_state}}/full_state/{{else}}/filter/{{/if}}" +
    "{{filter}}" +
    "{{/if}}"
  glados.Settings.ENTITY_BROWSERS_URL_GENERATOR = Handlebars.compile(glados.Settings.ENTITY_BROWSERS_URL_TEMPLATE)

  glados.Settings.SIMILARITY_URL_TEMPLATE = glados.Settings.GLADOS_MAIN_ROUTER_BASE_URL +
    "similarity_search_results/{{{term}}}/{{{threshold}}}"
  glados.Settings.SIMILARITY_URL_GENERATOR = Handlebars.compile(glados.Settings.SIMILARITY_URL_TEMPLATE)

  glados.Settings.SEARCH_URL_TEMPLATE = "{{base_url}}search_results/{{tab}}" +
    "{{#if query}}/query={{query}}{{/if}}" +
    "{{#if state}}/state={{state}}{{/if}}"
  glados.Settings.SEARCH_URL_GENERATOR = Handlebars.compile(glados.Settings.SEARCH_URL_TEMPLATE)

# Logs the JavaScript environment details
glados.logGladosSettings = () ->
  if glados.Settings.DEBUG
    console.log("---BEGIN GLaDOS JS ENVIRONMENT SETTINGS--------------------------------------------------------------")
    for keyI in _.keys(glados.Settings)
      console.log(keyI+":"+glados.Settings[keyI])
    console.log("---END GLaDOS JS ENVIRONMENT SETTINGS----------------------------------------------------------------")
    console.log("---BEGIN GLaDOS LOADED NAMESPACES--------------------------------------------------------------------")
    glados.logNameSpaceTree()
    console.log("---END GLaDOS LOADED NAMESPACES----------------------------------------------------------------------")
    console.log("Play nice and there will be CAKE!\n.\n.\n.\nThe CAKE is real, I promise!")
    console.log("♫ ♬ Searching compounds, all day long, searching compounds while I sing this song... ♫ ♬")
    console.log("Studying hard to pass the Turing test!")
    console.log("What are you looking at, human?")

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

# setups variables and functions to check whether or not the page has loaded
glados.setupOnLoadAfterJS = () ->
  js_ready_div = '<div id="GLaDOS-page-loaded" style="display: none;">NO</div>'
  $('body').prepend(js_ready_div)
  glados.ajax_count = 0
  $(document).ajaxStart () ->
    glados.ajax_count++
    $('#GLaDOS-page-loaded').html('NO')
    # The code in charge of showing the splash screen will be the router
#    $('#GladosMainSplashScreen').show()
  $(document).ajaxStop () ->
    glados.ajax_count--
    if glados.ajax_count == 0
      _.delay(
        () ->
          # Double check that ajax truly stopped
          if glados.ajax_count == 0
            $('#GLaDOS-page-loaded').html('YES')
        , 500
      )

$( "body" ).ready(glados.setupOnLoadAfterJS)

# enable this variable to prevent unsafe calls like saveAs from file saver
glados.JS_TEST_MODE = false

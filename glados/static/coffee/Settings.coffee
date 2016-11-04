Settings =
  WS_HOSTNAME: 'https://www.ebi.ac.uk/'
  WS_BASE_URL: 'https://www.ebi.ac.uk/chembl/api/data/'
  BEAKER_BASE_URL: 'https://www.ebi.ac.uk/chembl/api/utils/'
  WS_DEV_BASE_URL: 'https://wwwdev.ebi.ac.uk/chembl/api/data/'
  # Searches
  SEARCH_INPUT_DEBOUNCE_TIME: 600
  # Paginated Collections
  TABLE_PAGE_SIZES: [5, 10, 20, 25, 50, 100]
  CARD_PAGE_SIZES: [6, 12]
  EMBED_BASE_URL: "glados-ebitest.rhcloud.com/"
  EMBL_GREEN: '#9fcc3b'
  EMBL_BLUE: '#008cb5'

# Application URLS

Settings.ROOT_URL_PATH = "/"

# the search url is expected to be search_results/[advanced/]:query_string
Settings.SEARCH_RESULTS_PAGE = Settings.ROOT_URL_PATH+'search_results'
Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH = 'advanced_search'
Settings.SEARCH_RESULT_URL_REGEXP = new RegExp('^'+Settings.SEARCH_RESULTS_PAGE+
        '(/'+Settings.SEARCH_RESULTS_PAGE_ADVANCED_PATH+')?/(.*?)$')

# elastic search config
Settings.ES_BASE_URL = 'http://localhost:9200'
Settings.ES_INDEXES = {}
Settings.ES_INDEXES.COMPOUND = '/chembl_molecule'

# ----------------------------------------------------------------------------------------------------------------------
# Name Space Utils
# ----------------------------------------------------------------------------------------------------------------------

baseNameSpace = {glados:{}}
#glados will be available directly on the global
glados = baseNameSpace.glados

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

# logs the information of the objects loaded in the namespace tree
glados.logNameSpaceTree = (curNS,path)->
  if _.isUndefined(curNS)
    curNS = baseNameSpace
    path = ""
  if _.isObject(curNS) and _.keys(curNS).length > 0
    for nodeIName in _.keys(curNS)
      if nodeIName and nodeIName[0] != '_'
        glados.logNameSpaceTree(curNS[nodeIName],path+"."+nodeIName)
  else
    console.log(path+":"+typeof curNS)

# Logs the JavaScript environment details
glados.logGladosSettings = () ->
  console.log("---BEGIN GLaDOS JS ENVIRONMENT SETTINGS----------------------------------------------------------------")
  for keyI in _.keys(Settings)
    console.log(keyI+":"+Settings[keyI])
  console.log("---END GLaDOS JS ENVIRONMENT SETTINGS------------------------------------------------------------------")
  console.log("---BEGIN GLaDOS LOADED NAMESPACES----------------------------------------------------------------------")
  glados.logNameSpaceTree()
  console.log("---END GLaDOS LOADED NAMESPACES------------------------------------------------------------------------")
  console.log("Play nice and there will be CAKE!\n.\n.\n.\nThe CAKE is real, I promise!")
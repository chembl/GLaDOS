glados.useNameSpace 'glados.apps',
  VisualisePageApp: class VisualisePageApp

    @init = ->
      console.log 'init visualisations page'
      glados.apps.Main.MainGladosApp.hideMainSplashScreen()
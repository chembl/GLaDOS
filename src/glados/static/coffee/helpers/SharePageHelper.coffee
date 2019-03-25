glados.useNameSpace 'glados.helpers',
  SharePageHelper: class SharePageHelper

    @showSharePageModal = ->

      modalID = 'modal-SharePage'
      $modal = $("#BCK-GeneratedModalsContainer ##{modalID}")

      if $modal.length == 0

        $modal = ButtonsHelper.generateModalFromTemplate($trigger=undefined, 'Handlebars-Search-SharePageModal',
          startingTop=undefined, endingTop=undefined, customID=modalID)

      if not @sharePageView?

        sharePageModel = new glados.models.SharePage.SharePageModel
          long_href: window.location.href

        @sharePageView = new glados.views.SharePage.SharePageView
          el: $modal
          model: sharePageModel

      @sharePageView.render()
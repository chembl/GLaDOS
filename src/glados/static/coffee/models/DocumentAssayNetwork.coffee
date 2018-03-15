DocumentAssayNetwork = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  fetch: ->
    docChemblId = @get('document_chembl_id')

    assaysUrl = glados.Settings.WS_BASE_URL + 'assay.json?document_chembl_id=' + docChemblId + '&limit=1000'

    allAssays = {}

    #this is to know when I finished to get all activities
    activitiesListsRequested = 0
    activitiesListsReceived = 0

    # 1. Get all the Assays from the document chembl id, in some cases it needs to iterate over the pagination
    # because there are too many, for example CHEMBL2766011
    triggerAssayRequest = (currentUrl) ->

      getAssaysGroup = $.getJSON currentUrl, (response) ->
        newAssays = response.assays

        $.each newAssays, (index, newAssay) ->
          allAssays[newAssay.assay_chembl_id] = newAssay
          currentActsUrl = glados.Settings.WS_BASE_URL + 'activity.json?assay_chembl_id=' + newAssay.assay_chembl_id + '&limit=1000'
          activitiesListsRequested++
          triggerActivityRequest(currentActsUrl)

        nextUrl = response.page_meta.next

        if nextUrl?
          triggerAssayRequest(glados.Settings.WS_HOSTNAME + nextUrl)
          # if there is no next I must have processed the last page


      getAssaysGroup.fail ->
        console.log 'FAILED getting assays list!'

    triggerAssayRequest(assaysUrl)


    #
    # 2. For each assay that I receive in the previous function, I trigger a retrieval of the activities.
    #
    triggerActivityRequest = (currentActsUrl) ->

      getActivityGroup = $.getJSON currentActsUrl, (response) ->
        newActivities = response.activities

        $.each newActivities, (index, newActivity) ->
          currentAssay = allAssays[newActivity.assay_chembl_id]
          currentAssay.compound_act_list = {} unless currentAssay.compound_act_list?
          currentAssay.compound_act_list[newActivity.molecule_chembl_id] = 1


        nextUrl = response.page_meta.next

        if nextUrl?

          fixedHostname = glados.Settings.WS_HOSTNAME.slice(0, glados.Settings.WS_HOSTNAME.length - 1)
          triggerActivityRequest(fixedHostname + nextUrl)
        else
          activitiesListsReceived++
          checkIfAllInfoReady()

      getActivityGroup.fail ->
        console.log 'FAILED activities list!'

    # here I check if I got all the information I need
    # Now, what is required is to reorganise it to create the graphs
    # no more calls to the web services
    nodes = []
    links = []
    thisModel = @

    checkIfAllInfoReady = () ->

      if activitiesListsRequested == activitiesListsReceived

        # reorganise assays as list to make sure the output format is given correctly
        $.each allAssays, (index, assay) ->

          assay.name = assay.assay_chembl_id
          nodes.push assay

        $.each nodes, (i, assayI) ->

          compoundsI = assayI.compound_act_list

          $.each nodes, (j, assayJ) ->

            # the matrix is symmetric, don't do the computing twice
            if i > j
              return

            compoundsJ = assayJ.compound_act_list

            numEqual = 0
            for molecule_chembl_id, val of compoundsI
              if compoundsJ[molecule_chembl_id] == 1
                numEqual++

            links.push
              "source":i
              "target": j
              "value":numEqual
              "source_name": assayI.assay_chembl_id
              "target_name": assayJ.assay_chembl_id

        answer = {'nodes': nodes, 'links': links}
        thisModel.set('graph', answer)

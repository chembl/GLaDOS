DocumentAssayNetwork = Backbone.Model.extend

  fetch: ->

    docChemblId = @get('document_chembl_id')

    assaysUrl = 'https://www.ebi.ac.uk/chembl/api/data/assay.json?document_chembl_id=' + docChemblId + '&limit=10'

    # 1. Get all the Assays from the document chembl id, in some cases it needs to iterate over the pagination
    # because there are too many, for example CHEMBL2766011
    triggerAssayRequest = (currentUrl) ->

      getAssaysGroup = $.getJSON currentUrl, (response) ->
        console.log('response!')
        console.log response

        newAssays = response.assays
        nextUrl = response.page_meta.next

        console.log 'Next: ', response.page_meta.next?
        console.log 'Next url: ', nextUrl

        if nextUrl?
          triggerAssayRequest('https://www.ebi.ac.uk' + nextUrl)



      getAssaysGroup.fail ->

        console.log 'FAILED!'

    triggerAssayRequest(assaysUrl)

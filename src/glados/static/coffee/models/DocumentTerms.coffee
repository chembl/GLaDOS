DocumentTerms = Backbone.Model.extend

  initialize: ->

    @url = glados.Settings.WS_BASE_URL + 'document_term.json?document_chembl_id=' + @get('document_chembl_id') + '&order_by=-score'

  parse: (response) ->

    rawTerms = response['document_terms']
    wordList = ([term.term_text, parseFloat(term.score)] for term in rawTerms)

    return {word_list: wordList}

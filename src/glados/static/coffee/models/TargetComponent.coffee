TargetComponent = Backbone.Model.extend

  parse: (data) ->
    parsed = data
    parsed.accession_url = ''
    if _.has(parsed, 'accession')
      parsed.accession_url =  'http://www.uniprot.org/uniprot/'+parsed.accession
    return parsed;
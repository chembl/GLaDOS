DrugBrowserInfinityView = Backbone.View.extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->

    $row = $('<div class="row">')
    $(@el).append($row)

    for model in @collection.models

      card_cont = Handlebars.compile($('#Handlebars-DrugBrowser-Card').html())
        columns: @collection.getMeta('columns')

      $newContent = $(card_cont);
      $row.append($newContent);
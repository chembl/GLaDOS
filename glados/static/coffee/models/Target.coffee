Target = Backbone.RelationalModel.extend

  idAttribute: 'target_chembl_id'

  initialize: ->
    @on 'change', @getProteinTargetClassification, @
    @url = 'https://www.ebi.ac.uk/chembl/api/data/target/' + @get('target_chembl_id') + '.json'

  getProteinTargetClassification: ->

    target_components = @get('target_components')
    console.log('changed!')
    console.log(@)

    if target_components?

      @set('protein_classifications', {}, {silent:true})
      console.log('getProteinTargetClassification()!')

      get_proxy = $.proxy(@get, @)

      # step 1: I get the component id of each of the target components
      for comp in target_components
        component_id = comp['component_id']
        comp_url = 'https://www.ebi.ac.uk/chembl/api/data/target_component/' + component_id + '.json'

        # step 2: I request the details of the current component
        $.get(comp_url).done(

          (data) ->

            protein_classifications = data['protein_classifications']
            for prot_class in protein_classifications

              prot_class_id = prot_class['protein_classification_id']

              # step 3: Now that I got the protein class id, I need to check if it is already there, it can be repeated
              # so I will only make a call when necessary
              prot_class_dict = get_proxy('protein_classifications')

              if !prot_class_dict[prot_class_id]?
                # I don't have that protein classification, So I need to add it to the dictionary and make a
                # call to get the details
                prot_class_dict[prot_class_id] = []
                prot_class_url = 'https://www.ebi.ac.uk/chembl/api/data/protein_class/' + prot_class_id + '.json'

                $.get(prot_class_url).done(
                  (data) ->
                     prot_class_dict[data['protein_class_id']] = ( data['l' + num] for num in [1..8] )
                ).fail(
                  () -> console.log('failed2!')
                )


        ).fail(
          () -> console.log('failed!')
        )

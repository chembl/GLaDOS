glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  MechanismsOfActionList:

    initURL: (chemblID) ->
      @url = "#{glados.models.paginatedCollections.Settings.ES_BASE_URL}/chembl_mechanism/_search?q=#{chemblID}"

    parse: (data) ->

      mechanisms = data.hits.hits
      mechanismsIndex = {}
      for rawMechanism in mechanisms

        mechData = rawMechanism._source
        mechIdentifier = "#{mechData.target_chembl_id}-#{mechData.mechanism_of_action}"

        if not mechanismsIndex[mechIdentifier]?
          mechanismsIndex[mechIdentifier] = $.extend
            mech_identifier: mechIdentifier
            molecule_chembl_ids: [mechData.molecule_chembl_id]
            ,
            mechData
        else
          # add new references if we have new ones.
          currentRefs = _.indexBy(mechanismsIndex[mechIdentifier].mechanism_refs, 'ref_id')
          newRefsIndex = _.indexBy(mechData.mechanism_refs, 'ref_id')

          for newRefID, newRef of newRefsIndex
            if not currentRefs[newRefID]?
              mechanismsIndex[mechIdentifier].mechanism_refs.push newRef

          currentChemblID = mechData.molecule_chembl_id
          if not _.contains(mechanismsIndex[mechIdentifier].molecule_chembl_ids, currentChemblID)
            mechanismsIndex[mechIdentifier].molecule_chembl_ids.push currentChemblID

      return _.sortBy(_.values(mechanismsIndex), 'mechanism_of_action')

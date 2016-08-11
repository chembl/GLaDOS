TargetRelationList = PaginatedCollection.extend

  model: TargetRelation

  parse: (data) ->

    return data.target_relations
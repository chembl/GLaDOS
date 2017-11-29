describe "Target Relations", ->
  targetRels = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
  targetRels.initURL 'CHEMBL3559691'

  #TODO: remove dependence from server on this test
#  beforeAll (done) ->
#    targetRels.fetch()
#
#    # this timeout is to give time to get the
#    # target classification information, it happens after the fetch,
#    # there is a way to know that it loaded at least one classification: get('protein_classifications_loaded')
#    # but there is no way to know that it loaded all the classifications.
#    setTimeout ( ->
#      done()
#    ), 10000

#  it "(SERVER DEPENDENT) fetches the information correctly for CHEMBL3559691", (done) ->
#
#    dataMustBe = [["CHEMBL1795191","Cyclin-dependent kinase 10"],["CHEMBL1795192","Cyclin-dependent kinase 13"],["CHEMBL1907600","Cyclin-dependent kinase 5/CDK5 activator 1"],["CHEMBL1907601","Cyclin-dependent kinase 4/cyclin D1"],["CHEMBL1907602","Cyclin-dependent kinase 1/cyclin B1"],["CHEMBL1907605","Cyclin-dependent kinase 2/cyclin E1"],["CHEMBL2094126","Cyclin-dependent kinase 2/cyclin E"],["CHEMBL2094127","Cyclin-dependent kinase 1/cyclin B"],["CHEMBL2094128","Cyclin-dependent kinase 2/cyclin A"],["CHEMBL2095942","Cyclin-dependent kinase 4/cyclin D"],["CHEMBL2111288","Cyclin-dependent kinase 7/ cyclin H"],["CHEMBL2111326","Cyclin-dependent kinase 2 and 4 (CDK2 and CDK4)"],["CHEMBL2111389","CDK9/cyclin T1"],["CHEMBL2111444","CDK3/cyclin E"],["CHEMBL2111448","CDK6/cyclin D3"],["CHEMBL2111455","CDK6/cyclin D1"],["CHEMBL2508","Cyclin-dependent kinase 6"],["CHEMBL301","Cyclin-dependent kinase 2"],["CHEMBL3038467","CDK1/Cyclin A"],["CHEMBL3038468","CDK1/Cyclin E"],["CHEMBL3038469","CDK2/Cyclin A"],["CHEMBL3038470","CDK2/Cyclin A1"],["CHEMBL3038471","CDK3/Cyclin E"],["CHEMBL3038472","CDK4/Cyclin D3"],["CHEMBL3038473","CDK7/Cyclin H/MNAT1"],["CHEMBL3038474","CDK8/Cyclin C"],["CHEMBL3038475","CDK9/Cyclin K"],["CHEMBL3038517","CDK2/CDK4"],["CHEMBL3055","Cyclin-dependent kinase 7"],["CHEMBL308","Cyclin-dependent kinase 1"],["CHEMBL3116","Cyclin-dependent kinase 9"],["CHEMBL3301385","Cyclin-dependent kinase 4/cyclin D2"],["CHEMBL3301386","CDK6/cyclin D2"],["CHEMBL331","Cyclin-dependent kinase 4"],["CHEMBL4036","Cyclin-dependent kinase 5"],["CHEMBL4442","Cyclin-dependent kinase 3"],["CHEMBL4597","Serine/threonine-protein kinase PCTAIRE-1"],["CHEMBL5316","Serine/threonine-protein kinase PCTAIRE-3"],["CHEMBL5719","Cell division protein kinase 8"],["CHEMBL5790","Serine/threonine-protein kinase PCTAIRE-2"],["CHEMBL5808","PITSLRE serine/threonine-protein kinase CDC2L1"],["CHEMBL5856","Serine/threonine-protein kinase PFTAIRE-2"],["CHEMBL6002","Cell division cycle 2-like protein kinase 6"],["CHEMBL6162","Serine/threonine-protein kinase PFTAIRE-1"]]
#
#    data = _.map(targetRels.models, (o)-> [o.get('target_chembl_id'), o.get('pref_name')])
#    assert_data(targetRels, dataMustBe)
#
#    done()

  # ------------------------------
  # Helpers
  # ------------------------------

  assert_data = (collection, dataMustBe) ->

    data_obtained = _.map(collection.models, (o)-> [o.get('target_chembl_id'), o.get('pref_name')])

    comparator = _.zip(data_obtained, dataMustBe)
    for elem in comparator

      expect(elem[0][0]).toBe(elem[1][0])
      expect(elem[0][1]).toBe(elem[1][1])
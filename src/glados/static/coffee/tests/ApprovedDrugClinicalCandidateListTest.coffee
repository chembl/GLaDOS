describe "Approved Drug and Clinical Candidate List", ->

  appDrugsClinCandsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
  appDrugsClinCandsList.initURL 'CHEMBL2364670'

  beforeAll (done) ->

    appDrugsClinCandsList.fetch()

    setTimeout ( ->
      done()
    ), 5000

  it "(SERVER DEPENDENT) loads the information correctly after the multiple calls", (done) ->

    models = []

    model1 = appDrugsClinCandsList.get('CHEMBL1003')
    models.push(model1)
    model2 = appDrugsClinCandsList.get('CHEMBL1439')
    models.push(model2)
    model3 = appDrugsClinCandsList.get('CHEMBL1200944')
    models.push(model3)
    model4 = appDrugsClinCandsList.get('CHEMBL2107817')
    models.push(model4)

    expect(model1.get('pref_name')).toBe('CLAVULANATE POTASSIUM')
    expect(model2.get('pref_name')).toBe('TAZOBACTAM SODIUM')
    expect(model3.get('pref_name')).toBe('SULBACTAM SODIUM')
    expect(model4.get('pref_name')).toBe('AVIBACTAM SODIUM')

    for i in [0..3]

      model = models[i]
      expect(model.get('mechanism_of_action')).toBe('Bacterial beta-lactamase TEM inhibitor')
      expect(model.get('max_phase')).toBe(4)



    done()
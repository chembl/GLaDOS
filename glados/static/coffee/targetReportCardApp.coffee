class TargetReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  @initTarget = (chembl_id) ->
    target = new Target
      target_chembl_id: chembl_id

    target.url = 'https://www.ebi.ac.uk/chembl/api/data/target/' + chembl_id + '.json'
    return target
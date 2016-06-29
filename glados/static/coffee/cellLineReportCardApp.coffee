class CellLineReportCardApp

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------

  @initCellLine = (chembl_id) ->
    cell_line = new CellLine
      cell_chembl_id: chembl_id

    cell_line.url = 'https://www.ebi.ac.uk/chembl/api/data/cell_line/' + chembl_id + '.json'
    return cell_line
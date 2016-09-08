# View that renders the Compound Calculated Properties Section
# of the compound report card
CompoundCalculatedParentPropertiesView = CardView.extend(DownloadViewExt).extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->

    if not @model.get('molecule_properties')?
      $('#CalculatedCompoundParentProperties').hide()
      return

    thisView = @
    $.each @mol_properties, ( key, elem_id ) ->
      value = thisView.model.get('molecule_properties')[key]
      value = '--' unless value?
      $('#' + elem_id).text(value)

    @initEmbedModal('calculated_properties')
    @activateModals()
    @showVisibleContent()

  mol_properties:
    'full_mwt': 'Bck-CalcCompProp-MolWt'
    'mw_monoisotopic': 'Bck-CalcCompProp-MolWtM'
    'alogp':'Bck-CalcCompProp-ALogP'
    'rtb': 'Bck-CalcCompProp-RotBonds'
    'psa':'Bck-CalcCompProp-PSA'
    'molecular_species':'Bck-CalcCompProp-Msp'
    'hba': 'Bck-CalcCompProp-HBA'
    'hbd': 'Bck-CalcCompProp-HBD'
    'num_ro5_violations': 'Bck-CalcCompProp-RO5'
    'acd_most_apka': 'Bck-CalcCompProp-APKA'
    'acd_most_bpka': 'Bck-CalcCompProp-BPKA'
    'acd_logp': 'Bck-CalcCompProp-ACDLogP'
    'acd_logd': 'Bck-CalcCompProp-ACDLogD'
    'aromatic_rings': 'Bck-CalcCompProp-AR'
    'heavy_atoms': 'Bck-CalcCompProp-HA'
    'qed_weighted': 'Bck-CalcCompProp-QEDW'

  # -----------------------------------------------------------------
  # ---- Downloads
  # -----------------------------------------------------------------

  downloadParserFunction: (attributes) ->

    return attributes.molecule_properties

  getFilename: (format) ->

    if format == 'csv'
      return @model.get('molecule_chembl_id') + 'CalculatedParentProperties.csv'
    else if format == 'json'
      return @model.get('molecule_chembl_id') + 'CalculatedParentProperties.json'
    else
      return 'file.txt'
# View that renders the Compound Calculated Properties Section
# of the compound report card
CompoundCalculatedParentPropertiesView = CardView.extend(DownloadViewExt).extend

  initialize: ->
    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'


  render: ->

    if not @model.get('molecule_properties')?
      @hideSection()
      return

    molHierarchy = @model.get('molecule_hierarchy')
    if molHierarchy?
      #is salt?
      if molHierarchy.molecule_chembl_id != molHierarchy.parent_chembl_id
        @updateSectionTitle('Calculated Parent Properties')

    @showSection()

    thisView = @
    $.each @mol_properties, ( key, elem_id ) ->
      value = thisView.model.get('molecule_properties')[key]
      value = '--' unless value?
      $('#' + elem_id).text(value)

    @initEmbedModal('calculated_properties', @model.get('molecule_chembl_id'))
    @activateModals()
    @showCardContent()

  mol_properties:
    'mw_freebase': 'Bck-CalcCompProp-MolWt'
    'mw_monoisotopic': 'Bck-CalcCompProp-MolWtM'
    'alogp':'Bck-CalcCompProp-ALogP'
    'rtb': 'Bck-CalcCompProp-RotBonds'
    'psa':'Bck-CalcCompProp-PSA'
    'molecular_species':'Bck-CalcCompProp-Msp'
    'hba': 'Bck-CalcCompProp-HBA'
    'hba_lipinski': 'Bck-CalcCompProp-HBAL'
    'hbd': 'Bck-CalcCompProp-HBD'
    'hbd_lipinski': 'Bck-CalcCompProp-HBDL'
    'num_ro5_violations': 'Bck-CalcCompProp-RO5'
    'cx_most_apka': 'Bck-CalcCompProp-APKA'
    'num_lipinski_ro5_violations': 'Bck-CalcCompProp-ROL'
    'cx_most_bpka': 'Bck-CalcCompProp-BPKA'
    'cx_logp': 'Bck-CalcCompProp-CXLogP'
    'cx_logd': 'Bck-CalcCompProp-CXLogD'
    'aromatic_rings': 'Bck-CalcCompProp-AR'
    'heavy_atoms': 'Bck-CalcCompProp-HA'
    'qed_weighted': 'Bck-CalcCompProp-QEDW'

  # -----------------------------------------------------------------
  # ---- Downloads
  # -----------------------------------------------------------------

  downloadParserFunction: (attributes) ->

    return [attributes.molecule_properties]

  getFilename: (format) ->

    if format == 'csv'
      return @model.get('molecule_chembl_id') + 'CalculatedParentProperties.csv'
    else if format == 'json'
      return @model.get('molecule_chembl_id') + 'CalculatedParentProperties.json'
    else if format == 'xlsx'
      return @model.get('molecule_chembl_id') + 'CalculatedParentProperties.xlsx'
    else
      return 'file.txt'
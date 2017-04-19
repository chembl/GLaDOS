# this view is in charge of showing a collection of elements as a plot
PlotView = Backbone.View.extend(ResponsiviseViewExt).extend

  events:
    'change .select-xaxis,.select-yaxis,.select-colour': 'changeAxis'

  initialize: ->

    @XAXIS = 'x-axis'
    @YAXIS = 'y-axis'
    @COLOUR = 'colour'
    @ORDINAL = 'ORDINAL'
    @LINEAR = 'LINEAR'

    @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @

    @$vis_elem = $(@el).find('.BCK-CompResultsGraphContainer')
    updateViewProxy = @setUpResponsiveRender()

    @config = {
      properties:
        molecule_chembl_id:
          prop_name:'molecule_chembl_id'
          type: 'string'
          label: 'CHEMBL_ID'
        full_mwt:
          prop_name:'full_mwt'
          type: 'number'
          label: 'Molecular Weight'
        aromatic_rings:
          prop_name:'aromatic_rings'
          type: 'number'
          label: '#Aromatic rings'
        heavy_atoms:
          prop_name:'heavy_atoms'
          type: 'number'
          label: '#Heavy Atoms'
        ALogP:
          prop_name:'molecule_properties.alogp'
          type: 'number'
          label: 'ALogP'
        FULL_MWT:
          prop_name:'molecule_properties.full_mwt'
          type: 'number'
          label: 'Parent Molecular Weight'
        RO5:
          prop_name:'molecule_properties.num_ro5_violations'
          type: 'number'
          label: '#RO5 Violations'
          default_domain: [0, 4]
        PSA:
          prop_name:'molecule_properties.psa'
          type: 'number'
          label: 'Polar Surface Area'
        HBA:
          prop_name:'molecule_properties.hba'
          type: 'number'
          label: 'Hydrogen Bond Acceptors'
        HBD:
          prop_name:'molecule_properties.hbd'
          type: 'number'
          label: 'Hydrogen Bond Donnors'

      id_property: 'molecule_chembl_id'
      labeler_property: 'molecule_chembl_id'
      initial_property_x: 'ALogP'
      initial_property_y: 'FULL_MWT'
      initial_property_colour: 'RO5'
      x_axis_options:['ALogP', 'FULL_MWT', 'PSA', 'HBA', 'HBD', 'RO5']
      y_axis_options:['ALogP', 'FULL_MWT', 'PSA', 'HBA', 'HBD', 'RO5']
      colour_options:['RO5', 'FULL_MWT']
    }

    @idProperty = @config.properties[@config.id_property]
    @labelerProperty = @config.properties[@config.labeler_property]
    @currentPropertyX = @config.properties[@config.initial_property_x]
    @currentPropertyY = @config.properties[@config.initial_property_y]
    @currentPropertyColour = @config.properties[@config.initial_property_colour]

    @paintSelectors()

  selectionChangedHandler: ->

    # only bother if my element is visible
    if not $(@el).is(":visible")
      return

    newBorderColours = @getBorderColours(@shownElements, @getColourFor)
    newBorderWidths = @getBorderWidths(@shownElements)

    update = {
      'marker.line':
        color: newBorderColours
        width: newBorderWidths
    }

    Plotly.restyle(@$vis_elem.get(0), update, 0)

  selectItems: (idsList) -> @collection.selectItems(idsList)

  renderWhenError: ->

    @clearVisualisation()
    $(@el).find('select').material_select('destroy');

    @$vis_elem.html Handlebars.compile($('#Handlebars-Common-PlotError').html())
      static_images_url: glados.Settings.STATIC_IMAGES_URL

  render: ->

    if @collection.DOWNLOAD_ERROR_STATE
      @renderWhenError()
      return

    # only bother if my element is visible
    if $(@el).is(":visible")

      console.log 'RENDER GRAPH!'
      $messagesElement = $(@el).find('.BCK-VisualisationMessages')
      $messagesElement.html Handlebars.compile($('#' + $messagesElement.attr('data-hb-template')).html())
        message: 'Loading Visualisation...'

      @clearVisualisation()
      @paintGraph()
      $(@el).find('select').material_select()

      $messagesElement.html ''

  paintSelectors: ->

    $xAxisSelector = $(@el).find('.BCK-ESResultsPlot-selectXAxis')

    $xAxisSelector.html Handlebars.compile($('#' + $xAxisSelector.attr('data-hb-template')).html())
      options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_x}) for opt in @config.x_axis_options)

    $yAxisSelector = $(@el).find('.BCK-ESResultsPlot-selectYAxis')
    $yAxisSelector.html Handlebars.compile($('#' + $yAxisSelector.attr('data-hb-template')).html())
      options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_y}) for opt in @config.y_axis_options)

    $colourSelector = $(@el).find('.BCK-ESResultsPlot-selectColour')
    $colourSelector.html Handlebars.compile($('#' + $colourSelector.attr('data-hb-template')).html())
      options: ($.extend(@config.properties[opt], {id:opt, selected: opt == @config.initial_property_colour}) for opt in @config.colour_options)


  clearVisualisation: ->

     $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
     $legendContainer.empty()
     @$vis_elem.empty()
     $(@el).find('.BCK-CompResultsGraphRejectedResults').empty()

  changeAxis: (event) ->

    $selector = $(event.currentTarget)
    newProperty = $selector.val()
    if newProperty == ''
      return

    if $selector.hasClass('select-xaxis')
      console.log 'changing property to: ', newProperty
      @currentPropertyX = @config.properties[newProperty]
    else if $selector.hasClass('select-yaxis')
      @currentPropertyY = @config.properties[newProperty]
    else if $selector.hasClass('select-colour')
      @currentPropertyColour = @config.properties[newProperty]

    @clearVisualisation()
    @paintGraph()

  getBorderColours: (items, colourScale) ->

    thisView = @
    return items.map (item) ->
      if thisView.collection.itemIsSelected(glados.Utils.getNestedValue(item, thisView.idProperty.prop_name))
        return glados.Settings.VISUALISATION_SELECTED
      else return colourScale.range()[1]

  getBorderWidths: (items) ->

    thisView = @
    return items.map (item) ->
      if thisView.collection.itemIsSelected(glados.Utils.getNestedValue(item, thisView.idProperty.prop_name))
        return 2.5
      else return 0.5


  paintGraph: ->

    # 40 test molecules
    @shownElements = [{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6939","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6939","parent_chembl_id":"CHEMBL6939"},"molecule_properties":{"acd_logd":"0.16","acd_logp":"2.25","acd_most_apka":"13.86","acd_most_bpka":"9.42","alogp":"2.26","aromatic_rings":1,"full_molformula":"C17H27NO3","full_mwt":"293.40","hba":4,"hbd":2,"heavy_atoms":21,"molecular_species":"BASE","mw_freebase":"293.40","mw_monoisotopic":"293.1991","num_alerts":0,"num_ro5_violations":0,"psa":"50.72","qed_weighted":"0.70","ro3_pass":"N","rtb":10},"molecule_structures":{"canonical_smiles":"CC(C)NCC(O)COc1ccc(COCC2CC2)cc1","standard_inchi":"InChI=1S/C17H27NO3/c1-13(2)18-9-16(19)12-21-17-7-5-15(6-8-17)11-20-10-14-3-4-14/h5-8,13-14,16,18-19H,3-4,9-12H2,1-2H3","standard_inchi_key":"UOKWVICUCYNXFO-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":["J01EA01"],"availability_type":"1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":45924,"chirality":"2","dosed_ingredient":true,"first_approval":1973,"first_in_class":"0","helm_notation":null,"indication_class":"Antibacterial","inorganic_flag":"0","max_phase":4,"molecule_chembl_id":"CHEMBL22","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL22","parent_chembl_id":"CHEMBL22"},"molecule_properties":{"acd_logd":"0.47","acd_logp":"0.59","acd_most_apka":null,"acd_most_bpka":"6.90","alogp":"1.54","aromatic_rings":2,"full_molformula":"C14H18N4O3","full_mwt":"290.32","hba":7,"hbd":2,"heavy_atoms":21,"molecular_species":"NEUTRAL","mw_freebase":"290.32","mw_monoisotopic":"290.1379","num_alerts":0,"num_ro5_violations":0,"psa":"105.51","qed_weighted":"0.86","ro3_pass":"N","rtb":5},"molecule_structures":{"canonical_smiles":"COc1cc(Cc2cnc(N)nc2N)cc(OC)c1OC","standard_inchi":"InChI=1S/C14H18N4O3/c1-19-10-5-8(6-11(20-2)12(10)21-3)4-9-7-17-14(16)18-13(9)15/h5-7H,4H2,1-3H3,(H4,15,16,17,18)","standard_inchi_key":"IEDVJHCEMCRBQM-UHFFFAOYSA-N"},"molecule_synonyms":[{"molecule_synonym":"BW-56-72","syn_type":"RESEARCH_CODE","synonyms":"BW-56-72"},{"molecule_synonym":"Polytrim","syn_type":"OTHER","synonyms":"Polytrim"},{"molecule_synonym":"Primsol","syn_type":"OTHER","synonyms":"Primsol"},{"molecule_synonym":"Proloprim","syn_type":"TRADE_NAME","synonyms":"Proloprim"},{"molecule_synonym":"Trimethoprim","syn_type":"TRADE_NAME","synonyms":"Trimethoprim"},{"molecule_synonym":"Trimpex","syn_type":"TRADE_NAME","synonyms":"Trimpex"},{"molecule_synonym":"Trimpex 200","syn_type":"TRADE_NAME","synonyms":"Trimpex 200"},{"molecule_synonym":"Trimpex","syn_type":"BN_USP_DB","synonyms":"TRIMPEX"},{"molecule_synonym":"BW-5672","syn_type":"RESEARCH_CODE_DB","synonyms":"BW 56-72"},{"molecule_synonym":"Proloprim","syn_type":"BN_USP_DB","synonyms":"PROLOPRIM"},{"molecule_synonym":"Trimethoprim","syn_type":"BAN_DB","synonyms":"TRIMETHOPRIM"},{"molecule_synonym":"Trimethoprim","syn_type":"FDA_DB","synonyms":"TRIMETHOPRIM"},{"molecule_synonym":"Trimethoprim","syn_type":"INN_DB","synonyms":"TRIMETHOPRIM"},{"molecule_synonym":"Trimethoprim","syn_type":"JAN_DB","synonyms":"TRIMETHOPRIM"},{"molecule_synonym":"Trimethoprim","syn_type":"USP_DB","synonyms":"TRIMETHOPRIM"},{"molecule_synonym":"Trimethoprim","syn_type":"USAN_DB","synonyms":"TRIMETHOPRIM"},{"molecule_synonym":"Monotrim","syn_type":"TRADE_NAME","synonyms":"Monotrim"},{"molecule_synonym":"Proloprin","syn_type":"TRADE_NAME","synonyms":"Proloprin"},{"molecule_synonym":"TCMDC-125538","syn_type":"RESEARCH_CODE","synonyms":"TCMDC-125538"},{"molecule_synonym":"TCMDC-125538","syn_type":"OTHER","synonyms":"TCMDC-125538"}],"molecule_type":"Small molecule","natural_product":"0","oral":true,"parenteral":true,"polymer_flag":false,"pref_name":"TRIMETHOPRIM","prodrug":"0","structure_type":"MOL","therapeutic_flag":true,"topical":true,"usan_stem":null,"usan_stem_definition":"antibacterials (trimethoprim type)","usan_substem":null,"usan_year":1964,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6941","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6941","parent_chembl_id":"CHEMBL6941"},"molecule_properties":{"acd_logd":"-0.83","acd_logp":"1.67","acd_most_apka":"-0.29","acd_most_bpka":"10.50","alogp":"2.06","aromatic_rings":2,"full_molformula":"C8H7N3S","full_mwt":"177.23","hba":4,"hbd":2,"heavy_atoms":12,"molecular_species":"ZWITTERION","mw_freebase":"177.23","mw_monoisotopic":"177.0361","num_alerts":2,"num_ro5_violations":0,"psa":"90.60","qed_weighted":"0.48","ro3_pass":"N","rtb":0},"molecule_structures":{"canonical_smiles":"Nc1nc(S)c2ccccc2n1","standard_inchi":"InChI=1S/C8H7N3S/c9-8-10-6-4-2-1-3-5(6)7(12)11-8/h1-4H,(H3,9,10,11,12)","standard_inchi_key":"ZJAKAAVAZAYRLO-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6942","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6942","parent_chembl_id":"CHEMBL6942"},"molecule_properties":{"acd_logd":"3.80","acd_logp":"4.36","acd_most_apka":"13.50","acd_most_bpka":"7.88","alogp":"4.86","aromatic_rings":4,"full_molformula":"C24H25N5OS","full_mwt":"431.55","hba":6,"hbd":3,"heavy_atoms":31,"molecular_species":"NEUTRAL","mw_freebase":"431.55","mw_monoisotopic":"431.1780","num_alerts":1,"num_ro5_violations":0,"psa":"132.22","qed_weighted":"0.39","ro3_pass":"N","rtb":5},"molecule_structures":{"canonical_smiles":"CC(C)C(Sc1ccc2ccccc2c1)C(=O)Nc3ccc4nc(N)nc(N)c4c3C","standard_inchi":"InChI=1S/C24H25N5OS/c1-13(2)21(31-17-9-8-15-6-4-5-7-16(15)12-17)23(30)27-18-10-11-19-20(14(18)3)22(25)29-24(26)28-19/h4-13,21H,1-3H3,(H,27,30)(H4,25,26,28,29)","standard_inchi_key":"PWTQBCOCKQEHQK-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6944","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6944","parent_chembl_id":"CHEMBL6944"},"molecule_properties":{"acd_logd":"-0.03","acd_logp":"2.77","acd_most_apka":"4.50","acd_most_bpka":null,"alogp":"0.90","aromatic_rings":1,"full_molformula":"C12H13NO4S","full_mwt":"267.30","hba":4,"hbd":1,"heavy_atoms":18,"molecular_species":"ACID","mw_freebase":"267.30","mw_monoisotopic":"267.0565","num_alerts":1,"num_ro5_violations":0,"psa":"95.08","qed_weighted":"0.80","ro3_pass":"N","rtb":5},"molecule_structures":{"canonical_smiles":"CCOC(=O)C1=C(O)C(=O)N(Cc2cccs2)C1","standard_inchi":"InChI=1S/C12H13NO4S/c1-2-17-12(16)9-7-13(11(15)10(9)14)6-8-4-3-5-18-8/h3-5,14H,2,6-7H2,1H3","standard_inchi_key":"LCDLJTYTVMVKMU-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6945","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6945","parent_chembl_id":"CHEMBL1177925"},"molecule_properties":{"acd_logd":"-2.06","acd_logp":"-2.06","acd_most_apka":null,"acd_most_bpka":null,"alogp":"0.84","aromatic_rings":2,"full_molformula":"C19H24NO5.Br","full_mwt":"426.30","hba":4,"hbd":0,"heavy_atoms":25,"molecular_species":"NEUTRAL","mw_freebase":"346.40","mw_monoisotopic":"346.1654","num_alerts":4,"num_ro5_violations":0,"psa":"57.90","qed_weighted":"0.32","ro3_pass":"N","rtb":7},"molecule_structures":{"canonical_smiles":"[Br-].COc1c2OC(=O)C=Cc2c(COCCC[N+](C)(C)C)c3ccoc13","standard_inchi":"InChI=1S/C19H24NO5.BrH/c1-20(2,3)9-5-10-23-12-15-13-6-7-16(21)25-18(13)19(22-4)17-14(15)8-11-24-17;/h6-8,11H,5,9-10,12H2,1-4H3;1H/q+1;/p-1","standard_inchi_key":"SKTSZSCUJGHYBI-UHFFFAOYSA-M"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6946","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6946","parent_chembl_id":"CHEMBL6946"},"molecule_properties":{"acd_logd":"-0.13","acd_logp":"0.02","acd_most_apka":"7.59","acd_most_bpka":"1.31","alogp":"0.28","aromatic_rings":2,"full_molformula":"C12H13N3O4S2","full_mwt":"327.38","hba":5,"hbd":3,"heavy_atoms":21,"molecular_species":"NEUTRAL","mw_freebase":"327.38","mw_monoisotopic":"327.0347","num_alerts":1,"num_ro5_violations":0,"psa":"149.10","qed_weighted":"0.69","ro3_pass":"N","rtb":4},"molecule_structures":{"canonical_smiles":"Nc1ccc(cc1)S(=O)(=O)Nc2ccccc2S(=O)(=O)N","standard_inchi":"InChI=1S/C12H13N3O4S2/c13-9-5-7-10(8-6-9)21(18,19)15-11-3-1-2-4-12(11)20(14,16)17/h1-8,15H,13H2,(H2,14,16,17)","standard_inchi_key":"MTYAYRDXCSXATC-UHFFFAOYSA-N"},"molecule_synonyms":[{"molecule_synonym":"2-{[(4-Aminophenyl)Sulfonyl]Amino}Benzenesulfonamide","syn_type":"OTHER","synonyms":"2-{[(4-Aminophenyl)Sulfonyl]Amino}Benzenesulfonamide"}],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6947","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6947","parent_chembl_id":"CHEMBL6947"},"molecule_properties":{"acd_logd":"4.11","acd_logp":"4.12","acd_most_apka":"9.17","acd_most_bpka":null,"alogp":"5.25","aromatic_rings":3,"full_molformula":"C25H22F3N3O5","full_mwt":"501.45","hba":5,"hbd":1,"heavy_atoms":36,"molecular_species":"NEUTRAL","mw_freebase":"501.45","mw_monoisotopic":"501.1512","num_alerts":0,"num_ro5_violations":2,"psa":"93.90","qed_weighted":"0.46","ro3_pass":"N","rtb":8},"molecule_structures":{"canonical_smiles":"CC(=C(C)/c1cccc(OCc2nc(oc2C)c3ccc(cc3)C(F)(F)F)c1)CN4OC(=O)NC4=O","standard_inchi":"InChI=1S/C25H22F3N3O5/c1-14(12-31-23(32)30-24(33)36-31)15(2)18-5-4-6-20(11-18)34-13-21-16(3)35-22(29-21)17-7-9-19(10-8-17)25(26,27)28/h4-11H,12-13H2,1-3H3,(H,30,32,33)/b15-14+","standard_inchi_key":"ILPASLFASFHBDC-CCEZHUSRSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL1163143","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL1163143","parent_chembl_id":"CHEMBL1163143"},"molecule_properties":{"acd_logd":"10.58","acd_logp":"10.58","acd_most_apka":null,"acd_most_bpka":"3.95","alogp":"6.94","aromatic_rings":1,"full_molformula":"C37H56N2O5","full_mwt":"608.85","hba":6,"hbd":0,"heavy_atoms":44,"molecular_species":"NEUTRAL","mw_freebase":"608.85","mw_monoisotopic":"608.4189","num_alerts":2,"num_ro5_violations":2,"psa":"79.65","qed_weighted":"0.25","ro3_pass":"N","rtb":7},"molecule_structures":{"canonical_smiles":"COCC(=C)[C@@H]1CC[C@@]2(CC[C@]3(C)[C@H](CC[C@@H]4[C@@]5(C)CC[C@H](OC(=O)n6cncc6C)C(C)(C)[C@@H]5CC[C@@]34C)[C@@H]12)C(=O)OC","standard_inchi":"InChI=1S/C37H56N2O5/c1-23(21-42-8)25-12-17-37(31(40)43-9)19-18-35(6)26(30(25)37)10-11-28-34(5)15-14-29(44-32(41)39-22-38-20-24(39)2)33(3,4)27(34)13-16-36(28,35)7/h20,22,25-30H,1,10-19,21H2,2-9H3/t25-,26+,27-,28+,29-,30+,34-,35+,36+,37-/m0/s1","standard_inchi_key":"KPNTUIZGUAJMMK-DWKDZXJCSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6948","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6948","parent_chembl_id":"CHEMBL6948"},"molecule_properties":{"acd_logd":"-0.47","acd_logp":"1.18","acd_most_apka":null,"acd_most_bpka":"9.29","alogp":"1.26","aromatic_rings":1,"full_molformula":"C12H14F3N5","full_mwt":"285.27","hba":5,"hbd":2,"heavy_atoms":20,"molecular_species":"BASE","mw_freebase":"285.27","mw_monoisotopic":"285.1201","num_alerts":0,"num_ro5_violations":0,"psa":"79.99","qed_weighted":"0.86","ro3_pass":"N","rtb":2},"molecule_structures":{"canonical_smiles":"CC1(C)N=C(N)N=C(N)N1c2cccc(c2)C(F)(F)F","standard_inchi":"InChI=1S/C12H14F3N5/c1-11(2)19-9(16)18-10(17)20(11)8-5-3-4-7(6-8)12(13,14)15/h3-6H,1-2H3,(H4,16,17,18,19)","standard_inchi_key":"MMFKOLPHNNHIDJ-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6950","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6950","parent_chembl_id":"CHEMBL6950"},"molecule_properties":{"acd_logd":"-1.92","acd_logp":"0.17","acd_most_apka":null,"acd_most_bpka":"8.90","alogp":"0.06","aromatic_rings":2,"full_molformula":"C9H11N5","full_mwt":"189.22","hba":5,"hbd":3,"heavy_atoms":14,"molecular_species":"BASE","mw_freebase":"189.22","mw_monoisotopic":"189.1014","num_alerts":0,"num_ro5_violations":0,"psa":"103.83","qed_weighted":"0.59","ro3_pass":"N","rtb":1},"molecule_structures":{"canonical_smiles":"NCc1ccc2nc(N)nc(N)c2c1","standard_inchi":"InChI=1S/C9H11N5/c10-4-5-1-2-7-6(3-5)8(11)14-9(12)13-7/h1-3H,4,10H2,(H4,11,12,13,14)","standard_inchi_key":"UZVZMGNVBKHJKH-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6951","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6951","parent_chembl_id":"CHEMBL6951"},"molecule_properties":{"acd_logd":"0.78","acd_logp":"0.78","acd_most_apka":null,"acd_most_bpka":null,"alogp":"1.03","aromatic_rings":1,"full_molformula":"C16H14O6","full_mwt":"302.28","hba":6,"hbd":0,"heavy_atoms":22,"molecular_species":null,"mw_freebase":"302.28","mw_monoisotopic":"302.0790","num_alerts":2,"num_ro5_violations":0,"psa":"78.90","qed_weighted":"0.61","ro3_pass":"N","rtb":4},"molecule_structures":{"canonical_smiles":"O=C(OC[C@H]1C[C@@H]2O[C@H]1[C@@H]3[C@H]2C(=O)OC3=O)c4ccccc4","standard_inchi":"InChI=1S/C16H14O6/c17-14(8-4-2-1-3-5-8)20-7-9-6-10-11-12(13(9)21-10)16(19)22-15(11)18/h1-5,9-13H,6-7H2/t9-,10+,11+,12+,13-/m1/s1","standard_inchi_key":"SZDQLXRYGYIPFW-QNWJLWSRSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6952","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6952","parent_chembl_id":"CHEMBL6952"},"molecule_properties":{"acd_logd":"3.92","acd_logp":"3.93","acd_most_apka":"9.15","acd_most_bpka":null,"alogp":"4.79","aromatic_rings":3,"full_molformula":"C25H22F3N3O6","full_mwt":"517.45","hba":6,"hbd":1,"heavy_atoms":37,"molecular_species":"NEUTRAL","mw_freebase":"517.45","mw_monoisotopic":"517.1461","num_alerts":0,"num_ro5_violations":1,"psa":"103.13","qed_weighted":"0.44","ro3_pass":"N","rtb":9},"molecule_structures":{"canonical_smiles":"COc1cc(OCc2nc(oc2C)c3ccc(cc3)C(F)(F)F)cc(c1)C(=CCN4OC(=O)NC4=O)C","standard_inchi":"InChI=1S/C25H22F3N3O6/c1-14(8-9-31-23(32)30-24(33)37-31)17-10-19(34-3)12-20(11-17)35-13-21-15(2)36-22(29-21)16-4-6-18(7-5-16)25(26,27)28/h4-8,10-12H,9,13H2,1-3H3,(H,30,32,33)/b14-8+","standard_inchi_key":"WLVKJJMYKHHHSC-RIYZIHGNSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6954","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6954","parent_chembl_id":"CHEMBL6954"},"molecule_properties":{"acd_logd":"-1.98","acd_logp":"0.52","acd_most_apka":null,"acd_most_bpka":"17.14","alogp":"0.74","aromatic_rings":0,"full_molformula":"C5H10N2S","full_mwt":"130.21","hba":3,"hbd":1,"heavy_atoms":8,"molecular_species":"BASE","mw_freebase":"130.21","mw_monoisotopic":"130.0565","num_alerts":1,"num_ro5_violations":0,"psa":"54.40","qed_weighted":"0.49","ro3_pass":"Y","rtb":0},"molecule_structures":{"canonical_smiles":"CN1CCCN=C1S","standard_inchi":"InChI=1S/C5H10N2S/c1-7-4-2-3-6-5(7)8/h2-4H2,1H3,(H,6,8)","standard_inchi_key":"KWRGMBARTDLYSH-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6957","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6957","parent_chembl_id":"CHEMBL6957"},"molecule_properties":{"acd_logd":"0.89","acd_logp":"2.52","acd_most_apka":"13.47","acd_most_bpka":"8.94","alogp":"1.99","aromatic_rings":1,"full_molformula":"C14H21NO3","full_mwt":"251.32","hba":4,"hbd":2,"heavy_atoms":18,"molecular_species":"BASE","mw_freebase":"251.32","mw_monoisotopic":"251.1521","num_alerts":1,"num_ro5_violations":0,"psa":"58.56","qed_weighted":"0.73","ro3_pass":"N","rtb":7},"molecule_structures":{"canonical_smiles":"CC(C)NCC(O)COC(=O)c1cccc(C)c1","standard_inchi":"InChI=1S/C14H21NO3/c1-10(2)15-8-13(16)9-18-14(17)12-6-4-5-11(3)7-12/h4-7,10,13,15-16H,8-9H2,1-3H3","standard_inchi_key":"DNHFKKPFHBYSRA-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6960","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6960","parent_chembl_id":"CHEMBL6960"},"molecule_properties":{"acd_logd":"1.29","acd_logp":"1.29","acd_most_apka":null,"acd_most_bpka":"4.97","alogp":"0.68","aromatic_rings":0,"full_molformula":"C4H11NO","full_mwt":"89.14","hba":2,"hbd":1,"heavy_atoms":6,"molecular_species":"NEUTRAL","mw_freebase":"89.14","mw_monoisotopic":"89.0841","num_alerts":2,"num_ro5_violations":0,"psa":"35.25","qed_weighted":"0.41","ro3_pass":"Y","rtb":3},"molecule_structures":{"canonical_smiles":"CCCCON","standard_inchi":"InChI=1S/C4H11NO/c1-2-3-4-6-5/h2-5H2,1H3","standard_inchi_key":"WCVVIGQKJZLJDB-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL1163144","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL1163144","parent_chembl_id":"CHEMBL1163144"},"molecule_properties":{"acd_logd":"11.12","acd_logp":"11.12","acd_most_apka":null,"acd_most_bpka":"4.34","alogp":"8.25","aromatic_rings":2,"full_molformula":"C40H58N4O4","full_mwt":"658.91","hba":6,"hbd":0,"heavy_atoms":48,"molecular_species":"NEUTRAL","mw_freebase":"658.91","mw_monoisotopic":"658.4458","num_alerts":1,"num_ro5_violations":2,"psa":"88.24","qed_weighted":"0.29","ro3_pass":"N","rtb":6},"molecule_structures":{"canonical_smiles":"CC(=C)[C@@H]1CC[C@]2(COC(=O)n3ccnc3C)CC[C@]4(C)[C@H](CC[C@@H]5[C@@]6(C)CC[C@H](OC(=O)n7ccnc7C)C(C)(C)[C@@H]6CC[C@@]45C)[C@@H]12","standard_inchi":"InChI=1S/C40H58N4O4/c1-25(2)28-12-17-40(24-47-34(45)43-22-20-41-26(43)3)19-18-38(8)29(33(28)40)10-11-31-37(7)15-14-32(48-35(46)44-23-21-42-27(44)4)36(5,6)30(37)13-16-39(31,38)9/h20-23,28-33H,1,10-19,24H2,2-9H3/t28-,29+,30-,31+,32-,33+,37-,38+,39+,40+/m0/s1","standard_inchi_key":"AWISEXXGVHMSEU-COEVCNOISA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6961","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6961","parent_chembl_id":"CHEMBL6961"},"molecule_properties":{"acd_logd":null,"acd_logp":null,"acd_most_apka":null,"acd_most_bpka":null,"alogp":null,"aromatic_rings":null,"full_molformula":"C22H22N6Pt.2BF4","full_mwt":"739.14","hba":null,"hbd":null,"heavy_atoms":null,"molecular_species":null,"mw_freebase":null,"mw_monoisotopic":null,"num_alerts":null,"num_ro5_violations":null,"psa":null,"qed_weighted":null,"ro3_pass":null,"rtb":null},"molecule_structures":null,"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":"Platinum complex","prodrug":"-1","structure_type":"NONE","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6962","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6962","parent_chembl_id":"CHEMBL6962"},"molecule_properties":{"acd_logd":"0.73","acd_logp":"2.64","acd_most_apka":null,"acd_most_bpka":"10.01","alogp":"2.81","aromatic_rings":1,"full_molformula":"C15H23N5","full_mwt":"273.38","hba":5,"hbd":2,"heavy_atoms":20,"molecular_species":"BASE","mw_freebase":"273.38","mw_monoisotopic":"273.1953","num_alerts":0,"num_ro5_violations":0,"psa":"80.00","qed_weighted":"0.88","ro3_pass":"N","rtb":4},"molecule_structures":{"canonical_smiles":"CCCCc1ccc(cc1)N2C(=NC(=NC2(C)C)N)N","standard_inchi":"InChI=1S/C15H23N5/c1-4-5-6-11-7-9-12(10-8-11)20-14(17)18-13(16)19-15(20,2)3/h7-10H,4-6H2,1-3H3,(H4,16,17,18,19)","standard_inchi_key":"PCJOVXVEEYNISX-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6963","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6963","parent_chembl_id":"CHEMBL6963"},"molecule_properties":{"acd_logd":null,"acd_logp":null,"acd_most_apka":null,"acd_most_bpka":null,"alogp":null,"aromatic_rings":null,"full_molformula":"C15H13N4Pt.2BF4","full_mwt":"617.98","hba":null,"hbd":null,"heavy_atoms":null,"molecular_species":null,"mw_freebase":null,"mw_monoisotopic":null,"num_alerts":null,"num_ro5_violations":null,"psa":null,"qed_weighted":null,"ro3_pass":null,"rtb":null},"molecule_structures":null,"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":"(2,2':6',2''-terpyridine)platinum (II) complex","prodrug":"-1","structure_type":"NONE","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6968","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6968","parent_chembl_id":"CHEMBL6968"},"molecule_properties":{"acd_logd":"4.98","acd_logp":"4.98","acd_most_apka":null,"acd_most_bpka":null,"alogp":"5.39","aromatic_rings":1,"full_molformula":"C24H28O5","full_mwt":"396.48","hba":5,"hbd":0,"heavy_atoms":29,"molecular_species":null,"mw_freebase":"396.48","mw_monoisotopic":"396.1937","num_alerts":2,"num_ro5_violations":1,"psa":"61.83","qed_weighted":"0.51","ro3_pass":"N","rtb":3},"molecule_structures":{"canonical_smiles":"CCCC1=CC(=O)Oc2c1c3OC(C)(C)C=Cc3c4O[C@H](C(C)C)[C@@H](C)C(=O)c24","standard_inchi":"InChI=1S/C24H28O5/c1-7-8-14-11-16(25)27-23-17(14)22-15(9-10-24(5,6)29-22)21-18(23)19(26)13(4)20(28-21)12(2)3/h9-13,20H,7-8H2,1-6H3/t13-,20+/m0/s1","standard_inchi_key":"ZLGZNDWMMMIYPD-RNODOKPDSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6969","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6969","parent_chembl_id":"CHEMBL6969"},"molecule_properties":{"acd_logd":"7.00","acd_logp":"7.00","acd_most_apka":null,"acd_most_bpka":null,"alogp":"6.30","aromatic_rings":5,"full_molformula":"C26H18N2O3","full_mwt":"406.43","hba":3,"hbd":2,"heavy_atoms":31,"molecular_species":"NEUTRAL","mw_freebase":"406.43","mw_monoisotopic":"406.1317","num_alerts":4,"num_ro5_violations":1,"psa":"74.94","qed_weighted":"0.15","ro3_pass":"N","rtb":6},"molecule_structures":{"canonical_smiles":"O=C(Oc1ccc2[nH]c(cc2c1)C(=O)c3cc4ccccc4[nH]3)C=Cc5ccccc5","standard_inchi":"InChI=1S/C26H18N2O3/c29-25(13-10-17-6-2-1-3-7-17)31-20-11-12-22-19(14-20)16-24(28-22)26(30)23-15-18-8-4-5-9-21(18)27-23/h1-16,27-28H/b13-10+","standard_inchi_key":"WJDSWADDRNVNAI-JLHYYAGUSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6970","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6970","parent_chembl_id":"CHEMBL6970"},"molecule_properties":{"acd_logd":"1.90","acd_logp":"2.66","acd_most_apka":null,"acd_most_bpka":"8.08","alogp":"2.88","aromatic_rings":2,"full_molformula":"C15H18N4","full_mwt":"254.33","hba":4,"hbd":2,"heavy_atoms":19,"molecular_species":"NEUTRAL","mw_freebase":"254.33","mw_monoisotopic":"254.1531","num_alerts":0,"num_ro5_violations":0,"psa":"77.81","qed_weighted":"0.86","ro3_pass":"N","rtb":2},"molecule_structures":{"canonical_smiles":"Nc1nc(N)c2CC(Cc3ccccc3)CCc2n1","standard_inchi":"InChI=1S/C15H18N4/c16-14-12-9-11(8-10-4-2-1-3-5-10)6-7-13(12)18-15(17)19-14/h1-5,11H,6-9H2,(H4,16,17,18,19)","standard_inchi_key":"JHAGNGFBQHOFEL-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6971","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6971","parent_chembl_id":"CHEMBL6971"},"molecule_properties":{"acd_logd":"3.21","acd_logp":"3.86","acd_most_apka":null,"acd_most_bpka":"7.94","alogp":"4.21","aromatic_rings":2,"full_molformula":"C15H16Cl2N4","full_mwt":"323.22","hba":4,"hbd":2,"heavy_atoms":21,"molecular_species":"NEUTRAL","mw_freebase":"323.22","mw_monoisotopic":"322.0752","num_alerts":0,"num_ro5_violations":0,"psa":"77.81","qed_weighted":"0.87","ro3_pass":"N","rtb":2},"molecule_structures":{"canonical_smiles":"Nc1nc(N)c2CC(Cc3ccc(Cl)c(Cl)c3)CCc2n1","standard_inchi":"InChI=1S/C15H16Cl2N4/c16-11-3-1-9(7-12(11)17)5-8-2-4-13-10(6-8)14(18)21-15(19)20-13/h1,3,7-8H,2,4-6H2,(H4,18,19,20,21)","standard_inchi_key":"AGHASEULGKEPPP-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6973","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6973","parent_chembl_id":"CHEMBL6973"},"molecule_properties":{"acd_logd":"0.97","acd_logp":"0.99","acd_most_apka":"8.81","acd_most_bpka":null,"alogp":"-0.75","aromatic_rings":1,"full_molformula":"C13H17N3O6S","full_mwt":"343.36","hba":6,"hbd":2,"heavy_atoms":23,"molecular_species":"NEUTRAL","mw_freebase":"343.36","mw_monoisotopic":"343.0838","num_alerts":2,"num_ro5_violations":0,"psa":"124.63","qed_weighted":"0.55","ro3_pass":"N","rtb":4},"molecule_structures":{"canonical_smiles":"COc1ccc(cc1)S(=O)(=O)N2CN(C)C(=O)C[C@@H]2C(=O)NO","standard_inchi":"InChI=1S/C13H17N3O6S/c1-15-8-16(11(7-12(15)17)13(18)14-19)23(20,21)10-5-3-9(22-2)4-6-10/h3-6,11,19H,7-8H2,1-2H3,(H,14,18)/t11-/m1/s1","standard_inchi_key":"DRWHINQPSIPRHF-LLVKDONJSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6975","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6975","parent_chembl_id":"CHEMBL6975"},"molecule_properties":{"acd_logd":"3.13","acd_logp":"3.87","acd_most_apka":null,"acd_most_bpka":"7.88","alogp":"3.99","aromatic_rings":4,"full_molformula":"C19H16N4S","full_mwt":"332.42","hba":5,"hbd":2,"heavy_atoms":24,"molecular_species":"NEUTRAL","mw_freebase":"332.42","mw_monoisotopic":"332.1096","num_alerts":1,"num_ro5_violations":0,"psa":"103.11","qed_weighted":"0.55","ro3_pass":"N","rtb":3},"molecule_structures":{"canonical_smiles":"Nc1nc(N)c2c(CSc3ccc4ccccc4c3)cccc2n1","standard_inchi":"InChI=1S/C19H16N4S/c20-18-17-14(6-3-7-16(17)22-19(21)23-18)11-24-15-9-8-12-4-1-2-5-13(12)10-15/h1-10H,11H2,(H4,20,21,22,23)","standard_inchi_key":"ZUUKBKAAIZGEMF-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6976","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6976","parent_chembl_id":"CHEMBL6976"},"molecule_properties":{"acd_logd":"1.31","acd_logp":"1.31","acd_most_apka":null,"acd_most_bpka":"4.47","alogp":"1.52","aromatic_rings":1,"full_molformula":"C14H15N3O3","full_mwt":"273.29","hba":5,"hbd":1,"heavy_atoms":20,"molecular_species":"NEUTRAL","mw_freebase":"273.29","mw_monoisotopic":"273.1113","num_alerts":0,"num_ro5_violations":0,"psa":"63.16","qed_weighted":"0.89","ro3_pass":"N","rtb":2},"molecule_structures":{"canonical_smiles":"COc1cc2CC3=C(Nc2cc1OC)N=CN(C)C3=O","standard_inchi":"InChI=1S/C14H15N3O3/c1-17-7-15-13-9(14(17)18)4-8-5-11(19-2)12(20-3)6-10(8)16-13/h5-7,16H,4H2,1-3H3","standard_inchi_key":"ZTVYMXRRHFGHRV-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6977","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6977","parent_chembl_id":"CHEMBL6977"},"molecule_properties":{"acd_logd":"0.13","acd_logp":"0.13","acd_most_apka":"9.37","acd_most_bpka":"0.01","alogp":"0.95","aromatic_rings":2,"full_molformula":"C16H16ClN3O4S","full_mwt":"381.83","hba":5,"hbd":3,"heavy_atoms":25,"molecular_species":"NEUTRAL","mw_freebase":"381.83","mw_monoisotopic":"381.0550","num_alerts":0,"num_ro5_violations":0,"psa":"121.11","qed_weighted":"0.73","ro3_pass":"N","rtb":4},"molecule_structures":{"canonical_smiles":"NS(=O)(=O)c1cc(ccc1Cl)C(=O)NN2Cc3ccccc3C2CO","standard_inchi":"InChI=1S/C16H16ClN3O4S/c17-13-6-5-10(7-15(13)25(18,23)24)16(22)19-20-8-11-3-1-2-4-12(11)14(20)9-21/h1-7,14,21H,8-9H2,(H,19,22)(H2,18,23,24)","standard_inchi_key":"SUQAZNUNUJOHJW-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6981","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6981","parent_chembl_id":"CHEMBL6981"},"molecule_properties":{"acd_logd":"0.14","acd_logp":"1.75","acd_most_apka":"13.43","acd_most_bpka":"8.93","alogp":"1.71","aromatic_rings":1,"full_molformula":"C13H18FNO3","full_mwt":"255.29","hba":4,"hbd":2,"heavy_atoms":18,"molecular_species":"BASE","mw_freebase":"255.29","mw_monoisotopic":"255.1271","num_alerts":1,"num_ro5_violations":0,"psa":"58.56","qed_weighted":"0.73","ro3_pass":"N","rtb":7},"molecule_structures":{"canonical_smiles":"CC(C)NCC(O)COC(=O)c1cccc(F)c1","standard_inchi":"InChI=1S/C13H18FNO3/c1-9(2)15-7-12(16)8-18-13(17)10-4-3-5-11(14)6-10/h3-6,9,12,15-16H,7-8H2,1-2H3","standard_inchi_key":"HSNQSWHBLSMQSR-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6982","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6982","parent_chembl_id":"CHEMBL6982"},"molecule_properties":{"acd_logd":"5.66","acd_logp":"5.67","acd_most_apka":"9.17","acd_most_bpka":null,"alogp":"6.51","aromatic_rings":3,"full_molformula":"C29H28F3N3O5","full_mwt":"555.54","hba":5,"hbd":1,"heavy_atoms":40,"molecular_species":"NEUTRAL","mw_freebase":"555.54","mw_monoisotopic":"555.1981","num_alerts":0,"num_ro5_violations":2,"psa":"93.90","qed_weighted":"0.33","ro3_pass":"N","rtb":9},"molecule_structures":{"canonical_smiles":"Cc1oc(nc1COc2cccc(c2)C(=CCN3OC(=O)NC3=O)C4CCCCC4)c5ccc(cc5)C(F)(F)F","standard_inchi":"InChI=1S/C29H28F3N3O5/c1-18-25(33-26(39-18)20-10-12-22(13-11-20)29(30,31)32)17-38-23-9-5-8-21(16-23)24(19-6-3-2-4-7-19)14-15-35-27(36)34-28(37)40-35/h5,8-14,16,19H,2-4,6-7,15,17H2,1H3,(H,34,36,37)/b24-14+","standard_inchi_key":"NFKIAGHCEOESJC-ZVHZXABRSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6983","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6983","parent_chembl_id":"CHEMBL6983"},"molecule_properties":{"acd_logd":"4.51","acd_logp":"4.59","acd_most_apka":null,"acd_most_bpka":"9.43","alogp":"4.29","aromatic_rings":2,"full_molformula":"C15H15F3N2O","full_mwt":"296.29","hba":3,"hbd":2,"heavy_atoms":21,"molecular_species":"BASE","mw_freebase":"296.29","mw_monoisotopic":"296.1136","num_alerts":0,"num_ro5_violations":0,"psa":"45.15","qed_weighted":"0.83","ro3_pass":"N","rtb":1},"molecule_structures":{"canonical_smiles":"C[C@H]1Cc2cc3c(cc(O)nc3cc2N[C@@H]1C)C(F)(F)F","standard_inchi":"InChI=1S/C15H15F3N2O/c1-7-3-9-4-10-11(15(16,17)18)5-14(21)20-13(10)6-12(9)19-8(7)2/h4-8,19H,3H2,1-2H3,(H,20,21)/t7-,8+/m0/s1","standard_inchi_key":"GMHVQYLEZZOIBO-JGVFFNPUSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6984","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6984","parent_chembl_id":"CHEMBL6984"},"molecule_properties":{"acd_logd":"1.43","acd_logp":"3.06","acd_most_apka":"13.46","acd_most_bpka":"8.94","alogp":"2.41","aromatic_rings":2,"full_molformula":"C17H21NO3","full_mwt":"287.35","hba":4,"hbd":2,"heavy_atoms":21,"molecular_species":"BASE","mw_freebase":"287.35","mw_monoisotopic":"287.1521","num_alerts":1,"num_ro5_violations":0,"psa":"58.56","qed_weighted":"0.77","ro3_pass":"N","rtb":7},"molecule_structures":{"canonical_smiles":"CC(C)NCC(O)COC(=O)c1cccc2ccccc12","standard_inchi":"InChI=1S/C17H21NO3/c1-12(2)18-10-14(19)11-21-17(20)16-9-5-7-13-6-3-4-8-15(13)16/h3-9,12,14,18-19H,10-11H2,1-2H3","standard_inchi_key":"ZZSBGFQPTJBSCP-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6985","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6985","parent_chembl_id":"CHEMBL6985"},"molecule_properties":{"acd_logd":"4.01","acd_logp":"4.05","acd_most_apka":"12.25","acd_most_bpka":"6.07","alogp":"3.65","aromatic_rings":3,"full_molformula":"C17H14N2O","full_mwt":"262.31","hba":2,"hbd":1,"heavy_atoms":20,"molecular_species":"NEUTRAL","mw_freebase":"262.31","mw_monoisotopic":"262.1106","num_alerts":0,"num_ro5_violations":0,"psa":"37.90","qed_weighted":"0.73","ro3_pass":"N","rtb":1},"molecule_structures":{"canonical_smiles":"C1Cc2[nH]c(nc2c3ccccc3O1)c4ccccc4","standard_inchi":"InChI=1S/C17H14N2O/c1-2-6-12(7-3-1)17-18-14-10-11-20-15-9-5-4-8-13(15)16(14)19-17/h1-9H,10-11H2,(H,18,19)","standard_inchi_key":"HLFWKNALKQTOQJ-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL1163147","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL1163147","parent_chembl_id":"CHEMBL1163147"},"molecule_properties":{"acd_logd":null,"acd_logp":null,"acd_most_apka":null,"acd_most_bpka":null,"alogp":null,"aromatic_rings":null,"full_molformula":"C34H28Br4N4O13S","full_mwt":"1052.29","hba":null,"hbd":null,"heavy_atoms":null,"molecular_species":null,"mw_freebase":"1052.29","mw_monoisotopic":"1047.8107","num_alerts":null,"num_ro5_violations":null,"psa":null,"qed_weighted":null,"ro3_pass":null,"rtb":null},"molecule_structures":{"canonical_smiles":"ON=C\u0001/Cc2cc(Br)c(OS(=O)(=O)O)c(Oc3c(Br)cc(cc3Br)C(O)C(=N/O)C(=O)NCCc4ccc(O)c(Oc5ccc(cc5Br)C(O)CNC1=O)c4)c2","standard_inchi":"InChI=1S/C34H28Br4N4O13S/c35-19-11-17-2-4-26(19)53-27-9-15(1-3-24(27)43)5-6-39-34(47)29(42-49)30(45)18-12-21(37)31(22(38)13-18)54-28-10-16(7-20(36)32(28)55-56(50,51)52)8-23(41-48)33(46)40-14-25(17)44/h1-4,7,9-13,25,30,43-45,48-49H,5-6,8,14H2,(H,39,47)(H,40,46)(H,50,51,52)/b41-23+,42-29+","standard_inchi_key":"ULPCUXOFORECAE-ONZSAZKHSA-N"},"molecule_synonyms":[{"molecule_synonym":"Bastadin 26","syn_type":"OTHER","synonyms":"Bastadin 26"}],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":"BASTADIN 26","prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6986","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6986","parent_chembl_id":"CHEMBL6986"},"molecule_properties":{"acd_logd":"1.38","acd_logp":"1.38","acd_most_apka":"13.89","acd_most_bpka":null,"alogp":"2.27","aromatic_rings":0,"full_molformula":"C22H36O6","full_mwt":"396.52","hba":6,"hbd":3,"heavy_atoms":28,"molecular_species":"NEUTRAL","mw_freebase":"396.52","mw_monoisotopic":"396.2512","num_alerts":3,"num_ro5_violations":0,"psa":"104.06","qed_weighted":"0.24","ro3_pass":"N","rtb":14},"molecule_structures":{"canonical_smiles":"COC(=O)CCC=C/CC[C@@H]1[C@@H](C=CCC(C)(O)CCCCO)[C@H](O)CC1=O","standard_inchi":"InChI=1S/C22H36O6/c1-22(27,13-7-8-15-23)14-9-11-18-17(19(24)16-20(18)25)10-5-3-4-6-12-21(26)28-2/h3-4,9,11,17-18,20,23,25,27H,5-8,10,12-16H2,1-2H3/b4-3-,11-9+/t17-,18-,20-,22?/m1/s1","standard_inchi_key":"QFVICZQJYDDAAR-PYQODSEPSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6988","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6988","parent_chembl_id":"CHEMBL6988"},"molecule_properties":{"acd_logd":"0.50","acd_logp":"3.68","acd_most_apka":"4.08","acd_most_bpka":null,"alogp":"3.66","aromatic_rings":2,"full_molformula":"C15H13ClO3","full_mwt":"276.71","hba":3,"hbd":1,"heavy_atoms":19,"molecular_species":"ACID","mw_freebase":"276.71","mw_monoisotopic":"276.0553","num_alerts":0,"num_ro5_violations":0,"psa":"46.53","qed_weighted":"0.93","ro3_pass":"N","rtb":4},"molecule_structures":{"canonical_smiles":"COc1cc(ccc1CC(=O)O)c2ccc(Cl)cc2","standard_inchi":"InChI=1S/C15H13ClO3/c1-19-14-8-11(2-3-12(14)9-15(17)18)10-4-6-13(16)7-5-10/h2-8H,9H2,1H3,(H,17,18)","standard_inchi_key":"MWSAFGVWIYCCAF-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6989","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6989","parent_chembl_id":"CHEMBL6989"},"molecule_properties":{"acd_logd":"-4.76","acd_logp":"-0.27","acd_most_apka":"3.07","acd_most_bpka":"9.20","alogp":"0.82","aromatic_rings":2,"full_molformula":"C15H16N4O6","full_mwt":"348.31","hba":9,"hbd":5,"heavy_atoms":25,"molecular_species":"ZWITTERION","mw_freebase":"348.31","mw_monoisotopic":"348.1070","num_alerts":0,"num_ro5_violations":0,"psa":"175.73","qed_weighted":"0.51","ro3_pass":"N","rtb":6},"molecule_structures":{"canonical_smiles":"Cc1c(ccc2nc(N)nc(O)c12)C(=O)NC(CCC(=O)O)C(=O)O","standard_inchi":"InChI=1S/C15H16N4O6/c1-6-7(2-3-8-11(6)13(23)19-15(16)18-8)12(22)17-9(14(24)25)4-5-10(20)21/h2-3,9H,4-5H2,1H3,(H,17,22)(H,20,21)(H,24,25)(H3,16,18,19,23)","standard_inchi_key":"DELHTCXMMIFCPQ-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6991","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6991","parent_chembl_id":"CHEMBL6991"},"molecule_properties":{"acd_logd":"1.20","acd_logp":"3.51","acd_most_apka":"3.13","acd_most_bpka":"8.69","alogp":"4.49","aromatic_rings":4,"full_molformula":"C18H13N3OS","full_mwt":"319.38","hba":5,"hbd":2,"heavy_atoms":23,"molecular_species":"ZWITTERION","mw_freebase":"319.38","mw_monoisotopic":"319.0779","num_alerts":0,"num_ro5_violations":0,"psa":"97.33","qed_weighted":"0.57","ro3_pass":"N","rtb":2},"molecule_structures":{"canonical_smiles":"Nc1nc(O)c2cc(Sc3ccc4ccccc4c3)ccc2n1","standard_inchi":"InChI=1S/C18H13N3OS/c19-18-20-16-8-7-14(10-15(16)17(22)21-18)23-13-6-5-11-3-1-2-4-12(11)9-13/h1-10H,(H3,19,20,21,22)","standard_inchi_key":"DXYSGZNFDLGXPA-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":null,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6992","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6992","parent_chembl_id":"CHEMBL6992"},"molecule_properties":{"acd_logd":"1.16","acd_logp":"1.18","acd_most_apka":null,"acd_most_bpka":"6.80","alogp":"2.62","aromatic_rings":2,"full_molformula":"C13H15ClN4","full_mwt":"262.74","hba":4,"hbd":0,"heavy_atoms":18,"molecular_species":"NEUTRAL","mw_freebase":"262.74","mw_monoisotopic":"262.0985","num_alerts":0,"num_ro5_violations":0,"psa":"32.26","qed_weighted":"0.79","ro3_pass":"N","rtb":1},"molecule_structures":{"canonical_smiles":"CN1CCN(CC1)c2cnc3cc(Cl)ccc3n2","standard_inchi":"InChI=1S/C13H15ClN4/c1-17-4-6-18(7-5-17)13-9-15-12-8-10(14)2-3-11(12)16-13/h2-3,8-9H,4-7H2,1H3","standard_inchi_key":"CSBHRDWXCQKDLZ-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null},{"atc_classifications":[],"availability_type":"-1","biotherapeutic":null,"black_box_warning":"0","chebi_par_id":85558,"chirality":"-1","dosed_ingredient":false,"first_approval":null,"first_in_class":"-1","helm_notation":null,"indication_class":null,"inorganic_flag":"-1","max_phase":0,"molecule_chembl_id":"CHEMBL6993","molecule_hierarchy":{"molecule_chembl_id":"CHEMBL6993","parent_chembl_id":"CHEMBL6993"},"molecule_properties":{"acd_logd":"0.60","acd_logp":"0.60","acd_most_apka":"10.00","acd_most_bpka":"4.04","alogp":"0.62","aromatic_rings":1,"full_molformula":"C8H7N3O","full_mwt":"161.16","hba":3,"hbd":2,"heavy_atoms":12,"molecular_species":"NEUTRAL","mw_freebase":"161.16","mw_monoisotopic":"161.0589","num_alerts":0,"num_ro5_violations":0,"psa":"67.47","qed_weighted":"0.59","ro3_pass":"N","rtb":0},"molecule_structures":{"canonical_smiles":"NC1=Nc2ccccc2C(=O)N1","standard_inchi":"InChI=1S/C8H7N3O/c9-8-10-6-4-2-1-3-5(6)7(12)11-8/h1-4H,(H3,9,10,11,12)","standard_inchi_key":"SDTFBAXSPXZDKC-UHFFFAOYSA-N"},"molecule_synonyms":[],"molecule_type":"Small molecule","natural_product":"-1","oral":false,"parenteral":false,"polymer_flag":false,"pref_name":null,"prodrug":"-1","structure_type":"MOL","therapeutic_flag":false,"topical":false,"usan_stem":null,"usan_stem_definition":null,"usan_substem":null,"usan_year":null,"withdrawn_country":null,"withdrawn_flag":false,"withdrawn_reason":null,"withdrawn_year":null}]

    thisView = @

     # use real values if not being used by test version
    @shownElements = @collection.allResults if @collection?
    @rejectedElements = []
    # ignore molecules for which any value on any of the axes is null, they are not shown by plotly and they
    # can mess the axes range
    @shownElements = _.reject(@shownElements, (mol) ->

      for prop in [thisView.currentPropertyX.prop_name,
        thisView.currentPropertyY.prop_name,
        thisView.currentPropertyColour.prop_name]
        value = glados.Utils.getNestedValue(mol, prop)
        if !value? or value == glados.Settings.DEFAULT_NULL_VALUE_LABEL
          thisView.rejectedElements.push glados.Utils.getNestedValue(mol, thisView.labelerProperty.prop_name)
          return true

      return false
    )

    $rejectedReslutsInfo = $(@el).find('.BCK-CompResultsGraphRejectedResults')
    if @rejectedElements.length
      glados.Utils.fillContentForElement $rejectedReslutsInfo,
        rejected: @rejectedElements
    else
      $rejectedReslutsInfo.html('')

    # --------------------------------------
    # scales
    # --------------------------------------
    # builds a linear scale to position the circles
    # when the data is numeric, range is 0 to canvas width,
    # taking into account the padding
    buildLinearNumericScale = (dataList, axis, defaultDomain) ->

      if defaultDomain
        scaleDomain = defaultDomain
      else
        minVal = Number.MAX_VALUE
        maxVal = Number.MIN_VALUE

        i = 0
        for datum in dataList

          datum = parseFloat(datum)

          if datum == glados.Settings.DEFAULT_NULL_VALUE_LABEL or !datum?
            continue

          if datum > maxVal
            maxVal = datum
          if datum < minVal
            minVal = datum


        scaleDomain = [minVal, maxVal]

      range = [glados.Settings.VISUALISATION_LIGHT_BLUE_MIN, glados.Settings.VISUALISATION_LIGHT_BLUE_MAX]

      scale = d3.scale.linear()
        .domain(scaleDomain)
        .range(range)
      scale.type = thisView.LINEAR

      return scale

    # builds an ordinal scale to position the circles
    # when the data is string, range is 0 to canvas width,
    # taking into account the padding
    buildOrdinalStringScale = (dataList, axis) ->

      if axis == thisView.COLOUR
        return d3.scale.category20()
          .domain(dataList)

      range = switch
        when axis == thisView.XAXIS then [padding.text_left, width - padding.right]
        when axis == thisView.YAXIS then [height - padding.bottom, padding.top]

      scale = d3.scale.ordinal()
        .domain(dataList)
        .rangePoints(range)
      scale.type = thisView.ORDINAL

      return scale


    getScaleForProperty = (molecules, property, axis) ->

      dataList = (glados.Utils.getNestedValue(mol, property.prop_name) for mol in molecules)
      type = thisView.currentPropertyColour.type
      scale = switch
        when type == 'number' then buildLinearNumericScale(dataList, axis, thisView.currentPropertyColour.default_domain)
        when type == 'string' then buildOrdinalStringScale(dataList, axis)

      return scale


    @getColourFor = getScaleForProperty(@shownElements, @currentPropertyColour, @COLOUR)

    xValues = (glados.Utils.getNestedValue(mol, @currentPropertyX.prop_name) for mol in @shownElements)
    yValues = (glados.Utils.getNestedValue(mol, @currentPropertyY.prop_name) for mol in @shownElements)
    labels = (glados.Utils.getNestedValue(mol, @labelerProperty.prop_name) for mol in @shownElements)
    ids = (glados.Utils.getNestedValue(mol, @idProperty.prop_name) for mol in @shownElements)
    colours = (@getColourFor(glados.Utils.getNestedValue(mol, @currentPropertyColour.prop_name)) for mol in @shownElements)
    borderColours = @getBorderColours(@shownElements, @getColourFor)
    borderWidths = @getBorderWidths(@shownElements)

    trace1 = {
      x: xValues,
      y: yValues,
      # custom property to identify the dots
      ids: ids
      mode: 'markers',
      type: 'scatter',
      text: labels,
      textposition: 'top center',
      marker: {
        opacity: 0.8
        size: 12
        color: colours
        line:
          width: borderWidths
          color: borderColours
      }
    }

    legendData = [trace1]
    layout = {
      xaxis: {title: @currentPropertyX.label}
      yaxis: {title: @currentPropertyY.label}
      hovermode: 'closest'
    }
    console.log 'visual element: ', @$vis_elem

    graphDiv = @$vis_elem.get(0)

    Plotly.newPlot(graphDiv, legendData, layout)

    graphDiv.on('plotly_click', (eventInfo) ->
      pointNumber = eventInfo.points[0].pointNumber
      clickedChemblID = eventInfo.points[0].data.ids[pointNumber]
      window.open(Compound.get_report_card_url(clickedChemblID))
    )

    graphDiv.on('plotly_selected', (eventData) ->
      if not eventData?
        return
      thisView.selectItems(_.pluck(eventData.points, 'id'))
    )

    # --------------------------------------
    # Legend initialisation
    # --------------------------------------
    elemWidth = $(@el).width()
    horizontalPadding = 10
    legendWidth = 0.4 * elemWidth
    legendHeight = glados.Settings.VISUALISATION_LEGEND_HEIGHT
    $legendContainer = $(@el).find('.BCK-CompResultsGraphLegendContainer')
    $legendContainer.empty()
    legendContainer = d3.select($legendContainer.get(0))

    legendSVG = legendContainer.append('svg')
      .attr('width', legendWidth + 2 * horizontalPadding )
      .attr('height', legendHeight )

    # --------------------------------------
    # Fill legend details
    # --------------------------------------

    fillLegendDetails = ->

      legendSVG.selectAll('g').remove()
      legendSVG.selectAll('text').remove()

      legendG = legendSVG.append('g')
              .attr("transform", "translate(" + horizontalPadding + "," + (legendHeight - 30) + ")")

      legendSVG.append('text')
        .text(thisView.currentPropertyColour.label)
        .attr("class", 'plot-colour-legend-title')

      # center legend title
      textWidth = d3.select('.plot-colour-legend-title').node().getBBox().width
      xTrans = (legendWidth - textWidth) / 2

      legendSVG.select('.plot-colour-legend-title')
        .attr("transform", "translate(" + xTrans + ", 35)")

      rectangleHeight = glados.Settings.VISUALISATION_LEGEND_RECT_HEIGHT
      colourDataType = thisView.currentPropertyColour.type

      if colourDataType == 'string'

        domain = @getColourFor.domain()
        getXInLegendFor = d3.scale.ordinal()
          .domain( domain )
          .rangeBands([0, legendWidth])

        legendAxis = d3.svg.axis()
          .scale(getXInLegendFor)
          .orient("bottom")

        legendG.selectAll('rect')
          .data(getXInLegendFor.domain())
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', getXInLegendFor.rangeBand())
          .attr('x', (d) -> getXInLegendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> thisView.getColourFor d)

        legendG.call(legendAxis)

      else if colourDataType == 'number'

        domain = thisView.getColourFor.domain()
        linearScalePadding = 10
        getXInLegendFor = d3.scale.linear()
          .domain(domain)
          .range([linearScalePadding, (legendWidth - linearScalePadding)])

        getXInLegendFor.ticks(3)

        legendAxis = d3.svg.axis()
          .scale(getXInLegendFor)
          .orient("bottom")

        start = domain[0]
        stop = domain[1]
        numValues = 50
        step = Math.abs(stop - start) / numValues
        stepWidthInScale = Math.abs(getXInLegendFor.range()[0] - getXInLegendFor.range()[1]) / numValues

        legendData = d3.range(start, stop, step)

        legendAxis.tickValues([
          legendData[0]
          legendData[parseInt(legendData.length * 0.25)],
          legendData[parseInt(legendData.length * 0.5)],
          legendData[parseInt(legendData.length * 0.75)],
          legendData[legendData.length - 1],
        ])

        legendG.selectAll('rect')
          .data(legendData)
          .enter().append('rect')
          .attr('height',rectangleHeight)
          .attr('width', stepWidthInScale + 1)
          .attr('x', (d) -> getXInLegendFor d)
          .attr('y', -rectangleHeight)
          .attr('fill', (d) -> thisView.getColourFor d)

        legendG.call(legendAxis)

    fillLegendDetails()
    #customize legend styles
    $legendContainer.find('line, path').css('fill', 'none')

    prop = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'RO5')
    legendModel = new glados.models.visualisation.LegendModel
      property: prop
      collection: @collection

    $legendContainer2 = $(@el).find('.BCK-CompResultsGraphLegendContainer2')
    legendView = new LegendView
      model: legendModel
      el: $legendContainer2

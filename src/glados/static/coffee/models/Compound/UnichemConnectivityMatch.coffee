glados.useNameSpace 'glados.models.Compound',
  UnichemConnectivityMatch: Backbone.Model.extend {}

glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE =
'{{#each val}}' +
'{{#if this.show}}<a target="_blank" href="{{this.ref_url}}">{{this.ref_id}}</a> {{else}} {{/if}}' +
'{{/each}}'

glados.models.Compound.UnichemConnectivityMatch.COLUMNS =
  SOURCE:
    name_to_show: 'Source'
    comparator: 'src_name'
    link_base: 'scr_url'
  IDENTICAL_COMPONENT_MATCHES:
    name_to_show: 'Identical Component'
    comparator: 'identical_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE
  S:
    name_to_show: 'S'
    comparator: 's_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE
  I:
    name_to_show: 'I'
    comparator: 'i_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE
  P:
    name_to_show: 'P'
    comparator: 'p_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE
  SI:
    name_to_show: 'SI'
    comparator: 'si_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE
  IP:
    name_to_show: 'IP'
    comparator: 'ip_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE
  SP:
    name_to_show: 'SP'
    comparator: 'sp_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE
  SIP:
    name_to_show: 'SIP'
    comparator: 'sip_matches'
    custom_field_template: glados.models.Compound.UnichemConnectivityMatch.REF_TEMPLATE


glados.models.Compound.UnichemConnectivityMatch.ID_COLUMN = glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SOURCE

glados.models.Compound.UnichemConnectivityMatch.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.UnichemConnectivityMatch.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SOURCE
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.IDENTICAL_COMPONENT_MATCHES
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.S
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.I
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.P
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SI
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.IP
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SP
    glados.models.Compound.UnichemConnectivityMatch.COLUMNS.SIP
  ]
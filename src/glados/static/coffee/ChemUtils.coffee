glados.useNameSpace 'glados',
  ChemUtils:
    # based on http://opensmiles.org/opensmiles.html
    SMILES:
      canonicalize_ws_url: 'https://www.ebi.ac.uk/chembl/api/utils/canonicalizeSmiles'
      aliphatic_organic: '(?:B|C|N|O|S|P|F|Cl|Br|I)'
      aromatic_organic: '(?:b|c|n|o|s|p)'
      element_symbols: '(?:H|He|Li|Be|B|C|N|O|F|Ne|Na|Mg|Al|Si|P|S|Cl|Ar|K|Ca|Sc|Ti|V|Cr|Mn|Fe|Co|Ni|Cu|Zn|Ga|Ge|As|'+
        'Se|Br|Kr|Rb|Sr|Y|Zr|Nb|Mo|Tc|Ru|Rh|Pd|Ag|Cd|In|Sn|Sb|Te|I|Xe|Cs|Ba|Hf|Ta|W|Re|Os|Ir|Pt|Au|Hg|Tl|Pb|Bi|Po|At|'+
        'Rn|Fr|Ra|Rf|Db|Sg|Bh|Hs|Mt|Ds|Rg|Cn|Fl|Lv|La|Ce|Pr|Nd|Pm|Sm|Eu|Gd|Tb|Dy|Ho|Er|Tm|Yb|Lu|Ac|Th|Pa|U|Np|Pu|Am|'+
        'Cm|Bk|Cf|Es|Fm|Md|No|Lr)'
      aromatic_symbols: '(?:b|c|n|o|p|s|se|as)'
    InChI:
      regex: /^(InChI=)([^J]|[0-9+\-\(\)\\\/,])+$/
      key_regex: /^[A-Z]{14}-[A-Z]{10}-[A-Z]$/
    UniChem:
      orphaned_id_url: 'https://www.ebi.ac.uk/unichem/rest/orphanIdMap/'
      connectivity_url: 'https://www.ebi.ac.uk/unichem/rest/key_search/'
    DOI:
      regex: new RegExp('^(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?!["&\'<>|])\\S)+)$')
    CHEMBL:
      id_regex: /^CHEMBL[^\d\s]{0,2}([\d]+)[^\d\s]{0,2}$/i

glados.ChemUtils.SMILES.valid_elements = '(?:'+
  glados.ChemUtils.SMILES.aliphatic_organic+'|'+
  glados.ChemUtils.SMILES.aromatic_organic+'|'+
  glados.ChemUtils.SMILES.element_symbols+'|'+
  glados.ChemUtils.SMILES.aromatic_symbols+')'



glados.ChemUtils.SMILES.regex_other_chars= /[0-9\.@+\-\[\]\(\)\\\/%=#$~&!]/

glados.ChemUtils.SMILES.regex = new RegExp('^(?:'+glados.ChemUtils.SMILES.valid_elements+
  '|'+glados.ChemUtils.SMILES.regex_other_chars.source+'){4,}$'
)

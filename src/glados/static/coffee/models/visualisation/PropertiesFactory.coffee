glados.useNameSpace 'glados.models.visualisation',
  PropertiesFactory:
    Compound:
      esIndex:'chembl_molecule'
      Properties:
        USAN_YEAR:
          propName: 'usan_year'
          label: 'Year'
        RELATED_ASSAYS:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        RELATED_TARGETS:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        RELATED_ACTIVITIES:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        CHEMBL_ID:
          propName:'molecule_chembl_id'
          label: 'CHEMBL_ID'
        ALogP:
          propName: 'molecule_properties.alogp'
          label: 'ALogP'
        RO5:
          propName:'molecule_properties.num_ro5_violations'
          label: '#RO5 Violations'
          domain: [glados.Settings.DEFAULT_NULL_VALUE_LABEL, 0, 1, 2, 3, 4]
          coloursRange: [
            glados.Settings.VISUALISATION_GRID_NO_DATA,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL2,
            glados.Settings.VIS_COLORS.TEAL1
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        FULL_MWT:
          propName:'molecule_properties.full_mwt'
          label: 'Parent Molecular Weight'
          label_mini: 'Mol. Wt.'
          coloursRange: [glados.Settings.VIS_COLORS.RED5, glados.Settings.VIS_COLORS.RED2]
          colourScaleType: glados.Visualisation.CONTINUOUS
          ticksNumber: 5
        PSA:
          propName:'molecule_properties.psa'
          label: 'Polar Surface Area'
        HBA:
          propName:'molecule_properties.hba'
          label: 'Hydrogen Bond Acceptors'
        HBD:
          propName:'molecule_properties.hbd'
          label: 'Hydrogen Bond Donnors'
        THERAPEUTIC_FLAG:
          propName: 'therapeutic_flag'
          label: 'Therapeutic'
          parser:
            0: 'No'
            1: 'Yes'
            false: 'No'
            true: 'Yes'
        MAX_PHASE:
          propName: 'max_phase'
          label: 'Max phase'
          domain: [ 0, 1, 2, 3, 4]
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL1,
            glados.Settings.VIS_COLORS.TEAL2,
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        INDICATION_CLASS:
          propName: 'indication_class'
          label: 'Indication class'
          type: String
          colourScaleType: glados.Visualisation.CATEGORICAL
          coloursRange: [
            '#0a585b',
            '#077c80',
            '#2ba3a5',
            '#6fc7c6',
            '#c4e6e5',
            '#f1d6db',
            '#fdabbc',
            '#f9849d',
            '#e95f7e',
            '#cc4362'
          ]
        DISEASE:
          propName: '_metadata.drug_indications.efo_term'
          label: 'Disease'
          type: String
          colourScaleType: glados.Visualisation.CATEGORICAL
          coloursRange: [
            '#0a585b',
            '#077c80',
            '#2ba3a5',
            '#6fc7c6',
            '#c4e6e5',
            '#f1d6db',
            '#fdabbc',
            '#f9849d',
            '#e95f7e',
            '#cc4362'
          ]
    DocumentAggregation:
      Properties:
        YEAR:
          propName: 'year'
          label: 'Year'
          type: Number
        JOURNAL_NAME:
          propName: 'journal'
          label: 'Journal'
          type: Number
          colourScaleType: glados.Visualisation.CATEGORICAL
          coloursRange: [
            '#0d343a',
            '#0a585b',
            '#077c80',
            '#2ba3a5',
            '#6fc7c6',
            '#c4e6e5',
            '#fdabbc',
            '#f1d6db',
            '#f9849d',
            '#e95f7e',
            '#cc4362',
            '#a03a50',
            '#a03a50'
          ]
    Document:
      Properties:
        RELATED_TARGETS:
          propName: 'classes'
          label: 'Classes'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        RELATED_ASSAYS:
          propName: 'types'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        RELATED_ACTIVITIES:
          propName: 'types'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
    Target:
      esIndex:'chembl_target'
      Properties:
        ACTIVITY_TYPES:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        ASSOCIATED_ASSAYS:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        CHEMBL_ID:
          propName:'target_chembl_id'
          label: 'CHEMBL_ID'
        PREF_NAME:
          propName:'pref_name'
          label: 'Pref. Name'
        TARGET_TYPE:
          propName:'target_type'
          label: 'Target Type'
          label_mini: 'Type'
          domain: ["Other","SINGLE PROTEIN","ORGANISM","CELL-LINE","PROTEIN COMPLEX","PROTEIN FAMILY","TISSUE","SELECTIVITY GROUP","PROTEIN COMPLEX GROUP","NUCLEIC-ACID","SMALL MOLECULE","PROTEIN-PROTEIN INTERACTION","UNKNOWN","SUBCELLULAR","METAL","MACROMOLECULE","OLIGOSACCHARIDE","PROTEIN NUCLEIC-ACID COMPLEX","CHIMERIC PROTEIN","LIPID","PHENOTYPE","ADMET","NO TARGET","UNCHECKED"]
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL1,
            glados.Settings.VIS_COLORS.TEAL2,
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.RED5,
            glados.Settings.VIS_COLORS.BLUE1,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.BLUE4,
            glados.Settings.VIS_COLORS.BLUE5,
            glados.Settings.VIS_COLORS.ORANGE2,
            glados.Settings.VIS_COLORS.ORANGE3,
            glados.Settings.VIS_COLORS.PURPLE1,
            glados.Settings.VIS_COLORS.PURPLE2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL

        TARGET_CLASS:
          propName:'target_class'
          label: 'Target Class'
          label_mini: 'Class'
          domain: ["Other", "Enzyme", "Unclassified protein", "Membrane receptor", "Ion channel", "Other cytosolic protein", "Transporter", "Transcription factor", "Epigenetic regulator", "Secreted protein", "Structural protein", "Auxiliary transport protein", "Surface antigen", "Other membrane protein", "Adhesion", "Other nuclear protein"]
          range: [
            glados.Settings.VIS_COLORS.TEAL1,
            glados.Settings.VIS_COLORS.TEAL2,
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.RED5,
            glados.Settings.VIS_COLORS.BLUE1,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.BLUE4,
            glados.Settings.VIS_COLORS.BLUE5,
            glados.Settings.VIS_COLORS.ORANGE2,
            glados.Settings.VIS_COLORS.ORANGE3,
          ]

          colourScaleType: glados.Visualisation.CATEGORICAL
    Cell:
      esIndex: 'chembl_cell_line'
      Properties:
        RELATED_ASSAYS:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        RELATED_ACTIVITIES:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
    Tissue:
      esIndex:'chembl_tissue'
      Properties:
        RELATED_ASSAYS:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
        RELATED_ACTIVITIES:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
    Assay:
      esIndex:'chembl_assay'
      Properties:
        RELATED_TARGETS:
          propName: 'type'
          label: 'Types'
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.PURPLE2,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.GREY2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
    Activity:
      esIndex:'chembl_activity'
      Properties:
        LIGAND_EFFICIENCY_SEI:
          propName: 'ligand_efficiency.sei'
          label: 'Surface Efficiency index (SEI)'
          type: Number
        LIGAND_EFFICIENCY_BEI:
          propName: 'ligand_efficiency.bei'
          label: 'Binding Efficiency index (BEI)'
          type: Number
        STANDARD_VALUE:
          propName: 'standard_value'
          label: 'Standard Value nM'
          domain:[1, 100, 1000]
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL2
            glados.Settings.VIS_COLORS.TEAL3
            glados.Settings.VIS_COLORS.TEAL5
            glados.Settings.VIS_COLORS.RED2
          ]
          colourScaleType: glados.Visualisation.THRESHOLD
        MOLECULE_CHEMBL_ID:
          propName: 'molecule_chembl_id'
          label: 'Compound'
          type: String
        ACTIVITY_ID:
          propName: 'activity_id'
          label: 'Activity id'
        STANDARD_TYPE:
          propName: 'standard_type'
          label: 'Standard Type'
          label_mini: 'Std. Type'
          domain: ["Other", "Potency","GI50","IC50","Activity","Inhibition","Ki","MIC","EC50","AC50","ED50","Kd","Ratio","Residual Activity","IZ","Tissue Severity Score","GI","CC50","Ratio IC50","T1/2","LC50","TGI","CL","Drug uptake","MIC90","MIC50","Ratio Ki","Solubility","FC","IFI","AUC","Stability","F","mortality","ID50","Efficacy","WEIGHT","LogP","Emax","XC50","Selectivity ratio","Cmax","T/C","logD","Selectivity","MBC","Time","Ratio EC50","Change","LD50","pKa","IC90","MIC80","Vdss","Control","Survival","Km","Reduction","Papp","MFC","Delta Tm","Ratio CC50/EC50","Intrinsic activity","MED","permeability","Concentration","Relative potency","WBC","BUN","RBA","RBC","ALT","MCHC","ALP","CHOL","HCT","MCV","ALB","AST","CREAT","GLUC","HGB","MCH","PHOS","PROT","CHLORIDE","POTASSIUM","SODIUM","PLAT","BASOLE","EOSLE","LYMLE","MONOLE","NEUTLE","BILI","LDH","Selectivity Index","Tmax","ILS","Kb","DIZ","Ratio CC50/IC50","Stabilty","Drug metabolism","Cp","APTT","Hepatotoxicity","PT","ID/g","Selectivity index","MCC","TI","CLogP","MIC99","FIBRINO","TERMBW","TRIG","ALBGLOB","CALCIUM","PHOSLPD","RETIRBC","BILDIR","Dose","-logMIC","GGT","AbsAC40_uM","pKb","TC50","TD50","Cytotoxicity","Fu","PPB","Decrease","Ke","Toxicity","MST","Kcat","INH","EC90","solubility","Relative activity","Kcat/Km","Vmax","Imax","Kinact","PD50","Diet","Hepatotoxicity (acute)","Hepatotoxicity (moderate)","Vd","Protection","CLH","Residual activity","Log 1/C","Increase","IC95","Survivors","Delta MST","Motility","pD2","%max","Effect","Biodistribution","MTD","AbsAC35_uM","Ka","pKB","IC50 ratio","SI","MRT","Tm","Max","Dose/organ","CK","K","AbsAC35","LIPASE","URATE","Response","Log K","CO2","BASO","EOS","LYM","MONO","MEC","Displacement","BP","Weight change","NEUTSG","AbsAC26_uM","Fold change","Duration","SUV","RBCNUC","Dose/g","CD50","OD","log10cfu","BPR","ID/organ","Concentration @ Maxi","K obs / 1","Hepatotoxicity (animal toxicity known)","Hepatotoxicity (association with vascular disease)","Hepatotoxicity (benign tumour)","Hepatotoxicity (choleostasis)","Hepatotoxicity (chronic liver disease)","Hepatotoxicity (cirrhosis)","Hepatotoxicity (comment)","Hepatotoxicity (cytolytic)","Hepatotoxicity (granulomatous hepatitis)","Hepatotoxicity (malignant tumour)","Hepatotoxicity (mechanism)","Hepatotoxicity (severe hepatitis)","Hepatotoxicity (steatosis)","Hepatotoxicity (successful reintroduction)","Hepatotoxicity (time to onset)","PI","ED90","KA","t1/2","AbsAC40","K app","AD50","log K","Growth","Conc @ Max Fold Incr","LogD","IA","Ratio ED50","Cures","ED30","Stimulation","Distribution","Decrease in blood pressure","FICI","log10CFU/ml","Injected dose","IC80","Diuretic activity","pKi","MTC","NT","Log Ki","HepSE_Combined Scores","HepSE_bilirubinemia","HepSE_cholecystitis","HepSE_cholelithiasis","HepSE_cirrhosis","HepSE_elevated liver function tests","HepSE_hepatic failure","HepSE_hepatic necrosis","HepSE_hepatitis","HepSE_hepatomegaly","HepSE_jaundice","HepSE_liver disease","HepSE_liver fatty","HepSE_liver function tests abnormal","Therapeutic index","CL_renal","Phospholipidosis","MIC100","k obs / 1","Mortality","Log 1/D50","Activation","EC","Log 1/LD10","C50","UI","Ratio TD50/ED50","Ratio IC50/EC50","Reversal","Level","Potency ratio","Relative binding affinity","Binding","Radioactivity","Injected dose/g","pA2","ED20","Heart rate","logIC50","RatioLC50","fT>MIC","CD","K ass","AC40","ED","NA","IP","Max response","deltaT","Zone of inhibition","Delta mean survival time","No. of survivors","Max_Activity","RatioGI50","Max fall in blood pressure","MIC95","HR","Rate of inhibition","Delta TC","MSD","AUC/dose","Log 1/MMIC","Animals","Suppression","ILSmax","MPC","k cat","Viability","Optimal dose","Variation","Ratio pKi","ID","Log IC50","Recovery","Locomotor activity","Affinity","fu","AFI","Drug degradation","k3/Ki","Log2 MIC","ED25","No. of cured mice","PB","Activity rating","EDmin","IC100","Virus rating","pGI50","Delta blood pressure","Plasma level","log Pe","Decrease in SBP","AbsAC1000_uM","Delta IOP","HD50","Log k'","Relative IC50","Alkaline Phosphatase Increase - Activity Score","Alkaline Phosphatase Increase - Index Value","Alkaline Phosphatase Increase - Number of Reports","Composite Activity - Active","Composite Activity - Marginal","Composite Activity - Score","GGT Increase - Activity Score","GGT Increase - Index Value","GGT Increase - Number of Reports","LDH Increase - Activity Score","LDH Increase - Index Value","LDH Increase - Number of Reports","SGOT Increase - Activity Score","SGOT Increase - Index Value","SGOT Increase - Number of Reports","SGPT Increase - Activity Score","SGPT Increase - Index Value","SGPT Increase - Number of Reports","pED50","Saluretic activity","T-C","max activation","Paw swelling","Kis","pIC50","-Log C","Binding affinity","EC25","Log 1/Ki app","log(1/C)","Kapp","log Ks","Ki ratio","Plasma concentration","CL/F","ERH","Rm","logPapp","Relative affinity","Bmax","Ratio AUC","CFU","Permeability","k_obs","Score","No. of animals","K inact","EC30","EC80","Inhibition zone","Phytotoxicity","LC90","Growth inhibition","Urine volume","Block","Max_Activity_Concent","Anticonvulsant activity","-Log KB","deltaCT","AbsAC1","PC50","Retention time","HC50","Fall","MABP","2PT","Body weight","k","Injected","Solubility ratio","k_on","pD'2","MBC90","k2","Diameter of inhibition zone","Fa","Cured","LD10","KE","Uptake","Hill coefficient","No. of mice cured","IC30","SDL","Survival time","Cooperativity","Viable cells","Incorporation","FDI","k'","IC20","Release","Schizont size","Mean survival time","Metabolism","RA","pEC50","Average weight","Weight","GR80","LD90","Distribution of radioactivity","Effective dose","MPC8","pI50","D","Blood glucose","Ratio Ke","Ratio pIC50","PFA","LCK","LD99","Safety ratio","Cmin","Cp(f)","No. of revertants per plate","pKa2","Fh","ED40","Inhibitory activity","MBC50","IC25","MLC","F_fraction","Fg","Kii","Mean injected dose/g","Weight difference","Average weight change","ILS max","MES","Antagonism","Polyamine","k cat/Km","APD95","RUmax","pKa1","Repellency","log(10^6/IC50)","Log EC50","Relaxation","IC12","ED100","Log 1/M","Complex formation","CCIC50","VR","Drug release","Retention_time","Cell survival","LTKB_BD DILI severity score","MBIC","Relative efficacy","log(1/MIC)","DC50","P","pKD","MNCC","Max inhibition","ED50 ratio","Oral activity","Accumulation","Average IC90","delta logD","MPE","k_off","I.D./g","Log S","MLD","Rate","R","Hydrolysis","Rmax","D50","logKi","Delta G","LTS","Blood pressure","RF","DILI positive/negative","Formation","PAE","log(1/ID50)","Growth_index","Fold reversion","Range","ED1.5","MBP","fAUC/MIC","Amnesia reversal","EC20","ED80","pCC50","Estrogenic effect","I50","IOP","Mean survival days","RFU","Residual insulin release","GR50","AP","CMC","IG50","Change in BP","Relative Vmax","Tissue distribution","RatioAUC/MIC","Kinetic","Potentiation","LC99","kinact","ALD50","I","K0.5","Binding energy","-log(1/MIC)","Delta HR","No. of cures","No. of mice","TCS50","Antagonist potency","CC90","Kinetic_solubility","Excretion","Parasitaemia","Glucose normalisation","Mole fraction","Remaining","IC70","Retention","Lethality","Toxic deaths","Cell viability","Hypoglycemic activity","MNEC","Drug recovery","K2","Delta MAP","DNAUC","RI","log Kp","CF","Log SP","Efficiency","Median survival time","Ks","MAP","Sleeping time","MIC>90","Mean survival","TPE","deltaTm","Log LC50","Max stimulation","RLU","Change in heart rate","Log RA","PF50","nH","LogP app","T","Agonist potency","Rate constant","Smax","NI","Residual_activity","deltaA","Cell growth","Max effect","Acquisition time","LogD7.4","Na","BWD","Basal uptake","Enhancement","Index","Resistance index","MGM","P50","Protected","delta pIC50 wt-mutant","Log kill","Mean arterial blood pressure","Log 1/K","Taste character","CT","Survivals","deltalog10CFU/ml","Aggregation","CC25","TDS","2aPTT","Change in amplitude response","Ct","MFC90","Relative SEAP activity","Relative viability","Body weight change","C10","CFU/ml","PGI","C20","Delta A/min","MAC","AB50","Emetic episodes","EC99","Resistance","XI50","EC100","EMR","EC50 ratio","Log PNalk","Specific activity","V","pLD50","Reversion","Delta BG","MNTD","MPR","MTL","No. of cells","Log 1/T","RRT","EC15","Geometric mean","Specific binding","k3/ki","Cleavage","Crop_yield","EH","-Log ED50","CLogD","Partition coefficient","Taq inhibition","fAUC","GABA ratio","Log 1/MIC","SVT","Latency","pIC25","Disease control","GE","Lowering","pKA","Number","Tumor volume","GABA shift","Total radioactivity","Kic","Uterine weight","Change in weight","pK","Average skin reaction","FRP","Ratio Ki(app)","Serum Ca2+","Analgesia","Contraction","MFC50","TC","Normalization","ID x kg of body weight/g of tissue","Parasitemia","Response ratio","&#256;","Absorption","Conversion","IC99","MIC=>90","TT","Duration of action","No. of survivals","QH","Resistance factor","log10(%HIA +10)","Alloste ic enhan er (AE)","LC80","Log kon","RIS","Relative uterus weight","Relative ED50","Zone size","kHOX","Iron change","K(p,uu,brain)","MISS T/C","Proliferative response","-Delta G","Activity_index","ED2","Log kOH-","MBC99.9","MBIC90","Uptake ratio","Flu intensity","HACU improvement","Fold selectivity","K inact/Ki","Peff","Reduction of live worms","Cures/total","ISA","Neurotoxicity","Systolic blood pressure","Alpha max","CC100","CT10","Culture","pRA","Saluretic potency","Survivors at day 4","Apoptosis","ED10","LAD","MID","SC50","HF","Log Kd","Oral diuretic activity","Tumors","fCmax","Activity scale","Decrease in Systolic blood pressure","Relative EC30","logEC50","pTGI","-Log MIC","Licking latency","Mean relative potency","BBR","CHI","Kp","Swelling","ED99","IC10","Inhibition ratio","KB","TDI","BBC","HCR","pKi(uM)","Average survival","CPE index","Leishmanicidal activity","P50e","Survival rate","C/I ratio","Specificity","Toxic","Weight loss","LC70","Proliferation","Uptake value","dP/dt","kDPPH","Mean blood pressure","No. of toxic deaths","Normal beats","Rating","Recovery time","UTC","Change in IOP","Log koff","MAD","Toxic dose","CCh","GC50","Hypersensitivity factor","No. of positive cases","Change in blood pressure","Diuretic effect","Drug uptake(free)","Equieffective dose","TCID50","NE","Amount excreted","Log BR","CI","FR50","KB app","Mutagenicity","Agonism","Fluorescence intensity","Fold increase","KL","Rf","Time constant","Decrease in activity","Toxicity ratio","Max salt tolerance","Relative Potency","Relative velocity","Turnover","log(1/MLD)","logKw","p[A50]","MD","logP(lung)","Decrease in AP","Enzyme activity","Methemoglobin","NS","Serum level","Distribution (dose/g)","EC150","HI","Hemolysis","Log 1/MEC","No. of tumors","TR","kOX","EC95","Inhibition rate","Lysis","Relative amplitude","Weight change difference","logFu","BP decrease","Ki app","LD100","Susceptibility","Temperature","Vd/F","log(%)","Kq","No. of mice protected","log10CFU/g","Log (1/C)","ND50","No. of animals protected/animals tested","Stimulation index","Analgesic activity","Blood sugar lowering","LED","Log 1/Km","Delta t","MIC>98","Change in Cl- current","Decrease in CR","Induction","LD0","Log ED50","Metabolic stability","KSV","Mean","SMT","AbsAC50_uM","Cholesterol reduction","Conversion rate","SD90","Secretion","Fluorescence","Glucose utilization","Inhibitory diameter","S","Selectivity quotient","T50","Clearance","EC200","ED85","Increase in blood pressure","Production","Q","mechanism based inhibition","Entry latency","LC95","Max increase","Pc","SP","A50","Antagonist activity","Fold activation","pKa3","pTD50","DD","Injected dose/organ","Na+/K+","Relative hydrolysis rate","Taste class","Total iron output","Volume","Expression","IR","IVP","Na+ excretion","Safety index","T/C x100","TI50","2x APTT","Activity index","Delta HR50","LC100","No. of rosettes/100 Jurkat T cells","Sensitivity","Death","Estrogenic potency","Inhibitory index","MPE50","Onset","Tumor weight","Agonist activity","Antifertility potency","ID90","LD20","Wet weight of tissue","Log I50","Protein binding","Relative protection","TG100","Beta2 duration","Drugexcretion","ECmax","IS","PBI","Protein-DNA complex formation","Affinity constant","Blood level","CCID50","ID50 ratio","MBEC","P50c","log(1/IC50)","log(ratioKi)","Cures/no. of animals","K1","No. of sensitive","Serum concentration","Adhesion","Change in response","RE","behavior","Amount of TNF-alpha","Average dose per organ","ED15","Hammett constant","Hypothermic effect","Increase in IC50","NO release","Ratio LC50/IC50","BA","BK","Benzidine positive cells","PCMA antagonism","ED95","Lactone","Max reversal","Metabolite level","Occ","Serosal/Mucosal Ca","Sweetness potency","Total cholesterol","Transfection efficiency","pka","3 log kill","Ataxia","DA release","Delta SBP"]
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL1,
            glados.Settings.VIS_COLORS.TEAL2,
            glados.Settings.VIS_COLORS.TEAL3,
            glados.Settings.VIS_COLORS.TEAL4,
            glados.Settings.VIS_COLORS.TEAL5,
            glados.Settings.VIS_COLORS.RED3,
            glados.Settings.VIS_COLORS.RED2,
            glados.Settings.VIS_COLORS.RED4,
            glados.Settings.VIS_COLORS.RED5,
            glados.Settings.VIS_COLORS.BLUE1,
            glados.Settings.VIS_COLORS.BLUE2,
            glados.Settings.VIS_COLORS.BLUE3,
            glados.Settings.VIS_COLORS.BLUE4,
            glados.Settings.VIS_COLORS.BLUE5,
            glados.Settings.VIS_COLORS.ORANGE2,
            glados.Settings.VIS_COLORS.ORANGE3,
            glados.Settings.VIS_COLORS.PURPLE1,
            glados.Settings.VIS_COLORS.PURPLE2
          ]
          colourScaleType: glados.Visualisation.CATEGORICAL
    ActivityAggregation:
      Properties:
        PCHEMBL_VALUE_AVG:
          propName: 'pchembl_value_avg'
          label: 'PChEMBL Value Avg'
          type: Number
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL6,
            glados.Settings.VIS_COLORS.TEAL3
          ]
          colourScaleType: glados.Visualisation.CONTINUOUS
          ticksNumber: 5
        PCHEMBL_VALUE_MAX:
          propName: 'pchembl_value_max'
          label: 'PChEMBL Value Max'
          type: Number
        ACTIVITY_COUNT:
          propName: 'activity_count'
          label: 'Activity Count'
          type: Number
          coloursRange: [
            glados.Settings.VIS_COLORS.TEAL6,
            glados.Settings.VIS_COLORS.TEAL3
          ]
          colourScaleType: glados.Visualisation.CONTINUOUS
          ticksNumber: 5
        HIT_COUNT:
          propName: 'hit_count'
          label: 'Hit Count'
          type: Number

    # Generic functions
    generateColourScale: (prop) ->

      if prop.colourScaleType == glados.Visualisation.CATEGORICAL
        prop.colourScale = d3.scale.ordinal()
      else if prop.colourScaleType == glados.Visualisation.CONTINUOUS
        prop.colourScale = d3.scale.linear()
      else if prop.colourScaleType == glados.Visualisation.THRESHOLD
        prop.colourScale = d3.scale.threshold()
      prop.colourScale.domain(prop.domain).range(prop.coloursRange)

    generateContinuousDomainFromValues: (prop, values) ->

      minVal = Number.MAX_VALUE
      maxVal = -Number.MAX_VALUE

      for val in values

        val = parseFloat(val)
        if val == glados.Settings.DEFAULT_NULL_VALUE_LABEL or !val?
            continue

        if val > maxVal
          maxVal = val
        if val < minVal
          minVal = val

      prop.domain = [minVal, maxVal]

    parseValueForEntity: (esIndex, propName, propValue) ->

      # the idea is that the parsers can be cached so the browser doesn't have to look for the parser every time
      # the function is called
      if not glados.models.visualisation.PropertiesFactory.parsersIndex?
        glados.models.visualisation.PropertiesFactory.parsersIndex = {}

      parsersIndex = glados.models.visualisation.PropertiesFactory.parsersIndex
      parserID = esIndex + ":" + propName
      parser = parsersIndex[parserID]

      if not parser?

        for entityKey, entity of glados.models.visualisation.PropertiesFactory
          if entity.esIndex == esIndex
            properties = entity.Properties
            for propKey, property of properties
              if property.propName == propName
                parser = property.parser

      # if parser doesn't exist, add a placeholder
      if not parser?
        parser = {}
      parsersIndex[parserID] = parser

      parsedValue = parser[propValue]
      parsedValue ?= propValue

      return parsedValue



glados.models.visualisation.PropertiesFactory.getPropertyConfigFor = (entityName, propertyID, withColourScale=false) ->

  esIndex = glados.models.visualisation.PropertiesFactory[entityName].esIndex
  customConfig = glados.models.visualisation.PropertiesFactory[entityName].Properties[propertyID]
  baseConfig = if not esIndex? \
    then {} else glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[esIndex][customConfig.propName]

  prop = $.extend({}, baseConfig, customConfig)

  if withColourScale
    glados.models.visualisation.PropertiesFactory.generateColourScale(prop)

  return prop


  # randomColours = []
#            numColours = 16
#            seed = 3
#            for i in [1..numColours]
#              randomColours.push ("#" + (Math.round(Math.sin(seed++) * 0xFFFFFF)).toString(16))
#
#            range = randomColours
##            range = [glados.Settings.VISUALISATION_GREY_BASE].concat(d3.scale.category20b().range()).concat(randomColours)
#
#            console.log 'AAA range: ', range
#            console.log 'AAA range: ', JSON.stringify(range)
#            return range
#          )()

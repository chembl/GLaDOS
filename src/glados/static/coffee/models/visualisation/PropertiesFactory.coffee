glados.useNameSpace 'glados.models.visualisation',
  PropertiesFactory:
    Compound:
      esIndex:'chembl_molecule'
      Properties:
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
          coloursRange: [glados.Settings.VISUALISATION_GREY_BASE, '#e3f2fd', '#90caf9', '#42a5f5', '#1976d2', '#0d47a1']
          colourScaleType: glados.Visualisation.CATEGORICAL
        FULL_MWT:
          propName:'molecule_properties.full_mwt'
          label: 'Parent Molecular Weight'
          label_mini: 'Mol. Wt.'
          coloursRange: [glados.Settings.VISUALISATION_LIGHT_BLUE_MIN, glados.Settings.VISUALISATION_LIGHT_BLUE_MAX]
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
    Target:
      esIndex:'chembl_target'
      Properties:
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
          coloursRange: ["#9e9e9e","#393b79","#5254a3","#6b6ecf","#9c9ede","#637939","#8ca252","#b5cf6b","#cedb9c","#8c6d31","#bd9e39","#e7ba52","#e7cb94","#843c39","#ad494a","#d6616b","#e7969c","#7b4173","#a55194","#ce6dbd","#de9ed6","#e8c7b6","#242071","#c1bdce"]

#  (->
#
#            randomColours = []
#            numColours = 24 - 21
#            seed = 2
#            for i in [1..numColours]
#              randomColours.push ("#" + (Math.round(Math.sin(seed++) * 0xFFFFFF)).toString(16))
#
#            range = [glados.Settings.VISUALISATION_GREY_BASE].concat(d3.scale.category20b().range()).concat(randomColours)
#
#            console.log 'AAA range: ', range
#            console.log 'AAA range: ', JSON.stringify(range)
#            return range
#          )()
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
            glados.Settings.VISUALISATION_GREEN_BASE
            glados.Settings.VISUALISATION_LIGHT_GREEN_BASE
            glados.Settings.VISUALISATION_AMBER_BASE
            glados.Settings.VISUALISATION_RED_BASE
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
          coloursRange: ["#9e9e9e","#1f77b4","#aec7e8","#ff7f0e","#ffbb78","#2ca02c","#98df8a","#d62728","#ff9896","#9467bd","#c5b0d5","#8c564b","#c49c94","#e377c2","#f7b6d2","#7f7f7f","#c7c7c7","#bcbd22","#dbdb8d","#17becf","#9edae5","#d76aa4","#e8c7b6","#242071","#c1bdce","#f57c0f","#4787c6","#a83045","#fd4694","#698098","#8b44f7","#ffff5b","#895cd7","#6b9011","#fd9871","#a67943","#49b408","#f61e24","#c040b3","#265e5a","#e9b6c7","#d62f10","#24414","#d8a1e6","#e7d3fb","#21e1ce","#c33707","#f4d50d","#455a15","#a9e3e8","#fcefa3","#676f02","#8d2a4c","#fffa38","#8771f6","#6d9d61","#fde537","#a4beea","#4bdecf","#f6bb4a","#bebfbc","#289b7f","#eaa127","#d4ef30","#4881d","#d9d4cf","#e6db99","#1fa27d","#c4ac56","#f42921","#432aff","#ab9423","#fc939f","#655b59","#8f0ccc","#ffeff3","#85845d","#6fa87e","#fe2ce6","#a30142","#4e0811","#f7537e","#bd3af1","#2ad7d3","#eb86d3","#d3ab0b","#6cc0e","#db035b","#e5de96","#1d6289","#c61db2","#f37850","#40fa91","#ad40ed","#fc328b","#6345a8","#90ec6e","#ffe08d","#839417","#71b15e","#fe6f7c","#a14056","#502fc3","#f7e6bb","#bbb25c","#2d134b","#ec67c5","#d262a7","#90fdd","#dc2d81","#e4dcf6","#1b21ff","#c78b16","#f2c29d","#3ec8d5","#aeea3d","#fbcc67","#612df9","#92c927","#ffcc04","#81a12d","#73b7f6","#feacf7","#9f7c2e","#5255d8","#f874ff","#ba2602","#2f4ddb","#ed43f9","#d1160a","#b537d","#dd533e","#e3d6c0","#18e0ea","#c8f479","#f2080c","#3c95d7","#b0900b","#fb6137","#5f1456","#94a2ef","#ffb25a","#7fabaa","#75bc3c","#fee557","#9db4d3","#547a47","#f8fe48","#b895ed","#318779","#ee1b6b","#cfc53d","#d96e3","#de7489","#e2cbf7","#169f54","#ca59d4","#f148a0","#3a61a2","#b2324e","#faf0fc","#5cf8cc","#9679bb","#ff938f","#7db397","#77be25","#ff189a","#9bea4e","#569d04","#f98292","#b70224","#33c018","#eeee17","#ce7044","#fda03","#df915f","#e1bca2","#145d4b","#cbbb20","#f0845d","#382c41","#b3d0fe","#fa7bb8","#5adb64","#984d83","#ff6fa3","#7bb8fe","#79bda8","#ff46bf","#9a1ca9","#58be04","#fa01db","#b56aaf","#35f7ae","#efbbf8","#cd1727","#121cd1","#e0a9b9","#e0a8c6","#121ad9","#cd1856","#efbb46","#35f5bf","#b56c14","#fa016e","#58bc2a","#9a1e3d","#ff4699","#79bbeb","#7bbab9","#ff6fc5","#984bed","#5add3d","#fa7c20","#b3cf96","#382e2e","#f0850a","#cbb9ee","#145f43","#e1bd91","#df9069","#fd80a","#ce716f","#eeed62","#33be29","#b70385","#f98221","#569b28","#9bebe0","#ff186f","#77bc66","#7db54f","#ff93ac","#967822","#5cfaa3","#faf160","#b230e3","#3a638e","#f14949","#ca589e","#16a14c","#e2cce2","#de738f","#d94ea","#cfc664","#ee1ab2","#318589","#b8974b","#f8fdd2","#54786a","#9db662","#fee528","#75ba7b","#7fad60","#ffb272","#94a153","#5f162c","#fb6196","#b08e9c","#3c97c2","#f208b1","#c8f33f","#18e2e1","#e3d7a6","#dd523f","#b5184","#d1172e","#ed433b","#2f4bea","#ba275d","#f87485","#5253f9","#9f7dba","#feacc4","#73b633","#81a2e1","#ffcc18","#92c789","#612fcd","#fbccc2","#aee8cb","#3ecac0","#f2c33e","#c789d9","#1b23f6","#e4ddd9","#dc2c7f","#90de4","#d263c7","#ec6703","#2d1159","#bbb3b4","#f7e63d","#502de2","#a141df","#fe6f44","#71af99","#8395c9","#ffe09c","#90eacd","#63477a","#fc32e1","#ad3f78","#40fc7a","#f378ed","#c61c72","#1d6480","#e5df74","#db0255","#6ca15","#d3ac27","#eb860c","#2ad5e0","#bd3c46","#f752fb","#4e0630","#a302c8","#fe2caa","#6fa6b7","#85860d","#ffefff","#8f0b29","#655d2a","#fc93f2","#ab92ac","#432ce7","#f429b9","#c4ab12","#1fa473","#e6dc74","#d9d3c6","#48623","#d4f048","#eaa05d","#28998b","#bec10d","#f6bac4","#4bdcec","#a4c06d","#fde4f6","#6d9b98","#8773a3","#fffa3f","#8d28a6","#6770d1","#fceff1","#a9e26e","#455bfb","#f4d5a0","#c335c0","#21e3c3","#e7d4d1","#d8a0d8","#2421b","#d63025","#e9b5f8","#265c66","#c04200","#f61d99","#49b224","#a67ac3","#fd982b","#6b8e46","#895e82","#ffff5d","#8b434f","#698265","#fd46de","#a82ec8","#4789ab","#f57c9e","#c1bc84","#242265","#e8c889","#d76992","#1fa","#d76bb5","#e8c6e4","#241e7c","#c1bf19","#f57b7f","#4785e0","#a831c3","#fd464a","#697ecc","#8b469f","#ffff58","#895b2c","#6b91dc","#fd98b6","#a677c3","#49b5ec","#f61eb0","#c03f65","#26604e","#e9b795","#d62dfb","#2460e","#d8a2f3","#e7d324","#21dfd8","#c3384e","#f4d479","#45582e","#a9e563","#fcef55","#676d34","#8d2bf2","#fffa32","#877049","#6d9f2a","#fde578","#a4bd67","#4be0b2","#f6bbd1","#bebe6a","#289d72","#eaa1f1","#d4ee17","#48a17","#d9d5d9","#e6dabe","#1fa087","#c4ad99","#f42889","#432917","#ab959a","#fc934d","#655989","#8f0e6f","#ffefe8","#8582ae","#6faa45","#fe2d22","#a2ffbc","#4e09f3","#f75400","#bd399d","#2ad9c5","#eb8799","#d3a9ee","#6ce08","#db0460","#e5ddb7","#1d6093","#c61ef3","#f377b4","#40f8a8","#ad4261","#fc3234","#6343d6","#90ee0e","#ffe07d","#839265","#71b323","#fe6fb3","#a13ece","#5031a3","#f7e739","#bbb104","#2d153c","#ec6887","#d26186","#911d6","#dc2e83","#e4dc14","#1b2008","#c78c53","#f2c1fd","#3ec6eb","#aeebae","#fbcc0c","#612c25","#92cac5","#ffcbf0","#819f79","#73b9b9","#fead2a","#9f7aa3","#5257b7","#f87579","#ba24a7","#2f4fcc","#ed44b7","#d114e6","#b5576","#dd543c","#e3d5d9","#18def2","#c8f5b2","#f20767","#3c93ec","#b09179","#fb60d7","#5f1281","#94a48a","#ffb241","#7fa9f3","#75bdfd","#fee586","#9db345","#547c24","#f8febd","#b8948e","#318969","#ee1c25","#cfc415","#d98dc","#de7584","#e2cb0d","#169d5d","#ca5b0a","#f147f7","#3a5fb5","#b233b9","#faf097","#5cf6f5","#967b54","#ff9372","#7db1de","#77bfe4","#ff18c4","#9be8bd","#569ee0","#f98303","#b700c2","#33c207","#eeeecd","#ce6f19","#fdbfc","#df9255","#e1bbb4","#145b53","#cbbc52","#f083af","#382a53","#b3d266","#fa7b4f","#5ad98c","#984f1a","#ff6f82","#7bb744","#79bf65","#ff46e5","#9a1b15","#58bfdf","#fa0248","#b5694a","#35f99c","#efbca9","#cd15f9","#121eca","#e0aaab","#e0a7d4","#1218e1","#cd1985","#efba95","#35f3d1","#b56d78","#fa0101","#58ba50","#9a1fd1","#ff4673","#79ba2e","#7bbc74","#ff6fe7","#984a56","#5adf16","#fa7c89","#b3ce2e","#38301c","#f085b7","#cbb8bb","#14613b","#e1be7f","#df8f72","#fd611","#ce729a","#eeecac","#33bc39","#b704e7","#f981b0","#56994c","#9bed71","#ff1845","#77baa7","#7db708","#ff93c9","#967689","#5cfc7a","#faf1c4","#b22f78","#3a657b","#f149f2","#ca5768","#16a344","#e2cdcc","#de7295","#d92f1","#cfc78b","#ee19f8","#318398","#b898aa","#f8fd5d","#54768c","#9db7f0","#fee4f9","#75b8ba","#7faf17","#ffb28b","#949fb7","#5f1802","#fb61f6","#b08d2e","#3c99ae","#f20955","#c8f206","#18e4d8","#e3d88d","#dd5141","#b4f8a","#d11852","#ed427d","#2f49f9","#ba28b8","#f8740b","#52521a","#9f7f45","#feac90","#73b470","#81a495","#ffcc2c","#92c5ea","#6131a0","#fbcd1e","#aee75a","#3eccaa","#f2c3de","#c7889c","#1b25ed","#e4debb","#dc2b7d","#90bea","#d264e7","#ec6641","#2d0f67","#bbb50b","#f7e5be","#502c02","#a14368","#fe6f0c","#71add3","#83977b","#ffe0ac","#90e92c","#63494c","#fc3338","#ad3e04","#40fe63","#f37989","#c61b32","#1d6676","#e5e053","#db014f","#6c81b","#d3ad43","#eb8546","#2ad3ed","#bd3d9b","#f75278","#4e044e","#a3044e","#fe2c6d","#6fa4f0","#8587bc","#fff00a","#8f0985","#655efa","#fc9444","#ab9134","#432ecf","#f42a51","#c4a9ce","#1fa669","#e6dd4e","#d9d2bc","#4842a","#d4f161","#ea9f92","#289798","#bec25e","#f6ba3d","#4bdb09","#a4c1f0","#fde4b6","#6d99cf","#877550","#fffa46","#8d2700","#6772a0","#fcf03f","#a9e0f4","#455de2","#f4d634","#c33479","#21e5b8","#e7d5a8","#d89fcb","#24021","#d6313a","#e9b52a","#265a72","#c0434e","#f61d0e","#49b03f","#a67c43","#fd97e6","#6b8c7b","#89602d","#ffff5f","#8b41a6","#698432","#fd4727","#a82d4b","#478b91","#f57d2e","#c1bb39","#24245a","#e8c95b","#d76881","#3f3","#d76cc6","#e8c611","#241c87","#c1c063","#f57af0","#4783fb","#a83340","#fd4601","#697cff","#8b4848","#ffff56","#895982","#6b93a7","#fd98fb","#a67642","#49b7d0","#f61f3b","#c03e17","#266242","#e9b863","#d62ce5","#24808","#d8a401","#e7d24e","#21dde3","#c33995","#f4d3e5","#455647","#a9e6dd","#fcef07","#676b65","#8d2d98","#fffa2b","#876e9c","#6da0f3","#fde5b8","#a4bbe3","#4be295","#f6bc58","#bebd19","#289f65","#eaa2bc","#d4ecfe","#48c10","#d9d6e3","#e6d9e4","#1f9e91","#c4aedd","#f427f1","#43272f","#ab9712","#fc92fa","#6557b9","#8f1013","#ffefdd","#8580fe","#6fac0c","#fe2d5e","#a2fe36","#4e0bd5","#f75483","#bd3848","#2adbb8","#eb885f","#d3a8d2","#6d002","#db0566","#e5dcd9","#1d5e9d","#c62033","#f37718","#40f6bf","#ad43d5","#fc31dd","#634204","#90efaf","#ffe06d","#8390b3","#71b4e8","#fe6feb","#a13d45","#503383","#f7e7b7","#bbafac","#2d172e","#ec6949","#d26066","#913d0","#dc2f85","#e4db31","#1b1e11","#c78d8f","#f2c15c","#3ec501","#aeed1f","#fbcbb1","#612a51","#92cc64","#ffcbdc","#819dc5","#73bb7c","#fead5e","#9f7917","#525996","#f875f3","#ba234c","#2f51bd","#ed4575","#d113c3","#b576f","#dd553a","#e3d4f2","#18dcfb","#c8f6eb","#f206c2","#3c9200","#b092e7","#fb6077","#5f10ab","#94a626","#ffb229","#7fa83d","#75bfbe","#fee5b4","#9db1b6","#547e02","#f8ff33","#b89330","#318b59","#ee1cdf","#cfc2ee","#d9ad5","#de767e","#e2ca22","#169b65","#ca5c3f","#f1474e","#3a5dc9","#b23524","#faf033","#5cf51e","#967ced","#ff9355","#7db026","#77c1a3","#ff18ee","#9be72c","#56a0bc","#f98374","#b6ff60","#33c3f7","#eeef82","#ce6dee","#fddf4","#df934c","#e1bac5","#14595b","#cbbd84","#f08302","#382866","#b3d3ce","#fa7ae7","#5ad7b3","#9850b0","#ff6f60","#7bb589","#79c121","#ff470b","#9a1982","#58c1b9","#fa02b5","#b567e5","#35fb8a","#efbd5b","#cd14ca","#1220c2","#e0ab9d","#e0a6e1","#1216e8","#cd1ab3","#efb9e4","#35f1e3","#b56edd","#fa0095","#58b875","#9a2165","#ff464d","#79b871","#7bbe2f","#ff7008","#9848c0","#5ae0ef","#fa7cf1","#b3ccc6","#383209","#f08664","#cbb789","#146333","#e1bf6e","#df8e7c","#fd419","#ce73c5","#eeebf6","#33ba4a","#b70648","#f9813e","#569770","#9bef02","#ff181a","#77b8e8","#7db8c1","#ff93e6","#9674f0","#5cfe52","#faf228","#b22e0d","#3a6767","#f14a9b","#ca5632","#16a53c","#e2ceb7","#de719a","#d90f8","#cfc8b3","#ee193e","#3181a8","#b89a08","#f8fce7","#5474af","#9db97e","#fee4ca","#75b6f8","#7fb0cd","#ffb2a4","#949e1b","#5f19d7","#fb6256","#b08bc0","#3c9b99","#f209fa","#c8f0cd","#18e6d0","#e3d973","#dd5043","#b4d91","#d11976","#ed41c0","#2f4808","#ba2a14","#f87391","#52503c","#9f80d1","#feac5d","#73b2ac","#81a64a","#ffcc40","#92c44c","#613374","#fbcd79","#aee5e9","#3ece94","#f2c47f","#c7875f","#1b27e4","#e4df9e","#dc2a7b","#909f1","#d26607","#ec657f","#2d0d75"]

#  (->
#
#            randomColours = []
#            numColours = 1001 - 21
#            seed = 1
#            for i in [1..numColours]
#              randomColours.push ("#" + (Math.round(Math.abs(Math.sin(seed++)) * 0xFFFFFF)).toString(16))
#
#            range = [glados.Settings.VISUALISATION_GREY_BASE].concat(d3.scale.category20().range()).concat(randomColours)
#
#            console.log 'AAA range: ', JSON.stringify(range)
#            return range
#          )()
          colourScaleType: glados.Visualisation.CATEGORICAL
    ActivityAggregation:
      Properties:
        PCHEMBL_VALUE_AVG:
          propName: 'pchembl_value_avg'
          label: 'PChEMBL Value Avg'
          type: Number
          coloursRange: [glados.Settings.VISUALISATION_LIGHT_GREEN_MIN, glados.Settings.VISUALISATION_LIGHT_GREEN_MAX]
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
          coloursRange: [glados.Settings.VISUALISATION_LIGHT_GREEN_MIN, glados.Settings.VISUALISATION_LIGHT_GREEN_MAX]
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

/************************************* Chargement de la base **********************************/

LIBNAME Base 'P:\Scoring';

DATA DonneesFinales;
SET Base.Donnees1 Base.Donnees2 Base.Donnees3 Base.Donnees4 Base.Donnees5;
RUN;

/********************************* Correction doublons  **************************************/
proc sort data = DonneesFinales out= Donnees_Doublons nodupkey;
	BY NUMTECPRS DATDELHIS ;
run;


/******************************* Recodage des variables qualitatives *************************/

DATA DonneesFinales;
	SET DonneesFinales ;
	CODACVPRO = substr(compress(CODACVPRO),1,1);
RUN;


DATA donneesfinales;
	SET donneesfinales;
	IF CODACVECO = '0000Z' THEN CODACVECO = '0';
	ELSE CODACVECO = '1';
RUN;

proc freq data = DonneesFinales ;
 tables CODACVECO;
run; /* 96.02% des individus présentent la modalité 0*/

/********************************* Traitement des valeurs manquantes ***************************/
/************************************************************************************************/

/*TOP_RR_t: 64% de valeurs manquantes :  variable à retirer*/

/* CODSITFAM RISQUE_SCORE_PAR top_GF*/
proc freq data = DonneesFinales ;
 tables AGE;
run; /*Fréquence manquante = 1627*/
proc freq data = DonneesFinales ;
 tables AGEPRS;
run; /*Fréquence manquante = 620 ce qui représente 0.072% des valeurs observées de la variable */
/* On observe également des personnes avec des ages compris entre 0 et 17 ans, ce qui est inferieur à l'âge minimal pour effectuer librement
les opérations d'un compte */

/*On croise la variable ageprs avec la variable d'interêt pour rechercher le mécanisme de données manquantes */
data MISS_AGEPRS ;
    set DonneesFinales;
    where AGEPRS = .;
run;
proc freq data = MISS_AGEPRS ;
 	tables AGEPRS;
run;
proc freq data = MISS_AGEPRS ;
 	tables top_degrad_dd_3;
run; /*100% des manquants de la variable AGEPRS ne sont pas tombés en défaut (top_degrad_dd_3=0)  */
proc freq data = MISS_AGEPRS ;
 	tables CODACVPRO;
run; /*Toutes les données manquantes pour AGEPRS sont également manquantes pour la CSP  */
proc freq data = DonneesFinales ;
 	tables CODACVPRO;
run; /*Fréquence manquante = 620*/ 


/***** CODSITFAM ***********/

proc freq data = DonneesFinales ;
 tables CODSITFAM;
run; /*Fréquence manquante = 617 ce qui représente 0.072% des valeurs observées de la variable */
data MISS_CODSITFAM ;
    set DonneesFinales;
    where CODSITFAM = .;
run;
proc freq data = MISS_CODSITFAM ;
 	tables CODSITFAM;
run;
proc freq data = MISS_CODSITFAM ;
 	tables top_degrad_dd_3;
run; /*100% des manquants de la variable AGEPRS ne sont pas tombés en défaut (top_degrad_dd_3 =0)  */
proc freq data = MISS_CODSITFAM ;
 	tables CODACVPRO;
run; /*Toutes les données manquantes pour CODSITFAM sont également manquantes pour la CSP  */


/**** RISQUE_SCORE_PAR *******/

proc freq data = DonneesFinales ;
 tables RISQUE_SCORE_PAR;
run; /*Fréquence manquante = 620 ce qui représente 0.072% des valeurs observées de la variable */
data MISS_RISQUE_SCORE_PAR ;
    set DonneesFinales;
    WHERE RISQUE_SCORE_PAR = .;
run;
proc freq data = MISS_RISQUE_SCORE_PAR ;
 	tables RISQUE_SCORE_PAR ;
run;
proc freq data = MISS_RISQUE_SCORE_PAR ;
 	tables top_degrad_dd_3;
run; /*100% des manquants de la variable AGEPRS ne sont pas tombés en défaut (top_degrad_dd_3 =0)  */
PROC FREQ DATA = MISS_RISQUE_SCORE_PAR ;
 	TABLES CODACVPRO;
RUN; /*Toutes les données manquantes pour CODSITFAM sont également manquantes pour la CSP  */

%let var_quanti = AGEPRS ANCIENNETE CRTAD_AG_NBECR_A CRTAD_AG_NBJDE_BA CRTAD_AG_NBJDE_BC CRTAD_AG_SOLDE_T CRTAD_AG_SOLDE_T1 CRTAD_AG_SOLDE_T2
CRTAD_AG_SOLDE_T3 CRTAD_AG_SOLDE_T4 CRTAD_IND_0015 CRTAD_IND_0038 CRTAR_IND_0036 DIFFECR_PAR_TR ENCOURS_PAR IREVENU_M1 IREVENU_M2 MINSOLDE_PAR
MNTECSCRDIMM MNTENC_PAR MNTTOTCRDCSM MNTTOTMVTAFF MNTTOTMVTAFFGLISS_M12 NBECR_PAR NBJDEB3_ANN1_PAR_TR NBJDEPDP NBJDEPLS SLDFINMMSCPT epargne_res
montant_epargne ;

/*NDB_SURV_FINAL : defaut balois */

%let var_quali =  CODACVPRO CODSITFAM top_GF CODACVECO TYPE_FDC TOPCPTLITIG  ; /*  RISQUE_SCORE_PAR  TOPCPTLITIG?   TOPDD*/ 
 
DATA  DonneesFinales;
	set DonneesFinales;
	if AGEPRS =. then Q1 = 1;
	if ANCIENNETE =. then Q2 = 1;
	if CRTAD_AG_NBECR_A =. then Q3 = 1;  
	if CRTAD_AG_NBJDE_BA =. then Q4 = 1;
	if CRTAD_AG_NBJDE_BC =. then Q5 = 1;
	if CRTAD_AG_SOLDE_T =. then Q6 = 1;
	if CRTAD_AG_SOLDE_T1 =. then Q7 = 1;
	if CRTAD_AG_SOLDE_T2 =. then Q8 = 1;  
	if CRTAD_AG_SOLDE_T3 =. then Q9 = 1;
	if CRTAD_AG_SOLDE_T4 =. then Q10 = 1;
	if CRTAD_IND_0015 =. then Q11 = 1;
	if CRTAD_IND_0038 =. then Q12 = 1;
	if CRTAR_IND_0036 =. then Q13 = 1;  
	if DIFFECR_PAR_TR =. then Q14 = 1;
	if ENCOURS_PAR =. then Q15 = 1;
	if IREVENU_M1 =. then Q16 = 1;
	if IREVENU_M2 =. then Q17 = 1;
	if MINSOLDE_PAR =. then Q18 = 1;  
	if MNTECSCRDIMM =. then Q19 = 1;
	if MNTENC_PAR =. then Q20 = 1;
	if MNTTOTCRDCSM =. then Q21 = 1;
	if MNTTOTMVTAFF =. then Q22 = 1;
	if MNTTOTMVTAFFGLISS_M12 =. then Q23 = 1;  
	if NBECR_PAR =. then Q24 = 1;
	if NBJDEB3_ANN1_PAR_TR =. then Q25 = 1;
	if NBJDEPDP =. then Q26 = 1;
	if NBJDEPLS =. then Q27 = 1;
	if SLDFINMMSCPT =. then Q28 = 1;  
	if epargne_res =. then Q29 = 1;
	if montant_epargne =. then Q30 = 1;
	if CODACVPRO =. then Q31 = 1;
	if CODSITFAM =. then Q32 = 1;
	if RISQUE_SCORE_PAR =. then Q33 = 1;  
	if top_GF =. then Q34 = 1;
	if CODACVECO =. then Q35 = 1;
	if TYPE_FDC =. then Q36 = 1;
	if TOPCPTLITIG =. then Q37 = 1;
	if TOP_RR_t =. then Q38 = 1;  
	if datdelhis =. then Q39 = 1;

	miss_prop = 100*sum(of Q:)/39;
	drop Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39;
run;

/*n=894648*/

DATA DonneesFinales ;
    SET DonneesFinales;
    IF miss_prop >70 THEN DELETE;
RUN;

/*n=894035 --> supression de 613 individus*/
/*Imputation des variables quantitatives par la moyenne des non manquants*/

PROC STDIZE DATA=DonneesFinales OUT=DonneesFinales METHOD=MEAN REPONLY ;
  VAR &var_quanti ;
RUN ;


/*Imputation des variables qualitatives par le mode*/

/*CODSITFAM, mode=1*/
proc freq data = DonneesFinales ;
 tables CODSITFAM;
run;   
DATA DonneesFinales ;
    SET DonneesFinales;
    IF CODSITFAM =. THEN CODSITFAM='1';
RUN;


/*CODACVPRO, mode=5*/
proc freq data = DonneesFinales ;
 tables CODACVPRO;
run;   
DATA DonneesFinales ;
    SET DonneesFinales;
    IF CODACVPRO =. THEN CODACVPRO='5';
RUN;


/*TYPE_FDC, mode=0*/
proc freq data = DonneesFinales ;
 tables TYPE_FDC;
run;   
DATA DonneesFinales ;
    SET DonneesFinales;
    IF TYPE_FDC =. THEN TYPE_FDC='0';
RUN;


/*CODACVECO, mode=0*/
proc freq data = DonneesFinales ;
 tables CODACVECO;
run;   
DATA DonneesFinales ;
    SET DonneesFinales;
    IF CODACVECO =. THEN CODACVECO='0';
RUN;

/*TOPCPTLITIG, mode=0*/
proc freq data = DonneesFinales ;
 tables TOPCPTLITIG;
run;   
DATA DonneesFinales ;
    SET DonneesFinales;
    IF TOPCPTLITIG =. THEN top_GF='0';
RUN;
  

/************************************* Anomalies *********************************************/
data DonneesFinales;
set DonneesFinales  ;
	If AGEPRS<18 then AGEPRS_2 = "<= 18 ans";
	ELSE If AGEPRS<35 then AGEPRS_2 = "]18 - 35 ans]";
	ELSE If AGEPRS<50 then AGEPRS_2 = "]35 - 50 ans]";
	ELSE If AGEPRS<65 then AGEPRS_2 = "]50 - 65 ans]";
	ELSE If AGEPRS>65 then AGEPRS_2 = "> 60 ans";
run;

proc freq data = DonneesFinales ;
	tables AGEPRS_2*CODACVPRO;
run;


/*********************************** Création de nouvelles variables *****************************************************/

DATA DonneesFinales;
	SET DonneesFinales  ;
	IF (TOPLS>0 or TOPCPTLITIG>0 ) THEN LITIGE=1  ;
	ELSE LITIGE=0 ; 
	RATIO_ECR = NBECR_PAR/CRTAD_AG_NBECR_A;
	IF abs(SLDFINMMSCPT) > epargne_res THEN Top_PG= 0;
	ELSE Top_PG = 1;
RUN;


/*************************************************** Echantillonnage  ******************************************************/

PROC SORT DATA = DonneesFinales; 
	BY top_degrad_dd_3;
RUN;
PROC SURVEYSELECT DATA = DonneesFinales
	METHOD = SRS OUT = echantillon OUTALL SAMPRATE = 0.8 SEED = 123;
	STRATA top_degrad_dd_3;
RUN;
DATA train;
	SET echantillon;
	IF Selected=1;
RUN;


/************************* Liaison entre les variables qualitatives et la variable d'interêt *******************/

/******************************************** V de Cramer ******************************************************/

%let var_quali =  CODACVPRO CODSITFAM CODACVECO TYPE_FDC TOPCPTLITIG LITIGE CODITDAGE_PAR ; /*top_GF n'a qu'une seule modalité*/

ODS OUTPUT CHISQ = test_chi_deux2;
PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*(CODACVPRO CODSITFAM CODACVECO TYPE_FDC TOPCPTLITIG LITIGE CODITDAGE_PAR)/chisq;   /*RISQUE_SCORE_PAR*/ 
RUN;

Data test_chi_deux2;
	set test_chi_deux2 ;
	where Statistic = "V de Cramer" ;
	abs_V_Cramer = ABS(Value) ;
	keep Variable Table abs_V_Cramer ;
run ;


/***************  correlation entre variables quantitatives  *******************/

PROC CORR DATA = train PEARSON SPEARMAN OUTP = pearson OUTS = spearman NOPRINT;
VAR &var_quanti;
RUN;

DATA pearson(DROP = _TYPE_ RENAME = (_NAME_ = variable1));
SET pearson; WHERE _TYPE_ = 'CORR';
RUN;

PROC TRANSPOSE DATA = pearson NAME=variable2
PREFIX = correlation OUT = pearson;
VAR &var_quanti;
BY variable1 NOTSORTED;
RUN;


PROC PRINT DATA = pearson;
RUN;

DATA pearson;
	SET pearson;
	WHERE variable1<variable2;
	abscorrelation = ABS(correlation1);
RUN;

PROC SORT DATA = pearson;
BY DESCENDING abscorrelation;
RUN;
PROC PRINT DATA = pearson;
RUN;

/********************************************* Regroupement des variables qualitatives **********************************************/


/*CODITDAGE_PAR*/
PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*CODITDAGE_PAR ; 
RUN;

DATA echantillon;
	SET echantillon  ;
	IF CODITDAGE_PAR ='0'  THEN CODITDAGE_PAR2 = '0';
	ELSE  CODITDAGE_PAR2 = '1';  /*Autres*/
RUN;

PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*CODITDAGE_PAR2 ; 
RUN;  /*plus risquée =1*/

/*CODACVPRO*/

PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*CODACVPRO ; 
RUN;

DATA echantillon;
	SET echantillon;
	IF CODACVPRO ='1' or CODACVPRO ='6' or CODACVPRO ='8' THEN CODACVPRO2 = '1';
	ELSE IF CODACVPRO ='2' or CODACVPRO ='4' or CODACVPRO ='9' THEN CODACVPRO2 = '2';
	ELSE CODACVPRO2 = CODACVPRO;
RUN;

PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*CODACVPRO2 ; 
RUN;  /*plus risquée =1*/

/*CODSITFAM*/

PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*CODSITFAM ; 
RUN;

DATA echantillon;
	SET echantillon;
	IF CODSITFAM ='0' or CODSITFAM ='3' or CODSITFAM ='4' or CODSITFAM ='5' THEN CODSITFAM2 = '3';
	ELSE CODSITFAM2 = CODSITFAM;
RUN;

PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*CODSITFAM2 ; 
RUN; /*plus risquée =1*/


/*TYPE_FDC*/

proc freq data = DonneesFinales ;
 tables top_degrad_dd_3*type_fdc;
run; 

DATA echantillon;
	SET echantillon;
	IF type_fdc ='0' THEN type_fdc2 = '0';
	IF type_fdc ='1' or type_fdc ='11' or type_fdc ='13' THEN type_fdc2 = '1';
	IF type_fdc ='2' or type_fdc ='20' or type_fdc ='21' or type_fdc = '23' or type_fdc = '24' or type_fdc ='29' THEN type_fdc2 = '2';
	IF type_fdc ='3' or type_fdc ='30' or type_fdc ='31' THEN type_fdc2 = '3';
	IF type_fdc ='5' or type_fdc ='50' or type_fdc ='51' or type_fdc ='52' or type_fdc ='95' THEN type_fdc2 = '5';
RUN;

DATA echantillon;
	SET echantillon;
	IF type_fdc2 ='3' or type_fdc2 ='5' THEN type_fdc2 = '3';
RUN;
PROC FREQ DATA = echantillon;
	TABLES top_degrad_dd_3*type_fdc2 ; 
RUN;


/******************** Regroupement des variables quantitatives ********************************************/

/************************ Decoupage des variables en quantiles ********************************************/

PROC RANK DATA = Base GROUPE = 20 OUT = quantiles;
VAR AGEPRS
	MONTANT_EPARGNE
	CRTAD_AG_NBJDE_BA
	CRTAD_AG_SOLDE_T2
	MNTTOTMVTAFF
	IREVENU_M2
	NBJDEPDP
	SLDFINMMSCPT
	MINSOLDE_PAR
	MNTTOTMVTAFFGLISS_M12
	CRTAR_IND_0036 
	CRTAD_AG_NBECR_A
	MNTENC_PAR
	CRTAD_AG_NBJDE_BC
	ANCIENNETE;

	RANKS dAGEPRS
	dMONTANT_EPARGNE
	dCRTAD_AG_NBJDE_BA
	dCRTAD_AG_SOLDE_T2
	dMNTTOTMVTAFF
	dIREVENU_M2
	dNBJDEPDP
	dSLDFINMMSCPT
	dMINSOLDE_PAR
	dMNTTOTMVTAFFGLISS_M12
	dCRTAR_IND_0036 
	dCRTAD_AG_NBECR_A
	dMNTENC_PAR
	dCRTAD_AG_NBJDE_BC
	dANCIENNETE;
	
RUN;


/*AGEPRS*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dAGEPRS;
VAR AGEPRS;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * dAGEPRS;
RUN;

PROC FORMAT;
    VALUE AGEformat
	  LOW   -< 6 = "< 30 ans"  /*modalité la plus risquée*/
	  6 -< 9 = "[30 - 37 ans["
	  9 -< 13 = "[37 - 47 ans["
	  13 - HIGH = "[>47 ans[";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dAGEPRS AGEformat.;
RUN;
/*vérification de l'évolution temporelle*/
/*ods ouput CrossTabFreqs = TABLE1;*/
PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * DATDELHIS * dAGEPRS;
RUN;
/*
ods html file = 'P:\Scoring\excel\TAB1.xlsx';
proc print data=TABLE1;
run;
ods html close;
*/

/*IREVENU_M2*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dIREVENU_M2;
VAR IREVENU_M2;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * dIREVENU_M2;
RUN;

PROC FORMAT;
    VALUE REVENUformat
	  LOW   -< 3 = "1" /*modalité la plus risquée*/
	  3 -< 10 = "2"  
	  10 -< 16 = "3"
	  16 - HIGH   = "4";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dIREVENU_M2 REVENUformat.;
RUN;


/*MONTANT_EPARGNE*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dMONTANT_EPARGNE;
VAR MONTANT_EPARGNE;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * dMONTANT_EPARGNE;
RUN;

PROC FORMAT;
    VALUE MONTANT_EPARGNEformat
	  LOW   -< 8 = "1" 
	  8 -< 15 = "2"  
	  15 -< 19 = "3"
	  19 - HIGH   = "4";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dMONTANT_EPARGNE MONTANT_EPARGNEformat.;
RUN;



/*MNTTOTMVTAFF*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dMNTTOTMVTAFF;
VAR MNTTOTMVTAFF;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * dMNTTOTMVTAFF;
RUN;

PROC FORMAT;
    VALUE MNTTOTMVTAFFformat
	  LOW   -< 5 = "1"  /*modalité la plus risquée*/
	  5 -< 11 = "2"  
	  11 -< 17 = "3"
	  17 - HIGH   = "4";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dMNTTOTMVTAFF MNTTOTMVTAFFformat.;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * DATDELHIS * dMNTTOTMVTAFF;
RUN;

/*CRTAD_AG_NBJDE_BA*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dCRTAD_AG_NBJDE_BA;
VAR CRTAD_AG_NBJDE_BA;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * dCRTAD_AG_NBJDE_BA;
RUN;

PROC FORMAT;
    VALUE CRTAD_AG_NBJDE_BAformat
	  LOW   -< 4 = "1" 
	  4 -< 12 = "2"  /*modalité la plus risquée*/
	  12 -< 17 = "3"
	  17 - HIGH = "4";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dCRTAD_AG_NBJDE_BA CRTAD_AG_NBJDE_BAformat.;
RUN;


/*NBJDEPDP*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dNBJDEPDP;
VAR NBJDEPDP;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3 * dNBJDEPDP;
RUN;
PROC FORMAT;
    VALUE NBJDEPDPformat
	  LOW - 11 = "1" /*modalité la plus risquée*/
	  11 <- 16 = "2"  
	  16 -< 19 = "3"
	  19 - HIGH = "4";
RUN;
/*autre regroupement*/
PROC FORMAT;
    VALUE NBJDEPDPformat
	  LOW - 4 = "1" /*modalité la plus risquée*/
	  4 <- 12 = "2"
	  12 <- 17 = "3"  
	  17 -< 19 = "4"
	  19 - HIGH = "5";
RUN;


DATA quantiles;
    SET quantiles;
    FORMAT dNBJDEPDP NBJDEPDPformat.;
RUN;




/*CRTAD_AG_NBECR_A*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dCRTAD_AG_NBECR_A;
VAR CRTAD_AG_NBECR_A;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3*dCRTAD_AG_NBECR_A;
RUN;
PROC FORMAT;
    VALUE CRTAD_AG_NBECR_Aformat
	  LOW - 3 = "1" 
	  3 <- 9 = "2"  /*modalité la plus risquée*/
	  9 -< 13 = "3"
	  13 - HIGH = "4";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dCRTAD_AG_NBECR_A CRTAD_AG_NBECR_Aformat.;
RUN;

/***************************************************************************/
/*SLDFINMMSCPT*/
PROC MEANS DATA = quantiles MIN MAX;
CLASS dSLDFINMMSCPT;
VAR SLDFINMMSCPT;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3*dSLDFINMMSCPT;
RUN;
PROC FORMAT;
    VALUE SLDFINMMSCPTformat
	  LOW -< 6 = "1" /*modalité la plus risquée*/ 
	  6 -< 12 = "2"
	  12 -< 15 = "3"
	  15 -< 18 = "4"
	  18 - HIGH = "5";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dSLDFINMMSCPT SLDFINMMSCPTformat.;
RUN;


/*MINSOLDE_PAR*/
title "Histogramme de MINSOLDE_PAR par classe de risque";
proc sgplot data=quantiles;
   histogram dMINSOLDE_PAR / group=top_degrad_dd_3 transparency=0.5 scale=count;
   /*density dMINSOLDE_PAR / type=normal group=top_degrad_dd_3;
   keylegend / location=inside position=topright across=1;*/
run;
title;

PROC MEANS DATA = quantiles MIN MAX;
CLASS dMINSOLDE_PAR;
VAR MINSOLDE_PAR;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3*dMINSOLDE_PAR;
RUN;
PROC FORMAT;
    VALUE MINSOLDE_PARformat   
	  LOW -< 9 = "1" /*modalité la plus risquée*/ 
	  9 -< 13 = "2"
	  13 -< 14 = "3"
	  14 - HIGH = "4";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dMINSOLDE_PAR MINSOLDE_PARformat.;
RUN;


/*MNTENC_PAR*/
title "Histogramme de MNTENC_PAR par classe de risque";
proc sgplot data=quantiles;
   histogram dMNTENC_PAR / group=top_degrad_dd_3 transparency=0.5 scale=count;
run;
title;

PROC MEANS DATA = quantiles MIN MAX;
CLASS dMNTENC_PAR;
VAR MNTENC_PAR;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3*dMNTENC_PAR;
RUN;
PROC FORMAT;
    VALUE MNTENC_PARformat   
	  LOW -< 10 = "1" /*modalité la plus risquée*/ 
	  10 -< 17 = "2"
	  17 - HIGH = "3";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dMNTENC_PAR MNTENC_PARformat.;
RUN;
 /********************************************************************************/

/*CRTAR_IND_0036*/
title "Histogramme de CRTAR_IND_0036 par classe de risque";
proc sgplot data=quantiles;
   histogram dCRTAR_IND_0036 / group=top_degrad_dd_3 transparency=0.5 scale=count;
run;
title;

PROC MEANS DATA = quantiles MIN MAX;
CLASS dCRTAR_IND_0036;
VAR CRTAR_IND_0036;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3*dCRTAR_IND_0036;
RUN;
PROC FORMAT;
    VALUE CRTAR_IND_0036format   
	  LOW -< 14 = "1" /*modalité la plus risquée*/ 
	  14 - HIGH = "2";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dCRTAR_IND_0036 CRTAR_IND_0036format.;
RUN;


/*montant_epargne*/
title "Histogramme de montant_epargne par classe de risque";
proc sgplot data=quantiles;
   histogram dmontant_epargne / group=top_degrad_dd_3 transparency=0.5 scale=count;
run;
title;

PROC MEANS DATA = quantiles MIN MAX;
CLASS dmontant_epargne;
VAR montant_epargne;
RUN;

PROC FREQ DATA = quantiles;
	tables top_degrad_dd_3*dmontant_epargne;
RUN;
PROC FORMAT;
    VALUE montant_epargneformat   
	  LOW -< 8 = "1" /*modalité la plus risquée*/ 
	  8 -< 16 = "2"
	  16 - HIGH = "3";
RUN;

DATA quantiles;
    SET quantiles;
    FORMAT dmontant_epargne montant_epargneformat.;
RUN;


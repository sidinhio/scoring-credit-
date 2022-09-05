/*============================================================
==========	Projet de Scoring de crédit				==========
==========	Programme : 1.Data Management			==========
==========				2.Analyses					==========
==========	Par : Sidi TRAORE & Brice TIFA			==========
==========						GDR ENSAI 2020-2021	==========
/*============================================================*/

%let chemin = "P:\ENSAI_3A\Projet_Scoring\Donnes";
	libname donnes &chemin;
run;

data Base;
	set donnes.donneesfinales;
run;

%let variables_quanti = MINSOLDE_PAR CRTAD_AG_SOLDE_T CRTAD_IND_0038 CRTAD_AG_SOLDE_T1 CRTAD_AG_NBJDE_BA
TYPE_FDC CRTAD_AG_SOLDE_T2 CRTAD_AG_SOLDE_T3 CRTAD_AG_SOLDE_T4 CRTAD_AG_NBJDE_BC CRTAD_IND_0015 NBJDEPDP
MONTANT_EPARGNE MNTTOTMVTAFFGLISS_M12 MNTTOTMVTAFF MNTECSCRDIMM MNTTOTCRDCSM EPARGNE_RES 
SLDFINMMSCPT ENCOURS_PAR Age ANCIENNETE NBJDEPLS IREVENU_M2 IREVENU_M2 AGEPRS; /*variables quantitatives de la base*/; /*variables quantitatives de la base*/

%let variables_quali = CODITDAGE_PAR CODACVPRO CODSEXPRS  CODSITFAM CODCNDFRG; /*variables qualitatives de la base*/
/* On enlève CODPAY_NATIONALITE*/


%let  y = top_degrad_dd_3 ; /*variable à modéliser*/


/*************************************************************************/
/****************************LA BASE DE DONNEES***************************/
/*************************************************************************/
proc contents data = Base;
title "contenu table";
run;

/**************************SUB data with variable of interest***********************************************/
 DATA Base_Interest; 
   set Base2;
   keep &y &variables_quanti &variables_quali ;
RUN; 
proc contents data = Base_Interest;
title "contenu table";
run;

/*************************************************************************/
/**************************DATA Quality Assurance***************************/
/*************************************************************************/

/*
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\AUTOLEVEL.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\FISCALYR.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\GETFORMAT.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\GETNOBS.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\GETVARLIST.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\INVALID.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\LINKYR.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\MONTHLY.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\OUTLIER.sas.txt'; 
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\POSTMUN.sas.txt';
%include 'P:\ENSAI_3A\Projet_Scoring\Script\Mocros_Vimo\vimo.sas.txt'; 

%vimo(DS = work.Base_Interest);
*/



/*************************************************************************/
/**************************NETTOYAGE DE LA BASE***************************/
/*************************************************************************/
/*doublons*/
proc sort data= base out= Donnees_Doublons nodupkey;
	by NUMTECPRS DATDELHIS ;
run;

/****TRAITEMENT DES VALEURS MANQUANTES****/
/*Pour les variables quantitatives*/
proc means data = base;
var &variables_quanti;
title "valeurs manquantes variables quantitatives";
run; /* => Des soldes minimums négatifs;   ages < 18 : corriger */

/*Pour les variables qualitatives*/
proc freq data= Base;
table &variables_quali &y;
title "valeurs manquantes variables qualitatives";
run;

/****TRAITEMENT DES VALEURS ABERRANTES****/
proc sql;
select count(NUMTECPRS) into : nobs
from Base;
quit; 


/*data Base;
set Base;
if hatmatrix>3*13/&nobs then delete;
if abs(pearson)>2 then delete;
if AGEPRS<18 or AGEPRS>150 then delete; 
*/


/*************************************************************************/
/*****************************Recodage de variables***********************/
/*************************************************************************/




/*Code Libellé
1 Agriculteurs exploitants
2 Artisans, commerçants et chefs d'entreprise
3 Cadres et professions intellectuelles supérieures
4 Professions Intermédiaires
5 Employés
6 Ouvriers
7 Retraités
8 Autres personnes sans activité professionnelle

*/
data Base;
	set Base ;
	CODACVPRO2 = substr(compress(CODACVPRO),1,1);
run;/* Regrouper les Catégorie SCP par code INSEE*/


data Base;
	set Base ;
	If AGEPRS<18 then AGE_T1 = "<= 18 ans";
	ELSE IF AGEPRS<25  then AGE_T1 = "]18 - 25 ans]";
	ELSE IF AGEPRS<30 then AGE_T1 = "]25 - 30 ans]";
	ELSE IF AGEPRS<40 then AGE_T1= "]30 - 40 ans]";
	ELSE IF AGEPRS<50 then AGE_T1 = "]40 - 50 ans]";
	ELSE IF AGEPRS<60 then AGE_T1 = "]50 - 60 ans]";
	ELSE IF  AGEPRS>60then AGE_T1 = "> 60 ans";
run; /*Recoder l'âge*/



/*************************************************************************/
/*CODSITFAM
1 Marié(e)
2 Pacsé
3 En concubinage ou union libre
4 Veuf (ve)
5 Divorcé(e)
6 Celibataire*/

data Base;
	set Base ;
	If CODSITFAM = 0 then CODSITFAM_REC = 3;
	If CODSITFAM = 1  then CODSITFAM_REC = 1;
	If CODSITFAM = 2 then CODSITFAM_REC  = 2;
	If CODSITFAM = 3 then CODSITFAM_REC = 3;
	If CODSITFAM = 4 then CODSITFAM_REC = 3;
	If CODSITFAM = 5 then CODSITFAM_REC = 3;
run; /*Recoder la situation matrimoniale*/

data Base;
	set Base ;
	CODACVECO2 = substr(compress(CODACVECO),1,1);
run;/* Entreprises par codes APE (Activités principales exercées)*/



data Base;
	set Base ;
	CODACVPRO2 = substr(compress(CODACVPRO),1,1);
run;/* Entreprises par codes APE (Activités principales exercées)*/






%let variables_quali = CODITDAGE_PAR CODACVPRO2 CODACVECO2 AGE_T1 CODSEXPRS  CODSITFAM; /*variables qualitatives de la base*/



/*CREATION DE Nouveaux indicateurs */

DATA Base;
SET Base  ;
IF (TOPLS>0 or TOPCPTLITIG>0 ) THEN LITIGE=1  ;
ELSE LITIGE=0 ;
RATIO_ECR=NBECR_PAR/CRTAD_AG_NBECR_A;
if abs(SLDFINMMSCPT) > epargne_res THEN Top_PG= 0;
else Top_PG = 1;
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




/*************************************************************************/
/*****************************DATA SPLITTING******************************/
/*************************************************************************/

/****CONSTRUCTION D'UN ECHANTILLON APPRENTISSAGE****/

data quantiles;
	set quantiles ;
	If CODSITFAM = 0 then CODSITFAM_REC = 3;
	If CODSITFAM = 1  then CODSITFAM_REC = 1;
	If CODSITFAM = 2 then CODSITFAM_REC  = 2;
	If CODSITFAM = 3 then CODSITFAM_REC = 3;
	If CODSITFAM = 4 then CODSITFAM_REC = 3;
	If CODSITFAM = 5 then CODSITFAM_REC = 3;
run; /*Recoder la situation matrimoniale*/



data quantiles;
	set quantiles ;
	If CODACVPRO2 = "1"  then CODACVPRO_REC = 3;
	If CODACVPRO2 = "2"  then CODACVPRO_REC = 1;
	If CODACVPRO2 = "3" then CODACVPRO_REC  = 1;
	If CODACVPRO2 = "4" then CODACVPRO_REC = 1;
	If CODACVPRO2 = "5" then CODACVPRO_REC = 1;
	If CODACVPRO2 = "6" then CODACVPRO_REC = 1;
	If CODACVPRO2 = "7" then CODACVPRO_REC = 3;
	If CODACVPRO2 = "8" then CODACVPRO_REC = 2;
	If CODACVPRO2 = "9" then CODACVPRO_REC =2;
run; /*Recoder la CSP CODACVPRO2*/



PROC SORT DATA = quantiles;
BY top_degrad_dd_3;
RUN;

proc surveyselect
DATA = quantiles
OUT = echantillon OUTALL
SAMPRATE = 0.8 seed = 12345 ;
STRATA top_degrad_dd_3 ;
title "construction echantillon apprentissage";
run; 



data train;
set echantillon;
if Selected=1;
run;



data test;
set echantillon;
if Selected=0;
run;

proc freq data= train;
table &y;
title " Train Verifications proportions variable y";
run;

proc freq data= test;
table &y;
title "Test Verifications proportions variable y";
run;
/*=> même proportion de y la variable d'intérêt dans le train et le test*/




ods html close;
ods html ;

PROC LOGISTIC DATA = TRAIN;

	class dMNTTOTMVTAFF (param=ref ref='1')
		  dCRTAD_AG_NBJDE_BA (param=ref ref='2')
		  dNBJDEPDP	(param=ref ref='3')
		  dIREVENU_M2(param=ref ref='1')
		  dMINSOLDE_PAR (param=ref ref='4')
		  dCRTAD_AG_NBECR_A (param=ref ref='2')
		  dSLDFINMMSCPT(param=ref ref='1')
		  
		  
		  
		  
		  
		  CODACVPRO_REC(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									
									
									
						
									
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc selection = stepwise;
	output out = table_sortie predicted = PROBA;
RUN;


proc freq data = train;
tables top_degrad_dd_3* dIREVENU_M2;
run;

/**Revision Ref = 0**/
ods html close;
ods html ;

PROC LOGISTIC DATA = TRAIN;

	class dMNTTOTMVTAFF (param=ref ref='4')
		  dCRTAD_AG_NBJDE_BA (param=ref ref='4')
		  dNBJDEPDP	(param=ref ref='5')
		  dIREVENU_M2(param=ref ref='4')
		  dMINSOLDE_PAR (param=ref ref='1')
		  dCRTAD_AG_NBECR_A (param=ref ref='3')
		  dSLDFINMMSCPT(param=ref ref='4')
		  
		  
		  
		  
		  
		  CODACVPRO_REC(param=ref ref='3'); 
	model top_degrad_dd_3(Event='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									
									
									
						
									
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc ;
	output out = table_sortie predicted = PROBA;
RUN;


ods html close;
ods html ;

PROC LOGISTIC DATA = TRAIN;

	class dMNTTOTMVTAFF (param=ref ref='4'); 
	model top_degrad_dd_3(Event='1')= dMNTTOTMVTAFF 
								    /ctable link = logit rsquare outroc = roc ;
	output out = table_sortie predicted = PROBA;
RUN;



/***/

%let variables_modeles =dMNTTOTMVTAFF 
						dCRTAD_AG_NBJDE_BA
						dNBJDEPDP
						dIREVENU_M2
						dMINSOLDE_PAR
						dCRTAD_AG_NBECR_A
						dSLDFINMMSCPT
						dMNTENC_PAR
						dMONTANT_EPARGNE
						dAGEPRS
						dCRTAR_IND_0036;

ods html close;
ods html ;
proc freq data = train;
tables &y * (dMINSOLDE_PAR) ; 
run; 



ods html close;
ods html ;

PROC LOGISTIC DATA = quantiles;

	class dMNTTOTMVTAFF (param=ref ref='1')
		  dCRTAD_AG_NBJDE_BA (param=ref ref='2')
		  dNBJDEPDP	(param=ref ref='3')
		  dIREVENU_M2(param=ref ref='1')
		  dMINSOLDE_PAR (param=ref ref='4')
		  dCRTAD_AG_NBECR_A (param=ref ref='2')
		  dSLDFINMMSCPT(param=ref ref='1')
		  dMNTENC_PAR (param=ref ref='1')
		  dMONTANT_EPARGNE (param=ref ref='1')
		  dAGEPRS(param=ref ref='< 30 ans')
		  dCRTAR_IND_0036(param=ref ref='1'); 
	model top_degrad_dd_3(Event='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036/ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;



ods html close;
ods html ;

PROC LOGISTIC DATA = quantiles;

	class dMNTTOTMVTAFF (param=ref ref='4')
		  dCRTAD_AG_NBJDE_BA (param=ref ref='4')
		  dNBJDEPDP	(param=ref ref='5')
		  
		  
		
		  dSLDFINMMSCPT(param=ref ref='5')
		  dMINSOLDE_PAR (param=ref ref='3')
		  dMONTANT_EPARGNE (param=ref ref='3')
		  
		  CODACVPRO_REC(param=ref ref='3'); 
	model top_degrad_dd_3(Event='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									
									dMINSOLDE_PAR
									
									dSLDFINMMSCPT
									
									dMONTANT_EPARGNE
									
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;



ods html close;
ods html ;
proc freq data = train;
tables top_degrad_dd_3 *  (CODSITFAM CODACVPRO2 AGEPRS)/nocum nocol;
Format CODSITFAM CODSITFAMformat. CODACVPRO2 CODACVPRO2 $CODACVPROformat. AGEPRS AGEformatLogique.;
RUN;


/*Modèle BRICE*/
PROC LOGISTIC DATA = train;
class dMNTTOTMVTAFF (param=ref ref='4')
	dCRTAD_AG_NBJDE_BA (param=ref ref='4')
	dNBJDEPDP (param=ref ref='4')
	dMINSOLDE_PAR (param=ref ref='3')
	dSLDFINMMSCPT(param=ref ref='4')
	dAGEPRS(param=ref ref='[30 - 37 ans[')
	dMONTANT_EPARGNE(param=ref ref='3')
	/* CODSITFAM2(param=ref ref='3')*/
	CODACVPRO2(param=ref ref='7');

model top_degrad_dd_3(ref='0')= dMNTTOTMVTAFF
		dCRTAD_AG_NBJDE_BA
		dNBJDEPDP
		dMINSOLDE_PAR
		dSLDFINMMSCPT
		dAGEPRS
		dMONTANT_EPARGNE
		/*CODSITFAM2*/
		CODACVPRO2/ctable link = logit rsquare outroc = roc;
		output out = table_sortie predicted = PROBA;
RUN;







/********************************111111111111111111111111111µµµµµµµµµµµµµµµµ*/
/**Validation par Bootstrap**/


PROC SORT DATA=quantiles ;
	BY top_degrad_dd_3 ;
RUN ; 


PROC SURVEYSELECT DATA=quantiles METHOD=SRS OUT=train_bootstrap OUTALL SAMPRATE = 0.8 SEED = 123 REP= 10 ;
	STRATA top_degrad_dd_3;
RUN;

proc sort data=train_bootstrap;
	by replicate;
run;


ods html close;
ods html ;

ods output ParameterEstimates(Persist=run)=bootsrap_param;
PROC LOGISTIC DATA=train_bootstrap OUTMODEL=train_model;
class dMNTTOTMVTAFF (param=ref ref='4')
	dCRTAD_AG_NBJDE_BA (param=ref ref='4')
	dNBJDEPDP (param=ref ref='4')
	dMINSOLDE_PAR (param=ref ref='3')
	dSLDFINMMSCPT(param=ref ref='4')
	dAGEPRS(param=ref ref='[30 - 37 ans[')
	dMONTANT_EPARGNE(param=ref ref='3')
	/* CODSITFAM2(param=ref ref='3')*/
	CODACVPRO2(param=ref ref='7');

model top_degrad_dd_3(ref='0')= dMNTTOTMVTAFF
		dCRTAD_AG_NBJDE_BA
		dNBJDEPDP
		dMINSOLDE_PAR
		dSLDFINMMSCPT
		dAGEPRS
		dMONTANT_EPARGNE
		/*CODSITFAM2*/
		CODACVPRO2/ctable link = logit rsquare;
		output out = table_sortie predicted = PROBA;
By REPLICATE ;
RUN;

ods output close;

proc contents data = Bootsrap_param;
run;


proc sort data=Bootsrap_param;
	by Variable ClassVal0;
run;

data Bootsrap_param2;
	set Bootsrap_param;
	by Variable ClassVal0;
	Minimum = min(Estimate);
	Maximum = max(Estimate);
	Moyenne = mean(Estimate);
	/*Il n'y a pas de function std pour sas*/
	
run;



/*********************22222222222222222222222222*******************/


/*ID de sommmers moyen*/
/*Indice de Gini*/
ods trace on;
ods output association=ddesomers parameterestimates=parametreestimer;

PROC LOGISTIC DATA=train_bootstrap OUTMODEL=train_model;
class dMNTTOTMVTAFF (param=ref ref='4')
	dCRTAD_AG_NBJDE_BA (param=ref ref='4')
	dNBJDEPDP (param=ref ref='4')
	dMINSOLDE_PAR (param=ref ref='3')
	dSLDFINMMSCPT(param=ref ref='4')
	dAGEPRS(param=ref ref='[30 - 37 ans[')
	dMONTANT_EPARGNE(param=ref ref='3')
	/* CODSITFAM2(param=ref ref='3')*/
	CODACVPRO2(param=ref ref='7');

model top_degrad_dd_3(ref='0')= dMNTTOTMVTAFF
		dCRTAD_AG_NBJDE_BA
		dNBJDEPDP
		dMINSOLDE_PAR
		dSLDFINMMSCPT
		dAGEPRS
		dMONTANT_EPARGNE
		/*CODSITFAM2*/
		CODACVPRO2/ctable link = logit rsquare;
		output out = table_sortie predicted = PROBA;
By REPLICATE ;
RUN;

/**D de sommers moyen*/

ods trace off;
proc means data=Ddesomers(where=(Label2='D de Somers')) ;
*class Replicate ;
var nValue2;
run ; 


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
SLDFINMMSCPT ENCOURS_PAR Age ANCIENNETE NBJDEPLS IREVENU_M1 IREVENU_M2 AGEPRS; /*variables quantitatives de la base*/; /*variables quantitatives de la base*/

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


/*************************************************************************/
/*****************************DATA SPLITTING******************************/
/*************************************************************************/

/****CONSTRUCTION D'UN ECHANTILLON APPRENTISSAGE****/

PROC SORT DATA = Base;
BY top_degrad_dd_3;
RUN;

proc surveyselect
DATA = Base
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

/*************************************************************************/
/****************************ETUDE EXPLORATOIRE***************************/
/*************************************************************************/

/****STATISTIQUES DESCRIPTIVES****/

 /*Pour les variables quantitatives*/
Proc gchart data= train;
title "statistiques descriptives ";
vbar AGE/ subgroup= &y midpoints=18 to 78 by 10;
run;
quit; 


title "Distrubution de l'âge par dégradation du risque";
proc sgplot data= train (where =(top_degrad_dd_3 >= 1));
   histogram AGE / group=&y transparency=0.5 scale=count;
   density AGE / type=normal group=&y;
   keylegend / location=inside position=topright across=1;
run;
title;

title "Distrubution de l'âge par dégradation du risque";
proc sgplot data= train;
   histogram AGE / group=&y transparency=0.5 scale=count;
   density AGE / type=normal group=&y;
   keylegend / location=inside position=topright across=1;
run;
title;




/*************************************************************************/
/****************************ETUDE DES LIAISONS***************************/
/*************************************************************************/


/****VARIABLES D'intérêt (Y variable d'intérêt) - VARIABLES QUANTITATIVES****/


/* Y variables quanti*/
ODS OUTPUT kruskalWalis = kruskal;

PROC NPAR1WAY WILCOXON data = Base_aggrege CORRECT = no;
Class &y;
VAR &variables_quanti;
title "liaisons variables qualitatives Y - variables quantitatives";
RUN;


DATA kruskal (keep = variable cVlaue1 nValue1); 
SET kruskal; where name1 = '_KW_';
RUN;

PROC SORT DATA = kruskal;
BY DESCENDING _KW_; 
RUN;


/*PROC SORT DATA = kruskal;
BY DESCENDING CODITDAGE_PAR;*/
ods html file = "P:\ENSAI_3A\Projet_Scoring\Output\WilcoxonKruskalWalis_VF3.xls";

PROC PRINT data = kruskal;
RUN;

ods html close;

/*pval<0.05 variable discriminante: Statistique de krukal walis*/


/****VARIABLES D'intérêt (Y variable d'intérêt) - VARIABLES Qualitatives****/
ODS output Chisq = CRAMER;

PROC freq data = train;
tables &y * (&variables_quali)/chisq;
title "Liasions Y variables qualitatives";
run;


/*DATA CRAMER (keep = table value prob);
set CRAMER;
Where statistic = "V de Cramer";
RUN;
*/

PROC SORT DATA = work.CRAMER;
BY DESCENDING value; 
RUN;


ods html file = "P:\ENSAI_3A\Projet_Scoring\Output\Liaison_Y_Qualitatives_VF.xls";
PROC PRINT data = CRAMER;
RUN;

ods html close;



/****Autocorrélation variables quantitatives ****/
ODS output Chisq = Autocorelation_CRAMER;
PROC freq data = train;
tables (&variables_quali) * (&variables_quali)/chisq;
title "Autocorélation variables qualitatives VS variables qualitatives";
run;


PROC SORT DATA = work.Autocorelation_CRAMER;
BY DESCENDING value; 
RUN;

ods html file = "P:\ENSAI_3A\Projet_Scoring\Output\Autocorrelations_Quali_CRAMER2_vf.xlsx";
PROC PRINT data = Autocorelation_CRAMER;
RUN;
ods html close;


/****VARIABLES QUANTITATIVES - VARIABLES QUANTITATIVES****/

 %corrmatx(libnamex=work,
 dsname=Base,
 vars= MINSOLDE_PAR CRTAD_AG_SOLDE_T CRTAD_IND_0038 CRTAD_AG_SOLDE_T1 CRTAD_AG_NBJDE_BA
TYPE_FDC CRTAD_AG_SOLDE_T2 CRTAD_AG_SOLDE_T3 CRTAD_AG_SOLDE_T4 CRTAD_AG_NBJDE_BC CRTAD_IND_0015 NBJDEPDP
MONTANT_EPARGNE MNTTOTMVTAFFGLISS_M12 MNTTOTMVTAFF MNTECSCRDIMM MNTTOTCRDCSM EPARGNE_RES 
SLDFINMMSCPT ENCOURS_PAR Age ANCIENNETE NBJDEPLS IREVENU_M1 IREVENU_M2 AGEPRS,
 savpath=P:\ENSAI_3A\Projet_Scoring\Output,
 savfile=Correlations_matrix_Spearman_VF,
 hight=.9, medt=.8, lowt=.7)

/*************************************************************************/
/***********************TRANSFORMATION DES VARIABLES**********************/
/*************************************************************************/
/****DISCRETISATION DES VARIABLES QUANTITATIVES****/


PROC MEANS DATA = quantiles MIN MAX;
 
/*Decoupage des variables*/
PROC RANK DATA = train GROUPE = 20 OUT = quantiles;
VAR IREVENU_M1
AGE
MONTANT_EPARGNE
CRTAD_AG_NBJDE_BA
CRTAD_AG_SOLDE_T1/*Before*/
MNTTOTMVTAFF
IREVENU_M2
NBJDEPDP
SLDFINMMSCPT
MINSOLDE_PAR
MNTTOTMVTAFFGLISS_M12
CRTAD_AG_SOLDE_T/**/
ANCIENNETE
CRTAD_IND_0038
MNTECSCRDIMM
epargne_res
MNTTOTCRDCSM
NBJDEPLS;

RANKS dIREVENU_M1
	dAGE
	dMONTANT_EPARGNE
	dCRTAD_AG_NBJDE_BA
	dCRTAD_AG_SOLDE_T1
	dMNTTOTMVTAFF
  dIREVENU_M2
  dNBJDEPDP
  dSLDFINMMSCPT
  dMINSOLDE_PAR
  dMNTTOTMVTAFFGLISS_M12
  dCRTAD_AG_SOLDE_T
  dANCIENNETE
  dCRTAD_IND_0038
  dMNTECSCRDIMM
  depargne_res
  dMNTTOTCRDCSM
  dNBJDEPLS;
RUN;

CLASS dIREVENU_M1;
VAR IREVENU_M1;
RUN;

PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * (dIREVENU_M1) / CHISQ;
RUN;


PROC FORMAT;
    VALUE REVENUformat
	  LOW   -< 7 = "Faible"
	  7 -< 13 = "Moyen"
	  13 - HIGH   = "Elevé";
RUN;


DATA quantiles;
    SET quantiles;
    FORMAT dIREVENU_M1 REVENUformat.;
RUN;

/*

PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * (dIREVENU) / CHISQ;
RUN;


PROC FREQ DATA = quantiles;
FORMAT dIREVENU classdIREVENU. ;
tables dIREVENU_M1 * dIREVENU / CHISQ;
RUN;


data tabledescretise;
set quantiles;
If dIREVENU_M1>=14 then dIREVENU_M1_DISCRET = 'Riche';
If dIREVENU_M1>=8 and dIREVENU_M1=<13 then dIREVENU_M1_DISCRET = "Moyen";
If dIREVENU_M1>=2 and dIREVENU_M1=<7 then dIREVENU_M1_DISCRET = "Pauvre";
run;

*/

PROC FREQ DATA = tabledescretise;
tables top_degrad_dd_3 * (revenudiscret) ;
RUN;

/*To complete Script format*/

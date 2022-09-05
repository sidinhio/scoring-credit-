
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



/*************************************************************************/
/************************ESTIMATION DU MODELE*****************************/
/*************************************************************************/
%let variables_modele = CODSITFAM_REC
  AGE
  CODACVPRO_REC
  LITIGE
  dIREVENU_M2
  dMONTANT_EPARGNE
  dCRTAD_AG_NBJDE_BA
  dCRTAD_AG_SOLDE_T1
  dMNTTOTMVTAFF
  dNBJDEPDP
  dSLDFINMMSCPT
  dMINSOLDE_PAR
  dANCIENNETE
  Top_PG;

%let variables_class=CODSITFAM_REC (ref="2") AGE (ref="1") CODACVPRO_REC
(ref="1") LITIGE (ref="1")  dIREVENU_M1 (ref="3");
/*référence modalité la moins risquée*/

/****CHOIX DU MODELE PAR LE TEST DE VUONG****/
PROC LOGISTIC DATA = class_echantillon_app;
CLASS &variables_class/ PARAM=REF ;
MODEL IMPAYE (Event='1') = &variables_modele
/ OUTROC = Tab_Roc_App Selection=backward SLS=0.05 Link=Logit ;
OUTPUT OUT=TAB_SCORE_ECH_APP_logit p=p_logit PREDICTED=Y_Chapeau
XBETA=Y_Etoile_Chapeau ;
title "modelisation logit";
RUN ;


PROC LOGISTIC DATA = quantiles;
	format AGE AGEformatN.;
	class AGE(param=ref ref='< 30 ans');
	model top_degrad_dd_3(ref='1')= AGE /ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;


proc logistic data=  quantiles;
  class AGE / param=ref ;
  model admit = gre gpa rank;
run;


proc logistic;
      format Y Disease.;
      model Y=Exposure;
run;



PROC LOGISTIC DATA = quantiles;
	format AGE AGEformatN.
		dIREVENU_M1 REVENUformat.
	   dMONTANT_EPARGNE MONTANT_EPARGNEformat.
		dMNTTOTMVTAFF MNTTOTMVTAFFformat.
  		dSLDFINMMSCPT SLDFINMMSCPTformat.
  		dMINSOLDE_PAR MINSOLDE_PARformat.
  		dANCIENNETE ANCIENNETEformat.
  		Top_PG TOPPGformat.;
	class AGE(param=ref ref='< 30 ans') 
		dIREVENU_M1(param=ref ref='1')
		dMONTANT_EPARGNE (param=ref ref='1')
		dMNTTOTMVTAFF (param=ref ref='1')
		dMONTANT_EPARGNE (param=ref ref='1')
		dSLDFINMMSCPT (param=ref ref='1')
		dMINSOLDE_PAR (param=ref ref='1')
		dANCIENNETE (param=ref ref='1');
	model top_degrad_dd_3(ref='1')= AGE
									dIREVENU_M1
									dMONTANT_EPARGNE
								  dMNTTOTMVTAFF
								  dSLDFINMMSCPT
								  dMINSOLDE_PAR
								  dANCIENNETE
							     /ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;




PROC LOGISTIC DATA = quantiles;
	format AGE AGEformatN.
		dIREVENU_M1 REVENUformat.
		CODSITFAM_REC CODSITFAMRecFormat.
	   dMONTANT_EPARGNE MONTANT_EPARGNEformat.;
	class AGE(param=ref ref='< 30 ans') 
		 CODACVPRO_REC(param=ref ref='1')
		dIREVENU_M1(param=ref ref='1')
		dMONTANT_EPARGNE (param=ref ref='1');
	model top_degrad_dd_3(ref='1')= AGE
									CODACVPRO_REC
									dIREVENU_M1
									dMONTANT_EPARGNE /ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;


/*
LITIGE
  dIREVENU_M1
  dMONTANT_EPARGNE
  dCRTAD_AG_NBJDE_BA
  dCRTAD_AG_SOLDE_T1
  dMNTTOTMVTAFF
  dNBJDEPDP
  dSLDFINMMSCPT
  dMINSOLDE_PAR
  dANCIENNETE
  Top_PG 
*/

PROC LOGISTIC DATA = quantiles;
	format AGE AGEformatN.
		dIREVENU_M1 REVENUformat.
	   dMONTANT_EPARGNE MONTANT_EPARGNEformat.
		dMNTTOTMVTAFF MNTTOTMVTAFFformat.
  		dSLDFINMMSCPT SLDFINMMSCPTformat.
  		dMINSOLDE_PAR MINSOLDE_PARformat.
  		dANCIENNETE ANCIENNETEformat.;
	class AGE(param=ref ref='< 30 ans') 
		dIREVENU_M1(param=ref ref='1')
		CODSITFAM (param=ref ref='0')
		dMONTANT_EPARGNE (param=ref ref='1')
		dMNTTOTMVTAFF (param=ref ref='1')
		dSLDFINMMSCPT (param=ref ref='1')
		dMINSOLDE_PAR (param=ref ref='1')
		dANCIENNETE (param=ref ref='1');
	model top_degrad_dd_3(ref='1')= AGE
									dIREVENU_M1
									dMONTANT_EPARGNE
									CODSITFAM
								  dMNTTOTMVTAFF
								  dSLDFINMMSCPT
								  dMINSOLDE_PAR
								  dANCIENNETE
							     /ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;



PROC LOGISTIC DATA = quantiles;

	class CODSITFAM (param=ref ref='0');
	model top_degrad_dd_3(ref='1')= CODSITFAM  /ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;


PROC FREQ DATA = Train;
tables top_degrad_dd_3 * (dMINSOLDE_PAR) / CHISQ;
RUN;


/*********************/
%let variables_modele =  dMNTTOTMVTAFF
 dCRTAD_AG_NBJDE_BA
 dNBJDEPDP
 dCRTAD_AG_NBJDE_BC
 dIREVENU_M2
 dMINSOLDE_PAR
 dCRTAD_AG_NBECR_A
 dMNTTOTMVTAFFGLISS_M12
 dSLDFINMMSCPT
 dCRTAD_AG_SOLDE_T2
 dMNTENC_PAR
 dANCIENNETE
 dMONTANT_EPARGNE
 dAGEPRS
 dCRTAR_IND_0036;



/****VARIABLES D'intérêt (Y variable d'intérêt) - VARIABLES Qualitatives****/
ODS output Chisq = CRAMER;
PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * ( CODSITFAM_REC
  AGE
  CODACVPRO_REC
  LITIGE
  dIREVENU_M1
  dMONTANT_EPARGNE
  dCRTAD_AG_NBJDE_BA
  dCRTAD_AG_SOLDE_T1
  dMNTTOTMVTAFF
  dNBJDEPDP
  dSLDFINMMSCPT
  dMINSOLDE_PAR
  dANCIENNETE
  Top_PG )/chisq ;
FORMAT  CODSITFAM_REC CODSITFAMRecFormat. AGE AGEformatN. dIREVENU_M1 REVENUformat.
	     LITIGE LITIGEformat.
	   dMONTANT_EPARGNE MONTANT_EPARGNEformat. dCRTAD_AG_NBJDE_BA
		dCRTAD_AG_SOLDE_T1 CRTAD_AG_SOLDE_T1format.
		dMNTTOTMVTAFF MNTTOTMVTAFFformat.
		 dNBJDEPDP NBJDEPDPformat.
  		dSLDFINMMSCPT SLDFINMMSCPTformat.
  		dMINSOLDE_PAR MINSOLDE_PARformat.
  		dANCIENNETE ANCIENNETEformat.
  		Top_PG TOPPGformat.;
RUN;
/*
DATA CRAMER (keep = table value prob);
set CRAMER;
Where statistic = "V de Cramer";
RUN;


PROC SORT DATA = work.CRAMER;
BY DESCENDING value; 
RUN;
*/


ods html file = "P:\ENSAI_3A\Projet_Scoring\Output\V_de_Cramer_Autocorelation_Sidi_25_02.xls";
PROC PRINT data = CRAMER;
RUN;

ods html close;





PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * (CODACVPRO_REC) / CHISQ;
RUN;

PROC FREQ DATA = train;
 TABLES  top_degrad_dd_3 * dageprs / CHISQ;
RUN;



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
		  dCRTAR_IND_0036(param=ref ref='1')
		  CODSITFAM_REC(param=ref ref='1')
		  CODACVPRO_REC(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036
									CODSITFAM_REC
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;







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
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036/ctable link = logit rsquare outroc = roc Selection=stepwise SLS=0.05;
	output out = table_sortie predicted = PROBA;
RUN;



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
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036/ctable link = logit rsquare outroc = roc Selection= forward;
	output out = table_sortie predicted = PROBA;
RUN;




/****CONSTRUCTION D'UN ECHANTILLON APPRENTISSAGE****/


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






ods html close;
ods html ;
PROC LOGISTIC DATA = train;

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
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036/ctable link = logit rsquare outroc = roc Selection= forward;
	output out = table_sortie predicted = PROBA;
RUN;





PROC LOGISTIC DATA = train;

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
		  dCRTAR_IND_0036(param=ref ref='1')
		  CODSITFAM_REC(param=ref ref='1')
		  CODACVPRO_REC(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036
									CODSITFAM_REC
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;
























/*Réajustement*/
ods html close;
ods html ;
PROC FREQ DATA = quantiles;
tables &y * (&variables_modele)/nocum nofreq nocol ;
RUN;

/*V1*/

PROC LOGISTIC DATA = quantiles;

	class dMNTTOTMVTAFF (param=ref ref='1')
		  dCRTAD_AG_NBJDE_BA (param=ref ref='2')
		  dNBJDEPDP	(param=ref ref='3')
		  dIREVENU_M2(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2/ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;

PROC LOGISTIC DATA = quantiles;

	class dMNTTOTMVTAFF (param=ref ref='1')
		  dCRTAD_AG_NBJDE_BA (param=ref ref='2')
		  dNBJDEPDP	(param=ref ref='3')
		  dIREVENU_M2(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2/ctable link = logit rsquare outroc = roc;
	output out = table_sortie predicted = PROBA;
RUN;



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
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036/ctable link = logit rsquare outroc = roc Selection= stepwise;
	output out = table_sortie predicted = PROBA;
RUN;




PROC LOGISTIC DATA = TRAIN;

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
		  dCRTAR_IND_0036(param=ref ref='1')
		  CODSITFAM_REC(param=ref ref='1')
		  CODACVPRO_REC(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									dMNTENC_PAR
									dMONTANT_EPARGNE
									dAGEPRS
									dCRTAR_IND_0036
									CODSITFAM_REC
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc Selection= stepwise slentry = 0.10 slstay = 0.15;
	output out = table_sortie predicted = PROBA;
RUN;


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
		  
		  
		  dAGEPRS(param=ref ref='[>47 ans[')
		  
		  
		  CODACVPRO_REC(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									
									
									dAGEPRS
						
									
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc selection = stepwise;
	output out = table_sortie predicted = PROBA;
RUN;




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
		  
		  
		  dAGEPRS(param=ref ref='[>47 ans[')
		  
		  CODSITFAM_REC(param=ref ref='1')
		  CODACVPRO_REC(param=ref ref='1'); 
	model top_degrad_dd_3(ref='1')= dMNTTOTMVTAFF 
									dCRTAD_AG_NBJDE_BA
									dNBJDEPDP
									dIREVENU_M2
									dMINSOLDE_PAR
									dCRTAD_AG_NBECR_A
									dSLDFINMMSCPT
									
									
									dAGEPRS
						
									CODSITFAM_REC
									CODACVPRO_REC/ctable link = logit rsquare outroc = roc Selection=Backward SLS=0.05 ;
	output out = table_sortie predicted = PROBA;
RUN;


/*Vérification des formats*/

PROC FREQ DATA = Base;
 TABLES AGE;
 FORMAT AGE AGEformat.;
RUN;

PROC FREQ DATA = Base;
 TABLES AGEPRS;
 FORMAT AGEPRS AGEformat.;
RUN;

PROC FREQ DATA = Base;
 TABLES top_degrad_dd_3 * AGE;
 FORMAT AGE AGEformatN.;
RUN;


PROC FREQ DATA = Base;
 TABLES AGE_T1;
RUN;


/*Pour les indicateurs*/
PROC FREQ DATA = Base;
 tables  LITIGE * top_degrad_dd_3;
  FORMAT LITIGE LITIGEformat.;
RUN;


/*Pour CODACVPRO2*/
PROC FREQ DATA = quantiles;
 tables   top_degrad_dd_3* CODACVPRO2 ;
  FORMAT CODACVPRO2 $CODACVPROformat.;
RUN;

PROC FREQ DATA = quantiles;
 tables   top_degrad_dd_3* CODACVPRO_REC ;
RUN;


/*Pour CODSITFAMformat*/
PROC FREQ DATA = quantiles;
 tables   top_degrad_dd_3* CODSITFAM_REC ;
  FORMAT CODSITFAM_REC CODSITFAMformatN.;
RUN;

PROC FREQ DATA = quantiles;
 tables   top_degrad_dd_3* CODSITFAM ;
  FORMAT CODSITFAM CODSITFAMformatN.;
RUN;



/*1 Revenu dIREVENU_M1*/

PROC MEANS DATA = quantiles MIN MAX;
CLASS dIREVENU_M1;
VAR IREVENU_M1;
RUN;

PROC FREQ DATA = quantiles;
tables  (dIREVENU_M1) / CHISQ;
FORMAT dIREVENU_M1 REVENUformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dIREVENU_M1) / CHISQ;
RUN;

PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dIREVENU_M1) / CHISQ;
 FORMAT dIREVENU_M1 REVENUformat.;
RUN; /*ok POUR LE REVENU : Ecart relatifs de 30% 
ecart de 5% aumoins pour chaque modalité 
Décroissance des modalités */



/*2 MONTANT_EPARGNE*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dMONTANT_EPARGNE;
VAR dMONTANT_EPARGNE;
RUN;

PROC FREQ DATA = quantiles;
 tables top_degrad_dd_3*  dMONTANT_EPARGNE;
RUN;


PROC FREQ DATA = quantiles;
 tables  dMONTANT_EPARGNE;
 FORMAT dMONTANT_EPARGNE MONTANT_EPARGNEformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dMONTANT_EPARGNE) / CHISQ;
 FORMAT dMONTANT_EPARGNE MONTANT_EPARGNEformat.;
RUN;/*Contraintes OK*



/*3 dCRTAD_AG_NBJDE_BA*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dCRTAD_AG_NBJDE_BA;
VAR dCRTAD_AG_NBJDE_BA;
RUN;

PROC FREQ DATA = quantiles;
 tables  dCRTAD_AG_NBJDE_BA;
 FORMAT dCRTAD_AG_NBJDE_BA CRTAD_AG_NBJDE_BAformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dCRTAD_AG_NBJDE_BA) / CHISQ;
RUN;

PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dCRTAD_AG_NBJDE_BA) / CHISQ;
 FORMAT dCRTAD_AG_NBJDE_BA CRTAD_AG_NBJDE_BAformat.;
RUN;/*Contraintes OK*



/*4 dCRTAD_AG_NBJDE_BA*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dCRTAD_AG_SOLDE_T1;
VAR dCRTAD_AG_SOLDE_T1;
RUN;

PROC FREQ DATA = quantiles;
 tables  dCRTAD_AG_SOLDE_T1;
 FORMAT dCRTAD_AG_SOLDE_T1 CRTAD_AG_SOLDE_T1format.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dCRTAD_AG_SOLDE_T1) / CHISQ;
 FORMAT dCRTAD_AG_SOLDE_T1 CRTAD_AG_SOLDE_T1format.;
RUN;/*Contraintes OK*



/*5 dCRTAD_AG_NBJDE_BA*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dMNTTOTMVTAFF;
VAR dMNTTOTMVTAFF;
RUN;

PROC FREQ DATA = quantiles;
 tables  dMNTTOTMVTAFF;
 FORMAT dMNTTOTMVTAFF;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dMNTTOTMVTAFF) / CHISQ;
 FORMAT dMNTTOTMVTAFF MNTTOTMVTAFFformat.;
RUN;/*Contraintes OK*





/*6 dIREVENU_M2*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dIREVENU_M2;
VAR dIREVENU_M2;
RUN;

PROC FREQ DATA = quantiles;
 tables  dIREVENU_M2;
 FORMAT dIREVENU_M2 REVENUformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dIREVENU_M2) / CHISQ;
 FORMAT dIREVENU_M2 REVENUformat.;
RUN;/*Contraintes OK*




/*7 dNBJDEPDP REF = 1*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dNBJDEPDP;
VAR dNBJDEPDP;
RUN;

PROC FREQ DATA = quantiles;
 tables  dNBJDEPDP;
 FORMAT dNBJDEPDP NBJDEPDPformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dNBJDEPDP) / CHISQ;
 FORMAT dNBJDEPDP NBJDEPDPformat.;
RUN;/*Contraintes OK*



/*8 dNBJDEPDP REF = 1*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dSLDFINMMSCPT;
VAR dSLDFINMMSCPT;
RUN;

PROC FREQ DATA = quantiles;
 tables  dSLDFINMMSCPT;
 FORMAT dSLDFINMMSCPT SLDFINMMSCPTformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dSLDFINMMSCPT) / CHISQ;
 FORMAT dSLDFINMMSCPT SLDFINMMSCPTformat.;
RUN;/*Contraintes OK*



/*9 dMINSOLDE_PAR REF = 1*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dMINSOLDE_PAR;
VAR dMINSOLDE_PAR;
RUN;

PROC FREQ DATA = quantiles;
 tables  dMINSOLDE_PAR;
 FORMAT dMINSOLDE_PAR SLDFINMMSCPTformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dMINSOLDE_PAR) / CHISQ;
 FORMAT dMINSOLDE_PAR MINSOLDE_PARformat.;
RUN;/*Contraintes OK*



/*10  dANCIENNETE REF = 1*/


PROC MEANS DATA = quantiles MIN MAX;
CLASS dANCIENNETE;
VAR dANCIENNETE;
RUN;

PROC FREQ DATA = quantiles;
 tables  dANCIENNETE;
 FORMAT dANCIENNETE ANCIENNETEformat.;
RUN;


PROC FREQ DATA = quantiles;
 TABLES top_degrad_dd_3 * (dANCIENNETE) / CHISQ;
 FORMAT dANCIENNETE ANCIENNETEformat.;
RUN;/*Contraintes OK*





/*To do at the end*/
DATA quantiles;
    SET quantiles;
    FORMAT  dIREVENU_M1 REVENUformat.;
RUN;

/*
	
	
	
	
  
  
  
  
  dMNTTOTMVTAFFGLISS_M12
  dCRTAD_AG_SOLDE_T
  dCRTAD_IND_0038
  dMNTECSCRDIMM
  depargne_res
  dMNTTOTCRDCSM
  dNBJDEPLS
*/

ODS OUTPUT kruskalWalis = Croisement;

PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * ( CODSITFAM
  AGE
  CODACVPRO2
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
  Top_PG )/nocum nomiss nofreq ;
FORMAT  CODSITFAM CODSITFAMformat AGE AGEformat. dIREVENU_M1 REVENUformat.
	   CODACVPRO2 $CODACVPROformat. LITIGE LITIGEformat.
	   dMONTANT_EPARGNE MONTANT_EPARGNEformat. dCRTAD_AG_NBJDE_BA
		dCRTAD_AG_SOLDE_T1 CRTAD_AG_SOLDE_T1format.
		dMNTTOTMVTAFF MNTTOTMVTAFFformat.
		 dNBJDEPDP NBJDEPDPformat.
  		dSLDFINMMSCPT SLDFINMMSCPTformat.
  		dMINSOLDE_PAR MINSOLDE_PARformat.
  		dANCIENNETE ANCIENNETEformat.
  		Top_PG TOPPGformat.;
RUN;



/*PROC SORT DATA = kruskal;
BY DESCENDING CODITDAGE_PAR;*/
ods html file = "P:\ENSAI_3A\Projet_Scoring\Output\Croisement_Categorisation.txt";

PROC PRINT data = Croisement;
RUN;


ods html close;
ods html ;
PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * ( CODSITFAM
  AGE
  CODACVPRO2
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
  Top_PG )/nocum nofreq ;
FORMAT  CODSITFAM CODSITFAMformat. AGE AGEformat. dIREVENU_M1 REVENUformat.
	   CODACVPRO2 $CODACVPROformat. LITIGE LITIGEformat.
	   dMONTANT_EPARGNE MONTANT_EPARGNEformat. dCRTAD_AG_NBJDE_BA
		dCRTAD_AG_SOLDE_T1 CRTAD_AG_SOLDE_T1format.
		dMNTTOTMVTAFF MNTTOTMVTAFFformat.
		 dNBJDEPDP NBJDEPDPformat.
  		dSLDFINMMSCPT SLDFINMMSCPTformat.
  		dMINSOLDE_PAR MINSOLDE_PARformat.
  		dANCIENNETE ANCIENNETEformat.
  		Top_PG TOPPGformat.;
RUN;
ods html close;



/*Creation de nouveaux variables*/
data Base;
	set Base ;
	If CODSITFAM = 0 then CODSITFAM_REC = 2;
	If CODSITFAM = 1  then CODSITFAM_REC = 1;
	If CODSITFAM = 2 then CODSITFAM_REC  = 1;
	If CODSITFAM = 3 then CODSITFAM_REC = 1;
	If CODSITFAM = 4 then CODSITFAM_REC = 2;
	If CODSITFAM = 5 then CODSITFAM_REC = 2;
run; /*Recoder la situation matrimoniale*/


/*Réajustement*/
ods html close;
ods html ;
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
  Top_PG )/nocum nofreq nocol ;
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
ods html close;

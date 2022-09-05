
%let var_quanti = AGEPRS ANCIENNETE CRTAD_AG_NBECR_A CRTAD_AG_NBJDE_BA CRTAD_AG_NBJDE_BC CRTAD_AG_SOLDE_T CRTAD_AG_SOLDE_T1 CRTAD_AG_SOLDE_T2
CRTAD_AG_SOLDE_T3 CRTAD_AG_SOLDE_T4 CRTAD_IND_0015 CRTAD_IND_0038 CRTAR_IND_0036 DIFFECR_PAR_TR ENCOURS_PAR IREVENU_M1 IREVENU_M2 MINSOLDE_PAR
MNTECSCRDIMM MNTENC_PAR MNTTOTCRDCSM MNTTOTMVTAFF MNTTOTMVTAFFGLISS_M12 NBECR_PAR NBJDEB3_ANN1_PAR_TR NBJDEPDP NBJDEPLS SLDFINMMSCPT epargne_res
montant_epargne ;

/*NDB_SURV_FINAL : defaut balois */

%let var_quali =  CODACVPRO CODSITFAM top_GF CODACVECO TYPE_FDC TOPCPTLITIG  ; /*  RISQUE_SCORE_PAR  TOPCPTLITIG?   TOPDD*/ 
 


DATA  Base;
	set Base;
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
/*
DATA Base ;
    SET Base;
    IF miss_prop >70 THEN DELETE;
RUN;
*/


/*n=894035 --> supression de 613 individus*/
/*Imputation des variables quantitatives par la moyenne des non manquants*/

PROC STDIZE DATA=Base OUT=Base METHOD=MEAN REPONLY ;
  VAR &var_quanti ;
RUN ;

/*Imputation des variables qualitatives par le mode*/

/*CODSITFAM, mode=1*/
proc freq data = Base ;
 tables CODSITFAM;
run;   

DATA Base ;
    SET Base;
    IF CODSITFAM =. THEN CODSITFAM='1';
RUN;


/*CODACVPRO, mode=8*/
proc freq data = Base ;
 tables CODACVPRO;
run;  
 
DATA Base ;
    SET Base;
    IF CODACVPRO =. THEN CODACVPRO='8';
RUN;


/*TYPE_FDC, mode=0*/
proc freq data = Base ;
 tables TYPE_FDC;
run;   
DATA Base ;
    SET Base;
    IF TYPE_FDC =. THEN TYPE_FDC='0';
RUN;


/*CODACVECO, mode=0*/
proc freq data = Base ;
 tables CODACVECO;
run;   
DATA Base ;
    SET Base;
    IF CODACVECO =. THEN CODACVECO='0';
RUN;

/*TOPCPTLITIG, mode=0*/
proc freq data = Base ;
 tables TOPCPTLITIG;
run;   
DATA Base ;
    SET Base;
    IF TOPCPTLITIG =. THEN top_GF='0';
RUN;
  




/********************************************* Regroupement des variables qualitatives **********************************************/

DATA Base;
	SET Base  ;
	IF CODITDAGE_PAR ='0'  THEN CODITDAGE_PAR2 = '0';
	ELSE  CODITDAGE_PAR2 = '1';  /*Autres*/
RUN;

DATA Base;
	SET Base;
	IF CODACVPRO ='1' or CODACVPRO ='2' THEN CODACVPRO2 = '1';
	ELSE IF CODACVPRO ='7' or CODACVPRO ='8' or CODACVPRO ='9' THEN CODACVPRO2 = '3';
	ELSE CODACVPRO2 = '2';
RUN;

/*generer les echantillons bootstrap*/


proc surveyselect data=scoring.disc_fin  method = urs sampsize = 25000 seed=12345 out=scoring.bs_obs outhits noprint rep=100;
run;

proc sort data=scoring.bs_obs;
by replicate;
run;
%let lass=CSP2_ress_max CodeApporteur EtatNature Presence_bien_mev RelationBancaire_ress_max ValeurAcquisition_c 
apport_deniers_c  exist_conso_revolv 
irpar_ress_max montant_epargne_c nb_empr_c QualiteInterv_ress_max   ; 
/* valitadion des coeficients des estimations */
/*sortir les estimations des echantillons bootstrap*/
ods output ParameterEstimates(Persist=run)=scoring.bs_para;
proc  logistic data=scoring.bs_obs descending;
class CSP2_ress_max(param=ref ref="3") CodeApporteur(param=ref ref="L") EtatNature(param=ref ref="01") Presence_bien_mev(param=ref ref="0")   
 RelationBancaire_ress_max(param=ref ref="M1") ValeurAcquisition_c(param=ref ref="2") 
apport_deniers_c(param=ref ref="2")  exist_conso_revolv(param=ref ref="0") 
irpar_ress_max(param=ref ref="001") montant_epargne_c(param=ref ref="2") nb_empr_c(param=ref ref="1") QualiteInterv_ress_max(param=ref ref="04")

/param=ref;
model top_NDB  = &lass ; 
by replicate;
run; 
ods output close;



/*Gini*/
ods trace on;
ods output association=somers parameterestimates=pe;
proc logistic data=scoring.bs_obs;
class CSP2_ress_max(param=ref ref="3") CodeApporteur(param=ref ref="L") EtatNature(param=ref ref="01") Presence_bien_mev(param=ref ref="0")   
 RelationBancaire_ress_max(param=ref ref="M1") ValeurAcquisition_c(param=ref ref="2") 
apport_deniers_c(param=ref ref="2")  exist_conso_revolv(param=ref ref="0") 
irpar_ress_max(param=ref ref="001") montant_epargne_c(param=ref ref="2") nb_empr_c(param=ref ref="1") QualiteInterv_ress_max(param=ref ref="04")

/param=ref;
model top_NDB  = &lass ;
by replicate;
run;
ods trace off;


proc means data=somers(where=(Label2='D de Somers')) ;
*class Replicate ;
var nValue2;
run ; 



proc means data=scoring.bs_para ;
class VARIABLE ClassVal0;
var ESTIMATE ;
run; 


/* si l'estimation des echantillons est dans l'IC 95 de l'estimation originiale*/
DATA scoring.bs_para2;
set scoring.bs_para;
bs_sat=2;
IF VARIABLE="Intercept" THEN
	DO;
		IF ( 0.286852 <= ESTIMATE <= 1.134748) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;

ELSE IF VARIABLE="CSP2_ress_max" THEN
	DO;
		IF ( 1.4277 <= ESTIMATE <= 1.9885 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="EtatNature" THEN
	DO;
		IF ( -0.78034 <= ESTIMATE <= -0.05906 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="NbIntervenants" THEN
	DO;
		IF ( 0.337108 <= ESTIMATE <= 1.033692 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="RelationBancaire_ress_max" THEN
	DO;
		IF ( -1.001652  <= ESTIMATE <=-0.252148 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="TAUXAPPORTPERSONNALISE_c " THEN
	DO;
		IF ( -0.114668 <= ESTIMATE <=  0.731268) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="ValEstimeeBien_c" THEN
	DO;
		IF ( -0.339992 <= ESTIMATE <=  1.071992) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="apport_deniers_1" THEN
	DO;
		IF (-0.03588  <= ESTIMATE <= 0.80888) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="exist_conso_revolv" THEN
	DO;
		IF ( 0.0274 <= ESTIMATE <=  -0.15928) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="irpar_ress_max" THEN
	DO;
		IF (-1.499376 <= ESTIMATE <= -0.742424 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="nbPersCharg_c" THEN
	DO;
		IF (-0.97904 <= ESTIMATE <=  -0.07156) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="D_montant_epargne" THEN
	DO;
		IF ( -0.283644 <= ESTIMATE <= 0.525444 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="ValeurAcquisition_c" THEN
	DO;
		IF ( -0.364244 <= ESTIMATE <= 1.199444 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="age_max_c" THEN
	DO;
		IF ( -1.2266   <= ESTIMATE <= -0.3152 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;

ELSE IF VARIABLE="anc_emploi_ress_max_1" THEN
	DO;
		IF ( -0.122288   <= ESTIMATE <= 0.545288 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
ELSE IF VARIABLE="apport_deniers_1" THEN
	DO;
		IF ( 0.0475    <= ESTIMATE <= 0.6825 ) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;

ELSE IF VARIABLE="duree_max_c" THEN
	DO;
		IF ( -0.797052   <= ESTIMATE <= 0.168052) THEN bs_sat=0;
		ELSE bs_sat=1;
	END;
RUN;

proc sort data=scoring.bs_para2;
by descending bs_sat;
run;

proc means data=scoring.bs_para(where=(VARIABLE='CSP2_ress_max'));
by VARIABLE ;
var ESTIMATE ;

run;


proc means data=scoring.bs_para;
class VARIABLE ;
var ESTIMATE ;

run; 


proc means data=scoring.bs_para(where=(VARIABLE='NbIntervenants'));
by VARIABLE ;
var ESTIMATE ;

run; 





/* valitadion de gini*/

/*calculer le gini orginal*/
%Indice_Gini_Trapezes(Tab=table.scoring,Critere_Mod=defaut,Val_Critere=1,Var_Analyse=score, data_out=table.gini) 




/*iterer pour tous les echantillons*/
%Macro Indice_Gini_Trapezes_bs(Tabb=) ;
%DO I = 1 %TO 100;
data irs.bs_tmp;
set &Tabb;
If replicate = &i;
run;
%Indice_Gini_Trapezes(Tab=irs.bs_tmp,Critere_Mod=defaut,Val_Critere=1,Var_Analyse=score, data_out=irs.tmp_gini) 

Proc SQL NoPrint ;
	Select gini Into : TMP_GINI
	From irs.tmp_gini ;
QUIT;

DATA irs.final_gini;
set irs.final_gini end=eof;
output;
if eof then do;
gini=&TMP_GINI;
output;
end;
RUN;
%END;
Proc DataSets LIBRARY=IRS NOLIST ;
	Delete bs_tmp tmp_gini ;
Run ;
QUIT;
%MEnd Indice_Gini_Trapezes_bs ;

%Indice_Gini_Trapezes_bs(Tabb=irs.bs_obs)



proc means data=TMP2.Final_gini mean min max median;
run;

proc sql;
create table table.COD_APE as
(select * from TMP2.Bs100f_para where Variable='COD_APE');
quit;
run;


proc sql;
create table table.MNT_HA134A as
(select * from TMP2.Bs100f_para where Variable='MNT_HA134A');
quit;
run;


proc sql;
create table table.NB_ENFANTA as
(select * from TMP2.Bs100f_para where Variable='NB_ENFANTA');
quit;
run;


proc sql;
create table table.MNT_HA140A as
(select * from TMP2.Bs100f_para where Variable='MNT_HA140A');
quit;
run;

proc means data=table.COD_APE mean median;
var estimate;
run;
proc means data=table.MNT_HA134A mean median;
var estimate;
run;
proc means data=table.NB_ENFANTA mean median;
var estimate;
run;
proc means data=table.MNT_HA140A mean median;
var estimate;
run;

data table.ns;
merge table.base22(keep= CLAIND_IRS CLAIND_NS CLAIND_IRPRO CLAIND_IRFI defaut) table.scoring2(keep=score_rank);
run;


proc format;
value fCLAIND_IRPRO
0='0'
1='1'
2='2'
3='3'
4='4'
5='5'
6='6'
7='7'
8='8'
9='9'
10-11='10';
value fCLAIND_IRFI
1='1'
2='2'
3='3'
4='4'
5='5'
6='6'
7='7'
8='8'
9='9'
10='10';
value fIRS
1='1'
2='2'
3='3'
4='4'
5='5'
6='6'
7='7'
8='8'
9='9'
10='10'
;
run;

proc freq data=table.ns;
table defaut*CLAIND_IRPRO;
format claind_irpro fCLAIND_IRPRO. CLAIND_IRFI fCLAIND_IRFI. CLAIND_IRS fIRS.;
run;


proc  logistic data=table.ns plot(only)=(roc);
    class CLAIND_IRPRO(ref='10') CLAIND_IRFI(ref='10') CLAIND_IRS(ref='10')  /param=ref;
    model defaut(ref='1')=CLAIND_IRPRO CLAIND_IRFI CLAIND_IRS;
    format claind_irpro fCLAIND_IRPRO. CLAIND_IRFI fCLAIND_IRFI. CLAIND_IRS fIRS.;
run; 


proc  logistic data=table.ns plot(only)=(roc);
    class CLAIND_IRPRO(ref='10') CLAIND_IRFI(ref='10') score_rank(ref='1')  /param=ref;
    model defaut(ref='1')=CLAIND_IRPRO CLAIND_IRFI score_rank;
    format claind_irpro fCLAIND_IRPRO. CLAIND_IRFI fCLAIND_IRFI. score_rank score_rank.;
run; 



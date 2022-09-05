

/********************************111111111111111111111111111도도도도도도도도*/
/**Validation par Bootstrap**/


PROC SORT DATA=quantiles ;
	BY top_degrad_dd_3 ;
RUN ; 

proc surveyselect data=quantiles  method = urs sampsize = 25000 seed=12345 out=train_bootstrap outhits noprint rep=100;
run;
/*
PROC SURVEYSELECT DATA=quantiles METHOD=SRS OUT=train_bootstrap OUTALL SAMPRATE = 0.8 SEED = 123 REP= 100 ;
	STRATA top_degrad_dd_3;
RUN;*/

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
	
	dMONTANT_EPARGNE(param=ref ref='3')
	/* CODSITFAM2(param=ref ref='3')*/
	CODACVPRO2(param=ref ref='7');

model top_degrad_dd_3(ref='0')= dMNTTOTMVTAFF
		dCRTAD_AG_NBJDE_BA
		dNBJDEPDP
		dMINSOLDE_PAR
		dSLDFINMMSCPT
		
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

PROC SQL;
 SELECT *, MIN(Estimate) AS minimum_estimate, MAX(Estimate) as maximum_estimate, AVG(Estimate) as moyenne_estimate, STD(Estimate) as ecart_type
 FROM Bootsrap_param
 GROUP BY  Variable, ClassVal0;
QUIT;



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
	
	dMONTANT_EPARGNE(param=ref ref='3')
	/* CODSITFAM2(param=ref ref='3')*/
	CODACVPRO2(param=ref ref='7');

model top_degrad_dd_3(ref='0')= dMNTTOTMVTAFF
		dCRTAD_AG_NBJDE_BA
		dNBJDEPDP
		dMINSOLDE_PAR
		dSLDFINMMSCPT
		
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




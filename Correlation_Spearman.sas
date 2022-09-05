%macro corrmatx(libnamex=, dsname=, vars=, savpath=, savfile=CORRMATX, hight=.5,
medt=0, lowt=0);
options missing='';
%let cmvarn = %sysfunc(countw(&vars));
%local i;
proc corr data = &libnamex..&dsname SPEARMAN outp=corrmtx nomiss;
var &vars;
run;
proc template;
define style corrmatx;
 style table / borderwidth=10;
end;
run;
* suppress titles and footnotes;
title; footnote;
data corrmtx2;
set corrmtx (where=(_type_='CORR'));
halfmatflg+1;
array deletes(&cmvarn) &vars;
do i = 1 to &cmvarn;
if halfmatflg =< i then deletes(i) = .;
end;
drop halfmatflg i;
format &vars 5.2;
run;
proc format;
value corrfmtx
low - -&hight, &hight - high = 'red'
%if &medt ne 0 %then %do;
-&hight< - -&medt, &medt -< &hight = 'orange' %end;
%if &lowt ne 0 %then %do;
-&medt< - -&lowt, &lowt -< &medt = 'yellow'; %end;
run;
proc sql;
select '%NRSTR(%NRSTR(' || 'line "' || trim(name) || ': ' || trim(label) || '"));'
into :legend separated by ' '
from dictionary.columns
where libname=%UPCASE("&libnamex") and memname=%UPCASE("&dsname")
and name in (
%do i = 1 %to &cmvarn;
"%scan(&vars, &i) "
%end;
);
quit;



ods html file = "&savpath\&savfile..xls"
headtext="<style> td {mso-number-format:\@} </style>" style=corrmatx;
proc report data = corrmtx2
style(header)={htmlstyle="mso-rotate:90; height:50pt"};
column _name_ &vars;
define _name_ / display '' style=[font_weight=bold];
%do i = 1 %to &cmvarn;
define %scan(&vars, &i) / display " %scan(&vars, &i)" style=[background=corrfmtx.];
%end;
compute after / style=[just=left];
line ' ';
&legend
endcomp;
run;
ods html close;
options missing='.'; /* restore default */
%mend corrmatx; 


/*
 %corrmatx(libnamex=work,
 dsname=Base,
 vars=MINSOLDE_PAR CRTAD_AG_SOLDE_T CRTAD_IND_0038 CRTAD_AG_SOLDE_T1 CRTAD_AG_NBJDE_BA
TYPE_FDC CRTAD_AG_SOLDE_T2 CRTAD_AG_SOLDE_T3 CRTAD_AG_SOLDE_T4 CRTAD_AG_NBJDE_BC CRTAD_IND_0015 NBJDEPDP
MONTANT_EPARGNE MNTTOTMVTAFFGLISS_M12 MNTTOTMVTAFF MNTECSCRDIMM MNTTOTCRDCSM EPARGNE_RES SLDFINMMSCPT
AGEPRS,
 savpath=P:\ENSAI_3A\Projet_Scoring\Donnes,
 savfile=Correlations_matrix_Spearman,
 hight=.9, medt=.8, lowt=.7)
*/

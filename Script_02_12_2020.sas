PROC IMPORT OUT= Donnees1
 DATAFILE= 'P:/ENSAI 3A/Projet_Scoring/Donnes/Extract_201910/Extract_201910.txt'
 DBMS=DLM REPLACE;
 DELIMITER=';';
 DATAROW= 2;
RUN;


PROC IMPORT OUT= Donnees2
 DATAFILE= 'P:/ENSAI 3A/Projet_Scoring/Donnes/Extract_201911/Extract_201911.txt'
 DBMS=DLM REPLACE;
 DELIMITER=';';
 DATAROW= 2;

RUN;

DATA ab;
SET Donnees1 (in=x) Donnees2;
IF x=1 THEN origine="Donnees1";
ELSE origine="Donnees2";
RUN;



/*Reprise*/

data Donnees1    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'P:/ENSAI 3A/Projet_Scoring/Donnes/Extract_201910/Extract_201910.txt' delimiter = ';' MISSOVER DSD  lrecl=32767 firstobs=2 ;
         informat NUMTECPRS best32. ;
         informat TOPDD best32. ;
         informat MINSOLDE_PAR best32. ;
         informat CRTAD_AG_SOLDE_T best32. ;
         informat CRTAD_IND_0038 best32. ;
         informat CRTAD_AG_SOLDE_T1 best32. ;
         informat CRTAD_AG_SOLDE_T2 best32. ;
         informat CRTAD_AG_SOLDE_T3 best32. ;
         informat CRTAD_AG_SOLDE_T4 best32. ;
         informat CRTAD_AG_NBJDE_BC best32. ;
         informat CRTAD_AG_NBJDE_BA best32. ;
         informat CRTAD_IND_0015 best32. ;
         informat NBJDEPDP best32. ;
         informat ENCOURS_PAR best32. ;
         informat IREVENU_M1 best32. ;
         informat IREVENU_M2 best32. ;
         informat CRTAR_IND_0036 best32. ;
         informat AGEPRS best32. ;
         informat CODACVPRO best32. ;
         informat ANCIENNETE best32. ;
         informat MNTENC_PAR best32. ;
         informat CRTAD_AG_NBECR_A best32. ;
         informat RISQUE_SCORE_PAR best32. ;
         informat TOPCPTLITIG best32. ;
         informat NBJDEB3_ANN1_PAR_TR best32. ;
         informat DIFFECR_PAR_TR best32. ;
         informat NBECR_PAR best32. ;
         informat TOP_RR_t best32. ;
         informat NDB_SURV_FINAL best32. ;
         informat TYPE_FDC best32. ;
         informat CODITDAGE_PAR best32. ;
         informat TOPLS best32. ;
         informat MNTAUTCRT_PI_PAR $1. ;
         informat NBJDEPLS best32. ;
         informat top_GF best32. ;
         informat CODCNDFRG $1. ;
         informat AGE best32. ;
         informat montant_epargne best32. ;
         informat MNTTOTMVTAFFGLISS_M12 best32. ;
         informat MNTTOTMVTAFF best32. ;
         informat MNTECSCRDIMM best32. ;
         informat MNTTOTCRDCSM best32. ;
         informat epargne_res best32. ;
         informat SLDFINMMSCPT best32. ;
         informat irpar_bt_90_1 best32. ;
         informat irpar_bt_90_2 best32. ;
         informat top_degrad_2 best32. ;
         informat top_degrad_1 best32. ;
         informat _TEMG001 best32. ;
         informat datdelhis best32. ;
         informat irpar_dd_1 best32. ;
         informat irpar_dd_2 best32. ;
         informat top_degrad_dd_2 best32. ;
         informat top_degrad_dd_3 best32. ;
         informat ind_dd_M0 best32. ;
         informat ind_dd_M1 best32. ;
         informat ind_dd_M2 best32. ;
         informat ind_dd_M3 best32. ;
         informat ind_dd_M4 best32. ;
         informat ind_dd_M5 best32. ;
         informat ind_dd_final best32. ;
         informat CODSEXPRS best32. ;
         informat CODPAY_NATIONALITE $3. ;
         informat CODCMNIEE best32. ;
         informat CODACVECO $5. ;
         informat CODSITFAM best32. ;
         format NUMTECPRS best12. ;
         format TOPDD best12. ;
         format MINSOLDE_PAR best12. ;
         format CRTAD_AG_SOLDE_T best12. ;
         format CRTAD_IND_0038 best12. ;
         format CRTAD_AG_SOLDE_T1 best12. ;
         format CRTAD_AG_SOLDE_T2 best12. ;
         format CRTAD_AG_SOLDE_T3 best12. ;
         format CRTAD_AG_SOLDE_T4 best12. ;
         format CRTAD_AG_NBJDE_BC best12. ;
         format CRTAD_AG_NBJDE_BA best12. ;
         format CRTAD_IND_0015 best12. ;
         format NBJDEPDP best12. ;
         format ENCOURS_PAR best12. ;
         format IREVENU_M1 best12. ;
         format IREVENU_M2 best12. ;
         format CRTAR_IND_0036 best12. ;
         format AGEPRS best12. ;
         format CODACVPRO best12. ;
         format ANCIENNETE best12. ;
         format MNTENC_PAR best12. ;
         format CRTAD_AG_NBECR_A best12. ;
         format RISQUE_SCORE_PAR best12. ;
         format TOPCPTLITIG best12. ;
         format NBJDEB3_ANN1_PAR_TR best12. ;
         format DIFFECR_PAR_TR best12. ;
         format NBECR_PAR best12. ;
         format TOP_RR_t best12. ;
         format NDB_SURV_FINAL best12. ;
         format TYPE_FDC best12. ;
         format CODITDAGE_PAR best12. ;
         format TOPLS best12. ;
         format MNTAUTCRT_PI_PAR $1. ;
         format NBJDEPLS best12. ;
         format top_GF best12. ;
         format CODCNDFRG $1. ;
         format AGE best12. ;
         format montant_epargne best12. ;
         format MNTTOTMVTAFFGLISS_M12 best12. ;
         format MNTTOTMVTAFF best12. ;
         format MNTECSCRDIMM best12. ;
         format MNTTOTCRDCSM best12. ;
         format epargne_res best12. ;
         format SLDFINMMSCPT best12. ;
         format irpar_bt_90_1 best12. ;
         format irpar_bt_90_2 best12. ;
         format top_degrad_2 best12. ;
         format top_degrad_1 best12. ;
         format _TEMG001 best12. ;
         format datdelhis best12. ;
         format irpar_dd_1 best12. ;
         format irpar_dd_2 best12. ;
         format top_degrad_dd_2 best12. ;
         format top_degrad_dd_3 best12. ;
         format ind_dd_M0 best12. ;
         format ind_dd_M1 best12. ;
         format ind_dd_M2 best12. ;
         format ind_dd_M3 best12. ;
         format ind_dd_M4 best12. ;
         format ind_dd_M5 best12. ;
         format ind_dd_final best12. ;
         format CODSEXPRS best12. ;
         format CODPAY_NATIONALITE $3. ;
         format CODCMNIEE best12. ;
         format CODACVECO $5. ;
         format CODSITFAM best12. ;
      input
                  NUMTECPRS
                  TOPDD
                  MINSOLDE_PAR
                  CRTAD_AG_SOLDE_T
                  CRTAD_IND_0038
                  CRTAD_AG_SOLDE_T1
                  CRTAD_AG_SOLDE_T2
                  CRTAD_AG_SOLDE_T3
                  CRTAD_AG_SOLDE_T4
                  CRTAD_AG_NBJDE_BC
                  CRTAD_AG_NBJDE_BA
                  CRTAD_IND_0015
                  NBJDEPDP
                  ENCOURS_PAR
                  IREVENU_M1
                  IREVENU_M2
                  CRTAR_IND_0036
                  AGEPRS
                  CODACVPRO
                  ANCIENNETE
                  MNTENC_PAR
                  CRTAD_AG_NBECR_A
                  RISQUE_SCORE_PAR
                  TOPCPTLITIG
                  NBJDEB3_ANN1_PAR_TR
                  DIFFECR_PAR_TR
                  NBECR_PAR
                  TOP_RR_t
                  NDB_SURV_FINAL
                  TYPE_FDC
                  CODITDAGE_PAR
                  TOPLS
                  MNTAUTCRT_PI_PAR $
                  NBJDEPLS
                  top_GF
                  CODCNDFRG $
                  AGE
                  montant_epargne
                  MNTTOTMVTAFFGLISS_M12
                  MNTTOTMVTAFF
                  MNTECSCRDIMM
                  MNTTOTCRDCSM
                  epargne_res
                  SLDFINMMSCPT
                  irpar_bt_90_1
                  irpar_bt_90_2
                  top_degrad_2
                  top_degrad_1
                  _TEMG001
                  datdelhis
                  irpar_dd_1
                  irpar_dd_2
                  top_degrad_dd_2
                  top_degrad_dd_3
                  ind_dd_M0
                  ind_dd_M1
                  ind_dd_M2
                  ind_dd_M3
                  ind_dd_M4
                  ind_dd_M5
                  ind_dd_final
                  CODSEXPRS
                  CODPAY_NATIONALITE $
                  CODCMNIEE
                  CODACVECO $
                  CODSITFAM
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;


/*Donnees 2*/

data Donnees2    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'P:/ENSAI 3A/Projet_Scoring/Donnes/Extract_201911/Extract_201911.txt' delimiter = ';' MISSOVER DSD  lrecl=32767 firstobs=2 ;
         informat NUMTECPRS best32. ;
         informat TOPDD best32. ;
         informat MINSOLDE_PAR best32. ;
         informat CRTAD_AG_SOLDE_T best32. ;
         informat CRTAD_IND_0038 best32. ;
         informat CRTAD_AG_SOLDE_T1 best32. ;
         informat CRTAD_AG_SOLDE_T2 best32. ;
         informat CRTAD_AG_SOLDE_T3 best32. ;
         informat CRTAD_AG_SOLDE_T4 best32. ;
         informat CRTAD_AG_NBJDE_BC best32. ;
         informat CRTAD_AG_NBJDE_BA best32. ;
         informat CRTAD_IND_0015 best32. ;
         informat NBJDEPDP best32. ;
         informat ENCOURS_PAR best32. ;
         informat IREVENU_M1 best32. ;
         informat IREVENU_M2 best32. ;
         informat CRTAR_IND_0036 best32. ;
         informat AGEPRS best32. ;
         informat CODACVPRO best32. ;
         informat ANCIENNETE best32. ;
         informat MNTENC_PAR best32. ;
         informat CRTAD_AG_NBECR_A best32. ;
         informat RISQUE_SCORE_PAR best32. ;
         informat TOPCPTLITIG best32. ;
         informat NBJDEB3_ANN1_PAR_TR best32. ;
         informat DIFFECR_PAR_TR best32. ;
         informat NBECR_PAR best32. ;
         informat TOP_RR_t best32. ;
         informat NDB_SURV_FINAL best32. ;
         informat TYPE_FDC best32. ;
         informat CODITDAGE_PAR best32. ;
         informat TOPLS best32. ;
         informat MNTAUTCRT_PI_PAR $1. ;
         informat NBJDEPLS best32. ;
         informat top_GF best32. ;
         informat CODCNDFRG $1. ;
         informat AGE best32. ;
         informat montant_epargne best32. ;
         informat MNTTOTMVTAFFGLISS_M12 best32. ;
         informat MNTTOTMVTAFF best32. ;
         informat MNTECSCRDIMM best32. ;
         informat MNTTOTCRDCSM best32. ;
         informat epargne_res best32. ;
         informat SLDFINMMSCPT best32. ;
         informat irpar_bt_90_1 best32. ;
         informat irpar_bt_90_2 best32. ;
         informat top_degrad_2 best32. ;
         informat top_degrad_1 best32. ;
         informat _TEMG001 best32. ;
         informat datdelhis best32. ;
         informat irpar_dd_1 best32. ;
         informat irpar_dd_2 best32. ;
         informat top_degrad_dd_2 best32. ;
         informat top_degrad_dd_3 best32. ;
         informat ind_dd_M0 best32. ;
         informat ind_dd_M1 best32. ;
         informat ind_dd_M2 best32. ;
         informat ind_dd_M3 best32. ;
         informat ind_dd_M4 best32. ;
         informat ind_dd_M5 best32. ;
         informat ind_dd_final best32. ;
         informat CODSEXPRS best32. ;
         informat CODPAY_NATIONALITE $3. ;
         informat CODCMNIEE best32. ;
         informat CODACVECO $5. ;
         informat CODSITFAM best32. ;
         format NUMTECPRS best12. ;
         format TOPDD best12. ;
         format MINSOLDE_PAR best12. ;
         format CRTAD_AG_SOLDE_T best12. ;
         format CRTAD_IND_0038 best12. ;
         format CRTAD_AG_SOLDE_T1 best12. ;
         format CRTAD_AG_SOLDE_T2 best12. ;
         format CRTAD_AG_SOLDE_T3 best12. ;
         format CRTAD_AG_SOLDE_T4 best12. ;
         format CRTAD_AG_NBJDE_BC best12. ;
         format CRTAD_AG_NBJDE_BA best12. ;
         format CRTAD_IND_0015 best12. ;
         format NBJDEPDP best12. ;
         format ENCOURS_PAR best12. ;
         format IREVENU_M1 best12. ;
         format IREVENU_M2 best12. ;
         format CRTAR_IND_0036 best12. ;
         format AGEPRS best12. ;
         format CODACVPRO best12. ;
         format ANCIENNETE best12. ;
         format MNTENC_PAR best12. ;
         format CRTAD_AG_NBECR_A best12. ;
         format RISQUE_SCORE_PAR best12. ;
         format TOPCPTLITIG best12. ;
         format NBJDEB3_ANN1_PAR_TR best12. ;
         format DIFFECR_PAR_TR best12. ;
         format NBECR_PAR best12. ;
         format TOP_RR_t best12. ;
         format NDB_SURV_FINAL best12. ;
         format TYPE_FDC best12. ;
         format CODITDAGE_PAR best12. ;
         format TOPLS best12. ;
         format MNTAUTCRT_PI_PAR $1. ;
         format NBJDEPLS best12. ;
         format top_GF best12. ;
         format CODCNDFRG $1. ;
         format AGE best12. ;
         format montant_epargne best12. ;
         format MNTTOTMVTAFFGLISS_M12 best12. ;
         format MNTTOTMVTAFF best12. ;
         format MNTECSCRDIMM best12. ;
         format MNTTOTCRDCSM best12. ;
         format epargne_res best12. ;
         format SLDFINMMSCPT best12. ;
         format irpar_bt_90_1 best12. ;
         format irpar_bt_90_2 best12. ;
         format top_degrad_2 best12. ;
         format top_degrad_1 best12. ;
         format _TEMG001 best12. ;
         format datdelhis best12. ;
         format irpar_dd_1 best12. ;
         format irpar_dd_2 best12. ;
         format top_degrad_dd_2 best12. ;
         format top_degrad_dd_3 best12. ;
         format ind_dd_M0 best12. ;
         format ind_dd_M1 best12. ;
         format ind_dd_M2 best12. ;
         format ind_dd_M3 best12. ;
         format ind_dd_M4 best12. ;
         format ind_dd_M5 best12. ;
         format ind_dd_final best12. ;
         format CODSEXPRS best12. ;
         format CODPAY_NATIONALITE $3. ;
         format CODCMNIEE best12. ;
         format CODACVECO $5. ;
         format CODSITFAM best12. ;
      input
                  NUMTECPRS
                  TOPDD
                  MINSOLDE_PAR
                  CRTAD_AG_SOLDE_T
                  CRTAD_IND_0038
                  CRTAD_AG_SOLDE_T1
                  CRTAD_AG_SOLDE_T2
                  CRTAD_AG_SOLDE_T3
                  CRTAD_AG_SOLDE_T4
                  CRTAD_AG_NBJDE_BC
                  CRTAD_AG_NBJDE_BA
                  CRTAD_IND_0015
                  NBJDEPDP
                  ENCOURS_PAR
                  IREVENU_M1
                  IREVENU_M2
                  CRTAR_IND_0036
                  AGEPRS
                  CODACVPRO
                  ANCIENNETE
                  MNTENC_PAR
                  CRTAD_AG_NBECR_A
                  RISQUE_SCORE_PAR
                  TOPCPTLITIG
                  NBJDEB3_ANN1_PAR_TR
                  DIFFECR_PAR_TR
                  NBECR_PAR
                  TOP_RR_t
                  NDB_SURV_FINAL
                  TYPE_FDC
                  CODITDAGE_PAR
                  TOPLS
                  MNTAUTCRT_PI_PAR $
                  NBJDEPLS
                  top_GF
                  CODCNDFRG $
                  AGE
                  montant_epargne
                  MNTTOTMVTAFFGLISS_M12
                  MNTTOTMVTAFF
                  MNTECSCRDIMM
                  MNTTOTCRDCSM
                  epargne_res
                  SLDFINMMSCPT
                  irpar_bt_90_1
                  irpar_bt_90_2
                  top_degrad_2
                  top_degrad_1
                  _TEMG001
                  datdelhis
                  irpar_dd_1
                  irpar_dd_2
                  top_degrad_dd_2
                  top_degrad_dd_3
                  ind_dd_M0
                  ind_dd_M1
                  ind_dd_M2
                  ind_dd_M3
                  ind_dd_M4
                  ind_dd_M5
                  ind_dd_final
                  CODSEXPRS
                  CODPAY_NATIONALITE $
                  CODCMNIEE
                  CODACVECO $
                  CODSITFAM
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;


data Donnees3    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'P:/ENSAI 3A/Projet_Scoring/Donnes/Extract_201912/Extract_201912.txt' delimiter = ';' MISSOVER DSD  lrecl=32767 firstobs=2 ;
         informat NUMTECPRS best32. ;
         informat TOPDD best32. ;
         informat MINSOLDE_PAR best32. ;
         informat CRTAD_AG_SOLDE_T best32. ;
         informat CRTAD_IND_0038 best32. ;
         informat CRTAD_AG_SOLDE_T1 best32. ;
         informat CRTAD_AG_SOLDE_T2 best32. ;
         informat CRTAD_AG_SOLDE_T3 best32. ;
         informat CRTAD_AG_SOLDE_T4 best32. ;
         informat CRTAD_AG_NBJDE_BC best32. ;
         informat CRTAD_AG_NBJDE_BA best32. ;
         informat CRTAD_IND_0015 best32. ;
         informat NBJDEPDP best32. ;
         informat ENCOURS_PAR best32. ;
         informat IREVENU_M1 best32. ;
         informat IREVENU_M2 best32. ;
         informat CRTAR_IND_0036 best32. ;
         informat AGEPRS best32. ;
         informat CODACVPRO best32. ;
         informat ANCIENNETE best32. ;
         informat MNTENC_PAR best32. ;
         informat CRTAD_AG_NBECR_A best32. ;
         informat RISQUE_SCORE_PAR best32. ;
         informat TOPCPTLITIG best32. ;
         informat NBJDEB3_ANN1_PAR_TR best32. ;
         informat DIFFECR_PAR_TR best32. ;
         informat NBECR_PAR best32. ;
         informat TOP_RR_t best32. ;
         informat NDB_SURV_FINAL best32. ;
         informat TYPE_FDC best32. ;
         informat CODITDAGE_PAR best32. ;
         informat TOPLS best32. ;
         informat MNTAUTCRT_PI_PAR $1. ;
         informat NBJDEPLS best32. ;
         informat top_GF best32. ;
         informat CODCNDFRG $1. ;
         informat AGE best32. ;
         informat montant_epargne best32. ;
         informat MNTTOTMVTAFFGLISS_M12 best32. ;
         informat MNTTOTMVTAFF best32. ;
         informat MNTECSCRDIMM best32. ;
         informat MNTTOTCRDCSM best32. ;
         informat epargne_res best32. ;
         informat SLDFINMMSCPT best32. ;
         informat irpar_bt_90_1 best32. ;
         informat irpar_bt_90_2 best32. ;
         informat top_degrad_2 best32. ;
         informat top_degrad_1 best32. ;
         informat _TEMG001 best32. ;
         informat datdelhis best32. ;
         informat irpar_dd_1 best32. ;
         informat irpar_dd_2 best32. ;
         informat top_degrad_dd_2 best32. ;
         informat top_degrad_dd_3 best32. ;
         informat ind_dd_M0 best32. ;
         informat ind_dd_M1 best32. ;
         informat ind_dd_M2 best32. ;
         informat ind_dd_M3 best32. ;
         informat ind_dd_M4 best32. ;
         informat ind_dd_M5 best32. ;
         informat ind_dd_final best32. ;
         informat CODSEXPRS best32. ;
         informat CODPAY_NATIONALITE $3. ;
         informat CODCMNIEE best32. ;
         informat CODACVECO $5. ;
         informat CODSITFAM best32. ;
         format NUMTECPRS best12. ;
         format TOPDD best12. ;
         format MINSOLDE_PAR best12. ;
         format CRTAD_AG_SOLDE_T best12. ;
         format CRTAD_IND_0038 best12. ;
         format CRTAD_AG_SOLDE_T1 best12. ;
         format CRTAD_AG_SOLDE_T2 best12. ;
         format CRTAD_AG_SOLDE_T3 best12. ;
         format CRTAD_AG_SOLDE_T4 best12. ;
         format CRTAD_AG_NBJDE_BC best12. ;
         format CRTAD_AG_NBJDE_BA best12. ;
         format CRTAD_IND_0015 best12. ;
         format NBJDEPDP best12. ;
         format ENCOURS_PAR best12. ;
         format IREVENU_M1 best12. ;
         format IREVENU_M2 best12. ;
         format CRTAR_IND_0036 best12. ;
         format AGEPRS best12. ;
         format CODACVPRO best12. ;
         format ANCIENNETE best12. ;
         format MNTENC_PAR best12. ;
         format CRTAD_AG_NBECR_A best12. ;
         format RISQUE_SCORE_PAR best12. ;
         format TOPCPTLITIG best12. ;
         format NBJDEB3_ANN1_PAR_TR best12. ;
         format DIFFECR_PAR_TR best12. ;
         format NBECR_PAR best12. ;
         format TOP_RR_t best12. ;
         format NDB_SURV_FINAL best12. ;
         format TYPE_FDC best12. ;
         format CODITDAGE_PAR best12. ;
         format TOPLS best12. ;
         format MNTAUTCRT_PI_PAR $1. ;
         format NBJDEPLS best12. ;
         format top_GF best12. ;
         format CODCNDFRG $1. ;
         format AGE best12. ;
         format montant_epargne best12. ;
         format MNTTOTMVTAFFGLISS_M12 best12. ;
         format MNTTOTMVTAFF best12. ;
         format MNTECSCRDIMM best12. ;
         format MNTTOTCRDCSM best12. ;
         format epargne_res best12. ;
         format SLDFINMMSCPT best12. ;
         format irpar_bt_90_1 best12. ;
         format irpar_bt_90_2 best12. ;
         format top_degrad_2 best12. ;
         format top_degrad_1 best12. ;
         format _TEMG001 best12. ;
         format datdelhis best12. ;
         format irpar_dd_1 best12. ;
         format irpar_dd_2 best12. ;
         format top_degrad_dd_2 best12. ;
         format top_degrad_dd_3 best12. ;
         format ind_dd_M0 best12. ;
         format ind_dd_M1 best12. ;
         format ind_dd_M2 best12. ;
         format ind_dd_M3 best12. ;
         format ind_dd_M4 best12. ;
         format ind_dd_M5 best12. ;
         format ind_dd_final best12. ;
         format CODSEXPRS best12. ;
         format CODPAY_NATIONALITE $3. ;
         format CODCMNIEE best12. ;
         format CODACVECO $5. ;
         format CODSITFAM best12. ;
      input
                  NUMTECPRS
                  TOPDD
                  MINSOLDE_PAR
                  CRTAD_AG_SOLDE_T
                  CRTAD_IND_0038
                  CRTAD_AG_SOLDE_T1
                  CRTAD_AG_SOLDE_T2
                  CRTAD_AG_SOLDE_T3
                  CRTAD_AG_SOLDE_T4
                  CRTAD_AG_NBJDE_BC
                  CRTAD_AG_NBJDE_BA
                  CRTAD_IND_0015
                  NBJDEPDP
                  ENCOURS_PAR
                  IREVENU_M1
                  IREVENU_M2
                  CRTAR_IND_0036
                  AGEPRS
                  CODACVPRO
                  ANCIENNETE
                  MNTENC_PAR
                  CRTAD_AG_NBECR_A
                  RISQUE_SCORE_PAR
                  TOPCPTLITIG
                  NBJDEB3_ANN1_PAR_TR
                  DIFFECR_PAR_TR
                  NBECR_PAR
                  TOP_RR_t
                  NDB_SURV_FINAL
                  TYPE_FDC
                  CODITDAGE_PAR
                  TOPLS
                  MNTAUTCRT_PI_PAR $
                  NBJDEPLS
                  top_GF
                  CODCNDFRG $
                  AGE
                  montant_epargne
                  MNTTOTMVTAFFGLISS_M12
                  MNTTOTMVTAFF
                  MNTECSCRDIMM
                  MNTTOTCRDCSM
                  epargne_res
                  SLDFINMMSCPT
                  irpar_bt_90_1
                  irpar_bt_90_2
                  top_degrad_2
                  top_degrad_1
                  _TEMG001
                  datdelhis
                  irpar_dd_1
                  irpar_dd_2
                  top_degrad_dd_2
                  top_degrad_dd_3
                  ind_dd_M0
                  ind_dd_M1
                  ind_dd_M2
                  ind_dd_M3
                  ind_dd_M4
                  ind_dd_M5
                  ind_dd_final
                  CODSEXPRS
                  CODPAY_NATIONALITE $
                  CODCMNIEE
                  CODACVECO $
                  CODSITFAM
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;


data Donnees4    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'P:/ENSAI 3A/Projet_Scoring/Donnes/Extract_202001/Extract_202001.txt' delimiter = ';' MISSOVER DSD  lrecl=32767 firstobs=2 ;
         informat NUMTECPRS best32. ;
         informat TOPDD best32. ;
         informat MINSOLDE_PAR best32. ;
         informat CRTAD_AG_SOLDE_T best32. ;
         informat CRTAD_IND_0038 best32. ;
         informat CRTAD_AG_SOLDE_T1 best32. ;
         informat CRTAD_AG_SOLDE_T2 best32. ;
         informat CRTAD_AG_SOLDE_T3 best32. ;
         informat CRTAD_AG_SOLDE_T4 best32. ;
         informat CRTAD_AG_NBJDE_BC best32. ;
         informat CRTAD_AG_NBJDE_BA best32. ;
         informat CRTAD_IND_0015 best32. ;
         informat NBJDEPDP best32. ;
         informat ENCOURS_PAR best32. ;
         informat IREVENU_M1 best32. ;
         informat IREVENU_M2 best32. ;
         informat CRTAR_IND_0036 best32. ;
         informat AGEPRS best32. ;
         informat CODACVPRO best32. ;
         informat ANCIENNETE best32. ;
         informat MNTENC_PAR best32. ;
         informat CRTAD_AG_NBECR_A best32. ;
         informat RISQUE_SCORE_PAR best32. ;
         informat TOPCPTLITIG best32. ;
         informat NBJDEB3_ANN1_PAR_TR best32. ;
         informat DIFFECR_PAR_TR best32. ;
         informat NBECR_PAR best32. ;
         informat TOP_RR_t best32. ;
         informat NDB_SURV_FINAL best32. ;
         informat TYPE_FDC best32. ;
         informat CODITDAGE_PAR best32. ;
         informat TOPLS best32. ;
         informat MNTAUTCRT_PI_PAR $1. ;
         informat NBJDEPLS best32. ;
         informat top_GF best32. ;
         informat CODCNDFRG $1. ;
         informat AGE best32. ;
         informat montant_epargne best32. ;
         informat MNTTOTMVTAFFGLISS_M12 best32. ;
         informat MNTTOTMVTAFF best32. ;
         informat MNTECSCRDIMM best32. ;
         informat MNTTOTCRDCSM best32. ;
         informat epargne_res best32. ;
         informat SLDFINMMSCPT best32. ;
         informat irpar_bt_90_1 best32. ;
         informat irpar_bt_90_2 best32. ;
         informat top_degrad_2 best32. ;
         informat top_degrad_1 best32. ;
         informat _TEMG001 best32. ;
         informat datdelhis best32. ;
         informat irpar_dd_1 best32. ;
         informat irpar_dd_2 best32. ;
         informat top_degrad_dd_2 best32. ;
         informat top_degrad_dd_3 best32. ;
         informat ind_dd_M0 best32. ;
         informat ind_dd_M1 best32. ;
         informat ind_dd_M2 best32. ;
         informat ind_dd_M3 best32. ;
         informat ind_dd_M4 best32. ;
         informat ind_dd_M5 best32. ;
         informat ind_dd_final best32. ;
         informat CODSEXPRS best32. ;
         informat CODPAY_NATIONALITE $3. ;
         informat CODCMNIEE best32. ;
         informat CODACVECO $5. ;
         informat CODSITFAM best32. ;
         format NUMTECPRS best12. ;
         format TOPDD best12. ;
         format MINSOLDE_PAR best12. ;
         format CRTAD_AG_SOLDE_T best12. ;
         format CRTAD_IND_0038 best12. ;
         format CRTAD_AG_SOLDE_T1 best12. ;
         format CRTAD_AG_SOLDE_T2 best12. ;
         format CRTAD_AG_SOLDE_T3 best12. ;
         format CRTAD_AG_SOLDE_T4 best12. ;
         format CRTAD_AG_NBJDE_BC best12. ;
         format CRTAD_AG_NBJDE_BA best12. ;
         format CRTAD_IND_0015 best12. ;
         format NBJDEPDP best12. ;
         format ENCOURS_PAR best12. ;
         format IREVENU_M1 best12. ;
         format IREVENU_M2 best12. ;
         format CRTAR_IND_0036 best12. ;
         format AGEPRS best12. ;
         format CODACVPRO best12. ;
         format ANCIENNETE best12. ;
         format MNTENC_PAR best12. ;
         format CRTAD_AG_NBECR_A best12. ;
         format RISQUE_SCORE_PAR best12. ;
         format TOPCPTLITIG best12. ;
         format NBJDEB3_ANN1_PAR_TR best12. ;
         format DIFFECR_PAR_TR best12. ;
         format NBECR_PAR best12. ;
         format TOP_RR_t best12. ;
         format NDB_SURV_FINAL best12. ;
         format TYPE_FDC best12. ;
         format CODITDAGE_PAR best12. ;
         format TOPLS best12. ;
         format MNTAUTCRT_PI_PAR $1. ;
         format NBJDEPLS best12. ;
         format top_GF best12. ;
         format CODCNDFRG $1. ;
         format AGE best12. ;
         format montant_epargne best12. ;
         format MNTTOTMVTAFFGLISS_M12 best12. ;
         format MNTTOTMVTAFF best12. ;
         format MNTECSCRDIMM best12. ;
         format MNTTOTCRDCSM best12. ;
         format epargne_res best12. ;
         format SLDFINMMSCPT best12. ;
         format irpar_bt_90_1 best12. ;
         format irpar_bt_90_2 best12. ;
         format top_degrad_2 best12. ;
         format top_degrad_1 best12. ;
         format _TEMG001 best12. ;
         format datdelhis best12. ;
         format irpar_dd_1 best12. ;
         format irpar_dd_2 best12. ;
         format top_degrad_dd_2 best12. ;
         format top_degrad_dd_3 best12. ;
         format ind_dd_M0 best12. ;
         format ind_dd_M1 best12. ;
         format ind_dd_M2 best12. ;
         format ind_dd_M3 best12. ;
         format ind_dd_M4 best12. ;
         format ind_dd_M5 best12. ;
         format ind_dd_final best12. ;
         format CODSEXPRS best12. ;
         format CODPAY_NATIONALITE $3. ;
         format CODCMNIEE best12. ;
         format CODACVECO $5. ;
         format CODSITFAM best12. ;
      input
                  NUMTECPRS
                  TOPDD
                  MINSOLDE_PAR
                  CRTAD_AG_SOLDE_T
                  CRTAD_IND_0038
                  CRTAD_AG_SOLDE_T1
                  CRTAD_AG_SOLDE_T2
                  CRTAD_AG_SOLDE_T3
                  CRTAD_AG_SOLDE_T4
                  CRTAD_AG_NBJDE_BC
                  CRTAD_AG_NBJDE_BA
                  CRTAD_IND_0015
                  NBJDEPDP
                  ENCOURS_PAR
                  IREVENU_M1
                  IREVENU_M2
                  CRTAR_IND_0036
                  AGEPRS
                  CODACVPRO
                  ANCIENNETE
                  MNTENC_PAR
                  CRTAD_AG_NBECR_A
                  RISQUE_SCORE_PAR
                  TOPCPTLITIG
                  NBJDEB3_ANN1_PAR_TR
                  DIFFECR_PAR_TR
                  NBECR_PAR
                  TOP_RR_t
                  NDB_SURV_FINAL
                  TYPE_FDC
                  CODITDAGE_PAR
                  TOPLS
                  MNTAUTCRT_PI_PAR $
                  NBJDEPLS
                  top_GF
                  CODCNDFRG $
                  AGE
                  montant_epargne
                  MNTTOTMVTAFFGLISS_M12
                  MNTTOTMVTAFF
                  MNTECSCRDIMM
                  MNTTOTCRDCSM
                  epargne_res
                  SLDFINMMSCPT
                  irpar_bt_90_1
                  irpar_bt_90_2
                  top_degrad_2
                  top_degrad_1
                  _TEMG001
                  datdelhis
                  irpar_dd_1
                  irpar_dd_2
                  top_degrad_dd_2
                  top_degrad_dd_3
                  ind_dd_M0
                  ind_dd_M1
                  ind_dd_M2
                  ind_dd_M3
                  ind_dd_M4
                  ind_dd_M5
                  ind_dd_final
                  CODSEXPRS
                  CODPAY_NATIONALITE $
                  CODCMNIEE
                  CODACVECO $
                  CODSITFAM
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;


data Donnees5    ;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'P:/ENSAI 3A/Projet_Scoring/Donnes/Extract_202002/Extract_202002.txt' delimiter = ';' MISSOVER DSD  lrecl=32767 firstobs=2 ;
         informat NUMTECPRS best32. ;
         informat TOPDD best32. ;
         informat MINSOLDE_PAR best32. ;
         informat CRTAD_AG_SOLDE_T best32. ;
         informat CRTAD_IND_0038 best32. ;
         informat CRTAD_AG_SOLDE_T1 best32. ;
         informat CRTAD_AG_SOLDE_T2 best32. ;
         informat CRTAD_AG_SOLDE_T3 best32. ;
         informat CRTAD_AG_SOLDE_T4 best32. ;
         informat CRTAD_AG_NBJDE_BC best32. ;
         informat CRTAD_AG_NBJDE_BA best32. ;
         informat CRTAD_IND_0015 best32. ;
         informat NBJDEPDP best32. ;
         informat ENCOURS_PAR best32. ;
         informat IREVENU_M1 best32. ;
         informat IREVENU_M2 best32. ;
         informat CRTAR_IND_0036 best32. ;
         informat AGEPRS best32. ;
         informat CODACVPRO best32. ;
         informat ANCIENNETE best32. ;
         informat MNTENC_PAR best32. ;
         informat CRTAD_AG_NBECR_A best32. ;
         informat RISQUE_SCORE_PAR best32. ;
         informat TOPCPTLITIG best32. ;
         informat NBJDEB3_ANN1_PAR_TR best32. ;
         informat DIFFECR_PAR_TR best32. ;
         informat NBECR_PAR best32. ;
         informat TOP_RR_t best32. ;
         informat NDB_SURV_FINAL best32. ;
         informat TYPE_FDC best32. ;
         informat CODITDAGE_PAR best32. ;
         informat TOPLS best32. ;
         informat MNTAUTCRT_PI_PAR $1. ;
         informat NBJDEPLS best32. ;
         informat top_GF best32. ;
         informat CODCNDFRG $1. ;
         informat AGE best32. ;
         informat montant_epargne best32. ;
         informat MNTTOTMVTAFFGLISS_M12 best32. ;
         informat MNTTOTMVTAFF best32. ;
         informat MNTECSCRDIMM best32. ;
         informat MNTTOTCRDCSM best32. ;
         informat epargne_res best32. ;
         informat SLDFINMMSCPT best32. ;
         informat irpar_bt_90_1 best32. ;
         informat irpar_bt_90_2 best32. ;
         informat top_degrad_2 best32. ;
         informat top_degrad_1 best32. ;
         informat _TEMG001 best32. ;
         informat datdelhis best32. ;
         informat irpar_dd_1 best32. ;
         informat irpar_dd_2 best32. ;
         informat top_degrad_dd_2 best32. ;
         informat top_degrad_dd_3 best32. ;
         informat ind_dd_M0 best32. ;
         informat ind_dd_M1 best32. ;
         informat ind_dd_M2 best32. ;
         informat ind_dd_M3 best32. ;
         informat ind_dd_M4 best32. ;
         informat ind_dd_M5 best32. ;
         informat ind_dd_final best32. ;
         informat CODSEXPRS best32. ;
         informat CODPAY_NATIONALITE $3. ;
         informat CODCMNIEE best32. ;
         informat CODACVECO $5. ;
         informat CODSITFAM best32. ;
         format NUMTECPRS best12. ;
         format TOPDD best12. ;
         format MINSOLDE_PAR best12. ;
         format CRTAD_AG_SOLDE_T best12. ;
         format CRTAD_IND_0038 best12. ;
         format CRTAD_AG_SOLDE_T1 best12. ;
         format CRTAD_AG_SOLDE_T2 best12. ;
         format CRTAD_AG_SOLDE_T3 best12. ;
         format CRTAD_AG_SOLDE_T4 best12. ;
         format CRTAD_AG_NBJDE_BC best12. ;
         format CRTAD_AG_NBJDE_BA best12. ;
         format CRTAD_IND_0015 best12. ;
         format NBJDEPDP best12. ;
         format ENCOURS_PAR best12. ;
         format IREVENU_M1 best12. ;
         format IREVENU_M2 best12. ;
         format CRTAR_IND_0036 best12. ;
         format AGEPRS best12. ;
         format CODACVPRO best12. ;
         format ANCIENNETE best12. ;
         format MNTENC_PAR best12. ;
         format CRTAD_AG_NBECR_A best12. ;
         format RISQUE_SCORE_PAR best12. ;
         format TOPCPTLITIG best12. ;
         format NBJDEB3_ANN1_PAR_TR best12. ;
         format DIFFECR_PAR_TR best12. ;
         format NBECR_PAR best12. ;
         format TOP_RR_t best12. ;
         format NDB_SURV_FINAL best12. ;
         format TYPE_FDC best12. ;
         format CODITDAGE_PAR best12. ;
         format TOPLS best12. ;
         format MNTAUTCRT_PI_PAR $1. ;
         format NBJDEPLS best12. ;
         format top_GF best12. ;
         format CODCNDFRG $1. ;
         format AGE best12. ;
         format montant_epargne best12. ;
         format MNTTOTMVTAFFGLISS_M12 best12. ;
         format MNTTOTMVTAFF best12. ;
         format MNTECSCRDIMM best12. ;
         format MNTTOTCRDCSM best12. ;
         format epargne_res best12. ;
         format SLDFINMMSCPT best12. ;
         format irpar_bt_90_1 best12. ;
         format irpar_bt_90_2 best12. ;
         format top_degrad_2 best12. ;
         format top_degrad_1 best12. ;
         format _TEMG001 best12. ;
         format datdelhis best12. ;
         format irpar_dd_1 best12. ;
         format irpar_dd_2 best12. ;
         format top_degrad_dd_2 best12. ;
         format top_degrad_dd_3 best12. ;
         format ind_dd_M0 best12. ;
         format ind_dd_M1 best12. ;
         format ind_dd_M2 best12. ;
         format ind_dd_M3 best12. ;
         format ind_dd_M4 best12. ;
         format ind_dd_M5 best12. ;
         format ind_dd_final best12. ;
         format CODSEXPRS best12. ;
         format CODPAY_NATIONALITE $3. ;
         format CODCMNIEE best12. ;
         format CODACVECO $5. ;
         format CODSITFAM best12. ;
      input
                  NUMTECPRS
                  TOPDD
                  MINSOLDE_PAR
                  CRTAD_AG_SOLDE_T
                  CRTAD_IND_0038
                  CRTAD_AG_SOLDE_T1
                  CRTAD_AG_SOLDE_T2
                  CRTAD_AG_SOLDE_T3
                  CRTAD_AG_SOLDE_T4
                  CRTAD_AG_NBJDE_BC
                  CRTAD_AG_NBJDE_BA
                  CRTAD_IND_0015
                  NBJDEPDP
                  ENCOURS_PAR
                  IREVENU_M1
                  IREVENU_M2
                  CRTAR_IND_0036
                  AGEPRS
                  CODACVPRO
                  ANCIENNETE
                  MNTENC_PAR
                  CRTAD_AG_NBECR_A
                  RISQUE_SCORE_PAR
                  TOPCPTLITIG
                  NBJDEB3_ANN1_PAR_TR
                  DIFFECR_PAR_TR
                  NBECR_PAR
                  TOP_RR_t
                  NDB_SURV_FINAL
                  TYPE_FDC
                  CODITDAGE_PAR
                  TOPLS
                  MNTAUTCRT_PI_PAR $
                  NBJDEPLS
                  top_GF
                  CODCNDFRG $
                  AGE
                  montant_epargne
                  MNTTOTMVTAFFGLISS_M12
                  MNTTOTMVTAFF
                  MNTECSCRDIMM
                  MNTTOTCRDCSM
                  epargne_res
                  SLDFINMMSCPT
                  irpar_bt_90_1
                  irpar_bt_90_2
                  top_degrad_2
                  top_degrad_1
                  _TEMG001
                  datdelhis
                  irpar_dd_1
                  irpar_dd_2
                  top_degrad_dd_2
                  top_degrad_dd_3
                  ind_dd_M0
                  ind_dd_M1
                  ind_dd_M2
                  ind_dd_M3
                  ind_dd_M4
                  ind_dd_M5
                  ind_dd_final
                  CODSEXPRS
                  CODPAY_NATIONALITE $
                  CODCMNIEE
                  CODACVECO $
                  CODSITFAM
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;

DATA DonneesFinales;
SET Donnees1 Donnees2 Donnees3 Donnees4 Donnees5;
RUN;

/*libname sasref "P:/ENSAI 3A/Projet_Scoring/Donnes";
proc copy in=work out=sasref;
run;
libname sasref;
*/


PROC CONTENTS data= Donnees_Finales;

/*PROC EXPORT DATA=Donnees_Finales
OUTFILE=filename| OUTTABLE=table-name
<DBMS=identifier> <REPLACE>;
*/

/*Statistique descriptive*/

proc datasets library= DonneesFinales details;
run;

/* 1 correction doublons*/

proc sort data=DonneesFinales out= Donnees_Doublons nodupkey;
by NUMTECPRS DATDELHIS ;
run;

/* Pas de doublons */


/* 2 stat des*/
proc freq data=DonneesFinales;
table TOP_DEGRAD_2 ;
run;

proc freq data=DonneesFinales; /*Est ce que le score se dégrade entre aujourd'hui et 6 mois*/
table TOP_DEGRAD_1 ;
run;

proc freq data=DonneesFinales;
table top_degrad_dd_2 ; /* Moins de clients dégradés qu'en Degdrad 1.*/
run;

proc freq data=DonneesFinales;
table top_degrad_dd_3 ;
run;

proc freq data=DonneesFinales; /*Variables*/
table ind_dd_final ; /* Est ce qu'il est tombé au moins une fois en défaut en 6 mois*/
run; /* 249 valeurs manquantes*/


/*variables d'intérets TOP_DEGRAD_1 top_degrad_dd_3 ind_dd_final*/

/* 3 Tester la stabilité de  ind_dd_final en fonction de DATDELHIS */

proc freq data=DonneesFinales;
table ind_dd_final*DATDELHIS ;
run;


proc freq data = DonneesFinales;
tables ind_dd_final*DATDELHIS  /out=ind_dd_final_Datdelhis ;
run;

proc freq data = DonneesFinales ;
tables ind_dd_final*DATDELHIS / nofreq nocum  norow out=ind_dd_final_Datdelhis;
run;


/*Catégorie SCP*/

proc freq data = DonneesFinales ;
tables CODACVPRO;
run;


/* Regrouper les Catégorie SCP par code INSEE*/


/*
Code Libellé
1 Agriculteurs exploitants
2 Artisans, commerçants et chefs d'entreprise
3 Cadres et professions intellectuelles supérieures
4 Professions Intermédiaires
5 Employés
6 Ouvriers
7 Retraités
8 Autres personnes sans activité professionnelle

*/
data DonneesFinales;
set DonneesFinales ;
CODACVPRO2 = substr(compress(CODACVPRO),1,1);
run;

proc freq data = DonneesFinales ;
tables CODACVPRO2;
run;


proc freq data = DonneesFinales ;
tables ind_dd_final*DATDELHIS / nofreq nocum  norow out=ind_dd_final_Datdelhis;
run;

/* Recoder l'age*/
proc univariate data = DonneesFinales ;
 VAR AGEPRS;
run;

data DonneesFinales;
set DonneesFinales ;
If AGEPRS<18 then AGE_T1 = "<= 18 ans";
If AGEPRS<25  then AGE_T1 = "]18 - 25 ans]";
If AGEPRS<30 then AGE_T1 = "]25 - 30 ans]";
If AGEPRS<40 then AGE_T1= "]30 - 40 ans]";
If AGEPRS<50 then AGE_T1 = "]40 - 50 ans]";
If AGEPRS<60 then AGE_T1 = "]50 - 60 ans]";
If AGEPRS>60then AGE_T1 = "> 60 ans";
run;


proc format;
value classAge
low - 18 = 'Moins de 18 ans '
18 - 25 = ' 18-25 ans '
25 - 35 = ' 25-35 ans '
35 - 50 = ' 35 - 65 ans '
50 - 65 = ' 50 - 65 ans '
65-high= ' Retraité';
Run;

Data DonneesFinales;
	set DonneesFinales;
	classAge=AGEPRS;
	format classAge classAge. ;
Run;



proc freq data = DonneesFinales;
	tables classAge;
run;

proc freq data = DonneesFinales ;
tables classAge*CODACVPRO2;
run;

proc freq data = DonneesFinales ;
	tables classAge*CODACVPRO2;
run;

/*Valeurs manquantes*/

%macro missing_value(variable = );
title " Taux de NR % pour la variable : &variable.";
proc freq data = DonneesFinales;
tables &variable. /out=miss_&variable. nofreq nocum norow nocol;
run;
title;
%mend;


/*CODPAY_NATIONALITE
CODCMNIEE
CODACVECO
CODSITFAM
*/




%missing_value(variable=CODSEXPRS);
%missing_value(variable=CODPAY_NATIONALITE);


proc univariate data = DonneesFinales ;
 VAR AGEPRS;
run;

/*Histogramme*/
proc univariate data = DonneesFinales ;
 VAR MONTANT_EPARGNE;
run;

/*Formatage de l'âge*/

proc format;
	value classAge
	 low - 18 = 'Moins de 18 ans ' 
     18 - 25 = ' 18-25 ans ' 
	 25 - 35 = ' 25-35 ans ' 
     35 - 50 = ' 35 - 65 ans  '
     50 - 65 = ' 50 - 65 ans  '
	 65-high= ' Retraité';
Run;

Data DonneesFinales;
	set DonneesFinales;
	classAge=age;
	 format classAge classAge. ;
Run;

Proc freq data=Data0;
	table classAge;
Run;

Proc freq data=DonneesFinales;
	table classAge*codacvpro2;
Run;

/*Croiser la situation famillliale avec la situation dans le logment*/

/*Revenu situation familliale*/

/*Semaine pro : nettoyer la base, spliter*/


/*Echantilloner écchantillon aléatoire stratitifié 80-20% */

/*Variable Toddegrad_dd3*/

PROC SORT DATA = DonneesFinales;
BY top_degrad_dd_3;
RUN;

/*PROC SERVEYSELECT DATA = DonneesFinales
METHOD = SRS
OUT = echantillon
OUTALL SAMPRATE = 0.8
SEED = 123;
STRATA top_degrad_dd_3;
RUN
*/

PROC SURVEYSELECT 
      DATA = DonneesFinales
      OUT = echantillon OUTALL
      SAMPRATE = 0.8 ;
    STRATA top_degrad_dd_3 ;
 RUN ;


data train;
set echantillon;
if Selected=1;
run;



data test;
set echantillon;
if Selected=0;
run;


 Proc freq data = echantillon;
 tables top_degrad_dd_3*CODACVPRO/chisq;
 ods output onewayfreqs = CHI21;
 run;

 Proc freq data = echantillon;
 tables top_degrad_dd_3 * ( CODITDAGE_PAR CODACVPRO RISQUE_SCORE_PAR TOP_GF CODSEXPRS CODPAY_NATIONALITE CODSITFAM)/chisq;
 output out = CHI2;
 run;

data CHI2;
set CHI2 ;

run;


 /*DATA Test_chi_deux;
 set Test_chi_deux;
 T_Tschprow = (sqrt(_PCHI_/N)/sqrt(DF_PCHI)));
 rename _pchi_ = KHI_DEUX df_pchi = DF P_PCHI= PVALUE;
 run;
 */

 proc datasets library= CHI2 details;
run;




Data Test_chi_deux;
set Test_chi_deux ;
T_Tschuprow=(sqrt((_PCHI_/N)/sqrt(DF_PCHI))) ;
rename _pchi_= KHI_DEUX df_pchi=DF P_PCHI=PVALUE;
run;

 ods html file = "C:\RESULTATS_chi2.html";
 Proc print Test_chi_deux;
 ods html close

ods html file=  "P:/ENSAI 3A/Projet_Scoring/RESULTAT_CHI2.xls ";
Proc print data=Chi2bis ; run;
ods html close;

ods html file=  "P:/ENSAI 3A/Projet_Scoring/RESULTAT_CHI2";
Proc print data=Test_chi_deux ; run;
ods html close;

/*Reprise*/

ODS OUTPUT CHISQ = CHI2 ;
proc freq data=train; 
 tables top_degrad_dd_3 * ( CODITDAGE_PAR CODACVPRO RISQUE_SCORE_PAR TOP_GF CODSEXPRS CODPAY_NATIONALITE CODSITFAM)/chisq;
run; 

Data CHI2bis; 
set CHI2 ; 
T_Tschuprow=(sqrt((value/65536)/sqrt(DF))) ;
rename value=KHI_DEUX DF=DF prob=PVALUE;
run;

/*Le khi deux sensible au nombre de DDL, le V de cramer est moins, le T de shupro ne l'est pas. ON peu classer les 
liasons par le T de Shupro*/

/*variable quanti
MINSOLDE_PAR
CRTAD_AG_SOLDE_T
CRTAD_IND_0038
CRTAD_AG_SOLDE_T1
CRTAD_AG_NBJDE_BA
TYPE_FDC
CRTAD_AG_SOLDE_T2
CRTAD_AG_SOLDE_T3
CRTAD_AG_SOLDE_T4
CRTAD_AG_NBJDE_BC
CRTAD_IND_0015
NBJDEPDP

*/
ODS OUTPUT kruskalWalis = kruskal;
PROC NPAR1WAY WILCOXON data = train CORRECT = no;
Class top_degrad_dd_3;
OUTPUT OUT=kruskal;
VAR CRTAD_AG_SOLDE_T
CRTAD_IND_0038
CRTAD_AG_SOLDE_T1
CRTAD_AG_NBJDE_BA
TYPE_FDC
CRTAD_AG_SOLDE_T2
CRTAD_AG_SOLDE_T3
CRTAD_AG_SOLDE_T4
CRTAD_AG_NBJDE_BC
CRTAD_IND_0015
NBJDEPDP;
RUN;


DATA kruskal (keep = variable cVlaue1 nValue1); 
SET kruskal; where name1 = '_KW_';
RUN;

PROC SORT DATA = kruskal;
BY DESCENDING CODITDAGE_PAR;
ods html file = "P:/ENSAI 3A/Projet_Scoring/RESULTAT_KW.XLS";

PROC PRINT DATA = kruskal;
RUN;
ods html close;

PROC ANOVA DATA = train;
CLASS top_degrad_dd_3;
MODEL top_degrad_dd_3 = MINSOLDE_PAR;
RUN;

/*ANALYSE DE CORELATION*/

/*PROC CORR DATA = train PEARSON SPEARMAN OUTP = pearson OUTS = spearman
NOPRINT;
VAR CRTAD_AG_SOLDE_T
CRTAD_IND_0038
CRTAD_AG_SOLDE_T1
CRTAD_AG_NBJDE_BA
TYPE_FDC
CRTAD_AG_SOLDE_T2
CRTAD_AG_SOLDE_T3
CRTAD_AG_SOLDE_T4
CRTAD_AG_NBJDE_BC
CRTAD_IND_0015 ;
RUN;
*/

PROC CORR DATA = train PEARSON SPEARMAN OUTP = pearson OUTS = spearman
NOPRINT;
VAR MINSOLDE_PAR
CRTAD_AG_SOLDE_T
CRTAD_IND_0038
CRTAD_AG_SOLDE_T1
CRTAD_AG_NBJDE_BA
TYPE_FDC
CRTAD_AG_SOLDE_T2
CRTAD_AG_SOLDE_T3
CRTAD_AG_SOLDE_T4
CRTAD_AG_NBJDE_BC
CRTAD_IND_0015
NBJDEPDP
ANCIENNETE
AGEPRS
IREVENU_M1
IREVENU_M2
ENCOURS_PAR
NBECR_PAR
CRTAD_AG_NBECR_A
AGE
MONTANT_EPARGNE
MNTTOTMVTAFFGLISS_M12
MNTTOTMVTAFF
MNTECSCRDIMM
MNTTOTCRDCSM
EPARGNE_RES
SLDFINMMSCPT;
RUN;
PROC PRINT DATA = pearson;
RUN;

DATA pearson (DROP = _TYPE_ RENAME = (_NAME_ = variable1));
SET pearson;
WHERE _TYPE_ = "CORR";
RUN;

PROC PRINT DATA = pearson;
RUN;


PROC TRANSPOSE DATA = pearson NAME = variable2 PREFIX = correlation OUT = pearson;
VAR MINSOLDE_PAR
CRTAD_AG_SOLDE_T
CRTAD_IND_0038
CRTAD_AG_SOLDE_T1
CRTAD_AG_NBJDE_BA
TYPE_FDC
CRTAD_AG_SOLDE_T2
CRTAD_AG_SOLDE_T3
CRTAD_AG_SOLDE_T4
CRTAD_AG_NBJDE_BC
CRTAD_IND_0015
NBJDEPDP 
ANCIENNETE
AGEPRS
IREVENU_M1
IREVENU_M2
ENCOURS_PAR
NBECR_PAR
CRTAD_AG_NBECR_A
AGE
MONTANT_EPARGNE
MNTTOTMVTAFFGLISS_M12
MNTTOTMVTAFF
MNTECSCRDIMM
MNTTOTCRDCSM
EPARGNE_RES
SLDFINMMSCPT;
BY variable2 NOTSORTED;
RUN;

PROC PRINT DATA = pearson;
RUN;

DATA pearson;
SET pearson;
WHERE variable1<variable2;
abscorrelation = ABS(correlation1);


PROC SORT DATA = pearson;
BY DESCENDING abscorrelation;

ods html file = "P:/ENSAI 3A/Projet_Scoring/RESULTAT_pearson.xls";
PROC PRINT DATA = pearson;
RUN;
ods html close;

/* VARIABLES QUALI*/
ODS output Chisq = CRAMER;

PROC freq data = train;
tables top_degrad_dd_3 * (CODITDAGE_PAR
CODSEXPRS
CODPAY_NATIONALITE
CODACVPRO
CODACVECO
CODSITFAM
RISQUE_SCORE_PAR
TOP_GF
TOPCPTLITIG)/chisq; run;



DATA CRAMER (keep = table value prob);
set CRAMER;
Where statistic = "V de Cramer";
RUN;

PROC SORT DATA = work.CRAMER;
BY DESCENDING value; 
RUN;

ods html file = "P:/ENSAI_3A/Projet_Scoring/RESULTAT_CRAMER2.xlsx";
PROC PRINT data = CRAMER;
RUN;

ods html close;

proc transpose data=work.CRAMER
               out=work.CRAMER_transposed;
run;

/*Decoupage des variables*/
PROC RANK DATA = train GROUPE = 20 OUT = quantiles;
VAR IREVENU_M1
AGEPRS
MONTANT_EPARGNE
CRTAD_AG_NBJDE_BA
CRTAD_AG_SOLDE_T1;
RANKS dIREVENU_M1
dAGEPRS
dMONTANT_EPARGNE
dCRTAD_AG_NBJDE_BA
dCRTAD_AG_SOLDE_T1;
RUN;


PROC MEANS DATA = quantiles MIN MAX;
CLASS dIREVENU_M1;
VAR IREVENU_M1;
RUN;

PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * (dIREVENU_M1) / CHISQ;
RUN;


proc format;
value classdIREVENU
2 - 6 = 'R1'
7 - 12 = 'R2'
13 - 19 = 'R3';
Run;

Data quantiles2;
	set quantiles;
	classdIREVENU=dIREVENU;
	format classdIREVENU classdIREVENU. ;
Run;


FORMAT dIREVENU classdIREVENU. ;

PROC FREQ DATA = quantiles;
tables top_degrad_dd_3 * (dIREVENU) / CHISQ;
RUN;


PROC FREQ DATA = quantiles;
FORMAT dIREVENU classdIREVENU. ;
tables top_degrad_dd_3 * dIREVENU / CHISQ;
RUN;


data tabledescretise;
set quantiles;
If dIREVENU_M1>=14 then revenudiscret = 'Riche';
If dIREVENU_M1>=8 and dIREVENU_M1=<13 then revenudiscret = "Moyen";
If dIREVENU_M1>=2 and dIREVENU_M1=<7 then revenudiscret = "Pauvre";
run;



PROC FREQ DATA = tabledescretise;
tables top_degrad_dd_3 * (revenudiscret) ;
RUN;

/*Faire le V de Cramer*/


/*Continuer à discrétiser les variables les plus corrélés à la variable d'intérêt*/


/*Continuer à discrétiser les variables les plus corrélés à la variable d'intérêt*/

/*Vérifier la stabilité temporelle des variables discrétisés*/

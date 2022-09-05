
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

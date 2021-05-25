* DO FILE: "SKILL DISPERSION AND TRADE FLOWS"

* Start Log file
log using "Skill_Disp_and_Trade_log.smcl", replace

clear 
set more off, permanently
set memory 500m
use "Skill_Disp_and_Trade_DATA.dta"

**********
* Figure 1
**********
sort exporter Qindustry
gen x = 1 if exporter!=exporter[_n-1]
twoway (scatter ExIALSbar ExIALSsd if x==1, sort mlabel(exporter)), title(Mean and Dispersion in IALS scores)
drop x 

*********
* Table 2
*********
sort exporter Qindustry
gen x = 1 if exporter!=exporter[_n-1]
sort x ExIALScv
gen RExIALScv = _n if x==1 & ExIALScv!=.
sort x ExIALSbar
gen RExIALSbar = 20 - _n if x==1
sort x ExIALSsd
gen RExIALSsd = _n if x==1
sort x ExIALSressd
gen RExIALSressd = _n if x==1
table exporter if x==1, contents(mean ExIALScv mean RExIALScv mean ExIALSbar mean RExIALSbar)
table exporter if x==1, contents(mean ExIALSsd mean RExIALSsd mean ExIALSressd mean RExIALSressd)
drop RExIALScv RExIALSbar RExIALSsd RExIALSressd
drop x

*********
* Table 3
*********
sort Qindustry
gen x = 1 if Qindustry!=Qindustry[_n-1]
sort x Rrsdragec 
table Qindustry if x==1, contents(mean Rrsdragec mean R2Qcontact m R2Qteam m R2Qcomm m R2Qimpact)
drop x

**********
* Table A1
**********
sort Qindustry
gen x = 1 if Qindustry!=Qindustry[_n-1]
pwcorr cvwagec rsdragec Qcontact50 Qcomm50 Qimpact50 Qteam50 if x==1, sig
drop x

**********
* Table A5
**********
* Exporter-Importer-Industry variables
sum dexports lnexports 
* Exporter-specific variables
sort exporter 
gen x = 1 if exporter!=exporter[_n-1]
sum ExIALSn955 ExIALSbar Exat_kap Exat_hk Exproc Exdays Excost_gni_cap ExQc LaborRig if x==1
drop x
* Exporter's regulation costs
sort exporter Exproc
gen x = 1 if exporter!=exporter[_n-1]
sum Exproc Exdays Excost_gni_cap if x==1
drop x
* Importer's regulations costs
sort importer
gen x = 1 if importer!=importer[_n-1]
sum Improc Imdays Imcost_gni_cap if x==1
drop x
* Exporter-Importer-specific variables
sort exporter importer
gen x = 1 if exporter==exporter[_n+1] & importer!=importer[_n-1]
sum common_lang- n_landlock if x==1
drop x
* Industry-specific variables
sort Qindustry
gen x = 1 if Qindustry!=Qindustry[_n-1]
sum Qskill1 Qcapital Qtopcode Qdiff if x==1
drop x

***********
* Figure A1
***********

* Statistics Canada provided the IALS microdata used in this paper in a file called ials98-96-94cd.zip
* Please contact Statistics Canada to find out how to obtain access to these data. 
* Alternatively, the file ials98-96-94cd.zip might also be available through University libraries or other sources
* Using IALSALL.DAT contained in ials98-96-94cd.zip, the following code generates Figure A1
*clear
*set more off
*infix cntrid 1-2 weight 442-463 prose1 1126-1133 doc1 1166-1173 quant1 1206-1213 using "IALSALL.DAT", clear
*gen exporter = ""
*replace exporter="BEL" if cntrid==16
*replace exporter="CAN" if cntrid==1
*replace exporter="CAN" if cntrid==2
*replace exporter="CHL" if cntrid==29
*replace exporter="CZE" if cntrid==21
*replace exporter="DNK" if cntrid==23
*replace exporter="FIN" if cntrid==24
*replace exporter="DEU" if cntrid==5
*replace exporter="HUN" if cntrid==25
*replace exporter="IRL" if cntrid==7
*replace exporter="ITA" if cntrid==17
*replace exporter="NLD" if cntrid==8
*replace exporter="NZL" if cntrid==13
*replace exporter="NOR" if cntrid==18
*replace exporter="POL" if cntrid==9
*replace exporter="SVN" if cntrid==20
*replace exporter="CHE" if cntrid==4
*replace exporter="CHE" if cntrid==3
*replace exporter="CHE" if cntrid==22
*replace exporter="SWE" if cntrid==11
*replace exporter="UK" if cntrid==14
*replace exporter="UK" if cntrid==15
*replace exporter="USA" if cntrid==6
*gen w = round(weight)
*gen score = (doc1 + prose1 + quant1)/3

*local exporters "BEL CAN CHE CHL CZE DEU DNK FIN HUN IRL ITA NLD NOR NZL POL SVN SWE UK"
*foreach x of local exporters {
*	kdensity score if exporter=="USA" [fweight = w], kernel(gaussian) note(" ")text(0.01 211 "World" "1st quintile", place(w) size(small)) text(0.01 340 "World" "5th quintile", place(e) size(small))  xline (221.4, lpattern(dash)) xline(319.5, lpattern(dash))yscale(range(0.011)) bwidth(5) ylabel(none) xtitle("IALS score") addplot((kdensity score if exporter=="`x'" [fweight = w], kernel(gaussian) title(" ") lwidth(thick) bwidth(5) lcolor(black))) legend(order(1 "USA" 2 "`x'") rows(1) size(small)) saving(`x',replace)
*		 }
*graph combine "BEL" "CAN" "CHE" "CHL" "CZE" "DEU" "DNK" "FIN" "HUN" "IRL" "ITA" "NLD" "NOR" "NZL" "POL" "SVN" "SWE" "UK", xcommon ycommon rows(6) cols(3) imargin(vsmall) xsize(7) ysize(10) note("Kernel density estimation (kernel= gaussian, bandwidth = 5)")

***********
* Figure A2
***********

* First: read file containing merged measures of dispersion for the US and Canada
* Details on the construction of the Canadian dispersion measures are available upon request
clear
set more off
set mem 100m
use TableA2.dta, clear

* Second: Plot US dispersion rankings based on RSDRAGEC (residual standard deviation for the US) versus Canada residual dispersion rankings based on wageres6STD
*generate ranks
egen rankwageres6STD=rank(wageres6STD), field
egen rankrsdragec43=rank(rsdragec43), field

twoway (scatter rankwageres6STD rankrsdragec43, mlabel(naics_43)  mlabangle(325) mlabsize(vsmall) mlabgap(-5) xlabel(0(2)20) ylabel(0(2)20) legend(off) xtitle("US S.D.") ytitle("Canada S.D.") text( 2 12.5  "Intercept  3.82 (2.16)" "Slope       0.60 (0.20)" , place(se) box just(left) margin(l+0.5 t+1 b+1) width(35) )) (lfit  rankwageres6STD rankrsdragec43)
graph save STD2rank, replace


******************************************
* Interactions for the REGRESSION ANALYSIS
******************************************

clear 
set more off, permanently
set memory 500m
use "Skill_Disp_and_Trade_DATA.dta"

* STANDARDIZE VARIABLES
* The objective is to evaluate the quantitative significance of the interactions of interest.
* standardize all variables to a zero mean and std dev of one.
for var lnexports ExIALSbar- cshare5: egen X_b = std(X) 

* In order to ensure that the following interactions only involve variables that have been normalized,
* we drop everything that has not been normalized so far
keep *_b exporter importer Qindustry dexports 

* Gen INTERACTION VARIABLES for the regressions.

* Log scores and wages (raw)
for any Rsdwagec Rwagec955 Rwagecmd: gen ExIALSsd_x_X = ExIALSsd_b * X_b
for any Rsdwagec Rwagec955 Rwagecmd: gen ExIALS955_x_X = ExIALS955_b * X_b
for any Rsdwagec Rwagec955 Rwagecmd: gen ExIALSmd_x_X = ExIALSmd_b * X_b

* Normalized log scores and wages (raw)
for any Rcvwagec Rwagecn955 Rwagecnmd: gen ExIALScv_x_X = ExIALScv_b * X_b
for any Rcvwagec Rwagecn955 Rwagecnmd: gen ExIALSn955_x_X = ExIALSn955_b * X_b
for any Rcvwagec Rwagecn955 Rwagecnmd: gen ExIALSnmd_x_X = ExIALSnmd_b * X_b

* Log residual scores and residual wage dispersion
for any Rrsdragec Rrragec955 Rrragecmd : gen ExIALSressd_x_X = ExIALSressd_b * X_b
for any Rrsdragec Rrragec955 Rrragecmd : gen ExIALSres955_x_X = ExIALSres955_b * X_b
for any Rrsdragec Rrragec955 Rrragecmd : gen ExIALSresmd_x_X = ExIALSresmd_b * X_b

* Onet variables with residual skill dispersion
for any Ronet R2Qteam R2Qimpact R2Qcomm R2Qcontact : gen ExIALSressd_x_X = ExIALSressd_b * X_b
for any Ronet R2Qteam R2Qimpact R2Qcomm R2Qcontact : gen ExIALSres955_x_X = ExIALSres955_b * X_b
for any Ronet R2Qteam R2Qimpact R2Qcomm R2Qcontact : gen ExIALSresmd_x_X = ExIALSresmd_b * X_b

* Exporter IALS, physical and human capital abundance and factor intensity
gen Exat_kap_x_Qcapital = Exat_kap_b * Qcapital_b
gen Exat_hk_x_Qskill1 = Exat_hk_b * Qskill1_b

* Additional interactions:
* (i) IALS and Top-code
for any ExIALScv ExIALSn955 ExIALSnmd ExIALSres955 ExIALSressd ExIALSresmd: gen X_x_Qtopcode = X_b * Qtopcode_b
* (ii) IALS and H-O interaction
for any ExIALScv ExIALSn955 ExIALSnmd ExIALSres955 ExIALSressd ExIALSresmd: gen X_x_Qcapital = X_b * Qcapital_b
for any ExIALScv ExIALSn955 ExIALSnmd ExIALSres955 ExIALSressd ExIALSresmd: gen X_x_Qskill1 = X_b * Qskill1_b
for any Rcvwagec Rwagecn955 Rwagecnmd Rrsdragec Rrragec955 Rrragecmd : gen Exat_kap_x_X = Exat_kap_b * X_b
for any Rcvwagec Rwagecn955 Rwagecnmd Rrsdragec Rrragec955 Rrragecmd : gen Exat_hk_x_X = Exat_hk_b * X_b
* (iii) IALS mean and wage inequality
for any Rcvwagec Rwagecn955 Rwagecnmd Rrsdragec Rrragec955 Rrragecmd: gen ExIALSbar_x_X = ExIALSbar_b * X_b
* (iv) IALS mean and mean wages
gen ExIALSbar_x_Rwbar = ExIALSbar_b * Rwagecbar_b
* (v) Mean score and unnormalized raw wage dispersion
for any Rsdwagec Rwagec955 Rwagecmd: gen ExIALSbar_x_X = ExIALSbar_b * X_b
* (vi) Unnormalized raw score dispersion and mean wages
for any ExIALSsd ExIALS955 ExIALSmd: gen X_x_Rwbar = X_b * Rwagecbar_b
* (vii) Quality of the judicial system (Nunn) and Labor Law Rigidity (Tang)
for any Rrsdragec Rrragec955 Rrragecmd Ronet: gen ExLaborR_x_X = LaborRig_b * X_b
gen ExQc_x_Qdiff = ExQc_b * Qdiff_b
* (viii) For table A-3
gen ExIALSbar_x_Qskill1 = ExIALSbar_b * Qskill1_b
* (ix) GM test interactions: Predicted IALS variation * predicted wage disp and residual wage disp (2 alternative proxies for lambda)
for any Rrsdragec Ronet : gen ExIALSprecv_x_X = ExIALSprecv_b * X_b
for any Rrragec955 Ronet : gen ExIALSpren955_x_X = ExIALSpren955_b * X_b
for any Rrragecmd Ronet : gen ExIALSprenmd_x_X = ExIALSprenmd_b * X_b
* (x) Generate bilateral entry costs indicators - Data from Helpman et al (QJE 2008)
gen int_hmr_cost =  Excost_gni_cap_b * Imcost_gni_cap_b
gen int_hmr_days = Imdays_b * Exdays_b
gen int_hmr_proc = Improc_b * Exproc_b  

* Keep variables for regressions
keep *_x_* int_* common_lang_b-n_landlock_b exporter importer Qindustry lnexports dexports ExIALScv_b ExIALSbar_b ExIALSsd_b cshare*_b ExIALSressd_b ExIALSpresd_b
* Generate cluster (exporter-importer) and absorb variable (importer-industry)
egen xmcluster = group(exporter importer)
egen gg = group (Qindustry importer)

********************
* Table 1 - Column 1
********************
* Baseline specification
xi: areg lnexports_b i.Qindustry|ExIALSsd_b i.Qindustry|ExIALSbar_b i.exporter, absorb(gg) vce(cluster xmcluster)
* F-Test for dispersion and mean coefficients
* For dispersion coefficients
testparm  _IQinXExIA_2-_IQinXExIA_63
* For mean coefficients
testparm  _IQinXExIAa2- _IQinXExIAa63

* CODE TO CALCULATE STANDARD ERRORS (DELTA METHOD) OF THE MEAN DIFFERENCE OF THE COEFFICIENTS OF DISPERSION AND MEAN
* Select appropriate sections of the VAR-COV matrix of point estimates for DISP and MEAN
mat F = e(V)
mat covdisp = F[ 2..63 , 2..63 ]
mat covmean = F[ 65..126 , 65..126 ]
* Select appropriate sections of point estimates vectors for DISP and MEAN
mat G = e(b)
mat vecdisp = G[ 1 , 2..63 ]
mat vecmean = G[ 1 , 65..126 ]
mata
mata clear

// Import into Mata the Stata matrices defined above //
// Import the point estimate vectors //
A = st_matrix("vecmean")
B = st_matrix("vecdisp")

// Implementing the Delta Method requires computing a vector of partial derivatives of the mean difference function w.r.t each dispersion (mean) coefficient //
// Sign and magnitude of each partial derivative depend on the ranking of its estimated coeffcient //
// This ranking is obtained by applying 'order' and 'invorder' functions sequentally //
// The following commands compute the partial derivatives for disp and mean coefficients
orderA = order(A',1)
IA = invorder(orderA)
nA = J(62,1,63)
A1N = (1/(62*61))*2*(2*IA-nA)

orderB = order(B',1)
IB = invorder(orderB)
nB = J(62,1,63)
B1N = (1/(62*61))*2*(2*IB-nB)

// Import the covariance matrices of the point estimates //
C = st_matrix("covmean")
D = st_matrix("covdisp")

// Compute mean the mean difference of the point estimates //
dA = J(62,1,0)
Asum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dA[i] = dA[i] + abs(A[i]-A[j]) 
}
Asum = Asum + dA[i]
}

dB = J(62,1,0)
Bsum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dB[i] = dB[i] + abs(B[i]-B[j]) 
}
Bsum = Bsum + dB[i]
}

// Define the 'Mean Difference' for coefficients of, respectively, average skills and dispersion of skills //
avmean = Asum/(62*61)
avdisp = Bsum/(62*61)

// Final steps: use Delta method formula to compute the variances of avmean and avdisp //
varmean = A1N'*C*A1N
vardisp = B1N'*D*B1N

// Report estimate of 'mean differences' for DISP and MEAN, with associated variances and standard deviations //
sdmean = sqrt(varmean) 
sddisp = sqrt(vardisp)
avmean
sdmean
avdisp 
sddisp

// confidence intervals //
avmeanl = avmean - 1.96*sdmean
avmeanh = avmean + 1.96*sdmean
avdispl = avdisp - 1.96*sddisp
avdisph = avdisp + 1.96*sddisp

avmeanl
avmeanh

avdispl
avdisph

mata clear
end	

********************
* Table 1 - Column 2
********************
* Specification including top and bottom bins
xi: areg lnexports_b i.Qindustry|ExIALSsd_b i.Qindustry|ExIALSbar_b i.Qindustry|cshare1_b i.Qindustry|cshare5_b i.exporter, absorb(gg) vce(cluster xmcluster)

* F-Test for dispersion and mean coefficients
* For dispersion coefficients
testparm _IQinXExIA_2-_IQinXExIA_63
* For mean coefficients
testparm _IQinXExIAa2- _IQinXExIAa63
* For share in bin 1
testparm _IQinXcsha_2- _IQinXcsha_63
* For share in bin 5
testparm _IQinXcshaa2- _IQinXcshaa63

* CODE TO CALCULATE STANDARD ERRORS (DELTA METHOD) OF AVERAGE COEFFICIENTS OF DISPERSION AND MEAN, SHARE IN BIN 1 AND SHARE IN BIN 5
* SIMPLE EXTENSION OF THE CODE FOR COLUMN 1
** Select appropriate sections of the VAR-COV matrix of point estimates for DISP and MEAN, SHARE IN BIN 1 AND SHARE IN BIN 5
mat F = e(V)
mat covdisp = F[ 2..63 , 2..63 ]
mat covmean = F[ 65..126 , 65..126 ]
mat covbin1 = F[ 128..189 , 128..189 ]
mat covbin5 = F[ 191..252 , 191..252 ]
** Select appropriate sections of point estimates vectors for DISP and MEAN, SHARE IN BIN 1 AND SHARE IN BIN 5
mat G = e(b)
mat vecdisp = G[ 1 , 2..63 ]
mat vecmean = G[ 1 , 65..126 ]
mat vecbin1 = G[ 1 , 128..189 ]
mat vecbin5 = G[ 1 , 191..252 ]
mata
mata clear

// Import into Mata the Stata matrices defined above //

// Import the point estimate vectors //
A = st_matrix("vecmean")
B = st_matrix("vecdisp")
SL = st_matrix("vecbin1")
SH = st_matrix("vecbin5")

// Import the covariance matrices of the point estimates //
C = st_matrix("covmean")
D = st_matrix("covdisp")
E = st_matrix("covbin1")
F = st_matrix("covbin5")

// Vectors of Partial Derivatives to implement Delta Method//
orderA = order(A',1)
IA = invorder(orderA)
nA = J(62,1,63)
A1N = (1/(62*61))*2*(2*IA-nA)

orderB = order(B',1)
IB = invorder(orderB)
nB = J(62,1,63)
B1N = (1/(62*61))*2*(2*IB-nB)

orderSL = order(SL',1)
ISL = invorder(orderSL)
nSL = J(62,1,63)
SL1N = (1/(62*61))*2*(2*ISL-nSL)

orderSH = order(SH',1)
ISH = invorder(orderSH)
nSH = J(62,1,63)
SH1N = (1/(62*61))*2*(2*ISH-nSH)

// Compute mean the mean difference of the point estimates //
dA = J(62,1,0)
Asum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dA[i] = dA[i] + abs(A[i]-A[j]) 
}
Asum = Asum + dA[i]
}

dB = J(62,1,0)
Bsum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dB[i] = dB[i] + abs(B[i]-B[j]) 
}
Bsum = Bsum + dB[i]
}

dSL = J(62,1,0)
SLsum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dSL[i] = dSL[i] + abs(SL[i]-SL[j]) 
}
SLsum = SLsum + dSL[i]
}

dSH = J(62,1,0)
SHsum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dSH[i] = dSH[i] + abs(SH[i]-SH[j]) 
}
SHsum = SHsum + dSH[i]
}

// Define the 'Mean Difference' for coefficients of, respectively, average skills and dispersion of skills //
avmean = Asum/(62*61)
avdisp = Bsum/(62*61)
avbin1 = SLsum/(62*61)
avbin5 = SHsum/(62*61)

// Final steps: use Delta method formula to compute the variances of avmean, avdisp, avbin1 and avbin5 //
varmean = A1N'*C*A1N
vardisp = B1N'*D*B1N
varbin1 = SL1N'*E*SL1N
varbin5 = SH1N'*F*SH1N

// Report estimate of average effects (in absolute values) for DISP, MEAN, BIN1 and BIN5, with associated variances and standard deviations //
sdmean = sqrt(varmean) 
sddisp = sqrt(vardisp)
sdbin1 = sqrt(varbin1) 
sdbin5 = sqrt(varbin5) 
avmean
sdmean
avdisp
sddisp
avbin1
sdbin1
avbin5
sdbin5

// confidence intervals //
avmeanl = avmean - 1.96*sdmean
avmeanh = avmean + 1.96*sdmean
avdispl = avdisp - 1.96*sddisp
avdisph = avdisp + 1.96*sddisp
avbin1l = avbin1 - 1.96*sdbin1
avbin1h = avbin1 + 1.96*sdbin1
avbin5l = avbin5 - 1.96*sdbin5
avbin5h = avbin5 + 1.96*sdbin5

avmeanl
avmeanh

avdispl
avdisph

avbin1l 
avbin1h 

avbin5l 
avbin5h 
mata clear
end

********************
* Table 1 - Column 3
********************
* Baseline specification
xi: areg lnexports_b i.Qindustry|ExIALSressd_b i.Qindustry|ExIALSpresd_b i.Qindustry|ExIALSbar_b i.exporter, absorb(gg) vce(cluster xmcluster)
* For residual dispersion coefficients
testparm _IQinXExIA_2- _IQinXExIA_63
* For predicted dispersion coefficients
testparm _IQinXExIAa2 - _IQinXExIAa63
* For mean coefficients
testparm  _IQinXExIAb2 - _IQinXExIAb63

* CODE TO CALCULATE STANDARD ERRORS OF AVERAGE COEFFICIENTS OF DISPERSION AND MEAN
* SIMPLE EXTENSION OF THE CODE FOR COLUMN 1
* Select appropriate sections of the VAR-COV matrix of point estimates for DISP and MEAN
mat F = e(V)
mat covdres = F[ 2..63 , 2..63 ]
mat covdpre = F[ 65..126 , 65..126 ]
mat covmean = F[ 128..189 , 128..189 ]
* Select appropriate sections of point estimates vectors for DISP and MEAN
mat G = e(b)
mat vecdres = G[ 1 , 2..63 ]
mat vecdpre = G[ 1 , 65..126 ]
mat vecmean = G[ 1 , 128..189 ]
mata
mata clear

// Import into Mata the Stata matrices defined above //

// Import the point estimate vectors //
A = st_matrix("vecdres")
B = st_matrix("vecdpre")
SL = st_matrix("vecmean")

// Import the covariance matrices of the point estimates //
C = st_matrix("covdisp")
D = st_matrix("covdpre")
E = st_matrix("covmean")

// Vectors of Partial Derivatives to implement Delta Method//
orderA = order(A',1)
IA = invorder(orderA)
nA = J(62,1,63)
A1N = (1/(62*61))*2*(2*IA-nA)

orderB = order(B',1)
IB = invorder(orderB)
nB = J(62,1,63)
B1N = (1/(62*61))*2*(2*IB-nB)

orderSL = order(SL',1)
ISL = invorder(orderSL)
nSL = J(62,1,63)
SL1N = (1/(62*61))*2*(2*ISL-nSL)

// Compute mean the mean difference of the point estimates //

dA = J(62,1,0)
Asum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dA[i] = dA[i] + abs(A[i]-A[j]) 
}
Asum = Asum + dA[i]
}

dB = J(62,1,0)
Bsum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dB[i] = dB[i] + abs(B[i]-B[j]) 
}
Bsum = Bsum + dB[i]
}

dSL = J(62,1,0)
SLsum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dSL[i] = dSL[i] + abs(SL[i]-SL[j]) 
}
SLsum = SLsum + dSL[i]
}

// Define the 'Mean Difference' for coefficients of, respectively, average skills and dispersion of skills //
avdres = Asum/(62*61)
avdpre = Bsum/(62*61)
avmean = SLsum/(62*61)

// Final steps: use Delta method formula to compute the variances of avmean, avdisp//
vardres = A1N'*C*A1N
vardpre = B1N'*D*B1N
varmean = SL1N'*E*SL1N

// Report estimate of average effects (in absolute values) for DISP, MEAN with associated variances and standard deviations //
sddres = sqrt(vardres) 
sddpre = sqrt(vardpre)
sdmean = sqrt(varmean) 
avdres
sddres
avdpre
sddpre
avmean
sdmean

// confidence intervals //
avdresl = avdres - 1.96*sddres
avdresh = avdres + 1.96*sddres

avdprel = avdpre - 1.96*sddpre
avdpreh = avdpre + 1.96*sddpre

avmeanl = avmean - 1.96*sdmean
avmeanh = avmean + 1.96*sdmean

avdresl
avdresh

avdprel
avdpreh

avmeanl 
avmeanh 

mata clear
end

********************
* Table 1 - Column 4
********************
* Baseline specification
xi: areg lnexports_b i.Qindustry|ExIALSressd_b i.Qindustry|ExIALSbar_b i.exporter, absorb(gg) vce(cluster xmcluster)
* For residual dispersion coefficients
testparm _IQinXExIA_2- _IQinXExIA_63
* For mean coefficients
testparm  _IQinXExIAa2- _IQinXExIAa63

* CODE TO CALCULATE STANDARD ERRORS OF AVERAGE COEFFICIENTS OF DISPERSION AND MEAN
* SIMPLE EXTENSION OF THE CODE FOR COLUMN 1
* Select appropriate sections of the VAR-COV matrix of point estimates for DISP and MEAN
mat F = e(V)
mat covdres = F[ 2..63 , 2..63 ]
mat covmean = F[ 65..126 , 65..126 ]
* Select appropriate sections of point estimates vectors for DISP and MEAN
mat G = e(b)
mat vecdres = G[ 1 , 2..63 ]
mat vecmean = G[ 1 , 65..126 ]
mata

mata clear

// Import into Mata the Stata matrices defined above //

// Import the point estimate vectors //
A = st_matrix("vecdres")
SL = st_matrix("vecmean")

// Import the covariance matrices of the point estimates //
C = st_matrix("covdres")
E = st_matrix("covmean")

// Vectors of Partial Derivatives to implement Delta Method//
orderA = order(A',1)
IA = invorder(orderA)
nA = J(62,1,63)
A1N = (1/(62*61))*2*(2*IA-nA)

orderSL = order(SL',1)
ISL = invorder(orderSL)
nSL = J(62,1,63)
SL1N = (1/(62*61))*2*(2*ISL-nSL)

// Compute the mean difference of the point estimates //

dA = J(62,1,0)
Asum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dA[i] = dA[i] + abs(A[i]-A[j]) 
}
Asum = Asum + dA[i]
}

dSL = J(62,1,0)
SLsum = J(1,1,0)
for (i=1;i<=62;i++) {
for (j=1;j<=62;j++) {
dSL[i] = dSL[i] + abs(SL[i]-SL[j]) 
}
SLsum = SLsum + dSL[i]
}

// Define the 'Mean Difference' for coefficients of, respectively, average skills and dispersion of skills //
avdres = Asum/(62*61)
avmean = SLsum/(62*61)

// Final steps: use Delta method formula to compute the variances of avmean, avdisp//

vardres = A1N'*C*A1N
varmean = SL1N'*E*SL1N

// Report estimate of average effects (in absolute values) for DISP, MEAN, with associated variances and standard deviations //
sddres = sqrt(vardres) 
sdmean = sqrt(varmean) 
avdres
sddres
avmean
sdmean

// confidence intervals //
avdresl = avdres - 1.96*sddres
avdresh = avdres + 1.96*sddres

avmeanl = avmean - 1.96*sdmean
avmeanh = avmean + 1.96*sdmean

avdresl
avdresh

avmeanl 
avmeanh 

mata clear
end

*********
* TABLE 4
*********
* Columns (1) to (3), plus alternative combinations of dispersion measures
local IALS "ExIALSressd ExIALSres955 ExIALSresmd"
local wage "Rrsdragec Rrragec955 Rrragecmd"
foreach c of local IALS {
	foreach i of local wage {
	set seed 316
	xi: bootstrap, reps(50): areg lnexports `c'_x_`i' i.exporter i.Qindustry, absorb(importer) vce(cluster xmcluster)
	}
}
* Columns (4) to (6), plus alternative combinations of dispersion measures
local IALS "ExIALSressd ExIALSres955 ExIALSresmd"
local wage "Rrsdragec Rrragec955 Rrragecmd"
foreach c of local IALS {
	foreach i of local wage {
	set seed 316
	xi: bootstrap , reps(50): areg lnexports `c'_x_`i' common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	}
}

*********
* TABLE 5
*********
* Columns (1) to (5), using Std Dev of IALS scores
* Here, include IALS 95-5 and Mean Diff as robustness checks
local IALS "ExIALSressd ExIALSres955 ExIALSresmd"
local onet "R2Qteam R2Qimpact R2Qcomm R2Qcontact Ronet"
foreach c of local IALS {
	foreach i of local onet {
	set seed 316
	xi: bootstrap , reps(50): areg lnexports `c'_x_`i' common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	}
}
* Additional Robustness: Specification without trade barriers and E+Imp+Ind FE. 
local IALS "ExIALSressd ExIALSres955 ExIALSresmd"
local onet "R2Qteam R2Qimpact R2Qcomm R2Qcontact Ronet"
foreach c of local IALS {
	foreach i of local onet {
	set seed 316
	xi: bootstrap , reps(50): areg lnexports `c'_x_`i' i.exporter i.Qindustry, absorb(importer) vce(cluster xmcluster)
	}
}

*********************************************************
* TABLES 6 AND A-4 (second and first stages, respectively)
*********************************************************
* Columns (1) and (2) with Std Dev, also here 95-5 and MD
local IALS "ExIALSressd ExIALSres955 ExIALSresmd"
local wage "Rrsdragec Ronet"
foreach c of local IALS {
	foreach i of local wage {
	set seed 316
	xi: bootstrap , reps(50): areg dexports `c'_x_`i' int_hmr* common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	predict pLPM`c'_x_`i' if e(sample), xb
	gen p = pLPM`c'_x_`i'
	gen p2 = p^2
	gen p3 = p^3
	gen p4 = p^4
	set seed 316
	xi: bootstrap , reps(50): areg lnexports `c'_x_`i' p p2 p3 p4 common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	test p=p2=p3=p4=0
	drop pLPM`c'_x_`i' p p2 p3 p4
	}
}
* Columns (3) and (4) (with SD, also here 95-5 and MD)
local IALS "ExIALSressd ExIALSres955 ExIALSresmd"
local onet "Rrsdragec Ronet"
foreach c of local IALS {
	foreach i of local onet {
	set seed 316
	xi: bootstrap , reps(50): areg dexports `c'_x_`i' int_hmr* Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSressd_x_Qtopcode common_lang - n_landlock i.exporter , absorb(gg) vce(cluster xmcluster)
	predict p`c'_x_`i' if e(sample), xb
	gen p = p`c'_x_`i'
	gen p2 = p^2
	gen p3 = p^3
	gen p4 = p^4
	set seed 316
	xi: bootstrap , reps(50): areg lnexports `c'_x_`i' Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSressd_x_Qtopcode p p2 p3 p4 common_lang - n_landlock i.exporter , absorb(gg) vce(cluster xmcluster)
	test p=p2=p3=p4=0
	drop p`c'_x_`i' p p2 p3 p4
	}
}
* Columns (5) and (6) (with SD. Below, 95-5 and MD)
local onet "Rrsdragec Ronet"
foreach i of local onet {
	set seed 316
	xi: bootstrap , reps(50): areg dexports ExIALSressd_x_`i' ExIALSprecv_x_`i' int_hmr* Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSressd_x_Qtopcode common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	predict p`i' if e(sample), xb
	gen p = p`i'
	gen p2 = p^2
	gen p3 = p^3
	gen p4 = p^4
	set seed 316
	xi: bootstrap , reps(50): areg lnexports ExIALSressd_x_`i' ExIALSprecv_x_`i' Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSressd_x_Qtopcode p p2 p3 p4 common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	test p=p2=p3=p4=0
	drop p`i' p p2 p3 p4
	}
local onet "Rrragec955 Ronet"
foreach i of local onet {
	set seed 316
	xi: bootstrap , reps(50): areg dexports ExIALSres955_x_`i' ExIALSpren955_x_`i' int_hmr* Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSres955_x_Qtopcode common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	predict p`i' if e(sample), xb
	gen p = p`i'
	gen p2 = p^2
	gen p3 = p^3
	gen p4 = p^4
	set seed 316
	xi: bootstrap , reps(50): areg lnexports ExIALSres955_x_`i' ExIALSpren955_x_`i' Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSres955_x_Qtopcode p p2 p3 p4 common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	test p=p2=p3=p4=0
	drop p`i' p p2 p3 p4
	}
local onet "Rrragecmd Ronet"
foreach i of local onet {
	set seed 316
	xi: bootstrap , reps(50): areg dexports ExIALSresmd_x_`i' ExIALSprenmd_x_`i' int_hmr* Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSresmd_x_Qtopcode common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	predict p`i' if e(sample), xb
	gen p = p`i'
	gen p2 = p^2
	gen p3 = p^3
	gen p4 = p^4
	set seed 316
	xi: bootstrap , reps(50): areg lnexports ExIALSresmd_x_`i' ExIALSprenmd_x_`i' Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' ExIALSresmd_x_Qtopcode p p2 p3 p4 common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	test p=p2=p3=p4=0
	drop p`i' p p2 p3 p4
	}

* Also reported in Section 4.4.3: Previous specification for residual wage proxy, excluding the US from the sample
* SD reported in paper, here also 95-5, MD and Ronet
* Full specification (Selection + controls for other CA)
local IALS "ExIALSressd ExIALSres955 ExIALSresmd"
local onet "Rrsdragec Rrragec955 Rrragecmd Ronet"
foreach c of local IALS {
	foreach i of local onet {
	set seed 316
	xi: bootstrap , reps(50): areg dexports `c'_x_`i' int_hmr* Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' `c'_x_Qtopcode common_lang - n_landlock i.exporter if exporter!="USA" & importer!="USA", absorb(gg) vce(cluster xmcluster)
	predict p`c'_x_`i' if e(sample), xb
	gen p = p`c'_x_`i'
	gen p2 = p^2
	gen p3 = p^3
	gen p4 = p^4
	set seed 316
	xi: bootstrap , reps(50): areg lnexports `c'_x_`i' Exat_kap_x_Qcapital Exat_hk_x_Qskill1 ExQc_x_Qdiff ExLaborR_x_`i' `c'_x_Qtopcode p p2 p3 p4 common_lang - n_landlock i.exporter if exporter!="USA" & importer!="USA", absorb(gg) vce(cluster xmcluster)
	test p=p2=p3=p4=0
	drop p`c'_x_`i' p p2 p3 p4
	}
}

*************************
* RESULTS IN THE APPENDIX
************************* 

***********
* TABLE A-2
***********
* Columns (1) to (3), plus alternative combinations of dispersion measures
* E+Imp+Ind Fixed Effects, no trade barriers
local IALS "ExIALScv ExIALSn955 ExIALSnmd"
local wage "Rcvwagec Rwagecn955 Rwagecnmd"
foreach c of local IALS {
	foreach i of local wage {
	xi: areg lnexports `c'_x_`i' i.exporter i.Qindustry, absorb(importer) vce(cluster xmcluster)
	}
}
* Columns (4) to (6), plus alternative combinations of dispersion measures
* E+Imp-Ind Fixed Effects, trade barriers
local IALS "ExIALScv ExIALSn955 ExIALSnmd"
local wage "Rcvwagec Rwagecn955 Rwagecnmd"
foreach c of local IALS {
	foreach i of local wage {
	xi: areg lnexports `c'_x_`i' common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	}
}

***********
* TABLE A-3
***********
* Columns (1) to (3), plus alternative combinations of dispersion measures
local IALS "ExIALSsd ExIALS955 ExIALSmd"
local wage "Rsdwagec Rwagec955 Rwagecmd"
foreach c of local IALS {
	foreach i of local wage {
	xi: areg lnexports `c'_x_`i' ExIALSbar_x_`i' ExIALSbar_x_Rwbar `c'_x_Rwbar common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	}
}
* Column (4) - Non-normalized raw skill dispersion vs Human Capital abundance (H-O measure)
* Plus alternative combinations of dispersion measures
local IALS "ExIALSsd ExIALS955 ExIALSmd"
local wage "Rsdwagec Rwagec955 Rwagecmd"
foreach c of local IALS {
	foreach i of local wage {
	xi: areg lnexports `c'_x_`i' ExIALSbar_x_Qskill1 common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	}
}
* Column (5), plus alternative combinations of dispersion measures
local IALS "ExIALSsd ExIALS955 ExIALSmd"
local wage "Rsdwagec Rwagec955 Rwagecmd"
foreach c of local IALS {
	foreach i of local wage {
	xi: areg lnexports `c'_x_`i' ExIALSbar_x_Qskill1 ExIALSbar_x_`i' ExIALSbar_x_Rwbar `c'_x_Rwbar common_lang - n_landlock i.exporter, absorb(gg) vce(cluster xmcluster)
	}
}

log close
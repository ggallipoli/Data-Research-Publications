

////////////////////////////////* The header and reading the data in *//////////////////////////
clear all
set more off 
cap log close
set more off            // so that the program runs through
set linesize 255        // that tables are not split unnecessarily

/* set the work path */
cd "\\...\JOLE-replication"		

set matsize 10000

set scheme s1mono, permanently


		
*********************************************************
* Figure 1
*********************************************************			

	use "out/estim_norm_prd2", replace
	reg logku1ink i.year //pre-clean the wages for time effects (allowed because superconsistent here) 
	predict wage, residuals 	
	keep if inlist(year,2004,2007) 

	global skilltype noncognitive // cognitive noncognitive

if "${skilltype}"=="cognitive" {	
	gen S = cog>=6
}
if "${skilltype}"=="noncognitive" {	
	gen S = noncog>=6
}	
	tab year S
	
	compress
	display "$S_TIME $S_DATE"	
	
	reghdfe wage if S==0, absorb(fFE0=kmeangp perS0=per_id)
	reghdfe wage if S==1, absorb(fFE1=kmeangp perS1=per_id)
	
	* drop individuals who are available only in one year and fill the fixed effects to all other observations
	drop if fFE0==. & fFE1==.
	bysort kmeangp (fFE0): replace fFE0=fFE0[1] if fFE0==. 
	bysort kmeangp (fFE1): replace fFE1=fFE1[1] if fFE1==.
	
	codebook workp1_id
	collapse fFE0 fFE1 (count) nbrempl=fFE0, by(kmeangp) fast
*Normalize
	qui sum fFE0 [aw=nbrempl]
	replace fFE0= fFE0-r(mean)

	qui sum fFE1 [aw=nbrempl]
	replace fFE1= fFE1-r(mean)	
	sum fFE0 fFE1 [aw=nbrempl] 

*Regression
	reg fFE0 fFE1 [aw=nbrempl]
	global slope = round(_b[fFE1],0.01)
	
	test fFE1==1
	global tstat = round(sqrt(r(F)),0.01)
	
*Correlation	
	corr fFE0 fFE1 [aw=nbrempl]
	global crr = round(r(rho),0.01)	
	
twoway (scatter fFE0 fFE1, yaxis(1) msymbol(x) msize(medlarge) mcolor("189 30 36") legend(label(1 "Firm effects - high vs. low ${skilltype}"))) (lfit fFE0 fFE1, yaxis(1) lcolor(blue) lpattern(solid) legend(label(2 "Regression Line"))) (lfit fFE1 fFE1, yaxis(1) lcolor(gs5) lwidth(vthin) lpattern(dash)  legend(label(3 "Regression Line"))), xlabel(-0.7(0.2)0.4) ylabel(-0.7(0.2)0.4) legend(off) ytitle("Firm Effects - Low ${skilltype}") xtitle("Firm Effects - High ${skilltype}") note("Slope= ${slope}." " " "Test Statistic for equal firm effects= ${tstat}.", size(normal) pos(11) ring(0)) plotregion(margin(zero))	
	
export delimited using "out/groupedtest2004_2007-${skilltype}.csv", replace



**********************************************************************************************
***** Tables 1 and 3 ******
**********************************************************************************************	

	use "out/estim_norm_prd2", replace

	sum lmbC
	gen lamCbar = r(mean)
	gen lamC = lmbC - lamCbar
	sum lmbN
	gen lamNbar = r(mean)
	gen lamN = lmbN - lamNbar
	
	gen returns = lamC*C + lamN*N	
	gen returnC = lamC*C 
	gen returnN = lamN*N	
	
	gen firm = lmb0 + returns
	gen person = perFe + lamCbar*C + lamNbar*N 

	drop if returns==.
	codebook workp1_id
	
* Tables 1 and 3, columns (1)
	tabstat person lmb0 lamC lamN returnC returnN returns, stats(sd)
* Table 3 column (3)	
	tabstat returnC returnN returns, stats(mean)
	

	
**********************************************************************************************
***** TABLE 2 and Figure 2 (C and D) ******
**********************************************************************************************	

	use "out/estim_norm_prd2", replace
	append using out/estim_norm_prd1
	append using out/estim_norm_prd3		
	
	
	collapse C N lmb0 lmbC lmbN (sd) sdevC=C sdevN=N (rawsum) nbrempl=per_id, by(workp1_id kmeangp period) fast
	
 ****** Table 2 *******
global prd 2 // 1 2 3

	eststo clear
	eststo: regress C lmbC lmbN if period==${prd} [aw=1], cluster(kmeangp) 
	quietly estadd local Period "2"
	eststo: regress N lmbC lmbN if period==${prd} [aw=1], cluster(kmeangp) 
	quietly estadd local Period "2"	
	
	eststo: regress C lmbC lmbN lmb0 nbrempl if period==${prd} [aw=1], cluster(kmeangp) 
	quietly estadd local Period "2"
	eststo: regress N lmbC lmbN lmb0 nbrempl if period==${prd} [aw=1], cluster(kmeangp) 
	quietly estadd local Period "2"	
	
	eststo: regress C lmbC lmbN lmb0 if period==${prd} [aw=nbrempl], cluster(kmeangp) 
	quietly estadd local Period "2"
	eststo: regress N lmbC lmbN lmb0 if period==${prd} [aw=nbrempl], cluster(kmeangp) 
	quietly estadd local Period "2"		
	
	esttab, obs b(%12.3fc) se(%12.3fc) r2 scalars("Period Period")	
	

 ****** Figure 2, panels C and D *******	
	
	sum lmbC
	gen lamC = lmbC - r(mean)
	sum lmbN
	gen lamN = lmbN - r(mean)
	
global wght 1 // options: 1  nbrempl	

	binscatter lamC C [aw=${wght}], controls(period##c.N) nquantiles(20) by(period) linetype(connect) xlabel(0.4(0.1)0.7)   legend(row(1) label(1 "1990-1999") label(2 "1999-2008") label(3 "2008-2017")) xtitle("") ytitle("Cognitive return") savedata("out/lamC_avgC") replace	
	
	binscatter lamN N [aw=${wght}], controls(period##c.C) nquantiles(20) by(period) linetype(connect) xlabel(0.4(0.1)0.7) legend(row(1) label(1 "1990-1999") label(2 "1999-2008") label(3 "2008-2017")) xtitle("") ytitle("Noncognitive return") savedata("out/lamN_avgN") replace
	
	
	
**********************************************************************************************
***** FIGURE 2: FOSD GRAPHS -- PLOTTING THE CDF ******
**********************************************************************************************	

	use "out/estim_norm_prd2", replace
	drop if lmb0==. | lmbC==. | lmbN==.
	
	gen byte sLL = inlist(cog,1,2,3) & inlist(noncog,1,2,3)
	gen byte sML = inlist(cog,4,5,6) & inlist(noncog,1,2,3)
	gen byte sHL = inlist(cog,7,8,9) & inlist(noncog,1,2,3)
	gen byte sLM = inlist(cog,1,2,3) & inlist(noncog,4,5,6)
	gen byte sMM = inlist(cog,4,5,6) & inlist(noncog,4,5,6)
	gen byte sHM = inlist(cog,7,8,9) & inlist(noncog,4,5,6)
	gen byte sLH = inlist(cog,1,2,3) & inlist(noncog,7,8,9)
	gen byte sMH = inlist(cog,4,5,6) & inlist(noncog,7,8,9)
	gen byte sHH = inlist(cog,7,8,9) & inlist(noncog,7,8,9)	
	
	sum lmbC
	gen lamC = lmbC - r(mean)
	sum lmbN
	gen lamN = lmbN - r(mean)	

	
****** Figure 2, panel A *******	
foreach skill in LL ML HL LM MM HM LH MH HH {
	egen total_`skill' = total(s`skill') 		
	sort lamC
	gen cumC_`skill' = sum(s`skill') 
	gen pctC_`skill' = cumC_`skill' / total_`skill'	
}	
sort lamC
	
	sum lamC
	global Lbound `r(min)'
	global Ubound `r(max)'
	
preserve
	collapse pctC_LM pctC_MM pctC_HM (count) nobs=pctC_MM, by(lamC) fast
	
	twoway line pctC_LM lamC, lcolor(blue) xlabel(-0.15(0.05)0.15) || ///
		line pctC_MM lamC, lcolor("189 30 36") lwidth(medthick) lpattern(dash) || ///
		line pctC_HM lamC, lcolor(dkgreen) lwidth(medthick) lpattern(longdash_dot) ///
	, legend(cols(3) label(1 "low c, mid n") label(2 "mid c, mid n") label(3 "high c, mid n")) ytitle(CDF) xtitle("") title("CDF by cog skill level (noncog fixed at mid)")	
	 			
	export delimited using "out/cdfskill_lamC_midN.csv", replace
restore		
		
	
****** Figure 2, panel B *******	
foreach skill in LL ML HL LM MM HM LH MH HH {		
	sort lamN
	gen cumN_`skill' = sum(s`skill') 
	gen pctN_`skill' = cumN_`skill' / total_`skill'
}	
sort  lamN
	
	sum lamN
	global Lbound `r(min)'
	local Ubound 0.17

	collapse pctN_ML pctN_MM pctN_MH (count) nobs=pctN_MM, by(lamN) fast
	
	twoway line pctN_ML lamN if lamN<=`Ubound', lcolor(blue) xlabel(-0.15(0.05)0.15) || ///
		line pctN_MM lamN if lamN<=`Ubound', lcolor("189 30 36") lwidth(medthick) lpattern(dash) || ///
		line pctN_MH lamN if lamN<=`Ubound', lcolor(dkgreen) lwidth(medthick) lpattern(longdash_dot) ///
	, legend(cols(3) label(1 "mid c, low n") label(2 "mid c, mid n") label(3 "mid c, high n")) ytitle(CDF) xtitle("")  title("CDF by noncog. skill level (cog. fixed at mid)")	
		
	export delimited using "out/cdfskill_lamN_midC.csv", replace
	


**********************************************************************************************
***** Table 4 ******
**********************************************************************************************	


****** Columns (1)-(4) *******
	use "out/estim_norm_prd2", replace
	drop if lmb0==. | lmbC==. | lmbN==.

	collapse lmbC (count) actual=per_id, by(workp1_id C) fast	
	sum lmbC [aw=actual]
	global size_lmbC = r(mean)
	sum C [aw=actual]
	gen avg_C = r(mean)
	gen tilde_C = C - avg_C
	gen tilde_lmbC = lmbC - ${size_lmbC} 
	
	gen total_gain = tilde_lmbC*C 
	gen avg_C_gain = tilde_lmbC*avg_C
	gen tilde_C_gain = tilde_lmbC*tilde_C 
		
	replace tilde_lmbC = tilde_lmbC  * 100
	replace total_gain = total_gain  * 100
	replace avg_C_gain = avg_C_gain  * 100
	replace tilde_C_gain = tilde_C_gain  * 100
	
	tabstat tilde_lmbC total_gain avg_C_gain tilde_C_gain [aw=actual], by(C)

	
****** Column (5) *******
	use "out/estim_norm_prd2", replace
	drop if lmb0==. | lmbC==. | lmbN==.

	collapse lmb0 (count) actual=per_id, by(workp1_id C) fast	
	sum lmb0 [aw=actual]
	global size_lmb0 = r(mean)
	gen tilde_lmb0_size = lmb0 - ${size_lmb0} 
	
	tabstat tilde_lmb0_size [aw=actual], by(C)
	
	
	
	
**********************************************************************************************
***** Table 5 ******
**********************************************************************************************	

	use "out/estim_norm_prd2", replace
	drop if lmb0==. | lmbC==. | lmbN==.

	foreach X in 0 C N {
		sum lmb`X'
		gen lam`X'bar = r(mean)
		gen lam`X' = lmb`X' - lam`X'bar	
	} 	
	
	preserve
	collapse C N, by(workp1_id) fast	
	expand(9)
	bysort workp1_id: replace C=(_n-1)/8
	expand(9)
	bysort workp1_id C: replace N=(_n-1)/8
	tempfile temper
	save  `temper'
	restore
	
	preserve
	collapse (count) rndmwght=per_id, by(C N) fast
	merge 1:n C N using `temper', nogen
	tempfile temper
	save  `temper'
	restore
	
	collapse lam0 lamC lamN (count) weight=per_id, by(workp1_id C N) fast	
	merge 1:n workp1_id C N using `temper'
	replace weight = 0 if weight==.
	bysort workp1_id (lam0): replace lam0=lam0[1]
	bysort workp1_id (lamC): replace lamC=lamC[1]
	bysort workp1_id (lamN): replace lamN=lamN[1]
	
	gen predwageLog = lamC*C + lamN*N 	
	gen lamCC = lamC*C
	gen lamNN = lamN*N
	
	bysort workp1_id: egen firmsizeweight = total(weight)
	replace firmsizeweight = firmsizeweight * rndmwght // "random allocation" which preserves firm sizes		

******  random allocation (columns 1,3,5) ****** 
	sum /*lam0*/ lamCC lamNN predwageLog [aw=firmsizeweight], d
		
******  actual allocation (columns 2,4,6) ****** 
	sum /*lam0*/ lamCC lamNN predwageLog [aw=weight], d

	
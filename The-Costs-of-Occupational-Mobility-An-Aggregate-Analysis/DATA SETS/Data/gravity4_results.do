# delimit ;

cap log close;

*cd "[directory where do-files are saved]/Built";

*** PLOT EVOLUTION OF COEFFICIENTS ON TASK VAR'S ***;
use "reg3", clear;

twoway line estimate min95 max95 year if parm=="angsep", 
	lp(l - -) lc(blue gs10 gs10) legend(off) xtitle("") 
	title("Estimated coefficient on task distance") 
	name(dist, replace);
graph export "../TexFiles/dist_coeff.eps", replace;
twoway line estimate min95 max95 year if parm=="switch_to_nrc", 
	lp(l - -) lc(blue gs10 gs10) legend(off) xtitle("")
	title("Switch to NRC") 
	name(nrc, replace);
twoway line estimate min95 max95 year if parm=="switch_to_rc", 
	lp(l - -) lc(blue gs10 gs10) legend(off) xtitle("") 
	title("Switch to RC") 
	name(rc, replace);
twoway line estimate min95 max95 year if parm=="switch_to_rm", 
	lp(l - -) lc(blue gs10 gs10) legend(off) xtitle("") 
	title("Switch to RM") 
	name(rm, replace);
twoway line estimate min95 max95 year if parm=="switch_to_nrm", 
	lp(l - -) lc(blue gs10 gs10) legend(off) xtitle("") 
	title("Switch to NRM") 
	name(nrm, replace);
graph combine nrc rc rm nrm, title("Estimated coefficients on switches across task groups");
graph close nrc rc rm nrm;
graph export "../TexFiles/task_coeffs.eps", replace;


foreach sample in "full" "young" "Coll" "HS" "Long" "CodingError" { ;
	if "`sample'"=="young" { ;
		cd "./Young";
	};
 	if "`sample'"=="Coll" | "`sample'"=="HS" | "`sample'"=="Long" | "`sample'"=="CodingError" { ;
	cd "./../`sample'";
	};

log using "gravity4_log", replace;

	display "FROM HERE ON FOR `sample' SAMPLE";

* Choose year for graphs;
if "`sample'" != "CodingError" { ;
	local yr_gph=2012;
};
if "`sample'" == "CodingError" { ;
	local yr_gph=1992;
};



* Choose theta;
	* Change this for robustness checks with other values of theta;
	* Benchmark: estimate of theta based on median for restricted 
	* demographics (saved as scalar in gravity2b_theta);
scalar thetaest=theta50;
*scalar thetaest=2;
*scalar thetaest=theta10;
*scalar thetaest=theta90;
*scalar thetaest=6;
*scalar thetaest=8.87;


*********************
*** IMPLIED BETAS ***
*********************;

* Take estimated parameters and estimate of theta to get implied betas;
use "reg1", clear;
keep parm year estimate;
rename estimate estimate1;
foreach num of numlist 2(1)8 { ;
	merge parm year using "reg`num'", keep(estimate) sort;
	rename estimate estimate`num';
	drop _merge;
};
 
foreach i of numlist 1 2 3 4 5 6 7 8 {	;
* Generate estimated betas in the log d equation;
	gen beta`i' = estimate`i'/(-thetaest);
};

* Generate an estimated percentage change in d (iceberg cost) due to
* turning on dummies, or a 1 s.d. change in the continuous variables;
* sd needs to be calculated separately for regression that excludes zero flows;
* NOTE: sd's of angsep are for 2012, so % effects make sense for 2012 only;
foreach i of numlist 1 {	;
	gen percentage`i' = (exp(beta`i')-1)*100 
		if parm=="switch_to_nrc" | parm=="switch_to_rc"
			| parm=="switch_to_rm" | parm=="switch_to_nrm";
	replace percentage`i' = (exp(beta`i'*sdangsep91_1)-1)*100 
	if parm=="angsep";
}	;
foreach i of numlist 2 3 4 5 6 7 { ; 
	gen percentage`i' = (exp(beta`i')-1)*100 
		if parm=="switch_to_nrc" | parm=="switch_to_rc"
			| parm=="switch_to_rm" | parm=="switch_to_nrm";
}	;
foreach i of numlist 2 3 { ; 
	replace percentage`i' = (exp(beta`i'*sdangsep91_2)-1)*100 
		if parm=="angsep";
}	;
	replace percentage4 = (exp(beta4*sdangsep91alt)-1)*100 
		if parm=="angsep";
	replace percentage5 = (exp(beta5*sdangsep09)-1)*100 
		if parm=="angsep";
	replace percentage6 = (exp(beta6*sdangsep09skill)-1)*100 
		if parm=="angsep";

* Gen % for non-linear one - effect of 1 s.d. from mean of distance - use 2012;
quietly sum beta7 if parm=="angsep" & year==2012;
scalar b1=r(mean);
quietly sum beta7 if parm=="angsep91_2" & year==2012;
scalar b2=r(mean);
quietly sum beta7 if parm=="angsep91_3" & year==2012;
scalar b3=r(mean);
replace percentage7 = (exp(b1*sdangsep91_2 
	+ b2 * ((meanangsep91_2+sdangsep91_2)^2 - meanangsep91_2^2)
	+ b3 * ((meanangsep91_2+sdangsep91_2)^3 - meanangsep91_2^3)) - 1) * 100
	if parm=="angsep";
* Gen % for non-linear one - effect of 1 s.d. from 0;
gen percentage7b = (exp(b1*sdangsep91_2 + b2 * sdangsep91_2^2
	+ b3 * sdangsep91_2^3) - 1) * 100
	if parm=="angsep";
* Gen % for non-linear one - effect of 1 s.d. from min;
gen percentage7c = (exp(b1*sdangsep91_2 
	+ b2 * ((minangsep91_2+sdangsep91_2)^2 - minangsep91_2^2)
	+ b3 * ((minangsep91_2+sdangsep91_2)^3 - minangsep91_2^3)) - 1) * 100
	if parm=="angsep";
	

***** Save implied betas and percetage effects for Table \ref{tab:percentage}
* and Table \ref{tab:percentage_theta90};
if thetaest==theta50 {;
save "tab_percentage", replace;
};
if thetaest==theta90 {;
save "tab_percentage_theta90", replace;
};


	quietly sum year;
	local yr_min=r(min);
	local yr_max=r(max);
	local yr_min_plus1=`yr_min'+1;
	display "earliest year is `yr_min'";
	display "most recent year is `yr_max'";


* Save estimated coefficients for each year;
foreach num of numlist 3(1)6 8 { ;
	foreach y of numlist `yr_min'(1)`yr_max' { ;
		quietly sum beta`num' if parm=="angsep" & year==`y';
		scalar reg`num'_beta1_`y'=r(mean);
	};
};
	foreach y of numlist `yr_min'(1)`yr_max' { ;
		quietly sum beta7 if parm=="angsep" & year==`y';
		scalar reg7_beta1a_`y'=r(mean);
		quietly sum beta7 if parm=="angsep91_2" & year==`y';
		scalar reg7_beta1b_`y'=r(mean);
		quietly sum beta7 if parm=="angsep91_3" & year==`y';
		scalar reg7_beta1c_`y'=r(mean);
	};
foreach num of numlist 3(1)7 { ;
	foreach y of numlist `yr_min'(1)`yr_max' { ;
		quietly sum beta`num' if parm=="switch_to_nrc" & year==`y';
		scalar reg`num'_beta2_`y'=r(mean);
		quietly sum beta`num' if parm=="switch_to_rc" & year==`y';
		scalar reg`num'_beta3_`y'=r(mean);
		quietly sum beta`num' if parm=="switch_to_rm" & year==`y';
		scalar reg`num'_beta4_`y'=r(mean);
		quietly sum beta`num' if parm=="switch_to_nrm" & year==`y';
		scalar reg`num'_beta5_`y'=r(mean);
	};
};
	foreach y of numlist `yr_min'(1)`yr_max' { ;
		quietly sum beta8 if parm=="task_pair_21" & year==`y';
		scalar reg8_beta2_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_23" & year==`y';
		scalar reg8_beta3_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_24" & year==`y';
		scalar reg8_beta4_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_31" & year==`y';
		scalar reg8_beta5_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_32" & year==`y';
		scalar reg8_beta6_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_34" & year==`y';
		scalar reg8_beta7_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_41" & year==`y';
		scalar reg8_beta8_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_42" & year==`y';
		scalar reg8_beta9_`y'=r(mean);
		quietly sum beta8 if parm=="task_pair_43" & year==`y';
		scalar reg8_beta10_`y'=r(mean);
	};


******************************
*** DATASET WITH OCC SIZES ***
******************************;
* Variable n in gravity3_reg3 has occ size for occ2dig in each year,
* but appears several times (once for each occ2dig_t1), so create a file that just has the size info;

foreach whichreg in reg3 reg4 reg5 reg6 reg7 reg8 { ;

use "gravity3_`whichreg'", clear;
collapse n (sd) prueba=n, by(occ2dig year);
tab prueba;
drop prueba;
save "occ_size_`whichreg'", replace;


**********************************
*** GENERATE S_j AND theta_m_j ***
**********************************;
use "`whichreg'_src_dst", clear;

* Merge in occ size;
merge 1:1 occ2dig year using "occ_size_`whichreg'", nogen;

* Merge in annual intercepts;
merge m:1 year using "`whichreg'_cons", nogen keepusing(estimate);
rename estimate constant;

* Add occupation 2 with a zero source effect and dest effect = constant;
* Adjust dest effect to include constant for all occ's;
gen estimatesrc_adj = estimatesrc;
replace estimatesrc_adj = 0 if occ2dig==2;
gen estimatedst_adj = estimatedst+constant;
replace estimatedst_adj = constant if occ2dig==2;

* Generate s_j;
gen s_j = -estimatesrc_adj;

* Generate theta_m_j;
gen theta_m_j = s_j-estimatedst_adj;

label var s_j "S{subscript:j}";
label var theta_m_j "{&theta}m{subscript:j}";

* Find lowest theta_m_j across all occ/periods;
sum theta_m_j, det;
scalar theta_m_min=r(min);
* Find median for 2012;
sum theta_m_j if year==2012, det;
scalar theta_m_med_2012=r(p50);


************************************
*** PLOT SOURCE/DESTINATION FE'S ***
************************************;
twoway (scatter theta_m_j s_j if year==`yr_gph' [w=n], msymbol(circle_hollow) legend(off))
	(scatter theta_m_j s_j if year==`yr_gph', 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)), 
	name(circles_dot, replace);	
if thetaest==theta50 & "`sample'"=="full" & "`whichreg'"=="reg3" { ;
graph export "../TexFiles/occ_fe.eps", replace;
};
if thetaest==theta50 & "`sample'"!="full" & "`whichreg'"=="reg3" { ;
graph export "../../TexFiles/occ_fe_`sample'.eps", replace;
};

*** For Appendix that discusses relative size of exit and access costs ***;
* Check variance of source and destination fixed effects * ;
if thetaest==theta50 & "`whichreg'"=="reg3" & "`sample'"=="full" { ; 
	* Variance of s_j;
	sum s_j [w=n];
	* Variance of d_j;
	sum estimatedst_adj [w=n];
	* Variance of s_j-d_j;
	sum theta_m_j [w=n];
	* Compute variance of access costs (see equations in appendix of paper);
	* Var(m) = [Var(s-d) - [Var(s) - Var(d)]] / (2*theta^2);
	* Numbers here are standard deviations from the sum commands above;
	display ( 1.472702 ^2 - (.5432854^2 - 1.060126^2))/(2*thetaest^2);
	* Compute variance of exit costs;
	* Var(chi) = Var(s-d)/(theta^2)) - Var(m);
	display  (1.472702 ^2)/(thetaest^2) - ( 1.472702 ^2 - (.5432854^2 - 1.060126^2))/(2*thetaest^2);
};


if thetaest==theta50 & "`whichreg'"=="reg3" { ; 

*** Estimated source and destination FEs directly ***;

label var estimatesrc_adj "Estimated Source Fixed Effect: -S{subscript:j}";
label var estimatedst_adj "Estimated Destination Fixed Effect: D{subscript:j}";

twoway (scatter estimatedst_adj estimatesrc_adj if year==`yr_gph' [w=n], msymbol(circle_hollow) legend(off))
	(scatter estimatedst_adj estimatesrc_adj if year==`yr_gph', 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)), 
	name(occ_fe_raw, replace);
if "`sample'"=="full" { ;
graph export "../TexFiles/occ_fe_raw.eps", replace;
};
if "`sample'"=="Long" { ;
graph export "../../TexFiles/occ_fe_raw_12month.eps", replace;
};
};

* Save new version of the dataset;
save "gravity4_`whichreg'_src_dst", replace;


*** Correlate estimated entry costs with other variables ***;
* Specific vocational preparation from DOT;
if "`sample'"=="full" & "`whichreg'"=="reg3" & thetaest==theta50 { ;
rename occ2dig occ2dig_dd;
merge m:1 occ2dig_dd using "../dot_occ2dig_dd", 
	nogen keepusing(svp) keep(1 3);
rename occ2dig_dd occ2dig;
* Merge in fraction of workers with college degree;
merge 1:1 occ2dig year using "frac_coll", nogen keep(1 3);
* Merge in fraction of unionized workers;
merge 1:1 occ2dig year using "frac_union", nogen keep(1 3);
* Merge in licensing data;
merge m:1 occ2dig using "license", nogen keep(1 3);

	*** Check average costs for occupations with different levels of unionization/licensing rates ***;
	foreach name in union_m licensed { ;
	* First compute median across occupation-years;
	sum `name' [w=n] , det;
	scalar med_`name'=r(p50);
	* Check also for 2012 only;
	sum `name' [w=n] if year==2012, det;
	
	* Look at differences in access costs in 2012 between occupations 
	* above and below overall median unionization/licensing;
	sum theta_m_j [w=n] if `name'<=med_`name' & year==2012;
	scalar cost_below_`name'=r(mean);
	sum theta_m_j [w=n] if `name'>med_`name' & `name'<. & year==2012;
	scalar cost_above_`name'=r(mean);
	* Difference in means (will be used in conterfactuals);
	scalar cost_diff_`name'=cost_above_`name'-cost_below_`name';
	* Check which occ's are above median (will be used below in counterfactuals);
	tab occ2dig if `name'>med_`name' & `name'<. & year==2012;
	};


*** Collapse to average across all years ***;
collapse theta_m_j svp coll union* *lic* shareheavy* n, by(occ2dig);

label var theta_m_j "{&theta}m{subscript:j}";
label var svp "Specific Vocational Preparation, DOT";
label var coll "Fraction of Workers with a College Degree";
label var union_m "Union Membership Rate";
label var lic_fed_state "Occupational Licensing Measure";
label var licensed "Number of States in which Occupation is Licensed";


twoway (scatter theta_m_j svp [w=n], msymbol(circle_hollow) legend(off))
	(scatter theta_m_j svp , 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)), 
	name(svp, replace) subtitle("Panel A: Specific Vocational Preparation");
twoway (scatter theta_m_j coll  [w=n], msymbol(circle_hollow) legend(off))
	(scatter theta_m_j coll , 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)), 
	name(coll, replace) subtitle("Panel B: Fraction of Workers with College Degree");	
twoway (scatter theta_m_j union_m  [w=n], msymbol(circle_hollow) legend(off))
	(scatter theta_m_j union_m , 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)), 
	name(union_m, replace) subtitle("Panel C: Union Membership Rate");	
twoway (scatter theta_m_j licensed [w=n], msymbol(circle_hollow) legend(off))
	(scatter theta_m_j licensed , 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)), 
	name(licensed, replace) subtitle("Panel D: State Licensing");	

graph combine svp coll union_m licensed, name(svp_coll_union, replace);
graph close svp coll union_m licensed;
graph export "../TexFiles/svp_coll_union.eps", replace;


* Standardize variables (mean zero, standard deviation one);
foreach name in svp coll union_c union_m licenses licensed fed_license lic_fed_state 
	shareheavy shareheavy2 shareheavy3 { ;
egen norm_`name' = std(`name');
};

* Generate an equally weighted average of the 4 standardized measures;
gen std_equal_w = 0.25*norm_svp + 0.25*norm_coll + 0.25*norm_union_m + 0.25*norm_licensed;
twoway (scatter theta_m_j std_equal_w  [w=n], msymbol(circle_hollow) legend(off))
	(scatter theta_m_j std_equal_w , 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)),
	xtitle("Composite Empirical Access Cost Measure") 
	name(std_equal_w, replace) subtitle("Panel A: Equally Weighted");	


** Principal Component Analysis of the 4 measures**;
* (note that this is the same as a weighted average of the standardized variables
*  where the weights are chosen to maximize the proportion of the variance that
*  is explained);
pca svp91 coll union_m licensed [w=n] ;
predict pca_predict, score;

twoway (scatter theta_m_j pca_predict  [w=n], msymbol(circle_hollow) legend(off))
	(scatter theta_m_j pca_predict  , 
		ms(i) mlabel(occ2dig) mlabpos(c) mlabcol(gs1)), 
	xtitle("Composite Empirical Access Cost Measure")
	name(pca_predict , replace) subtitle("Panel B: Principal Component Analysis Predictions");	

graph combine std_equal_w pca_predict, name(composite_meas, replace);
graph export "../TexFiles/composite_meas.eps", replace;
graph close std_equal_w pca_predict;
};	



******************************************
*** COST FOR SPECIFIC OCCUPATION PAIRS ***
******************************************;

* Generate costs of each transition;
* Use estimated betas from IntReg;
use "gravity3_`whichreg'", clear;

merge m:1 occ2dig year using "gravity4_`whichreg'_src_dst", keepusing(s_j);
rename s_j Sk;
drop _m;

rename occ2dig occ2dig_current;
rename occ2dig_t1 occ2dig;
merge m:1 occ2dig year using "gravity4_`whichreg'_src_dst", 
					keepusing(s_j theta_m_j);
rename s_j Sj;
drop _m;
rename occ2dig occ2dig_t1;
rename occ2dig_current occ2dig;

keep if yhat<.; * Drops flows from A to A;

gen d_hat=exp(-(yhat+Sk-Sj)/thetaest);

gen d_tilde=exp(-(yhat+Sk-Sj+theta_m_j)/thetaest);

if "`whichreg'"=="reg7"{ ;
gen d_tilde_test=exp(reg7_beta1a_`yr_min'*angsep + reg7_beta1b_`yr_min'*angsep^2 
	+ reg7_beta1c_`yr_min'*angsep^3
	+ reg7_beta2_`yr_min'*switch_to_nrc 
	+ reg7_beta3_`yr_min'*switch_to_rc 
	+ reg7_beta4_`yr_min'*switch_to_rm	
	+ reg7_beta5_`yr_min'*switch_to_nrm) if year==`yr_min';
if "`sample'"!="CodingError" { ;
foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
replace d_tilde_test=exp(reg7_beta1a_`y'*angsep + reg7_beta1b_`y'*angsep^2 
	+ reg7_beta1c_`y'*angsep^3
	+ reg7_beta2_`y'*switch_to_nrc 
	+ reg7_beta3_`y'*switch_to_rc 
	+ reg7_beta4_`y'*switch_to_rm	
	+ reg7_beta5_`y'*switch_to_nrm) if year==`y';
};
	};
	};
else { ;
if "`whichreg'"=="reg8"{ ;
gen d_tilde_test=exp(reg8_beta1_`yr_min'*angsep + reg8_beta2_`yr_min'*task_pair_21
	+ reg8_beta3_`yr_min'*task_pair_23
	+ reg8_beta4_`yr_min'*task_pair_24 
	+ reg8_beta5_`yr_min'*task_pair_31 
	+ reg8_beta6_`yr_min'*task_pair_32	
	+ reg8_beta7_`yr_min'*task_pair_34
	+ reg8_beta8_`yr_min'*task_pair_41
	+ reg8_beta9_`yr_min'*task_pair_42
	+ reg8_beta10_`yr_min'*task_pair_43) if year==`yr_min';
if "`sample'"!="CodingError" { ;
foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
replace d_tilde_test=exp(reg8_beta1_`y'*angsep + reg8_beta2_`y'*task_pair_21
	+ reg8_beta3_`y'*task_pair_23
	+ reg8_beta4_`y'*task_pair_24 
	+ reg8_beta5_`y'*task_pair_31 
	+ reg8_beta6_`y'*task_pair_32	
	+ reg8_beta7_`y'*task_pair_34
	+ reg8_beta8_`y'*task_pair_41
	+ reg8_beta9_`y'*task_pair_42
	+ reg8_beta10_`y'*task_pair_43) if year==`y';
	};
	};

};
else { ;
gen d_tilde_test=exp(`whichreg'_beta1_`yr_min'*angsep 
	+ `whichreg'_beta2_`yr_min'*switch_to_nrc 
	+ `whichreg'_beta3_`yr_min'*switch_to_rc 
	+ `whichreg'_beta4_`yr_min'*switch_to_rm	
	+ `whichreg'_beta5_`yr_min'*switch_to_nrm) if year==`yr_min';
if "`sample'"!="CodingError" { ;
foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
replace d_tilde_test=exp(`whichreg'_beta1_`y'*angsep 
	+ `whichreg'_beta2_`y'*switch_to_nrc 
	+ `whichreg'_beta3_`y'*switch_to_rc 
	+ `whichreg'_beta4_`y'*switch_to_rm	
	+ `whichreg'_beta5_`y'*switch_to_nrm) if year==`y';
};	
};
};
};

	
gen test = d_tilde-d_tilde_test;
sum test, det;
drop d_tilde_test test;

if "`whichreg'"=="reg7" {;
gen d_dist = exp(reg7_beta1a_`yr_min'*angsep + reg7_beta1b_`yr_min'*angsep^2 
	+ reg7_beta1c_`yr_min'*angsep^3) if year==`yr_min';
if "`sample'"!="CodingError" { ;
foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
replace d_dist = exp(reg7_beta1a_`y'*angsep + reg7_beta1b_`y'*angsep^2 
	+ reg7_beta1c_`y'*angsep^3) if year==`y';
};
};
};
else { ;
gen d_dist = exp(`whichreg'_beta1_`yr_min'*angsep) if year==`yr_min';
if "`sample'"!="CodingError" { ;
foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
replace d_dist = exp(`whichreg'_beta1_`y'*angsep) if year==`y';
};
};
};

sum d_hat, det;
sum d_tilde, det;
sum d_dist, det;

gen imp_dist=(d_dist-1)/(d_hat-1);
gen imp_tasks=(d_tilde-1)/(d_hat-1);
display "THESE ARE THE SUMMARY STATISTICS FOR TABLE tab:relative_d and tab:theta_robustness (BASED ON REGRESSION `whichreg' AND USING ALL YEARS) USING SAMPLE `sample'";
sum imp*, det;


sort year d_hat;

***** Save costs for specific occ pairs for Table \ref{tab:dkj_examples}
* and Table \ref{tab:dkj_examples_theta90};
if thetaest==theta50 & "`whichreg'"=="reg3" {;
save "dkj_examples", replace;
};
if thetaest==theta90 & "`whichreg'"=="reg3" {;
save "dkj_examples_theta90", replace;
};


*** Build minimum/median costs for alternative CF;
egen angsep_min = min(angsep) if occ2dig!=occ2dig_t1;
egen angsep_med = median(angsep) if occ2dig!=occ2dig_t1;

foreach type in min med { ;
if "`whichreg'"=="reg7" {;
gen d_dist_`type' = exp(reg7_beta1a_`yr_min'*angsep_`type' + reg7_beta1b_`yr_min'*angsep_`type'^2 
	+ reg7_beta1c_`yr_min'*angsep_`type'^3) if year==`yr_min';
if "`sample'"!="CodingError" { ;
foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
replace d_dist_`type' = exp(reg7_beta1a_`y'*angsep_`type' + reg7_beta1b_`y'*angsep_`type'^2 
	+ reg7_beta1c_`y'*angsep_`type'^3) if year==`y';
};
};
};
else { ;
gen d_dist_`type' = exp(`whichreg'_beta1_`yr_min'*angsep_`type') if year==`yr_min';
if "`sample'"!="CodingError" { ;
foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
replace d_dist_`type' = exp(`whichreg'_beta1_`y'*angsep_`type') if year==`y';
};
};
};
};



****************************
*** COUNTERFACTUAL FLOWS ***
****************************
;
gen ycf0 = yhat+thetaest*ln(d_dist);
gen ycf1 = yhat+thetaest*ln(d_tilde);
gen ycf2 = yhat+thetaest*ln(d_hat);

gen ycf1_test = Sj-Sk-theta_m_j;
gen ycf2_test = Sj-Sk;

gen test1 = ycf1-ycf1_test;
sum test1, det;
gen test2 = ycf2-ycf2_test;
sum test2, det;

drop *test*;

gen normswhat=exp(yhat);
gen normswcf0=exp(ycf0);
gen normswcf1=exp(ycf1);
gen normswcf2=exp(ycf2);

sum normsw*, det;

*** With minimum costs;
gen ycf0_min = yhat+thetaest*ln(d_dist)-thetaest*ln(d_dist_min);
gen ycf1_min = yhat+thetaest*ln(d_tilde)-thetaest*ln(d_dist_min);
gen ycf2_min = Sj - Sk - thetaest*ln(d_dist_min) 
	- theta_m_min;
gen ycf2_min_test = yhat+thetaest*ln(d_hat)-thetaest*ln(d_dist_min)
	- theta_m_min;
gen test1 = ycf2_min-ycf2_min_test;
sum test1, det;
drop test1;


* Alternative where we keep distance at zero and just reduce mjt's to min;
gen ycf2_min_alt = Sj - Sk - theta_m_min;

gen normswcf0_min=exp(ycf0_min);
gen normswcf1_min=exp(ycf1_min);
gen normswcf2_min=exp(ycf2_min);
gen normswcf2_min_alt=exp(ycf2_min_alt);
sum normsw*min*, det;


*** With median costs;
gen ycf2_med = Sj - Sk - thetaest*ln(d_dist_med) 
	- theta_m_med_2012 if year==2012;

gen normswcf2_med=exp(ycf2_med);
sum normsw*med, det;

*** Policy experiment with reduction in unionization rates;
* For occupations with unionization above median across occupation-years, 
* reduce theta_m_j by the difference between the average theta_m_j for that group
* and the average theta_m_j for occupations with unionization below median;
* This difference is computed above;
* The occupations with unionization above median in 2012 were identified above;
gen ycf_union = yhat;
replace ycf_union = yhat + cost_diff_union_m if 
	occ2dig_t1==8 | occ2dig_t1==9 | occ2dig_t1==10 | occ2dig_t1==11 | 
	occ2dig_t1==14 | occ2dig_t1==15 | occ2dig_t1==24 | occ2dig_t1==25 | 
	occ2dig_t1==27 | occ2dig_t1==30 | occ2dig_t1==35 | occ2dig_t1==36 | 
	occ2dig_t1==37 | occ2dig_t1==38 | occ2dig_t1==39 | occ2dig_t1==40 | 
	occ2dig_t1==41 | occ2dig_t1==43 | occ2dig_t1==44;
gen normswcf_union=exp(ycf_union);

*** Policy experiment with reduction in licensing rates;
* For occupations with licensing above median across occupations, 
* reduce theta_m_j by the difference between the average theta_m_j for that group
* and the average theta_m_j for occupations with licensing below median;
* This difference is computed above;
* The occupations with licensing above median were identified above;
gen ycf_lic = yhat;
replace ycf_lic = yhat + cost_diff_licensed if 
	occ2dig_t1==3 | occ2dig_t1==4 | occ2dig_t1==7 | occ2dig_t1==8 | 
	occ2dig_t1==9 | occ2dig_t1==10 | occ2dig_t1==11 | occ2dig_t1==12 | 
	occ2dig_t1==14 | occ2dig_t1==17 | occ2dig_t1==18 | occ2dig_t1==27 | 
	occ2dig_t1==29 | occ2dig_t1==30 | occ2dig_t1==31 | occ2dig_t1==36 | 
	occ2dig_t1==40 | occ2dig_t1==41;
gen normswcf_lic=exp(ycf_lic);


collapse (sum) totflows=flows totnormsw=normsw totnormswhat=normswhat 
	totnormswcf0=normswcf0 totnormswcf1=normswcf1 totnormswcf2=normswcf2
	totnormswcf0_min=normswcf0_min totnormswcf1_min=normswcf1_min 
		totnormswcf2_min=normswcf2_min 
		totnormswcf2_min_alt=normswcf2_min_alt
		totnormswcf2_med=normswcf2_med
		totnormswcf_union=normswcf_union
		totnormswcf_lic=normswcf_lic
	(mean) size=n, by(occ2dig year);

gen mobk=totnormsw/(totnormsw+1);

gen mobk_test=totflows/size;
gen test = mobk-mobk_test;
sum test, det;
drop *test*;

foreach name in hat cf0 cf1 cf2 cf0_min cf1_min cf2_min cf2_min_alt cf2_med cf_union cf_lic { ;
	gen mobk`name'=totnormsw`name'/(totnormsw`name'+1);
} ;

sum mobk*, det;


twoway scatter mobkhat mobk;
gen logmobk=ln(mobk);
gen logmobkhat=ln(mobkhat);
twoway (scatter logmobkhat logmobk) (line logmobk logmobk);

gen gapabs=mobkcf1-mobkhat;
gen gappct=(mobkcf1-mobkhat)/mobk;
gen ratiocf1=mobkcf1/mobk;
gen ratiocf2=mobkcf2/mobk;
gen frac_dist=(mobkcf0-mobkhat)/(mobkcf2-mobkhat);
gen frac_task=(mobkcf1-mobkhat)/(mobkcf2-mobkhat);

gen frac_dist_min=(mobkcf0_min-mobkhat)/(mobkcf2_min-mobkhat);
gen frac_task_min=(mobkcf1_min-mobkhat)/(mobkcf2_min-mobkhat);

gen frac_dist_min_alt=(mobkcf0-mobkhat)/(mobkcf2_min_alt-mobkhat);
gen frac_task_min_alt=(mobkcf1-mobkhat)/(mobkcf2_min_alt-mobkhat);

display "THESE ARE THE SUMMARY STATISTICS FOR TABLE tab:cf_sum OR tab:cf_young OR tab:cf_robustness";
display "THE ONES BELOW ARE BASED ON REGRESSION `whichreg' USING SAMPLE `sample'";
display "FOCUS ON THE ONES FOR _min_alt";
sum frac_dist*, det;
sum frac_task*, det;

if "`sample'"=="full" & "`whichreg'"=="reg3" { ;
display "RESULTS FOR 1994";
sum frac_dist*_min_alt if year==1994, det;
sum frac_task*_min_alt if year==1994, det;
};

***** Increase in mobility rates when all task barriers are removed, relative
* to fitted values;
display "THIS IS THE INCREASE IN MOBILITY WHEN TASK BARRIERS ARE REMOVED (BASED ON `whichreg' AND USING ALL YEARS) USING SAMPLE `sample'";
sum gapabs, det;
sum mobkhat, det;
sum mobk, det;

sum mobkcf2, det;
gen cf2stayers=1-mobkcf2;
display "THIS IS THE FRACTION OF STAYERS WHEN ALL BARRIERS ARE REMOVED (BASED ON `whichreg' AND USING ALL YEARS) USING SAMPLE `sample'";
sum cf2stayers, det;

gen test=mobkcf1-mobk;
sum test, det;
drop test;

gen test0=mobkcf0-mobkcf0_min;
sum test0, det;
gen test1=mobkcf1-mobkcf1_min;
sum test1, det;
drop test0 test1;



sort year mobk;

***** Save counterfactual mobility rates for Table \ref{tab:ratio_k} (part 1 - specific occ pairs);
if thetaest==theta50 & "`whichreg'"=="reg3" { ;
save "ratio_k", replace;

* Aggregate annual data;
collapse (mean) mobk mobkhat mobkcf* [weight=size], by(year);

***** Save counterfactual mobility rates for Table \ref{tab:ratio_k} (part 2 - aggregate);
save "ratio_k_agg", replace;

* Close if-loop for last part;
};


* Close loop over "whichreg";
};
* Close loop over "sample";
log close;
};



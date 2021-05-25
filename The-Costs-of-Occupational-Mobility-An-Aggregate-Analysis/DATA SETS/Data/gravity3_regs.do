# delimit ;

cap log close;

*cd "[directory where do-files are saved]/Built";

log using "gravity3_log", replace;

foreach sample in "full" "young" "Coll" "HS" "Long" "CodingError" { ;

	if "`sample'"=="young" { ;
	display "FROM HERE ON FOR YOUNG SAMPLE";
	cd "./Young";
	};
 	if "`sample'"=="Coll" | "`sample'"=="HS" | "`sample'"=="Long" | "`sample'"=="CodingError" { ;
	display "FROM HERE ON FOR `sample' SAMPLE";
	cd "./../`sample'";
	};
 
use "gravity_flows", clear;

	quietly sum year;
	local yr_min=r(min);
	local yr_max=r(max);
	local yr_min_plus1=`yr_min'+1;
	display "earliest year is `yr_min'";
	display "most recent year is `yr_max'";

*************************************************************
*** CHANGE ZEROS TO LOWEST OBSERVED VALUE IN WHOLE SAMPLE ***
*************************************************************;

* Find smallest non-zero value of normsw;
gen aux1 = normsw if normsw>0;
egen aux2=min(aux1);

* Change zeros to this value;
gen lognormsw_adj=lognormsw;
replace lognormsw_adj=ln(aux2) if normsw==0;
drop aux1 aux2;

gen angsep91_2 = angsep91^2;
gen angsep91_3 = angsep91^3;

gen angsep09_2 = angsep09^2;
gen angsep09_3 = angsep09^3;

* Have to omit one source and one destination in all years;
* For simplicity just drop the dummies for one of the occ's;
drop src_2 dst_2;


**************************
*** EXCLUDE ZERO FLOWS ***
**************************;
* Excluding zero flows;

# delimit ;
rename angsep91 angsep;
label var angsep "dist";

gen yhat=.;

* Run regressions for each year;
	
	*** EXCLUDE ZERO FLOWS (REG1) ***;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	reg lognormsw angsep switch_to* 
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	* Do est2vec and sum stats only for 2012;
	if `y'==2012 { ;
		est2vec gravity_reg, shvars(angsep switch_to_*) e(r2) replace;
		sum angsep if e(sample);
		scalar sdangsep91_1=r(sd);
	};
	parmest, saving("reg1_y`y'", replace);
	};
};

	*** CHANGE ZEROS TO LOWEST OBSERVED VALUE IN WHOLE SAMPLE (REG2) ***;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	reg lognormsw_adj angsep switch_to* 
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	if `y'==2012 { ;
		est2vec gravity_reg, addto(gravity_reg) name(zero1);
		twoway scatter lognormsw_adj angsep if e(sample), 
			xtitle("Task distance based on angular separation")
			ytitle("Log of ratio of switchers to stayers, 2012")
			name(scatter_2012, replace);
		if "`sample'"=="full" { ;
		graph export "scatter_2012.eps", replace;
		};
		sum angsep if e(sample);
		scalar sdangsep91_2=r(sd);
		scalar meanangsep91_2=r(mean);
		scalar minangsep91_2=r(min);
	};
	parmest, saving("reg2_y`y'", replace);
	};
};

	*** INTREG USING LOWEST OBSERVED VALUE IN WHOLE SAMPLE (REG3) ***;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	intreg lognormsw lognormsw_adj angsep switch_to* 
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	predict yhat_`y' if e(sample);
	replace yhat=yhat_`y' if year==`y';
	drop yhat_`y';
	if `y'==2012 { ;
		est2vec gravity_reg, addto(gravity_reg) name(intreg);
		display "This is the effect of a 1 sd change in distance on the dep var";
		display _b[angsep]*sdangsep91_2;
		twoway (scatter yhat lognormsw if year==2012) 
			(line lognormsw lognormsw if year==2012),
			ytitle("Fitted values") xtitle("ln(sw{subscript:kj} / sw{subscript:kk})")
			legend(off);
		if "`sample'"=="full" { ;
		graph export "fit.eps", replace;
		};
	};
	
	* Save 1992 and 1994 results for coding error table;
	if `y'==1994 & "`sample'"=="full" { ;
		est2vec coding_error_table, shvars(angsep switch_to_*) replace;
	};
	if `y'==1992 & "`sample'"=="CodingError" { ;
		est2vec coding_error_table, addto(coding_error_table) name(r1992);
		est2tex coding_error_table, replace preserve 
			path("../../TexFiles")
			mark(stars) levels(90 95 99) fancy lab 
			collab("1994 1992");
	};
	
	parmest, saving("reg3_y`y'", replace);
	};
};
	save "gravity3_reg3", replace;		


	***********************************************************************
	*** ROBUSTNESS WITH OTHER TASK COMPONENTS (MORE DOT MEASURES, ONET) ***
	***********************************************************************;
	
	
	*** MORE DOT MEASURES (REG4)*** ;
	rename angsep angsep91;
	rename angsep91alt angsep;
	drop yhat;
	gen yhat=.;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	intreg lognormsw lognormsw_adj angsep switch_to* 
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	predict yhat_`y' if e(sample);
	replace yhat=yhat_`y' if year==`y';
	drop yhat_`y';
	if `y'==2012 { ;
		twoway scatter lognormsw_adj angsep if e(sample), name(g5, replace);
		est2vec gravity_robustness, shvars(angsep angsep91_* switch_to_*
		task_pair_21 task_pair_23 task_pair_24 
		task_pair_31 task_pair_32 task_pair_34 
		task_pair_41-task_pair_43) e(r2) replace;
		sum angsep if e(sample);
		scalar sdangsep91alt=r(sd);
		scalar meanangsep91alt=r(mean);
		scalar minangsep91alt=r(min);
	};
	parmest, saving("reg4_y`y'", replace);	
	};
};
		save "gravity3_reg4", replace;
	
	*** ONET (REG5) ***;
	rename angsep angsep91alt;
	rename angsep09 angsep;
	drop yhat;
	gen yhat=.;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	intreg lognormsw lognormsw_adj angsep switch_to* 
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	predict yhat_`y' if e(sample);
	replace yhat=yhat_`y' if year==`y';
	drop yhat_`y';
	if `y'==2012 { ;
		est2vec gravity_robustness, addto(gravity_robustness) name(onet_work);
		sum angsep if e(sample);
		scalar sdangsep09=r(sd);
		scalar meanangsep09=r(mean);
		scalar minangsep09=r(min);
	};
	parmest, saving("reg5_y`y'", replace);	
	};
};
		save "gravity3_reg5", replace;
	
	*** ONET SKILLS (REG6) ***;
	rename angsep angsep09;
	rename angsep09skill angsep;
	drop yhat;
	gen yhat=.;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	intreg lognormsw lognormsw_adj angsep switch_to* 
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	predict yhat_`y' if e(sample);
	replace yhat=yhat_`y' if year==`y';
	drop yhat_`y';
	if `y'==2012 { ;
		sum angsep if e(sample), det;
		twoway scatter lognormsw_adj angsep if e(sample), name(g6, replace);
		est2vec gravity_robustness, addto(gravity_robustness) name(onet_skill);
		sum angsep if e(sample);
		scalar sdangsep09skill=r(sd);
		scalar meanangsep09skill=r(mean);
		scalar minangsep09skill=r(min);
	};
	parmest, saving("reg6_y`y'", replace);	
	};
};
		save "gravity3_reg6", replace;

	rename angsep angsep09skill;
	rename angsep91 angsep;
	
	*** INTREG WITH CUBIC IN DISTANCE (REG7) ***;
	drop yhat;
	gen yhat=.;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	intreg lognormsw lognormsw_adj angsep angsep91_* switch_to* 
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	predict yhat_`y' if e(sample);
	replace yhat=yhat_`y' if year==`y';
	drop yhat_`y';
	if `y'==2012 { ;
		est2vec gravity_robustness, addto(gravity_robustness) name(cubic);
		* Marginal effect of distance on LHS variable at mean of distance;
		display _b[angsep]+2*_b[angsep91_2]*meanangsep91_2
			+3*_b[angsep91_3]*(meanangsep91_2)^2;
	};
	parmest, saving("reg7_y`y'", replace);	
	};
};
		save "gravity3_reg7", replace;


	*** Check how things look when using dummies for different combinations of broad tasks (REG8) ***;
	drop yhat;
	gen yhat=.;
foreach y of numlist `yr_min'(1)`yr_max' { ;
	quietly sum lognormsw if year==`y';
	if `r(N)'!=0 { ;
	intreg lognormsw lognormsw_adj angsep 
		task_pair_21 task_pair_23 task_pair_24 
		task_pair_31 task_pair_32 task_pair_34 
		task_pair_41-task_pair_43
		src_* dst* if occ2dig~=occ2dig_t1 & year==`y';
	predict yhat_`y' if e(sample);
	replace yhat=yhat_`y' if year==`y';
	drop yhat_`y';
	if `y'==2012 { ;
		est2vec gravity_robustness, addto(gravity_robustness) name(task_pair);
		display "This is the effect of a 1 sd change in distance on the dep var";
		display _b[angsep]*sdangsep91_2;
	};
	parmest, saving("reg8_y`y'", replace);
	};
};

		save "gravity3_reg8", replace;




if "`sample'"=="full" { ;
est2tex gravity_reg, replace preserve 
     	path("../TexFiles")
	mark(stars) levels(90 95 99) fancy lab 
	collab("No~Zeros Zeros~Replaced Tobit");

est2tex gravity_robustness, replace preserve 
     	path("../TexFiles")
	mark(stars) levels(90 95 99) fancy lab 
	collab("DOT~Alt OnetWork ONetSkill Benchmark~Cubic Task~Pairs");
};	
	
*** POOL YEARS ***;
foreach num of numlist 1(1)8 { ;
	use "reg`num'_y`yr_min'", clear;
	gen year=`yr_min';
	erase "reg`num'_y`yr_min'.dta";
		foreach y of numlist `yr_min_plus1'(1)`yr_max' { ;
			capture append using "reg`num'_y`y'";
			replace year=`y' if year==.;
		capture erase "reg`num'_y`y'.dta";
		};
	if `num'>2 { ;
		drop if eq=="lnsigma";
		drop eq;
	};
	save "reg`num'", replace;
};


*** SAVE ESTIMATED SOURCE AND DESTINATION FIXED EFFECTS ***;
foreach num of numlist 1 3(1)8 { ;
use "reg`num'", clear;
	
split parm, p(_);

keep if parm1=="src" | parm1=="dst"; * Keep only source and destin dummies;
keep parm1 parm2 year estimate;
reshape wide estimate, i(parm2 year) j(parm1) string;

rename parm2 occ2dig;
destring occ2dig, replace;

save "reg`num'_src_dst", replace;
};


*** Save annual intercepts***;
foreach num of numlist 3(1)8 { ;
use "reg`num'", clear;
keep if parm=="_cons";
save "reg`num'_cons", replace;
};

};


log close;

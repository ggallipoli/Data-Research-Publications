
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

	
	
****************************************************************************************************	
*************************** Grouped sample and estimation ****************************
****************************************************************************************************
	
	
*********************************************************
* k-means grouping estimation (100 average skills and wages)
*********************************************************			

	global skill norm // dummy stanine norm
	global prd 2 // 1 2 3

	use "out/estimSmpl2020.dta", replace	
	
	keep year per_id alder workp1_id org1_id logku1ink cog noncog sec2digit sni_leo occ ssyk

* select the estimation period
	gen byte period1 = year>=1990 & year<=1999
	gen byte period2 = year>=1999 & year<=2008	
	gen byte period3 = year>=2008 & year<=2017
	keep if period${prd}==1
	drop period*
	gen period = ${prd}	
	
* connected set of firm groups for estimation
	a2group, individual(per_id) unit(workp1_id) groupvar(connect)
	bysort connect: egen connect_size = count(per_id)
	egen max_connect_size = max(connect_size)
	keep if connect_size == max_connect_size
	drop *connect*		
	
	drop if cog==. | noncog==.
	
* control variables
	if "${prd}" == "1" { 
		gen time_ID = 0 if inlist(year,1990,1991)
			replace time_ID = 1 if inlist(year,1992,1993)
			replace time_ID = 2 if inlist(year,1994,1995)
			replace time_ID = 3 if inlist(year,1996,1997)
			replace time_ID = 4 if inlist(year,1998,1999)
			tab year time_ID, miss	
	}	
	if "${prd}" == "2" { 
		gen time_ID = 0 if inlist(year,1999,2000)
			replace time_ID = 1 if inlist(year,2001,2002)
			replace time_ID = 2 if inlist(year,2003,2004)
			replace time_ID = 3 if inlist(year,2005,2006)
			replace time_ID = 4 if inlist(year,2007,2008)
			tab year time_ID, miss	
	}
	if "${prd}" == "3" { 
		gen time_ID = 0 if inlist(year,2008,2009)
			replace time_ID = 1 if inlist(year,2010,2011)
			replace time_ID = 2 if inlist(year,2012,2013)
			replace time_ID = 3 if inlist(year,2014,2015)
			replace time_ID = 4 if inlist(year,2016,2017)
			tab year time_ID, miss	
	}
	
	gen age_ID = 0 if alder<=25
		replace age_ID = 2 if alder>25 & alder<=32
		replace age_ID = 3 if alder>32 & alder<=42
		replace age_ID = 4 if alder>42 
		tab alder age_ID, miss
	gen C_ID = cog >= 4
	replace C_ID = 2 if cog >= 7
	gen N_ID = noncog >= 4
	replace N_ID = 2 if noncog >= 7	
	
	egen int alder_S_year = group(age_ID C_ID N_ID time_ID)
		
* skill scaling
	gen C = cog
	gen N = noncog	
	if "${skill}" == "norm" { 
		replace C = (cog - 1)/8 // make uniform within [0,1]
		replace N = (noncog - 1)/8
	}	
	tab C N
	
* grouping firms	
	bysort workp1_id: egen avgC = mean(cog)
	bysort workp1_id: egen avgN = mean(noncog)	
	bysort workp1_id: egen avgW = mean(logku1ink)	

	foreach v in avgW avgC avgN {
	egen z_`v' = std(`v')
	}	
	display "$S_TIME $S_DATE"
	cluster kmeans z_*, k(100) measure(L2) generate(kmeangp) //iterate(100)	
	display "$S_TIME $S_DATE"	

* estimate
	reghdfe logku1ink, absorb(lmbC=kmeangp##c.C lmbN=kmeangp##c.N  perFe=per_id control=alder_S_year) 
		gen lmb0 = lmbC + lmbN
		drop lmbC lmbN
	
		display "$S_TIME $S_DATE"
		describe 
	foreach skill in C N {
	gen lmb`skill' = lmb`skill'Slope1 if lmb`skill'Slope!=0 
	}	

	compress
	drop alder_S_year *Slope*
	save "out/estim_${skill}_prd${prd}", replace
	
	
	
********************************************************************************************************************************************************	
************************************************* Construct the firm-level sample *************************************************
********************************************************************************************************************************************************	
				
	
*********************************************************
* Construct leave-one-out connected set (dual connected, and for both C and N skills)
*********************************************************			

use "out/estimSmpl1999_2008.dta", replace
	tab cog noncog, miss
	gen S = 0 
	replace S = 1 if cog>=6 & noncog<=5 
	replace S = 1 if cog<=5 & noncog>=6 
	replace S = 2 if cog>=6 & noncog>=6
	tab S 
	
forvalues skill = 0(1)2 {	
preserve	
	keep if S==`skill'
	
		a2group, individual(per_id) unit(workp1_id) groupvar(connect)
		bysort connect: egen connect_size = count(per_id)
		egen max_connect_size = max(connect_size)
		keep if connect_size == max_connect_size
		drop *connect*	

	replace per_id = -1 * per_id
	export delimited workp1_id per_id using "out/network-full-s`skill'.txt", novarnames nolabel replace 
restore	
}

/// RUN networkconstruction.py on these data, then...

* ... read in and create a dual connected set (have to iterate..)
	import delimited "out/result-full-s0.txt", encoding(Big5) clear 
	gen workp1_id = v1
	replace workp1_id = v2 if v1<0 & v2>=0
	keep workp1_id	
	duplicates drop workp1_id, force
	tempfile temper
	save `temper'
	import delimited "out/result-full-s1.txt", encoding(Big5) clear 
	gen workp1_id = v1
	replace workp1_id = v2 if v1<0 & v2>=0
	keep workp1_id	
	duplicates drop workp1_id, force
	merge 1:1 workp1_id using `temper', keep(1 2 3) gen(merger1) // the dual connected firms of the current round
	save `temper', replace
	import delimited "out/result-full-s2.txt", encoding(Big5) clear 
	gen workp1_id = v1
	replace workp1_id = v2 if v1<0 & v2>=0
	keep workp1_id	
	duplicates drop workp1_id, force	
	merge 1:1 workp1_id using `temper', keep(1 2 3) gen(merger2) // the dual connected firms of the current round
	
	gen byte notconverged = merger1!=3 | merger2!=3
	sort notconverged
	assert notconverged[_N] == 1  // if the assertion is false, the algorithm has converged (dual leave-one-out connected sample identified)
	
	keep if merger1==3 & merger2==3
	merge 1:n workp1_id using "out/estimSmpl1999_2008.dta", keep(1 3) nogen // merge and save for next round	

	gen S = 0 
	replace S = 1 if cog>=6 & noncog<=5 
	replace S = 1 if cog<=5 & noncog>=6 
	replace S = 2 if cog>=6 & noncog>=6
	
forvalues skill = 0(1)2 {	
preserve	
	keep if S==`skill'		
		a2group, individual(per_id) unit(workp1_id) groupvar(connect)
		bysort connect: egen connect_size = count(per_id)
		egen max_connect_size = max(connect_size)
		keep if connect_size == max_connect_size
		drop *connect*		

	replace per_id = -1 * per_id
	export delimited workp1_id per_id using "out/network-full-s`skill'.txt", novarnames nolabel replace
restore	
}
		
	
	
*********************************************************
* Finally, collapse to the match level (person-firm matches) 
* and save for import to python
*********************************************************				

	import delimited "out/result-s1.txt", encoding(Big5) clear // it does not matter which one of the connected files we pick
	gen workp1_id = v1
	replace workp1_id = v2 if v1<0 & v2>=0
	keep workp1_id
	duplicates drop workp1_id, force
	merge 1:n workp1_id using "out/estimSmpl1999_2008.dta", keep(1 3) nogen 	

	* drop singleton observations (ie inviduals who stay in the same firm as in match level implementation) as they lead to missings in stata and P=1 leverages
	by per_id workp1_id, sort: gen helper = _n == 1
	by per_id: egen nbr_emplyrs = total(helper) 
	drop if nbr_emplyrs == 1

	collapse logku1ink cog noncog year alder (count) matchFreq=logku1ink, by(per_id workp1_id) fast	

	sort per_id workp1_id
	egen worker_ID = group(per_id) 
	sum worker_ID
	replace worker_ID = worker_ID-1
	assert worker_ID[_n+1] == worker_ID | worker_ID[_n+1] == worker_ID+1 if _n<_N

	sort workp1_id
	egen firm_ID = group(workp1_id) 
	sum firm_ID
	replace firm_ID = firm_ID-1
	assert firm_ID[_n+1] == firm_ID | firm_ID[_n+1] == firm_ID+1 if _n<_N

	tab cog noncog, miss
	gen worker_C = cog 
	gen worker_CID = worker_C

	gen worker_N = noncog 
	gen worker_NID = worker_N

	replace year = floor(year)
	gen time_ID = year - 1999
	tab year time_ID, miss
	
	gen alder2 = alder
	replace alder = floor(alder)
	gen age_ID = 0 if alder<=25
	replace age_ID = 1 if alder>25 & alder<=32
	replace age_ID = 2 if alder>32 & alder<=42
	replace age_ID = 3 if alder>42 
	tab alder age_ID, miss

	rename logku1ink wage
	
	keep worker_ID firm_ID matchFreq worker_C worker_CID worker_N worker_NID time_ID age_ID wage
	order worker_ID firm_ID matchFreq worker_C worker_CID worker_N worker_NID time_ID age_ID wage
	sort worker_ID firm_ID time_ID matchFreq

	foreach vrbl in worker_ID firm_ID matchFreq worker_C worker_CID worker_N worker_NID time_ID age_ID wage {
		display "`vrbl'"
	export delimited `vrbl' using "out/full/`vrbl'.txt", novarnames nolabel replace	
	}	
		


clear all
/************************************************************************
Canada Covid Revison 2021 - data update and validation

created by Xianya 03/03/2021
************************************************************************/




// Xianya's laptop
if strpos("`c(hostname)'","XIANYAs-MacBook-Pro.local")!=0 {
	cd "/Users/xianya/Dropbox/2020 - Canada COVID"
	}

// Xianya's desktop
if strpos("`c(hostname)'","ARTS-ECON-053B")!=0 {
	cd "C:\Users\User\Dropbox\2020 - Canada COVID"
	}


	
/**************************************************************
Ado files
**************************************************************/

global adobase "../2020 - Canada COVID/FINAL SUBMISSION/data/Ados" // Ado packages used by the project are to be found here
/* install any packages locally */
capture mkdir "$adobase"
sysdir set listex "$adobase/listtex" 
sysdir set estadd "$adobase/estadd"
sysdir set esttab "$adobase/esttab"
sysdir set eststo "$adobase/eststo"
sysdir set estout "$adobase/estout"


*** set up directories
global revision "../2020 - Canada COVID/2021- Revision - Data Update"
global henry "../2020 - Canada COVID/Final (Predictions)/merged"
global data "../2020 - Canada COVID/data" 
global empData "$revision/emp_Data" //latest Employment data 
global gdpData "$revision/GDP_Data" //latest GDP data 
global emp_plot "$revision/employement_plot"
global GDP_plot "$revision/GDP_plot"
global GDP_table "$revision/GDP_table"
global empDataProvince "$empData/emp_province_2020"
global dingel "../2020 - Canada COVID/Dingel and Neimann (Predictions)" 




*** Input the date of new released data if applicable
global latestEmpData "0101_2103" // our newest employment data is in 2021/03
global latestGDPdata 2102 // our newest GDP data is in 2021/02
global version "_2102" 

global GDP_plot${version} "$revision/GDP_plot${version}"




cap program drop main
program define main
	syntax[anything]
	
	
	** prepare Employment data and GDP data; generate a dataset including indices 
	dataprep, latestEmpData(${latestEmpData}) latestGDPdata(${latestGDPdata}) 
	
	*** compute the employement & GDP related stats (L, H, Aggregate) 
	*emp_gdp_stats
	
	
	*** compute the aggregate/by resilience GDP plots 
	* gdp_plot
	
	*** compute the by industry GDP plots + Table 6
	*industry_plot
	
	*** compute the by province GDP plots + Table 7
	*province_plot
	
	*** elasticity regression, table 1, table 3 
	*regression
	
	*** bubble graphs
	*bubble
	
	*** compute GDP level, table 4 
	*GDP_level_table
	
	*** compute GDP Growth rate, table 5
	*GDP_growth_table
	

end




************************************************************************

cap program drop dataprep
program define dataprep

		syntax[anything], latestEmpData(string) latestGDPdata(integer)
		
**** old GDP&Emp data
		
	preserve
		import excel "$data/Combined-GDP and employment.xlsx", sheet("Combined GDP&Emp Canada") firstrow clear
		drop if ProvinceCode==.
		rename ReferenceDate reference_date
		rename Employementfigures employement_figures
		rename Year year
		rename Month month
		keep reference_date Industry employement_figures month year GDP
		merge m:1 Industry using "$henry/matchind_it_ci_wfh_merged.dta", keepusing(IndustryCode ind_codes it ci wfh itxwfh GDP_newgroup) keep(3) force nogen
		tempfile orginalData
		save `orginalData'
	restore
		
*** prepare latest employement data	

	import delimited "$empData/emp_databaseLoadingData_`latestEmpData'.csv", clear
	
	rename northamericanindustryclassificat Industry
	rename ïref_date reference_date
	rename value employement_figures
	keep reference_date Industry employement_figures

	gen year = substr(reference_date, 1, 4)
	gen month = substr(reference_date, 6, 7)
	replace month = usubstr(month, 2, .) if usubstr(month,1,1) == "0" 
	destring , replace
	
  ** merge with IT-intensity & WFH-index & Resilience data

	replace Industry = "Goods-producing industries [T002]" if Industry == "Goods-producing sector"
	replace Industry = "Total employed, all industries  [T001]" if Industry == "Total employed, all industries"
	replace Industry = "Services-producing sector [T003]" if Industry == "Services-producing sector"


	merge m:1 Industry using "$henry/matchind_it_ci_wfh_merged.dta", keepusing(IndustryCode ind_codes it ci wfh itxwfh GDP_newgroup) keep(3) force nogen
	cap drop if IndustryCode == "T001"
	cap drop if IndustryCode == "T002"
	
	tempfile emp_data
	save `emp_data', replace
	
	use `emp_data', clear
	

*** prepare latest GDP data for all years from 2001 - latest month
	
			import delimited "$gdpData/`latestGDPdata'.csv", clear 
			
			rename northamericanindustryclassificat Industry
			rename ïref_date reference_date
			rename value GDP
			keep if seasonaladjustment == "Seasonally adjusted at annual rates"
			keep if prices == "Chained (2012) dollars"
			keep reference_date Industry GDP
			gen year = substr(reference_date, 1, 4)
			gen month = substr(reference_date, 6, 7)
			replace month = usubstr(month, 2, .) if usubstr(month,1,1) == "0" 
			destring , replace
	
	
			***** Industry class changes, re-organize the industries
			
			replace Industry = "Agriculture [111-112, 1100, 1151-1152]" if Industry == "Agriculture, forestry, fishing and hunting [11]"
			
			replace Industry = "Forestry, fishing, mining, quarrying, oil and gas [21, 113-114, 1153, 2100]" if Industry == "Mining, quarrying, and oil and gas extraction [21]"
			
			replace Industry = "Business, building and other support services [55-56]" if Industry == "Management of companies and enterprises [55]"
			replace Industry = "Business, building and other support services [55-56]" if Industry == "Administrative and support, waste management and remediation services [56]"
			
			replace Industry = "Information, culture and recreation [51, 71]" if Industry == "Arts, entertainment and recreation [71]"
			replace Industry = "Information, culture and recreation [51, 71]" if Industry == "Information and cultural industries [51]"
			
			replace Industry = "Wholesale and retail trade [41, 44-45]" if Industry == "Wholesale trade [41]"
			replace Industry = "Wholesale and retail trade [41, 44-45]" if Industry == "Retail trade [44-45]"
			
			replace Industry = "Finance, insurance, real estate, rental and leasing [52-53]" if Industry == "Finance and insurance [52]"
			replace Industry = "Finance, insurance, real estate, rental and leasing [52-53]" if Industry == "Real estate and rental and leasing [53]"
			
			replace Industry = "Total employed, all industries  [T001]" if Industry == "All industries [T001]"
			collapse (sum) GDP, by (year month Industry reference_date)
*			
			
			
  ** merge with IT-intensity & WFH-index & Resilience data

	merge m:1 Industry using "$henry/matchind_it_ci_wfh_merged.dta", keepusing(IndustryCode ind_codes it ci wfh itxwfh GDP_newgroup) keep(3) force nogen
	cap drop if IndustryCode == "T001"
	cap drop if IndustryCode == "T002"
	
	save "$gdpData/allyears_gdp_data${version}.dta", replace
	
	
	use "$gdpData/allyears_gdp_data${version}.dta", clear
	
	
*** merge all the data

	merge 1:1 Industry month year using `emp_data', keep(3) nogen
	
	//append using `orginalData'
	
	drop if GDP==.
	
	order year month Industry
	sort year month Industry
	save "${revision}/allyears_final_update_data${version}.dta", replace
	
	
			
	
	
end



cap program drop emp_gdp_stats
program define emp_gdp_stats

		syntax[anything]

*** compute the growth rate of employment& GDP and levels of GDP
	local realized "_realized"
	
	foreach type in 1 2 3{

	** all industries
		if `type' == 1 {
		local case ""
		}
	** High resilience industries
		if `type' == 2 {
		local case "H"
		}
	** Low resilience industries
		if `type' == 3 {
		local case "L"
		}
		
		
		
		use "$revision/allyears_final_update_data${version}.dta", clear
		keep if year >= 2019
		
		drop if Industry == "Agriculture [111-112, 1100, 1151-1152]"
		/*
		
		*** check if all years data is consistent to what we used before - Yes
		
		preserve
		use "$revision/allyears_final_update_data.dta", clear
		keep if year >= 2019
		
		keep year month Industry GDP employement_figures
		rename GDP GDP_new
		rename employement_figures employement_figures_new
		tempfile new
		save `new'
		restore
		
		merge 1:1 year month Industry using `new'
		keep year month Industry GDP* emp*
		gen diff = GDP_new - GDP
		
		*/
		
		
		egen indid = group(IndustryCode)
		egen tid = group(year month)
		tsset indid tid
		
		quietly sum itxwfh, d
		gen highitxwfh=cond(itxwfh>`r(p50)',1,0) // indicator for above median
		replace highitxwfh =. if itxwfh ==.
		//gen emp_growth_highitxwfh = emp_growth * highitxwfh


		if `type' == 2 {
			keep if highitxwfh == 1
		}
		if `type' == 3 {
			keep if highitxwfh == 0
		}
		
		collapse (sum) employement_figures GDP, by (year month tid)
		gen indid = 1
		tsset indid tid
		gen emp`case'_growth = (employement_figures - L12.employement_figures)/L12.employement_figures
		gen gdp`case'_growth = (GDP - L12.GDP)/L12.GDP
		
		preserve
		keep if month == 2 & year == 2020
		sum GDP
		di `r(mean)'
		local normalization `r(mean)'
		restore
		gen gdp`case'_level = GDP/`normalization' if ((year == 2020 & month >= 2) |(year == 2021))
		
		rename employement_figures emp`case'
		rename GDP gdp`case'
		tempfile `type'data
		save ``type'data', replace
	
}

	
	use `1data', clear
	merge 1:1 year month using `2data', nogen
	merge 1:1 year month using `3data', nogen
	drop indid tid
	

	
*********** merge in the predicted values we got

		** _realized : realized employment
		**  : projected employment 
		** _agri: no agriculture

	************ Baseline stats ************
	
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("aggregate baseline") firstrow clear
		rename empgrowth emp_predict
		rename C emp_growth_predict
		rename GDP gdp_predict
		rename gdpgrowth gdp_growth_predict
		rename GDPLevels gdp_level_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		keep month year gdp_growth_predict gdp_predict gdp_level_predict emp_growth_predict emp_predict Date
		tempfile p
		save `p', replace
		restore
		
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("wfh baseline") firstrow clear
		rename Employementfigures empH_predict
		rename empgrowth empH_growth_predict
		rename GDP gdpH_predict
		rename GDPgrowth gdpH_growth_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		rename H gdpH_level_predict
		replace gdpH_level_predict = "" if year == 2019 | (year == 2020 & month == 1)
		keep month year gdpH_growth_predict gdpH_predict gdpH_level_predict empH_growth_predict empH_predict Date
		destring, replace
		tempfile H_p
		save `H_p', replace
		restore
		
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("non-wfh baseline") firstrow clear
		rename Employementfigures empL_predict
		rename emp_growth empL_growth_predict
		rename GDP gdpL_predict
		rename gdpgrowth gdpL_growth_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		rename H gdpL_level_predict
		replace gdpL_level_predict = "" if year == 2019 | (year == 2020 & month == 1)
		keep month year gdpL_growth_predict gdpL_predict gdpL_level_predict empL_growth_predict empL_predict Date
		destring, replace
		tempfile L_p
		save `L_p', replace
		restore
		
		merge 1:1 year month using `p', nogen
		merge 1:1 year month using `H_p', nogen
		merge 1:1 year month using `L_p', nogen
	
	
	
	************ Optimistic stats ************
		
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("agg optimistic") firstrow clear
		rename empgrowth op_emp_predict
		rename C op_emp_growth_predict
		rename GDP op_gdp_predict
		rename gdpgrowth op_gdp_growth_predict
		rename GDPLevels op_gdp_level_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		keep month year op* Date
		tempfile op_p
		save `op_p', replace
		restore
		
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("wfh optimistic") firstrow clear
		rename Employementfigures op_empH_predict
		rename empgrowth op_empH_growth_predict
		rename GDP op_gdpH_predict
		rename GDPgrowth op_gdpH_growth_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		rename L op_gdpH_level_predict
		replace op_gdpH_level_predict =. if year == 2019 | (year == 2020 & month == 1)
		keep month year op* Date
		tempfile op_H_p
		save `op_H_p', replace
		restore
		
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("non-wfh optimistic") firstrow clear
		rename Employementfigures op_empL_predict
		rename emp_growth op_empL_growth_predict
		rename GDP op_gdpL_predict
		rename gdpgrowth op_gdpL_growth_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		rename K op_gdpL_level_predict
		replace op_gdpL_level_predict =. if year == 2019 | (year == 2020 & month == 1)
		keep month year op* Date
		tempfile op_L_p
		save `op_L_p', replace
		restore
		
		merge 1:1 year month using `op_p', nogen
		merge 1:1 year month using `op_H_p', nogen
		merge 1:1 year month using `op_L_p', nogen
	
	
	/*
	************ Pessimistic stats ************
	
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("agg delayed") firstrow clear
		rename empgrowth pe_emp_predict
		rename C pe_emp_growth_predict
		rename GDP pe_gdp_predict
		rename gdpgrowth pe_gdp_growth_predict
		rename GDPLevels pe_gdp_level_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		keep month year pe* Date
		tempfile pe_p
		save `pe_p', replace
		restore
		
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("wfh delayed") firstrow clear
		rename Employementfigures pe_empH_predict
		rename empgrowth pe_empH_growth_predict
		rename GDP pe_gdpH_predict
		rename GDPgrowth pe_gdpH_growth_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		rename L pe_gdpH_level_predict
		replace pe_gdpH_level_predict =. if year == 2019 | (year == 2020 & month == 1)
		keep month year pe* Date
		tempfile pe_H_p
		save `pe_H_p', replace
		restore
		
		preserve
		import excel "$revision/gdp predictions_new`realized'_agri.xlsx", sheet("non-wfh delayed") firstrow clear
		rename Employementfigures pe_empL_predict
		rename emp_growth pe_empL_growth_predict
		rename GDP pe_gdpL_predict
		rename gdpgrowth pe_gdpL_growth_predict
		gen month = month(Date) 
		gen year = year(Date)
		drop if Date ==.
		rename L pe_gdpL_level_predict
		replace pe_gdpL_level_predict =. if year == 2019 | (year == 2020 & month == 1)
		keep month year pe* Date
		tempfile pe_L_p
		save `pe_L_p', replace
		restore
		
		merge 1:1 year month using `pe_p', nogen
		merge 1:1 year month using `pe_H_p', nogen
		merge 1:1 year month using `pe_L_p', nogen
	
	*/
		
	order Date year month gdp gdp_predict gdp_growth gdp_growth_predict gdpH gdpH_predict gdpH_growth gdpH_growth_predict gdpL gdpL_predict gdpL_growth gdpL_growth_predict gdp_level gdp_level_predict gdpH_level gdpH_level_predict gdpL_level gdpL_level_predict emp emp_predict emp_growth emp_growth_predict empH empH_predict empH_growth empH_growth_predict empL empL_predict empL_growth empL_growth_predict
	
	//emp from 06/20 predict values
	//gdp from 03/20 predict values
	
	save "${revision}/update_new`realized'_merged_data_model_noagri${version}.dta", replace
	
end



cap program drop gdp_plot
program define gdp_plot

	syntax[anything]
		
	use "${revision}/update_new_merged_data_model_noagri${version}.dta", clear
	
	preserve
	use "${revision}/update_new_realized_merged_data_model_noagri${version}.dta", clear
	keep Date year month gdp*predict
	rename gdp*predict real_gdp*predict
	tempfile realized
	save `realized'
	restore
	
	merge 1:1 Date year month using `realized', nogen
	cap drop *emp*
	cap drop if (year < 2020 | (year == 2022 & month > 1))


		
**************** Appendix A.2, 

*bar graph for quarterly growth rates (year to year)*
if 1 == 1{

foreach year in 20 21{

	preserve
	keep if year==20`year' & month <= 6 & month >= 4
	gen Quarters = "Apr-Jun 20`year'"
	keep Quarters *gdp*growth* 
	collapse (mean) *gdp*growth* , by(Quarter)
	tempfile Apirl`year'
	save `Apirl`year''
	restore

	 
	preserve
	keep if year==20`year' & month <= 9 & month >= 7
	gen Quarters = "Jul-Sep 20`year'"
	keep Quarters *gdp*growth* 
	collapse (mean) *gdp*growth* , by(Quarter)
	tempfile Jun`year'
	save `Jun`year''
	restore

	preserve
	keep if year==20`year' & month <= 12 & month >= 10
	gen Quarters = "Oct-Dec 20`year'"
	keep Quarters *gdp*growth* 
	collapse (mean) *gdp*growth* , by(Quarter)
	tempfile Oct`year'
	save `Oct`year''
	restore

}
	
	preserve
	keep if year==2021 & month <= 3 & month >= 1
	gen Quarters = "Jan-Mar 2021"
	keep Quarters *gdp*growth* 
	collapse (mean) *gdp*growth* , by(Quarter)
	tempfile Jan21
	save `Jan21'
	restore
	
	preserve
	use `Jan21', clear
	foreach year in 20 21{
		append using `Apirl`year''
		append using `Jun`year''
		append using `Oct`year''
		
		}
	tempfile quarterData
	save `quarterData'
	restore



	preserve
	
	use `quarterData', clear
	
	gen order = 1 if Quarters == "Apr-Jun 2020"
	replace order = 2 if Quarters == "Jul-Sep 2020"
	replace order = 3 if Quarters == "Oct-Dec 2020"
	replace order = 4 if Quarters == "Jan-Mar 2021"
	replace order = 5 if Quarters == "Apr-Jun 2021"
	replace order = 6 if Quarters == "Jul-Sep 2021"
	replace order = 7 if Quarters == "Oct-Dec 2021"
	
	
	
/*
	foreach type in 1 2 3{

		** baseline
			if `type' == 1 {
			local case ""
			local title "for baseline recovery"
			local name "Baseline"
			}
		** optimistic
			if `type' == 2 {
			local case "op_"
			local title "for a benign recovery"
			local name "Optimistic"
			}
		** pessimistic
			if `type' == 3 {
			local case "pe_"
			local title "in case of a second wave"
			local name "Pessimistic"
			}

	graph bar (asis) gdp_growth `case'gdp_growth_predict, over (Quarters,sort(order) label(angle(45))) bar(1, col(gs7))  bar(2, col(navy*0.7)) bar(3, col(gs4))  bar(4, col(navy)) bar(5, col(gs13))  bar(6, col(navy*0.4)) title("Annual GDP growth (%) `title', by quarter", size(large)) subtitle("Comparing with the real GDP growth for all industries (Mar20 - Dec20)", size(medsmall)) ytitle("GDP growth in percent") legend(size(medsmall)) legend(label(1 Real Data) label(2 Model)) 
	
	graph export "${GDP_plot}/update_`name'_quarter.png", replace

	}
	
*/
	set scheme s1mono

		graph bar (asis) gdp_growth_predict op_gdp_growth_predict real_gdp_growth_predict gdp_growth, over (Quarters,sort(order) label(angle(45))) title("Annual GDP growth (%) `title', by quarter", size(large)) subtitle("Compared with the real GDP growth until Feb 2021", size(medsmall)) ytitle("GDP growth in percent") legend(size(medsmall)) legend(label(1 Baseline) label(2 Benign Outlook) label(3 Baseline (Realized Employment)) label(4 Real GDP Growth)) 
			
		graph export "${GDP_plot${version}}/quarter_noagri.png", replace
	
	
	*** Produce a table for Annual GDP Growth by Industry type, no use
	if 1==0{
	drop *gdp_* 
	order order Quarters gdpH_growth_predict gdpL_growth_predict op_gdpH_growth_predict op_gdpL_growth_predict pe_gdpH_growth_predict pe_gdpL_growth_predict  gdpH_growth gdpL_growth
	sort order
	drop order
	ds, has(type numeric)
	format `r(varlist)' %9.3f
	listtex using "${GDP_plot${version}}/update_quarter_table.tex", rstyle(tabular) replace
	}
	restore
		
}		
		
*************** GDP levels --- Figure 4, 5, 6
if 1 == 1{
	
	set scheme s1color
	
	foreach type in 1 2 {
	
		** baseline
			if `type' == 1 {
			local case ""
			local title "Case 1: Recovery based on The Great Recession"
			local name "Baseline"
			}
		** optimistic
			if `type' == 2 {
			local case "op_"
			local title "Case 2: Benign Outlook Recovery"
			local name "Optimistic"
			}
		** pessimistic
			if `type' == 3 {
			local case "pe_"
			local title "Case 3 Pessimistic GDP Forecast"
			local name "Pessimistic"
			}
		
		twoway line gdp_level `case'gdp_level_predict gdpH_level `case'gdpH_level_predict gdpL_level `case'gdpL_level_predict Date, ///
					sort clcolor(black grey*0.4 black grey*0.4 black grey*0.4) ///
					clpattern(solid solid longdash longdash shortdash shortdash) ///
					clwidth(medium medthick medium medthick medium medthick) ///
					title("`title'") ///
					ytitle("GDP Level") ///
					xtitle("") ylabel(#6 ,grid) yscale(range(0.85 1.05) titlegap(*+5)) xlabel(#9) ///
					legend(label(1 Data (All Industries)) label(2 Model (All)) label(3 Data (High Resilience Industries)) label(4 Model (High Resilience)) label(5 Data (Low Resilience Industries)) label(6 Model (Low Resilience))) 
				
			graph export "${GDP_plot${version}}/gdp_levels_`name'_noagri.png", replace
			
			if `type' == 1 {
		twoway line gdp_level real_gdp_level_predict gdpH_level real_gdpH_level_predict gdpL_level real_gdpL_level_predict Date, ///
					sort clcolor(black grey*0.5 black grey*0.5 black grey*0.6) ///
					clpattern(solid solid longdash longdash shortdash shortdash) ///
					clwidth(medium medthick medium medthick medium medthick) ///
					title("`title'") ///
					subtitle("Using the realized employement to estimate GDP until Feb 2021") ///
					ytitle("GDP Level") ///
					xtitle("") ylabel(#6 ,grid) yscale(range(0.85 1.05) titlegap(*+5)) xlabel(#9) ///
					legend(label(1 Data (All Industries)) label(2 Model (All)) label(3 Data (High Resilience Industries)) label(4 Model (High Resilience)) label(5 Data (Low Resilience Industries)) label(6 Model (Low Resilience))) 
				
			graph export "${GDP_plot${version}}/gdp_levels_`name'_real_emp_noagri.png", replace
			}

	}
}

if 1 == 1{
	
	
	set scheme s1color
	
	twoway line gdp_level op_gdp_level_predict gdp_level_predict real_gdp_level_predict Date, ///
					sort clcolor(black grey*0.5 grey*0.5 grey*0.5) ///
					clpattern(solid dash longdash shortdash)  ///
					clwidth(medium medthick medthick medthick) ///
					title("Possible GDP Recovery Paths") ///
					ytitle("GDP Level") ///
					xtitle("") ylabel(#6 ,grid) yscale(range(0.85 1.05) titlegap(*+5)) xlabel(#9) ///
					legend(label(1 Real GDP Levels) label(2 Benign Outlook Projection) label(3 Baseline Projection) label(4 Baseline (realized employement)))
				
			graph export "${GDP_plot${version}}/update_gdp_levels_all_paths.png", replace
			
}	
		
			
	
end




cap program drop industry_plot
program define industry_plot

	syntax[anything]
		
	use "${revision}/allyears_final_update_data${version}.dta", clear
	drop if year < 2019
	
	set scheme s1mono

	replace Industry = "Public administration" if IndustryCode == "91"
	replace Industry = "Other services (except public administration)" if IndustryCode == "81"
	replace Industry = "Accommodation and food services" if IndustryCode == "72"
	replace Industry = "Health care and social assistance" if IndustryCode == "62"
	replace Industry = "Educational services" if IndustryCode == "61"
	replace Industry = "Business, building and other support services" if IndustryCode == "55-56"
	replace Industry = "Professional, scientific and technical services" if IndustryCode == "54"
	replace Industry = "Finance, insurance, real estate, rental and leasing" if IndustryCode == "52-53"
	replace Industry = "Information, culture and recreation" if IndustryCode == "51, 71"
	replace Industry = "Transportation and warehousing" if IndustryCode == "48-49"
	replace Industry = "Wholesale and Retail Trade" if IndustryCode == "41, 44-45"
	replace Industry = "Manufacturing" if IndustryCode == "31-33"
	replace Industry = "Construction" if IndustryCode == "23"
	replace Industry = "Utilities" if IndustryCode == "22"
	replace Industry = "Mining, quarrying, oil and gas" if IndustryCode == "21, 113-114, 1153, 2100"
	replace Industry = "Agriculture" if IndustryCode == "111-112, 1100, 1151-1152"

	egen indid = group(IndustryCode)
	egen tid = group(year month)
	tsset indid tid
	gen gdp_growth = ((GDP - L12.GDP)/L12.GDP)*100
	
	preserve
	collapse (sum) GDP, by(year month)
	gen Industry = "All industries"
	egen indid = group(Industry)
	egen tid = group(year month)
	tsset indid tid
	gen gdp_growth = ((GDP - L12.GDP)/L12.GDP)*100
	tempfile aggregate
	save `aggregate'
	restore
	
	append using `aggregate'
	keep if year == 2021 & month == 2   // GDP growth from Feb 2020 to Feb 2021
	keep gdp_growth Industry

	

	preserve
	import excel "${revision}/gdp_prediction_new.xlsx", sheet ("Industry") firstrow clear
	rename gdp_growth gdp_growth_predict  // predicted GDP growth from Feb 2020 to Feb 2021
	rename gdp_growth_optimistic gdp_growth_op_predict
	tempfile predict
	save `predict'
	restore
	
	merge 1:1 Industry using `predict', nogen

	drop if Industry == "Agriculture"

**************** Figure 7 GDP growth for industries

	graph bar (asis) gdp_growth_predict gdp_growth gdp_growth_op_predict, over (Industry, sort(order) label(angle(45))) scale(0.7) title("GDP growth from Feb 2020 to Feb 2021, by Industry", size(large)) ytitle("GDP growth in percent") legend(size(medsmall)) legend(label(1 Baseline Projection) label(2 Real GDP Growth) label(3 Benign Outlook Projection)) ylabel(#8) bar(1, color(grey*0.7)) bar(2, color(grey*0.5)) bar(3, color(grey*0.3))
	graph export "${GDP_plot${version}}/industry_no_agri.png", replace
	
	/*
	graph bar (asis) gdp_growth gdp_growth_op_predict, over (Industry, sort(order) label(angle(45))) scale(0.7) title("GDP growth from Feb 2020 to Dec 2020, by Industry", size(large)) ytitle("GDP growth in percent") legend(size(medsmall)) legend(label(1 Real GDP Growth) label(2 Optimistic Estimated GDP Growth)) ylabel(#8) 
	graph export "${GDP_plot}/industry_optimistic.png", replace
	*/
	
/*
	preserve
	import excel "${revision}/gdp_prediction.xlsx", sheet ("Industry") firstrow clear
	rename gdp_growth gdp_growth_predict  // predicted GDP growth from Feb 2020 to Feb 2021
	rename gdp_growth_optimistic gdp_growth_op_predict
	graph bar (asis) gdp_growth_predict gdp_growth_op_predict, over (Industry, sort(order) label(angle(45))) scale(0.7) title("GDP growth from Feb 2020 to Feb 2021, by Industry", size(large)) ytitle("GDP growth in percent") legend(size(medsmall)) legend(label(1 GDP Growth Baseline) label(2 Optimistic Estimated GDP Growth)) ylabel(#8) 
	graph export "${GDP_plot}/industry_figure8.png", replace
	restore
*/

**************** Table 6 GDP growth for industries

	sort order Industry gdp_growth_predict gdp_growth_op_predict gdp_growth	
	order order Industry gdp_growth_predict gdp_growth_op_predict gdp_growth	
	drop order
	
	ds, has(type numeric)
	format `r(varlist)' %9.3f
	
	
	*
	rename gdp_growth_predict baseline
	rename gdp_growth_op_predict optimistic
	rename gdp_growth real
	corr baseline optimistic real
	*
	
	listtex using "${GDP_table}/gdp_industry_table${version}.tex", rstyle(tabular) replace

	
**************** Figure 9 GDP growth for industries - Dingel & Neimann	

	preserve
	import excel "${revision}/gdp_prediction_new.xlsx", sheet ("Industry_dingel") firstrow clear
	rename gdp_growth gdp_growth_predict_dingel
	rename gdp_growth_optimistic gdp_growth_op_predict_dingel
	tempfile dingel
	save `dingel'
	restore
	
	merge 1:1 Industry using `dingel', nogen
	
	drop if Industry == "Agriculture"
	
	graph bar (asis) gdp_growth_predict_dingel gdp_growth gdp_growth_op_predict_dingel, over (Industry, sort(order) label(angle(45))) scale(0.7) title("GDP growth from Feb 2020 to Feb 2021, by Industry", size(large)) ytitle("GDP growth in percent") legend(size(medsmall)) legend(label(1 Baseline Projection) label(2 Real GDP Growth) label(3 Benign Outlook Projection)) ylabel(#8) bar(1, color(grey*0.7)) bar(2, color(grey*0.5)) bar(3, color(grey*0.3))
	graph export "${GDP_plot${version}}/dingel_industry_no_agri.png", replace


**************** Table 8 GDP growth for industries - Dingel & Neimann	
	preserve
	keep order Industry gdp_growth_predict_dingel gdp_growth_op_predict_dingel gdp_growth
	sort order Industry gdp_growth_predict_dingel gdp_growth_op_predict_dingel gdp_growth	
	order order Industry gdp_growth_predict_dingel gdp_growth_op_predict_dingel gdp_growth	
	drop order
	
	ds, has(type numeric)
	format `r(varlist)' %9.3f
	
	
	/*
	rename gdp_growth_predict baseline
	rename gdp_growth_op_predict optimistic
	rename gdp_growth real
	corr baseline optimistic real
	scatter gdp_growth_predict gdp_growth_op_predict
	*/
	
	listtex using "${GDP_table}/gdp_industry_table_dingel${version}.tex", rstyle(tabular) replace

	restore
end





cap program drop province_plot
program define province_plot

	syntax[anything]
	
	
	set scheme s1mono

		**************** Figure 9 GDP growth by province
			
		
		import excel "${revision}/gdp_prediction_new.xlsx", sheet ("Province") firstrow clear

				
		label variable gdp_growth "Baseline Projection"
		label variable gdp_growth_optimistic "Benign Outlook Projection"
		
		drop if order ==.
		
		correlate gdp_growth gdp_growth_optimistic 
		
		graph bar (asis) gdp_growth gdp_growth_optimistic, over (Provinces, sort(order) label(angle(45))) scale(0.7)  title("Estimated GDP growth from Feb 2020 to Dec 2020, by Province") ytitle("GDP growth") exclude0 yscale(range(0 -11)) ylabel(#8) 

		graph export "${GDP_plot${version}}/province.png", replace

		
		
		**************** Table 7 GDP growth rates by province
		sort order
		drop order
		ds, has(type numeric)
		format `r(varlist)' %9.3f
		listtex using "${GDP_table}/gdp_province_table.tex", rstyle(tabular) replace
			
		**************** Table 9 GDP growth rates by province - Dingel
		import excel "${revision}/gdp_prediction_new.xlsx", sheet ("Province_dingel") firstrow clear
		label variable gdp_growth "Baseline Projection"
		label variable gdp_growth_optimistic "Benign Outlook Projection"
		drop if order ==.
		
		sort order
		drop order
		ds, has(type numeric)
		format `r(varlist)' %9.3f
		listtex using "${GDP_table}/gdp_province_table_dingel.tex", rstyle(tabular) replace
		
end


cap program drop regression
program define regression

		use "${revision}/allyears_final_update_data${version}.dta", clear

	preserve
		//drop if Industry == "Agriculture [111-112, 1100, 1151-1152]"
		egen indid=group(IndustryCode)
		egen tid=group(year month)
		tsset indid tid
		quietly sum itxwfh,d
		gen highitxwfh=cond(itxwfh>`r(p50)',1,0) // indicator for above median
		replace highitxwfh=. if itxwfh==.
		gen emp_growth=(employement_figures-L12.employement_figures)/L12.employement_figures
		gen gdp_growth=(GDP-L12.GDP)/L12.GDP
		gen lag1_emp_growth=L1.emp_growth
		gen lag2_emp_growth=L2.emp_growth
		gen lag3_emp_growth=L3.emp_growth
		gen emp_growth_highitxwfh=emp_growth*highitxwfh
		gen lag1_emp_growth_highitxwfh=lag1_emp_growth*highitxwfh
		gen lag2_emp_growth_highitxwfh=lag2_emp_growth*highitxwfh
		gen lag3_emp_growth_highitxwfh=lag3_emp_growth*highitxwfh

		global ivs lag2_emp_growth lag3_emp_growth

		reg gdp_growth emp_growth,r
		estadd local sample "All",replace
		estadd local hasIV "No",replace
		est sto temp1
		
		ivregress gmm gdp_growth (emp_growth=$ivs),r first
		estat firststage
		mat fstat=r(singleresults)
		estadd scalar fs1=fstat[1,4]
		estadd local sample "All",replace
		estadd local hasIV "Yes",replace
		est sto temp2
		
		reg gdp_growth emp_growth if year==2008 | year==2009,r
		estadd local sample "2008-09",replace
		estadd local hasIV "No",replace
		est sto temp3
		
		reg gdp_growth emp_growth highitxwfh emp_growth_highitxwfh,r
		estadd local sample "All",replace
		estadd local hasIV "No",replace
		est sto temp4
		
		ivregress gmm gdp_growth highitxwfh (emp_growth emp_growth_highitxwfh=$ivs lag2_emp_growth_highitxwfh lag3_emp_growth_highitxwfh),r first
		estat firststage
		mat fstat=r(singleresults)
		estadd scalar fs1=fstat[1,4]
		estadd local sample "All",replace
		estadd local hasIV "Yes",replace
		est sto temp5
		
		reg gdp_growth emp_growth highitxwfh emp_growth_highitxwfh if year==2008 | year==2009,r
		estadd local sample "2008-09",replace
		estadd local hasIV "No",replace
		est sto temp6
		local constant _b[_cons]
		local growth_emp _b[emp_growth]
		local resilience _b[highitxwfh]
		local interaction _b[emp_growth_highitxwfh]
		
		la var emp_growth "Employment Growth"
		la var highitxwfh "High Resilience"
		la var emp_growth_highitxwfh "\quad $\times$ Employment Growth"
		local tokeep "emp_growth highitxwfh emp_growth_highitxwfh"

		****** Table 1
		*
		esttab temp1 temp2 temp3 temp4 temp5 temp6 using "${GDP_table}/new_table1${version}.tex", b(2) replace star(* 0.10 ** 0.05 *** 0.01) mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)" "(11)" "(12)") nonum brackets se mgroups("Real GDP Growth", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) label keep(`tokeep') order(`tokeep') stats (r2 N sample hasIV, label("R-squared" "Sample Size" "Sample" "Instrument") fmt(2 0)) parentheses nolz nogaps fragment nolines prehead("Dep. var. = ")
*
	restore


	preserve
		drop it ci wfh itxwfh
		merge m:1 Industry using "${dingel}/matchind_it_ci_dingel.dta", keepusing(it ci) keep(3) nogen
		//drop if Industry == "Agriculture [111-112, 1100, 1151-1152]"
		
		egen indid=group(IndustryCode)
		egen tid=group(year month)
		tsset indid tid
		quietly sum ci,d
		gen highci=cond(ci>`r(p50)',1,0) // indicator for above median
		replace highci=. if ci==.
		gen emp_growth=(employement_figures-L12.employement_figures)/L12.employement_figures
		gen gdp_growth=(GDP-L12.GDP)/L12.GDP
		gen lag1_emp_growth=L1.emp_growth
		gen lag2_emp_growth=L2.emp_growth
		gen lag3_emp_growth=L3.emp_growth
		gen emp_growth_highci=emp_growth*highci
		gen lag1_emp_growth_highci=lag1_emp_growth*highci
		gen lag2_emp_growth_highci=lag2_emp_growth*highci
		gen lag3_emp_growth_highci=lag3_emp_growth*highci

		global ivs lag2_emp_growth lag3_emp_growth
		
		reg gdp_growth emp_growth,r
		estadd local sample "All",replace
		estadd local hasIV "No",replace
		est sto temp1
				
		ivregress gmm gdp_growth (emp_growth=$ivs),r first
		estat firststage
		mat fstat=r(singleresults)
		estadd scalar fs1=fstat[1,4]
		estadd local sample "All",replace
		estadd local hasIV "Yes",replace
		est sto temp2
				
		reg gdp_growth emp_growth if year==2008 | year==2009,r
		estadd local sample "2008-09",replace
		estadd local hasIV "No",replace
		est sto temp3
				
		reg gdp_growth emp_growth highci emp_growth_highci,r
		estadd local sample "All",replace
		estadd local hasIV "No",replace
		est sto temp4
				
		ivregress gmm gdp_growth highci (emp_growth emp_growth_highci=$ivs lag2_emp_growth_highci lag3_emp_growth_highci),r first
		estat firststage
		mat fstat=r(singleresults)
		estadd scalar fs1=fstat[1,4]
		estadd local sample "All",replace
		estadd local hasIV "Yes",replace
		est sto temp5
				
		reg gdp_growth emp_growth highci emp_growth_highci if year==2008 | year==2009,r
		estadd local sample "2008-09",replace
		estadd local hasIV "No",replace
		est sto temp6

		local constant _b[_cons]
		local growth_emp _b[emp_growth]
		local resilience _b[highitxwfh]
		local interaction _b[emp_growth_highitxwfh]
		
		la var emp_growth "Employment Growth"
		la var highci "High CI"
		la var emp_growth_highci "\quad $\times$ Employment Growth"
		local tokeep "emp_growth highci emp_growth_highci"

		****** Table 1
		*
		esttab temp1 temp2 temp3 temp4 temp5 temp6 using "${GDP_table}/dingel_table${version}.tex", b(2) replace star(* 0.10 ** 0.05 *** 0.01) mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)" "(11)" "(12)") nonum brackets se mgroups("Real GDP Growth", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) label keep(`tokeep') order(`tokeep') stats (r2 N sample hasIV, label("R-squared" "Sample Size" "Sample" "Instrument") fmt(2 0)) parentheses nolz nogaps fragment nolines prehead("Dep. var. = ")
		
		*
	restore
	
end



cap program drop bubble
program define bubble

local k = 1
foreach province in "Canada" "Newfoundland and Labrador" "Prince Edward Island" "Nova Scotia" "New Brunswick" "Quebec" "Ontario" "Manitoba" "Saskatchewan" "Alberta" "BC"{
	import delimited "${empDataProvince}/`province'.csv", clear
	rename northamericanindustryclassificat Industry
	rename ïref_date reference_date
	rename value employement_figures
	keep reference_date Industry employement_figures geo

	gen year = substr(reference_date, 1, 4)
	gen month = substr(reference_date, 6, 7)
	replace month = usubstr(month, 2, .) if usubstr(month,1,1) == "0" 
	destring , replace
	
  ** merge with IT-intensity & WFH-index & Resilience data

	replace Industry = "Goods-producing industries [T002]" if Industry == "Goods-producing sector"
	replace Industry = "Total employed, all industries  [T001]" if Industry == "Total employed, all industries"
	replace Industry = "Services-producing sector [T003]" if Industry == "Services-producing sector"
    drop if Industry == "Goods-producing industries [T002]" | Industry == "Services-producing sector [T003]"
    gen Province_code = `k'
	if `k' == 1{
		tempfile emp_ind_prov
		save `emp_ind_prov'
	}
	if `k' != 1 append using `emp_ind_prov'
	save `emp_ind_prov', replace
	local k = `k' + 1
}
	
	drop year reference_date
	rename geo Geography
	reshape wide employement_figures, i(Geography Industry Province_code) j(month)
	rename employement_figures* month*
	rename month1 Jan
	rename month2 Feb
	rename month3 March
	rename month4 April
	gen ind_codes = .
	replace ind_codes =15 if Industry == "Accommodation and food services [72]"
	replace ind_codes =2 if Industry == "Agriculture [111-112, 1100, 1151-1152]"
	replace ind_codes =11 if Industry == "Business, building and other support services [55-56]"
	replace ind_codes =5 if Industry == "Construction [23]"
	replace ind_codes =12 if Industry == "Educational services [61]"
	replace ind_codes =9 if Industry == "Finance, insurance, real estate, rental and leasing [52-53]"
	replace ind_codes =3 if Industry == "Forestry, fishing, mining, quarrying, oil and gas [21, 113-114, 1153, 2100]"
	replace ind_codes =13 if Industry == "Health care and social assistance [62]"
	replace ind_codes =14 if Industry == "Information, culture and recreation [51, 71]"
	replace ind_codes =6 if Industry == "Manufacturing [31-33]"
	replace ind_codes =16 if Industry == "Other services (except public administration) [81]"
	replace ind_codes =10 if Industry == "Professional, scientific and technical services [54]"
	replace ind_codes =17 if Industry == "Public administration [91]"
	replace ind_codes =1 if Industry == "Total employed, all industries  [T001]"
	replace ind_codes =8 if Industry == "Transportation and warehousing [48-49]"
	replace ind_codes =4 if Industry == "Utilities [22]"
	replace ind_codes =7 if Industry == "Wholesale and retail trade [41, 44-45]"
	order Geography Province_code Industry ind_codes Jan Feb Mar April
	sort Province_code ind_codes 
	
	preserve
	import excel "${revision}/emply_indus_latest2.xlsx", sheet("Sheet1") firstrow clear
	keep Province_code ind_codes ITintensity z_it_Score Homeshoreability resilience_product
	tempfile index
	save `index'
	restore 
	
	merge 1:1 Province_code ind_codes using `index', nogen
	
forval i=1(1)3{
	preserve
	if `i' == 1{
	local index "Homeshoreability"
	local name "Home-shorability"
	}
	
	if `i' == 2{
	local index "resilience_product"
	local name "Resilience"
	}
	
	if `i' == 3{
	local index "ITintensity"
	local name "IT share"
	}
 	* Calculate employment changes
		gen log_jan=log(Jan)
		gen log_apr=log(April)
		gen log_mar=log(March)
		gen log_feb=log(Feb)

		gen emp_changes=(April-Feb)/Feb
		gen emp_changes2=(April-Jan)/Jan
		gen emp_changes3=(Feb-Jan)/Jan
		gen emp_changes4=(March-Feb)/Feb
		gen emp_changes5=(April-Feb)/Feb
		gen emp_changes6=(log_apr-log_feb)
		gen emp_changes7=(April-March)/March

		egen pop=sum(Feb), by (ind_code)

		*regression and correlation - Anushka
		regress emp_changes `index', robust
		correlate `index' emp_changes

		* Generate Graphs
		global var1 `index' emp_changes

		* Changes
		gen change_1=(Feb-Jan)/Jan
		gen change_2=(March-Feb)/Feb
		gen change_3=(Apri-March)/March
		gen change=(change_1 + change_2 + change_3)/3
		sum change


		* not using loop cause we may need different graphs for IT and dingel measure
		drop if ind_code==1
		*if we drop agriculture as it has the largest homeshoreability value
		if `i' != 3{
			drop if ind_code==2
		}
		*drop if Province_code==1
		*graph twoway (lfit $var1) (scatter $var1)

		* Remove food and accommodation, industry with highest fall
		*graph twoway (lfit $var2) (scatter $var2) if ind_code!=15
		* Remove health care industry
		*graph twoway (lfit $var1) (scatter $var1) if ind_code!=13


		collapse emp_changes pop `index' z_it_Score, by(ind_code)

		label var ind_codes   `"Industry codes"'
		replace ind_codes=1 if ind==1
		label define ind_codes_lbl 1 `"All industries"', add

		replace ind_codes=2 if ind==2
		label define ind_codes_lbl 2 `"Agriculture"', add

		replace ind_codes=3 if ind==3
		label define ind_codes_lbl 3 `"Mining etc"', add

		replace ind_codes=4 if ind==4
		label define ind_codes_lbl 4 `"Utilities"', add

		replace ind_codes=5 if ind==5
		label define ind_codes_lbl 5 `"Construction"', add

		replace ind_codes=6 if ind==6
		label define ind_codes_lbl 6 `"Manufacturing"', add

		replace ind_codes=7 if ind==7
		label define ind_codes_lbl 7 `"Wholesale and retail trade"', add

		replace ind_codes=8 if ind==8
		label define ind_codes_lbl 8 `"Transportation and Warehousing"', add

		replace ind_codes=9 if ind==9
		label define ind_codes_lbl 9 `"Finance, insurance, real estate"', add

		replace ind_codes=10 if ind==10
		label define ind_codes_lbl 10 `"Professional, scientific and technical services	"', add

		replace ind_codes=11 if ind==11
		label define ind_codes_lbl 11 `"Business and support services "', add

		replace ind_codes=12 if ind==12
		label define ind_codes_lbl 12 `"Educational services"', add

		replace ind_codes=13 if ind==13
		label define ind_codes_lbl 13 `"Health care and social assistance"', add

		replace ind_codes=14 if ind==14
		label define ind_codes_lbl 14 `"Information, culture and recreation"', add

		replace ind_codes=15 if ind==15
		label define ind_codes_lbl 15 `"Accommodation and food services"', add

		replace ind_codes=16 if ind==16
		label define ind_codes_lbl 16 `"Other services"', add

		replace ind_codes=17 if ind==17
		label define ind_codes_lbl 17 `"Public administration"', add
		label values ind_codes ind_codes_lbl

		set scheme s1color
		*lfitci
		local temp: di %3.2f r(rho)
		twoway (lfitci emp_changes `index' [aw=pop]) (scatter emp_changes `index' [aw=pop],  mcolor(%30) ),  xtitle("`name' by Industry") ytitle("Employment drop (in %) by Industry (Feb'20-April'20)") legend(off)
		graph export "${GDP_plot}/bubble_`name'.png", replace
	restore
	}	
		
end



cap program drop GDP_level_table
program define GDP_level_table

	use "$revision/update_new_merged_data_model_noagri${version}.dta", clear
	
	preserve
	use "$revision/update_new_realized_merged_data_model_noagri${version}.dta", clear
	keep Date year month gdp*predict
	rename gdp*predict real_gdp*predict
	tempfile realized
	save `realized'
	restore
	
	merge 1:1 Date year month using `realized', nogen
	cap drop *emp*
	cap drop if (year < 2020 | (year == 2020 & month == 1) | (year == 2022 & month != 1))
	drop pe*
	
	
	preserve
	
		keep Date *level*predict year month
		drop real*
		order Date gdp_level_predict gdpL_level_predict gdpH_level_predict op_gdp_level_predict op_gdpL_level_predict op_gdpH_level_predict
		drop if (year == 2021 & month == 3) | (year == 2021 & month == 5) | (year == 2021 & month == 6) | (year == 2021 & month == 8) | (year == 2021 & month == 9) | (year == 2021 & month == 11) | (year == 2021 & month == 12) 
		
		gen date = ""
		replace date = "Feb-20" if (year == 2020 & month == 2)
		replace date = "Mar-20" if (year == 2020 & month == 3)
		replace date = "Apr-20" if (year == 2020 & month == 4)
		replace date = "May-20" if (year == 2020 & month == 5)
		replace date = "Jun-20" if (year == 2020 & month == 6)
		replace date = "Jul-20" if (year == 2020 & month == 7)
		replace date = "Aug-20" if (year == 2020 & month == 8)
		replace date = "Sep-20" if (year == 2020 & month == 9)
		replace date = "Oct-20" if (year == 2020 & month == 10)
		replace date = "Nov-20" if (year == 2020 & month == 11)
		replace date = "Dec-20" if (year == 2020 & month == 12)
		replace date = "Jan-21" if (year == 2021 & month == 1)
		replace date = "Feb-21" if (year == 2021 & month == 2)
		replace date = "Apr-21" if (year == 2021 & month == 4)
		replace date = "Jul-21" if (year == 2021 & month == 7)
		replace date = "Oct-21" if (year == 2021 & month == 10)
		replace date = "Jan-22" if (year == 2022 & month == 1)
		drop year month Date
		order date gdp_level_predict gdpL_level_predict gdpH_level_predict op_gdp_level_predict op_gdpL_level_predict op_gdpH_level_predict
		
		ds, has(type numeric)
		format `r(varlist)' %9.3f
		listtex using "${GDP_table}/gdp_level_table_pannelA${version}.tex", rstyle(tabular) replace
		
	restore

	
	preserve
	
		keep Date *level* year month
		drop op* gdp*predict
		order Date real_gdp_level_predict real_gdpL_level_predict real_gdpH_level_predict gdp_level gdpL_level gdpH_level
		drop if (year == 2021 & month == 3) | (year == 2021 & month == 5) | (year == 2021 & month == 6) | (year == 2021 & month == 8) | (year == 2021 & month == 9) | (year == 2021 & month == 11) | (year == 2021 & month == 12) 
		
		gen date = ""
		replace date = "Feb-20" if (year == 2020 & month == 2)
		replace date = "Mar-20" if (year == 2020 & month == 3)
		replace date = "Apr-20" if (year == 2020 & month == 4)
		replace date = "May-20" if (year == 2020 & month == 5)
		replace date = "Jun-20" if (year == 2020 & month == 6)
		replace date = "Jul-20" if (year == 2020 & month == 7)
		replace date = "Aug-20" if (year == 2020 & month == 8)
		replace date = "Sep-20" if (year == 2020 & month == 9)
		replace date = "Oct-20" if (year == 2020 & month == 10)
		replace date = "Nov-20" if (year == 2020 & month == 11)
		replace date = "Dec-20" if (year == 2020 & month == 12)
		replace date = "Jan-21" if (year == 2021 & month == 1)
		replace date = "Feb-21" if (year == 2021 & month == 2)
		replace date = "Apr-21" if (year == 2021 & month == 4)
		replace date = "Jul-21" if (year == 2021 & month == 7)
		replace date = "Oct-21" if (year == 2021 & month == 10)
		replace date = "Jan-22" if (year == 2022 & month == 1)
		drop year month Date
		order date real_gdp_level_predict real_gdpL_level_predict real_gdpH_level_predict gdp_level gdpL_level gdpH_level
		
		ds, has(type numeric)
		format `r(varlist)' %9.3f
		listtex using "${GDP_table}/gdp_level_table_pannelB${version}.tex", rstyle(tabular) replace
		
	restore


end


cap program drop GDP_growth_table
program define GDP_growth_table

	use "$revision/update_new_merged_data_model_noagri${version}.dta", clear
	
	preserve
	use "$revision/update_new_realized_merged_data_model_noagri${version}.dta", clear
	keep Date year month gdp*predict
	rename gdp*predict real_gdp*predict
	tempfile realized
	save `realized'
	restore
	
	merge 1:1 Date year month using `realized', nogen
	cap drop *emp*
	cap drop if (year < 2020 | (year == 2020 & month == 1) | (year == 2022 & month != 1))
	drop pe*
	
	
	preserve
	
		keep Date *growth*predict year month
		drop real*
		order Date gdp_growth_predict gdpL_growth_predict gdpH_growth_predict op_gdp_growth_predict op_gdpL_growth_predict op_gdpH_growth_predict
		drop if (year == 2021 & month == 3) | (year == 2021 & month == 5) | (year == 2021 & month == 6) | (year == 2021 & month == 8) | (year == 2021 & month == 9) | (year == 2021 & month == 11) | (year == 2021 & month == 12) 
		
		gen date = ""
		replace date = "Feb-20" if (year == 2020 & month == 2)
		replace date = "Mar-20" if (year == 2020 & month == 3)
		replace date = "Apr-20" if (year == 2020 & month == 4)
		replace date = "May-20" if (year == 2020 & month == 5)
		replace date = "Jun-20" if (year == 2020 & month == 6)
		replace date = "Jul-20" if (year == 2020 & month == 7)
		replace date = "Aug-20" if (year == 2020 & month == 8)
		replace date = "Sep-20" if (year == 2020 & month == 9)
		replace date = "Oct-20" if (year == 2020 & month == 10)
		replace date = "Nov-20" if (year == 2020 & month == 11)
		replace date = "Dec-20" if (year == 2020 & month == 12)
		replace date = "Jan-21" if (year == 2021 & month == 1)
		replace date = "Feb-21" if (year == 2021 & month == 2)
		replace date = "Apr-21" if (year == 2021 & month == 4)
		replace date = "Jul-21" if (year == 2021 & month == 7)
		replace date = "Oct-21" if (year == 2021 & month == 10)
		replace date = "Jan-22" if (year == 2022 & month == 1)
		drop year month Date
		order date gdp_growth_predict gdpL_growth_predict gdpH_growth_predict op_gdp_growth_predict op_gdpL_growth_predict op_gdpH_growth_predict
		
		replace gdp_growth_predict = gdp_growth_predict*100
		replace gdpL_growth_predict = gdpL_growth_predict*100
		replace gdpH_growth_predict = gdpH_growth_predict*100
		replace op_gdp_growth_predict = op_gdp_growth_predict*100
		replace op_gdpL_growth_predict = op_gdpL_growth_predict*100
		replace op_gdpH_growth_predict = op_gdpH_growth_predict*100
		
		ds, has(type numeric)
		format `r(varlist)' %9.3f
		listtex using "${GDP_table}/gdp_growth_table_pannelA${version}.tex", rstyle(tabular) replace
		
	restore

	
	preserve
	
		keep Date *growth* year month
		drop op* gdp*predict
		order Date real_gdp_growth_predict real_gdpL_growth_predict real_gdpH_growth_predict gdp_growth gdpL_growth gdpH_growth
		drop if (year == 2021 & month == 3) | (year == 2021 & month == 5) | (year == 2021 & month == 6) | (year == 2021 & month == 8) | (year == 2021 & month == 9) | (year == 2021 & month == 11) | (year == 2021 & month == 12) 
		
		gen date = ""
		replace date = "Feb-20" if (year == 2020 & month == 2)
		replace date = "Mar-20" if (year == 2020 & month == 3)
		replace date = "Apr-20" if (year == 2020 & month == 4)
		replace date = "May-20" if (year == 2020 & month == 5)
		replace date = "Jun-20" if (year == 2020 & month == 6)
		replace date = "Jul-20" if (year == 2020 & month == 7)
		replace date = "Aug-20" if (year == 2020 & month == 8)
		replace date = "Sep-20" if (year == 2020 & month == 9)
		replace date = "Oct-20" if (year == 2020 & month == 10)
		replace date = "Nov-20" if (year == 2020 & month == 11)
		replace date = "Dec-20" if (year == 2020 & month == 12)
		replace date = "Jan-21" if (year == 2021 & month == 1)
		replace date = "Feb-21" if (year == 2021 & month == 2)
		replace date = "Apr-21" if (year == 2021 & month == 4)
		replace date = "Jul-21" if (year == 2021 & month == 7)
		replace date = "Oct-21" if (year == 2021 & month == 10)
		replace date = "Jan-22" if (year == 2022 & month == 1)
		drop year month Date
		order date real_gdp_growth_predict real_gdpL_growth_predict real_gdpH_growth_predict gdp_growth gdpL_growth gdpH_growth
		
		replace real_gdp_growth_predict = real_gdp_growth_predict*100
		replace real_gdpL_growth_predict = real_gdpL_growth_predict*100
		replace real_gdpH_growth_predict = real_gdpH_growth_predict*100
		replace gdp_growth = gdp_growth*100
		replace gdpL_growth = gdpL_growth*100
		replace gdpH_growth = gdpH_growth*100
		
		
		ds, has(type numeric)
		format `r(varlist)' %9.3f
		listtex using "${GDP_table}/gdp_growth_table_pannelB${version}.tex", rstyle(tabular) replace
		
	restore


end








main

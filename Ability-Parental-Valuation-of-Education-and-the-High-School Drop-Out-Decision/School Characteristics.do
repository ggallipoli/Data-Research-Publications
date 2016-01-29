set more off
clear

cd "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Revisions October 2012"

insheet using Boys_estfactors.txt, clear 



rename v1 id
rename v2 cog
rename v3 noncog
rename v4 vp
rename v5 phcog
rename v6 pmcog
rename v7 plcog
rename v8 phnoncog
rename v9 plnoncog
rename v10 phvp
rename v11 plvp

sort id
merge 1:1 id using "mergefactorb.dta" 

drop _merge


sort recordid

save boysfactors.dta, replace



use "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\May 2011 Programs\Data\ANALYSIS DATA NOVEMBER 19 2007.dta", clear

sort recordid

merge 1:1 recordid using boysfactors.dta



keep if _merge == 3

drop _merge

sort schoolid


merge m:1 schoolid using "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\May 2011 Programs\Data\youth_unemp.dta"

keep if _merge == 3

drop _merge

egen avgread = rowmean(pv1read pv2read pv3read pv4read pv5read)

gen dp = c3dropout
gen lnfi =   ln(aeqivinc)

drop if aeqivinc >= 350

gen pedxx = 6 if a2 == 1 | a2 == 5 | a2 == 21
replace pedxx= 5 if a2 == 2 | a2 == 6 |  a2 == 10 | a2 == 22
replace pedxx= 4 if a2 == 7 
replace pedxx= 3 if a2 == 3 | a2 == 8  | a2 == 11  | a2 == 12 | a2 == 13  | a2 == 15  | a2 == 23
replace pedxx= 2 if a2 == 4  | a2 == 9 | a2 == 14 | a2 == 16 | a2 == 17 | a2 == 18 | a2 == 20 | a2 == 24
replace pedxx = 1 if a2 == 19 


ta pedxx, gen(pedn)


label var  pedn6 "LTSH"
label var  pedn5 " one HS"
label var  pedn4 "Both HS"
label var  pedn3 "PSE < BA"
label var  pedn2 "BA mixture"
label var  pedn1 "BA"



gen sibdrop = pb20 == 1 if pb20 < 3

gen nfld = y1sprov1
gen pei = y1sprov2
gen ns  = y1sprov3
gen nb = y1sprov4
gen pq = y1sprov5
gen on = y1sprov5
gen sk = y1sprov7
gen mb = y1sprov8
gen ab = y1sprov9
gen bc = y1sprov10

gen native = childnative 


rename rural urban
gen rural = 1-urban

gen imm =  p1simm 
/*gen sec =  p1ssecgen */
gen moves = p1pnummoves 
gen twoparent = p1stwopar 
gen otpar = p1potwopar == 1 | p1potonepar == 1 
gen lonemom = p1pmomonly 
gen lonedad = p1pdadonly 
gen lonepar = lonedad+lonemom
gen wght = w3_ypr

gen parpref = parexpsm == 4 if parexpsm ~= .


gen pt1 = readtile1 == 1
gen pt2 = readtile1 == 2
gen pt3 = readtile1 == 3
gen pt4 = readtile1 == 4

gen ppt = 1 if pt1 == 1
replace ppt = 2 if pt2 == 1
replace ppt = 3 if pt3 == 1
replace ppt = 4 if pt4 == 1
egen parpptx = group(parpref ppt)

ta parpptx, gen(parpp)

gen monthb = 0 

forval i = 2(1)12 {
local k = `i' - 1
replace monthb = `k' if  birthm`i' == 1
}


gen page = pa6p2 if pa6p2 < 90 

gen numsib = 0 

forval i = 4(1)8 {

replace numsib = numsib + 1 if pa4p`i' >= 5 & pa4p`i' <= 8

}

destring sc11q03, replace force
gen lowmat = sc11q03 == 3 | sc11q03 == 4 if sc11q03 ~= .
destring stratio, force replace
destring ratcomp, force replace
destring sc13q01, replace force
destring schlsize, replace force
destring sc14q01, replace force 
destring sc14q02, replace force 


gen comprat = schlsize/sc13q01
gen tearat = schlsize/(sc14q01+.5*sc14q01)

reg comprat i.pedxx lnfi nfld pei ns nb pq sk mb ab bc native rural imm moves numsib monthb page
predict compres, residual


reg avgread i.pedxx lnfi nfld pei ns nb pq sk mb ab bc native rural imm moves numsib monthb page
predict readres, residual

reg lowmat i.pedxx lnfi nfld pei ns nb pq sk mb ab bc native rural imm moves numsib monthb page
predict lowmatres, residual
reg tearat i.pedxx lnfi nfld pei ns nb pq sk mb ab bc native rural imm moves numsib monthb page
predict teachres, residual

egen st_vp = std(vp)
egen st_cog = std(cog)
egen st_noncog = std(noncog)

egen st_comp = std(compres)
egen st_teach = std(teachres)
egen st_lowres = std(lowmatres)
egen st_read = std(readres)


xtile qcomp= st_comp , nq(400)
xtile qteach = st_teach, nq(400)
xtile qlowres = st_lowres, nq(400)

set mat 2000
capture log close
log using "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\Output\unweighted school quantiles.txt", text replace

mean st_vp st_cog st_noncog if qcomp ~= ., over(qcomp)
mean st_vp st_cog st_noncog if qteach ~= ., over(qteach)
mean st_vp st_cog st_noncog if qlowres ~= ., over(qlowres)

log close

log using "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\Output\unweighted school quantiles.txt", text append
ta qcomp
ta qteach
ta qlowres

log close

save "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\data\factorcorr.dta", replace

collapse (mean) st_comp st_vp st_cog st_noncog (count) num = st_vp [aw = wght] if qcomp ~= ., by(qcomp)

saveold "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\data\compres.dta", replace

/****************/

use "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\data\factorcorr.dta", clear


collapse (mean) st_teach st_vp st_cog st_noncog (count) num = st_vp [aw = wght] if qteach ~= ., by(qteach)

saveold "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\data\teachrat.dta", replace


/****************/

use "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\data\factorcorr.dta", clear


collapse (mean) st_lowres st_vp st_cog st_noncog (count) num = st_vp [aw = wght] if qlowres ~= ., by(qlowres)

saveold "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR\data\lowres.dta", replace





set more off

use "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\May 2011 Programs\Data\Stata Version of Guass Data_Jul20.dta", clear

cd "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Revisions October 2012\out"

/*
Folder in Vancouver
use "K:\Dropouts\May 2011 Programs\Data\Stata Version of Guass Data_Jul20.dta", clear

*/

gen ofam = otpar + lonemom + lonedad 
gen highab = pt1 + pt2
gen east = nfld + pei + ns + nb 

capture log close
log using reg_startv.txt, text replace
 



probit dp lnfi pedn2 pedn3 pedn4 pedn5 pedn6 east pq sk mb ab bc  rural moves ofam numsib monthb yunemp 

mat b0 = e(b)' 
scalar rws = rowsof(b0)

mat hs = b0[rws..rws,.]\b0[1..rws-1,.]

reg grds lnfi pedn2 pedn3 pedn4 pedn5 pedn6  east pq sk mb ab bc  rural moves ofam numsib monthb yunemp 
mat b0 = e(b)' 
scalar rws = rowsof(b0)

mat grds = b0[rws..rws,.]\b0[1..rws-1,.]


reg avgread pedn2 pedn3 pedn4 pedn5 pedn6  east pq sk mb ab bc  rural moves ofam monthb 
mat b0 = e(b)' 
scalar rws = rowsof(b0)

mat pisa = b0[rws..rws,.]\b0[1..rws-1,.]

probit parpref pedn2 pedn3 pedn4 pedn5 pedn6   east pq sk mb ab bc  rural numsib 
mat b0 = e(b)' 
scalar rws = rowsof(b0)

mat ppref = b0[rws..rws,.]\b0[1..rws-1,.]

probit saved lnfi pedn2 pedn3 pedn4 pedn5 pedn6   east pq sk mb ab bc  rural  numsib page 
mat b0 = e(b)' 
scalar rws = rowsof(b0)

mat svd = b0[rws..rws,.]\b0[1..rws-1,.]


probit hwkonetime pedn2 pedn3 pedn4 pedn5 pedn6  east pq sk mb ab bc  rural moves ofam numsib monthb 

mat b0 = e(b)' 
scalar rws = rowsof(b0)

mat hwk = b0[rws..rws,.]\b0[1..rws-1,.]

probit tryhard pedn2 pedn3 pedn4 pedn5 pedn6   east pq sk mb ab bc  rural moves ofam numsib monthb 

mat b0 = e(b)' 
scalar rws = rowsof(b0)

mat trh = b0[rws..rws,.]\b0[1..rws-1,.]


/********starting values for equation betas **********/

mat list hs
mat list grds
mat list pisa
mat list ppref
mat list svd
mat list hwk
mat list trh 

log close 

} 

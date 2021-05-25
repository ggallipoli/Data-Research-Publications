



use "K:\Dropouts\Factor Analysis\December 2009\dat\analysis robustness data.dta", clear

keep if avgsci ~= .

reg avgsci cog 
predict resci, residual


xtile qsci= resci, nq(800)

collapse (mean) resci value (count) num = value [aw = wght], by(qsci)

save "K:\Dropouts\Factor Analysis\December 2009\dat\out\scivalu.dta", replace

use "K:\Dropouts\Factor Analysis\December 2009\dat\analysis robustness data.dta", clear


keep if avgsci ~= .

xtile qsci= avgsci, nq(800)

collapse (mean) avgsci cog (count) num = value  [aw = wght], by(qsci)

save "K:\Dropouts\Factor Analysis\December 2009\dat\out\scicog.dta", replace


use "K:\Dropouts\Factor Analysis\December 2009\dat\analysis robustness data.dta", clear


keep if avgmath ~= .

xtile qmat= avgmath, nq(800)

collapse (mean) avgmath cog (count) num = value  [aw = wght], by(qmat)

save "K:\Dropouts\Factor Analysis\December 2009\dat\out\matcog.dta", replace


use "K:\Dropouts\Factor Analysis\December 2009\dat\analysis robustness data.dta", clear

keep if avgmath ~= .

reg avgmath cog 
predict remat, residual



xtile qmat= remat, nq(800)

collapse (mean) remat value (count) num = value [aw = wght], by(qmat)

save "K:\Dropouts\Factor Analysis\December 2009\dat\out\matvalu.dta", replace

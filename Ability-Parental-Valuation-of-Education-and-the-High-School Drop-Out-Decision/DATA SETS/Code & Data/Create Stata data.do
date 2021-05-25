
clear
set mem 500m

#delim ;
/* "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII "/


 "				YITS HIGHSCHOOL DROPSOUT STATCAN PROJECT				 "/


 "______________________________________________________________________________________ "/


 "		DATE: Jan 30 2007										 "/


 "		PROGRAMER: KELLY FOLEY											 "/


 "		PROGRAM PURPOSE:  	create labels and stata file for data file  	 "/
 "														      "/

 "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII "/ */ ;
#delim cr

insheet using  "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\readonlydata\May 28 2007\allvars file 3 cycles 28MAY07.csv"

label var inpisa1   "On Cycle One PISA File "
label var incycle2   "On Cycle Two  File "
label var incycle3   "On Cycle Three  File "
label var inpar1   "On Cycle One Parents YITS File "
label var inyits1   "On Cycle One Student YITS File "
label var insamp   "Valid for sample restrictions " 
label var y1sqenglish   "YITS S1: Questionaire in English " 
label var y1sprov   "YITS S1: Province "
label var y1sprov1   "YITS S1: Newfoundland "
label var y1sprov2   "YITS S1: Prince Edward Island "
label var y1sprov3   "YITS S1: Nova Scotia "
label var y1sprov4   "YITS S1: New Brunswick "
label var y1sprov5   "YITS S1: Quebec "
label var y1sprov6   "YITS S1: Ontario "
label var y1sprov7   "YITS S1: Manitoba "
label var y1sprov8   "YITS S1: Saskatchewan "
label var y1sprov9   "YITS S1: Alberta "
label var y1sprov10   "YITS S1: British Columbia "
label var y1sprovnnb  "YITS S1: Province (not including New Brunswick "
label var y1sacadpart   "YITS S1: Academic Participation Scale " 
label var y1sacadidnt   "YITS S1: Academic Identification Scale "
label var y1ssoceng   "YITS S1: Social Engagement Scale "
label var y1sacaeng   "YITS S1: Academic Engagement Scale "
label var y1sovreng   "YITS S1: Overall Engagement Scale "
label var y1sselfest  "YITS S1: Self-Esteem Scale "
label var y1sselfeff   "YITS S1: Self-Efficacy Scale "
label var y1ssocsupp   "YITS S1: Support Scale "
label var y1smastery   "YITS S1: Mastery Scale "
label var y1strschwkbk   "YITS S1: Walk or Bike to school "
label var y1strschpubtr   "YITS S1: Take public transport to school "
label var y1strschdrive   "YITS S1: Drive to school "
label var y1strschscbus   "YITS S1: Take School Bus to school "
label var y1strschscres   "YITS S1: Live in residence at school "
label var y1strtml15m   "YITS S1: Less than 15 min travel time to school "
label var y1strtm15t1h   "YITS S1:  Btwn 15 min and 1 hr travel time to school "
label var y1strtmgt1h   "YITS S1: Over 1 hr travel time to school "
label var y1sexphsgrad   "YITS S1: Expect to graduate from H.S. "
label var y1sexplths   "YITS S1: Highest Ed. want to obtain- less than H.S. "
label var y1sexphs   "YITS S1: Highest Ed. want to obtain-  H.S. "
label var y1sexptrade   "YITS S1: Highest Ed. want to obtain- Trade/Appr "
label var y1sexpcollge   "YITS S1: Highest Ed. want to obtain- College/CEGEP "
label var y1sexpbadeg   "YITS S1: Highest Ed. want to obtain- One Uni. Degree "
label var y1sexpgrad   "YITS S1: Highest Ed. want to obtain- > 1 Uni Degree "
label var y1sawaysick   "YITS S1: Away from school >2wks for sickness "
label var y1shospstay   "YITS S1: Ever been in hospital for > 2wks "
label var y1sschkout  "YITS S1: Ever been kicked out of school "
label var y1strdsmoke   "YITS S1: Ever tried smoking "
label var y1smokewkl    "YITS S1: Smoke at least weekly "
label var y1svolunt    "YITS S1: Volunteered in the last 12 months "

label var y1swrkemp   "YITS S1: Ever worked for an employer "
label var y1swrkodd   "YITS S1: Ever worked at odd jobs "
label var y1swrkfam   "YITS S1: Ever worked for family "
label var y1severwrk   "YITS S1: Ever worked for any job "
label var y1swschemp   "YITS S1: Worked during school year for an employer "
label var y1swschodd   "YITS S1: Worked during school year at odd jobs "
label var y1swschfam   "YITS S1: Worked during school year for family "
label var y1sschwrk   "YITS S1: Worked during school year for any job "


label var y1ssvowned   "YITS S1: Saves for own education "
label var y1shsvimppar   "YITS S1: H.S. grad very imp. to at least one parent "
label var y1sgthsvimppar    "YITS S1: More than H.S. very imp. to at least one parent "
label var y1sovgr9t100    "YITS S1: Overall grades 90 to 100 % "
label var y1sovgr80t89    "YITS S1: Overall grades 80 to 89 % "
label var y1sovgr70t79    "YITS S1: Overall grades 70 to 79 % "
label var y1sovgr60t69    "YITS S1: Overall grades 60 to 69 % "
label var y1sovgr55t59    "YITS S1: Overall grades 55 to 59 % "
label var y1sovgr50t54    "YITS S1: Overall grades 50 to 54 % "
label var y1sovgrlt50    "YITS S1: Overall grades lt 50 % "
label var dtlstinsch   "Date last in school " 
label var dtlstftsch   "Date last in school full-time " 
label var dtgrdhsch   "Date graduated highschool " 
label var  d2nevdropout   "DEPVAR S2: Never Dropped Out "
label var d2dropoutonc   "DEPVAR S2: Dropped Out Once "
label var d2dropoutgeon   "DEPVAR S2: Dropped OUt more than Once "
label var d2drophsgrd   "DEPVAR S2: Dropped out and HS Grad "
label var d2dropleav    "DEPVAR S2: Dropped out and HS Leaver "
label var d2dropcont    "DEPVAR S2: Dropped out and HS Continuer "
label var d2nodrhsgrd   "DEPVAR S2: No Drop out and HS Grad "
label var d2nodrcont  "DEPVAR S2: No Drop out and HS Grad "
label var d2monthdrop "DEPVAR S2: Month until dropped out "
label var p1sgrade67   "PISA S1: Grade 6 or 7 "
label var p1sgrade8   "PISA S1: Grade 8 "
label var p1sgrade9   "PISA S1: Grade 9 "
label var p1sgrade10   "PISA S1: Grade 10 "
label var p1sgradeg11   "PISA S1: Grade 11 or over "
label var p1sfemale  "PISA S1: Female "
label var p1smalguard   "PISA S1: Live with male gaurdian  "
label var p1sfemguard  "PISA S1: Live with female graurdian "
label var p1slvdad   "PISA S1: live with dad "
label var p1slvmom  "PISA S1: Live with mom "
label var p1sgranguard  "PISA S1: Live with grandmother as head "
label var p1stwopar  "PISA S1: Live with both parents "
label var p1slvnotrad   "PISA S1: Live in non-traditional house "
label var p1slvmommal  "PISA S1: Live with mom and male guardian "
label var p1slvdadfem  "PISA S1: Live with dad and female guardian "
label var p1stwoguard   "PISA S1:  Live with male and female guardians "
label var p1sprgrp1  "PISA S1: Family Type, Two parents " 
label var p1sprgrp2  "PISA S1: Family Type, Single mom " 
label var p1sprgrp3  "PISA S1: Family Type, Single dad "
label var p1sprgrp4  "PISA S1: Family Type, parent and step parent " 
label var p1sprgrp5  "PISA S1: Family Type, other " 
label var p1snumsib   "PISA S1: Number of siblings "
label var p1sonlych  "PISA S1: Only Child "
label var p1soldest  "PISA S1: Oldest Child "
label var p1syoungest  "PISA S1: Youngest Child "
label var p1smiddle  "PISA S1: Middle Child "
label var p1ssameage  "PISA S1: Siblings all same age "
label var p1smomjbnoinfo   "PISA S1: No info mom's activity "
label var p1smomjobft   "PISA S1: Mom works FT "
label var p1smomjobpt   "PISA S1: Mom works PT "
label var p1smomjobun   "PISA S1: Mom unemployed "
label var p1smomjobhm  "PISA S1:  Mom not in lab. market "
label var p1sdadjbnoinfo   "PISA S1: No info dad's activity "
label var p1sdadjobft   "PISA S1: Dad works FT "
label var p1sdadjobpt   "PISA S1: Dad works PT "
label var p1sdadjobun   "PISA S1: Dad unemployed "
label var p1sdadjobhm  "PISA S1:  Dad not in lab. market "
label var p1smomhed1  "PISA S1: Mom's highest ed. < grd 6 "
label var p1smomhed2  "PISA S1: Mom's highest ed. > grd 6 < grd 9 "
label var p1smomhed3  "PISA S1: Mom's highest ed. > grd 9 no h.s. "
label var p1smomhed4  "PISA S1: Mom's highest ed. Highschool "
label var p1smomhed5  "PISA S1: Mom's highest ed. PSE "
label var p1sdadhed1  "PISA S1: Dad's highest ed. < grd 6 "
label var p1sdadhed2  "PISA S1: Dad's highest ed. > grd 6 < grd 9 "
label var p1sdadhed3  "PISA S1: Dad's highest ed. > grd 9 no h.s. "
label var p1sdadhed4  "PISA S1: Dad's highest ed. Highschool "
label var p1sdadhed5  "PISA S1: Dad's highest ed. PSE "
label var p1smomnoed   "PISA S1: No Mom's Ed data "
label var p1smomhson  "PISA S1: Mom high school only "
label var p1smomunhs  "PISA S1: Mom high school and PSE "
label var p1smomunns  "PISA S1: Mom PSE and no h.s. "
label var p1smomlths  "PISA S1: Mom PSE and less than h.s. "
label var p1sdadnoed   "PISA S1: No Dad's Ed data "
label var p1sdadhson  "PISA S1: Dad high school only "
label var p1sdadunhs  "PISA S1: Dad high school and PSE "
label var p1sdadunns  "PISA S1: Dad PSE and no h.s. "
label var p1sdadlths  "PISA S1: Dad PSE and less than h.s. "
label var p1simm  "PISA S1: Child is not born in Canada "
label var p1simmmom  "PISA S1: Mother not born in Canada "
label var p1simmdad  "PISA S1: Father not born in Canada "
label var p1ssecgen   "PISA S1: Second generation Canadian "
label var p1senglish  "PISA S1: Speak English at Home "
label var p1sfrench  "PISA S1: Speak French at Home "
label var p1sothlang "PISA S1: Speak Other Language at Home "
label var p1sremedsch "PISA S1: Took remedial courses at school "
label var p1senrisch "PISA S1: Took enriched courses at school "
label var p1sprtutor "PISA S1: Go to private tutor "
label var p1snvlate "PISA S1: Never late for school "
label var p1ssmtlate  "PISA S1: Sometimes late for school "
label var p1softlate "PISA S1: Often late for school "
label var p1snvmiss "PISA S1: Never miss school "
label var p1ssmtmiss  "PISA S1: Sometimes miss school "
label var p1softmiss "PISA S1: Often miss school "
label var p1snvskip  "PISA S1: Never skip school "
label var p1ssmtskip  "PISA S1: Sometimes skip school "
label var p1softskip "PISA S1: Often skip school "
label var p1snobooks  "PISA S1: No books in the home "
label var p1s1t100books  "PISA S1: 1 to 100 books in the home "
label var p1s100t500bks  "PISA S1: 100 to 500 books in the home "
label var p1sgt500books  "PISA S1: more than 500 books in the home "
label var p1scomphome "PISA S1: Access to computer at home "
label var p1purban   "PISA P1: Urban "
label var p1pfamincom "PISA P1: Family Income "
label var p1pfrchimm "PISA P1: Child in french immersion "
label var p1pmonitor "PISA P1: Parent monitoring scale "
label var p1pnuture "PISA P1: Parent nuturing scale "
label var p1pincons "PISA P1: Parent inconsistent discipline scale "
label var p1pchdadifs "PISA P1: Child Activity difficult sometimes "
label var p1pchdadifo "PISA P1: Child Activity difficult often "
label var p1pchdadifn "PISA P1: Child Activity difficult never "
label var p1premedsch "PISA P1: Child taken remedial classes "
label var p1penrisch "PISA P1: Child taken enrichment classes "
label var p1prptgrd "PISA P1: Child repeated grade "
label var p1pprbsch "PISA P1: Contacted by the school for problem "
label var p1ppolice  "PISA P1: Child intervied by police "
label var p1psibdrpout  "PISA P1: Sibling has dropped out of Highschool "
label var p1phsvimppar  "PISA P1: Important child finished High school "
label var p1pgthsvimppar  "PISA P1: Important child goes beyond H.S. "
label var p1pfinobst  "PISA P1: Financial obstacle to parent's ed. expectation "
label var p1pdistobst  "PISA P1: Distance obstacle to parent's ed. expectation "
label var p1pgrdobst  "PISA P1: Grades obstacle to parent's ed. expectation "
label var p1phlthobst  "PISA P1: Health obstacle to parent's ed. expectation "
label var p1pplaned  "PISA P1: Parents' plan for child's education "
label var p1ptwoparents  "PISA P1: Lives with two parents "
label var p1poneparent  "PISA P1: Lives with one parent "
label var p1pmomdad  "PISA P1:  Lives with mother and father "
label var p1potwopar  "PISA P1: Lives with other two parents "
label var p1pmomonly  "PISA P1:  Lives with single mother "
label var p1pdadonly  "PISA P1:  Lives with single father "
label var p1potonepar  "PISA P1:   Lives with other one parent "
label var p1pnummoves  "PISA P1: Number of child home moves "
label var p1pchcancit  "PISA P1: Child canadian citizen "
label var p1pchildimm  "PISA P1: Child not born in Canada "
label var p1psecgen "PISA P1: At least one parent not born in Canada "
label var p1pmomhed1  "PISA P1: Mom's highest ed. < grd 6 "
label var p1pmomhed2  "PISA P1: Mom's highest ed. > grd 6 < grd 9 "
label var p1pmomhed3  "PISA P1: Mom's highest ed. > grd 9 no h.s. "
label var p1pmomhed4  "PISA P1: Mom's highest ed. Highschool "
label var p1pmomhed5  "PISA P1: Mom's highest ed. PSE "
label var p1pdadhed1  "PISA P1: Dad's highest ed. < grd 6 "
label var p1pdadhed2  "PISA P1: Dad's highest ed. > grd 6 < grd 9 "
label var p1pdadhed3  "PISA P1: Dad's highest ed. > grd 9 no h.s. "
label var p1pdadhed4  "PISA P1: Dad's highest ed. Highschool "
label var p1pdadhed5  "PISA P1: Dad's highest ed. PSE "

label var p1pmomjbnoinfo   "PISA P1: No info mom's activity "
label var p1pmomjob   "PISA P1: Mom works  "
label var p1pmomjobun   "PISA P1: Mom unemployed "
label var p1pmomjobhm  "PISA P1:  Mom not in lab. market "
label var p1pdadjbnoinfo   "PISA P1: No info dad's activity "
label var p1pdadjob   "PISA P1: Dad works  "
label var p1pdadjobun   "PISA P1: Dad unemployed "
label var p1pdadjobhm  "PISA P1:  Dad not in lab. market "

gen p1pmomnoed = 1 if inpar1 == 1 & p1pmomhed1 == .
gen p1pdadnoed = 1 if inpar1 == 1 & p1pdadhed1 == .


forval i = 0(1)5 {
gen p1sreadl`i' =  pv1rlev == `i' 
}

forval i = 1(1)5 {
replace p1smomhed`i' = 0 if p1smomnoed == 1
replace p1sdadhed`i' = 0 if p1sdadnoed == 1
replace p1pmomnoed  = 0 if  p1pmomhed`i' == 1
replace p1pdadnoed  = 0 if  p1pdadhed`i' == 1
}


forval i = 1(1)5 {
replace p1pmomhed`i' = 0 if p1pmomnoed == 1
replace p1pdadhed`i' = 0 if p1pdadnoed == 1

}

gen p1pmomhedct = 0 if p1pmomnoed == 1
gen p1pdadhedct = 0 if p1pdadnoed == 1

gen p1smomhedct = 0 if p1smomnoed == 1
gen p1sdadhedct = 0 if p1sdadnoed == 1
forval i = 1(1)5 {
replace p1pmomhedct = `i' if p1pmomhed`i' == 1
replace p1pdadhedct = `i' if p1pdadhed`i' == 1
replace p1smomhedct = `i' if p1smomhed`i' == 1
replace p1sdadhedct = `i' if p1sdadhed`i' == 1
}


replace p1pnummoves = . if p1pnummoves > 100 


forval i = 204(1)215 {
local j = `i'-203
gen birthm`j' = agedec2001 ==`i'
}

gen d2dropleavbi = d2dropleav
replace d2dropleavbi = 0 if incycle2 == 0


gen sample = insamp == 1 & inpar1 == 1 & inyits1 == 1 & incycle2 == 1 & incycle3 == 1 & insamp3 == 1


gen inattrit =  incycle2 == 0 | incycle3 == 0 



/***************************************************************************************************/
/***************************************************************************************************/
/***************************************************************************************************/
/*SECTION*/

						/* MAKE DEPVARS */

/***************************************************************************************************/
/***************************************************************************************************/
/**************************************************************************************************
*/

#delim ;
gen dp1 =(hsstatd2 == 1 | hsstatd3 == 1) & dnod2 == 0 & dnod3 == 0 ;
gen dp2 =  (hsstatd2 == 1 | hsstatd3 == 1) & ((dnod2 > 0 & dnod2 < 90) | (dnod3 > 0 & dnod3 < 90));
gen dp3 =  hsstatd2 == 2 & hsstatd3 == 2 & dnod2 == 0 & dnod3 == 0 ;
gen dp4 =   hsstatd3 == 2 & ((dnod2 > 0 & dnod2 < 90) | (dnod3 > 0 & dnod3 < 90));
gen dp5 =  ((hsstatd2 == 3 & hsstatd3 == 3 & dnod2 == 1 & dnod3 == 1) |   
(hsstatd2 == 2 & hsstatd3 == 3 & dnod2 == 0 & dnod3 == 1))  | (hsstatd3 == 3 & hsstatd2 == 2 & dnod2 == 0 & dnod3 == 1) ;
gen dp6= ((hsstatd2 == 3 & hsstatd3 == 3 & ((dnod2 > 1 & dnod2 < 90)| (dnod3 > 1 & dnod3 < 90)))  | (hsstatd3 == 3 & dnod3 > 1 & dnod3 < 90)) |
(hsstatd2 == 2 & hsstatd3 == 3 & dnod2 == 1 & dnod3 == 1);
#delim cr

gen highstat = .
forval i = 1(1)6 {
replace highstat = `i' if dp`i' == 1
}

replace highstat = 0 if highstat == . & incycle2 == 0 | incycle3 == 0  
gen cases81 = 1 if hsstatd2 == 2 & hsstatd3 == 3 & dnod2 == 1 & dnod3 == 1

label define hstf 1 "Graduate"
label define hstf 2 "Graduate who dropped out", a
label define hstf 3 "Continuer", a
label define hstf 4 "Continuer who dropped out", a
label define hstf 5 "Dropout never returned", a
label define hstf 6 "Current dropout, returned before", a
label define hstf 0 "Sample Attrition", a

label val highstat hstf

gen highstat1 = 1 if highstat == 1 | highstat == 2
replace highstat1 = 2 if highstat == 4 | highstat == 3
replace highstat1 = 3 if highstat == 5 | highstat == 6
replace highstat1 = 0 if highstat == 0

label define hstf1 1 "Graduate"
label define hstf1 2 "Continuer", a
label define hstf1 3 "Dropout", a
label define hstf1 0 "Sample Attrition", a

label val highstat1 hstf1

gen c3dropout = 1 if highstat1 == 3 
replace c3dropout = 0 if highstat1 == 2 | highstat1 == 1
replace c3dropout = 3 if highstat1 == 0

gen evdropout = 1 if highstat == 2 | highstat >= 4
replace evdropout = 0 if highstat == 1 | highstat == 3
replace evdropout = 3 if highstat == 0

label define dpf 1 "Dropped out at least once"
label define dpf 0 "Never dropped out", a
label define dpf 3 "Sample Attrition", a

label val evdropout dpf


label define dpf1 1 "Dropped-out at Cycle 3"
label define dpf1 0 "Graduate or continuer at Cycle 3", a
label define dpf1 3 "Sample Attrition", a
label val c3dropout dpf1


global depvr "c3dropout"

replace p1pplaned  = 0 if p1pplaned  == 2

replace wealth = " " if wealth == "N"
destring wealth, replace


egen pisaread = rowmean(pv1read pv2read pv3read pv4read pv5read)

xtile readtile1 = pisaread, nq(4)


local par mom 
gen `par'edcat22 =  pe1b  if mother == 1 & pe1a == 2 & pe1b < 11
replace  `par'edcat22 =  pe1c + 10  if mother == 1 & pe1a == 1 & pe1c < 12
replace  `par'edcat22 =  pe2b  if mother == 0 & pe2a == 2  & pe2b < 11
replace  `par'edcat22 =  pe2c + 10  if mother == 0 & pe2a == 1 & pe2c < 12
replace  `par'edcat22 =  22  if `par'edcat22 == .


local par dad 
gen `par'edcat22 =  pe1b  if mother == 0 & pe1a == 2 & pe1b < 11
replace  `par'edcat22 =  pe1c + 10  if mother == 0 & pe1a == 1 & pe1c < 12
replace  `par'edcat22 =  pe2b  if mother == 1 & pe2a == 2  & pe2b < 11
replace  `par'edcat22 =  pe2c + 10  if mother == 1 & pe2a == 1 & pe2c < 12
replace  `par'edcat22 =  22  if `par'edcat22 == .

local ncat 21
local par mom
gen `par'edcat`ncat' = `par'edcat22
replace   `par'edcat`ncat' = .  if  `par'edcat22 == 11
replace   `par'edcat`ncat' = `par'edcat22 - 1  if `par'edcat22 > 11


local par dad
gen `par'edcat`ncat' = `par'edcat22
replace   `par'edcat`ncat' = .  if  `par'edcat22 == 11
replace   `par'edcat`ncat' = `par'edcat22 - 1  if `par'edcat22 > 11


local ncat 18
local par mom
gen `par'edcat`ncat' = `par'edcat21  if  `par'edcat21 < 14
replace   `par'edcat`ncat' = 13  if  `par'edcat21 == 14
replace   `par'edcat`ncat' = `par'edcat21 - 1  if  `par'edcat21 >= 15 & `par'edcat21 <= 18
replace   `par'edcat`ncat' = 17  if  `par'edcat21 == 19
replace   `par'edcat`ncat' = 18  if  `par'edcat21 == 20 | `par'edcat21 == 21 



local par dad
gen `par'edcat`ncat' = `par'edcat21  if  `par'edcat21 < 14
replace   `par'edcat`ncat' = 13  if  `par'edcat21 == 14
replace   `par'edcat`ncat' = `par'edcat21 - 1  if  `par'edcat21 >= 15 & `par'edcat21 <= 18
replace   `par'edcat`ncat' = 17  if  `par'edcat21 == 19
replace   `par'edcat`ncat' = 18  if  `par'edcat21 == 20 | `par'edcat21 == 21 






local ncat 9
local par mom
gen `par'edcat`ncat' = `par'edcat18 - 9  if  `par'edcat18 > 11
replace   `par'edcat`ncat' = 1  if  `par'edcat18  <= 9
replace   `par'edcat`ncat' = 2  if  `par'edcat18  == 10 |`par'edcat18  == 11


local par dad
gen `par'edcat`ncat' = `par'edcat18 - 9  if  `par'edcat18 > 11
replace   `par'edcat`ncat' = 1  if  `par'edcat18  <= 9
replace   `par'edcat`ncat' = 2  if  `par'edcat18  == 10 |`par'edcat18  == 11



local ncat 6
local par mom
gen `par'edcat`ncat' = `par'edcat9   if  `par'edcat9 < 5
replace   `par'edcat`ncat' = 4  if  `par'edcat9  == 5
replace   `par'edcat`ncat' = 5  if  `par'edcat9  == 6 | `par'edcat9  == 7 | `par'edcat9  == 8
replace   `par'edcat`ncat' = 6  if  `par'edcat9  == 9



local par dad
gen `par'edcat`ncat' = `par'edcat9   if  `par'edcat9 < 5
replace   `par'edcat`ncat' = 4  if  `par'edcat9  == 5
replace   `par'edcat`ncat' = 5  if  `par'edcat9  == 6 | `par'edcat9  == 7 | `par'edcat9  == 8
replace   `par'edcat`ncat' = 6  if  `par'edcat9  == 9



local ncat 5
local par mom
gen `par'edcat`ncat' = `par'edcat9   if  `par'edcat6 < 4
replace   `par'edcat`ncat' = 3  if  `par'edcat6  == 4
replace   `par'edcat`ncat' = 4  if  `par'edcat6  == 5
replace   `par'edcat`ncat' = 5  if  `par'edcat6  == 6



local par dad
gen `par'edcat`ncat' = `par'edcat6   if  `par'edcat6 < 4
replace   `par'edcat`ncat' = 3  if  `par'edcat6  == 4
replace   `par'edcat`ncat' = 4  if  `par'edcat6  == 5
replace   `par'edcat`ncat' = 5  if  `par'edcat6  == 6




local ncat 4
local par mom
gen `par'edcat`ncat' = `par'edcat6   if  `par'edcat6 < 4
replace   `par'edcat`ncat' = 3  if  `par'edcat6  == 4 | `par'edcat6  == 5 
replace   `par'edcat`ncat' = 4  if  `par'edcat6  == 6



local par dad
gen `par'edcat`ncat' = `par'edcat6   if  `par'edcat6 < 4
replace   `par'edcat`ncat' = 3  if  `par'edcat6  == 4 | `par'edcat6  == 5 
replace   `par'edcat`ncat' = 4  if  `par'edcat6  == 6

/***********/

gen studyhrs = 0 if ysa6 == 1
replace studyhrs = 1 if ysa6 == 2
replace studyhrs = 2 if ysa6 == 3
replace studyhrs = 5.5 if ysa6 == 4
replace studyhrs = 11 if ysa6 == 5
replace studyhrs = 15 if ysa6 == 6


gen grdes = 95 if  y1sovgr9t100 == 1
replace grdes = 85 if  y1sovgr80t89  == 1
replace grdes = 75 if  y1sovgr70t79  == 1
replace grdes = 65 if  y1sovgr60t69  == 1
replace grdes = 57 if  y1sovgr55t59  == 1
replace grdes = 52 if  y1sovgr50t54  == 1
replace grdes = 40 if  y1sovgrlt50 == 1

gen c2studyhrs = 0 if f2q12 == 1
replace c2studyhrs = 1 if f2q12== 2
replace c2studyhrs = 2 if f2q12== 3
replace c2studyhrs = 5.5 if f2q12== 4
replace c2studyhrs = 11 if f2q12== 5
replace c2studyhrs = 15 if f2q12== 6


gen c2grdes = 95 if  c2q01a == 1
replace c2grdes = 85 if  c2q01a == 2
replace c2grdes = 75 if  c2q01a == 3
replace c2grdes = 65 if  c2q01a == 4
replace c2grdes = 57 if  c2q01a == 5
replace c2grdes = 52 if  c2q01a == 6
replace c2grdes = 40 if  c2q01a == 7




gen parexplths = pb22 == 1 if pb22 < 90
gen pexphs = pb22 == 2 if pb22 < 90
gen pexptrade = pb22 == 3 if pb22 < 90
gen pexpcoll = pb22 == 4 if pb22 < 90
gen pexpuni= pb22 == 5 if pb22 < 90
gen pexpgrdeg = pb22 == 6 if pb22 < 90
gen pexpany= pb22 == 7 if pb22 < 90

gen parexp  = pb22 if pb22 < 90

gen stuexp = 1 if y1sexphs ~= .
replace stuexp = 2 if  y1sexptrade == 1
replace stuexp = 3 if  y1sexpcollge== 1
replace stuexp = 4 if  y1sexpbadeg== 1
replace stuexp = 5 if  y1sexpgrad == 1
replace stuexp = 6 if  y1sexphs == 1



gen panyobst = pb25a == 1 if pb25a < 3

gen anyobxfin = panyobst*p1pfinobst

gen dstudyhrs = c2studyhrs -studyhrs

gen dgrades =  c2grdes - grdes 

gen frhsimp = ysd2a == 4 if ysd2a < 5

label var  frhsimp "All close friends think high school completion very important"

gen frskip = ysd2b == 4 if ysd2b < 5

label var  frskip "All close friends skip classes once a week"

gen frdrop = ysd2c == 4 if ysd2c < 5

label var  frdrop "All close friends have dropped out"

gen frmoreed = ysd2d == 4 if ysd2d < 5

label var  frmoreed "All close friends plan more ed"

gen frtroub = ysd2e == 4 if ysd2e < 5

label var  frtroub "All close friends have a reputation for trouble"

gen frsmoke = ysd2f == 4 if ysd2f < 5

label var  frsmoke "All close friends smoke"

gen frswkhrd = ysd2g == 4 if ysd2g < 5

label var frswkhrd "All close friends think it's ok to work hard"


gen ya = ysd2a if ysd2a < 5
gen yb = ysd2b if ysd2b < 5
gen yc = ysd2c if ysd2c < 5
gen yd = ysd2d if ysd2d < 5
gen ye = ysd2e if ysd2e < 5
gen yf = ysd2f if ysd2f < 5
gen yg = ysd2g if ysd2g < 5



gen frscale = yb-ya + yc -yd + ye +yf - yg +8

gen depchild= (depchd2 > 0 & depchd2 < 5) |  (depchd3 > 0 & depchd3 < 5)

gen missdepchild = depchd2 == 99 | depchd3 == 99
replace missdepchild = 0 if depchild == 1

gen x1 = sqrt(pa1)
gen aeqivinc= (p1pfaminc/x1)/1000


gen parexpatlhs = 1 if parexplths == 1 | pexphs == 1
replace parexpatlhs = 0 if parexplths == 0 & pexphs == 0

gen rural = 1-p1purban


gen kidexpct = 1 if  y1sexplths == 1
replace kidexpct = 2 if y1sexphs == 1
replace kidexpct = 3 if  y1sexptrade == 1
replace kidexpct = 4 if y1sexpcollge == 1
replace kidexpct = 5 if y1sexpbadeg == 1
replace kidexpct = 6 if  y1sexpgrad   == 1

replace kidexpct = 7 if  ysdv_a11 == 97

gen kiddknow =  ysdv_a11 == 97

label var kidexpct "Y expectation 7 cat"

gen kidexpsm = 1 if kidexpct < 3
replace kidexpsm = 3 if kidexpct > 2 & kidexpct < 5
replace kidexpsm = 4 if kidexpct > 4 & kidexpct ~= .
replace kidexpsm = 2 if ysdv_a11 == 97



gen kidexpsma = 1 if kidexpct < 3
replace kidexpsma = 2 if kidexpct > 2 & kidexpct < 5
replace kidexpsma = 3 if kidexpct > 4 & kidexpct ~= .



label var kidexpsma "Y expectation w/o Don't know"
ta kidexpsm, gen(yexpect)


label var yexpect1 "Y expect HS or less"
label var yexpect2 "Y expect don't know"
label var yexpect3 "Y expect trade or college"
label var yexpect4 "Y expect BA or more"


gen parexpct = 1 if parexplths == 1
replace parexpct = 2 if pexphs == 1 
replace parexpct = 3 if pexptrade == 1
replace parexpct = 4 if pexpcoll  == 1
replace parexpct = 5 if pexpuni  == 1
replace parexpct = 6 if pexpgrdeg   == 1
replace parexpct = 7 if pexpany == 1

gen parexpsm = 1 if parexpct < 3
replace parexpsm = 3 if parexpct > 2 & parexpct < 5
replace parexpsm = 4 if parexpct > 4 & parexpct ~= .
replace parexpsm = 2 if parexpct == 7

ta parexpsm, gen(pexpect)

label var pexpect1 "P expect HS or less"
label var pexpect2 "P expect Any > HS"
label var pexpect3 "P expect trade or college"
label var pexpect4 "P expect BA or more"

gen parhope = 1 if parexpct < 5 | parexpct == 7
replace parhope = 2 if parexpct == 5 | parexpct == 6

gen kidhope = 1 if kidexpct < 5 
replace kidhope = 2 if kidexpct == 5 | kidexpct == 6
replace kidhope = 3 if ysdv_a11 == 97

egen kidparhope = group(kidhope parhope)

label define kidparf 1 "Y < BA P < BA"
label define kidparf 2 "Y < BA P > BA", a
label define kidparf 3 "Y > BA  P < BA", a
label define kidparf 4 "Y > BA  P > BA", a
label define kidparf 5 "Y DK  P < BA", a
label define kidparf 6 "Y DK  P > BA", a

label val kidparhope kidparf





ta kidparhope, gen(hopeint)


label var hopeint1 "Y < BA P < BA"
label var hopeint2 "Y < BA P > BA"
label var hopeint3 "Y > BA  P < BA"
label var hopeint4 "Y > BA  P > BA"
label var hopeint5 "Y DK  P < BA"
label var hopeint6 "Y DK  P > BA"

gen bdate = mdy(bmonthd2,15,byeard2)

gen lsinschool2 = mdy(lesmtd2,15,lesyrd2) if lesyrd2< 9000
gen lsinschool3 = mdy(lesmtd3,15,lesyrd3) if lesyrd3< 9000

gen hsgrad2 = mdy(hsdipmd2,15,hsdipyd2) if hsdipyd2 < 9000
gen hsgrad3 = mdy(hsdipmd3,15,hsdipyd3) if hsdipyd3 < 9000


gen lsinpse2 = mdy(dlpsmd2,15,dlpsyd2) if dlpsyd2 < 9000
gen lsinpse3 = mdy(dlpsmd3,15,dlpsyd3) if dlpsyd3 < 9000

egen maxpse = rowmax(lsinpse2 lsinpse3)


gen datelast = lsinschool2 if hsstatd2 == 3 & hsstatd3 == 3
gen type = 1 if hsstatd2 == 3 & hsstatd3 == 3
replace datelast  = lsinschool3 if hsstatd2 == 2 & hsstatd3 == 3
replace type = 2 if hsstatd2 == 2 & hsstatd3 == 3

replace datelast= lsinschool3 if hsstatd2 == 2 & hsstatd3 == 2
replace type = 3 if hsstatd2 == 2 & hsstatd3 == 2
replace datelast= hsgrad2 if hsstatd2 == 1 & hedld3 == 2
replace type = 4 if hsstatd2 == 1 & hedld3 == 2
replace datelast= hsgrad3 if hsstatd2 ~= 1 & hedld3 == 2
replace type = 5 if hsstatd2 ~= 1 & hedld3 == 2


replace datelast =maxpse if hedld2 == 3 & hedld3 == 3 
replace type = 6 if hedld2 < 3 & hedld3 == 3 


replace datelast =maxpse if hedld2 < 3 & hedld3 == 3 
replace type = 7 if hedld2 < 3 & hedld3 == 3 

replace datelast =maxpse if hedld2 == 4 & hedld3 == 4
replace type = 8 if hedld2 == 4 & hedld3 == 4

replace datelast =maxpse if hedld2 < 4 & hedld3 == 4
replace type = 9 if hedld2 < 4 & hedld3 == 4

gen startdate = mdy(4,15,2000)



gen lastmonth = (datelast - startdate)/30



label define typef 1 "High school drop -out before Age 17"
label define typef 2 "High school drop -out between Age 17- 19", a
label define typef 3 "Still in high school Age 19", a
label define typef 4 "High school grad by age 17", a
label define typef 5 "High school grad by age 19", a
label define typef 6 "PSE not completed started before age 17", a
label define typef 7 "PSE not completed started between Age 17- 19", a
label define typef 8 "Completed PSE before age 17", a
label define typef 9 "Completed PSE between Age 17- 19", a

label val type typef



gen pse = type > 5 if type ~= .
gen hs = type == 4 |type == 5 if type ~= .
gen lths = type < 4 if type ~= .

replace pse = 0 if hedld2 == 1 & hedld3 == 1 & type == .
replace hs = 0 if hedld2 == 1 & hedld3 == 1 & type == .
replace lths = 1 if hedld2 == 1 & hedld3 == 1 & type == .

replace pse = 1 if hedld2 == 3 & hedld3 == 3 & type == .
replace hs = 0 if hedld2 == 3 & hedld3 == 3 & type == .
replace lths = 0 if hedld2 == 3 & hedld3 == 3 & type == .




gen uni = (hlpsd2 > 8 & hlpsd2 < 21) | (hlpsd3 > 8 & hlpsd3 < 21)
replace uni = . if hlpsd2 > 96 & hlpsd3 > 96

gen college = pse == 1 & uni == 0
replace college = . if pse == . | uni == .






label define daded5f 1 "Less than high school"
label define daded5f 2 "High school", a
label define daded5f 3 "Any PSE below BA", a
label define daded5f 4 "BA and above", a
label define daded5f 5 "Missing data", a

label val dadedcat5 daded5f
label val momedcat5 daded5f


egen a2 =group(dadedcat5 momedcat5)

label define edcat5intf 1 "Dad < HS Mom < HS"
label define edcat5intf 2 "Dad < HS Mom HS", a
label define edcat5intf 3 "Dad < HS Mom PSE below BA", a
label define edcat5intf 4 "Dad < HS Mom BA or more", a
label define edcat5intf 5 "Dad < HS Mom Missing", a
label define edcat5intf 6 "Dad HS Mom < HS", a
label define edcat5intf 7 "Dad HS Mom HS", a
label define edcat5intf 8 "Dad HS Mom PSE below BA", a
label define edcat5intf 9 "Dad HS Mom BA or more", a
label define edcat5intf 10 "Dad HS Mom Missing", a
label define edcat5intf 11 "Dad PSE below BA Mom < HS", a
label define edcat5intf 12 "Dad PSE below BA Mom HS", a
label define edcat5intf 13 "Dad PSE below BA Mom PSE below BA", a
label define edcat5intf 14 "Dad PSE below BA Mom BA or more", a
label define edcat5intf 15 "Dad PSE below BA Mom Missing", a
label define edcat5intf 16 "Dad BA or more Mom < HS", a
label define edcat5intf 17 "Dad BA or more Mom HS", a
label define edcat5intf 18 "Dad BA or more Mom PSE below BA", a
label define edcat5intf 19 "Dad BA or more Mom BA or more", a
label define edcat5intf 20 "Dad BA or more Mom Missing", a
label define edcat5intf 21 "Dad missing Mom < HS", a
label define edcat5intf 22 "Dad missing Mom HS", a
label define edcat5intf 23 "Dad missing Mom PSE below BA", a
label define edcat5intf 24 "Dad missing Mom BA or more", a
label define edcat5intf 25 "Dad missing Mom Missing", a


label val a2 edcat5intf


label var a2 "Parents Ed interacted"

ta a2, gen(paredint)

label var paredint1 "Dad < HS Mom < HS"
label var paredint2 "Dad < HS Mom HS"
label var paredint3 "Dad < HS Mom PSE below BA"
label var paredint4 "Dad < HS Mom BA or more"
label var paredint5 "Dad < HS Mom Missing"
label var paredint6 "Dad HS Mom < HS"
label var paredint7 "Dad HS Mom HS"
label var paredint8 "Dad HS Mom PSE below BA"
label var paredint9 "Dad HS Mom BA or more"
label var paredint10 "Dad HS Mom Missing"
label var paredint11 "Dad PSE below BA Mom < HS"
label var paredint12 "Dad PSE below BA Mom HS"
label var paredint13 "Dad PSE below BA Mom PSE below BA"
label var paredint14 "Dad PSE below BA Mom BA or more"
label var paredint15 "Dad PSE below BA Mom Missing"
label var paredint16 "Dad BA or more Mom < HS"
label var paredint17 "Dad BA or more Mom HS"
label var paredint18 "Dad BA or more Mom PSE below BA"
label var paredint19 "Dad BA or more Mom BA or more"
label var paredint20 "Dad BA or more Mom Missing"
label var paredint21 "Dad missing Mom < HS"
label var paredint22 "Dad missing Mom HS"
label var paredint23 "Dad missing Mom PSE below BA"
label var paredint24 "Dad missing Mom BA or more"
label var paredint25 "Dad missing Mom Missing"


gen lowpayexp = (ysk1j == 3 | ysk1j == 4) & ysk1j~= 9

gen nogoal = ysk7d == 6
gen dkgoal = ysk7d == 9
gen nounigoal = ysk7d == 2 & ysk7e == 2 


label var nogoal "Y does not have occupation goal"
label var dkgoal "Y doesn't know how much ed for goal"
label var nounigoal "Less than uni needed for goal"

gen savedforkid = pb2701 == 1 |  pb2702 == 1 | pb2703 == 1 | pb2704 == 1 | pb2705 == 1
#delim ;
replace savedforkid = . if (pb2701 == 8 | pb2701 == 9) &   (pb2702 == 8 | pb2702 == 9)
 &   (pb2703 == 8 | pb2703 == 9) &   (pb2704 == 8 | pb2704 == 9) &   (pb2705 == 8 | pb2705 == 9) ;
#delim cr

gen nosave = 1-savedforkid

label var  nosave "Parent has not saved for ed"
label var savedforkid "Parent has saved for ed"

 save "K:\Dropouts\May 2011 Programs\Data\Stata Data May 4 2011.dta", replace




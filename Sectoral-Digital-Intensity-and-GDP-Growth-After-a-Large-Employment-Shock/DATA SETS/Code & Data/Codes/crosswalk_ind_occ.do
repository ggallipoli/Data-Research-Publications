

gen soc2010=.
label var soc2010   `"Soc2010 occupation codes"'

// Code for Ipums Canada and soc 2010 crosswalks
* Note- A few ipums occ codes have the same soc codes as ipums splits a few occupations over mutiple codes. These are highlighted in green. Can refer back later for checking.

replace soc2010=111 if occ==1
label define soc2010_lbl 111 `"Legislators"', add

replace soc2010= 113 if occ==2
label define soc2010_lbl 113 `"Administrative and financial Managers"', add

replace soc2010=113 if occ==3
*label define soc2010_lbl 113 `"Administrative and financial Managers"', add

replace soc2010= 119 if occ==4
label define soc2010_lbl 119 `"Other Managers"', add

replace soc2010= 112 if occ==5
label define soc2010_lbl 112 `"Sales Managers"', add

replace soc2010= 119 if occ==6
* label define soc2010_lbl 119 `"Other Managers"', add

replace soc2010= 119 if occ==7
* label define soc2010_lbl 119 `"Other Managers"', add

replace soc2010= 119 if occ==8
* label define soc2010_lbl 119 `"Other Managers"', add

replace soc2010= 113 if occ==9
*label define soc2010_lbl 113 `"Administrative and financial Managers"', add

replace soc2010= 132 if occ==10
label define soc2010_lbl 132 `"Financial Specialists"', add

replace soc2010= 131 if occ==11
label define soc2010_lbl 131 `"Business Operations Specialists"', add

replace soc2010= 231 if occ==12
label define soc2010_lbl 231 `"Legal Occupations"', add

replace soc2010= 436 if occ==13
label define soc2010_lbl 436 `"Office Administrative Assistants"', add

replace soc2010= 131 if occ==14
* label define soc2010_lbl 131 `"Business Operations Specialists"', add

replace soc2010= 439 if occ==15
label define soc2010_lbl 439 `"General Office Workers"', add

replace soc2010= 433 if occ==16
label define soc2010_lbl 433 `"Financial Administrative Support Workers"', add

replace soc2010= 434 if occ==17
label define soc2010_lbl 434 `"Other Clerks"', add

replace soc2010= 435 if occ==18
label define soc2010_lbl 435 `"Material Recording, Scheduling, Dispatching, and Distributing Workers"', add

replace soc2010= 172 if occ==19
label define soc2010_lbl 172 `"Engineers"', add

replace soc2010= 152 if occ==20
label define soc2010_lbl 152 `"Computer Occupations"', add

replace soc2010= 191 if occ==21
label define soc2010_lbl 191 `"Life Science Occupations"', add

replace soc2010= 173 if occ==22
label define soc2010_lbl 173 `"Electrical Technicians"', add

replace soc2010= 194 if occ==23
label define soc2010_lbl 194 `"Life Science Technicians"', add

replace soc2010= 291 if occ==24
label define soc2010_lbl 291 `"Healthcare Practitioners and Technical Occupations"', add

replace soc2010= 291 if occ==25
*label define soc2010_lbl 291 `"Healthcare Practitioners and Technical Occupations"', add

replace soc2010= 292 if occ==26
label define soc2010_lbl 292 `"Medical Technicians"', add

replace soc2010= 319 if occ==27
label define soc2010_lbl 319 `"Supporting Health Services"', add

replace soc2010= 319 if occ==28
*label define soc2010_lbl 319 `"Supporting Health Services"', add

replace soc2010= 251 if occ==29
label define soc2010_lbl 251 `"Post Secondary Teachers"', add

replace soc2010= 252 if occ==30
label define soc2010_lbl 252 `"Elementary and Secondary Teachers"', add

replace soc2010= 211 if occ==31
label define soc2010_lbl 211 `"Community and Social Services"', add

replace soc2010= 193 if occ==32
label define soc2010_lbl 193 `"Social Scientists and related workers"', add

replace soc2010= 232 if occ==33
label define soc2010_lbl 232 `"Paralegal Support Workers"', add

replace soc2010= 331 if occ==34
label define soc2010_lbl 331 `"Front Line Protective Workers"', add

replace soc2010= 333 if occ==35
label define soc2010_lbl 333 `"Public Protection"', add

replace soc2010=254  if occ==36
label define soc2010_lbl 254 `"Librarians and archivists"', add

replace soc2010= 271 if occ==37
label define soc2010_lbl 271 `"Art and Design Workes"', add

replace soc2010= 272 if occ== 38
label define soc2010_lbl  272 `"Athletes, coaches"', add

replace soc2010= 413  if occ== 39
label define soc2010_lbl 413 `"Sales Representatives"', add

replace soc2010= 411 if occ== 40
label define soc2010_lbl 411 `"Sales Supervisors"', add

replace soc2010= 351 if occ== 41
label define soc2010_lbl 351 `"Chefs and cooks"', add

replace soc2010= 352 if occ== 42
label define soc2010_lbl 352 `"Customer Service"', add

replace soc2010= 412 if occ== 43
label define soc2010_lbl 412 `"Retail Sales"', add

replace soc2010= 412 if occ== 44
* label define soc2010_lbl 412 `"Retail Sales"', add

replace soc2010= 353 if occ== 45
label define soc2010_lbl 353 `"Food and Beverage Services"', add

replace soc2010= 339 if occ== 46
label define soc2010_lbl 339 `"Security Guards"', add

replace soc2010= 434 if occ== 47
*label define soc2010_lbl 434 `"Other Clerks"', add

replace soc2010= 413 if occ== 48
* label define soc2010_lbl 413 `"Travel and accommodation"', add

replace soc2010= 412 if occ== 49
* label define soc2010_lbl 412 `"Retail Sales"', add

replace soc2010= 419 if occ== 50
label define soc2010_lbl 419 `"Other Sales Workers"', add

replace soc2010= 359 if occ== 51
label define soc2010_lbl 359 `"Other Food Helpers"', add

replace soc2010= 372 if occ== 52
label define soc2010_lbl 372 `"Cleaners"', add

replace soc2010= 514 if occ== 53
label define soc2010_lbl 514 `"Metal Forming"', add

replace soc2010= 499 if occ== 54
label define soc2010_lbl 499 `"Telecommunications Workers"', add

replace soc2010= 517 if occ== 55
label define soc2010_lbl 517 `"Wood Workers"', add

replace soc2010= 472 if occ== 56
label define soc2010_lbl 472 `"Industrial Workers"', add

replace soc2010= 492 if occ== 57
label define soc2010_lbl 492 `"Machinery mechanics"', add

replace soc2010= 493 if occ== 58
label define soc2010_lbl  493 `"Automatice technicians"', add

replace soc2010= 491 if occ== 59
label define soc2010_lbl 491 `"Maintenance Trades: Contractors"', add

replace soc2010= 499 if occ== 60
* label define soc2010_lbl 499 `"Other installers repairers"', add

replace soc2010= 533 if occ== 61
label define soc2010_lbl 533 `"Vehicle Drivers"', add

replace soc2010= 534 if occ== 62
label define soc2010_lbl 534 `"Heavy equipment operators"', add

replace soc2010= 537 if occ== 63
label define soc2010_lbl 537 `"Trades Helpers and labourers"', add

replace soc2010= 451 if occ== 64
label define soc2010_lbl 451 `"Supervisors forestry"', add

replace soc2010= 452 if occ== 65
label define soc2010_lbl 452 `"Agricultural Workers"', add

replace soc2010= 371 if occ== 66
label define soc2010_lbl  371 `"Landscaping"', add

replace soc2010= 512 if occ== 67
label define soc2010_lbl 512 `"Assemblers"', add

replace soc2010= 516 if occ== 68
label define soc2010_lbl  516 `"Machine Operators"', add

replace soc2010= 519 if occ== 69
label define soc2010_lbl 519 `"Assembly Workers"', add

replace soc2010= 537 if occ== 70
* label define soc2010_lbl 537 `"Labourers in Processing"', add

label values soc2010 soc2010_lbl



// Code industry from https://international.ipums.org/international-action/variables/CA2011A_0405#codes_section

gen ind_codes=.
label var ind_codes   `"Industry codes"'

replace ind_codes=1 if ind==1
label define ind_codes_lbl 1 `"Agriculture, forestry, fishing and hunting"', add

replace ind_codes=2 if ind==2
label define ind_codes_lbl 2 `"Mining, quarrying, and oil and gas extraction"', add

replace ind_codes=3 if ind==3
label define ind_codes_lbl 3 `"Utilities"', add

replace ind_codes=4 if ind==4
label define ind_codes_lbl 4 `"Construction"', add

replace ind_codes=5 if ind==5
label define ind_codes_lbl 5 `"Manufacturing"', add

replace ind_codes=6 if ind==6
label define ind_codes_lbl 6 `"Wholesale Trade"', add

replace ind_codes=7 if ind==7
label define ind_codes_lbl 7 `"Retail Trade"', add

replace ind_codes=8 if ind==8
label define ind_codes_lbl 8 `"Transportation and Warehousing"', add

replace ind_codes=9 if ind==9
label define ind_codes_lbl 9 `"Information and cultural industries"', add

replace ind_codes=10 if ind==10
label define ind_codes_lbl 10 `"Finance and Insurance"', add

replace ind_codes=11 if ind==11
label define ind_codes_lbl 11 `"Real Estate"', add

replace ind_codes=12 if ind==12
label define ind_codes_lbl 12 `"Professional, scientific and technical services"', add

replace ind_codes=13 if ind==13
label define ind_codes_lbl 13 `"Administrative Support"', add

replace ind_codes=14 if ind==14
label define ind_codes_lbl 14 `"Educational Services"', add

replace ind_codes=15 if ind==15
label define ind_codes_lbl 15 `"Health care and social assistance"', add

replace ind_codes=16 if ind==16
label define ind_codes_lbl 16 `"Information, culture & recreation"', add

replace ind_codes=17 if ind==17
label define ind_codes_lbl 17 `"Accommodationa and food services"', add

replace ind_codes=18 if ind==18
label define ind_codes_lbl 18 `"Other Services"', add

replace ind_codes=19 if ind==19
label define ind_codes_lbl 19 `"Public Administration"', add

label values ind_codes ind_codes_lbl



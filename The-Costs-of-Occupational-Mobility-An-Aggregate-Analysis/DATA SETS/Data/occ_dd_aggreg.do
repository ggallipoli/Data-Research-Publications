# delimit ;

* This do-file aggregates Autor-Dorn occupation codes;

* From 3-digit to 2-digit: occ2dig_dd;
gen occ2dig_dd=2 if occ1990dd>=4 & occ1990dd<=22;
replace occ2dig_dd=3 if occ1990dd>=23 & occ1990dd<=37;
replace occ2dig_dd=4 if occ1990dd>=43 & occ1990dd<=59;
replace occ2dig_dd=5 if occ1990dd>=64 & occ1990dd<=83;
replace occ2dig_dd=7 if occ1990dd>=84 & occ1990dd<=89;
replace occ2dig_dd=8 if occ1990dd>=95 & occ1990dd<=106;
replace occ2dig_dd=9 if occ1990dd==154;
replace occ2dig_dd=10 if occ1990dd>=155 & occ1990dd<=163;
replace occ2dig_dd=11 if occ1990dd>=164 & occ1990dd<=177;
replace occ2dig_dd=12 if occ1990dd==178;
replace occ2dig_dd=13 if occ1990dd>=183 & occ1990dd<=199; 
replace occ2dig_dd=14 if occ1990dd>=203 & occ1990dd<=208;
replace occ2dig_dd=15 if occ1990dd>=214 & occ1990dd<=225;
replace occ2dig_dd=16 if occ1990dd>=226 & occ1990dd<=235;
replace occ2dig_dd=17 if occ1990dd>=243 & occ1990dd<=256;
replace occ2dig_dd=18 if occ1990dd>=258 & occ1990dd<=283;
replace occ2dig_dd=19 if occ1990dd>=303 & occ1990dd<=308;
replace occ2dig_dd=20 if occ1990dd>=313 & occ1990dd<=315;
replace occ2dig_dd=21 if occ1990dd>=316 & occ1990dd<=336;
replace occ2dig_dd=22 if occ1990dd>=337 & occ1990dd<=344;
replace occ2dig_dd=24 if occ1990dd>=346 & occ1990dd<=357;
replace occ2dig_dd=25 if occ1990dd>=359 & occ1990dd<=389;
replace occ2dig_dd=26 if occ1990dd>=405 & occ1990dd<=408;
replace occ2dig_dd=27 if occ1990dd>=415 & occ1990dd<=427;
replace occ2dig_dd=28 if occ1990dd>=433 & occ1990dd<=444;
replace occ2dig_dd=29 if occ1990dd>=445 & occ1990dd<=447;
replace occ2dig_dd=30 if occ1990dd>=448 & occ1990dd<=455;
replace occ2dig_dd=31 if occ1990dd>=457 & occ1990dd<=472;
replace occ2dig_dd=32 if occ1990dd>=473 & occ1990dd<=475;
replace occ2dig_dd=33 if occ1990dd>=479 & occ1990dd<=498;
replace occ2dig_dd=35 if occ1990dd>=503 & occ1990dd<=549;
replace occ2dig_dd=36 if occ1990dd>=558 & occ1990dd<=599;
replace occ2dig_dd=37 if occ1990dd>=614 & occ1990dd<=699;
replace occ2dig_dd=38 if occ1990dd>=703 & occ1990dd<=779;
replace occ2dig_dd=39 if occ1990dd>=783 & occ1990dd<=789;
replace occ2dig_dd=40 if occ1990dd==799;
replace occ2dig_dd=41 if occ1990dd>=803 & occ1990dd<=859;
replace occ2dig_dd=43 if occ1990dd>=865 & occ1990dd<=873;
replace occ2dig_dd=44 if occ1990dd>=875 & occ1990dd<=889;
replace occ2dig_dd=45 if occ1990dd==905;

label var occ2dig_dd "2-digit occ code (DD)";


* From 2-digit to 1-digit: occ1dig_dd;
gen occ1dig_dd=01 if occ2dig_dd>=2 & occ2dig_dd<=3;
replace occ1dig_dd=02 if occ2dig_dd>=4 & occ2dig_dd<=16;
replace occ1dig_dd=03 if occ2dig_dd>=17 & occ2dig_dd<=18;
replace occ1dig_dd=04 if occ2dig_dd>=19 & occ2dig_dd<=25;
replace occ1dig_dd=05 if occ2dig_dd>=26 & occ2dig_dd<=31;
replace occ1dig_dd=06 if occ2dig_dd>=32 & occ2dig_dd<=33;
replace occ1dig_dd=07 if occ2dig_dd>=35 & occ2dig_dd<=37;
replace occ1dig_dd=08 if occ2dig_dd>=38 & occ2dig_dd<=40;
replace occ1dig_dd=09 if occ2dig_dd>=41 & occ2dig_dd<=44;

label var occ1dig_dd "1-digit occ code (DD)";

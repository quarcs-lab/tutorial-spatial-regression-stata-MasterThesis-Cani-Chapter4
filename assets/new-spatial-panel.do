* explore my non-spatial data: datapanel
use data3

* label the variables
label variable fips "Spatial-unit ID"
label variable district "District name"
label variable gpov "Growth of Poverty Rate"
label variable gsev "Growth of Poverty Severity Index"
label variable ggap "Growth of Poverty Gap Index"
label variable mys "Mean Year School"
label variable shr_agr "Share of Agricultural sector GRDP"
label variable unemp "Unemployment Rate"
label variable gdpgr "Economic growth"
label variable shr_ind "Share of Manufacturing sector GRDP"
label variable subs_rice "Percentage of poor receiving subsidized rice"
label variable inv_shr "Public investment to GDP"
label variable gdi "Gender Development Index"



* describe and summarize myPANEL
describe
summarize

* save myPANEL
save, replace

* Import and translate to stata shapa file
clear
spshape2dta INDO_KAB_2016, replace

* NOTE:  Two stata files will be created
* myMAP_shp.dta
* myMAP.dta

* explore my spatial data: myMAP
use INDO_KAB_2016

* describe and summarize myMAP.dta
describe
summarize


* generate new spatial-unit id: fips
destring IDKAB, generate(fips)

save, replace

* change the spatial-unit id from _ID to fips
spset fips, modify replace

* modify the coordinate system from planar to latlong
spset, modify coordsys(latlong, miles)

* Check spatial ID and coordinate system
spset

use data3
* merge with myPANEL 
xtset fips year 
spbalance 
merge m:1 fips using INDO_KAB_2016
keep if _merge==3 
drop _merge

xtset

spset


* Check spatial ID and coordinate system
spset

* save new extended MAP data
save mymap_and_panel , replace

describe

* Check spatial ID and coordinate system
spset

use mymap_and_panel
describe


****--------------------------------
****--------------------------------
*Testing Beta Convergence

** Beta convergence without Spatial Effect


* Plot beta convergence
** Poverty Rate
twoway (scatter gpov ln_pov) (lfit gpov ln_pov), xtitle("ln_Poverty Rate in 2010") ytitle("Average Growth of Poverty Rate 2010-2018") legend (off) 
graph save   "beta-pov.gph", replace
graph export "beta-pov.pdf", replace

** Poverty Gap
twoway (scatter ggap ln_gap) (lfit ggap ln_gap), xtitle("ln_Poverty Gap in 2010") ytitle("Average Growth of Poverty Gap 2010-2018") legend (off) 
graph save   "beta-gap.gph", replace
graph export "beta-gap.pdf", replace

** Poverty Sev
twoway (scatter gsev ln_sev) (lfit gsev ln_sev), xtitle("ln_Poverty Sev in 2010") ytitle("Average Growth of Poverty Severity 2010-2018") legend (off) 
graph save   "beta-sev.gph", replace
graph export "beta-sev.pdf", replace

* Absolute Beta regression for poverty rate
xtreg gpov ln_pov, robust
gen speed_pov = - (log(1+_b[ln_pov])/8)
gen halfLife_pov = log(2)/speed_pov



*Absolute Beta regression for poverty gap
xtreg ggap ln_gap, robust
gen speed_gap = - (log(1+_b[ln_gap])/8)
gen halfLife_gap = log(2)/speed_gap



*Absolute Beta regression for poverty severity
xtreg gsev ln_sev, robust
gen speed_sev = - (log(1+_b[ln_sev])/8)
gen halfLife_sev = log(2)/speed_sev


* Conditional Beta regression for poverty rate
xtreg gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind 
gen speed_pov1 = - (log(1+_b[ln_pov])/8)
gen halfLife_pov1 = log(2)/speed_pov1


* The same for poverty gap
xtreg ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind 
gen speed_gap1 = - (log(1+_b[ln_gap])/8)
gen halfLife_gap1= log(2)/speed_gap1



*Conditional Beta regression for poverty severity
xtreg gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind 
gen speed_sev2 = - (log(1+_b[ln_sev])/8)
gen halfLife_sev2= log(2)/speed_sev2



*-------------------------------------------------------
***************** Close log file*************
*-------------------------------------------------------

log close


** Testing for Moran's I statistics
moransi gpov, lon(COORD_X) lat (COORD_Y) swm (pow 2) dist(.) dunit(km) approx
egen std_gpov = std (gpov)
spgen std_pov2010, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
moransi pov2018, lon(coord_x) lat (coord_y) swm (pow 2) dist(.) dunit(km) approx
egen std_pov2018 = std (pov2018)
spgen std_pov2018, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
moransi gap2010, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
egen std_gap2010 = std (gap2010)
spgen std_gap2010, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
moransi gap2018, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
egen std_gap2018 = std (gap2018)
spgen std_gap2018, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
moransi sev2010, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
egen std_sev2010 = std (sev2010)
spgen std_sev2010, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
moransi sev2018, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
egen std_sev2018 = std (sev2018)
spgen std_sev2018, lon(coord_x) lat (coord_y)  swm (pow 2) dist(.) dunit(km) approx
clear


** Creating scatter plot

rename splag1_std_pov2010 w_std_pov2010
twoway (scatter w_std_pov2010 std_pov2010) (lfit w_std_pov2010 std_pov2010), xtitle("Standardized Poverty Rate in 2010") ytitle("W.Standardized Poverty Rate in 2010") legend (off) 
graph save   "pov2010.gph", replace
graph export "pov2010.pdf", replace

rename splag1_std_pov2018 w_std_pov2018
twoway (scatter w_std_pov2018 std_pov2018) (lfit w_std_pov2018 std_pov2018), xtitle("Standardized Poverty Rate in 2018") ytitle("W.Standardized Poverty Rate in 2018") legend (off) 
graph save   "pov2018.gph", replace
graph export "pov2018.pdf", replace

rename splag1_std_gap2010 w_std_gap2010
twoway (scatter w_std_gap2010 std_gap2010) (lfit w_std_gap2010 std_gap2010), xtitle("Standardized Poverty Gap in 2010") ytitle("W.Standardized Poverty Gap in 2010") legend (off) 
graph save   "gap2010.gph", replace
graph export "gap2010.pdf", replace

rename splag1_std_gap2018 w_std_gap2018
twoway (scatter w_std_gap2018 std_gap2018) (lfit w_std_gap2018 std_gap2018), xtitle("Standardized Poverty Gap in 2018") ytitle("W.Standardized Poverty Gap in 2018") legend (off) 
graph save   "gap2018.gph", replace
graph export "gap2018.pdf", replace

rename splag1_std_sev2010 w_std_sev2010
twoway (scatter w_std_sev2010 std_sev2010) (lfit w_std_sev2010 std_sev2010), xtitle("Standardized Poverty Severity in 2010") ytitle("W.Standardized Poverty Severity in 2010") legend (off) 
graph save   "sev2010.gph", replace
graph export "sev2010.pdf", replace

rename splag1_std_sev2018 w_std_sev2018
twoway (scatter w_std_sev2018 std_sev2018) (lfit w_std_sev2018 std_sev2018), xtitle("Standardized Poverty Severity in 2018") ytitle("W.Standardized Poverty Severity in 2018") legend (off) 
graph save   "sev2018.gph", replace
graph export "sev2018.pdf", replace

* create the spatial weights matrix ( for panel data)
spmat import Wi using Wx


** OLS Random Effect or Conditional 

** Poverty rate
xtreg gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind 
gen speed_1 = - (log(1+_b[ln_pov])/8)
gen halfLife_1 = log(2)/speed_1

** Poverty gap
xtreg ggap ln_gap mys gdpgr unemp subs_rice gdi ln_inv shr_agr shr_ind
gen speed_2 = - (log(1+_b[ln_gap])/8)
gen halfLife_2= log(2)/speed_2

* The same for poverty gap
xtreg gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind
gen speed_3 = - (log(1+_b[ln_sev])/8)
gen halfLife_3 = log(2)/speed_3

estimates store ols_re

*---------- Testing for cross-sectional dependence in the panel data model----------**

set matsize 700

** Pesaran's test
xtcsd, pes abs

** Friedman's Test
xtcsd, fri abs

** Frees' Test
xtcsd, fre abs



**SAR Random Effect Model 
** Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) re 
gen speed1 = - (log(1+_b[ln_pov])/8)
gen halfLife1 = log(2)/speed1
estat ic

* The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) re 
gen speed2 = - (log(1+_b[ln_gap])/8)
gen halfLife2 = log(2)/speed2
estat ic

* The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) re 
gen speed3 = - (log(1+_b[ln_sev])/8)
gen halfLife3 = log(2)/speed3
estat ic

estimates store sar_re


**SDM Random Effect Model 

** Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) re 
gen speed4 = - (log(1+_b[ln_pov])/8)
gen halfLife4 = log(2)/speed4
estat ic


* The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) re 
gen speed5 = - (log(1+_b[ln_gap])/8)
gen halfLife5 = log(2)/speed5
estat ic

* The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) re 
gen speed6 = - (log(1+_b[ln_sev])/8)
gen halfLife6 = log(2)/speed6
estat ic

estimates store sdm_re

**OLS Fixed Effect
** Poverty rate
quietly xtreg gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, fe
gen speed7 = - (log(1+_b[ln_pov])/8)
gen halfLife7 = log(2)/speed7
estat ic
eststo model1

* The same for poverty gap
quietly xtreg ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, fe 
gen speed8 = - (log(1+_b[ln_gap])/8)
gen halfLife8  = log(2)/speed8
estat ic
eststo model2


* The same for poverty severity
quietly xtreg gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, fe
gen speed9 = - (log(1+_b[ln_sev])/8)
gen halfLife9 = log(2)/speed9
estat ic
eststo model3

esttab, aic bic r2

estimates store ols_fe

set matsize 700

** Pesaran's test
xtcsd, pes abs

** Friedman's Test
xtcsd, fri abs

** Frees' Test
xtcsd, fre abs

hausman ols_fe ols_re


**SAR Fixed Effect Model 

** Poverty rate
quietly xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) 
gen speed10 = - (log(1+_b[ln_pov])/8)
gen halfLife10 = log(2)/speed10
estat ic
eststo model1



* The same for poverty gap
quietly xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) 
gen speed11 = - (log(1+_b[ln_gap])/8)
gen halfLife11 = log(2)/speed11
estat ic
eststo model5


* The same for poverty severity
quietlyxsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) 
gen speed12 = - (log(1+_b[ln_sev])/8)
gen halfLife12 = log(2)/speed12
eststo model 3
estat ic
esttab r2 aic bic

estimates store sar_fe

*Dynamic SAR Fixed Effect Model 

** Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe dlag (2) type (ind) 
gen speed13 = - (log(1+_b[ln_pov])/8)
gen halfLife13 = log(2)/speed13
estat ic


* The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe dlag (2) type (ind)
gen speed14 = - (log(1+_b[ln_gap])/8)
gen halfLife14 = log(2)/speed14
estat ic

* The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe dlag (2) type (ind) 
gen speed15 = - (log(1+_b[ln_sev])/8)
gen halfLife15 = log(2)/speed15
estat ic

estimates store sar_fe

**SEM Fixed Effect Model 

** Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, emat (Wi) model (sem) fe type (ind)  
gen speed16 = - (log(1+_b[ln_pov])/8)
gen halfLife16 = log(2)/speed16
estat ic


* The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, emat (Wi) model (sem) fe type (ind)
gen speed17 = - (log(1+_b[ln_gap])/8)
gen halfLife17 = log(2)/speed17
estat ic

* The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, emat (Wi) model (sem) fe type (ind)
gen speed18 = - (log(1+_b[ln_sev])/8)
gen halfLife18 = log(2)/speed18
estat ic

estimates store sem_fe

**SAC Fixed Effect Model 

** Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) emat (Wi) model (sac) fe type (ind)
gen speed19 = - (log(1+_b[ln_pov])/8)
gen halfLife19 = log(2)/speed19
estat ic


* The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) emat (Wi) model (sac) fe type (ind)
gen speed20 = - (log(1+_b[ln_gap])/8)
gen halfLife20 = log(2)/speed20
estat ic

* The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) emat (Wi) model (sac) fe type (ind)
gen speed21 = - (log(1+_b[ln_sev])/8)
gen halfLife21 = log(2)/speed21
estat ic

estimates store sac_fe

**SDM Fixed Effect Model 

** Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) fe type (ind) 
gen speed22 = - (log(1+_b[ln_pov])/8)
gen halfLife22 = log(2)/speed22
estat ic


* The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) fe type (ind)
gen speed23 = - (log(1+_b[ln_gap])/8)
gen halfLife23 = log(2)/speed23
estat ic

* The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) fe  type (ind)
gen speed24 = - (log(1+_b[ln_sev])/8)
gen halfLife24 = log(2)/speed24
estat ic


estimates store sdm_fe

**Dynamic SDM Fixed Effect Model 

** Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) dlag (2) fe type (ind) 
gen speed25 = - (log(1+_b[ln_pov])/8)
gen halfLife25 = log(2)/speed25
estat ic


* The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) dlag (2) fe type (ind)
gen speed26 = - (log(1+_b[ln_gap])/8)
gen halfLife26 = log(2)/speed26
estat ic

* The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) dlag (2) fe  type (ind)
gen speed27 = - (log(1+_b[ln_sev])/8)
gen halfLife27 = log(2)/speed27
estat ic


estimates store sdm_fe

** Haussman Test

hausman sar_fe sar_re
hausman sem_fe sem_re
hausman sac_fe sac_re
hausman sdm_fe sdm_re



*** Erase "unnecesary" files
*They are erased because they can be re-generated when the entire do file is run.
* Also because it is not possible to upload a file that is >100MB to github
erase myMAP_shp.dta

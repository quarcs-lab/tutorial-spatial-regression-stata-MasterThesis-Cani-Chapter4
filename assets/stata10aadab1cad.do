**SAR Fixed Effect Model 
sysuse mymap_and_panel

**Import Wa ( our weight matrix) into our panel model. I rename with Wi

spmat import Wi using Wa

**Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) effects
gen speed4 = - (log(1+_b[ln_pov])/8)
gen halfLife4 = log(2)/speed4
estat ic

** The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) effects
gen speed5 = - (log(1+_b[ln_gap])/8)
gen halfLife5 = log(2)/speed5
estat ic

** The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) effects
gen speed6 = - (log(1+_b[ln_sev])/8)
gen halfLife6 = log(2)/speed6
estat ic

estimates store sar_fe


** SAR Random Effect


*Poverty rate
xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) re 
gen speed7 = - (log(1+_b[ln_pov])/8)
gen halfLife7 = log(2)/speed7
estat ic

*The same for poverty gap
xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) re  
gen speed8 = - (log(1+_b[ln_gap])/8)
gen halfLife8  = log(2)/speed8
estat ic


*The same for poverty severity
xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) re 
gen speed9 = - (log(1+_b[ln_sev])/8)
gen halfLife9 = log(2)/speed9
estat ic

estimates store sar_re

** Conducting Hausman Test

hausman sar_fe sar_re


Regional Poverty, Convergence, and Spatial Effects:
================
Ragdad Cani Miranti

<style>
h1.title {font-size: 18pt; color: DarkBlue;} 
body, h1, h2, h3, h4 {font-family: "Palatino", serif;}
body {font-size: 12pt;}
/* Headers */
h1,h2,h3,h4,h5,h6{font-size: 14pt; color: #00008B;}
body {color: #333333;}
a, a:hover {color: #8B3A62;}
pre {font-size: 12px;}
</style>

Suggested citation: Miranti, Ragdad Cani. 2020. Regional Poverty,
Convergence,and Spatial Effects: A Spatial Econometric Approach
<https://rpubs.com/canimiranti/stata_spatial_panel_514districts>

This work is licensed under the Creative Commons Attribution-Share Alike
4.0 International License. ![](License.png)

# Original data source

All data are derived from the Indonesia Central Bureau of Statistics
(Badan Pusat Statistik Republik of Indonesia). <https://www.bps.go.id/>

# Explore my non-spatial data: datapanel

In this case, data3.dta is the panel ( long data) form

``` stata
sysuse data3
```

    end of do-file

## Label the variables

``` stata
sysuse data3

label variable fips "District ID"
label variable district "District name"
label variable pov " Poverty Rate"
label variable gap " Poverty Gap Index"
label variable sev " Poverty Severity Index"
label variable agr " Total GRDP of Agriculture sector at district-i"
label variable ind "Total GRDP of Industry sector at district-i"
label variable gpov "Growth of Poverty Rate"
label variable gsev "Growth of Poverty Severity Index"
label variable ggap "Growth of Poverty Gap Index"
label variable mys "Mean Year School"
label variable shr_agr "Share of Agricultural sector to total GRDP"
label variable unemp "Unemployment Rate"
label variable gdpgr "Economic growth"
label variable shr_ind "Share of industry sector to total GRDP"
label variable subs_rice "Percentage of poor purchase subsidized rice"
label variable inv_shr "Share of Public investment to GDP"
label variable gdi "Gender Development Index"
describe
summarize
```

    Contains data from ./data3.dta
      obs:         4,626                          
     vars:            27                          27 Jan 2021 09:42
     size:       670,770                          
    -------------------------------------------------------------------------------------------------------------------------------------
                  storage   display    value
    variable name   type    format     label      variable label
    -------------------------------------------------------------------------------------------------------------------------------------
    fips            int     %8.0g                 District ID
    year            int     %8.0g                 
    district        str26   %26s                  District name
    service         float   %9.0g                 
    pov             float   %9.0g                  Poverty Rate
    gap             float   %9.0g                  Poverty Gap Index
    sev             float   %9.0g                  Poverty Severity Index
    mys             float   %9.0g                 Mean Year School
    agr             float   %9.0g                  Total GRDP of Agriculture sector at district-i
    unemp           float   %9.0g                 Unemployment Rate
    gdpgr           float   %9.0g                 Economic growth
    inv             double  %10.0g                
    ind             float   %9.0g                 Total GRDP of Industry sector at district-i
    subs_rice       float   %9.0g                 Percentage of poor purchase subsidized rice
    gdi             float   %9.0g                 Gender Development Index
    gdp             long    %12.0g                
    island          str19   %19s                  
    gpov            float   %9.0g                 Growth of Poverty Rate
    ggap            float   %9.0g                 Growth of Poverty Gap Index
    gsev            float   %9.0g                 Growth of Poverty Severity Index
    shr_ind         float   %9.0g                 Share of industry sector to total GRDP
    shr_agr         float   %9.0g                 Share of Agricultural sector to total GRDP
    ln_pov          float   %9.0g                 
    ln_gap          float   %9.0g                 
    ln_sev          float   %9.0g                 
    inv_shr         float   %9.0g                 Share of Public investment to GDP
    ln_inv          float   %9.0g                 
    -------------------------------------------------------------------------------------------------------------------------------------
    Sorted by: 
    
        Variable |        Obs        Mean    Std. Dev.       Min        Max
    -------------+---------------------------------------------------------
            fips |      4,626    4574.257    2678.595       1101       9471
            year |      4,626        2014    2.582268       2010       2018
        district |          0
         service |      4,626    6.614797    9.538464          0      64.74
             pov |      4,626    14.22667    8.705273       1.67      49.58
    -------------+---------------------------------------------------------
             gap |      4,626    2.374658    2.300813        .05      19.16
             sev |      4,626    .7474189      .97928        .01      10.15
             mys |      4,626    7.645441    1.717653        .25       12.6
             agr |      4,626     2863.28    3989.058      23.53      62445
           unemp |      4,626    5.343531    3.081055          0      19.84
    -------------+---------------------------------------------------------
           gdpgr |      4,626    5.997218    2.943957     -14.49     107.07
             inv |      4,626    1.59e+09    1.37e+10     407000   2.22e+11
             ind |      4,626    4914.623    15559.28          0   238957.1
       subs_rice |      4,626    57.89956    25.12048          0   116.5955
             gdi |      4,626    88.12807    7.235699       24.1      99.75
    -------------+---------------------------------------------------------
             gdp |      4,626    2.09e+07    3.64e+07     174740   3.65e+08
          island |          0
            gpov |      4,626   -.0517686    .0535961  -.3567133   .1496517
            ggap |      4,626   -.0500954    .2633248  -1.241657   1.161183
            gsev |      4,626   -.0745803    .3329664  -1.778151   1.342423
    -------------+---------------------------------------------------------
         shr_ind |      4,626    6.462646    10.54983          0      88.27
         shr_agr |      4,626    6.618044    6.446088        .01      51.65
          ln_pov |      4,626    2.483652    .5925594   .5128236   3.903588
          ln_gap |      4,626    .5225219    .8400528  -2.995732   2.952825
          ln_sev |      4,626   -.7647654    .9530818   -4.60517   2.317474
    -------------+---------------------------------------------------------
         inv_shr |      4,626    .3126588    4.260859   .0000299   149.0742
          ln_inv |      4,626    19.24801    .9199063   12.91657   26.12594

\#\#save myPANEL data

``` stata

sysuse data3
save, replace
```

    file ./data3.dta saved

# Explore my Map

Import and translate to stata shapa file

``` stata
spshape2dta INDO_KAB_2016, replace

* NOTE:  Two stata files will be created
* INDO_KAB_2016_shp.dta
* INDO_KAB_2016.dta

*Explore my spatial data: myMAP
use INDO_KAB_2016

*Describe and summarize myMAP.dta
describe
summarize


*Generate new spatial-unit id: fips
destring IDKAB, generate(fips)

save, replace

*Change the spatial-unit id from _ID to fips
spset fips, modify replace

*Modify the coordinate system from planar to latlong
spset, modify coordsys(latlong, miles)

*Check spatial ID and coordinate system
spset
```

``` 
  (importing .dbf file)
  (creating _ID spatial-unit id)
  (creating _CX coordinate)
  (creating _CY coordinate)

  file INDO_KAB_2016_shp.dta created
  file INDO_KAB_2016.dta     created



Contains data from INDO_KAB_2016.dta
  obs:           522                          
 vars:            12                          10 Feb 2021 11:45
 size:        52,722                          
-------------------------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
-------------------------------------------------------------------------------------------------------------------------------------
_ID             int     %12.0g                Spatial-unit ID
_CX             double  %10.0g                x-coordinate of area centroid
_CY             double  %10.0g                y-coordinate of area centroid
PROVNO          str2    %9s                   PROVNO
KABKOTNO        str2    %9s                   KABKOTNO
PROVINSI        str26   %26s                  PROVINSI
KABKOT          str26   %26s                  KABKOT
IDKAB           str4    %9s                   IDKAB
TAHUN           str4    %9s                   TAHUN
SUMBER          str3    %9s                   SUMBER
COORD_X         double  %18.7f                COORD_X
COORD_Y         double  %18.7f                COORD_Y
-------------------------------------------------------------------------------------------------------------------------------------
Sorted by: _ID

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
         _ID |        522       261.5    150.8327          1        522
         _CX |        522    113.2422    10.98185    95.3056   140.8089
         _CY |        522   -3.223506    3.866893  -10.72604   5.837818
      PROVNO |          0
    KABKOTNO |          0
-------------+---------------------------------------------------------
    PROVINSI |          0
      KABKOT |          0
       IDKAB |          0
       TAHUN |          0
      SUMBER |          0
-------------+---------------------------------------------------------
     COORD_X |        522    113.2427    10.97469   95.27568   140.7202
     COORD_Y |        522   -3.238102    3.875886  -10.69717    5.85758

IDKAB: all characters numeric; fips generated as int

file INDO_KAB_2016.dta saved

  (_shp.dta file saved)
  (data in memory saved)
  Sp dataset INDO_KAB_2016.dta
                data:  cross sectional
     spatial-unit id:  _ID (equal to fips)
         coordinates:  _CX, _CY (planar)
    linked shapefile:  INDO_KAB_2016_shp.dta

  Sp dataset INDO_KAB_2016.dta
                data:  cross sectional
     spatial-unit id:  _ID (equal to fips)
         coordinates:  _CY, _CX (latitude-and-longitude, miles)
    linked shapefile:  INDO_KAB_2016_shp.dta


  Sp dataset INDO_KAB_2016.dta
                data:  cross sectional
     spatial-unit id:  _ID (equal to fips)
         coordinates:  _CY, _CX (latitude-and-longitude, miles)
    linked shapefile:  INDO_KAB_2016_shp.dta
```

## Merge with myPANEL data : data3.dta

``` stata
sysuse data3
xtset fips year 
spbalance 
merge m:1 fips using INDO_KAB_2016
keep if _merge==3 
drop _merge
tset

**Save the merge of my map and panel data
save mymap_and_panel,replace 
```

``` 
       panel variable:  fips (strongly balanced)
        time variable:  year, 2010 to 2018
                delta:  1 unit

  (data strongly balanced)

    Result                           # of obs.
    -----------------------------------------
    not matched                             8
        from master                         0  (_merge==1)
        from using                          8  (_merge==2)

    matched                             4,626  (_merge==3)
    -----------------------------------------

(8 observations deleted)

       panel variable:  fips (strongly balanced)
        time variable:  year, 2010 to 2018
                delta:  1 unit

file mymap_and_panel.dta saved
```

# Describe the new dataset

This is my mymap\_and\_panel.dta ( the merge between MAP and panel data)

``` stata

sysuse mymap_and_panel
describe
```

    Contains data from ./mymap_and_panel.dta
      obs:         4,626                          
     vars:            39                          10 Feb 2021 11:45
     size:     1,137,996                          
    -------------------------------------------------------------------------------------------------------------------------------------
                  storage   display    value
    variable name   type    format     label      variable label
    -------------------------------------------------------------------------------------------------------------------------------------
    fips            int     %8.0g                 Spatial-unit ID
    year            int     %8.0g                 
    district        str26   %26s                  District name
    service         float   %9.0g                 
    pov             float   %9.0g                 
    gap             float   %9.0g                 
    sev             float   %9.0g                 
    mys             float   %9.0g                 Mean Year School
    agr             float   %9.0g                 
    unemp           float   %9.0g                 Unemployment Rate
    gdpgr           float   %9.0g                 Economic growth
    inv             double  %10.0g                
    ind             float   %9.0g                 
    subs_rice       float   %9.0g                 Percentage of poor receiving subsidized rice
    gdi             float   %9.0g                 Gender Development Index
    gdp             long    %12.0g                
    island          str19   %19s                  
    gpov            float   %9.0g                 Growth of Poverty Rate
    ggap            float   %9.0g                 Growth of Poverty Gap Index
    gsev            float   %9.0g                 Growth of Poverty Severity Index
    shr_ind         float   %9.0g                 Share of Manufacturing sector GRDP
    shr_agr         float   %9.0g                 Share of Agricultural sector GRDP
    ln_pov          float   %9.0g                 
    ln_gap          float   %9.0g                 
    ln_sev          float   %9.0g                 
    inv_shr         float   %9.0g                 Public investment to GDP
    ln_inv          float   %9.0g                 
    _ID             int     %10.0g                Spatial-unit ID
    _CX             double  %10.0g                x-coordinate of area centroid
    _CY             double  %10.0g                y-coordinate of area centroid
    PROVNO          str2    %9s                   PROVNO
    KABKOTNO        str2    %9s                   KABKOTNO
    PROVINSI        str26   %26s                  PROVINSI
    KABKOT          str26   %26s                  KABKOT
    IDKAB           str4    %9s                   IDKAB
    TAHUN           str4    %9s                   TAHUN
    SUMBER          str3    %9s                   SUMBER
    COORD_X         double  %18.7f                COORD_X
    COORD_Y         double  %18.7f                COORD_Y
    -------------------------------------------------------------------------------------------------------------------------------------
    Sorted by: fips  year

# Create our spatial weights matrix

To create weight matrix in panel model, firstly we must create weight
matrix in the cross-sectional (wide) data containing COORD (X) and COORD
(Y) and spatial-ID. In this case, I rename my cross-sectional data with
datacross.dta. I use inverse distance matrix as an example.

``` stata
sysuse datacross.dta
spmat idistance datacross coord_x coord_y, id(fips) normalize (row)
spmat export datacross using Wa
```

    Wa already exists
    r(498);
    
    end of do-file
    r(498);

# OLS: Non spatial model

We use similar syntax for poverty rate, poverty gap, and poverty
severity index

``` stata
**OLS Fixed Effect
sysuse mymap_and_panel

*Poverty rate
quietly xtreg gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, fe
gen speed1 = - (log(1+_b[ln_pov])/8)
gen halfLife1 = log(2)/speed1
quietly estat ic
eststo model1

*The same for poverty gap
quietly xtreg ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, fe 
gen speed2 = - (log(1+_b[ln_gap])/8)
gen halfLife2  = log(2)/speed2
quietly estat ic
eststo model2


*The same for poverty severity
quietly xtreg gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, fe
gen speed3 = - (log(1+_b[ln_sev])/8)
gen halfLife3 = log(2)/speed3
quietly estat ic
eststo model3
esttab, r2 aic bic

estimates store ols_fe
```

``` 
                      (1)             (2)             (3)   
                     gpov            ggap            gsev   
------------------------------------------------------------
ln_pov            -0.0249***                                
                 (-14.02)                                   

mys              -0.00375***      -0.0258***      -0.0381***
                  (-6.25)        (-10.81)        (-11.08)   

gdpgr           -0.000843***    0.0000283        0.000111   
                  (-3.73)          (0.03)          (0.08)   

unemp           0.0000740        0.000496        -0.00183   
                   (0.28)          (0.46)         (-1.17)   

subs_rice        0.000140***     0.000554***      0.00104***
                   (4.23)          (4.07)          (5.29)   

gdi            -0.0000637        0.000477         0.00111   
                  (-0.53)          (0.96)          (1.54)   

inv_shr         0.0000279        0.000430         0.00117   
                   (0.15)          (0.58)          (1.07)   

shr_agr          0.000400***     0.000851        -0.00214** 
                   (3.50)          (1.80)         (-3.11)   

shr_ind         -0.000389***     0.000435         0.00113** 
                  (-6.04)          (1.64)          (2.91)   

ln_gap                             -0.145***                
                                 (-28.96)                   

ln_sev                                             -0.205***
                                                 (-35.80)   

_cons              0.0407***        0.138***      -0.0834   
                   (3.49)          (3.34)         (-1.41)   
------------------------------------------------------------
N                    4626            4626            4626   
R-sq                0.060           0.175           0.247   
AIC              -17629.0         -4510.3          -999.0   
BIC              -17564.6         -4445.9          -934.6   
------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001
```

# The spatial model: SLM

In spatial panel model,there are three types of fixed-effect options:
time-fixed effect, region-fixed effect and time and region fixed-effect.
In this tutorail, I use region (district) fixed effect.

SLM stands for Spatial Lag Model using Fixed Effect with Region
(District) Fixed Effect and SAR Random Effect Model. Import our weight
matrix Wa into our panel dataset. I rename with Wi.

This syntax generates direct and indirect effects as well by adding code
‘effects’ into model.

``` stata
**SAR Fixed Effect Model 
sysuse mymap_and_panel

spmat import Wi using Wa

**Poverty rate
quietly xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) effects
gen speed4 = - (log(1+_b[ln_pov])/8)
gen halfLife4 = log(2)/speed4
quietly estat ic
eststo model4

** The same for poverty gap
quietly xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) effects
gen speed5 = - (log(1+_b[ln_gap])/8)
gen halfLife5 = log(2)/speed5
quietly estat ic
eststo model5

** The same for poverty severity
quietly xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) fe type (ind) effects
gen speed6 = - (log(1+_b[ln_sev])/8)
gen halfLife6 = log(2)/speed6
quietly estat ic
eststo model6
esttab, r2 aic bic

estimates store sar_fe


** SAR Random Effect


*Poverty rate
quietly xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) re 
gen speed7 = - (log(1+_b[ln_pov])/8)
gen halfLife7 = log(2)/speed7
quietly estat ic
eststo model7

*The same for poverty gap
quietly xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) re  
gen speed8 = - (log(1+_b[ln_gap])/8)
gen halfLife8  = log(2)/speed8
quietly estat ic
eststo model8


*The same for poverty severity
quietly  xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr  shr_agr shr_ind, wmat (Wi) model (sar) re 
gen speed9 = - (log(1+_b[ln_sev])/8)
gen halfLife9 = log(2)/speed9
quietly estat ic
eststo model9
esttab, r2 aic bic

estimates store sar_re

** Conducting Hausman Test

hausman sar_fe sar_re
```

``` 
                      (1)             (2)             (3)   
                     gpov            ggap            gsev   
------------------------------------------------------------
Main                                                        
ln_pov            -0.0249***                                
                 (-14.94)                                   

mys              -0.00375***      -0.0259***      -0.0381***
                  (-6.64)        (-11.49)        (-11.77)   

gdpgr           -0.000841***    0.0000338        0.000114   
                  (-3.96)          (0.04)          (0.09)   

unemp           0.0000732        0.000500        -0.00183   
                   (0.30)          (0.50)         (-1.24)   

subs_rice        0.000141***     0.000553***      0.00104***
                   (4.54)          (4.31)          (5.62)   

gdi            -0.0000579        0.000477         0.00111   
                  (-0.51)          (1.02)          (1.63)   

inv_shr         0.0000106        0.000428         0.00116   
                   (0.06)          (0.61)          (1.13)   

shr_agr          0.000394***     0.000852        -0.00214***
                   (3.67)          (1.92)         (-3.30)   

shr_ind         -0.000380***     0.000435         0.00113** 
                  (-6.29)          (1.74)          (3.09)   

ln_gap                             -0.145***                
                                 (-30.76)                   

ln_sev                                             -0.205***
                                                 (-38.02)   
------------------------------------------------------------
Spatial                                                     
rho                -0.449***       0.0514          0.0194   
                  (-3.97)          (0.54)          (0.20)   
------------------------------------------------------------
Variance                                                    
sigma2_e          0.00128***       0.0220***       0.0470***
                  (48.05)         (48.09)         (48.09)   
------------------------------------------------------------
LR_Direct                                                   
ln_pov            -0.0249***                                
                 (-14.54)                                   

mys              -0.00377***      -0.0259***      -0.0382***
                  (-6.91)        (-11.97)        (-12.27)   

gdpgr           -0.000821***     0.000126        0.000249   
                  (-4.04)          (0.15)          (0.20)   

unemp           0.0000754        0.000508        -0.00182   
                   (0.32)          (0.51)         (-1.26)   

subs_rice        0.000141***     0.000552***      0.00104***
                   (4.68)          (4.44)          (5.77)   

gdi            -0.0000504        0.000509         0.00116   
                  (-0.44)          (1.09)          (1.70)   

inv_shr         0.0000103        0.000427         0.00116   
                   (0.06)          (0.59)          (1.09)   

shr_agr          0.000392***     0.000840*       -0.00216***
                   (3.82)          (1.98)         (-3.49)   

shr_ind         -0.000376***     0.000457         0.00116** 
                  (-6.34)          (1.87)          (3.25)   

ln_gap                             -0.145***                
                                 (-29.91)                   

ln_sev                                             -0.205***
                                                 (-36.98)   
------------------------------------------------------------
LR_Indirect                                                 
ln_pov            0.00758***                                
                   (5.15)                                   

mys               0.00115***     -0.00181        -0.00132   
                   (4.20)         (-0.61)         (-0.32)   

gdpgr            0.000250***   0.00000391      0.00000175   
                   (3.31)          (0.03)          (0.01)   

unemp          -0.0000236       0.0000322      -0.0000696   
                  (-0.31)          (0.22)         (-0.26)   

subs_rice      -0.0000432***    0.0000377       0.0000354   
                  (-3.48)          (0.60)          (0.31)   

gdi             0.0000155       0.0000369       0.0000420   
                   (0.44)          (0.43)          (0.28)   

inv_shr       -0.00000294       0.0000287       0.0000355   
                  (-0.05)          (0.27)          (0.21)   

shr_agr         -0.000119**     0.0000610      -0.0000717   
                  (-3.17)          (0.52)         (-0.30)   

shr_ind          0.000114***    0.0000305       0.0000384   
                   (4.22)          (0.52)          (0.30)   

ln_gap                            -0.0101                   
                                  (-0.62)                   

ln_sev                                           -0.00710   
                                                  (-0.32)   
------------------------------------------------------------
LR_Total                                                    
ln_pov            -0.0173***                                
                  (-9.08)                                   

mys              -0.00262***      -0.0277***      -0.0395***
                  (-6.02)         (-7.35)         (-7.49)   

gdpgr           -0.000571***     0.000130        0.000250   
                  (-3.76)          (0.14)          (0.20)   

unemp           0.0000518        0.000540        -0.00189   
                   (0.31)          (0.51)         (-1.25)   

subs_rice       0.0000982***     0.000590***      0.00108***
                   (4.41)          (4.08)          (4.98)   

gdi            -0.0000349        0.000546         0.00120   
                  (-0.44)          (1.07)          (1.65)   

inv_shr        0.00000736        0.000456         0.00120   
                   (0.06)          (0.59)          (1.09)   

shr_agr          0.000273***     0.000901        -0.00223** 
                   (3.55)          (1.89)         (-3.27)   

shr_ind         -0.000261***     0.000487         0.00120** 
                  (-5.46)          (1.84)          (3.10)   

ln_gap                             -0.155***                
                                  (-8.83)                   

ln_sev                                             -0.212***
                                                  (-9.07)   
------------------------------------------------------------
N                    4626            4626            4626   
R-sq                0.007           0.168           0.209   
AIC              -17607.3         -4472.6          -961.1   
BIC              -17420.5         -4285.9          -774.3   
------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001


















------------------------------------------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)             (5)             (6)   
                     gpov            ggap            gsev            gpov            ggap            gsev   
------------------------------------------------------------------------------------------------------------
Main                                                                                                        
ln_pov            -0.0249***                                      -0.0201***                                
                 (-14.94)                                        (-11.97)                                   

mys              -0.00375***      -0.0259***      -0.0381***     -0.00322***      -0.0260***      -0.0387***
                  (-6.64)        (-11.49)        (-11.77)         (-5.50)        (-11.11)        (-11.64)   

gdpgr           -0.000841***    0.0000338        0.000114       -0.000952***    -0.000102        0.000161   
                  (-3.96)          (0.04)          (0.09)         (-4.29)         (-0.11)          (0.12)   

unemp           0.0000732        0.000500        -0.00183       -0.000255      -0.0000866        -0.00236   
                   (0.30)          (0.50)         (-1.24)         (-1.01)         (-0.08)         (-1.57)   

subs_rice        0.000141***     0.000553***      0.00104***    0.0000781*       0.000448***      0.00107***
                   (4.54)          (4.31)          (5.62)          (2.45)          (3.42)          (5.77)   

gdi            -0.0000579        0.000477         0.00111      -0.0000137        0.000315        0.000494   
                  (-0.51)          (1.02)          (1.63)         (-0.12)          (0.65)          (0.71)   

inv_shr         0.0000106        0.000428         0.00116      -0.0000590        0.000269        0.000619   
                   (0.06)          (0.61)          (1.13)         (-0.34)          (0.38)          (0.60)   

shr_agr          0.000394***     0.000852        -0.00214***     0.000400***     0.000526        -0.00271***
                   (3.67)          (1.92)         (-3.30)          (3.59)          (1.14)         (-4.08)   

shr_ind         -0.000380***     0.000435         0.00113**     -0.000381***     0.000420         0.00116** 
                  (-6.29)          (1.74)          (3.09)         (-5.95)          (1.59)          (3.02)   

ln_gap                             -0.145***                                       -0.143***                
                                 (-30.76)                                        (-30.54)                   

ln_sev                                             -0.205***                                       -0.198***
                                                 (-38.02)                                        (-37.17)   

_cons                                                              0.0499***        0.197***      0.00518   
                                                                   (4.10)          (4.80)          (0.09)   
------------------------------------------------------------------------------------------------------------
Spatial                                                                                                     
rho                -0.449***       0.0514          0.0194           0.440***        0.560***        0.245** 
                  (-3.97)          (0.54)          (0.20)          (5.37)          (8.05)          (2.75)   
------------------------------------------------------------------------------------------------------------
Variance                                                                                                    
sigma2_e          0.00128***       0.0220***       0.0470***      0.00147***       0.0248***       0.0529***
                  (48.05)         (48.09)         (48.09)         (45.05)         (45.29)         (45.29)   

lgt_theta                                                          -0.636***       -0.836***       -0.465***
                                                                 (-11.47)        (-16.98)         (-8.48)   
------------------------------------------------------------------------------------------------------------
LR_Direct                                                                                                   
ln_pov            -0.0249***                                                                                
                 (-14.54)                                                                                   

mys              -0.00377***      -0.0259***      -0.0382***                                                
                  (-6.91)        (-11.97)        (-12.27)                                                   

gdpgr           -0.000821***     0.000126        0.000249                                                   
                  (-4.04)          (0.15)          (0.20)                                                   

unemp           0.0000754        0.000508        -0.00182                                                   
                   (0.32)          (0.51)         (-1.26)                                                   

subs_rice        0.000141***     0.000552***      0.00104***                                                
                   (4.68)          (4.44)          (5.77)                                                   

gdi            -0.0000504        0.000509         0.00116                                                   
                  (-0.44)          (1.09)          (1.70)                                                   

inv_shr         0.0000103        0.000427         0.00116                                                   
                   (0.06)          (0.59)          (1.09)                                                   

shr_agr          0.000392***     0.000840*       -0.00216***                                                
                   (3.82)          (1.98)         (-3.49)                                                   

shr_ind         -0.000376***     0.000457         0.00116**                                                 
                  (-6.34)          (1.87)          (3.25)                                                   

ln_gap                             -0.145***                                                                
                                 (-29.91)                                                                   

ln_sev                                             -0.205***                                                
                                                 (-36.98)                                                   
------------------------------------------------------------------------------------------------------------
LR_Indirect                                                                                                 
ln_pov            0.00758***                                                                                
                   (5.15)                                                                                   

mys               0.00115***     -0.00181        -0.00132                                                   
                   (4.20)         (-0.61)         (-0.32)                                                   

gdpgr            0.000250***   0.00000391      0.00000175                                                   
                   (3.31)          (0.03)          (0.01)                                                   

unemp          -0.0000236       0.0000322      -0.0000696                                                   
                  (-0.31)          (0.22)         (-0.26)                                                   

subs_rice      -0.0000432***    0.0000377       0.0000354                                                   
                  (-3.48)          (0.60)          (0.31)                                                   

gdi             0.0000155       0.0000369       0.0000420                                                   
                   (0.44)          (0.43)          (0.28)                                                   

inv_shr       -0.00000294       0.0000287       0.0000355                                                   
                  (-0.05)          (0.27)          (0.21)                                                   

shr_agr         -0.000119**     0.0000610      -0.0000717                                                   
                  (-3.17)          (0.52)         (-0.30)                                                   

shr_ind          0.000114***    0.0000305       0.0000384                                                   
                   (4.22)          (0.52)          (0.30)                                                   

ln_gap                            -0.0101                                                                   
                                  (-0.62)                                                                   

ln_sev                                           -0.00710                                                   
                                                  (-0.32)                                                   
------------------------------------------------------------------------------------------------------------
LR_Total                                                                                                    
ln_pov            -0.0173***                                                                                
                  (-9.08)                                                                                   

mys              -0.00262***      -0.0277***      -0.0395***                                                
                  (-6.02)         (-7.35)         (-7.49)                                                   

gdpgr           -0.000571***     0.000130        0.000250                                                   
                  (-3.76)          (0.14)          (0.20)                                                   

unemp           0.0000518        0.000540        -0.00189                                                   
                   (0.31)          (0.51)         (-1.25)                                                   

subs_rice       0.0000982***     0.000590***      0.00108***                                                
                   (4.41)          (4.08)          (4.98)                                                   

gdi            -0.0000349        0.000546         0.00120                                                   
                  (-0.44)          (1.07)          (1.65)                                                   

inv_shr        0.00000736        0.000456         0.00120                                                   
                   (0.06)          (0.59)          (1.09)                                                   

shr_agr          0.000273***     0.000901        -0.00223**                                                 
                   (3.55)          (1.89)         (-3.27)                                                   

shr_ind         -0.000261***     0.000487         0.00120**                                                 
                  (-5.46)          (1.84)          (3.10)                                                   

ln_gap                             -0.155***                                                                
                                  (-8.83)                                                                   

ln_sev                                             -0.212***                                                
                                                  (-9.07)                                                   
------------------------------------------------------------------------------------------------------------
N                    4626            4626            4626            4626            4626            4626   
R-sq                0.007           0.168           0.209           0.014           0.188           0.212   
AIC              -17607.3         -4472.6          -961.1        -15923.9         -2696.8           542.1   
BIC              -17420.5         -4285.9          -774.3        -15840.1         -2613.1           625.8   
------------------------------------------------------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

                 ---- Coefficients ----
             |      (b)          (B)            (b-B)     sqrt(diag(V_b-V_B))
             |     sar_fe       sar_re       Difference          S.E.
-------------+----------------------------------------------------------------
      ln_sev |   -.2054804    -.1976194        -.007861        .0009758
         mys |   -.0380943    -.0386616        .0005673               .
       gdpgr |    .0001138     .0001607       -.0000469               .
       unemp |   -.0018342    -.0023628        .0005286               .
   subs_rice |     .001043      .001069        -.000026        9.42e-06
         gdi |    .0011141     .0004944        .0006197               .
     inv_shr |    .0011612     .0006186        .0005426        .0000556
     shr_agr |   -.0021405    -.0027115         .000571               .
     shr_ind |    .0011279     .0011587       -.0000308               .
------------------------------------------------------------------------------
                           b = consistent under Ho and Ha; obtained from xsmle
            B = inconsistent under Ha, efficient under Ho; obtained from xsmle

    Test:  Ho:  difference in coefficients not systematic

                  chi2(9) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =      133.24
                Prob>chi2 =      0.0000
                (V_b-V_B is not positive definite)
```

# The spatial model: SEM

SLM stands for Spatial Error Model using Fixed Effect with Region
(District) Fixed Effect. Import our weight matrix Wa into our panel
dataset. In the SEM mode, the direct and indirect effects can not be
generated.

``` stata
*SEM Fixed Effect Model 
sysuse mymap_and_panel

spmat import Wi using Wa

**Poverty rate
quietly xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, emat (Wi) model (sem) fe type (ind)
gen speed10 = - (log(1+_b[ln_pov])/8)
gen halfLife10 = log(2)/speed10
quietly estat ic
eststo model10


**The same for poverty gap
quietly xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, emat (Wi) model (sem) fe type (ind) effects
gen speed11 = - (log(1+_b[ln_gap])/8)
gen halfLife11 = log(2)/speed11
quietly estat ic
eststo model11

**The same for poverty severity
quietly xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, emat (Wi) model (sem) fe type (ind) effects
gen speed12 = - (log(1+_b[ln_sev])/8)
gen halfLife12 = log(2)/speed12
quietly estat ic
eststo model12
esttab, r2 aic bic

estimates store sem_fe
```

``` 
                      (1)             (2)             (3)   
                     gpov            ggap            gsev   
------------------------------------------------------------
Main                                                        
ln_pov            -0.0249***                                
                 (-14.97)                                   

mys              -0.00372***      -0.0259***      -0.0382***
                  (-6.60)        (-11.50)        (-11.80)   

gdpgr           -0.000841***    0.0000369        0.000124   
                  (-3.96)          (0.04)          (0.10)   

unemp           0.0000787        0.000499        -0.00188   
                   (0.32)          (0.49)         (-1.27)   

subs_rice        0.000143***     0.000552***      0.00105***
                   (4.62)          (4.30)          (5.64)   

gdi            -0.0000560        0.000486         0.00114   
                  (-0.50)          (1.04)          (1.66)   

inv_shr         0.0000114        0.000409         0.00111   
                   (0.07)          (0.58)          (1.07)   

shr_agr          0.000394***     0.000845        -0.00216***
                   (3.68)          (1.90)         (-3.33)   

shr_ind         -0.000372***     0.000436         0.00113** 
                  (-6.14)          (1.74)          (3.11)   

ln_gap                             -0.145***                
                                 (-30.76)                   

ln_sev                                             -0.206***
                                                 (-38.04)   
------------------------------------------------------------
Spatial                                                     
lambda             -0.439***       0.0681          0.0905   
                  (-3.80)          (0.68)          (0.88)   
------------------------------------------------------------
Variance                                                    
sigma2_e          0.00128***       0.0220***       0.0470***
                  (48.05)         (48.09)         (48.09)   
------------------------------------------------------------
N                    4626            4626            4626   
R-sq                0.007           0.167           0.209   
AIC              -17641.9         -4508.8          -997.8   
BIC              -17571.1         -4437.9          -927.0   
------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001
```

# The spatial model: SAC

SAC stands for Spatial Autoregressive Combined using Fixed Effect with
Region (District) Import our weight matrix Wa into our panel dataset

``` stata
*SAC Fixed Effect Model 
sysuse mymap_and_panel

spmat import Wi using Wa

**Poverty rate
quietly xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) emat (Wi) model (sac) fe type (ind) effects
gen speed13 = - (log(1+_b[ln_pov])/8)
gen halfLife13 = log(2)/speed13
quietly estat ic
eststo model13


**The same for poverty gap
quietly xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) emat (Wi) model (sac) fe type (ind) effects
gen speed14 = - (log(1+_b[ln_gap])/8)
gen halfLife14 = log(2)/speed14
quietly estat ic
eststo model14

**The same for poverty severity
quietly xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) emat (Wi) model (sac) fe type (ind) effects
gen speed15 = - (log(1+_b[ln_sev])/8)
gen halfLife15 = log(2)/speed15
quietly estat ic
eststo model15
esttab, r2 aic bic

estimates store sac_fe
```

``` 
                      (1)             (2)             (3)   
                     gpov            ggap            gsev   
------------------------------------------------------------
Main                                                        
ln_pov            -0.0249***                                
                 (-14.91)                                   

mys              -0.00375***      -0.0260***      -0.0384***
                  (-6.64)        (-11.50)        (-11.87)   

gdpgr           -0.000841***    0.0000382        0.000113   
                  (-3.96)          (0.04)          (0.09)   

unemp           0.0000728        0.000495        -0.00195   
                   (0.30)          (0.49)         (-1.32)   

subs_rice        0.000141***     0.000551***      0.00105***
                   (4.52)          (4.29)          (5.67)   

gdi            -0.0000581        0.000497         0.00118   
                  (-0.51)          (1.06)          (1.73)   

inv_shr         0.0000110        0.000385         0.00106   
                   (0.06)          (0.53)          (0.99)   

shr_agr          0.000394***     0.000835        -0.00219***
                   (3.68)          (1.88)         (-3.37)   

shr_ind         -0.000381***     0.000436         0.00114** 
                  (-6.27)          (1.75)          (3.13)   

ln_gap                             -0.145***                
                                 (-30.72)                   

ln_sev                                             -0.205***
                                                 (-37.97)   
------------------------------------------------------------
Spatial                                                     
rho                -0.483         -0.0949          -0.232   
                  (-1.25)         (-0.31)         (-1.15)   

lambda             0.0320           0.157           0.285   
                   (0.09)          (0.53)          (1.55)   
------------------------------------------------------------
Variance                                                    
sigma2_e          0.00144***       0.0247***       0.0527***
                  (53.31)         (53.95)         (53.84)   
------------------------------------------------------------
LR_Direct                                                   
ln_pov            -0.0249***                                
                 (-14.55)                                   

mys              -0.00377***      -0.0261***      -0.0385***
                  (-6.91)        (-11.98)        (-12.36)   

gdpgr           -0.000821***     0.000131        0.000248   
                  (-4.04)          (0.16)          (0.20)   

unemp           0.0000751        0.000503        -0.00193   
                   (0.31)          (0.51)         (-1.34)   

subs_rice        0.000141***     0.000551***      0.00105***
                   (4.66)          (4.42)          (5.82)   

gdi            -0.0000506        0.000530         0.00123   
                  (-0.45)          (1.13)          (1.80)   

inv_shr         0.0000107        0.000384         0.00105   
                   (0.06)          (0.51)          (0.96)   

shr_agr          0.000392***     0.000824        -0.00221***
                   (3.82)          (1.93)         (-3.56)   

shr_ind         -0.000377***     0.000458         0.00117***
                  (-6.31)          (1.88)          (3.29)   

ln_gap                             -0.145***                
                                 (-29.88)                   

ln_sev                                             -0.205***
                                                 (-37.10)   
------------------------------------------------------------
LR_Indirect                                                 
ln_pov            0.00633                                   
                   (0.92)                                   

mys              0.000966       -0.000740         0.00617   
                   (0.91)         (-0.06)          (1.02)   

gdpgr            0.000209     -0.00000270      -0.0000479   
                   (0.93)         (-0.01)         (-0.17)   

unemp          -0.0000191       0.0000103        0.000308   
                  (-0.18)          (0.02)          (0.69)   

subs_rice      -0.0000358       0.0000171       -0.000169   
                  (-0.86)          (0.06)         (-1.00)   

gdi             0.0000141      0.00000736       -0.000200   
                   (0.33)          (0.02)         (-0.82)   

inv_shr       -0.00000363       0.0000433       -0.000162   
                  (-0.05)          (0.11)         (-0.53)   

shr_agr        -0.0000991       0.0000474        0.000360   
                  (-0.82)          (0.09)          (0.98)   

shr_ind         0.0000971      0.00000974       -0.000190   
                   (0.91)          (0.04)         (-0.95)   

ln_gap                           -0.00455                   
                                  (-0.07)                   

ln_sev                                             0.0327   
                                                   (1.02)   
------------------------------------------------------------
LR_Total                                                    
ln_pov            -0.0186**                                 
                  (-2.60)                                   

mys              -0.00281*        -0.0268*        -0.0324***
                  (-2.51)         (-2.22)         (-4.99)   

gdpgr           -0.000613*       0.000128        0.000200   
                  (-2.24)          (0.12)          (0.19)   

unemp           0.0000560        0.000513        -0.00163   
                   (0.28)          (0.42)         (-1.28)   

subs_rice        0.000106*       0.000568        0.000882***
                   (2.20)          (1.88)          (4.03)   

gdi            -0.0000366        0.000537         0.00103   
                  (-0.41)          (0.95)          (1.68)   

inv_shr        0.00000711        0.000427        0.000893   
                   (0.05)          (0.49)          (0.94)   

shr_agr          0.000293*       0.000871        -0.00185** 
                   (2.00)          (1.23)         (-3.04)   

shr_ind         -0.000280*       0.000468        0.000981** 
                  (-2.49)          (1.41)          (2.85)   

ln_gap                             -0.150*                  
                                  (-2.21)                   

ln_sev                                             -0.173***
                                                  (-5.24)   
------------------------------------------------------------
N                    4626            4626            4626   
R-sq                0.007           0.165           0.210   
AIC              -17605.3         -4470.9          -961.1   
BIC              -17412.1         -4277.7          -767.9   
------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001
```

# The spatial model: SDM

SDM stands for Spatial Durbin Model using Fixed Effect with Region
(District) Fixed Effect and SDM Random Effect Model. Import our weight
matrix Wa into our panel dataset

``` stata
*SDM Fixed Effect Model 
sysuse mymap_and_panel

spmat import Wi using Wa

**Poverty rate
quietly xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) fe type (ind) effects
gen speed16 = - (log(1+_b[ln_pov])/8)
gen halfLife16 = log(2)/speed16
quietly estat ic
eststo model16


**The same for poverty gap
quietly xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) fe type (ind) effects
gen speed17 = - (log(1+_b[ln_gap])/8)
gen halfLife17 = log(2)/speed17
quietly estat ic
eststo model17

**The same for poverty severity
quietly xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) fe type (ind) effects
gen speed18 = - (log(1+_b[ln_sev])/8)
gen halfLife18 = log(2)/speed18
quietly estat ic
eststo model18
esttab, r2 aic bic

estimates store sdm_fe


*SDM Random Effect Model 

**Poverty rate
quietly xsmle gpov ln_pov mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) re 
gen speed19 = - (log(1+_b[ln_pov])/8)
gen halfLife19 = log(2)/speed19
quietly estat ic
eststo model19


**The same for poverty gap
quietly xsmle ggap ln_gap mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) re
gen speed20 = - (log(1+_b[ln_gap])/8)
gen halfLife20 = log(2)/speed20
quietly estat ic
eststo model20

**The same for poverty severity
quietly xsmle gsev ln_sev mys gdpgr unemp subs_rice gdi inv_shr shr_agr shr_ind, wmat (Wi) model (sdm) re
gen speed21 = - (log(1+_b[ln_sev])/8)
gen halfLife21 = log(2)/speed21
quietly estat ic
eststo model21
esttab, r2 aic bic

estimates store sdm_re

**Conducting Hausman Test

hausman sdm_fe sdm_re
```

``` 
                      (1)             (2)             (3)   
                     gpov            ggap            gsev   
------------------------------------------------------------
Main                                                        
ln_pov            -0.0250***                                
                 (-15.01)                                   

mys              -0.00370***      -0.0258***      -0.0379***
                  (-6.56)        (-11.45)        (-11.73)   

gdpgr           -0.000857***  0.000000752     -0.00000877   
                  (-4.04)          (0.00)         (-0.01)   

unemp           0.0000549        0.000516        -0.00177   
                   (0.23)          (0.51)         (-1.20)   

subs_rice        0.000135***     0.000553***      0.00106***
                   (4.33)          (4.31)          (5.71)   

gdi            -0.0000575        0.000503         0.00120   
                  (-0.51)          (1.08)          (1.77)   

inv_shr         0.0000426       0.0000264        0.000378   
                   (0.23)          (0.03)          (0.33)   

shr_agr          0.000403***     0.000853        -0.00224***
                   (3.75)          (1.92)         (-3.46)   

shr_ind         -0.000382***     0.000406         0.00110** 
                  (-6.32)          (1.62)          (3.01)   

ln_gap                             -0.146***                
                                 (-30.87)                   

ln_sev                                             -0.206***
                                                 (-38.23)   
------------------------------------------------------------
Wx                                                          
ln_pov            -0.0178                                   
                  (-0.97)                                   

mys               0.00492          0.0769**         0.134***
                   (0.73)          (2.84)          (3.42)   

gdpgr           -0.000764         -0.0108         -0.0128   
                  (-0.29)         (-1.00)         (-0.82)   

unemp            0.000302        -0.00105          0.0324*  
                   (0.11)         (-0.09)          (2.01)   

subs_rice        0.000359         0.00212        -0.00118   
                   (1.14)          (1.66)         (-0.64)   

gdi               0.00101        -0.00883         -0.0135   
                   (0.81)         (-1.71)         (-1.81)   

inv_shr        -0.0000950         0.00294         0.00517   
                  (-0.14)          (1.07)          (1.30)   

shr_agr       -0.00000770         0.00591          0.0109   
                  (-0.01)          (1.28)          (1.63)   

shr_ind           0.00182**      -0.00141        -0.00514   
                   (2.74)         (-0.51)         (-1.28)   

ln_gap                            0.00384                   
                                   (0.07)                   

ln_sev                                             0.0807   
                                                   (1.34)   
------------------------------------------------------------
Spatial                                                     
rho                -0.523***       0.0273          0.0446   
                  (-4.45)          (0.27)          (0.43)   
------------------------------------------------------------
Variance                                                    
sigma2_e          0.00128***       0.0219***       0.0467***
                  (48.03)         (48.09)         (48.09)   
------------------------------------------------------------
LR_Direct                                                   
ln_pov            -0.0249***                                
                 (-14.47)                                   

mys              -0.00375***      -0.0258***      -0.0380***
                  (-6.86)        (-11.92)        (-12.20)   

gdpgr           -0.000834***    0.0000898        0.000120   
                  (-4.10)          (0.11)          (0.10)   

unemp           0.0000563        0.000523        -0.00175   
                   (0.24)          (0.53)         (-1.21)   

subs_rice        0.000133***     0.000553***      0.00106***
                   (4.40)          (4.43)          (5.84)   

gdi            -0.0000545        0.000532         0.00124   
                  (-0.48)          (1.14)          (1.82)   

inv_shr         0.0000429       0.0000265        0.000380   
                   (0.22)          (0.03)          (0.32)   

shr_agr          0.000401***     0.000843*       -0.00226***
                   (3.90)          (1.98)         (-3.64)   

shr_ind         -0.000386***     0.000427         0.00113** 
                  (-6.51)          (1.75)          (3.16)   

ln_gap                             -0.146***                
                                 (-30.03)                   

ln_sev                                             -0.206***
                                                 (-37.23)   
------------------------------------------------------------
LR_Indirect                                                 
ln_pov           -0.00267                                   
                  (-0.22)                                   

mys               0.00447          0.0784**         0.139** 
                   (1.04)          (2.80)          (3.27)   

gdpgr          -0.0000864         -0.0104         -0.0124   
                  (-0.05)         (-0.88)         (-0.70)   

unemp            0.000112        -0.00155          0.0335*  
                   (0.06)         (-0.14)          (1.98)   

subs_rice        0.000194         0.00223        -0.00116   
                   (0.91)          (1.66)         (-0.58)   

gdi              0.000666        -0.00924         -0.0145   
                   (0.83)         (-1.77)         (-1.84)   

inv_shr        -0.0000777         0.00305         0.00550   
                  (-0.16)          (1.04)          (1.26)   

shr_agr        -0.0000972         0.00643          0.0119   
                  (-0.12)          (1.26)          (1.57)   

shr_ind           0.00133**      -0.00153        -0.00551   
                   (2.85)         (-0.51)         (-1.23)   

ln_gap                            0.00236                   
                                   (0.05)                   

ln_sev                                             0.0781   
                                                   (1.27)   
------------------------------------------------------------
LR_Total                                                    
ln_pov            -0.0276*                                  
                  (-2.31)                                   

mys              0.000720          0.0525           0.101*  
                   (0.17)          (1.87)          (2.37)   

gdpgr           -0.000920         -0.0103         -0.0123   
                  (-0.50)         (-0.86)         (-0.69)   

unemp            0.000168        -0.00102          0.0317   
                   (0.10)         (-0.09)          (1.86)   

subs_rice        0.000327         0.00278*      -0.000107   
                   (1.54)          (2.06)         (-0.05)   

gdi              0.000612        -0.00871         -0.0132   
                   (0.76)         (-1.66)         (-1.67)   

inv_shr        -0.0000348         0.00308         0.00588   
                  (-0.09)          (1.15)          (1.48)   

shr_agr          0.000303         0.00727         0.00963   
                   (0.39)          (1.41)          (1.27)   

shr_ind          0.000944*       -0.00110        -0.00438   
                   (2.01)         (-0.36)         (-0.97)   

ln_gap                             -0.143**                 
                                  (-2.81)                   

ln_sev                                             -0.128*  
                                                  (-2.08)   
------------------------------------------------------------
N                    4626            4626            4626   
R-sq                0.013           0.168           0.211   
AIC              -17610.2         -4467.9          -973.3   
BIC              -17365.5         -4223.2          -728.6   
------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001


















------------------------------------------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)             (5)             (6)   
                     gpov            ggap            gsev            gpov            ggap            gsev   
------------------------------------------------------------------------------------------------------------
Main                                                                                                        
ln_pov            -0.0250***                                      -0.0196***                                
                 (-15.01)                                        (-11.72)                                   

mys              -0.00370***      -0.0258***      -0.0379***     -0.00318***      -0.0258***      -0.0387***
                  (-6.56)        (-11.45)        (-11.73)         (-5.43)        (-11.01)        (-11.68)   

gdpgr           -0.000857***  0.000000752     -0.00000877       -0.000962***    -0.000146        0.000121   
                  (-4.04)          (0.00)         (-0.01)         (-4.35)         (-0.16)          (0.09)   

unemp           0.0000549        0.000516        -0.00177       -0.000266      -0.0000567        -0.00219   
                   (0.23)          (0.51)         (-1.20)         (-1.05)         (-0.05)         (-1.46)   

subs_rice        0.000135***     0.000553***      0.00106***    0.0000801*       0.000469***      0.00113***
                   (4.33)          (4.31)          (5.71)          (2.52)          (3.58)          (6.08)   

gdi            -0.0000575        0.000503         0.00120      -0.0000253        0.000272        0.000554   
                  (-0.51)          (1.08)          (1.77)         (-0.22)          (0.56)          (0.80)   

inv_shr         0.0000426       0.0000264        0.000378      -0.0000230       0.0000536        0.000307   
                   (0.23)          (0.03)          (0.33)         (-0.12)          (0.07)          (0.27)   

shr_agr          0.000403***     0.000853        -0.00224***     0.000370***     0.000419        -0.00291***
                   (3.75)          (1.92)         (-3.46)          (3.32)          (0.91)         (-4.37)   

shr_ind         -0.000382***     0.000406         0.00110**     -0.000353***     0.000465         0.00118** 
                  (-6.32)          (1.62)          (3.01)         (-5.50)          (1.76)          (3.07)   

ln_gap                             -0.146***                                       -0.142***                
                                 (-30.87)                                        (-30.40)                   

ln_sev                                             -0.206***                                       -0.198***
                                                 (-38.23)                                        (-37.21)   

_cons                                                              -0.254*         -0.138          0.0109   
                                                                  (-2.06)         (-0.31)          (0.02)   
------------------------------------------------------------------------------------------------------------
Wx                                                                                                          
ln_pov            -0.0178                                         0.00925                                   
                  (-0.97)                                          (0.52)                                   

mys               0.00492          0.0769**         0.134***       0.0175**         0.107***        0.158***
                   (0.73)          (2.84)          (3.42)          (2.60)          (3.86)          (4.06)   

gdpgr           -0.000764         -0.0108         -0.0128        -0.00518*        -0.0302**      -0.00997   
                  (-0.29)         (-1.00)         (-0.82)         (-1.97)         (-2.78)         (-0.65)   

unemp            0.000302        -0.00105          0.0324*       -0.00638*        -0.0212         0.00732   
                   (0.11)         (-0.09)          (2.01)         (-2.49)         (-1.96)          (0.49)   

subs_rice        0.000359         0.00212        -0.00118       -0.000959**      -0.00188        -0.00336*  
                   (1.14)          (1.66)         (-0.64)         (-3.28)         (-1.54)         (-1.98)   

gdi               0.00101        -0.00883         -0.0135         0.00279*       -0.00126         -0.0101   
                   (0.81)         (-1.71)         (-1.81)          (2.25)         (-0.24)         (-1.38)   

inv_shr        -0.0000950         0.00294         0.00517       -0.000242         0.00248         0.00226   
                  (-0.14)          (1.07)          (1.30)         (-0.36)          (0.88)          (0.56)   

shr_agr       -0.00000770         0.00591          0.0109       -0.000362         0.00506         0.00670   
                  (-0.01)          (1.28)          (1.63)         (-0.31)          (1.05)          (0.97)   

shr_ind           0.00182**      -0.00141        -0.00514         0.00182*       -0.00118        -0.00493   
                   (2.74)         (-0.51)         (-1.28)          (2.57)         (-0.41)         (-1.16)   

ln_gap                            0.00384                                         0.00522                   
                                   (0.07)                                          (0.11)                   

ln_sev                                             0.0807                                           0.158** 
                                                   (1.34)                                          (2.68)   
------------------------------------------------------------------------------------------------------------
Spatial                                                                                                     
rho                -0.523***       0.0273          0.0446           0.200*          0.430***        0.267** 
                  (-4.45)          (0.27)          (0.43)          (2.17)          (5.23)          (2.79)   
------------------------------------------------------------------------------------------------------------
Variance                                                                                                    
sigma2_e          0.00128***       0.0219***       0.0467***      0.00147***       0.0248***       0.0526***
                  (48.03)         (48.09)         (48.09)         (45.02)         (45.20)         (45.25)   

lgt_theta                                                          -0.543***       -0.781***       -0.449***
                                                                  (-9.68)        (-15.63)         (-8.10)   
------------------------------------------------------------------------------------------------------------
LR_Direct                                                                                                   
ln_pov            -0.0249***                                                                                
                 (-14.47)                                                                                   

mys              -0.00375***      -0.0258***      -0.0380***                                                
                  (-6.86)        (-11.92)        (-12.20)                                                   

gdpgr           -0.000834***    0.0000898        0.000120                                                   
                  (-4.10)          (0.11)          (0.10)                                                   

unemp           0.0000563        0.000523        -0.00175                                                   
                   (0.24)          (0.53)         (-1.21)                                                   

subs_rice        0.000133***     0.000553***      0.00106***                                                
                   (4.40)          (4.43)          (5.84)                                                   

gdi            -0.0000545        0.000532         0.00124                                                   
                  (-0.48)          (1.14)          (1.82)                                                   

inv_shr         0.0000429       0.0000265        0.000380                                                   
                   (0.22)          (0.03)          (0.32)                                                   

shr_agr          0.000401***     0.000843*       -0.00226***                                                
                   (3.90)          (1.98)         (-3.64)                                                   

shr_ind         -0.000386***     0.000427         0.00113**                                                 
                  (-6.51)          (1.75)          (3.16)                                                   

ln_gap                             -0.146***                                                                
                                 (-30.03)                                                                   

ln_sev                                             -0.206***                                                
                                                 (-37.23)                                                   
------------------------------------------------------------------------------------------------------------
LR_Indirect                                                                                                 
ln_pov           -0.00267                                                                                   
                  (-0.22)                                                                                   

mys               0.00447          0.0784**         0.139**                                                 
                   (1.04)          (2.80)          (3.27)                                                   

gdpgr          -0.0000864         -0.0104         -0.0124                                                   
                  (-0.05)         (-0.88)         (-0.70)                                                   

unemp            0.000112        -0.00155          0.0335*                                                  
                   (0.06)         (-0.14)          (1.98)                                                   

subs_rice        0.000194         0.00223        -0.00116                                                   
                   (0.91)          (1.66)         (-0.58)                                                   

gdi              0.000666        -0.00924         -0.0145                                                   
                   (0.83)         (-1.77)         (-1.84)                                                   

inv_shr        -0.0000777         0.00305         0.00550                                                   
                  (-0.16)          (1.04)          (1.26)                                                   

shr_agr        -0.0000972         0.00643          0.0119                                                   
                  (-0.12)          (1.26)          (1.57)                                                   

shr_ind           0.00133**      -0.00153        -0.00551                                                   
                   (2.85)         (-0.51)         (-1.23)                                                   

ln_gap                            0.00236                                                                   
                                   (0.05)                                                                   

ln_sev                                             0.0781                                                   
                                                   (1.27)                                                   
------------------------------------------------------------------------------------------------------------
LR_Total                                                                                                    
ln_pov            -0.0276*                                                                                  
                  (-2.31)                                                                                   

mys              0.000720          0.0525           0.101*                                                  
                   (0.17)          (1.87)          (2.37)                                                   

gdpgr           -0.000920         -0.0103         -0.0123                                                   
                  (-0.50)         (-0.86)         (-0.69)                                                   

unemp            0.000168        -0.00102          0.0317                                                   
                   (0.10)         (-0.09)          (1.86)                                                   

subs_rice        0.000327         0.00278*      -0.000107                                                   
                   (1.54)          (2.06)         (-0.05)                                                   

gdi              0.000612        -0.00871         -0.0132                                                   
                   (0.76)         (-1.66)         (-1.67)                                                   

inv_shr        -0.0000348         0.00308         0.00588                                                   
                  (-0.09)          (1.15)          (1.48)                                                   

shr_agr          0.000303         0.00727         0.00963                                                   
                   (0.39)          (1.41)          (1.27)                                                   

shr_ind          0.000944*       -0.00110        -0.00438                                                   
                   (2.01)         (-0.36)         (-0.97)                                                   

ln_gap                             -0.143**                                                                 
                                  (-2.81)                                                                   

ln_sev                                             -0.128*                                                  
                                                  (-2.08)                                                   
------------------------------------------------------------------------------------------------------------
N                    4626            4626            4626            4626            4626            4626   
R-sq                0.013           0.168           0.211           0.118           0.261           0.225   
AIC              -17610.2         -4467.9          -973.3        -15982.1         -2722.8           525.2   
BIC              -17365.5         -4223.2          -728.6        -15840.4         -2581.1           666.9   
------------------------------------------------------------------------------------------------------------
t statistics in parentheses
* p<0.05, ** p<0.01, *** p<0.001

                 ---- Coefficients ----
             |      (b)          (B)            (b-B)     sqrt(diag(V_b-V_B))
             |     sdm_fe       sdm_re       Difference          S.E.
-------------+----------------------------------------------------------------
      ln_sev |   -.2062572    -.1975043        -.008753        .0009642
         mys |   -.0379153    -.0387483         .000833               .
       gdpgr |   -8.77e-06      .000121       -.0001298               .
       unemp |   -.0017744    -.0021902        .0004158               .
   subs_rice |    .0010581     .0011287       -.0000706               .
         gdi |    .0012048     .0005539        .0006509               .
     inv_shr |    .0003783     .0003071        .0000713               .
     shr_agr |   -.0022435    -.0029054        .0006619               .
     shr_ind |    .0010984     .0011754        -.000077               .
------------------------------------------------------------------------------
                           b = consistent under Ho and Ha; obtained from xsmle
            B = inconsistent under Ha, efficient under Ho; obtained from xsmle

    Test:  Ho:  difference in coefficients not systematic

                  chi2(9) = (b-B)'[(V_b-V_B)^(-1)](b-B)
                          =       77.17
                Prob>chi2 =      0.0000
                (V_b-V_B is not positive definite)
```

# References

> Belotti, Federico and Hughes, Gordon and Piano Mortari, Andrea,
> Spatial Panel Data Models Using Stata (March 25, 2016). CEIS Working
> Paper No. 373, Available at \<<https://ssrn.com/abstract=2754703> or
> <http://dx.doi.org/10.2139/ssrn.2754703>\>

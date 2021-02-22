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

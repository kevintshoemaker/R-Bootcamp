
##################################################
####                                          ####  
####  R Bootcamp, Module 2.5                  ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################


######################################################
####  Introduction to Spatial Data Analysis in R  ####
####     Assembled by: Mitch Gritts                ####
######################################################


###################
# before starting make sure we have a clean global environment
rm(list = ls())

# install.packages(c('dplyr', 'spData', 'sf', 'raster', 'rgdal', 'rgeos', 'rcartocolor', 'magrittr', 'leaflet'))   # run this line if you haven't already installed these packages!

file_name <- 'https://kevintshoemaker.github.io/R-Bootcamp/data.zip'
download.file(file_name, destfile = 'data.zip')
unzip(zipfile = 'data.zip', exdir = '.')


# load libraries and set working directory
library(dplyr)
library(spData)
library(sf)
library(raster)
library(rgdal)
library(rgeos)
library(rcartocolor)
library(magrittr)
library(leaflet)


## a single point
pt <- st_point(c(1, 1))
plot(pt)

## multiple points 
mpt <- st_multipoint(rbind(c(0, 0), c(1, 0), c(1, 1), c(0, 1), c(0, 0)))
plot(mpt)

## a line
l <- st_linestring(rbind(c(0, 0), c(1, 0), c(1, 1), c(0, 1), c(0, 0)))
plot(l, col = 'purple')

## a polygon
poly <- st_polygon(list(rbind(c(0, 0), c(1, 0), c(1, 1), c(0, 1), c(0, 0))))
plot(poly, col = 'purple')

## ...etc, multiline and multipolygons

# create spatial points data frame ----
## load reptile data 
reptiles <- readr::read_csv('reptiles.csv')

## create a SpatialPoints object
## provide data (x), the columns that contain the x & y (coords)
## and the coordinate reference system (crs)
sf_points <- st_as_sf(x = reptiles, 
                      coords = c('x', 'y'), 
                      crs = '+init=epsg:26911')

## inspect the SpatialPoints object
str(sf_points)


# inspecting the sf object ----
## checking the projection of the sf object 
st_crs(sf_points)

## summary funciton
summary(sf_points)

## what type is the geometry column
class(sf_points$geometry)

## plot the data
plot(sf_points[0])

head(sf_points)

# subset an sf object ----
phpl <- sf_points[sf_points$species == 'Phrynosoma platyrhinos', ]
head(phpl)

## check to see that there is only one species in the data.frame
phpl %>% magrittr::extract2('species') %>% unique()

class(sf_points)

## we can filter using dplyr syntax
sf_points %>% 
  dplyr::filter(species == 'Phrynosoma platyrhinos') %>% 
  head()


## plot with sf::plot
plot(head(sf_points, n = 100))


plot(head(sf_points['year'], n = 100))

## the plot function also uses this syntax to select a single row to plot
## plot(head(sf_points['year'], n = 100))

## and if you don't want to color the plot by feature you can use 0
## to specify plotting 0 attributes
## note, this is plotting all the points
plot(sf_points[0], col = 'purple')

#############
# Nevada Counties example...

# read in nv county shapefile ----
counties <- st_read(dsn = 'data/nv_counties/NV_Admin_Counties.shp')


## once finished check the structure
str(counties, max.level = 3)

## some data management
### check the contents of the geometry field
counties$geometry

### let's double check that projection of the counties
st_crs(counties)

### How does this projection compare to the sf_points object?
### double check the sf_points projection
st_crs(sf_points)

### then explicitly compare them using boolean logic
st_crs(counties) == st_crs(sf_points)

### let's reproject the points to our desired CRS, utm
### we will go into more detail on reprojections later
counties <- st_transform(counties, st_crs(sf_points))

### double check they are equal
st_crs(counties) == st_crs(sf_points)


## check structure of a polygon within a SpatialPolygonsDataFrame
str(counties)

## check the geometry type
class(counties$geometry)

## print the first few rows for inspection
head(counties, n = 4)


## plot a spatial polygon
plot(counties)

## we don't wan't to color by any feature
## st_geometry returns just the geometry column
plot(st_geometry(counties))

## we can plot certain polygons...
## which has a plotting behavior we aren't used to
## this will plot every attribute for the first county
plot(counties[1, ])

## if we only want to include the outline, the following will work
plot(st_geometry(counties)[1])

## multiple at once
layout(matrix(1:3, ncol = 3, nrow = 1))
plot(st_geometry(counties)[1])
plot(st_geometry(counties)[1:4])
plot(st_geometry(counties)[counties$CNTYNAME == 'Clark'])


## we can even plot our reptile points ontop of the counties
layout(matrix(1))
plot(st_geometry(counties))
plot(st_geometry(sf_points), pch = 1, cex = .5, col = 'purple', add = TRUE)


# Spatial joins ----

## use the %over% funcstion, which is the same as over(spdf_points, counties)
rslt <- st_join(sf_points, counties)

## what does rslt look like?
str(rslt)

## how about summary
summary(rslt)


## what happens if you change the order of the input objects?
summary(st_join(counties, sf_points))


# unioning polygons ----
## all of these function come from the rgeos package.
## select two counties to union
plot(st_geometry(counties)[2:3])

## union them
plot(st_union(st_geometry(counties)[2:3]))

# union all interior polygons ----
## we ccan do the same thing to get a the border of NV
## the following uses the pipe (%>%) to increase code readability
nv <- counties %>% st_geometry() %>% st_union()
plot(nv)

# topological relations ----

# create a polygon
a_poly = st_polygon(list(rbind(c(-1, -1), c(1, -1), c(1, 1), c(-1, -1))))
a = st_sfc(a_poly)
# create a line
l_line = st_linestring(x = matrix(c(-1, -1, -0.5, 1), ncol = 2))
l = st_sfc(l_line)
# create points
p_matrix = matrix(c(0.5, 1, -1, 0, 0, 1, 0.5, 1), ncol = 2)
p_multi = st_multipoint(x = p_matrix)
p = st_cast(st_sfc(p_multi), "POINT")

## plot
par(pty = "s")
plot(a, border = "red", col = "gray", axes = TRUE)
plot(l, add = TRUE)
plot(p, add = TRUE, lab = 1:4)
text(p_matrix[, 1] + 0.04, p_matrix[, 2] - 0.06, 1:4, cex = 1.3)
st_within(p[1], a, sparse = F)
st_within(p[2], a, sparse = F)
st_touches(p[2], a, sparse = F)
st_intersects(p[1:2], a, sparse = F)
st_intersects(p[3:4], a, sparse = F)

# remove points outside
sparse <- st_intersects(rslt, nv)
sel_logical <- lengths(sparse) > 0

sf_points <- rslt[sel_logical, ]

## check the results by uncommenting this code, and running
# plot(nv)
# plot(st_geometry(sf_points), col = 'purple', add = T)


# spTranform ----
## we will use a data set from the spData package
## the epsg id for this data is 4269
us_states <- spData::us_states

## check the CRS
st_crs(us_states)

plot(st_geometry(us_states), 
     col = 'white',
     graticule = st_crs(us_states), 
     axes = T, main = 'Initial, EPSG = 4269')

## reproject basics, and replot
wgs_usa <- st_transform(us_states, crs = '+init=epsg:4326')
plot(st_geometry(wgs_usa), 
     col = 'white',
     graticule = st_crs(wgs_usa), 
     axes = T, main = 'WGS84')


## we can do this with other reprojections as well so you can really tell a difference
layout(matrix(1:8, nrow = 2))
us_states %>% st_geometry() %>% 
  st_transform(crs = "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs" ) %>%   
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Albers Equal Area')
us_states %>% st_geometry() %>% 
  st_transform(crs = '+proj=sinu') %>% 
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Van Der Grinten')
us_states %>% st_geometry() %>% 
  st_transform(crs = '+proj=robin') %>% 
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Robinson')
us_states %>% st_geometry() %>% 
  st_transform(crs = '+proj=gall') %>% 
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Gall-Peters')
us_states %>% st_geometry() %>% 
  st_transform(crs = '+proj=eqc') %>% 
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Plate Carree')
us_states %>% st_geometry() %>% 
  st_transform(crs = '+proj=goode') %>% 
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Goode Homolosine')
us_states %>% st_geometry() %>% 
  st_transform(crs = '+init=epsg:26911') %>% 
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'NAD83 Zone 11')
us_states %>% st_geometry() %>% 
  st_transform(crs = '+init=epsg:26921') %>% 
  plot(col = 'white', 
       graticule = st_crs(wgs_usa),
       axes = T, main = 'NAD83 Zone 21')


## we can also define our own projection
layout(matrix(1:2, nrow = 2))

us_states %>% st_geometry() %>% 
  st_transform(crs = '+proj=lcc +lat_1=20 +lat_2=60 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs') %>% 
  plot(col = 'white',
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Lambert Conformal Standard')

us_states %>% st_geometry() %>% 
  st_transform(crs = '+proj=lcc +lat_1=33 +lat_2=45 +lat_0=39 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs') %>% 
  plot(col = 'white',
       graticule = st_crs(wgs_usa),
       axes = T, main = 'Lambert Conformal USA')


# working with raster data ----
## save some data for later
save(counties, sf_points, rslt, nv, file = 'data/module2_6.RData')

## let's clean our workspace first
rm(list = ls())
load('data/module2_6.RData')

## load a raster
dem <- raster('data/nv_dem_coarse.grd')

## check dem structure
str(dem)

## what is this?
dem@data@inmemory


## plot raster
terrain_colors <- rcartocolor::carto_pal(7, 'TealRose')
plot(dem)

## or, with a new set of more aesthetic colors!
image(dem, asp = 1, col = terrain_colors)


# load a second raster, distance to roads ----
road_rast <- raster('data/road_dist.grd')

## plot
plot(road_rast, col = rcartocolor::carto_pal(7, 'Mint'))

## use the raster::projection function
projection(road_rast)
projection(dem)
identicalCRS(road_rast, dem)

## compare to nv SpatialPolygonsDataFrame
identicalCRS(dem, as(nv, 'Spatial'))

## proof these are the same crs
plot(dem, col = terrain_colors)
plot(nv, lwd = 3, add = T)


# create distance to roads ----
road_dist <- distance(road_rast, filename = "road_dist.grd", overwrite = T)

## cool, what does this look like?
plot(road_dist)
plot(nv, lwd = 3, add = T)

## mask raster to NV border. This will set all values outside NV to NA
nv_road_dist <- mask(road_dist, mask = as(nv, 'Spatial'), filename = 'nv_road_dist.grd', overwrite = T)

## plot our new raster, with nevada border
plot(nv_road_dist)
plot(nv, lwd = 3, add = T)

## compare raster values
summary(road_dist)
summary(nv_road_dist)


# raster extraction ----
## global env setup
rm(road_dist, road_rast)


## extract values from the dem
## this returns a vector of length = nrow(sf_points)
elevation <- raster::extract(dem, as(sf_points, 'Spatial'))
summary(elevation)

## this can be combined with our data
## and yes, this can be done in one step instead of 2
sf_points$elevation <- elevation


## and now, we can figure out the distribution of elevations in our data!
hist(sf_points$elevation * 3.28, main = 'Distribution of Elevation', xlab = 'Elevation (ft)', freq = T)

## what about those NAs?
na_points <- sf_points[is.na(sf_points$elevation), ]
## honestly, this 2000 number is purely experimental, 
## change values till you get what you want on the map
bounds <- extend(extent(as(na_points, 'Spatial')), 2000)

## plot the map, zoom in on these points in the map
raster::plot(dem, ext = bounds, col = terrain_colors)
plot(st_geometry(na_points), col = 'black', add = T)
plot(nv, add = T)


load("data/module2_6.RData")
wgs_pts <- sf_points[1:100, ] %>% st_transform(4326)

library(leaflet)
# interactive mapping ----
leaflet::leaflet(wgs_pts) %>% 
  addTiles() %>% 
  addCircleMarkers(radius = 5)


## leaflet provider tiles
leaflet::leaflet(wgs_pts) %>% 
  addProviderTiles(providers$Esri.WorldTopoMap) %>% 
  addCircleMarkers(radius = 5)


## and popups
leaflet::leaflet(wgs_pts) %>% 
  addTiles() %>% 
  addCircleMarkers(radius = 5, popup = paste(wgs_pts$species))


###########
# CHALLENGE PROBLEMS


# SpatialLines solution ----
## 1. read in data
### HINT: use readshapefile
### data to use:
#### data/roads/roads.shp
#### data/counties/counties.shp

## 2. reproject
### HINT: check counties projection

## 3. plot

## 4. plot roads, style based on road type 

## 5. intersect counties and roads

## 6. plot some of the intersections

## etc ...



# SpatialLines solution ----
## read data


## reproject


## plot counties

## intersect

## etc ...


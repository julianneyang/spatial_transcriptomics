## Following tutorial from: https://bookdown.org/sjcockell/ismb-tutorial-2023/practical-session-1.html#import-10x-visium-data
BiocManager::install("ggspavis")
BiocManager::install("STexampleData")

library(SpatialExperiment)
library(STexampleData)
library(ggplot2)
library(ggspavis)

# Load the object
spe <- Visium_humanDLPFC()

## Check number of features/genes (rows) and spots (columns)
dim(spe)

## Checking out the counts 
assay(spe)[20:40, 2000:2010]

## Have a look at the genes metadata
head(rowData(spe))


## Check the spatial coordinates
head(spatialCoords(spe))


## spot-level metadata
head(colData(spe))

## Have a look at the image metadata
imgData(spe)

## retrieve the image
spi <- getImg(spe)

## "plot" the image
plot(imgRaster(spi))

## Extract the spot locations
spot_coords <- spatialCoords(spe) %>% as.data.frame

## Scale by low-res factor
lowres_scale <- imgData(spe)[imgData(spe)$image_id == 'lowres', 'scaleFactor']
spot_coords$x_axis <- spot_coords$pxl_col_in_fullres * lowres_scale
spot_coords$y_axis <- spot_coords$pxl_row_in_fullres * lowres_scale

## lowres image is 600x600 pixels
dim(imgRaster(spi))

## flip the Y axis
spot_coords$y_axis <- abs(spot_coords$y_axis - (ncol(imgRaster(spi)) + 1))
points(x=spot_coords$x_axis, y=spot_coords$y_axis)

ggplot(mapping = aes(1:600, 1:600)) +
  annotation_raster(imgRaster(spi), xmin = 1, xmax = 600, ymin = 1, ymax = 600) +
  geom_point(data=spot_coords, aes(x=x_axis, y=y_axis), alpha=0.2) + xlim(1, 600) + ylim(1, 600) +
  coord_fixed() + 
  theme_void()

## Add the annotation to the coordinate data frame
spot_coords$on_tissue <- as.logical(colData(spe)$in_tissue)

ggplot(mapping = aes(1:600, 1:600)) +
  annotation_raster(imgRaster(spi), xmin = 1, xmax = 600, ymin = 1, ymax = 600) +
  geom_point(data=spot_coords, aes(x=x_axis, y=y_axis, colour=on_tissue), alpha=0.2) + xlim(1, 600) + ylim(1, 600) +
  coord_fixed() + 
  theme_void()

# Bypass all the manual stuff we did with ggspavis
plotSpots(spe, in_tissue = NULL, annotate='in_tissue')

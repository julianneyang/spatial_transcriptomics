BiocManager::install("spatialLIBD")
BiocManager::install("SpatialExperiment")
BiocManager::install("magick")
BiocManager::install("scater")

library(spatialLIBD)

#This is following instructions from: https://research.libd.org/spatialLIBD/articles/spatialLIBD.html

## Download the spot-level data
spe <- fetch_data(type = "spe")
spe
## Reproduce locally with
spatialLIBD::vis_grid_clus(spe = spe)

## Download sce data
sce_layer <- spatialLIBD::fetch_data(type = 'sce_layer')


## View our LIBD layers for one sample
vis_clus(
  spe = spe,
  clustervar = "layer_guess_reordered",
  sampleid = "151673",
  colors = libd_layer_colors,
  ... = " LIBD Layers"
)
## Connect to ExperimentHub
ehub <- ExperimentHub::ExperimentHub()
modeling_results <- fetch_data("modeling_results", eh = ehub)

## list of modeling result tables
sapply(modeling_results, class)
#>        anova   enrichment     pairwise 
#> "data.frame" "data.frame" "data.frame"
sapply(modeling_results, dim)
#>      anova enrichment pairwise
#> [1,] 22331      22331    22331
#> [2,]    10         23       65
sapply(modeling_results, function(x) {
  head(colnames(x))
})

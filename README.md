# TB NanoString: Dimension Reduction + k-means Shiny App

An interactive Shiny app that applies PCA, UMAP, or NMF (rank 2) to blood expression
of 107 TB-related genes in 179 people with active tuberculosis (TB) or latent TB
infection (LTBI) (Kaipilyawar et al., *Clin Infect Dis*, 2022), then runs k-means
clustering on the two reduced dimensions.

## Files

- `app.R`: the Shiny app
- `TBnanostring.rds`: the data (must be in the same folder as `app.R`)

## How to run

1. Download this repository (green **Code** button → **Download ZIP**) and unzip it,
   keeping `app.R` and `TBnanostring.rds` in the same folder.
2. Install the required packages in R (one time only):

   ```r
   install.packages(c("shiny", "uwot", "mclust", "BiocManager"))
   BiocManager::install("Biobase")   # needed by the NMF package
   install.packages("NMF")
   ```

3. Open `app.R` in RStudio and click **Run App**, or run `shiny::runApp()` from that folder.

The app takes about 30 seconds to start, because UMAP and NMF are computed once at launch.

## Features

- Choose the dimension reduction method (PCA, UMAP, or NMF) and the number of clusters k
- Scatterplot of the two reduced dimensions, colored by k-means cluster and shaped by TB status, with cluster centers marked by X
- Cross-table of clusters vs. TB status and the adjusted Rand index

library(tidyverse)
library(devtools)
# install_github("jokergoo/ComplexHeatmap")
library(ComplexHeatmap)

dat <- read_csv("data-many-analysts/master_data_Charles_euc.csv") 

colnames(dat) |> head()

# let's try with the raw data

# divide it up into annotation and matrix

# first five columns contain annotation info
anno <- dat |> select(id_col)

# convert the covariates used to a matrix
mat <- as.matrix(dat[, c(3,6:ncol(dat))])

rownames(mat) <- anno$id_col
colnames(mat) <- colnames(dat)[c(3,6:ncol(dat))]

# make the heatmap of analyses by columns
Heatmap(mat) |> print()

dat |> pull(link_function_reported) |> unique()

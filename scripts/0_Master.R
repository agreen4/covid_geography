library(pacman)
p_load(corrplot, factoextra, FactoMineR, readr, tidycensus, tidyverse, tigris, sf)

census_api_key("3e50904445914dd0fd03025e7d222c5f097016c0")
DL_Year<-2018
survey <- "acs5"
geo<-"tract"

state<-fips_codes %>% select(state_code, state_name) %>% distinct() %>% filter(!state_code %in% c(60, 66, 69, 72, 74, 78)) %>% select(state_code)

if(!exists("data/acs_covars.rds")){
  source("scripts/01_get_acs.R") 
}
if(exists("data/acs_covars.rds")){
acs_covars<-  read_rds("data/acs_covars.rds")
}


# Visualize the tract data and the place geography which will be extracted
ggplot()+geom_sf(data=place_geo)
#ggplot()+geom_sf(data=trt)

# Extract tracts for the place

dataset<-st_filter(trt, place_geo)
ggplot()+geom_sf(data=dataset)

dataset_to_pca<-dataset %>% select(under18:P_Female, P_FHHH:PCI)
st_geometry(dataset_to_pca)<-NULL

tracts.pca <- PCA(dataset_to_pca, graph = TRUE)
print(tracts.pca)

tractseig.val
tractseig.val <- get_eigenvalue(tracts.pca)
fviz_eig(tracts.pca, addlabels = TRUE, ylim = c(0, 50))

get_pca_var(tracts.pca)
fviz_pca_var(tracts.pca, col.var = "black")

tractvars <- get_pca_var(tracts.pca)
corrplot(tractvars$cos2, is.corr=FALSE)

fviz_contrib(tracts.pca, choice = "var", axes = 1, top = 10)
fviz_contrib(tracts.pca, choice = "var", axes = 2, top = 10)
fviz_contrib(tracts.pca, choice = "var", axes = 3, top = 10)
fviz_contrib(tracts.pca, choice = "var", axes = 4, top = 10)
fviz_contrib(tracts.pca, choice = "var", axes = 5, top = 10)

#total contribution to all PCs, red line is the expected average contribution
fviz_contrib(tracts.pca, choice = "var", axes = 1:2, top = 10)
fviz_contrib(tracts.pca, choice = "var", axes = 1:5, top = 10)

#highlighting most contributing variables on correlation plot 
fviz_pca_var(tracts.pca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)

tracts_hcpc<-HCPC(tracts.pca, nb.clust = -1, graph = TRUE)
fviz_dend(tracts_hcpc, cex = 0.7, palette = "jco", rect = TRUE, rect_fill = TRUE, rect_border = "jco", labels_track_height = 0.8)
fviz_cluster(tracts_hcpc, repel = TRUE, show.clust.cent = TRUE, palette = "jco", ggtheme = theme_minimal(), main = "Factor map")

dataset_clusters<-tracts_hcpc$data.clust
cluster_characteristics<-dataset_clusters %>% group_by(clust) %>% summarise_all(funs(mean))
write_csv(cluster_characteristics, file.path(paste0("output/", state,"_",place,"_cluster_char.csv")))


dataset<-bind_cols(dataset, dataset_clusters %>% select(clust))

#eviction <- read_csv("data/tracts.csv", col_types = cols(GEOID = col_character())) %>% filter(year == 2016) %>% select(GEOID, `eviction-filings`, evictions, `eviction-filing-rate`, `eviction-rate`)

eviction<-read_csv(paste0("https://eviction-lab-data-downloads.s3.amazonaws.com/", state, "/tracts.csv"), col_types = cols(GEOID = col_character())) %>% filter(year == 2016) %>% select(GEOID, `eviction-filings`, evictions, `eviction-filing-rate`, `eviction-rate`)
dataset<-left_join(dataset, eviction, by="GEOID")
saveRDS(dataset, paste0("output/",state, "_", place, "_clusters.rds"))
# Map Clusters
ggplot()+geom_sf(data=dataset, aes(fill=clust))
ggsave(paste0(state, "_", place, "_TractClusterMap.png"), device="png", path="output", dpi=600)

# Cluster Racial and Eviction characteristics
Race_Characteristics<-dataset %>% group_by(clust) %>% summarise_at(vars(PWhite:PForeignborn, `eviction-filing-rate`, `eviction-rate`), funs(mean(., na.rm=TRUE)))
st_geometry(Race_Characteristics)<-NULL
write_csv(Race_Characteristics, file.path(paste0("output/", state,"_",place,"_race_char.csv")))

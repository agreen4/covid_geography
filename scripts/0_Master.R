library(pacman)
p_load(corrplot, factoextra, FactoMineR, purrr, readr, sf, tidyverse, tidycensus, tigris)

census_api_key("3e50904445914dd0fd03025e7d222c5f097016c0")
DL_Year<-2018
survey <- "acs5"
geo<-"tract"
state<-fips_codes %>% select(state_code, state_name) %>% 
  distinct() %>% 
  filter(!state_name %in% c("American Samoa", "Guam", "Northern Mariana Islands", "Puerto Rico", "U.S. Minor Outlying Islands", "U.S. Virgin Islands")) %>% 
  select(state_code)







#Download Eviction Lab Data
#https://evictionlab.org/eviction-tracking/get-the-data/
#Need to check date to download most up to date file.

eviction_lab_data<-read_csv("https://evictionlab.org/uploads/all_sites_20201121.csv")

eviction_lab_tracts<-eviction_lab_data %>% 
  dplyr::select(GEOID, city, type) %>% 
  distinct()%>% 
  filter(GEOID != "sealed", type == "Census Tract")

state<-eviction_lab_tracts %>% 
  filter(type == "Census Tract") %>% 
  mutate(GEOID = substr(GEOID, 0, 2)) %>% 
  dplyr::select(GEOID) %>% 
  distinct() %>% 
  filter(GEOID != "se")

# Manually get census tracts associated with Eviction Lab places
# if(!file.exists("data/eviction_lab_tracts.rds")){
#   source("scripts/Place_Geography.R")
# } else {
#   eviction_lab_tracts<-read_rds("data/eviction_lab_tracts.rds")
# }
# 
# state<- eviction_lab_tracts %>% 
#   st_set_geometry(NULL) %>% 
#   select(GEOID) %>% 
#   mutate(GEOID = substr(GEOID, 0,2)) %>% 
#   distinct()

# Get ACS covariates
if(!file.exists("data/acs_covars.rds")){
  source("scripts/01_get_acs.R") 
} else {
acs_covars<- read_rds("data/acs_covars.rds")
}

#Join to select Eviction Lab Tracts

dataset_tract<-left_join(eviction_lab_tracts, acs_covars, by="GEOID")
#saveRDS(dataset_tract, "data/dataset_tract.rds")

#Remove tracts with no population and select variables to cluster
dataset_cluster<-dataset_tract %>% 
  filter(pop_tot > 0) %>% 
  dplyr::select(GEOID, city, under18, over65, PNH_White, PNH_Black, PNH_Asian, PNH_Other, PLatino, PForeignborn, P_FHHH, Pov, MHHI, Rvac, P_Rent, MHV, OCB, RCB, MGR, ServOccup, Mobility, Commute, PCI, P_NoCar, conman, food, health, protection, socialservices, transport)

# Perform single imputation based upon variables with no missing values
dataset_cluster %>% summarise_all(funs(sum(is.na(.))))
dataset_cluster<-dataset_cluster %>% 
  group_by(city) %>% 
  impute_lm(P_FHHH+Pov+MHHI+Rvac+P_Rent+MHV+OCB+RCB+MGR+ServOccup+Commute+PCI+P_NoCar+conman + food + health + protection + socialservices + transport ~ under18+over65+PNH_White+PNH_Black+PNH_Asian+PLatino+PForeignborn+Mobility)
dataset_cluster %>% 
  ungroup()%>% 
  summarise_all(funs(sum(is.na(.))))

dataset_cluster %>% 
  group_by(city) %>% 
  summarise_if(is.numeric, mean, na.rm=TRUE) %>% 
  dplyr::select(city, under18, over65, PForeignborn, P_FHHH, Pov, MHHI, Rvac, P_Rent, MHV, OCB, RCB, MGR, ServOccup, Mobility, Commute, PCI, P_NoCar, conman, food, health, protection, socialservices, transport) %>% 
  View()

#Scale the data for PCA
dataset_cluster_pca<-dataset_cluster %>% 
  dplyr::select(city, under18, over65, PForeignborn, P_FHHH, Pov, MHHI, Rvac, P_Rent, MHV, OCB, RCB, MGR, ServOccup, Mobility, Commute, PCI, P_NoCar, conman, food, health, protection, socialservices, transport) %>% 
  group_by(city)%>% 
  mutate(across(under18:transport,scale)) %>% 
  ungroup() %>% 
  dplyr::select(-city)


# # Visualize the tract data and the place geography which will be extracted
# ggplot()+geom_sf(data=place_geo)
# #ggplot()+geom_sf(data=trt)
# 
# # Extract tracts for the place
# 
# dataset<-st_filter(trt, place_geo)
# ggplot()+geom_sf(data=dataset)

tracts.pca <- PCA(dataset_cluster, scale=TRUE, quali.sup=c(1:2), graph = FALSE)
plot.PCA(tracts.pca, axes=c(1, 2), choix="var")
fviz_nbclust(dataset_cluster_pca, kmeans, method = "gap_stat", nboot=50)
fviz_nbclust(dataset_cluster_pca, kmeans, method = "wss")
fviz_nbclust(dataset_cluster_pca, kmeans, method = "silhouette")
test<-NbClust::NbClust(data=tractvars, distance = "euclidean", method = "Ward")

p_load(NbClust)

p_load(FactoInvestigate)
Investigate(tracts.pca)
dimdesc(tracts.pca)

#print(tracts.pca)

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

tracts_hcpc<-HCPC(tracts.pca, graph = FALSE)
tracts_hcpc$desc.var$quanti
tracts_hcpc$desc.axes$quanti

fviz_dend(tracts_hcpc, cex = 0.7, palette = "jco", rect = TRUE, rect_fill = TRUE, rect_border = "jco", labels_track_height = 0.8)
fviz_cluster(tracts_hcpc, repel = TRUE, show.clust.cent = TRUE, palette = "jco", ggtheme = theme_minimal(), main = "Factor map")

dataset_clusters<-tracts_hcpc$data.clust
cluster_characteristics<-dataset_clusters %>% group_by(clust) %>% summarise_all(funs(mean))
#write_csv(cluster_characteristics, file.path(paste0("output/", state,"_",place,"_cluster_char.csv")))


dataset_cluster_s<-bind_cols(dataset_cluster_s, dataset_clusters %>% 
                               dplyr::select(clust))

dataset_cluster<-bind_cols(dataset_cluster, dataset_clusters %>% dplyr::select(clust))
dataset_cluster %>% 
  group_by(clust) %>% 
  summarise(N = n(), across(under18:essential, mean, na.rm=TRUE)) %>% 
  View()

dataset_cluster %>% 
  group_by(city, clust) %>% 
  summarise(N = n(), across(under18:essential, mean, na.rm=TRUE)) %>% 
  View()







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

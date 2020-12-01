library(pacman)
p_load(sf, tidyverse, tigris)
options(tigris_use_cache = TRUE)

eviction_lab_states<-c("TX", "MA", "CT", "SC", "OH", "OH", "OH", "TX", "FL", "SC", "CT", "TX", "IN", "FL", "MO", "TN", "WI", "AZ", "PA", "VA", "IN", "MO", "FL", "DE", "PA")
eviction_lab_places<-c("Austin", "Boston", "Bridgeport", "Charleston", "Cincinnati", "Cleveland", "Columbus", "Fort Worth", "Gainesville", "Greenville", "Hartford", "Houston", "Indianapolis city (balance)", "Jacksonville", "Kansas City", "Memphis", "Milwaukee", "Phoenix", "Pittsburgh", "Richmond", "South Bend", "St. Louis", "Tampa", "Wilmington", "Philadelphia")
eviction_lab_place_names<-bind_cols(eviction_lab_places, eviction_lab_states) %>% set_names(c("place_name", "state_name"))
eviction_lab_place_names<-left_join(eviction_lab_place_names, fips_codes %>% select(state, state_code) %>% distinct(), by = c("state_name" = "state"))
rm(eviction_lab_states, eviction_lab_places)

get_tracts_place<-function(state_code, place_name){
  trt<-tracts(state=state_code, class="sf") %>% 
    mutate(trt_area = st_area(.)) %>% 
    select(GEOID, trt_area)
  plc<-places(state=state_code, class="sf") %>% 
    select(NAME)
  plc<-plc %>% filter(NAME %in% place_name)
  plc_trt<-trt %>% st_intersection(plc) %>% 
    mutate(frag_area = st_area(.)) %>% 
    filter(as.numeric(frag_area) > 0)
  return(plc_trt)
}

eviction_lab_tracts<-reduce(map2(eviction_lab_place_names$state_code, eviction_lab_place_names$place_name, function(state_code, place_name){
  get_tracts_place(state_code, place_name)
}),
rbind
)

eviction_lab_tracts<-eviction_lab_tracts %>% 
  mutate(NAME = case_when(
    NAME == "Indianapolis city (balance)" ~ "Indianapolis",
    TRUE ~ as.character(NAME)
  ))

saveRDS(eviction_lab_tracts, "data/eviction_lab_tracts.rds")

rm(eviction_lab_place_names, get_tracts_place)

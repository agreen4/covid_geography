library(pacman)
p_load(purrr, tidycensus, tidyverse)

get_vars<-function(y){
  reduce(map(state, function(x){
    get_acs(geography = geo, state = x, variables = y, cache_table = TRUE, survey = survey, year = DL_Year, output = "wide")
  }),
  rbind
  ) 
}

#B01001: Age, Population ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_14_5YR_B01001&prodType=table

B01001_Vars<-c("B01001_001",
               "B01001_002",
               "B01001_003",
               "B01001_004",
               "B01001_005",
               "B01001_006",
               "B01001_020",
               "B01001_021",
               "B01001_022",
               "B01001_023",
               "B01001_024",
               "B01001_025",
               "B01001_027",
               "B01001_028",
               "B01001_029",
               "B01001_030",
               "B01001_044",
               "B01001_045",
               "B01001_046",
               "B01001_047",
               "B01001_048",
               "B01001_049")

B01001 <-get_vars(B01001_Vars)
B01001$pop_tot<-B01001$B01001_001E

B01001$under18<-(B01001$B01001_003E
                 +B01001$B01001_004E
                 +B01001$B01001_005E
                 +B01001$B01001_006E
                 +B01001$B01001_027E
                 +B01001$B01001_028E
                 +B01001$B01001_029E
                 +B01001$B01001_030E)/B01001$B01001_001E

B01001$over65<-(B01001$B01001_020E
                +B01001$B01001_021E
                +B01001$B01001_022E
                +B01001$B01001_023E
                +B01001$B01001_024E
                +B01001$B01001_025E
                +B01001$B01001_044E
                +B01001$B01001_045E
                +B01001$B01001_046E
                +B01001$B01001_047E
                +B01001$B01001_048E
                +B01001$B01001_049E)/B01001$B01001_001E

B01001$P_Female<-(B01001$B01001_001E-B01001$B01001_002E)/B01001$B01001_001E

B01001$pop_tot[B01001$pop_tot == "NaN"]<-NA
B01001$under18[B01001$under18 == "NaN"]<-NA
B01001$over65[B01001$over65 == "NaN"]<-NA
B01001$P_Female[B01001$P_Female == "NaN"]<-NA

B01001<-B01001 %>% select(GEOID, pop_tot, under18, over65, P_Female)

#B11016: Households
#https://data.census.gov/cedsci/table?q=Households&d=ACS%205-Year%20Estimates%20Detailed%20Tables&tid=ACSDT5Y2018.B11016&hidePreview=false
B11016_Vars<-c("B11016_001")

B11016 <-get_vars(B11016_Vars)
B11016$hh_tot<-B11016$B11016_001E
B11016$hh_tot[B11016$hh_tot == "NaN"]<-NA
B11016<-B11016 %>% select(GEOID, hh_tot)

#B02001: Race ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B02001&prodType=table
B02001_Vars<-c("B02001_001",
               "B02001_002",
               "B02001_003",
               "B02001_004",
               "B02001_005",
               "B02001_006",
               "B02001_007",
               "B02001_008")

B02001 <- get_vars(B02001_Vars)

B02001$PWhite<-B02001$B02001_002E/B02001$B02001_001E
B02001$PBlack<-B02001$B02001_003E/B02001$B02001_001E
B02001$PAIAN<-B02001$B02001_004E/B02001$B02001_001E
B02001$PAsian<-B02001$B02001_005E/B02001$B02001_001E
B02001$PNonwhite<-(B02001$B02001_001E-B02001$B02001_002E)/B02001$B02001_001E

B02001$PWhite[B02001$PWhite == "NaN"]<-NA
B02001$PBlack[B02001$PBlack == "NaN"]<-NA
B02001$PAIAN[B02001$PAIAN == "NaN"]<-NA
B02001$PAsian[B02001$PAsian == "NaN"]<-NA
B02001$PNonwhite[B02001$PNonwhite == "NaN"]<-NA

B02001<-B02001 %>% select(GEOID, PWhite, PBlack, PAIAN, PAsian, PNonwhite)

#B03002: Ethnicity + Non-Hispanic White
#https://data.census.gov/cedsci/table?q=non%20hispanic%20white&tid=ACSDT1Y2019.B03002&hidePreview=false
B03002_Vars<-c("B03002_001", 
               "B03002_003",
               "B03002_004",
               "B03002_005",
               "B03002_006",
               "B03002_007",
               "B03002_008",
               "B03002_009",
               "B03002_012")
B03002<-get_vars(B03002_Vars)

B03002$PNH_White<-B03002$B03002_003E/B03002$B03002_001E
B03002$PNH_Black<-B03002$B03002_004E/B03002$B03002_001E
B03002$PNH_Asian<-B03002$B03002_006E/B03002$B03002_001E
B03002$PNH_Other<-(B03002$B03002_005E+B03002$B03002_007E+B03002$B03002_008E+B03002$B03002_009E)/B03002$B03002_001E
B03002$PLatino<-B03002$B03002_012E/B03002$B03002_001E

B03002$PNH_White[B03002$PNH_White=="NaN"]<-NA
B03002$PNH_Black[B03002$PNH_Black=="NaN"]<-NA
B03002$PNH_Asian[B03002$PNH_Asian=="NaN"]<-NA
B03002$PNH_Other[B03002$PNH_Other=="NaN"]<-NA
B03002$PLatino[B03002$PLatino == "NaN"]<-NA

B03002<-B03002 %>% select(GEOID, PNH_White, PNH_Black, PNH_Asian, PNH_Other, PLatino)

#B05002: Foreign Born ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B05002&prodType=table
B05002_Vars<-c("B05002_001",
               "B05002_013")

B05002 <- get_vars(B05002_Vars)

B05002$PForeignborn<-B05002$B05002_013E/B05002$B05002_001E

B05002$PForeignborn[B05002$PForeignborn == "NaN"]<-NA

B05002<-B05002 %>% select(GEOID, PForeignborn)

#B19013: Median Household Income ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B19013&prodType=table
B19013_Vars<-c("B19013_001")

B19013 <- get_vars(B19013_Vars)

B19013$MHHI<-B19013$B19013_001E

B19013$MHHI[B19013$MHHI == "NaN"]<-NA

B19013<-B19013 %>% select(GEOID, MHHI)

#B11001: Female Headed Household ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B11001&prodType=table
B11001_Vars<-c("B11001_001", "B11001_006")
B11001 <- get_vars(B11001_Vars)

B11001$P_FHHH <- B11001$B11001_006E /B11001$B11001_001E

B11001$P_FHHH[B11001$P_FHHH == "NaN"]<-NA

B11001<-B11001 %>% select(GEOID, P_FHHH)


#B17001: Poverty Rate ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B17001&prodType=table
B17001_Vars<-c("B17001_001",
               "B17001_002")
B17001 <- get_vars(B17001_Vars)

B17001$Pov<-B17001$B17001_002E / B17001$B17001_001E

B17001$Pov[B17001$Pov == "NaN"]<-NA

B17001<-B17001 %>% select(GEOID, Pov)

#B19301: Per Capita Income ---- 
B19301_Vars<-c("B19301_001")

B19301 <- get_vars(B19301_Vars)

B19301$PCI<-B19301$B19301_001E

B19301$PCI[B19013$PCI == "NaN"]<-NA

B19301<-B19301 %>% select(GEOID, PCI)

#C24050: Industry by Occupation (Service Occupations) ----
#https://data.census.gov/cedsci/table?q=C24050&tid=ACSDT1Y2019.C24050&hidePreview=false
C24050_Vars<-c("C24050_001E",
              "C24050_029E")

C24050 <- get_vars(C24050_Vars)

C24050$ServOccup <- C24050$C24050_029E/C24050$C24050_001E

C24050$ServOccup[C24050$ServOccup == "NaN"]<-NA

C24050 <- C24050 %>% select(GEOID, ServOccup)

#B25003: Tenure (Renter Occupied) ----
#https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_16_5YR_B25003&prodType=table

B25003_Vars <- c("B25003_001", "B25003_003")
B25003 <- get_vars(B25003_Vars)

B25003$P_Rent <- B25003$B25003_003E / B25003$B25003_001E
B25003$P_Rent[B25003$P_Rent == "NaN"]<-NA

B25003<-B25003 %>% select(GEOID, P_Rent)

#B25077: Median Home Value (Owner Occupied Housing Units) ----
B25077_Vars <- c("B25077_001")
B25077 <- get_vars(B25077_Vars)

names(B25077)[3]<-"MHV"
B25077$MHV[B25077$MHV == "NaN"]<-NA

B25077 <- B25077 %>%  select(GEOID, MHV)

#B25064: Median Gross Rent ---- 
B25064_Vars <- c("B25064_001")

B25064 <- get_vars(B25064_Vars)

B25064$MGR <- B25064$B25064_001E
B25064$MGR[B25064$MGR == "NaN"]<-NA

B25064 <- B25064 %>% select(GEOID, MGR)

# B25106: Housing Cost Burden (Owners and Renters) ----
B25106_Vars <- c("B25106_001",
                 "B25106_002",
                 "B25106_006",
                 "B25106_010",
                 "B25106_014", 
                 "B25106_018", 
                 "B25106_022",
                 "B25106_024",
                 "B25106_028", 
                 "B25106_032",
                 "B25106_036",
                 "B25106_040",
                 "B25106_044")

B25106 <- get_vars(B25106_Vars)

B25106$OCB<-(B25106$B25106_006E+
                      B25106$B25106_010E+
                      B25106$B25106_014E+
                      B25106$B25106_018E+
                      B25106$B25106_022E)/B25106$B25106_002E
                      
B25106$RCB<-(B25106$B25106_028E+
                      B25106$B25106_032E+
                      B25106$B25106_036E+
                      B25106$B25106_040E+
                      B25106$B25106_044E)/B25106$B25106_024E

B25106$OCB[B25106$OCB == "NaN"]<-NA
B25106$OCB[B25106$OCB == "NaN"]<-NA

B25106 <- B25106 %>%  select(GEOID, OCB, RCB)

# B25002: Residential Vacancy Rate ----
B25002_Vars<-c("B25002_001", "B25002_003")
B25002 <- get_vars(B25002_Vars)
B25002$Rvac<-B25002$B25002_003E/B25002$B25002_001E
B25002$Rvac[B25002$Rvac == "NaN"]<-NA

B25002 <- B25002 %>% select(GEOID, Rvac)

#B07003 Mobility Rate (moved within last year) ----
B07003_Vars<-c("B07003_001",
               "B07003_004")

B07003 <- get_vars(B07003_Vars)

B07003$Mobility<-(B07003$B07003_001E-B07003$B07003_004E)/B07003$B07003_001E
B07003$Mobility[B07003$Mobility == "NaN"]<-NA

B07003 <- B07003 %>% select(GEOID, Mobility)

#B08303 Commute (over 60 mins) ----
B08303_Vars<-c("B08303_001",
              "B08303_012",
              "B08303_013")
B08303 <- get_vars(B08303_Vars)

B08303$Commute<-(B08303$B08303_012E+B08303$B08303_013E)/B08303$B08303_001E
B08303$Commute[B08303$Commute == "NaN"]<-NA

B08303<-B08303 %>% select(GEOID, Commute)

#Vehicles Available (Households with no vehicles available)
B25044_Vars<-c(
  "B25044_001",
  "B25044_003",
  "B25044_009"
)

B25044<-get_vars(B25044_Vars)

B25044$P_NoCar<-(B25044$B25044_003E+B25044$B25044_009E)/B25044$B25044_001E
B25044$P_NoCar[B25044$P_NoCar == "NaN"]<-NA
B25044<-B25044 %>% select(GEOID, P_NoCar)

#S2401: Essential Workers ----
# Uses CMAP strategy for identifying workers in essential idustries
#https://github.com/CMAP-REPOS/essentialworkers/blob/master/essential%20occupations%20script.R

# essential worker assignments, identified by variable ID.
#  no  = not essential
#  na  = a subtotal in the table. Disregard.
#  conman = Construction, Manufacturing, Maintenance
occ_class <- tribble(~variable, ~essential,
                     "S2401_C01_001", "total",
                     "S2401_C01_002", "na",
                     "S2401_C01_003", "na",
                     "S2401_C01_004", "no",
                     "S2401_C01_005", "no",
                     "S2401_C01_006", "na",
                     "S2401_C01_007", "no",
                     "S2401_C01_008", "no",
                     "S2401_C01_009", "no",
                     "S2401_C01_010", "na",
                     "S2401_C01_011", "socialservices",
                     "S2401_C01_012", "no",
                     "S2401_C01_013", "no",
                     "S2401_C01_014", "no",
                     "S2401_C01_015", "na",
                     "S2401_C01_016", "health",
                     "S2401_C01_017", "health",
                     "S2401_C01_018", "na",
                     "S2401_C01_019", "health",
                     "S2401_C01_020", "na",
                     "S2401_C01_021", "protection",
                     "S2401_C01_022", "protection",
                     "S2401_C01_023", "food",
                     "S2401_C01_024", "conman",
                     "S2401_C01_025", "no",
                     "S2401_C01_026", "na",
                     "S2401_C01_027", "no",
                     "S2401_C01_028", "no",
                     "S2401_C01_029", "na",
                     "S2401_C01_030", "food",
                     "S2401_C01_031", "conman",
                     "S2401_C01_032", "conman",
                     "S2401_C01_033", "na",
                     "S2401_C01_034", "conman",
                     "S2401_C01_035", "transport",
                     "S2401_C01_036", "transport"
)

# build vector of occupation categories
occ_class_list <- filter(occ_class, essential != "total" & essential != "na") %>% 
  .[["essential"]] %>% 
  unique()

# get descriptive variable names for table S2401
varnames <- load_variables(DL_Year, "acs5/subject", cache = TRUE) %>% 
  # get only records from this table
  filter(str_sub(name, 1, 5) == "S2401") %>%
  # remove unnecessary label text
  mutate(label = sub('^Estimate!!', '', label)) %>% 
  # drop unnecessary columns and rename
  select(variable = name, label)

# get occupation data tracts
S2401<-reduce(map(state, function(x){
get_acs(geography = geo, table = "S2401", cache_table = TRUE, 
          year = DL_Year, state = x, survey = survey)
}),
rbind
)

# clean up occupation data
S2401_clean <- S2401 %>%
  # add descriptive variable names
  left_join(varnames, by = "variable") %>% 
  # drop gender and gender percent data, keeping only total
  filter(str_sub(label, 1, 5) == "Total") %>% 
  # add occupation classes
  left_join(occ_class, by = "variable") %>% 
  # clean labels by separating into separate columns. At the moment, keep only the last (most detailed) descriptor
  separate(label, into = c(NA, NA, NA, NA, "label"), sep = "!!", fill = "left") %>%
  # drop all subtotal records
  filter(essential != "na")

# check that all workers are still in the data
S2401_clean %>% 
  # turn essential into just a total vs subcategory column
  mutate(essential = if_else(essential == "total", "total", "sub")) %>% 
  # summarize employment by total and subtotal per tract
  group_by(NAME, essential) %>% 
  summarize(estimate = sum(estimate)) %>% 
  pivot_wider(id_cols = NAME, names_from = essential, values_from = estimate) %>% 
  # generate a check column, and see if it equals 0
  mutate(check = (total - sub) == 0) %>%
  .[["check"]] %>% 
  # return TRUE if every check is TRUE
  all()


final <- S2401_clean %>% 
  # summarize employment categories per tract
  group_by(GEOID, essential) %>% 
  summarize(NAME = first(NAME),
            estimate = sum(estimate)) %>% 
  # widen the table so there is 1 row per census tract
  pivot_wider(id_cols = c(GEOID, NAME), names_from = essential, values_from = estimate) %>% 
  # calculate percentages of various essential worker categories
  mutate_at(occ_class_list, ~ . / total) %>% 
  mutate(essential = 1 - no) %>% 
  # clean up column names
  select(GEOID, NAME, total_workers = total, essential, nonessential = no, everything()) %>% 
  # clean up tract name
  separate(NAME, into = c("tract", "county", NA), sep = ", ", remove = FALSE) %>% 
  mutate(county = sub(' County', '', county),
         tract = gsub("[^0-9.-]", "", tract)) %>% 
  # drop tracts with fewer than 100 workers, for SOME degree of MOE accuracy
  filter(total_workers > 99)
final <-final %>% select(GEOID, total_workers:transport)
rm(occ_class, S2401, S2401_clean, varnames)

#Merge Together----
acs_covars<-list(B01001, B11016, B02001, B03002, B05002, B11001, B17001, B19013, B25002, B25003, B25077, B25106, B25064, C24050, B07003, B08303, B19301, B25044, final) %>% 
  reduce(left_join, by="GEOID")

write_rds(acs_covars, "data/acs_covars.rds")

rm(B01001, B02001, B03002, B05002, B11001, B11016, B17001, B19013, B25002, B25003, B25044, B25077, B25106, B25064, C24050, B07003, B08303, B19301, final)
rm(list=ls(pattern="^B"), C24050_Vars, occ_class_list)


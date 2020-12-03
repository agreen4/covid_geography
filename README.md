# Description

This set of scripts creates a national typology of census tracts for all tracts in the continental US, Alaska, and Hawaii. The goal of the typology is to develop a reduced sets of place types for which subsequent modeling can be performed to estimate the impacts of evictions on the spread of COVID. 

# ACS Covariates

|  Variable | Description | Source | Table | Notes |
|-|-|-|-|-|
| GEOID | Tract FIPS Code |20018 ACS  |  |  |
|poptot  |Total population  |2018 ACS |B01001  |  |
|popden  |Population density  |2018 ACS, 2018 TIGER |B01001  |Tract population divided by tract area (miles<sup>2</sup>)  |
|under18  |Proportion of the population under age 18  |2018 ACS |B01001  |  |
|over65  |Proportion of the population over age 65  |2018 ACS  |B01001  |  |
|P_Female  |Proportion of the population who is female  |2018 ACS  |B01001  |  |
|hh_tot  |Total households  in the Census Tract|2018 ACS  |B11016  |  |
|PNH_White  |Proportion of the population identifying as Non-Hispanic White  |2018 ACS  |B03002  |  |
|PNH_Black  |Proportion of the population identifying as Non-Hispanic Black  |2018 ACS  |B03002  |  |
|PNH_Asian  |Proportion of the population identifying as Non-Hispanic Asian  |2018 ACS  |B03002  |  |
|PNH_Other  |Proportion of the population identifying as Non-Hispanic all other groups  |2018 ACS  |  B03002  ||
|PLatino  |Proportion of the population identifying as Hispanic or Latino (of any race)  |2018 ACS  |B03002  |  |
|PForeignborn  |Proportion of the population who is foreign born  |2018 ACS  |B05002  |  |
|MHHI  |Median household income  |2018 ACS  |B19013  |  |
|P_FHHH  |Proportion female-headed households  |2018 ACS  |B11001  |  |
|Pov  |Household poverty rate  |2018 ACS  |B17001  |  |
|PCI  |Per-capita Income  |2018 ACS  |B19301  |  |
|ServOccup  |Proportion population working in service occupations  |2018 ACS  |C24050  |  |
|P_Rent|Proportion renter-occupied households|2018 ACS|B25003||
|MHV|Median home value|2018 ACS |B25077||
|MGR|Median gross rent|2018 ACS|B25064||
|OCB|Proportion cost-burdened homeowners|2018 ACS|B25106||
|RCB|Proportion cost-burdened renters|2018 ACS|B25106||
|Rvac|Residential vacancy rate|2018 ACS|B25002||
|Mobility|Proportion of households who moved within the last year|2018 ACS|B07002||
|Commute|Proportion of workers with long (> 60 minute) commutes to work|2018 ACS|B08303||
|NoCar|Proportion of households with no vehicle available|2018 ACS|B25044||
|conman|Construction and manufacturing|2018 ACS|S2401|Uses [CMAP Methodology](https://github.com/CMAP-REPOS/essentialworkers) for identifying essential workers|
|food|Food preparation and service|2018 ACS|S2401|Uses [CMAP Methodology](https://github.com/CMAP-REPOS/essentialworkers) for identifying essential workers|
|health|Healthcare|2018 ACS|S2401|Uses [CMAP Methodology](https://github.com/CMAP-REPOS/essentialworkers) for identifying essential workers|
|protection|Protective services|2018 ACS|S2401|Uses [CMAP Methodology](https://github.com/CMAP-REPOS/essentialworkers) for identifying essential workers|
|socialservices|Social services|2018 ACS|S2401|Uses [CMAP Methodology](https://github.com/CMAP-REPOS/essentialworkers) for identifying essential workers|
|transport|Transportation|2018 ACS|S2401|Uses [CMAP Methodology](https://github.com/CMAP-REPOS/essentialworkers) for identifying essential workers|

Housing instability - [Routhier (2019)](https://www.tandfonline.com/action/showCitFormats?doi=10.1080/10511482.2018.1509228) examines multiple dimensions of housing instability and uses American Housing Survey data to produce a typology for the measurement of the severity of such instability. Their index includes four dimensions - affordability, crowding, poor physical conditions, and forced moves and instability, with affordability being the strongest indicator of housing insecurity. 

[Kang (2019)](https://www.tandfonline.com/doi/pdf/10.1080/02673037.2019.1676402?casa_token=rhjjHpwLG7sAAAAA:vUYeYQh0RbDMPYbCfd2CGkZNAMk8HRVCi5cqxRr4oTggZU9-282g_dJB1Zm7zpbM8RCL5t88) uses Panel Study of Income Dynamics (PSID) data to examine regional determinants of housing instability for metropolitan areas in the United States. They find that poverty and it's outcomes, especially incidence of doubled-up households at the metropolitan level are important determinants of housing instability. They also find that lack of access to a vehicle is an important determinant of housing instability - a finding consistent with other studies which have explored issues related to car access and poverty.

[Cox et al. (2019)](https://www.jstor.org/stable/pdf/26696378.pdf?casa_token=zKWb66ICGakAAAAA:B4xhEXkn7Hlh5tI3DJvHgL1Lv8KueVvlfSxLkHQFKUgMziQDHBVl4HOGVi67fLMZ-SxB__AZwW6OTAhSqbpuQxTVRVXTba6Czy2DQ4tQFHvlScw) develop a roadmap for the measurement of housing insecurity in the U.S., identifying seven dimensions based upon a metaanalysis of the literature. The seven identified areas - housing stability, housing affordability, housing quality, housing safety, neighborhood safety, neighborhood quality, and homelessness - are present in existing literature, but are not comprehensively analyzed together.

#ERS Commuting Shed Delineations
In order to split census tracts into reasonable regions for standardization, we use [2010 vintage USDA Economic Research Service Commuting Zones](https://sites.psu.edu/psucz/data/) based upon the work of [Fowler, et al (2016)](https://link.springer.com/article/10.1007/s11113-016-9386-0).

# Eviction Lab Geographies

We analyze the same set of census places analyzed in Eviction Lab's [Eviction Tracking System](https://evictionlab.org/eviction-tracking/). This system provides weekly updates to eviction filing numbers since March 15, 2020 and also performs some analysis on the impacts of state and local government eviction moratoria on eviction rates.

While the majority of eviction filing information is summarized to census tracts, for a few cities (Austin (TX), Pittsburgh (PA), and Richmond (VA), eviction filings are summarized to zip codes. Consequently, we develop two preliminary sets of analytical files - one for census tracts, and one for zip codes.

For Eviction Lab geographies, we extract the following information:

|  Variable | Description | Source | Table | Notes |
|-|-|-|-|-|
| GEOID | Tract FIPS Code |  |  |  |
| trt_area | Tract Area (Square Meters) | 2018 TIGER Geographies |  |  |
| NAME | City Name |  |  |  |
| frag_area | Tract Fragment Area (Square Meters) | 2018 TIGER Geographies |  | Reflects proportion of tract area within city boundaries for tracts that cross place boundaries. |

Tract and Zip Code Tabulation Area geographies are first downloaded for the states in which each city is located. Census place geographies for those places are also downloaded.
The area (in square meters) is calculated for each administrative geography.
Census place geogrpahies are overlaid upon tract and zip code geographies, and are then use to extract those portions of the administrative geographies within the place geographies.
The area (in square meters) is calculated for each administrative geography that lies within the census place boundary for each city. As of right now, the script keeps all fragments with some area inside the city limits. This can be modified to exclude small fragments, especially if these fragements prove to be substantially different than other geographies within the place.

# Clustering the Tracts
[Spielman and Singleton (2015)](https://www.tandfonline.com/doi/pdf/10.1080/00045608.2015.1052335). Link for code is available on Github, but code itself is missing. This code by the same authors also [available on Github](https://github.com/geoss/acs_demographic_clusters/tree/master/code), may be useful.

Giselle Routhier (2019) Beyond Worst Case Needs: Measuring the Breadth and Severity of Housing Insecurity Among Urban Renters, Housing Policy Debate, 29:2, 235-249, DOI: 10.1080/10511482.2018.1509228
# Description

This set of scripts creates a set of demographic covariates associated with Census tracts located in those communities which Eviction Lab is tracking "real time" evictions during the COVID-19 Pandemic

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

# ACS Covariates

|  Variable | Description | Source | Table | Notes |
|-|-|-|-|-|
| GEOID | Tract FIPS Code |  |  |  |
|  |  |  |  |  |

Housing instability - [Routhier (2019)](https://www.tandfonline.com/action/showCitFormats?doi=10.1080/10511482.2018.1509228) examines multiple dimensions of housing instability and uses American Housing Survey data to produce a typology for the measurement of the severity of such instability. Their index includes four dimensions - affordability, crowding, poor physical conditions, and forced moves and instability, with affordability being the strongest indicator of housing insecurity. 
- Affordability
Cost Burdened Renters - Rent above 30% income
Severely Cost Burdened Renters - Rent above 50% income
Poverty - Income below 133% of Federal Poverty rate (if rent is above 30 percent of income)
- Crowding
Crowded Households - More than 1 person per room
Severely Crowded Households - More than 1.5 people per room
Doubled up households - One or more subfamilies within the same households

[Kang (2019)](https://www.tandfonline.com/doi/pdf/10.1080/02673037.2019.1676402?casa_token=rhjjHpwLG7sAAAAA:vUYeYQh0RbDMPYbCfd2CGkZNAMk8HRVCi5cqxRr4oTggZU9-282g_dJB1Zm7zpbM8RCL5t88) uses Panel Study of Income Dynamics (PSID) data to examine regional determinants of housing instability for metropolitan areas in the United States. They find that poverty and it's outcomes, especially incidence of doubled-up households at the metropolitan level are important determinants of housing instability. They also find that lack of access to a vehicle is an important determinant of housing instability - a finding consistent with other studies which have explored issues related to car access and poverty.

Market Tightnes - rvac
MGR
Unemp
Pov
% Commute by automobile

[Cox et al. (2019)](https://www.jstor.org/stable/pdf/26696378.pdf?casa_token=zKWb66ICGakAAAAA:B4xhEXkn7Hlh5tI3DJvHgL1Lv8KueVvlfSxLkHQFKUgMziQDHBVl4HOGVi67fLMZ-SxB__AZwW6OTAhSqbpuQxTVRVXTba6Czy2DQ4tQFHvlScw) develop a roadmap for the measurement of housing insecurity in the U.S., identifying seven dimensions based upon a metaanalysis of the literature. The seven identified areas - housing stability, housing affordability, housing quality, housing safety, neighborhood safety, neighborhood quality, and homelessness - are present in existing literature, but are not comprehensively analyzed together.

# Clustering the Tracts


Giselle Routhier (2019) Beyond Worst Case Needs: Measuring the Breadth and Severity of Housing Insecurity Among Urban Renters, Housing Policy Debate, 29:2, 235-249, DOI: 10.1080/10511482.2018.1509228
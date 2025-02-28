# Author: Francisco Rios 
# Purpose: Prep all data necessary for Aim 3 Analyses
# Date: Last modified May 4 2022

rm(list=ls())

# set up files
source(paste0("/Users/ziva/R Projects/uw-phi-vax/global_vac_index/aim_3/01_set_up_R.R"))

# Load data: index results, vaccination data, DALY

# load index dataset
index_data <- readRDS(paste0(prepped_data_dir, "aim_2/19_index_results_third_version.RDS"))

# load vaccination coverage dataset
vax_data <- readRDS(paste0(prepped_data_dir, "aim_1/01_vaccine_trends.RDS"))

# reshape the vaccination data
vax_data <- pivot_wider(vax_data,
                        id_cols=c("location_id", "location_name", "year_id"),
                        names_from = "vaccine_name",
                        values_from = c(prop_val, prop_upper, prop_lower))

# load the DALY data
daly_data <- readRDS(paste0(prepped_data_dir, "aim_3/01_prepped_diphtheria_dalys.RDS"))#changed for diphtheria

# merge together files for each location and year
#Does not appear to be adding in the dalys data!!
full_data <- index_data %>%
left_join(vax_data,
          by=c("gbd_location_id"="location_id",
              "year"="year_id",
              "location"="location_name")) %>%
left_join(daly_data,
          by=c("gbd_location_id"="location_id","year"
         ))

# subset columns that will be used in the analyses
full_data <- full_data %>% 
  select(location, region, year, gbd_location_id, iso_code, iso_num_code, 
         region, result, prop_val_MCV1, prop_val_DTP1, prop_val_DTP3, prop_val_RotaC,
         dalys_diphtheria_number, dalys_diphtheria_percent, dalys_diphtheria_rate)

# save full data for analysis
saveRDS(full_data, file=paste0(prepped_data_dir, "aim_3/02_prepped_full_data_dip.RDS"))
#Created new file name for prepped data with diphtheria instead of measles dalys

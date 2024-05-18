pacman::p_load(tidyverse)

#save for later
old_wd <- getwd()

#set path to data
setwd("../Python/simulated_data/")

files <- list.files(pattern = "*.csv", full.names = TRUE)

#load  all .csv files
data <- lapply(files, read_csv)

#split it to single dfs with the correct names
names(data) <- gsub(".csv", "", list.files(pattern = "*.csv"))

#Split to single dfs
list2env(data, envir = .GlobalEnv)

#get the resistance level from the full data frame
single_trial_resistance_beliefs <- single_trial_resistance_beliefs %>%
  mutate(resistance_level = single_trial_full_data$resistance_state,
         #get entropy levels
         resistance_entropy = single_trial_full_data$resistance_entropy,
         #make a timestep column
         timestep = 1:nrow(single_trial_resistance_beliefs) - 1)  %>% 
  #select all but the first column
  select(c(-1)) 

#Turn into long format
single_trial_resistance_beliefs <- single_trial_resistance_beliefs %>%
  pivot_longer(cols = c(1:6), values_to = "belief")  %>% 
  mutate(state_belief = as.numeric(gsub("r", "", name)) - 1)

#make full data have a timestep column
single_trial_full_data <- single_trial_full_data %>%
  mutate(timestep = 1:nrow(single_trial_full_data) - 1)

setwd(old_wd)


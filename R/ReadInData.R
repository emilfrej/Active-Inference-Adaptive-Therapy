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

#get the sim_length
exploratory_sim_length <- nrow(single_trial_full_data)

#get the number of tests
num_tests <- sum(single_trial_full_data$testing_state == "testing")

#get the number of policies
num_policies <- single_trial_full_data$policy[1] %>% 
  str_count("\n") + 1

#create a vector with column names pol 1 pol 2 up pol 6
pol_names <- paste0("pol_", 1:num_policies)

#chose interesting timesteps
chosen_timesteps <- c(16, 34)

#construct a dataframe for fep values at a few timesteps 
fep_ex_df_full <- single_trial_full_data %>% 
  #make as many columns for policies
  separate(policy, into = paste0("pol_at_time", 1:6), sep = "\n", fill = "right") %>%
  
  #pivot to long form
  pivot_longer(cols = c(contains("pol_at_time")), values_to = "pol_at_time", names_to = "future_timepoint") %>% 
  
  #calculate actual timepoint by first extract the digit in the future_timepoint column
  mutate(future_timepoint = as.numeric(str_extract(future_timepoint, "[0-9]+")) + timestep,
         #remove everything that isnt digits from pol at time
         pol_at_time = str_remove_all(pol_at_time, "[^0-9]")) %>% 
  
  #add coloumn for treating at the each time by extracting the first index of the pol at time and for testing
  mutate(treatment_planned = ifelse(str_sub(pol_at_time, 1, 1) == "1", 1, 0),
         testing_planned = ifelse(str_sub(pol_at_time, 5, 5) == "1", 1, 0))


sim_lengths_growth_rate_0.1$growth_rate <- 0.1
sim_lengths_growth_rate_0.3$growth_rate <- 0.3
sim_lengths_growth_rate_0.5$growth_rate <- 0.5
sim_lengths_growth_rate_0.7$growth_rate <- 0.7

#add the rows of all of them to one dataframe
sim_lengths <- rbind(sim_lengths_growth_rate_0.1, sim_lengths_growth_rate_0.3, sim_lengths_growth_rate_0.5, sim_lengths_growth_rate_0.7) 

#turn into long format
sim_lengths_long <- sim_lengths %>% 
  select(-1) %>% 
  pivot_longer(cols = 1:4, names_to = "strategy", values_to = "sim_length") 

#rename all ADT to RB
sim_lengths_long$strategy <- ifelse(sim_lengths_long$strategy == "ADT", "RB", sim_lengths_long$strategy)


#make a df for contrasts
contrasted_sim_lengths <- sim_lengths %>%
  
  #make growth rate a factor
  mutate(growth_rate = as.factor(growth_rate),
         
         #get difference in percent
         short_vs_rb = (Short - ADT)  / ADT * 100,
         medium_vs_rb = (Medium - ADT) / ADT * 100,
         long_vs_rb = (Long - ADT) /  ADT * 100) %>% 
  
  #pivot to long format for ease of plotting
  pivot_longer(cols = contains("vs"), values_to = "change_in_percent", names_to = "contrast") %>% 
  
  #only keep usefull columns
  select(contrast, change_in_percent, growth_rate)

setwd(old_wd)


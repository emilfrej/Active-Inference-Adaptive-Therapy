#get the number of policies
num_policies <- single_trial_full_data$policy[1] %>% 
  str_count("\n") + 1

#create a vector with column names pol 1 pol 2 up pol 6
pol_names <- paste0("pol_", 1:num_policies)

#construct a dataframe for fep values at a few timesteps 
fep_ex_df <- single_trial_full_data %>% 
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

source("sim_run_example.R") 

plot <- ggplot(single_trial_full_data, aes(x = timestep, y = tumor_state)) +
  
  #add line for tumor
  geom_line(aes(color = "Tumor Level")) +
  
  #add line for resistance state
  geom_line(aes(y = resistance_state, color = "Resistance Level" ), linetype = 2) +
  
  #add expected testing
  geom_point(data = fep_ex_df %>% filter(testing_planned == 1), aes(x = future_timepoint, y = 0, shape = "Planned Testing"), size = 1, alpha = .4) +
  scale_shape_manual(values = c("Planned Testing" = 4)) +
  

  #force the resistance level color to black
  scale_color_manual(values = c("black", "red")) +
  
  #add shaded areas for planned treatement
  geom_rect(data = fep_ex_df %>% filter(treatment_planned == 1), aes(xmin = future_timepoint, xmax = future_timepoint+1,  ymin = -Inf, ymax = Inf, fill = "Planned Treament"), inherit.aes = FALSE, , alpha = 0.2, label = "Planned Treatment")  +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(title = NULL),
         colour = guide_legend(title = NULL)) +
  

  #set legend
  scale_fill_manual(values = c("Planned Treament" = "red")) +
  
  
  #remove the shape legend title
  guides(shape = guide_legend(title = NULL)) +
  
  labs(title = "Best Policy at Each Timepoint",
       x = "Time",
       y = "Tumor and Resistance State") 

plot




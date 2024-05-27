# Turn expected states into long format for all columns (r* and t)
expected_states_long <- single_trial_expected_states %>% 
  pivot_longer(cols = (4:15), names_to = "state", values_to = "belief") %>% 
  
  # Make the states into numeric variables
  mutate(state_type = if_else(str_detect(state, "r"), "Resistance Level", "Tumor Level"), 
         state_num = as.numeric(str_extract(state, "[0-9]+")) - 1,
         distance_from_current_timepoint = future_timepoint - current_time) %>% 
  filter((current_time == "24" & state_type == "Resistance Level") | (current_time == "14" & state_type == "Tumor Level")) 

source("sim_run_example.R")

# Create the plot
plot <- plot + ggplot() +
  # Plot a vline for resistance level
  geom_vline(xintercept = 24, linetype = 15, alpha = .5) +
  
  # Plot a red vline for tumor level at 14
  geom_vline(xintercept = 14, linetype = 15, alpha = .5, color = "red") +
  
  # Plot points
  geom_point(data = expected_states_long, aes(y = state_num, x = future_timepoint, size = belief, alpha = belief, color = state_type)) +
  
  # Remove the guide about beliefs and rename beliefs to Probability
  guides(size = guide_legend(title = "Expected Probability"),
         alpha = guide_legend(title = "Expected Probability")) +
  
  # Define the color scale manually to match the levels of state_type
  scale_color_manual(values = c("Resistance Level" = "black", "Tumor Level" = "red")) +
  
  # Define the size range
  scale_size(range = c(0.1, 3))

# Print the plot
print(plot)
#first build treatment dataframe for when treatment is given
treatment_shading <- single_trial_full_data %>%
  filter(treatment_state == "treat") %>% 
  select(timestep) %>%
  
  #make a new column for used for plotting
  mutate(time_plus_1 = timestep + 1,
         timestep_minus_1 = timestep - 1)

#add column for testing
testing_times <- single_trial_full_data %>%
  filter(testing_state == "testing")
  

plot <- ggplot(single_trial_full_data, aes(x = timestep, y = tumor_state)) +
  
  #add line for tumor
  geom_line(aes(color = "Tumor Level")) +
  
  #add line for resistance state
  geom_line(aes(y = resistance_state, color = "Resistance Level" ), linetype = 2) +
  
  #add shaded areas for treatment on
  geom_rect(data = treatment_shading, aes(xmin = timestep_minus_1, xmax = timestep,  ymin = -Inf, ymax = Inf, fill = "Treating"), inherit.aes = FALSE, , alpha = 0.4, label = "Treatment is given")  +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(title = NULL),
         colour = guide_legend(title = NULL)) +
  
  #force the resistance level color to black
  scale_color_manual(values = c("black", "red")) +
  
  #overlay testing points
  geom_point(data = testing_times, aes(x = timestep, y = 4.5, shape = "Testing"), size = 1) +
  
  #set other x shape for testing
  scale_shape_manual(values = c("Testing" = 4)) +
  
  #remove the shape legend title
  guides(shape = guide_legend(title = NULL)) +
  
  
 
  labs(x = "Time",
       y = "Tumor and Resistance State") 

#save plot 
ggsave("../visualizations/Tumor_and_Resistance_Levels.png", width = 10, height = 6, units = "in")


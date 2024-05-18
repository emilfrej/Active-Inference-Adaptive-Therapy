#first build treatment dataframe for when treatment is given
treatment_shading <- single_trial_full_data %>%
  filter(treatment_state == "treat") %>% 
  select(timestep) %>%
  
  #make a new column for used for plotting
  mutate(time_plus_1 = timestep + 1,
         timestep_minus_1 = timestep - 1)


plot <- ggplot(single_trial_full_data, aes(x = timestep, y = tumor_state)) +
  
  #add line for tumor
  geom_line(aes(color = "Tumor Level")) +
  
  #add line for resistance state
  geom_line(aes(y = resistance_state, color = "Resistance Level" ), linetype = 2) +
  
  #add shaded areas for treatment on
  geom_rect(data = treatment_shading, aes(xmin = timestep_minus_1, xmax = timestep,  ymin = -Inf, ymax = Inf, fill = "Treatment Is Given"), inherit.aes = FALSE, , alpha = 0.4, label = "Treatment is given")  +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(title = NULL),
         colour = guide_legend(title = NULL)) +
  
  #force the resistance level color to black
  scale_color_manual(values = c("black", "red")) +
  
  
  
  labs(title = "Tumor and Resistance Level Through Time",
       x = "Time",
       y = "Tumor and Resistance State") 

#save plot 
ggsave("../visualizations/Tumor_and_Resistance_Levels.png", width = 10, height = 6, units = "in")


#Plot the resistance level through time as x-axis
plot <- ggplot(single_trial_resistance_beliefs, aes(y = resistance_level, x = timestep)) +
  
  #plot actual level as empty cicles
  geom_line(linetype = 2) +
  ylim(0, 5) +
  
  #plot the belief as colored and sized points according to beleif strength
  geom_point(aes(y = state_belief, color = belief, size = belief), shape = 21) +
  
  #add color scheme
  scale_color_gradient(low = "blue", high = "red") +
  scale_size(range = c(0.001, 7)) +
  
  guides(size = "none") +
  
  #add the model belief as colored plot depeding on probability
  labs(title = "Model Beliefs of Resistance Level",
       x = "Time",
       y = "Resistance State",
       color = "Probability According to Model") 

ggsave("../visualizations/Model_Beliefs_about_Resistance.png", width = 10, height = 6, units = "in")
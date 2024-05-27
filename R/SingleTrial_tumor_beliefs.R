single_trial_tumor_beliefs_long <- single_trial_tumor_beliefs %>%
  mutate(tumor_state = single_trial_full_data$tumor_state,
         #get entropy levels
         resistance_entropy = single_trial_full_data$tumor_entropy,
         #make a timestep column
         timestep = 1:nrow(single_trial_tumor_beliefs) - 1)  %>% 
  #select all but the first column
  select(c(-1)) 

#Turn into long format
single_trial_tumor_beliefs_long <- single_trial_tumor_beliefs_long %>%
  pivot_longer(cols = c(1:6), values_to = "belief")  %>% 
  mutate(state_belief = as.numeric(gsub("t", "", name)) - 1)


#Plot the resistance level through time as x-axis
plot <- ggplot(single_trial_tumor_beliefs_long, aes(y = tumor_state, x = timestep)) +
  
  #plot actual level as empty cicles
  geom_line(aes(color = "Tumor State"), linetype = 1, show.legend = T) +
  
  #set resistance level color to black
  scale_color_manual(values = c("Red")) +
  

  
  theme(legend.position = "bottom") +
  
  #remove the colour for resistance level 
  guides(color = guide_legend(title = NULL)) +
  
  ylim(0, 5) +
  
  new_scale_color() +
  
  #plot the belief as colored and sized points according to beleif strength
  geom_point(aes(y = state_belief, color = belief, size = belief), shape = 21) +
  
  #add color scheme
  
  scale_color_gradient(low = "blue", high = "red") +
  scale_size(range = c(0.001, 7)) +
  
  #remove 
  labs(x = "Time",
       y = "Patient State Values",
       color = "")  +
  
  guides(size = "none") 




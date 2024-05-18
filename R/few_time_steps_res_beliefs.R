#filter only timestep 24, 25, 26
few_timesteps_res_data <- single_trial_resistance_beliefs %>%
  filter(timestep %in% c(30, 31, 32, 33)) %>% mutate(timestep = as.factor(timestep))

#plot as bar chart
plot <- ggplot(few_timesteps_res_data, aes(x = name, y = belief, fill = belief)
       ) + geom_bar(stat = "identity", position = "dodge") + 
  
  facet_wrap(~timestep) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  
  #add a dot for the actual resistance level
  geom_point(aes(x = resistance_level + 1, y = 0.05), color = "red") +
  
  #add color scheme 
  labs(title = "Beliefs about Resistance Level", x = "Belief State", y = "Belief")

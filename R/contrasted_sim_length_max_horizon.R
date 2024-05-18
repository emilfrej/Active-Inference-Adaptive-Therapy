#create a subset for 
max_horizon <- contrasted_sim_lengths %>%
  filter(growth_rate != 0.1 & contrast == "long_vs_adt") 
  
  #plot histograms of sim lengths and facet by growth rate
plot <- ggplot(max_horizon, aes(x = sim_length)) +
  geom_density(aes(fill = contrast, color = contrast), alpha = 0.1) + 
  facet_wrap(~growth_rate) +
  xlim(-75,75) +
  
  #plot a vertical line at 0
  geom_vline(xintercept = 0, linetype = 2, alpha = .5) +
  
  labs(title = "POMDP performance against ADT",
       x = "Difference against ADT in same run",
       y = "Density")  +
  
  #move the guide below the plot
  theme(legend.position = "bottom") 
  


#create a subset for 
max_horizon <- contrasted_sim_lengths %>%
  filter(contrast == "long_vs_rb") 
  
  #plot histograms of sim lengths and facet by growth rate
plot <- ggplot(max_horizon, aes(x = change_in_percent)) +
  geom_density(aes(fill = contrast, color = contrast), alpha = 0.1) + 
  facet_wrap(~growth_rate) +
  
  #plot a vertical line at 0
  geom_vline(xintercept = 0, linetype = 2, alpha = .5) +
  
  labs(title = "Performance aAgainst Range-bounded Strategy of Long Horizon POMPD",
       x = "Difference against range-bounded strategy on same run (%)",
       y = "Density")  +
  
  #move the guide below the plot
  theme(legend.position = "bottom") 
  


#create a subset for 
max_horizon <- contrasted_sim_lengths %>%
  filter(contrast == "long_vs_rb") 

max_horizon$contrast <- if_else(max_horizon$contrast == "long_vs_rb", "Long Horizon POMDP vs RB", max_horizon$contrast)
  
  #plot histograms of sim lengths and facet by growth rate
plot <- ggplot(max_horizon, aes(x = change_in_percent)) +
  geom_density(aes(fill = contrast, color = contrast), alpha = 0.1) + 
  facet_wrap(~growth_rate) +
  
  #plot a vertical line at 0
  geom_vline(xintercept = 0, linetype = 2, alpha = .5) +
  
  labs(x = "Difference in Survival times (%)",
       y = "Density")  +
  
  #move the guide below the plot
  theme(legend.position = "bottom") +

  #remove contranst label on the guide
  guides(fill = guide_legend(title = NULL),
         color = guide_legend(title = NULL)) +
  
  #move legend to inside the top right panel
  theme(legend.position = c(0.8, 0.94)) +
  
  #make consistent size
  theme(legend.key.size = unit(0.19, "cm")) +
  
  
  #set the colors to red
  scale_fill_manual(values = c("red", "blue")) +
  scale_color_manual(values = c("red", "blue")) 
  
  
  
  

  


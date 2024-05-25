
#make density curves for simulation
plot <- ggplot(sim_lengths_long, aes(x = sim_length, fill = strategy, color = strategy)) +
  geom_density(alpha = 0.1) + 
  facet_wrap(~growth_rate) +
  labs(x = "Simulation Length",
       y = "Density")  +

  #move legend to top left panel
  theme(legend.position = c(0.76, 0.94)) +
  
  #make it horizontal
  theme(legend.direction = "horizontal") +
  
  #make it smaller
  theme(legend.key.size = unit(0.19, "cm")) +
  
#remove the strategy able
  guides(fill = guide_legend(title = NULL),
  color = guide_legend(title = NULL)) 
  

ggsave("../visualizations/Simulation_Lengths_full.png", width = 10, height = 6, units = "in")




#make density curves for simulation
plot <- ggplot(sim_lengths_long, aes(x = sim_length, fill = strategy, color = strategy)) +
  geom_density(alpha = 0.1) + 
  facet_wrap(~growth_rate) +
  labs(title = "POMDP performance against range-bounded strategy (RB)",
       x = "Simulation Length",
       y = "Density")  +

#move the legend below the plot
  theme(legend.position = "bottom")  +

#remove the strategy able
  guides(fill = guide_legend(title = NULL),
  color = guide_legend(title = NULL))


  


ggsave("../visualizations/Simulation_Lengths_full.png", width = 10, height = 6, units = "in")



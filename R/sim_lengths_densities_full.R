source("ReadInData.R")

sim_lengths_growth_rate_0.1$growth_rate <- 0.1
sim_lengths_growth_rate_0.3$growth_rate <- 0.3
sim_lengths_growth_rate_0.5$growth_rate <- 0.5
sim_lengths_growth_rate_0.7$growth_rate <- 0.7

#add the rows of all of them to one dataframe
sim_lengths <- rbind(sim_lengths_growth_rate_0.1, sim_lengths_growth_rate_0.3, sim_lengths_growth_rate_0.5, sim_lengths_growth_rate_0.7) 

#turn into long format
sim_lengths_long <- sim_lengths %>% 
  select(-1) %>% 
  pivot_longer(cols = 1:4, names_to = "strategy", values_to = "sim_length")


#make density curves for simulation
plot <- ggplot(sim_lengths_long, aes(x = sim_length, fill = strategy, color = strategy)) +
  geom_density(alpha = 0.1) + 
  facet_wrap(~growth_rate) +
  labs(title = "POMDP performance against ADT",
       x = "Simulation Length",
       y = "Density") 


ggsave("../visualizations/Simulation_Lengths_full.png", width = 10, height = 6, units = "in")



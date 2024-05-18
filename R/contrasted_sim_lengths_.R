#make a df for contrasts
contrasted_sim_lengths <- sim_lengths %>%
  
  filter(growth_rate != 0.1) %>%
  
  #make growth rate a factor
  mutate(growth_rate = as.factor(growth_rate),
         short_vs_adt = Short - ADT,
         medium_vs_adt = Medium - ADT,
         long_vs_adt = Long - ADT) %>% 
  
  #pivot to long format for ease of plotting
  pivot_longer(cols = contains("vs"), values_to = "sim_length", names_to = "contrast") %>% 
  
  #only keep usefull columns
  select(contrast, sim_length, growth_rate)

#plot histograms of sim lengths and facet by growth rate
plot <- ggplot(contrasted_sim_lengths, aes(x = sim_length, fill = contrast, color = contrast)) +
  geom_density(alpha = 0.1) +
  xlim(-75, 75) +
  facet_wrap(~growth_rate) +
  # add line a 0
  geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.5) +
  labs(title = "POMDP performance against ADT",
       x = "Difference against ADT in same run",
       y = "Density")
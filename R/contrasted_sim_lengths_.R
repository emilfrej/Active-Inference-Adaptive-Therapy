#plot histograms of sim lengths and facet by growth rate
plot <- ggplot(contrasted_sim_lengths, aes(x = change_in_percent, fill = contrast, color = contrast)) +
  geom_density(alpha = 0.1) +
  facet_wrap(~growth_rate) +
  # add line a 0
  geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.5) +
  labs(title = "POMDP performance against ADT",
       x = "Difference against ADT in same run",
       y = "Density")
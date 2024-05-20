#for certain timepoints
## construct a dataframe with relevant timepoints

fep_components <- single_trial_full_data
## plot the expected free energy components for course of action as barcharts
ggplot(fep_components, aes(x = timestep)) +
  
  #plot expected utility
  geom_bar(aes(y = expected_utility, fill = "Expected Utility"), stat = "identity")  +
                 
 #plot expected info gain
  geom_bar(aes(y = expected_info_gain, fill = "Expected Information Gain"), stat = "identity") +
  
  #set colors to yellow and purple
  scale_fill_manual(values = c("Expected Utility" = "yellow", "Expected Information Gain" = "purple")) +
  
  #plot a hline at 0
  geom_hline(yintercept = 0, linetype = 15, alpha = 1) +
  
  #set y-lab to expected free energy
  labs(y = "Expected Free Energy", x = "Time") +
  
  #title to expected free energy components
  ggtitle("Expected Free Energy Components for Top Policy") +
  
  #remove fill title
  guides(fill = guide_legend(title = NULL)) +
  
  #move legend below plot
  theme(legend.position = "bottom") 

#save the plot
ggsave("visualizations/fep_components.png", plot, width = 10, height = 5, units = "in", dpi = 300)


   
%toy example


%% States / outcomes
patient = [1, 0]; % alive, dead % outcome

tumor = [1,0,0,0,0]; %cancer level, 1 is smallest, 5 is largest

resistance = [0,1,0,0,0]; % .0, .2, .4, .6, .8, and 1

treatment = [1,0]; % off, on

%% POMDP

%priors over stateds are equal to states
d{1} = patient

d{2} = tumor

%resistance
d{3} = [.2, .2, .2, .2, .2]

%likelihood mappings
%for patient status

a{1} = zeros(length(patient), length(tumor), length(resistance), length(patient), length(treatment))

for i = i:length(patient)
    for j = j:length(tumor)
        for k = k:length(resistance)
            for l = l:length(patient)
                for n = n:length(treatment)
                    
                    %if patient is alive, set likelihood mapping for observing alive patient to 1 
                    %observing alive patient
                    if i == 1 && n == 1 ;
                       a{1}(i, j, k, l, n) = 1;

                    else %otherwise set it to zero
                        a{1}(i, j, k, l, n) = 0;
                    end
                end
            end
        end
    end
end


%% simulation conditions
tumor_progression_chance = 0.3;

p_resistance_increase = 0.5;

p_resistance_decrease = [.0, .2, .7, .8, .9];

p_treatment_success = [1, .8, .6, .4, .2];

time_steps = 100

%% record data
%set empty array
data = zeros(time_steps, 3);

%loop
for i = 1:time_steps

    %get old tumor level
    tumor_level = find(tumor, 1);

    %check if progression 
    tumor_level = tumor_level + binornd(1,tumor_progression_chance,1,1);
    
    %record tumor_level
    data(i, 1) = tumor_level;

    %break loop if patient died
    if tumor_level == 6;
        break
    end

    %begin treatment if tumor_level is more than 3
    if tumor_level > 3; 
        treatment = [0, 1];
    end

    %stop when it is less than 2
    if tumor_level < 2;
       treatment = [1,0];
    end

    if treatment == [1,0];
        treatmentONOFF = 0;
    else
        treatmentONOFF = 1;
    end

    %find resistance level
    resistance_level = find(resistance, 1);
  

    %If treatment is on
    if treatment(2) == 1;
        %reduce tumor level with lower probs when resistance level
        %increases
        tumor_level = tumor_level - binornd(1, p_treatment_success(resistance_level),1,1);

        %increase resistance if treatment is given if resistance less than
        %5
        if resistance_level < 5;
            resistance_level = resistance_level + binornd(1, p_resistance_increase,1,1); 
        end
        if (0 < resistance_level && resistance_level < 6);
            resistance = [0,0,0,0,0];
            resistance(resistance_level) = 1;
        end

    end
        %If treatment is off
    if treatment(1) == 1;
        
        %decrease resistance if treatment is given
        if resistance_level > 1;
            resistance_level = resistance_level - binornd(1, p_resistance_decrease(tumor_level),1,1); 
        end 

        %set new resistance state if it doesn't exceed vector
        if (0 < resistance_level && resistance_level < 6);
            resistance = [0,0,0,0,0];
            resistance(resistance_level) = 1;
        end
    end

    %reset index
    tumor = [0,0,0,0,0];

    %set index of new level. 
    tumor(tumor_level) = 1;

    %record variable
    data(i, 2) = resistance_level;
    data(i, 3) = treatmentONOFF;

end

plot(data(:, 1) , 'b-');



hold on;

plot(data(:, 2), 'r--');

plot(data(:, 3), 'o')

xlabel('Time');

ylim([-1, 7]);


legend('Tumor Level', 'Resistance Level', "Treatment");

hold off;











%% simulation conditions
p_resistance_increase = 0.5;

tumor_progression_chance = 0.3;

p_resistance_decrease = [.0, .2, .7, .8, .9];

p_treatment_success = [1, .8, .6, .4, .2];

time_steps = 100;

%% States / observations

tumor = [1,0,0,0,0]; %cancer level, 1 is smallest, 5 is largest

tumor_observation = tumor;

resistance = [0,1,0,0,0]; % .0, .2, .4, .6, .8, and 1

patient = [1, 0]; % alive, dead 

patient_observation = patient;

treatment = [1,0]; % off, on

treatment_observation = treatment;


%% POMDP 
%priors over stateds are equal to states
d{1} = patient;

d{2} = tumor;

%resistance
d{3} = [.2, .2, .2, .2, .2];

%likelihood mappings

%for patient status (alive/dead)
a{1} = zeros(length(patient_observation), length(tumor), length(resistance), length(patient), length(treatment));

for i = 1:length(patient_observation)
    for j = 1:length(tumor)
       for k = 1:length(resistance)
            for l = 1:length(patient)
                for n = 1:length(treatment)
 
                    %if patient dimension and observation dimension correponds
                    %to alive (1), set likelihood mapping to 1
                    if i == l;
                       a{1}(i, j, k, l, n) = 1;

                    end
                end
            end
        end
    end
end

%for tumor_level
a{2} = zeros(length(tumor_observation), length(tumor), length(resistance), length(patient), length(treatment));

for i = 1:length(tumor_observation)
    for j = 1:length(tumor)
        for k = 1:length(resistance)
            for l = 1:length(patient)
                for n = 1:length(treatment)
 
                     %if tumor (state) and tumor_observation index is the same, set likelihood mapping to 1
                    if i == j;
                       a{2}(i, j, k, l, n) = 1;

                    end
                end
            end
        end
    end
end


%for treatment
a{3} = zeros(length(treatment_observation), length(tumor), length(resistance), length(patient), length(treatment));

for i = 1:length(treatment_observation)
    for j = 1:length(tumor)
        for k = 1:length(resistance)
            for l = 1:length(patient)
                for n = 1:length(treatment)
 
                     %if treatment_obs and treatment (state) index is the same, set likelihood mapping to 1
                    if i == n;
                       a{3}(i, j, k, l, n) = 1;

                    end
                end
            end
        end
    end
end

% transition probabilities. Rows are next state, columns are current state, and depth is action. One matrix for each factor

% tumor set all transition probabilities to zero
b{1} = zeros(length(tumor),length(tumor), length(treatment))

%The diagonal is chance of staying in the same state. One Below the
%diagonal is the chance of going one level up. One above the diagonal is
%the chance of going level down.

%b{1}(:,:,1) is no treatment
for i = 1:length(tumor)
    for j = 1:length(tumor)

        %if the row index is 1 larger than column index set no treatment
        %matrix to progression risk
        if i-j == 1;

            b{1}(i,j,1) = tumor_progression_chance;
        
        %if on the diagonal set probability to 1-tumor_progression chance
        %if no treatment is given
        elseif i == j;

            b{1}(i,j,1) = 1 - tumor_progression_chance;

            %% How to model different progression chances depending on another state? 
            b{1}(i,j,2) = 1 - tumor_progression_chance * 
        end
    end
end




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

set(legend,...
    'Position',[0.158035714285714 0.803571428571429 0.195535714285714 0.0904761904761905]);

hold off;














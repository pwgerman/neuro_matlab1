function estimate_position_freezing(animalname, day_list)
% calls w_estimate_postition which modifies smkim's original
% estimate_position by allowing for a vector of cmperpix values
% and only calculating stress epochs by option value.
%
% This function was previously called: estimate_position_script

%animalname = 'Eliot';
%day_list = 1:7;

animal = animaldef(animalname, 'outputstruct', 1)
cd(animal.dir);  

% parameters to test
epochs = [2 3]; % only calculate freezing in epochs 2 & 3
half_list = .1; %[.1 .25 .4];
epsilon_list = .5; % [.25 .5 .75 1];
duration_list = 2; %[ 1 2 3];

for half = half_list
    for epsilon = epsilon_list
        for duration = duration_list           
            for day = day_list
                clear estpos;
                
                cmppfile = [animal.pre,'cmperpix.mat']
                load(cmppfile);
                cmperpixDay = cmperpix{day}; %pos{day}{}.cmperpixel; %cmperpix{2-rem(day,2)} % alternate for each day
                
                est_pos_params = struct('centimeters_per_pixel', {cmperpixDay},...
                    'front_back_marker_weights', [1 0],'loess_halfwidth', .75,...
                    'num_loess_iterations', 4);
                est_pos_params.rrm_halfwidths = [half half half];
                est_pos_params.epsilon = epsilon;
                est_pos_params.min_stop_duration = duration; % default =.5
                est_pos_params.min_front_back_separation = 1;
                
                est_pos_params
                
                filename = [animal.pre,'rawpos0', num2str(day),'.mat']
                %outputfile = [animal.pre,'estpos0', num2str(day),'-h', num2str(half), '-d', num2str(duration), '-e',num2str(epsilon), '.mat']
                outputfile = [animal.pre,'estpos0', num2str(day), '.mat']
                
                rawpos = load(filename, 'rawpos');
                rawpos = rawpos.rawpos{day};
                %estpos{1} = w_estimate_position(rawpos, est_pos_params);
                estpos{day} = w_estimate_position(rawpos, 'centimeters_per_pixel', {cmperpixDay},...
                    'front_back_marker_weights', [1 0],'loess_halfwidth', .75,...
                    'num_loess_iterations', 4, 'rrm_halfwidths',[half half half],...
                    'epsilon', epsilon, 'min_stop_duration', duration, 'min_front_back_separation',1,...
                    'epochs', epochs);
                save(outputfile,'est_pos_params','estpos');              
            end
        end
    end
end


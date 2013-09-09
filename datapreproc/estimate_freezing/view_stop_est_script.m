function est_freeze_times = view_stop_est(ANIMPREFIX)
% aggregate freeze estimates

% for aggregating the freeze times calculated by the
% estimate_position_scripts

%ANIMPREFIX =   'Jig'; % 'Buk'; % 'Cum'

tmptimes = load([ANIMPREFIX,'freezetimes.mat']); % matrix of manually scored freezing times
freeze_times = tmptimes.freeze_times;

clear diff_average time_diff epoch end_time est_freeze_times effect_diff h e d day epoch estpos;

h =1;
for half = .1%[.1 .2];
    e = 1;
    for epsilon = .5%[.5 .6]
        d = 1;
        for duration = 1 %[.5 1 1.5 2]
            time_diff = []; %initialize new matrix for holding difference between estimate and manual score
            for day = 1:5
                
                %epoch.stress = 2+rem(day,2); % alternate for each day; Cummings shock is epoch=3 on day=1
                %epoch.control = 2+rem(day+1,2);
                epoch.stress = 2+rem(day,2); % alternate for each day; Bukowski shock is epoch=3 on day=1
                epoch.control = 2+rem(day+1,2);
                
                filename = [ANIMPREFIX,'estpos0', num2str(day),'-h', num2str(half), '-d', num2str(duration), '-e',num2str(epsilon), '.mat'];              
                estpos = load(filename, 'estpos');
                
                % for Buk, use day; Cum use 1
                %if strcmp(ANIMPREFIX,'Cum')
                %    estpos = estpos.estpos{1};  % estpos.estpos{day};
                %else
                    estpos = estpos.estpos{day};
                %end
                
                end_time.stress = min([18000 size(estpos{epoch.stress}.data,1)]); % restrict to first 10 minutes
                end_time.control = min([18000 size(estpos{epoch.control}.data,1)]); % restrict to first 10 minutes
                
                % calculate freezing time in seconds for each session
                est_freeze_times.stress{day}(h,d,e) = sum(estpos{epoch.stress}.data(1:end_time.stress,10))/30; 
                est_freeze_times.control{day}(h,d,e) = sum(estpos{epoch.control}.data(1:end_time.control,10))/30; 
                %freeze_times{day}{h}{d}{e}{epoc} = [filename, num2str(epoc), num2str(epoch)]; % use this line to test indexing

                time_diff.stress(day) = est_freeze_times.stress{day}(h,d,e) - freeze_times.stress(day);
                time_diff.control(day) = est_freeze_times.control{day}(h,d,e) - freeze_times.control(day);
                
                effect_diff{day}(h,d,e) = est_freeze_times.stress{day}(h,d,e) - est_freeze_times.control{day}(h,d,e);
                
                %[hyp,p,ci,stats] = ttest(diff); % statistical difference of estimate and manual score
                %prob(h,d,e) = p;
            
                %[hyp,p,ci,stats] = ttest(diff(epoc,:)); % statistical difference of estimate and manual score
                %prob{epoc}(h,d,e) = p;
                
                diff_average.stress(h,d,e) = mean(time_diff.stress(:));
                diff_average.control(h,d,e) = mean(time_diff.control(:));
            end
            d = d+1; % advance duration counter
        end
        e=e+1; % advance epsilon counter
    end
    h = h +1; % advance halfwidth counter
end


% NOTE: The output of  estimate_position_script SHOULD be to have each day
% as index for the location in the first cell dimension.  Currently, they
% are all in position 1.
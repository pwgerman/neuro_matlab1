% script to calc output of rungetripactivprob
% display_rungetripactivprob_output.m

fout = [];
bargroup = [];

% does this replicat the functionality of structure_group_combine ??
for stage = 1:length(f)
    for an = 1:length(f{stage})
        for g = 1:length(f{stage}(an).output)
            try
                %fout{stage}{g} = [fout{stage}{g};  f{stage}(an).output{g}];
                fout{stage}{g} = [fout{stage}{g};an*ones(size(f{stage}(an).output{g}, 1),1)  f{stage}(an).output{g}];
            catch
                %fout{stage}{g} = [f{stage}(an).output{g}];
                fout{stage}{g} = [an*ones(size(f{stage}(an).output{g}, 1),1)  f{stage}(an).output{g}];
            end
        end
    end
end

figure;
hold on;
for stage = 1:length(f)
    numsampgroup = [];
    for i= 1:length(fout{stage})
        disp(['n= ' num2str(size(fout{stage}{i},1))]);
        numsamp(i) = size(fout{stage}{i},1);
        numsampgroup = [numsampgroup, ' n=',num2str(numsamp(i))];
        disp([nanmean(fout{stage}{i}) sem(fout{stage}{i})]);
    end
    
    if length(fout{stage}) == 2
        [h,p] = ttest2(fout{stage}{1}(:,6), fout{stage}{2}(:,6));
        disp(['p= ' num2str(p)]);
        for i = 1:length(fout{stage})
            bargroup{i} = fout{stage}{i}(:,6);
        end
        [handle, hb] = barsem2(bargroup);
        title(['Reactivation of PF cells in Stres Tracks:' ' ttest p= ' num2str(p,1)]);
        ylabel('cell reactiv prob');
        set(gca,'XTickLabel',{'RipShk,PF-C', 'RipCtrl,PF-C'})
        legend(gca, ['n=',num2str(numsamp(1)),', n=', num2str(numsamp(2))]);
    elseif length(fout{stage}) > 2
        sample = [];
        group = [];
        for i = 1:length(fout{stage})
            sample = [sample; fout{stage}{i}(:,6)];
            group = [group; i*ones(length(fout{stage}{i}(:,6)),1)];
        end
        ds = dataset(group, sample);
        p = anova1(sample, group, 'off')
        for i = 1:length(fout{stage})
            bargroup{i} = fout{stage}{i}(:,6);
            bargroup{i} = bargroup{i}(~isnan(bargroup{i})); % remove NaN
        end
        subplot(2,2,stage);
        
        [handle, hb] = barsem2(bargroup);
        title(['Reactivation of PF cells in Stress Tracks: day=', num2str(fout{stage}{1}(1,2)) ' ANOVA p= ' num2str(p,1)]);
        ylabel('cell reactiv prob');
        %set(gca,'XTickLabel',{'RipShk,PFShk', 'RipCtrl,PFShk', 'RipShk,PFCtrl', 'RipCtrl,PFCtrl'})
        set(gca,'XTickLabel',{'RipShk,PF-C', 'RipCtrl,PF-C', 'RipShk,PFlinear', 'RipCtrl,PFlinear'})
        legend(gca, numsampgroup);
    end
end

% this bit will plot place fields, but currently gets tied up on
% vectorfill.mex function for some epochs.  What about those epochs causes
% the slow up?
%{
for i = 1:size(fout{1}{1},1)
    switch fout{1}{1}(i,1) % animal#
        case 1
            plotrunepochs('Bukowski', fout{1}{1}(i,2:5))
        case 2
            plotrunepochs('Cummings', fout{1}{1}(i,2:5))
        case 3
            plotrunepochs('Dickinson', fout{1}{1}(i,2:5))
        case 4
            plotrunepochs('Eliot', fout{1}{1}(i,2:5))
        case 5
            plotrunepochs('Jigsaw', fout{1}{1}(i,2:5))
    end
    pause;
end
%}

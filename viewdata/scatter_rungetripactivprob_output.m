% script to calc output of rungetripactivprob
% scatter_rungetripactivprob_output.m

fout = [];
bargroup = [];

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


%rowindex = rowfind(fout{4}{2}(:,[1 2 4 5]), fout{4}{1}(:,[1 2 4 5]));
%setlist = [{'firstonly'}, {'secondonly'}, {'intersect'}]; %
setlist = [{'shock only'}, {'control only'}, {'intersect'}]; %
%grouplist = [{'shock'}, {'control'},{'sleep1'},{'sleep2'}];
grouplist = [{'sleep1'}, {'run1'},{'run2'},{'sleep2'}];

figure;
set(gcf, 'Color', [1 1 1]);
hold on;
count =1;
for stage = 1:length(fout)
    for g = 1:(length(fout{stage})-1)
        for g2 = (g+1):length(fout{stage})
            g2index = rowfind(fout{stage}{g}(:,[1 2 4 5]), fout{stage}{g2}(:,[1 2 4 5])); %index for g2 display
            g2index = g2index(g2index>0);
            gindex = rowfind(fout{stage}{g2}(:,[1 2 4 5]), fout{stage}{g}(:,[1 2 4 5])); % for g display
            gindex = gindex(gindex>0);
            %scatter(1:length(fout{1}{2}(:,6)), fout{1}{2}(:,6), [], fout{1}{2}(:,1), 'filled')
            subplot(length(fout),6, count);
            hold on;
            %scatter(fout{stage}{g}(gindex,6), fout{stage}{g2}(g2index,6), [], fout{stage}{g}(gindex,1), 'filled');
            if count == 1         
                gscatter(fout{stage}{g}(gindex,6), fout{stage}{g2}(g2index,6), fout{stage}{g}(gindex,1));
            else
                gscatter(fout{stage}{g}(gindex,6), fout{stage}{g2}(g2index,6), fout{stage}{g}(gindex,1),[],[],[],'off');
            end
            xlabel([grouplist{g}]);
            ylabel([grouplist{g2}]);
            axisMax = .4;
            axis([0 axisMax 0 axisMax]);
            plot([0 axisMax], [0 axisMax], ':k');
            %pause;
            count = count+1;
        end
    end
    subplot(length(fout),6, count-6); 
    title(['Place Field in ', setlist{stage}]);
end
%subplot(length(fout),6, 1); 
%legend(['Buk', 'Cum', 'Dic', 'Eli', 'Jig']);


%{
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
        [handle, hb] = barsem2(bargroup);
        
        title(['Reactivation of PF cells in Stress Tracks: day=', num2str(fout{stage}{1}(1,2)) ' ANOVA p= ' num2str(p,1)]);
        ylabel('cell reactiv prob');
        %set(gca,'XTickLabel',{'RipShk,PFShk', 'RipCtrl,PFShk', 'RipShk,PFCtrl', 'RipCtrl,PFCtrl'})
        set(gca,'XTickLabel',{'RipShk,PF-C', 'RipCtrl,PF-C', 'RipShk,PFlinear', 'RipCtrl,PFlinear'})
        legend(gca, numsampgroup);
    end
end
%}


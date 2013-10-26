% scatter_rungetripactivprob_multiday_norm
%   finds normalized value of reactivation.
%   normalizes to the reactivation of a cell in sleep epoch 1.
%
% script to calc output of rungetripactivprob
% scatter_rungetripactivprob_multiday
% takes multiple runs of rungetripactivprob across a few days and then
% saved as f1, f2 ,... for days 1,2 etc... 
% then all days are concatenated and plotted together.

mfout = [];
%varlist = [{'f1'},{'f2'},{'f3'},{'f4'}];

for varnum = 1:length(mf)
    for stage = 1:length(mf{varnum})
        for an = 1:length(mf{varnum}{stage})
            for g = 1:length(mf{varnum}{stage}(an).output)
                try
                    %fout{stage}{g} = [fout{stage}{g};  f{stage}(an).output{g}];
                    mfout{stage}{g} = [mfout{stage}{g};an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                catch
                    %fout{stage}{g} = [f{stage}(an).output{g}];
                    mfout{stage}{g} = [an*ones(size(mf{varnum}{stage}(an).output{g}, 1),1)  mf{varnum}{stage}(an).output{g}];
                end
            end
        end
    end
end

%rowindex = rowfind(fout{4}{2}(:,[1 2 4 5]), fout{4}{1}(:,[1 2 4 5]));
%setlist = [{'firstonly'}, {'secondonly'}, {'intersect'}]; %
setlist = [{'shock only'}, {'control only'}, {'intersect'}]; %
%setlist = [{'shock only'}, {'control only'}, {'neither'}]; %
%setlist = [{'C-track only'}, {'linear track only'}, {'intersect'}];
%setlist = [{'epoch2 only'}, {'epoch3 only'}, {'intersect'}];
grouplist = [{'sleep1'},{'shock'}, {'control'},{'sleep2'}];
%grouplist = [{'sleep1'}, {'run1'},{'run2'},{'sleep2'}];
%grouplist = [{'sleep1'}, {'C-track'},{'linear'},{'sleep2'}];
%grouplist = [{'w1'},{'w2'}];

figure;
set(gcf, 'Color', [1 1 1]);
hold on;
count =1;
for stage = 1:length(mfout)
    for g = 1 %:(length(mfout{stage})-1)
        for g2 = (g+1):length(mfout{stage})
            g2index = rowfind(mfout{stage}{g}(:,[1 2 4 5]), mfout{stage}{g2}(:,[1 2 4 5])); %index for g2 display
            g2index = g2index(g2index>0);
            gindex = rowfind(mfout{stage}{g2}(:,[1 2 4 5]), mfout{stage}{g}(:,[1 2 4 5])); % for g display
            gindex = gindex(gindex>0);
            %scatter(1:length(fout{1}{2}(:,6)), fout{1}{2}(:,6), [], fout{1}{2}(:,1), 'filled')
            subplot(length(mfout),3, count);
            hold on;
            normout = mfout{stage}{g2}(g2index,6)./mfout{stage}{g}(gindex,6);
            %scatter(fout{stage}{g}(gindex,6), fout{stage}{g2}(g2index,6), [], fout{stage}{g}(gindex,1), 'filled');
            if count == 1 %| count == 13  % add legend     
                gscatter(mfout{stage}{g}(gindex,6), normout, mfout{stage}{g}(gindex,1));
            else
                gscatter(mfout{stage}{g}(gindex,6), normout, mfout{stage}{g}(gindex,1),[],[],[],'off');
            end 
            xlabel([grouplist{g}]);
            ylabel([grouplist{g2}]);
            axisMax = 4;
            %axis([0 axisMax 0 axisMax]);
            %plot([0 axisMax], [0 axisMax], ':k');
            %pause;
            %{
            % the variables below are just for pull out variables from the
            % plot to be used for statistics after this script is run.
            % They are not used in the script itself.
            if count == 4
                concurr_sh = mfout{stage}{g}(gindex,6); % PFsRs
                replay_ct = mfout{stage}{g2}(g2index,6); %PFsRc
            elseif count == 10
                replay_sh = mfout{stage}{g}(gindex,6); %PFcRs
                concurr_ct = mfout{stage}{g2}(g2index,6);  % PFcRc
            end
            % end pulling variables out of script
            %}
            count = count+1;
            preplay{stage} = mfout{stage}{g}(:,6);
            replay{stage} = mfout{stage}{4}(:,6);
        end
    end
    %subplot(length(mfout),6, count-6); 
    %subplot(length(mfout),6, count);  % for only 2 days
    %title(['Place Field in ', setlist{stage}]);
end
figure;
set(gcf, 'Color', [1 1 1]);
hold on;
for stage = 1:3
    %hist(preplay{stage}, 0:.01:.39)
    F(stage) = cdfplot(preplay{stage});
end
set(F(1),'LineWidth',2,'Color','r')
set(F(2),'LineWidth',2)
set(F(3),'LineWidth',2,'Color','m')
legend([F(1) F(2) F(3)],'shock','ctrl','both','Location','NW');
title('CDF of Place Field cell reactivation probability in Sleep1');

[h,p,k] = kstest2(preplay{2},preplay{3});


figure;
set(gcf, 'Color', [1 1 1]);
hold on;
for stage = 1:3
    %hist(preplay{stage}, 0:.01:.39)
    F(stage) = cdfplot(replay{stage});
end
set(F(1),'LineWidth',2,'Color','r')
set(F(2),'LineWidth',2)
set(F(3),'LineWidth',2,'Color','m')
legend([F(1) F(2) F(3)],'shock','ctrl','both','Location','NW');
title('CDF of Place Field cell reactivation probability in Sleep2');


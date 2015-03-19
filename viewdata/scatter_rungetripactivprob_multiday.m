% scatter_rungetripactivprob_multiday
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
set(gcf, 'Color', [1 1 1]); % set grey bg to white
hold on;
count =1;
for stage = 1:length(mfout)
    for g = 1:(length(mfout{stage})-1)
        for g2 = (g+1):length(mfout{stage})
            if  isempty(mfout{stage}{g})
                mfout{stage}{g} = zeros(1,6);
            elseif isempty(mfout{stage}{g2})
                mfout{stage}{g2} = zeros(1,6);               
            end
            g2index = rowfind(mfout{stage}{g}(:,[1 2 4 5]), mfout{stage}{g2}(:,[1 2 4 5])); %index for g2 display
            g2index = g2index(g2index>0);
            gindex = rowfind(mfout{stage}{g2}(:,[1 2 4 5]), mfout{stage}{g}(:,[1 2 4 5])); % for g display
            gindex = gindex(gindex>0);
            %scatter(1:length(fout{1}{2}(:,6)), fout{1}{2}(:,6), [], fout{1}{2}(:,1), 'filled')
            subplot(length(mfout),6, count);
            hold on;
            %scatter(fout{stage}{g}(gindex,6), fout{stage}{g2}(g2index,6), [], fout{stage}{g}(gindex,1), 'filled');
            if count == 1 | count == 13  % add legend     
                gscatter(mfout{stage}{g}(gindex,6), mfout{stage}{g2}(g2index,6), mfout{stage}{g}(gindex,1));
            else
                gscatter(mfout{stage}{g}(gindex,6), mfout{stage}{g2}(g2index,6), mfout{stage}{g}(gindex,1),[],[],[],'off');
            end 
            xlabel([grouplist{g}]);
            ylabel([grouplist{g2}]);
            axisMax = .4;
            axis([0 axisMax 0 axisMax]);
            plot([0 axisMax], [0 axisMax], ':k');
            %pause;
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
            count = count+1;
        end
    end
    subplot(length(mfout),6, count-6); 
    %subplot(length(mfout),6, count);  % for only 2 days
    title(['Place Field in ', setlist{stage}]);
end

% save file info
%picpre = 'freezetimes_estpos';
savedir = '/home/walter/Desktop/sfn2013-images/';
filenameout = 'scatter1'; %[picpre, num2str(picind)];
% save output for adobe illustrator
print('-depsc','-r300',[savedir,filenameout,'.ai']);
print('-djpeg','-r300',[savedir,filenameout,'.jpg']);

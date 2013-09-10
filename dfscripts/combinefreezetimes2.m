function out = combinefreezetimes2(tmpfout)
% out = COMBINEFREEZETIMES2(tmpfout)
% uses the fout  output of runrunriprate.  It will attempt to combine the
% freezing times from estpos such that they can be passed to
% numericgroupcombine or made into a similarly compatable format to be used
% for correlations with the ripple rates in a given recording session.


% display the freezing times as determined by exclude times
% disp('freeze times');
tfilter = 2; % the number of the time filter with freezing.  runriprate:timefilter{2}
missedcount = 0;
out = [];

%tmpfout = fout{frz}{trk}; from runrunriprate script

for an = 1:length(tmpfout);
    % freeze, track, animal, (.timefilterresults), day, epoch, (estpos=2),
    % freezing<0or1>is (:,2)
    tmp2fout = tmpfout(an).timefilterresults;
    for d = 1:length(tmp2fout{tfilter})
        for e = 1:length(tmp2fout{tfilter}{d})
            if ~isempty(tmp2fout{tfilter}{d}{e})
                try
                    %disp(sum(tmp2fout{tfilter}{d}{e}(:,2))/30);
                    out = [out ; an d e sum(tmp2fout{tfilter}{d}{e}(:,2))/30];
                    %disp(fout{frz}{trk}(an).timefilterresults)
                    %disp(sum(fout{frz}{trk}(an).timefilterresults{2}{1}{2}(:,2))/30)
                catch
                    missedcount = missedcount +1;
                end
            end
            % make an falt.output to send to numericgroupcombine.
        end
    end
end
out;
%disp(['missed = ' num2str(missedcount)]);






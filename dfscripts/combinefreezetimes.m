% combinefreezetimes
% uses the fout  output of runrunriprate.  It will attempt to combine the
% freezing times from estpos such that they can be passed to
% numericgroupcombine or made into a similarly compatable format to be used
% for correlations with the ripple rates in a given recording session.


% display the freezing times as determined by exclude times
disp('freeze times');
tfilter = 2; % the number of the time filter with freezing.  runriprate:timefilter{2}
missedcount = 0;
out = [];
for frz = 1: length(fout)     % freezing or not
    for trk = 1: length(fout{frz})    % c or linear track
        tmpfout = fout{frz}{trk};
        for an = 1:length(tmpfout);
            % freeze, track, animal, (.timefilterresults), day, epoch, (estpos=2),
            % freezing<0or1>is (:,2)
            tmp2fout = tmpfout(an).timefilterresults;
            for d = 1:length(tmp2fout{tfilter})
                for e = 1:length(tmp2fout{tfilter}{d})
                    if ~isempty(tmp2fout{tfilter}{d}{e})
                        try
                            %disp(sum(tmp2fout{tfilter}{d}{e}(:,2))/30);
                            out = [out ; frz trk an d e sum(tmp2fout{tfilter}{d}{e}(:,2))/30];                            
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
    end
end
disp(['missed = ' num2str(missedcount)]);






% script to calc output of rungetripactivprob
% display_rungetripactivprob_output.m

fout = [];
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

for stage = 1:length(fout)
    for i= 1:length(fout{stage})
        disp(size(fout{stage}{i}));
        disp([nanmean(fout{stage}{i}) sem(fout{stage}{i})]);
    end
end



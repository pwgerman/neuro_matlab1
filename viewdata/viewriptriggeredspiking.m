% viewriptriggeredspiking

try ~isempty(f.output{1}(1).c1vsc2);
    disp('Using previous f.output. Clear f to recalculate.');
catch
    runriptriggeredspiking;
end

for d = 1:length(f.output)
for e = 1:length(f.output{d})
    sumriptrig = zeros(size(f.output{d}(e).time));
    
    %plot each riptriggered average in sequence
    if ~isempty(f.output{d}(e).c1vsc2)
        for ii= 1:length(f.output{d}(e).c1vsc2(:,1))
            plot(f.output{d}(e).time, f.output{d}(e).c1vsc2(ii,:));
            title(['day ' num2str(f.epochs{1}(e,1)), '  epoch ', num2str(f.epochs{1}(e,2)), ' cellpair ', num2str(ii)]);
            pause
            
            sumriptrig = sumriptrig + f.output{d}(e).c1vsc2(ii,:);
        end
        
        
        plot(f.output{d}(e).time, sumriptrig);
        title(['day-epoch ' num2str(f.epochs{1}(e,:))]);
        pause;
    end
end
end


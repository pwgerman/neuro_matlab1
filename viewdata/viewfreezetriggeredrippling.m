% viewfreezetriggeredrippling
% visualize output from script runfreezetriggeredrippling
% for animals

an = 5;
% test for output
try ~isempty(f(an).output{1}(1).c1vsc2);
    disp('Using previous f.output. Clear f to recalculate.');
catch
    runfreezetriggeredrippling;
end

for an = 1:5
    for d = 1:length(f(an).output)
        for e = 1:length(f(an).output{d})
            %plot each riptriggered average in sequence
            if ~isempty(f(an).output{d}(e).c1vsc2)
                plot(f(an).output{d}(e).time, f(an).output{d}(e).c1vsc2);
                title(['animal ' num2str(an) '  day ' num2str(f(an).epochs{1}(e,1)), '  epoch ', num2str(f(an).epochs{1}(e,2))]);
                keyboard;%pause
            end
        end
    end
end

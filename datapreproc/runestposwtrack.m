% combine datastructs

more off;
for day = 6:9
    tic;
    try
        estimate_position_freezing_wtrack('Bukowski', day);
    catch
        disp('estpos failed');
    end
    toc
end

for day = 6:10   
    tic;
    try
        estimate_position_freezing_wtrack('Cummings', day);
    catch
        disp('estpos failed')
    end
    toc
end

for day = 6:14
    tic;
    try
        estimate_position_freezing_wtrack('Eliot', day);
    catch
        disp('estpos failed')
    end
    toc
end

for day = 6:8
    tic;
    try
        estimate_position_freezing_wtrack('Jigsaw', day);
    catch
        disp('estpos failed');
    end
    toc
end
more on;

%testmatfiles
% this code is for loading files that were found by r-studio and identified
% as previously deleted .mat files.  This code attempts to read variable in
% them and if that succeeds it attemps to load the file.  It then enters
% the results into a log that shows which files are viable and which are
% corrupted.
%
% Walter German 2013-04-16

min = 4292;  % crashed on 4291
max = 5440; %5440;
log = cell(max,2);

for num = min:max
    try
        matObj = matfile([num2str(num),'.mat']);  
        s = whos(matObj);    
        try
            log{num,1}= s.name; %disp(s.name);
            
            if 1
                try
                    load([num2str(num),'.mat']);
                    log{num, 2}= (['file ',num2str(num),'.mat  successfully loaded']);
                catch err
                    log{num,2}= ('corrupt file'); % disp('    corrupt file');
                end
            end
        catch
            log{num, 1}= ('none');
        end
    catch
        log{num, 1}= ('not MAT');
    end
end
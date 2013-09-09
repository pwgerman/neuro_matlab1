% runrunriprate
%
% calculates stuff.


timelimit = 10;
renewcache = 0;
if renewcache
    cout = cell(1,2);
    fout = cell(1,2);
end

% cout{freeze}{shock}{c/lin}(:,n) where n=2:day, 5:riprate, 6:ripproportion
%[fout{2}{2} cout{2}{2}]= runriprate;
%[fout{1}{2} cout{1}{2}]= runriprate;
%[fout{1}{1} cout{1}{1}]= runriprate('freezeon', 0, 'shocktrackon', 0);
%[fout{2}{1} cout{2}{1}]= runriprate;

% display mean values
for freeze = 1:2
    for shock = 1:2
        if renewcache
            [fout{freeze}{shock} cout{freeze}{shock}]= runriprate('freezeon', freeze==1, 'shocktrackon', shock==1);
        end
        %disp(['freeze ' num2str(freeze) '  shock ' num2str(shock)]);
        %disp('c-track    linear-track');
        %disp(cout{freeze}{shock}{1}); % show full matrix for all animals
        %disp(cout{freeze}{shock}{2}); % show full matrix for all animals
        %disp([mean(cout{freeze}{shock}{1}(:,5))   mean(cout{freeze}{shock}{2}(:,5))]);
        %disp([sem(cout{freeze}{shock}{1}(:,5))   sem(cout{freeze}{shock}{2}(:,5))]);
        
        % display the freezing times as determined by exclude times
        cfrztimes{freeze}{shock} = combinefreezetimes2(fout{freeze}{shock});  
        compcout{freeze}{shock} = sortrows([cout{freeze}{shock}{1};cout{freeze}{shock}{2}]);
    end
end

% test within animal difference of c-linear during non-freezing (ignore
% shock v control. Each animal only has one condition of c-linear or
% shock-control, so they cannot both be controlled at the same time within
% animal.  c-track=1, linear=2
ctrack = 1;
ltrack = 2;
within = cell(2);
testvar = 5; % 5=riprate; 6=rip+proportion
for freeze = 1:2
    % subtact tracks within animal
    %lastcol = size(cout{freeze}{1}{ctrack} ,2); % find last column so one more can be added
    lastcol = 1;
    within{freeze}{1} = cout{freeze}{1}{ctrack}(:,testvar) - cout{freeze}{2}{ltrack}(:,testvar); % ctrack=shocktrack
    within{freeze}{2} = cout{freeze}{2}{ctrack}(:,testvar) - cout{freeze}{1}{ltrack}(:,testvar); % ctrack=controltrack
    % append includetime to last columns
    within{freeze}{1}(:,(lastcol+1)) = cout{freeze}{1}{ctrack}(:,7);
    within{freeze}{1}(:,(lastcol+2)) = cout{freeze}{2}{ltrack}(:,7);
    within{freeze}{2}(:,(lastcol+1)) = cout{freeze}{2}{ctrack}(:,7);
    within{freeze}{2}(:,(lastcol+2)) = cout{freeze}{1}{ltrack}(:,7);
    
    %disp(within{freeze}{1})
    %disp(within{freeze}{2})
    
    within{freeze}{1} = removetestrows(within{freeze}{1}, 2, timelimit);
    within{freeze}{1} = removetestrows(within{freeze}{1}, 3, timelimit);
    within{freeze}{2} = removetestrows(within{freeze}{2}, 2, timelimit);
    within{freeze}{2} = removetestrows(within{freeze}{2}, 3, timelimit);
    
    %disp(within{freeze}{1})
    %disp(within{freeze}{2})
    
    disp(['freeze ' num2str(freeze)]);
    disp('c-lin:  c=shock   lin=shock');  
    disp([mean(within{freeze}{1}(:,1))  mean(within{freeze}{2}(:,1))]); 
    disp([sem(within{freeze}{1}(:,1))  sem(within{freeze}{2}(:,1))]);
end


% same as above except compares shocktrack - controltrack
for freeze = 1:2
    % subtact tracks within animal
    %lastcol = size(cout{freeze}{1}{ctrack} ,2); % find last column so one more can be added
    lastcol = 1;
    within{freeze}{1} = cout{freeze}{1}{ctrack}(:,testvar) - cout{freeze}{2}{ltrack}(:,testvar); % shocktrack=ctrack
    within{freeze}{2} = cout{freeze}{1}{ltrack}(:,testvar) - cout{freeze}{2}{ctrack}(:,testvar); % shocktrack=linear
    % append includetime to last columns
    within{freeze}{1}(:,(lastcol+1)) = cout{freeze}{1}{ctrack}(:,7);
    within{freeze}{1}(:,(lastcol+2)) = cout{freeze}{2}{ltrack}(:,7);
    within{freeze}{2}(:,(lastcol+1)) = cout{freeze}{2}{ctrack}(:,7);
    within{freeze}{2}(:,(lastcol+2)) = cout{freeze}{1}{ltrack}(:,7);
    
    %disp(within{freeze}{1})
    %disp(within{freeze}{2})
    
    within{freeze}{1} = removetestrows(within{freeze}{1}, 2, timelimit);
    within{freeze}{1} = removetestrows(within{freeze}{1}, 3, timelimit);
    within{freeze}{2} = removetestrows(within{freeze}{2}, 2, timelimit);
    within{freeze}{2} = removetestrows(within{freeze}{2}, 3, timelimit);
    
    %disp(within{freeze}{1})
    %disp(within{freeze}{2})
    
    disp(['freeze ' num2str(freeze)]);
    disp('shock-control:  shock=c   shock=lin');  
    disp([mean(within{freeze}{1}(:,1))  mean(within{freeze}{2}(:,1))]); 
    disp([sem(within{freeze}{1}(:,1))  sem(within{freeze}{2}(:,1))]);
    
end



%{
day{1}=(cout{1}{1}{2}(:,2)==1)
day{2}=(cout{1}{1}{2}(:,2)==2)
day{3}=(cout{1}{1}{2}(:,2)==3)
day{4}=(cout{1}{1}{2}(:,2)==4)

cout{1}{1}{2}(:,5).*day{1}
%}





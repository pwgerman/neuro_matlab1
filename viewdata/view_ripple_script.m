

% variable args
param = 'maxthresh'; %'peak'; %'maxthresh'; 'energy'
riprate = 1;  % 1= ignore param and count number of ripples. 0= find mean of param for all ripples


% animal definitions
bca1 = [1 3 4 5 7 10 11];
bbca1 = [1 3 4 5 10];
cca1 = [1 4 5 6 9 10 11 12 13 16 17];
cbca1 = [1 4 5 6 9 17];
dca1 = [2 4 5 6 7 8 9 10 17 18 19];
dbca1 = [4 9 10 17 19];
eca1 = [3 7:16]; % CA1 tetrodes for Eli
ebca1 = [3 10 11 12 13]; % best CA1 tetrodes for Eli
jca1 = [1 2 4:10 13 14 17]; % CA1 tetrodes for Jig
jbca1 = [1 4 7 8 10 17]; % best CA1 tetrodes for Jig



%example for loop over names
%{ 
names = {'fred' 'sam' 'al'};
for ind = 1:length(names)
    %s.(names{ind}) = magic(length(names{ind}));
    eval([param '.(names{ind}) = magic(length(names{ind}));'])
end
%}

names = {'Buk' 'Cum' 'Dic' 'Eli' 'Jig'};
for ani = 1:length(names)  
    % prepare each animal directory
    day = 1:5; % default is days 1-5, change for individual animals as 
        % needed below
    switch names{ani}
        case 'Jig'
            cd /mnt/backup/walter/walter/phys/Jig;
            tt = jbca1; % tetrodes
            filename = 'Jigripples0';
        case 'Eli'
            cd /mnt/backup/walter/walter/phys/Eli;
            tt = ebca1;
            filename = 'Eliripples0';
        case 'Buk'
            cd /mnt/backup/walter/walter/phys/Buk;
            tt = bbca1;
            filename = 'Bukripples0';
        case 'Cum'
            cd /mnt/backup/walter/walter/phys/Cum;
            tt = cbca1;
            filename = 'Cumripples0';
        case 'Dic'
            cd /mnt/backup/walter/walter/phys/Dic;
            tt = dbca1;
            filename = 'Dicripples0';
            day = 1:4; % only 4 days for Dickinson
    end
    
    out = cell(max(day),1);
    for d = day
        load([filename, num2str(d), '.mat']);
        count = 1;
        for i = tt %i = 1:21
            for e = 1:4
                if riprate == 1
                    eval(['out{d}(count,e) = length(ripples{d}{e}{i}.', param,');']) % count ripple events
                elseif riprate == 0
                    eval(['out{d}(count,e) = mean(ripples{d}{e}{i}.', param,');'])
                end
            end
            count = count+1;
        end
    end
    
    % s.(names{ani}) = out;  % this is a cool way to index.  switch to this for subsequent analysis
    eval([param '.(names{ani}) = out;'])
    % alter the s to a variable that reflects the analysis being done.
    
    % analyse
    switch names{ani}
        case 'Buk'
            bout = out;
            b1 = [bout{1} ; bout{3}; bout{5}];
            b2 = [bout{2}; bout{4}];
        case 'Cum'
            cout = out;
            c1 = [cout{1} ; cout{3}; cout{5}];
            c2 = [cout{4}]; 
            %c2 = [cout{2}; cout{4}];  % unusually large peak in cout{2}
        case 'Dic'
            dout = out;
            d1 = [dout{1} ; dout{3}];
            d2 = [dout{2}; dout{4}];
        case 'Eli'
            eout = out;
            e1 = [eout{1} ; eout{3}; eout{5}];
            e2 = [eout{2}; eout{4}];
        case 'Jig'
            jout = out;
            j1 = [jout{1} ; jout{3}; jout{5}];
            j2 = [jout{2}; jout{4}];
    end
end

%{
both1 = [e1; j1];
both2 = [e2; j2];
mean(both1,1)
mean(both2,1)
%}

all1 = [b2; c2; d1; e1; j1];  % shock epoch 2
all2 = [b1; c1; d2; e2; j2];   % shock epoch 3
disp([mean(all1, 1); mean(all2, 1)]);  % mean across all tetrodes(means) in all ani for day order
disp([std(all1); std(all2)]);
disp([sem(all1); sem(all2)]);



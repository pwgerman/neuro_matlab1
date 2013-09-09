% ripplecount

%tmp =load('Dicripples01.mat', 'ripples');
%ripples{1} = tmp.ripples{1};
%length(ripples{d}{2}{1}.startind);% t=1

epochripsD = cell(4,3);
epochripsB = cell(8,3);
epochripsC = cell(9,3);

%{
cd /data18/walter/Dic
for d = 1:4
    ripples{d} = cell(1,8);
    tmp =load(['Dicripples0' num2str(d) '.mat'],  'ripples');
    ripples{d} = tmp.ripples{d};
    clear tmp;
    
    for e = [2 3]
        for t = 1 : length(ripples{d}{e}) %[10 14 20 21] 
            tetrips(t) =length(ripples{d}{e}{t}.startind);
        end
        epochripsD{d,e}= tetrips';
        clear tetrips;
    end
end
%}

cd /data18/walter/Buk
for d = 1:8
    ripples{d} = cell(1,8);
    tmp =load(['Bukripples0' num2str(d) '.mat'],  'ripples');
    ripples{d} = tmp.ripples{d};
    clear tmp;
    
    for e = [2 3]
        for t = [5 10] %1 : length(ripples{d}{e})
            tetrips(t) =length(ripples{d}{e}{t}.startind);
        end
        %epochripsB(d,e)= max(tetrips);
        epochripsB{d,e}= tetrips';
        clear tetrips;
    end
end

cd /data18/walter/Cum
for d = 1:9
    ripples{d} = cell(1,8);
    tmp =load(['Cumripples0' num2str(d) '.mat'],  'ripples');
    ripples{d} = tmp.ripples{d};
    clear tmp;
    
    for e = [2 3]
        for t = [10 14 20 21] %1 : length(ripples{d}{e})
            tetrips(t) =length(ripples{d}{e}{t}.startind);
        end
        %epochripsC(d,e)= max(tetrips);
        epochripsC{d,e}= tetrips';
        clear tetrips;
    end
end

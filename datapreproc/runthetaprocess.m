% runthetaprocess
%{
animalname = 'Bukowski';
days = [3 4 5];
daytetlist = [3 6; 4 6; 5 6]; % Bukowski REF=6
%}

%{
animalname = 'Cummings';
days = [1:6];
daytetlist = [1:6; ones(1,6)*8]'; % Cummings REF=8 (through day 6, then REF=13 day7 on)
%}

%{
animalname = 'Dickinson';
days = [1:4];
daytetlist = [1:4; ones(1,4)]'; % Dickinson REF=1
%}

%{
animalname = 'Eliot';
days = [1:5];
daytetlist = [1:5; ones(1,5)]'; % Eliot REF=1
%}

%{
animalname = 'Jigsaw';
days = [1:5];
tetlist=[2 5 12 13 20];
daylist = [];
tetlisttmp = [];
for d = days
    daylist= [daylist ones(1,length(tetlist))*d];
    tetlisttmp = [tetlisttmp tetlist];
end
daytetlist = [daylist; tetlisttmp]';
%}

animalname = 'Jigsaw';
days = [1:5];
daytetlist = [1:5; ones(1,5)*20]'; % Jigsaw REF=[2 5 12 13 20]

animal = animaldef(animalname, 'outputstruct', 1);
%thetadayprocess(animal.dir, animal.pre ,days);
thetadayprocess(animal.dir, animal.pre ,days, 'daytetlist', daytetlist);


% trispec2
% trigspec2 calls trigspec for all tetrodes in an epoch & plots high
% z-scores in time along with freezing scores. 

%cd /mnt/data18/walter/phys/Spec;
%load spectro-CA1-shock-ctrl-cum.mat;

animalname = f.animal{1};
animal = animaldef(animalname, 'outputstruct', 1);

estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');


g = 1;
e = 1;
nume = size(f.output{1},2);

index = f.output{g}(e).index;
x = cell(length(index(1)),length(index(2)),length(index(3)));
y = cell(length(index(1)),length(index(2)),length(index(3)));

oldday = 0;
for e = 1:nume
    index = f.output{g}(e).index;
    frztimes = estpos{index(1)}{index(2)}.data(:,10);
    postimes = estpos{index(1)}{index(2)}.data(:,1);
    vel = estpos{index(1)}{index(2)}.data(:,5);
    
    % create a new figure window to plot each day
    if index(1)>oldday
        figure;
    end
    oldday = index(1);
    
    %[tmpx,tmpy] =trigspec(f,g,e);
    [tmpx,tmpy] =trigspec(f,g,e);
    %tmpx = tmpx.*index(3);
    tmpy = tmpy+index(3);
    x{index(1)}{index(2)}{index(3)} = tmpx;
    y{index(1)}{index(2)}{index(3)} = tmpy;
    scatter(x{index(1)}{index(2)}{index(3)},y{index(1)}{index(2)}{index(3)});
    plot(postimes, frztimes, 'r')
    
end


%{
    % use when output of trigspec is out=freq(zscore(tmpindex)>=2);
freqlist = [];
for e = 1:nume
    freqlist = [freqlist trigspec(f,e)];  
end
%}
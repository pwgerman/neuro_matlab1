% trispec2_hist
% trigspec2_hist calls trigspec_hist for all tetrodes in an epoch & plots high
% z-scores in a histogram by frequency 

%cd /mnt/data18/walter/phys/Spec;
%load spectro-CA1-shock-ctrl-cum.mat;

animalname = f.animal{1};
animal = animaldef(animalname, 'outputstruct', 1);

switch lower(animal.name)
    case 'bukowski'
        ref = 6;
    case 'cummings'
        ref = 8;
    case 'dickinson'
        ref = 1;
    case 'eliot'
        ref = 1;
    case 'jigsaw'
        ref = 12;
    otherwise
            disp('reference tetrode unknown');
end
    

g = 1;
e = 1;
nume = size(f.output{1},2);

index = f.output{g}(e).index;

%oldday = 1;
freqlist = cell(5,1);
figure;
for e = 1:nume
    index = f.output{g}(e).index;
 
    % create a new figure window to plot each day
    if index(1)>oldday
        %figure;
        %hist(freqlist, 30);
        %title(['day ', num2str(index(1))]);
    end
    oldday = index(1);
    
    freqlist{index(1)} = [freqlist{index(1)} trigspec_hist(f,g,e)]; 
    
    %{
    %[tmpx,tmpy] =trigspec(f,g,e);
    %tmpx = tmpx.*index(3);
    tmpy = tmpy+index(3);
    x{index(1)}{index(2)}{index(3)} = tmpx;
    y{index(1)}{index(2)}{index(3)} = tmpy;
    scatter(x{index(1)}{index(2)}{index(3)},y{index(1)}{index(2)}{index(3)});
    plot(postimes, frztimes, 'r')
    %}
end


    % use when output of trigspec is out=freq(zscore(tmpindex)>=2);
freqlistall = [];
for e = 1:nume  
        freqlistall = [freqlistall trigspec_hist(f,g,e)];
end
hist(freqlistall, 30);


    % use when output of trigspec is out=freq(zscore(tmpindex)>=2);
    % reduce to only ref tetrode.
freqlistref = [];
for e = 1:nume
    index = f.output{g}(e).index;
    if index(3) == ref
        freqlistref = [freqlistref trigspec_hist(f,g,e)];
    end
end
hist(freqlistref, 30);


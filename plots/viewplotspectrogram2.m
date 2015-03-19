function viewplotspectrogram2(f, varargin)
% viewplotspectrogram2 plots z-score spectro w/ title info
% about tetrode).  Plots all the tetrodes in a epoch. 
%
% 'f' is the output filter handle from runplotspectrogram2 which itself
% calls runplotspectrogram
% perhaps 'displayplotspectrogram' as name would better capture function
%
% create spectrogram and save
%tic; runplotspectrogram; toc

g =1;
unused = procOptions(varargin);

for an = 1:length(f)
    fanimalname = f(an).animal{1};
    animal = animaldef(fanimalname, 'outputstruct', 1);
    estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
    cellinfo = loaddatastruct(animal.dir, animal.pre, 'cellinfo');
    indexold = [0 1];
    index = [0 0];
    %g =1;
    for e =1:length(f(an).output{g})
            
        index = f(1).output{g}(e).index;
       % refresh for each new epoch
        if ~isequal(index(1:2), indexold(1:2))
            hold off;
        end
        
        SS = f(an).output{g}(e).fullspectrum;
        %SS = f(an).output{g}(e).spectrum;
        ZS = zscore(SS,0,1);
        TT = f(an).output{g}(e).time;
        FF = f(an).output{g}(e).frequency;
        %imagesc(TT, FF, log(SS'));
        imagesc(TT, FF, ZS');
        ylim([0 15]);
        
        axis xy  % set(gca,'YDir','reverse');
        hold on
        

        freeze = estpos{index(1)}{index(2)}.data(:,10);
        frztime = estpos{index(1)}{index(2)}.data(:,1);
        plot(frztime, freeze, 'w', 'LineWidth' , 2)
        
        % tetrode characteristics
        if length(cellinfo{index(1)}{index(2)}) < index(3)
            numcells = 0;
            meanrate = 0;
        else
            numcells = length(cellinfo{index(1)}{index(2)}{index(3)});
            structindex = findstruct(cellinfo{index(1)}{index(2)}{index(3)});
            tmpcellinfo = cell2mat(cellinfo{index(1)}{index(2)}{index(3)}(structindex));
            if ~isempty(tmpcellinfo)
                meanrate = mean([tmpcellinfo(:).meanrate]);
            else
                meanrate = 0;
            end
        end
        
        title([animal.name, ' ', num2str(index), '  numcells:', num2str(numcells), '  m-rate:', num2str(meanrate)]);
        
        keyboard;
        cla;
        indexold = index;
    end
end
end

%{
% save output
cd /mnt/backup/walter/walter/phys/Eli/
mkdir Spec
cd Spec
save('Elispec04-4-1.mat', 'f');
%}

function index = findstruct(cellstruct)
index = [];
for ii = 1:length(cellstruct)
    if isstruct(cellstruct{ii})
        index = [index ii];
    end
end
end


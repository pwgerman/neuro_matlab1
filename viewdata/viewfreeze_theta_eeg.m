% viewfreeze_theta_eeg
%   plots the t2theta power (4-6Hz) along with eeg to compare noise to
%   signal

% freeze triggered windows for eegs
% see runfreezetriggeredrippling
more off;

anlist = [{'Bukowski'} {'Cummings'} {'Dickinson'} {'Eliot'} {'Jigsaw'}];
anum = 3; %1:5
daylist = 1; %1:5
eplist = 3; %[2 3 5 7];

for aa = anum
    an = anlist{aa};
    switch lower(an)
        case 'bukowski'
            animal = animaldef('Bukowski', 'outputstruct', 1);
            reftet = 6;
        case 'cummings'
            animal = animaldef('Cummings', 'outputstruct', 1);
            reftet = 8;
        case 'dickinson'
            animal = animaldef('Dickinson', 'outputstruct', 1);
            reftet = 1;
        case 'eliot'
            animal = animaldef('Eliot', 'outputstruct', 1);
            reftet = 1;
        case 'jigsaw'
            animal = animaldef('Jigsaw', 'outputstruct', 1);
            reftet = 12;
        otherwise
            error('animal name not recognized');
    end
    tetinfo = loaddatastruct(animal.dir, animal.pre, 'tetinfo');
    tetfilter = evaluatefilter(tetinfo, 'isequal($area,''CA1'')');
    
    for day = daylist;%1:3
        for ep = eplist;%[2 3 5 7]
            
            tmptetlist = find(tetfilter(:,2)==ep & tetfilter(:,1)==day);
            tetlist = tetfilter(tmptetlist, 3);
            for tt = 1:length(tetlist)
                tet = tetlist(tt);
                %disp([day ep]);
                %use fdatool to create filter
                %Hd = type1thetaf2; % generate filter coefs from fdatool 'generate m-file'
                
                % begin loading, analyzing and plotting
                
                t2theta = loadeegstruct(animal.dir, animal.pre, 't2theta', day, ep, reftet); %t2theta % 3 lines: here, filtered(3 lines below), title
                eeg = loadeegstruct(animal.dir, animal.pre, 'eeg', day, ep, tet);
                eegthresh = loadeegstruct(animal.dir, animal.pre, 'eegthresh', day, ep, tet);
                ripple = loadeegstruct(animal.dir, animal.pre, 'ripple', day, ep, tet);
                
                
                
                tmpt2theta = t2theta{day}{ep}{reftet};
                tmpeeg = eeg{day}{ep}{tet};
                tmpeegthresh = eegthresh{day}{ep}{tet};
                tmpripple = ripple{day}{ep}{tet};
                
                loadstring = sprintf('%s%sripple%02d-%d-%02d.mat',...
                    animal.eegraw, animal.pre, day, ep, tet);
                ripple = load(loadstring); % old data
                tmprippleNT = ripple.ripple{day}{ep}{tet};
                
                % plot results
                estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
                freezing = estpos{day}{ep}.data(:,10);
                frztimes = estpos{day}{ep}.data(:,1);
                
                ripples = loaddatastruct(animal.dir, animal.pre, 'ripples');
                try
                    riptimes = ripples{day}{ep}{tet}.starttime;
                    riphight = ripples{day}{ep}{tet}.maxthresh;
                    riphight = riphight * 50;
                catch
                    riptimes = [] ;
                end
                rastervert = [riphight -riphight];
                %rastervert = [-150 150];
                
                figure;
                cla;
                xlim('auto');
                ylim('auto')
                plot(eegtimes(tmpt2theta), tmpt2theta.data, 'g');
                hold on;
                
                plot(eegtimes(tmpeeg), tmpeeg.data, 'm');
                plot(eegtimes(tmpeegthresh), tmpeegthresh.data, 'c');
                plot(eegtimes(tmprippleNT), tmprippleNT.data(:,1), 'r'); % 1 for filtered, 3 for envelope
                plot(eegtimes(tmpripple), tmpripple.data(:,1), 'b'); % 1 for filtered, 3 for envelope

                for jj = 1:length(riptimes)
                    plot([riptimes(jj) riptimes(jj)], [rastervert(jj,1) rastervert(jj, 2)], 'Color', [1,0.4,0.6]);  % pink [1,0.4,0.6]
                    %plot([riptimes(jj) riptimes(jj)], rastervert, 'b');
                end
                plot(frztimes, freezing*200, 'k');                
                % load and plot no theshold (high amplitude noise) ripples
                %{
                loadstring = sprintf('/mnt/data18/walter/phys/Buk/ripples_nothresh/%sripples%02d.mat',...
                    animal.pre, day);
                ripples = load(loadstring);  % no thresh ripples (before remove high amplitude noise)
                try
                    riptimes = ripples.ripple{day}{ep}{tet}.starttime;
                catch
                    riptimes = [] ;
                end
                rastervert = [-120 120];
                for jj = 1:length(riptimes)
                    plot([riptimes(jj) riptimes(jj)], rastervert, 'r');
                end
                %}
                
                
                tinfo = sprintf('t2theta %s, day%02d-%d tet%02d  cells:%f', animal.name, ...
                    day, ep, tet, tetcellcount(animal.name, tet));
                title(tinfo);
                zoom on;
            end
        end
    end
end
more on;

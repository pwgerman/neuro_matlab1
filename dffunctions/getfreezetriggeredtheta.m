% getfreezetriggeredtheta
%   plots the t2theta power (4-6Hz)

% freeze triggered windows for eegs
% see runfreezetriggeredrippling
%{
day = 1;
ep = 3;
tet = 1;
animal = animaldef('Eliot', 'outputstruct', 1);
%}
anlist = [{'Bukowski'} {'Cummings'} {'Dickinson'} {'Eliot'} {'Jigsaw'}];

for aa = 1:5
    an = anlist{aa};
    for day = 1:3
        for ep = [2 3 5 7]
            %disp([day ep]);
            %use fdatool to create filter
            %Hd = type1thetaf2; % generate filter coefs from fdatool 'generate m-file'
            switch lower(an)
                case 'bukowski'
                    animal = animaldef('Bukowski', 'outputstruct', 1);
                    tet = 6;
                case 'cummings'
                    animal = animaldef('Cummings', 'outputstruct', 1);
                    tet = 8;
                case 'dickinson'
                    animal = animaldef('Dickinson', 'outputstruct', 1);
                    tet = 1;
                case 'eliot'
                    animal = animaldef('Eliot', 'outputstruct', 1);
                    tet = 1;
                case 'jigsaw'
                    animal = animaldef('Jigsaw', 'outputstruct', 1);
                    tet = 12;
                otherwise
                    error('animal name not recognized');
            end
            
            
            % begin loading, analyzing and plotting
            
            t2theta = loadeegstruct(animal.dir, animal.pre, 't2theta', day, ep, tet); %t2theta % 3 lines: here, filtered(3 lines below), title
            eeg{day}{ep}{tet} = loadeegstruct(animal.dir, animal.pre, 'eeg', day, ep, tet); 
            t2data = t2theta{day}{ep}{tet}.data;
            %t2data = t2data(:,1); % theta filtered amplitude
            
            % plot results
            
            estpos = loaddatastruct(animal.dir, animal.pre, 'estpos');
            freezing = estpos{day}{ep}.data(:,10);
            frztimes = estpos{day}{ep}.data(:,1);
               
            eegstart = eeg{day}{ep}{tet}.starttime;
            eegsrate = eeg{day}{ep}{tet}.samprate;
            eegend = (length(t2data))/eegsrate + eegstart;
            eegtimes = eegstart:(1/eegsrate):eegend;
            eegtimes = eegtimes(1:end-1);
            
            figure;
            cla;
            xlim('auto');
            ylim('auto')
            plot(eegtimes, t2data);
            hold on;
            plot(frztimes, freezing*200, 'r');
            tinfo = sprintf('t2theta %s, day%02d-%d tet%02d', animal.name, ...
	    		day, ep, tet);
            title(tinfo);
            
        end
    end
end

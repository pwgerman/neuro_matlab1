% filtering data
% use viewfreeze_theta_eeg.m to visualize the output
% this code is now superceded by the code in thetadayprocess script and the
% function it calls, thetadayprocess, which I've modified from the lab
% version to be more versitile.  There should really be a filterdayprocess
% that takes any filter. (Emily's?)
more off
%day =1;
%ep = 2;
anlist = [{'Bukowski'} {'Cummings'} {'Dickinson'} {'Eliot'} {'Jigsaw'}];
downsample = 10;

for aa = [1 2 4 5] % finish Buk 6:8, Eliot 6.3:8
    an = anlist{aa}
    for day = 4:5 % for non dic 4:5 beyond 5 still not loading eeg 
        for ep = [2 3 5 7]
            disp([day ep])
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
            
            eeg = loadeegstruct(animal.dir, animal.pre, 'eeg', day, ep, tet);
            %eegraw = eeg{day}{ep}{tet}.data;
            NumF = load('type2theta.mat');
            
            %eegff = filtfilt(Hd.numerator, 1, eeg{day}{ep}{tet}.data);
            %eegff = filtfilt(Num, 1, eeg{day}{ep}{tet}.data);
            %eegff = filtfilt(NumF.Num, 1, eeg{day}{ep}{tet}.data);
            t2theta{day}{ep}{tet} = eeg{day}{ep}{tet};
            t2theta{day}{ep}{tet}.data = filtfilt(NumF.Num, 1, eeg{day}{ep}{tet}.data);
            
            % save output
            
            % downsample if requested
            if (downsample ~= 1)
                t2theta{day}{ep}{tet}.data = ...
                    t2theta{day}{ep}{tet}.data(1:downsample:end, :);
                t2theta{day}{ep}{tet}.samprate = ...
                    t2theta{day}{ep}{tet}.samprate / downsample;
            end
            
            
            
            % save the resulting file
            thetafile = sprintf('%s/EEG/%st2theta%02d-%d-%02d.mat', ...
                animal.dir, animal.pre, day, ep, tet);
            save(thetafile, 't2theta');
            clear t2theta
            
        end
    end
end

more on;



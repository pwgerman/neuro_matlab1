% viewraweeg  or 'noisecut'
%   plots the raw eeg of the reference tetrode of all animals run sessions
%   to show where there are noise events that could interfere with
%   analysis.
%   You may need to manually initiate the variable responselog = [] and
%   flaglog = [] before the session.  This extra step prevents it from
%   being accidentally overwritten by the script.
%       Responses:
%           'a' accept, no noise.
%           'd' discard tetrode, too much noise
%           'f' flag, brings up command prompt to leave a comment
%           mouse button press will record pointer value as threshold 

%{
day = 2;
ep = 3;
tet = 6;
animal = animaldef('Bukowski', 'outputstruct', 1);
%}

restartval = [1 1 2 11]; %[2 1 3 16];% [1 1 5 1];% values to restart inputs at
before_restart = true;

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
                    %tet = 6; % REF
                    tetlist = evaluatefilter(tetinfo{1}{2},'isequal($area, ''CA1'')'); % CA1 tetrodes
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
            
            for tt= 1:size(tetlist) %length(eeg{day}{ep})
                tet = tetlist(tt);
                % check if some should be skipped at beginning.
                if isequal([aa day ep tet], restartval)
                    before_restart = false;
                end
                if ~before_restart
                    eeg = loadeegstruct(animal.dir, animal.pre, 'eeg', day, ep, tet);
                    eeg1 = eeg{day}{ep}{tet};
                    %figure;
                    plot(eegtimes(eeg1), eeg1.data)
                    tinfo = sprintf('%s %0d-%d-%0d',animal.name, day, ep, tet);
                    title(tinfo);
                    ylim('auto');
                   
                    
                    % ask for feedback
                    zoom on;
                    keyboard;%pause(.1);
                    [xm, ym, button] = ginput(1); % ginput_check(1); could avoid keypress errors
                    switch button
                        case 97 % 'a' accept
                            accept = true;
                            thresh = 10000;
                            flag = false;
                        case 100 % 'd' decline
                            accept = false;
                            thresh = 0;
                            flag = false;
                        case 102 % 'f' flag to look at later (for unusual cases)
                            accept = true;
                            thresh = 0;
                            flag = true;
                            flaglog = [flaglog; {[aa day ep tet]} {input('Describe reason for flag:  ', 's')}];
                        case 1 % right mouse button press
                            accept = true;
                            thresh = ym;
                            flag = false;
                        case 3 % right mouse button press
                            accept = true;
                            thresh = ym;
                            flag = false;
                        otherwise
                            disp(sprintf('%s %s %0d-%d-%0d', 'unknown input for ', animal.name, day, ep, tet))
                    end
                    responselog = [responselog; aa day ep tet accept thresh flag];
                    %eegind2time(eeg1, find(eeg1.data == min(eeg1.data)))';
                end
            end
        end
    end
end

% save responselog12.mat responselog flaglog

%{
function [xm, ym, button] = ginput_check(1);
[xm, ym, button] = ginput(1);
if ismember(button, [1 3 97 100 102])
    return;
else
    disp(sprintf('reponse must be ''a'', ''d'', ''f'', or a mouse
    button'));  %allow for f to also bring back for a second input.
    [xm, ym, button] = ginput_check(1);
end
return
end
%}


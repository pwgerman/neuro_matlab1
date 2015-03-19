function out = plotfreezetriggeredrips(fsingle, animalnum, index, predelay)
% plotfreezetriggeredrips.m
% PLOTFREEZETRIGGEREDRIPS(fsingle, animalnum, index)
% plot histogram of ripple start times relative to freezing start times
% it takes fsingle is a filterfuntion struct that has the output already.
% The output must be in the form of ripple start and end times.
% animalnum is the animal index number in the filterfunction f
% index is an index [day epoch] or [day epoch cell tetrode]
%
% call function to pick best tetrode for animal and epoch
% just loading ripples won't work well.  The correct tetrode must be chosen
%
% load ripple start times (use best tetrode)
%ripples = loaddatastruct(animal.dir, animal.pre, 'ripples', days);
%ripples{d}{e}
%
% or load data from the script rungetriptimes2.m
%PFsubset =1; % place fields in shock track only
%f{1};
%shockepochs = f{1}.epochs{2};
%animals = {'Eliot'};
%animals = {'Bukowski','Cummings','Dickinson','Eliot','Jigsaw'};

triggrange = 15;    % maximum time (sec) between ripple and event
%predelay = 5;      % amount of non-freezing time before freezing event

% tmp ripples for debugging rest of code.
tmprips = fsingle{1}.output{index}(2).times;    % load ripples from filter function ouput
tmpe = fsingle{1}.epochs{index}(2);         % epoch
tmpd = fsingle{1}.epochs{index}(1);         % day
tmpa = fsingle{1}.animal{animalnum};        % animal

% load freeze start times
animal = animaldef(tmpa, 'outputstruct', 1);
d = tmpd; % for loop days
e = tmpe; % for loop epochs
estpos = loaddatastruct(animal.dir, animal.pre, 'estpos', tmpd); % animals position estimate
if ~isempty(estpos{d}{e}.data)
    postime = estpos{d}{e}.data(:,1);
    posfreeze = estpos{d}{e}.data(:,10);
    [freezestart freezeend] = state2event(postime, posfreeze);
end

ripstart = tmprips(:,1);
ripend = tmprips(:,2);



% calculate time ripple precedes freezing
%{
freezetriggrip = [];
for r = 1:length(ripstart)
    for fz = 1:length(freezestart)
        freezetriggrip(r,fz) = (ripstart(r) - freezestart(fz)); %for all ripple and freeze combinations
    end
end
%}

prefreezetime = freezestart(2:end) - freezeend(1:end-1);
freezestartdelay = freezestart([true (prefreezetime > predelay) ]);  % ...
    % first freezestart is considered to have a delay, thus true
[1 (prefreezetime > 5) ];
freezetriggrip = outerfun(@minus, ripstart, freezestartdelay);

% calculate the time since previous freezeend before each freeezestart
% use to ensure that there is buffer of no freezing before freezing begins
%tmptimelimit = outerfun(@minus, freezestart, freezeend);
% remove self references
%tmptimelimit = tmptimelimit(~eye(length(freezestart)));
%tmptimelimit = tmptimelimit > 5; % only times differences more than 5 sec


% reduce freezetriggrip to only events ripples within triggrange (sec) of
% event
freezetriggrip;

freezetriggriprange = freezetriggrip(abs(freezetriggrip) < triggrange);
hist(freezetriggriprange,30)
out = freezetriggrip;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% outerfun                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = outerfun(funhandle, A, B)
% M = OUTERFUN(funhandle, A, B)
% takes a function handle for a simple arithmetic operator and two vectors,
% A and B that can be of unequal length (n and m respectively)
% the output M is an m by n matrix where each element (m,n) is the output
% of function FUNHANDLE on input A(m) and B(n).
%
% example:
%           M = outerfun(@minus, [4 5 6], [1 2 3])
%M =
%      3     2     1
%      4     3     2
%      5     4     3

if ~isvector(A) | ~isvector(B)
    error('A and B must each be vectors');
end
if size(A, 1) == 1
    A = A';
end
if size(B,2) == 1
    B = B';
end

tmpA = A(:,ones(1, length(B)));
tmpB = B(ones(length(A),1), :);
M = arrayfun(funhandle,tmpA,tmpB);

% info on algorithm:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/69365
% http://mathforum.org/kb/message.jspa?messageID=803292
%


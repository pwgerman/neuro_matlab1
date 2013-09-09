% behav_input.m
%
% This asks for the behavioral sequence on the w-track for each
% animal in the form of ioperR.  Then it alters them to 1 or 0
% and organizes into behavior types for scoring and saves this matrix.
% Use behav_input_read.m
% to read in and use the output files.

function out = behav_input(savefile)

behd = [];
% define data columns
day = 1; % training day of trial
run = 2; % training session within day of trial
isinb = 3; % trial is inbound
isret = 4; % trial is return error
iscor = 5; % trial is correct
inb = 6;  % inbound choices excluding return errors
outb = 7;
all = 8;
inbr = 9;  % inbound choices with return errors
outbr = 10;
allr = 11;

% Collect input
append = 1;
i = 1;
casenames = [];
while append == 1
prompt = {'Rat Name:','Day:','Run:','Behavior Sequence:'};
dlg_title = 'Input behavioral sequence';
num_lines = 1;
if i == 1
   def = {'Rat_01','1','1',''};
else
    def{1} = answer{i-1}{1};
    def{4} = '';
    if answer{i-1}{3}=='1'
        def{2} = answer{i-1}{2};
        def{3} = num2str(1+str2num(answer{i-1}{3}));
    else
        def{2} = num2str(1+str2num(answer{i-1}{2}));
        def{3} = '1';
    end
end
options.Resize='on';
answer{i} = inputdlg(prompt,dlg_title,num_lines,def,options);

% Build matrix
if length(answer{i}{4})==0
    error('no behavioral sequence entered');
end
append_behd = zeros(length(answer{i}{4}),11);
append_behd(:,day) = str2num(answer{i}{2});
append_behd(:,run) = str2num(answer{i}{3});
beh_seq = [''];
for l=1:length(answer{i}{4})
    beh_seq(l) = answer{i}{4}(l)';
end
append_behd(:,isinb) = (beh_seq=='i' | beh_seq=='p' | beh_seq=='r')';
append_behd(:,isret) = (beh_seq=='r' | beh_seq=='R')';
append_behd(:,iscor) = (beh_seq=='i' | beh_seq=='o')';
append_behd(:,6:11) = repmat(append_behd(:,iscor),1,6); 
append_behd(any(append_behd(:,isret),2),6:8) = NaN;
append_behd(any(append_behd(:,isinb),2),[7 10]) = NaN;
append_behd(any(~append_behd(:,isinb),2),[6 9]) = NaN;
%append_behd(:,beh) = (beh_seq);

behd = [behd; append_behd];
for c = 1:length(beh_seq)
casenames = [casenames; beh_seq(c)];
end
% Append another run
choice = questdlg('Append another run?', ...
 'Append...', ...
 'Yes','No','No');
% Handle response
switch choice
    case 'Yes'
        append = 1;
        i = i+1;
    case 'No'
        append = 0;
end
end

out = [];
out = behd;
char(out(:,11))'

varnames = char('day','run','isinb','isret','iscor','inb','outb','all','inbr','outbr','allr');
tblwrite(behd, varnames, casenames, savefile);  


% Calculate learning probability
% define parameters for getest
startflag =1;
background_prob = .5;
conf =.95;
bp = cell(11,1);

% all inbound and outbound with return errors
bp{allr} = behd(:,allr);

% eliminate the NaN blanks from the trial lists of subsets of trials (all
% except allr=11)
for i = 6:10
    M = behd(:,i);
    M(any(isnan(M),2),:)=[];
    % M(isfinite(M(:, 1)), :);  % alternative code to do the same as line above
    bp{i} = M;
end

% run for all inbound and outbound with return errors
% [pc, lt] = getestprobcorrect(bp{allr}, background_prob, startflag, conf);

% run for all inbound and outbound without returns errors
[pc, lt] = getestprobcorrect(bp{all}, background_prob, startflag, conf);


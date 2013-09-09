% runGetEst.m
%
% First import data "behd" with with rows corresponding to trials and columns of data ordered according to:

% define data columns
day = 1; % training day of trial
session = 2; % training session within day of trial
isinb = 3; % trial is inbound
isret = 4; % trial is return error
iscor = 5; % trial is correct
inb = 6;  % inbound choices excluding return errors
outb = 7;
all = 8;
inbr = 9;  % inbound choices with return errors
outbr = 10;
allr = 11;


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
[pc, lt] = getestprobcorrect(bp{allr}, background_prob, startflag, conf);

% run for all inbound and outbound without returns errors
[pc, lt] = getestprobcorrect(bp{all}, background_prob, startflag, conf);

[pc, lt] = getestprobcorrect(bp{inb}, background_prob, startflag, conf);
[pc, lt] = getestprobcorrect(bp{outb}, background_prob, startflag, conf);

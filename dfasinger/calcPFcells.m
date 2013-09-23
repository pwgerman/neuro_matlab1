function PFcells = calcPFcells(minV, minPeak, animals, epochfilter, lessthan, varargin)
% includecells = CALCPFCELLS(minV, minPeak, animals, epochfilter, lessthan, varargin)
%gets all cells with peak > minpeak basedon occnormed firing at > minV
%assumes group is a structure and each element starts with the following columns: [animal day epoch tet
%cell ...], group{1} = [1 3 4 5 6 values of interest]
%
%optional
%   lessthan, 0 or 1, default 0--> finds all cells with peak > minPeak, if
%   lessthan = 1 finds all cells with peak < minPeak
%
% The varargin
% must be two arguments, a string declaring a cellfilter, and a cellfilter
% that defines the inclusion criteria. 
% minV: minimum velocity to include timepoint (a scalar value)
% 
% Example: 
%       minV = 4;
%       animals = {'Barack', 'Calvin', 'Dwight'};
%       epochfilter = ['(isequal($environment, ''lineartrack'')) & $exposure == 1'];
%       cellfilter ='( (isequal($area, ''CA1'') | isequal($area, ''CA3'') ) && ($meanrate < 4) )';
%   allrunPKgroup = getpeakratesallrun(minV, minPeak, animals, epochfilter, 0, 'cellfilter', cellfilter);
%

if nargin < 5
    lessthan = 0;
end


allrunPKgroup = getpeakratesallrun(minV, animals, epochfilter, varargin);%Bar, Dwi, Cal
if lessthan == 0
    PFcells = allrunPKgroup{1}(allrunPKgroup{1}(:,6)>=minPeak, 1:5);
elseif lessthan == 1
    PFcells = allrunPKgroup{1}(allrunPKgroup{1}(:,6)<minPeak, 1:5);
end
end

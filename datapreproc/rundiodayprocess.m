function rundiodayprocess(animalname, day)
%RUNDIODAYPROCESS(animalname, day)
% calls diodayprocess
% to be used on data extracted by shell command line:
%   nspike_extract -diotext <datafile.dat>
%
% creates output file with three variables:
%   DIO{day}{epoch}{pin}
%   diopulses{pin}
%   rawdio{day}{epoch}.times    rawdio{day}{epoch}.values
%

varargin = [];

animal = animaldef(animalname, 'outputstruct', 1);
daydirect = getdaydir(animal.name, day);
diodayprocess(daydirect, animal.dir, animal.pre, day, varargin);
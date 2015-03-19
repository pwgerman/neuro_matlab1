function count = tetcellcount(animalname, tet)
% count = TETCELLCOUNT(animal, tet)
%   returns the total number of cells on a tetrode across all days and
%   epochs divided by the standard deviation of tetrodes with cells.  A
%   zero indicates that the tetrode never had any cells on all days of
%   recording.
%
maxcells = 28;
animal = animaldef(animalname, 'outputstruct', 1);
tetinfo = loaddatastruct(animal.dir, animal.pre, 'tetinfo');
count = cell(maxcells,1);
%tetfilter = evaluatefilter(tetinfo, 'isequal($area,''CA1'')');
for day = 1:length(tetinfo)
    for ep = 1:length(tetinfo{day})
        for tt = 1:length(tetinfo{day}{ep})
            if isnumeric(tetinfo{day}{ep}{tt}.numcells)
                count{tt} = [count{tt}  tetinfo{day}{ep}{tt}.numcells];
            end
        end
    end
end


for tt = 1:length(count)
    tetsum(tt) = sum(count{tt});
end

nonzero = find(tetsum>0);
tmp = zeros(1, maxcells);
denom = std(tetsum(nonzero));
tmp(nonzero) =  tetsum(nonzero)/denom;

count = tmp(tet);
end
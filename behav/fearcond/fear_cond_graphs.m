
%fear_cond_graphs.m
%   written by Walter German on Aug 16, 2011
%   needs functions barsem() and sem()
%   rows are each animal, columns are test day


barsem(shock2b, cntrl2b);

title('Fear Conditioning');
xlabel('day');
ylabel('freezing time (s)');
legend('control', 'shock', 'Location', 'Best');
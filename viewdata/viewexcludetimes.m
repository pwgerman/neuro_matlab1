% viewexcludetimes.m
%   for visualizing and comparing exclude times
figure;
hold on;
%{
for ii = 1:length(f0.excludetime{1}{1})
    plot([f0.excludetime{1}{1}(ii,1) f0.excludetime{1}{1}(ii,2)],[3 3]);
end
for ii = 1:length(f1.excludetime{1}{1})
    plot([f1.excludetime{1}{1}(ii,1) f1.excludetime{1}{1}(ii,2)],[2 2],'r');
end

for ii = 1:length(fv.excludetime{1}{1})
    plot([fv.excludetime{1}{1}(ii,1) fv.excludetime{1}{1}(ii,2)],[4 4], 'Color', hue('pink'));
end

for ii = 1:length(fz1.excludetime{1}{1})
    plot([fz1.excludetime{1}{1}(ii,1) fz1.excludetime{1}{1}(ii,2)],[5 5], 'g');
end
%}
for ii = 1:length(fn0.excludetime{1}{1})
    plot([fn0.excludetime{1}{1}(ii,1) fn0.excludetime{1}{1}(ii,2)],[6 6], 'c');
end
for ii = 1:length(fn1.excludetime{1}{1})
    plot([fn1.excludetime{1}{1}(ii,1) fn1.excludetime{1}{1}(ii,2)],[7 7], 'k');
end
plot(f.output{1}.includetimes(:,1), (f.output{1}.includetimes(:,2)+2), 'm');
plot(f.output{1}.pos(:,1), f.output{1}.pos(:,2), 'g');
%plot(f.output{1}.eegenv(:,1), f.output{1}.eegenv(:,2), 'g');
ylim([-100 100]);
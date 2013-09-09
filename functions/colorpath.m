function out = colorpath(x,y)

% Walter German 2011-11-8
% plots 2d path with JET color map progressing from beginning to end.

cmap = jet;
segment_size = floor(length(x)/size(cmap,1));

%figure; 
hold;

for s = 1: size(cmap,1) -1
    i1 = segment_size*(s-1) +1;
    i2 = segment_size*s +1;
    
    plot(x(i1:i2), y(i1:i2), 'Color', cmap(s,:));
end

% plot end of data here (remainder of uneven division into segments)
s = size(cmap,1);
i1 = segment_size*(s-1) +1;
plot(x(i1:end), y(i1:end), 'Color', cmap(s,:));

colorbar('DataAspectRatio', [1 .5 1]);

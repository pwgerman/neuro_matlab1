function out = noNanStderr(input)
% out = noNanStderr(input)
% Computes the stderr of a matrix, ignoring the NaN's

if ~isnumeric(input)
    error('The input must be numeric');
end
input = shiftdim(input);
out = [];
for i = 1:size(input,2)
    tmp = input(find(~isnan(input(:,i))),i);  
    out(i) = sem(tmp); %stderr(tmp);
end
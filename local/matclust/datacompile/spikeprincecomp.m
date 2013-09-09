function [scores] = spikeprincecomp(waves, ncomp, amps, pass)

scores = [];

for i = 1:4
    [peaks cuts] = spike_peaks(waves(:,i,:), 6,20);
    covariance = cov(peaks');
    coef = pcacov(covariance);
    coef = coef(:,1:ncomp);
    scores = [scores (cuts')*(coef)];
    
end

% use z-scores of individual waves
%{
for i = 1:4
    
    transwave = reshape(waves(:,i,:),40,[])';
    ztwaves = zscore(double(transwave'));   % ztwaves(40,spikes)
    
    covariance = cov(ztwaves(:,pass)');
    coef = pcacov(covariance);
    coef = coef(:,1:ncomp);
    scores = [scores (ztwaves')*(coef)];
    
end
%}

%{
covariance = cov(double(reshape(waves(:,i,pass),40,[])'));
coef = pcacov(covariance);
coef = coef(:,1:ncomp);
scores = [scores (double(reshape(waves(:,i,:),40,[])')*(coef))];
%}

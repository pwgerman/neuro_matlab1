function [eegvar] = iseegvar(varname)
% eegvar = iseegvar(varname)
% returns 1 if varname is the name of an eeg variable and 0 otherwise
% 
% eeg variables are
% 	'eeg'
%	'theta', 't1theta', 't2theta'
%	'gamma','lowgamma','highgamma'
%	'ripple'
%       'spectrum','coherence'
switch (varname)
case {'eeg', 'theta','t1theta', 't2theta', 'gamma', 'ripple','lowgamma','highgamma','spectrum','coherence'}
    eegvar = 1;
otherwise
    eegvar = 0;
end


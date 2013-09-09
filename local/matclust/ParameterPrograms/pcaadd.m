function void = pcaadd()
% [out, names] = pcaadd();

global clustdata;
global clustattrib;

dlg = inputdlg('Enter threshold (uV)');
thresh = str2num(dlg{1});
cd(clustattrib.currentfilepath);
load(clustattrib.datafile);

amps = clustdata.params(:,2:5);
pass = find( (amps(:,1) >= thresh) | (amps(:,2) >= thresh) | (amps(:,3) >= thresh) | (amps(:,4) >= thresh) );

out = spikeprincecomp(waves, 2, amps, pass);
names = {'pca1-1','pca1-2','pca2-1','pca2-2','pca3-1','pca3-2','pca4-1','pca4-2'};

% alter open matclust session results in slow perfomance and clusters out
% of alignment

clustdata.names =[clustdata.names; names'];
clustdata.params = [clustdata.params out];
global graphattrib;
origparams = clustdata.origparams;
newparams = origparams + size(names,2);
clustdata.origparams = newparams;
clustdata.filledparam = ones(1,17);
clustdata.datarange = [min(clustdata.params,[],1);max(clustdata.params,[],1)]; %stores the minimum and maximum values (-/+ 10% of range) of each parameter

graphattrib.viewbox = repmat([0 1 0 1],[size(clustdata.params,2) 1 size(clustdata.params,2)]);  %stores the current view window for each axis pair [xmin xmax ymin ymax]

% replace 9 and 17 with new and orig params
graphattrib.viewbox = repmat([0 1 0 1], [17 1 17]);
graphattrib.viewbox(1:9,:,1:9) = graphattrib.oldviewbox;
graphattrib.oldviewbox = graphattrib.viewbox;


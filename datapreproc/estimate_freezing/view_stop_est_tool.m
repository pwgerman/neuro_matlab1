% cell_matrix_script
% processes output of view_stop_est
% first run once for each animal and place in an output file will
% a cell index refering to the animal number.  After creating 
% this matrix will all animals data,
% use cell2mat() to start convert , then use these to finish.


newestfall.stress= [];
for a = 1:5  % animals 1-5
    for e = 1:4  % epoch 1-4
newestfall.stress(a,e) = estfall(a).stress{e};
    end
end

newestfall.control= [];
for a = 1:5
    for e = 1:4
newestfall.control(a,e) = estfall(a).control{e};
    end
end

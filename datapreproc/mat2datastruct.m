function mat2datastruct(datatype, inputfilename, outputfileanme)
% MAT2DATASTRUCT(datatype, inputfilename, outputfileanme)
% converts a 2D matrix that is a non cell array on at least one dimention
% into a 2D cell matrix.  This is useful for converting standard arrays
% from data in spreadsheets into datastructs that can be read into filter
% framework using loaddatastruct() that requires data format
% datatype{day}{epoch}.  The inputfile must contain a matrix 
% or struct named datatype of format datatype(dim1,dim2) or
% dataype{dim1}(dim2).  The output will be saved as a file 
% "outputfilename.mat".  The final format of the output will be
% datatype{dim1}{dim2}.
% Must be called from within the directory of the input file.
%
% Used to convert cmperpix{day}(epoch) to cmperpix{day}{epoch}
% 
% Datatype must be the name of the variable loaded from the inputfile.
% Example: mat2datastruct('cmperpix','Bukcmperpix', 'Bukcmperpixnew');
% 
% 12-Aug-2013 10:47:49 Walter German
%

input = [];
out = [];

load(inputfilename);
eval(['input=' datatype ';']);

for d = 1:length(input)
    if iscell(input)
        for e = 1:length(input{d})
            out{d}{e} = input{d}(e);
        end
    else
        for e = 1:length(input(d))
            out{d}{e} = input(d,e);
        end
    end
end
eval([datatype '=out;']);
save(outputfileanme, datatype);
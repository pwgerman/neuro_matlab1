% LEADZERO turn a number into a string with leading zeros

function outputstr = leadzero(numzeros, basenum)

if basenum >= 0
    outputstr = num2str(basenum);
    if numzeros >= 0
        while numzeros > 0
            outputstr = ['0',outputstr];
            numzeros = numzeros -1;
        end
    else
        error('number of zeros must be positive number');
    end
else
    error('base number must be positive number');
end
end
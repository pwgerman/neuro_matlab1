%addfreezetaskinfo
%
% This is a prototype function that is intended to add freezing behavior
% info to the task struct from the freezetimes struct.  It will probably be
% more useful to instead use the createfearinfostruct to make a fearinfo
% file that will then be accessed from the filter framework via a
% setfilterfear function called from createfilter.

    %{
        addtaskinfo(animal.dir, animal.pre, [d], [2], 'freezetime', freeze_times.stress(d));      
        addtaskinfo(animal.dir, animal.pre, [d], [3], 'freezetime', freeze_times.control(d));      
        addtaskinfo(animal.dir, animal.pre, [d], [2], 'freezetime', freeze_times.control(d));      
        addtaskinfo(animal.dir, animal.pre, [d], [2], 'freezetime', freeze_times.stress(d));      
%}
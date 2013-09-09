% takes position data from running video through steve's position
% reconstruct program.

function out = airtimes(posstruct)

% posstruct is defined and created in function readrawpos.m
xthresh = 230;
ythresh = 100;


p = posstruct;
plot(p.data(:,2), p.data(:,3));

time = p.data(:,1);
xpos = p.data(:,2);
ypos = p.data(:,3); 

hz = int32(100/(time(102)-time(2))); %number of samples per second

count = 0;  % number of seconds in file
quad(1:4) = 0; % number of seconds spent in each of 4 quadrants defined by xthresh and ythresh
% quadrants numbered counterclockwise from upper right
enter(1:4) = 0; % transitions into or out of rest zones

last = time(1);  % time of last transition
visit = struct('q3',[],'q4',[]); % list of times spent in rest area each visit
airoff = struct('q3',[],'q4',[],'dur3',[],'dur4', [],'last',time(1)); % times air turned off

for i = (hz+1):hz:length(time)  % index counts of once per second
    count = count +1;
    if xpos(i) < xthresh % quadrant 2&3
        if ypos(i) > ythresh % quad 2
            quad(2) = quad(2) +1;
            if ypos(i-hz) <= ythresh % from quad 3
                enter(2) = enter(2) +1; % enter 2 from 3
                visit.q3 = [visit.q3 (time(i)-last)];
                last = time(i);
            end
        else % quad 3
            quad(3) = quad(3) + 1;
            if ypos(i-hz) > ythresh % from quad 2
                enter(3) = enter(3) +1; % enter 3 from 2
                last = time(i);
                airoff.q3 = [airoff.q3 time(i)];
                airoff.dur3 = [airoff.dur3 (time(i)-airoff.last)];
                airoff.last = time(i);
            end
        end
    end
    if xpos(i) > xthresh % quadrant 1&4
        if ypos(i) > ythresh % quad 1
            quad(1) = quad(1) +1;
            if ypos(i-hz) <= ythresh % from quad 4
                enter(1) = enter(1) +1; % enter 1 from 4
                visit.q4 = [visit.q4 (time(i)-last)];
                last = time(i);
            end
        else % quad 4
            quad(4) = quad(4) + 1;
            if ypos(i-hz) > ythresh % from quad 1
                enter(4) = enter(4) +1; % enter 4 from 1
                last = time(i);
                airoff.q4 = [airoff.q4 time(i)];
                airoff.dur4 = [airoff.dur4 (time(i)-airoff.last)];
                airoff.last = time(i);
            end
        end
    end
end
visit.last = time(end)-last;
out = airoff;

end
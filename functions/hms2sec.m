function sec = hms2sec(hms)
%HMS2SEC  Convert from hours, minutes and seconds to seconds.
%   hms is a vector with three values [h m s]
%   HMS2SEC(HOUR, MINUTE, SECOND) converts the number of hours, minutes and
%   seconds to seconds.
hour = hms(1);
minute = hms(2);
second = hms(3);
   sec = second + 60 * minute + 3600 * hour;

end


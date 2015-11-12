function[RPM] = cadence(StridetimeAvg)
%function - find cadence (60/stridetime) - revolutions per minute
% created     : 27oct2015 (AKM)
% last edited : 27oct2015 (AKM)

%==========================================================================
% FINDING THE PATIENT'S CADENCE
%==========================================================================
%Since Stridetime calculates how many seconds it takes to take 1 stride(seconds/stride),
%we want to convert it to strides/seconds, which can be read as
%revolutions/seconds, which can then be converted into revolutions/minute,
%or RPM (which is cadence)
StridepSec = 1/StridetimeAvg;
RPM = StridepSec*60;

end
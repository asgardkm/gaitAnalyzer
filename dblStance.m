function[dblstance] = dblStance(FV1, FV2, Time, threshold)
% function - find dblstance time - rather straightfoward
%
% created - 27oct2015 (AKM)
% last edited - 27oct2015 (AKM)

%==========================================================================
% FINDING THE DOUBLE STANCE TIME
%==========================================================================
fprintf('Finding double stance percentage time...')
dblstnce = 0;
%Doublestance time is the percentage of time in a gate cycle that both feet
%are on the ground. This can be calculated by counting each frame/"fraction
%of a second" that vertical forces from both feet are present.
%A threshhold is included for better accuracy.
for i = 1:length(Time);   
    if (FV1(i) > threshold && FV2(i) > threshold);
        dblstnce = dblstnce + 1;  
    end   
end
%Converting the number of frames calculated above into a ratio / percentage of the
%total number of frames
dblstance = (dblstnce/length(Time))*100;

dblstance = sprintf('%g%%', dblstance);
fprintf('done (dblstance)\n')
end
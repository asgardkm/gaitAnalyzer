function[ldist, rdist] = distKnee2Ank(LLEK, RLEK, LLM, RLM, clean)
% function - finds distance (m) from knee to ankle for both feet (avg+std)
% FORM : dist_knee2ank = distKnee2Ank(LLEK, RLEK, LLM, RLM)
% INPUTS : LLEK - left knee
%          RLEK - right knee
%          LLM  - left ankle
%          RLM  - right ankle           
% OUPUTS - ldist.(avg, std),
%          rdist.(avg, std),
%          newclean - updated clean data structure
%
% NOTE : LEK = KNEE, LM = ANKL
%
% last edited - 27oct2015 (Asgard Kaleb Marroquin)

%% code
%==========================================================================
% CALCULATING THE DISTANCE BETWEEN THE ANKLE AND KNEE
%==========================================================================
% define the list inputs into vector variables
% use the distance formula to get distance for left knee(x1,y1,z1) to left
% ankle(x2,y2,z2) using the following formula : (do same for right)
% d = sqrt( (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2 )
% am using hypot twice here (hypot takes two inputs at a time)

%--begin trimming--------------------------------------------------

% need function for removing blank indexes - % 27oct2015 finished function!
% done with rmBlankData - set 'bool' value to 0
% issues coming from below should be fixed by running useMarkerLCD.m
% [newclean, ~, LLEK] = rmBlankData(clean,    LLEK, 8, 0); % 1 is a dummy input - %%missing is irrelevenat when taking a flat cut (bool==0)
% [newclean, ~, RLEK] = rmBlankData(newclean, RLEK, 8, 0); % do same for RLEK
% [newclean, ~, LLM] =  rmBlankData(newclean, LLM,  8, 0); % and LLM
% [newclean, ~, RLM] =  rmBlankData(newclean, RLM,  8, 0); % and RLM

marray  = {LLEK RLEK LLM RLM};
str_ray = {varname(LLEK) varname(RLEK) varname(LLM) varname(RLM)}; 
all_str = fieldnames(clean);
% run function for input cells - take mean of the XYZ cell arrays of the
% SACR and the NAVE to find center of mass
new_marray = useMarkerLCD(marray, str_ray, all_str, clean);
LLEK = new_marray{1};
RLEK = new_marray{2};
LLM  = new_marray{3};
RLM  = new_marray{4};

%--end of trimming--------------------------------------------------

ldistval = hypot(LLEK.Z{:} - LLM.Z{:}, hypot(LLEK.X{:} - LLM.X{:}, LLEK.Y{:} - LLM.Y{:}));
rdistval = hypot(RLEK.Z{:} - RLM.Z{:}, hypot(RLEK.X{:} - RLM.X{:}, RLEK.Y{:} - RLM.Y{:}));

%Left Ankle and Knee:
ldistavg = mean(ldistval);
ldiststd = std(ldistval);

%Right Ankle and Knee:
rdistavg = mean(rdistval);
rdiststd = std(rdistval);


%==========================================================================
% OUTPUTS : ASSIGN VARIABLES TO STRUCTURE
%          ldist.(avg, std),
%          rdist.(avg, std)
ldist.avg = ldistavg;
ldist.std = ldiststd;

rdist.avg = rdistavg;
rdist.std = rdiststd;
%==========================================================================

% OLD CoDE : ---------------------------------------------------------
% LDist = zeros(1, length(LeftKnee));
% RDist = zeros(1, length(RightKnee));
% 
% for i = 1:length(LeftKnee);
%     LDist(i) = sqrt((ZLeftKnee(i) - ZLeftAnkle(i))^2 + (YLeftKnee(i) - YLeftAnkle(i))^2);
%     RDist(i) = sqrt((ZRightKnee(i) - ZRightAnkle(i))^2 + (YRightKnee(i) - YRightAnkle(i))^2);
% end
% 
% %Need to change RDist for V_PS1 de to NaN's in data
% RDist = RDist(27:end);
% 
% %Left Ankle and Knee:
% LDistAvg = mean(LDist);
% LDistStd = std(LDist);
% 
% %Right Ankle and Knee:
% RDistAvg = mean(RDist);
% RDistStd = std(RDist);
% 
end
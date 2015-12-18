function[] = lowerLegCOM(LLEK, RLEK, LLM, RLM, LHEE, RHEE, LTOE, RTOE, mass, oldclean, trialfile)
%
% function - find the center of mass of the lower leg system (consisting
% of the calf and foot)
%
% inputs  : LLEK - left knee
%           RLEK - right knee
%           LLM - left ankle
%           RLM - right ankle
%           LHEE - left heel
%           RHEE - right heel
%           LTOE - left toe
%           RTOE - right toe
%           mass - mass structure
%           oldclean - structure of markers
%           trialfile - string name of trial file
%
% outputs : 
%
% created 18dec2015 akm
% last edited 18dec2015 akm

%--------------------trimming idx------------------------------------------
% code below seems confusing? see centerMass.m for explanation

% save inputs into an array to feed into useMarkerLCD
marray  = {LLEK, RLEK, LLM, RLM, LHEE, RHEE, LTOE, RTOE};

str_ray = {varname(LLEK) varname(RLEK) varname(LLM) varname(RLM) ...
           varname(LHEE) varname(RHEE) varname(LTOE) varname(RTOE)}; 
       
all_str = fieldnames(oldclean);
% run function for input cells - take mean of the XYZ cell arrays of the
% SACR and the NAVE to find center of mass
struct_marray = useMarkerLCD(marray, str_ray, all_str, oldclean);
new_marray = cellfun(@(idx) struct2cell(idx), struct_marray, 'uniformoutput', 0);
llek = new_marray{1};
rlek = new_marray{2};
llm  = new_marray{3};
rlm  = new_marray{4};
lhee = new_marray{5};
rhee = new_marray{6};
ltoe = new_marray{7};
rtoe = new_marray{8};

%--------------end of trimming---------------------------------------------

%If Normal Walking is present:
if ~isempty(regexp(trialfile, 'NW', 'ONCE'))
    %Calf Center of Mass - Based on paper : COM is 43.3% of calf (below the knee)
    %Foot Center of Mass - Based on paper : COM is 43.6% of  foot (from heel)
    %   (paper is from a military document, will have to look up later to

    %   post here as reference)
    % finding calf and foot COM's one Cartesian direction at a time
    for i = 1 : length(rtoe);
        lcalf{i} = llek{i}{:} - ( (llek{i}{:} - llm{i}{:}) * 0.433 );% left calf COM  
        rcalf{i} = rlek{i}{:} - ( (rlek{i}{:} - rlm{i}{:}) * 0.433 ); % right calf COM

        lfoot{i} = lhee{i}{:} - ( (lhee{i}{:} - ltoe{i}{:}) * 0.436 ); % left foot COM
        rfoot{i} = rhee{i}{:} - ( (rhee{i}{:} - rtoe{i}{:}) * 0.436 ); % right foot COM
    end
    
else %HOW TO FIND COM OF THE PROSTHESES? (left leg stays the same - right is prostheses)
    %The COM are basically as follows:
    %Calf COM = Knee Marker
    %Foot COM = Ankle Marker   
    
    for i = 1 : length(YLeftKnee);
        lcalf{i} = llek{i}{:} - ( (llek{i}{:} - llm{i}{:}) * 0.433 );% left calf COM  
        rcalf{i} = rlek{i}{:}; % right calf COM

        lfoot{i} = lhee{i}{:} - ( (lhee{i}{:} - ltoe{i}{:}) * 0.436 ); % left foot COM
        rfoot{i} = rlm{i}{:}; % right foot COM
    end
   
end % end of shank/foot com calculations

%COM combining the foot and the calf:
%Equation for Combining two masses to find one center of mass:
%x(cm) = (m1x1+m2x2)/(m1+m2)
for i = 1 : length(rtoe);
    % Left lower leg system
    lfootcalf{i} = ( (mass.lcalf * lcalf{i}) + (mass.lfoot * lfoot{i}) ) / (mass.lcalf + mass.lfoot);
    % Right lower leg system
    rfootcalf{i} = ( (mass.rcalf * rcalf{i}) + (mass.rfoot * rfoot{i}) ) / (mass.rcalf + mass.rfoot);
end

%Get radius! from knee to the (x,y,z) coordinate of the COM just found:
for i = 1 : length(LCF_YCOM);
   %Left i hat and j hat components of the radius
   %Also, change from mm to m
   LCF_YCOM_R(i,:) = (YLeftKnee(i,:) - LCF_YCOM(i,:));
   LCF_ZCOM_R(i,:) = (ZLeftKnee(i,:) - LCF_ZCOM(i,:));
   lf
   %Right i hat and j hat components of the radius
   RCF_YCOM_R(i,:) = (YRightKnee(i,:) - RCF_YCOM(i,:));
   RCF_ZCOM_R(i,:) = (ZRightKnee(i,:) - RCF_ZCOM(i,:));
end

%Find the magnitude of the radius - Pythagoras
for i = 1 : length(LCF_YCOM_R);
    LCF_COM_R(i,:) = sqrt((LCF_YCOM_R(i,:)^2) + (LCF_ZCOM_R(i,:)^2));
    RCF_COM_R(i,:) = sqrt((RCF_YCOM_R(i,:)^2) + (RCF_ZCOM_R(i,:)^2));
end

end
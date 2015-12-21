function[llowleg_rad, rlowleg_rad] = lowerLegCOM(LLEK, RLEK, LLM, RLM, LHEE, RHEE, LTOE, RTOE, mass, oldclean, trialfile)
% FORM : [lfootcalf_rad, rfootcalf_rad] = lowerLegCOM(LLEK, RLEK, LLM, RLM, LHEE, RHEE, LTOE, RTOE, mass, oldclean, trialfile)
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
% outputs : lfootcalf_rad - radius distance to left lower leg center of mass
%           rfootcalf_rad - radius distance to right lower leg  ""   ""  ""

% created 18dec2015 akm
% last edited 18dec2015 akm

fprintf('Finding knee to lowerleg COM radius...')

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

% define cells:
lfoot = cell(size(ltoe));
rfoot = cell(size(rtoe));
lcalf = cell(size(llek));
rcalf = cell(size(rlek));
lfootcalf = cell(size(lfoot));
rfootcalf = cell(size(rfoot));
lfootcalf_vrad = cell(size(lfootcalf));
rfootcalf_vrad = cell(size(rfootcalf));

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
    
    for i = 1 : length(rtoe);
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
for i = 1 : length(rtoe);
   %Left i hat j hat k hat components of the radius
   lfootcalf_vrad{i} = llek{i}{:} - lfootcalf{i};
   %Right i hat j hat k hat components of the radius
   rfootcalf_vrad{i} = rlek{i}{:} - rfootcalf{i};
end

%Find the magnitude of the radius - Pythagoras
llowleg_rad = sqrt(lfootcalf_vrad{1}.^2 + lfootcalf_vrad{2}.^2 + lfootcalf_vrad{3}.^2);
rlowleg_rad = sqrt(rfootcalf_vrad{1}.^2 + rfootcalf_vrad{2}.^2 + rfootcalf_vrad{3}.^2);

fprintf('done (llowleg_rad, rlowleg_rad)\n')
end
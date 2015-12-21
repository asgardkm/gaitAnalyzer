function[lMOI, rMOI] = gcMOI(llowleg_rad, rlowleg_rad, mass, gc_info, Strideframes, TimeVector)
% FORM : [lMOI, rMOI] = gcMOI(llowleg_rad, rlowleg_rad, mass, gc_info, Strideframes, TimeVector)
%
% function - calculate gaitcycle moment of intertia for the knee during
% walk
%
% inputs  : llowleg_rad - left knee-lowlegCOM radius
%           rlowleg_rad - right knee-lowlegCOM radius
%           mass - mass structure
%           gc_info - gaitcycle information structure
%           Strideframes - # of frames (idx) in one stride (gaitcycle)
%           TimeVector - vector (in time) of entire trial
%
% outputs : lMOI - left knee moment of inertia
%           rMOI - right knee moment of intertia
%
% created 18dec2015
% last edited 18dec2015

% define starts and stops of gaitcycles
fprintf('Finding knee moment of inertia...')
starts = gc_info.starts;
stops  = gc_info.stops;
%==========================================================================
%CALCULATE MOMENT OF INERTIA 
%==========================================================================

%KNEE
%Moment of Intertia = mass*radius^2
%Mass = sum of masses of all elements in system(ex. lower leg=shank+foot)
%Radius = knee to COM of system(in this case)

LK_MOI_ALL = (mass.lcalf + mass.lfoot)*(llowleg_rad).^2;
RK_MOI_ALL = (mass.rcalf + mass.rfoot)*(rlowleg_rad).^2;

% gaitcycle moment of inertias for left and right
LK_MOI = gcpicker(LK_MOI_ALL, starts, stops);
RK_MOI = gcpicker(RK_MOI_ALL, starts, stops);

lMOI   = getMaxParams(LK_MOI_ALL, LK_MOI, Strideframes, TimeVector);
rMOI   = getMaxParams(RK_MOI_ALL, RK_MOI, Strideframes, TimeVector);
fprintf('done (gc.lMOI, gc.rMOI)\n')
end
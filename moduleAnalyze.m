function[output] = moduleAnalyze(output, trialfile, dataparams)
% FORM : output  = moduleAnalyze(output, trialfile, dataparams)
%
% function : group together functions required for analyzing trial data.
% Function will run for one input trialfile at a time.
%
% inputs :  output     - structure with clean and bool - will add parameters
%           trialfile   - contains name which output branch is on
%           dataparams - data parameters from mainConfig.txt
%
% outputs : output     - structure now has gait parameters appended
%
% created : 21dec2015 (akm)
% last edited : 21dec2015 (akm)

% define clean and bool
clean = output.(trialfile).clean;
bool  = output.(trialfile).bool;

% =========================================================================
% FRAME AND TIME 
% FRAME

markernames = fieldnames(clean);

frame_tmp   = struct2cell(clean.(markernames{find(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Frame', 'match')))})); % define frames automatically :)
frame       = cell2mat(frame_tmp);

output.(trialfile).frame = frame; % append frame


% TIME
% look wheter for a timestamp fieldname exists - if it does, use it, 
%else, find it by dividing frames by frequency
if any(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Time', 'match')))
    time_tmp = struct2cell(clean.(markernames{find(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Time', 'match')))}));
    time     = cell2mat(time_tmp);
else
    time     = frame./dataparams.frequency;           % time (based on camera frequency)
end
output.(trialfile).time  = time;  %append time


% =========================================================================

% =========================================================================
%                       PARAMETERS W/O GAITCYCLES
% =========================================================================

% =========================================================================
% GROUND REACTION FORCES
% first step - get gaitcycle!
%   to do that - need filtered force data - function getGRF()
% getGRF - has ground reaction forces
if bool.grf_bool
    [gfr1, gfr2] = getGRF(clean); 
    output.(trialfile).gfr1  = gfr1; % append gfr1
    output.(trialfile).gfr2  = gfr2; % append gfr2
end
% =========================================================================

% =========================================================================
% STEP/STRIDE
% get step/stride values (time, distance)
if bool.stride_bool
    [stride, lstep,rstep] = findStride(clean.LHEE, clean.RHEE, dataparams.frequency, frame, dataparams);
    output.(trialfile).stride = stride; % append stride
    output.(trialfile).lstep = lstep;   % append lstep
    output.(trialfile).rstep = rstep;   % append rstep
end
% =========================================================================

% =========================================================================
% DISTANCE FROM KNEE TO ANKLE
    % NOTE : LEK = KNEE, LM = ANKL
if bool.distknee2ank_bool
    [dist_knee2ank.ldist, dist_knee2ank.rdist] = distKnee2Ank(clean.LLEK,... 
        clean.RLEK, clean.LLM, clean.RLM, clean);
    output.(trialfile).dist_knee2ank = dist_knee2ank; % append shank length
end
% =========================================================================

% =========================================================================
% CENTER OF MASS
if bool.centermass_bool
    centermass = centerMass(clean.SACR, clean.NAVE, clean, 1);
    output.(trialfile).centermass = centermass; % append center of mass
end
% =========================================================================

% =========================================================================
% PROSTHETIC-SHANK RAIO LENGTH
if bool.shankratio_bool
    pratio = prostheticShankRatio(dist_knee2ank.ldist.avg, dist_knee2ank.rdist.avg);
    output.(trialfile).pratio = pratio; % append prosthetic shank ratio
end
% =========================================================================

% =========================================================================
% DOUBLESTANCE
if bool.dblstance_bool
    [dblstance, swing, stance] = dblStance(gfr1.(dataparams.vertical_force), gfr2.(dataparams.vertical_force), clean.LHEE, clean.RHEE, time, dataparams, output.(trialfile).lstep);
    output.(trialfile).dblstance = dblstance;   % append doublestance time
    output.(trialfile).swing     = swing;       % append swing data
    output.(trialfile).stance    = stance;      % append stance data
end
% =========================================================================

% =========================================================================
% CADENCE
if bool.cadence_bool
    cadence = Cadence(stride.time.avg);
    output.(trialfile).cadence = cadence; % append cadence
end
% =========================================================================


% =========================================================================
%                       PARAMETERS W/ GAITCYCLES
% =========================================================================

% =========================================================================
% GET GAITCYCLES
if bool.gaitcycle_bool
    gc.info = getGaitcycle(gfr1.(dataparams.vertical_force), frame, time, stride.time, dataparams.LFB, ...
                           dataparams.UFB, dataparams.gc_percent);
end
% =========================================================================

% =========================================================================
% GAITCYCLE GAIT REACTION FORCES
if bool.gcforce_bool
    [gc.f1, gc.f2] = gcForce(gfr1, gfr2, gc.info, stride.time.time_in_frames, time, dataparams);
end
% =========================================================================

% =========================================================================
% JOINT ANGLES
if bool.jointangle_bool
    gc.angle = jointAngle(clean.LLEK, clean.RLEK, clean.LLM, clean.RLM, clean.LGTRO, ... 
                          clean.RGTRO,clean.LTOE, clean.RTOE, gc.info, ...
                          stride.time.time_in_frames, time, dataparams);
end
% =========================================================================

% =========================================================================
% JOINT ANGLE VELOCITY
if bool.jointanglevel_bool
    [gc.angleVel, LKVshift] = jointAngleVelocity(gc.angle, gc.info, stride.time.time_in_frames, time, 1);
end
% =========================================================================

% =========================================================================
% JOINT ANGLE ACCELERATION
if bool.jointangleacc_bool
    [gc.angleAcc, LKVshift] = jointAngleVelocity(gc.angleVel, gc.info, stride.time.time_in_frames, time, 2);
end
% =========================================================================

% =========================================================================
% WEIGHT / MASS
if bool.gcforce_bool % this couldn't run w/o gcforce
    [weight, weightidx, mass] = weightMass(trialfile, dataparams, gc.f1);
    output.(trialfile).weight    = weight;       % append patient weight (N)
    output.(trialfile).weightidx = weightidx;    % append indexes w/ weights
    output.(trialfile).mass      = mass;         % append patient mass (kg)
end
% =========================================================================

% =========================================================================
% CALCULATING LOWER LEG SYSTEM (SHANK + FOOT) CENTER OF MASS
%   note : units will depend on input units for markers
if bool.gcforce_bool && bool.lowleg_bool
    [llowleg_rad, rlowleg_rad] = lowerLegCOM(clean.LLEK, clean.RLEK, clean.LLM, clean.RLM, clean.LHEE, ...
                                             clean.RHEE, clean.LTOE, clean.RTOE, mass, clean, trialfile);
    output.(trialfile).llowleg_rad = llowleg_rad;  % append left lower leg COM radius from knee
    output.(trialfile).rlowleg_rad = rlowleg_rad;  % append right lower leg COM radius from knee

end
% =========================================================================

% =========================================================================
% CALCULATING GAITCYCLE MOMENT OF INTERTIA
if bool.gcforce_bool && bool.lowleg_bool % MOI won't run w/o lowerLegCOM.m
   [gc.lMOI, gc.rMOI] = gcMOI(llowleg_rad, rlowleg_rad, mass, gc.info, stride.time.time_in_frames, time);
end
% =========================================================================

% append gaitcycle structure
if exist('gc', 'var')
    output.(trialfile).gc = gc; % append gaitcycle structure
end

clear clean bool % clear the tmp clean and bool variables for the next run

end
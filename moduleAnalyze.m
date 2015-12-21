function[] = moduleAnalyze()
% FORM : 
%
% function : 
%
% inputs : 
%
% outputs :
%
% created : 21dec2015 (akm)
% last edited : 21dec2015 (akm)

% =========================================================================
% FRAME AND TIME 
% FRAME

markernames = fieldnames(clean);

frame_tmp   = struct2cell(clean.(markernames{find(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Frame', 'match')))})); % define frames automatically :)
frame       = cell2mat(frame_tmp);

% TIME
% look wheter for a timestamp fieldname exists - if it does, use it, 
%else, find it by dividing frames by frequency
if any(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Time', 'match')))
    time_tmp = struct2cell(clean.(markernames{find(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Time', 'match')))}));
    time     = cell2mat(time_tmp);
else
    time     = frame./dataparams.frequency;           % time (based on camera frequency)
end

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
end
% =========================================================================

% =========================================================================
% STEP/STRIDE
% get step/stride values (time, distance)
if bool.stride_bool
    [stride, lstep,rstep] = findStride(clean.LHEE, clean.RHEE, dataparams.frequency, frame);
end
% =========================================================================

% =========================================================================
% DISTANCE FROM KNEE TO ANKLE
    % NOTE : LEK = KNEE, LM = ANKL
if bool.distknee2ank_bool
    [dist_knee2ank.ldist, dist_knee2ank.rdist] = distKnee2Ank(clean.LLEK,... 
        clean.RLEK, clean.LLM, clean.RLM, clean);
end
% =========================================================================

% =========================================================================
% CENTER OF MASS
if bool.centermass_bool
    centermass = centerMass(clean.SACR, clean.NAVE, clean, 1);
end
% =========================================================================

% =========================================================================
% PROSTHETIC-SHANK RAIO LENGTH
if bool.shankratio_bool
    pratio = prostheticShankRatio(dist_knee2ank.ldist.avg, dist_knee2ank.rdist.avg);
end
% =========================================================================

% =========================================================================
% DOUBLESTANCE
if bool.dblstance_bool
    dblstance = dblStance(gfr1.vert, gfr2.vert, time, dataparams.threshold);
end
% =========================================================================

% =========================================================================
% CADENCE
if bool.cadence_bool
    cadence = Cadence(stride.time.avg);
end
% =========================================================================


% =========================================================================
%                       PARAMETERS W/ GAITCYCLES
% =========================================================================

% =========================================================================
% GET GAITCYCLES
if bool.gaitcycle_bool
    gc.info = getGaitcycle(gfr1.vert, frame, time, stride.time, dataparams.LFB, ...
                           dataparams.UFB, dataparams.gc_percent);
end
% =========================================================================

% =========================================================================
% GAITCYCLE GAIT REACTION FORCES
if bool.gcforce_bool
    [gc.f1, gc.f2] = gcForce(gfr1, gfr2, gc.info, stride.time.time_in_frames, time);
end
% =========================================================================

% =========================================================================
% JOINT ANGLES
if bool.jointangle_bool
    gc.angle = jointAngle(clean.LLEK, clean.RLEK, clean.LLM, clean.RLM, clean.LGTRO, ... 
                          clean.RGTRO,clean.LTOE, clean.RTOE, gc.info, ...
                          stride.time.time_in_frames, time);
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
end
% =========================================================================

% =========================================================================
% CALCULATING LOWER LEG SYSTEM (SHANK + FOOT) CENTER OF MASS
if bool.gcforce_bool && bool.lowleg_bool
    [llowleg_rad, rlowleg_rad] = lowerLegCOM(LLEK, RLEK, LLM, RLM, LHEE, RHEE, ...
                                                 LTOE, RTOE, mass, clean, trialfile);
end
% =========================================================================

% =========================================================================
% CALCULATING GAITCYCLE MOMENT OF INTERTIA
if bool.gcforce_bool && bool.lowleg_bool % MOI won't run w/o lowerLegCOM.m
   [gc.lMOI, gc.rMOI] = gcMOI(llowleg_rad, rlowleg_rad, mass, gc_info, stride.time.time_in_frames, time);
end
% =========================================================================


end
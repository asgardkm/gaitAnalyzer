%% INTRODUCTION
% main script for running functions for determining gait properties
% based on choosing certain markers.
% author      - Asgard Kaleb Marroquin (University of South Florida)
% created     - 24aug2015
% last edited - 9dec2015    integrated mainConfig.txt readConfig.m function
%                           and bools

%% INPUTS : DATA PREPARATION
% =========================================================================
% set your work directory
setMyWD();
% =========================================================================

% =========================================================================
% read in a mainConfig.txt file
[dataparams, markerstring] = readConfig('mainConfig.txt');
% =========================================================================

% =========================================================================
% PRELIMINARY SETUP / DATA SELECTION
%determine OS
[pc_os, unix_os] = determineOS();
[csv_str, txt_str] = formatStrings(unix_os, pc_os);
% either create or choose pre-existing combined trial data and get it's
% string name - also get the directory of the selected patient
[trialfile, patient_dir, conc_input] = dataConcInput(csv_str, txt_str, dataparams.txt_idx); %NOTE - check back later to see what outputs need to be called from here
% =========================================================================

% =========================================================================
% READING TRIAL DATA
[marker_all, coord_all, data_all] = readData(trialfile, patient_dir, conc_input, dataparams.txt_idx, dataparams.ignore_idx);
% =========================================================================

% =========================================================================
% ASSIGN MARKERS
ttl = assignMarkers(marker_all, coord_all, data_all);
% =========================================================================

% =========================================================================
% CLEAN MARKERS
% need a function that puts each marker in ttl to its individual ttl coords
% and data columns
[clean, kill_list, data_all] = cleanMarkers(ttl, dataparams.ignore_idx, conc_input);
% =========================================================================

% need a function which sees which markers are available for use so that the 
% correct data functions run: 
% input strings can be provided by mainConfig.txt
bool = checkExistance(markerstring, clean);


%% LET THE APPLICATIONS BEGIN!
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
% 

% =========================================================================

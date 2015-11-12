%% INTRODUCTION
% main script for running functions for determining gait properties
% based on choosing certain markers.
% author      - Asgard Kaleb Marroquin (University of South Florida)
% created     - 24aug2015
% last edited - 10nov2015

%% INPUTS : DATA PREPARATION

% =========================================================================
% TEXT INDEXES + FREQUENCY + THRESHOLDS & BOUNDS

% TEXT INDEXES
%   set the indexes (columns) you wish to use from the text file (include 
%   forces or whole text file?)
txt_idx = 1:167;
% txt_idx = 150:167;

%FREQUENCY OF CAMERAS
frequency  = 100; % set frequency of camera for times (the camera used for this is using  100 HZ)

%THRESHOLDS AND BOUNDS
threshold  = 5;                          % set force threshold - for doublestance
LFB        = 5;                          % lower force bound for finding gaitcycles 
UFB        = 100;                        % upper force ound for finding gaitycles
gc_percent = 1;                          % percentage of gaitcycle to include in gc vectors 
% =========================================================================


% =========================================================================
% set your work directory
setMyWD();
% =========================================================================


% =========================================================================
%determine OS
[pc_os, unix_os] = determineOS();
[csv_str, txt_str] = formatStrings(unix_os, pc_os);
% either create or choose pre-existing combined trial data and get it's
% string name - also get the directory of the selected patient
[trialfile, patient_dir, conc_input] = dataConcInput(csv_str, txt_str, txt_idx); %NOTE - check back later to see what outputs need to be called from here
% =========================================================================

% =========================================================================
% READING TRIAL DATA
[marker_all, coord_all, data_all] = readData(trialfile, patient_dir, conc_input, txt_idx);
% =========================================================================

% =========================================================================
% ASSIGN MARKERS
ttl = assignMarkers(marker_all, coord_all, data_all);
% =========================================================================

% =========================================================================
% CLEAN MARKERS
% need a function that puts each marker in ttl to its individual ttl coords
% and data columns
[clean, kill_list, data_all] = cleanMarkers(ttl);
% =========================================================================

% =========================================================================
% 15oct2015 - no longer needed - is done in cleanMarkers above
% MATCH MARKERS
% function will assign marker data and XYZ coord to each marker title name
% where each title name will be a structure containing XYZ + data 
%  FORM (pseudo) : title is a structure where : 
%   title.coords{1} = data{1}
%   title.coords{2} = data{2}
%   title.coords{3} = data{3}
% marker = matchMarkers(clean);
% =========================================================================

% may need some where that defines what to be calling the elements in the
% output strucutre (like structure.(variable)) - define in script, in txt?
%% LET THE APPLICATIONS BEGIN!

% =========================================================================
% FRAME AND TIME 
%FRAME
markernames = fieldnames(clean);
frame_tmp   = struct2cell(clean.(markernames{find(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Frame', 'match')))})); % define frames automatically :)
frame       = cell2mat(frame_tmp{:});
% TIME
% look wheter for a timestamp fieldname exists - if it does, use it, 
%else, find it by dividing frames by frequency
if any(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Time', 'match')))
    time_tmp = struct2cell(clean.(markernames{find(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), 'Time', 'match')))}));
    time     = cell2mat(time_tmp{:});
else
    time     = frame./frequency;           % time (based on camera frequency)
end
% =========================================================================

%16oct2015 -
% how am i going to save output data? in one structure? in two? how to
% divide what data goes where?
% can have two strucutres:
% structure one : data for KINEMATICS - decided 19oct2015
% structure two : has data for KINETICS

% =========================================================================
%                       PARAMETERS W/O GAITCYCLES
% =========================================================================
%
%
% =========================================================================
% GROUND REACTION FORCES
% first step - get gaitcycle!
%   to do that - need filtered force data - function getGRF()
% getGRF - has ground reaction forces
[kinetics.gfr1, kinetics.gfr2] = getGRF(clean); 
% =========================================================================

% =========================================================================
% STEP/STRIDE
% get step/stride values (time, distance)
[kinematics.stride, kinematics.lstep, ... 
 kinematics.rstep] = findStride(clean.LHEE, clean.RHEE, frequency, frame);
% =========================================================================

% =========================================================================
% DISTANCE FROM KNEE TO ANKLE
    % NOTE : LEK = KNEE, LM = ANKL
[kinematics.dist_knee2ank.ldist,...
 kinematics.dist_knee2ank.rdist] = distKnee2Ank(clean.LLEK, clean.RLEK, ...
                                                clean.LLM,  clean.RLM, clean);
% =========================================================================

% =========================================================================
% CENTER OF MASS
kinematics.centermass = centerMass(clean.SACR, clean.NAVE, clean);
% =========================================================================

% =========================================================================
% PROSTHETIC-SHANK RAIO LENGTH
kinematics.pratio = prostheticShankRatio(kinematics.dist_knee2ank.ldist.avg, ...
                                         kinematics.dist_knee2ank.rdist.avg);
% =========================================================================

% =========================================================================
% DOUBLESTANCE
kinematics.dblstance = dblStance(kinetics.gfr1.vert, kinetics.gfr2.vert, time, threshold);
% =========================================================================

% =========================================================================
% CADENCE
kinematics.cadence = cadence(kinematics.stride.time.avg);
% =========================================================================

% =========================================================================
%                       PARAMETERS W/ GAITCYCLES
% =========================================================================
%
%
% =========================================================================
% GET GAITCYCLES
gc.info = getGaitcycle(kinetics.gfr1.vert, frame, time, kinematics.stride.time, LFB, UFB, gc_percent);
% =========================================================================

[gc.f1, gc.f2] = gcForce(kinetics, gc.info, kinematics.stride.time.time_in_frames, time);
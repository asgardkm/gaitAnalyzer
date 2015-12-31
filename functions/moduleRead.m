function[clean, bool] = moduleRead(trialfile, patient_dir, conc_input, dataparams, markerstring)
% FORM : [clean, bool] = moduleRead(trialfile, patient_dir, conc_input, dataparams, markerstring)
%
% function - group together functions required for reading in, cleaning,
% and organizing trial data.
%
% inputs :  trialfile    - name of selected datafile
%           patient_dir  - directory name of where trialfile is located
%           conc_input   - input from user for selecting file type
%           dataparams   - data parameters from mainConfig.txt
%           markerstring - marker string parameters from mainConfig.txt
%
% outputs : clean        - structure w/ clean marker and force data
%           bool         - determines which functions run (based on clean)
%
% created 21dec2015 (akm)
% last edited 21dec2015 (akm)


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
[clean, ~, ~] = cleanMarkers(ttl, dataparams.ignore_idx, conc_input);
% =========================================================================

% =========================================================================
% GET BOOLS FOR FUNCTION RUNS
% need a function which sees which markers are available for use so that the 
% correct data functions run: 
% input strings can be provided by mainConfig.txt
bool = checkExistance(markerstring, clean);
% =========================================================================

end
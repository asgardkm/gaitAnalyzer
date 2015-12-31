% =========================================================================
% INTRODUCTION
% main script for running functions for determining gait properties
% based on choosing certain markers.
% author      - Asgard Kaleb Marroquin (University of South Florida)
% created     - 24aug2015
% last edited - 9dec2015    integrated mainConfig.txt readConfig.m function
%                           and bools
%               21dec2015   integrated modules for facilitating symmetry
%                           analysis
% =========================================================================

% =========================================================================
% set your work directory
setMyWD();
% =========================================================================

% =========================================================================
% read in a mainConfig.txt file
[fileparams, dataparams, markerstring] = readConfig('mainConfig.txt');
% =========================================================================

% =========================================================================
% PRELIMINARY SETUP / DATA SELECTION
[pc_os, unix_os] = determineOS();                           % determine OS
[csv_str, txt_str] = formatStrings(unix_os, pc_os);         % format file extension strings as per OS

% either create or choose pre-existing combined trial data and get it's
% string name - also get the directory of the selected patient
[trialfile, patient_dir, conc_input] = dataConcInput(csv_str, txt_str, dataparams.txt_idx, fileparams); 
% =========================================================================

% ========================================================================
% READ AND ANALYZE DATA
for i = 1:length(trialfile)                                 % run for # of trialfiles (1 for 'select', all for 'all')
    
    %ORGANIZE TRIALFILE STRING
    name_tmp = strsplit(trialfile{i}, '.');                 % split trialfile, will turn into cell array
    truname = char(name_tmp(1));                            % select relevant piece, turn back into string
    
    %READ
    [output.(truname).clean, output.(truname).bool] = ...   % read in the trialfile
        moduleRead(trialfile{i}, patient_dir, conc_input, dataparams, markerstring);
    
    %ANALYZE
    output = moduleAnalyze(output, truname, dataparams);    % analyze the trialfile
end
% =========================================================================

% =========================================================================
% RUN SYMMETRY ANALYSIS (IF APPLICABLE)
if fileparams.run_symmetry                              
    symmetry = symmetryAnalysis(output, fileparams.paretic, fileparams.nonparetic);
end
% =========================================================================

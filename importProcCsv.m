function[marker_all, coord_all, data_all] = importProcCsv(comb_trialfile, patient_dir)
% function - read in a combined DFLOW+NEXUS csv file
%
% form    : = importProcCsv()
%
% Inputs  : csv_file_tmp  - filepath string to the text file
%           patient_dir   - string of filepath to patient directory
%
% Outputs : marker_all
%           coord_all
%           data_all
%
% created 10nov2015
% last edited 10nov2015

orig_dir = cd(patient_dir);

% this will change based on ext and on conc_output (possbile : 1-4)
data_all        = csvread(comb_trialfile, 2, 0);

% Read the whole data file
open_pos  = fopen(comb_trialfile);
% set repmat for d_all so that each cell is a string
name_rep  = repmat('%q ', 1, length(data_all(1,:)));
% read the file and set each value in file as a string
d_all   = textscan(open_pos, name_rep(1:end-1), 'delimiter', ',');
d_all   = [d_all{1:length(d_all)}];
% close textscan
fclose(open_pos);

%read the combined data
marker_all      = d_all(1, 1:length(d_all(1,:)));
coord_all       = d_all(2, 1:length(d_all(1,:)));

cd(orig_dir);

end
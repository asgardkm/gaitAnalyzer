function[pos_name, pos_coord, pos_values] = importRawCsv(csv_file_tmp, patient_dir)
% function - read in a raw NEXUS csv file
%
% form    : [marker_all, coord_all, data_all] = importRawCsv(csv_file_tmp, patient_dir)
%
% Inputs  : csv_file_tmp  - filepath string to the text file
%           patient_dir   - string of filepath to patient directory
%
% Outputs : pos_name
%           pos_coord
%           pos_values
%
% created 10nov2015
% last edited 10nov2015

orig_dir = cd(patient_dir);

pos     = csvread(csv_file_tmp, 5, 0); % for RAW csv, the values start at the 5th column

% Assign NEXUS data to cells - name, coords, units, and values
% open textscan
open_pos  = fopen(csv_file_tmp);
% set repmat for all_pos so that each cell is a string
name_rep  = repmat('%q ', 1, length(pos(1,:)));
% read the file and set each value in file as a string
all_pos   = textscan(open_pos, name_rep(1:end-1), 'delimiter', ',');
str_pos = [all_pos{1:length(all_pos)}];
% close textscan
fclose(open_pos);

% save the first couple of rows that have title string info
pos_name      = str_pos(3, 1:length(str_pos(1,:)));
pos_coord     = str_pos(4, 1:length(str_pos(1,:)));
% pos_unit      = str_pos(5, 1:length(str_pos(1,:)));
% save values from csv
pos_values    = pos;


cd(orig_dir);

end
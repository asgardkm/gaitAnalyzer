function[forces_name, force_coords, forces_values] = importRawTxt(txt_file_tmp, includeforces, select_idx, patient_dir)
% function - read in a raw DFLOW text file
%
% form    : [marker_all, coord_all(???), data_all]= importRawTxt(txt_file_tmp, includeforces, select_idx, patient_dir)
%
% Inputs  : txt_file_tmp  - filepath string to the text file
%           includeforces - bool whether to use whole text file or to only use  
%           select_idx    - input indexes for selecting forces (if include
%                           forces is true/1)
%           patient_dir   - string of filepath to patient directory
%
% Outputs : 
%
% created 10nov2015
% last edited 10nov2015

orig_dir = cd(patient_dir);
% Read txt dflow data
forces     = dlmread(txt_file_tmp, '\t', 1, 0);
% Assign NEXUS data to cells - name, coords, units, and values
% open textscan
open_pos  = fopen(txt_file_tmp);
% set repmat for all_pos so that each cell is a string
name_rep  = repmat('%q ', 1, length(forces(1,:)));
% read the file and set each value in file as a string
all_for   = textscan(open_pos, name_rep(1:end-1), 'delimiter', ' ', 'multipledelimsasone', 1);
str_for = [all_for{1:length(all_for)}];
% close textscan
fclose(open_pos);

% Assign dflow data to cells - name and values
    %  forces will be the columns 150:167 - must be hard coded for now
    % f_idx         = 150:167;
    f_idx         = select_idx;
    forces        = forces(1:length(forces)-2, f_idx);


% get the forces names! (split up big string, then only call names for
% forces)
forces_name   = str_for{1, :};   
forces_name   = strsplit(forces_name);
forces_name   = forces_name(f_idx);

forces_values = forces;

% get the 'x y z' string value...
force_coords = [{'x'}, {'y'}, {'z'}];
if includeforces == 0 %if bool is false - create a coord list 
    
    % ... and repeat it for each name (for pos and for forces)
    force_coords = repmat(force_coords, 1, (length(forces_name)-2)/3);
    force_coords = [forces_name{1:2}, force_coords];
end


cd(orig_dir)
end
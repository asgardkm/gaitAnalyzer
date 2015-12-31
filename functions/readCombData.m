function[marker_all, coord_all, data_all] = readCombData(comb_trialfile, patient_dir, conc_output, txt_idx)
%% read the data!

% the method you use to read in file (csvread, dlmread) will depend on the
% extension of the file! 10nov2015
% go to the patient directory
fprintf('Reading %s file - ', comb_trialfile)
orig_dir        = cd(patient_dir);

switch conc_output
    case 1 % if selected 1 (read raw DFLOW txt file) - use raw txt read function
        [forces_name, forces_values] = importRawTxt(txt_file_tmp, 1, txt_idx, patient_dir);

    case 2 % if selected 2 (read raw NEXUS csv file) - use raw csv read function
        [pos_name, pos_coord, pos_values] = importRawCsv(csv_file_tmp, patient_dir);
        
    case 3 % if selected 3 (read preprocessed combined csv file)
    case 4 % if selected 4 - same as 3
end
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

cd(orig_dir)
fprintf('done\n')
end
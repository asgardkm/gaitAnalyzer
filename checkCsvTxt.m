function[pos_name, pos_coord, pos_values, forces_name, forces_values] = checkCsvTxt(csv_file_tmp, txt_file_tmp, patient_dir, txt_idx)
%% Read csv NEXUS data
[pos_name, pos_coord, pos_values] = importRawCsv(csv_file_tmp, patient_dir);

%% Read txt dflow data
[forces_name, ~, forces_values] = importRawTxt(txt_file_tmp, 1, txt_idx, patient_dir);

%% trim data
% Trim values so that thneystrcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)strcmp(any(all_files), combined_file)
if length(pos_values) > length(forces_values);
    pos_values    = pos_values(1:length(forces_values), :);
end

if length(pos_values) < length(forces_values);
    forces_values = forces_values(1:length(pos_values), :);
end 

end
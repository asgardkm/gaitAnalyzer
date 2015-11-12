function[comb_filename, patient_dir] = assignData(csv_str, txt_str, txt_idx)
%% select trial csv and txt files
% get csv file
[csv_file, patient_dir] = uigetfile([pwd csv_str], 'Select NEXUS csv');

%move to patient's data directory
cd(patient_dir);
% get txt file
txt_file = uigetfile([pwd txt_str], 'Select DFLOW txt');

%move back to original directory in order to access functions
cd ..

% run function defined above to get comb filename, output dir, and pic dir
[input_filenames, all_files, trial_name] = concDataStr(csv_file, txt_file, patient_dir);

%%  run function checking if file/folder defined above already exists 
%  in current patient dir - give decision to user whether to overwrite or
%  use existing file/folder name
[input_replies] = duplDecision(all_files, input_filenames, trial_name);
comb_filename = char(input_filenames{1});

%% If combined file is to be created, create it!
    if strcmp(input_replies{1}, 'y');
        [pos_name, pos_coord, pos_values, forces_name, forces_values] = checkCsvTxt(csv_file, txt_file, patient_dir, txt_idx);
        combiner(pos_name, pos_coord, pos_values, forces_name, forces_values, comb_filename, patient_dir);
    end
end
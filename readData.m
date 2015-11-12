function[marker_all, coord_all, data_all] = readData(trialfile, patient_dir, conc_output, txt_idx)
%% read the data!

% the method you use to read in file (csvread, dlmread) will depend on the
% extension of the file! 10nov2015
% go to the patient directory
fprintf('Reading %s file - ', trialfile)

switch conc_output
    case '1' % if selected 1 (read raw DFLOW txt file) - use raw txt read function
        [marker_all, coord_all, data_all] = importRawTxt(trialfile, 0, txt_idx, patient_dir);

    case '2' % if selected 2 (read raw NEXUS csv file) - use raw csv read function
        [marker_all, coord_all, data_all] = importRawCsv(trialfile, patient_dir);
        
    case '3' % if selected 3 (read preprocessed combined csv file)
        [marker_all, coord_all, data_all] = importProcCsv(trialfile, patient_dir);
    case '4' % if selected 4 - same as 3
        [marker_all, coord_all, data_all] = importProcCsv(trialfile, patient_dir);
end

fprintf('done\n')
end
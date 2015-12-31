function[input_filenames, all_files, csv_file] = concDataStr(csv_file, txt_file, patient_dir)
    % function for making sure files are of same trials

    %% break up file string to "trial.extension"; save "trial" string
    csv_file = strtok(csv_file, '.');
    txt_file = strtok(txt_file, '.');
    % return warning if the two file names are not identical
    if strcmp(csv_file,txt_file) == 0;
        warning('Warning : csv and txt files do not have the same name, and may not be the same trial.\n Check your files again before proceeding.\n\n csv file : %s\n txt file : %s\n',...
            csv_file, txt_file);
    end
    %% define strings for combined file strings
    comb     = 'Combined';
    txt_ext  = '.txt';
    csv_ext  = '.csv';
    xls_ext  = '.xls';
    xlsx_ext = '.xlsx';
    
    % note - combined filename will be based on csv file, not the txt
    combined_file = sprintf('%s%s%s',comb, csv_file,csv_ext);
    % ASSIGN NAME OF TEXT DATASHEET THAT WILL RECIEVE OUTPUT OF CODE
    output_name   = sprintf('Results_%s',csv_file, txt_ext);
    % ASSIGN JPG FOLDER THAT WILL HOLD GRAPH PICTURES
    jpgfolder     = sprintf('%s',csv_file);
    
    %% check if combined file already exists!:
    %  first define all files in directory
    orig_dir = cd(patient_dir);
    all_files = dir();
    all_files = {all_files.name};
    %  turn combined_file from string to cell in orderto appply strcmp
    combined_file = cellstr(combined_file);
    output_name   = cellstr(output_name);
    jpgfolder     = cellstr(jpgfolder);  
    
    %  NOTE:make sure order of cell inputs in input_files matches output
    %  order of cells returned by duplDecision - the decisions will be in
    %  that order!
    input_filenames = {combined_file, output_name, jpgfolder};
    
    %return to functions!
    cd(orig_dir)
     
end
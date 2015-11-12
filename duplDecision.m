function [input_reply] = duplDecision(all_files, input_files, trial_name)
% check to see if one of the comb files matches current trial chosen

input_reply = cell(1,length(input_files));
% loop decision query for user for each of input_file filename
    for i = 1:length(input_files)
        % IF the input filename already exists in the directory...
        if any(strcmp(all_files, input_files{i}))
            % ... give user option to overwrite or use current file w/ filename
            input_reply{i} = input(sprintf('\nFile/folder name for the trial already exists\n  File/folder name : %s.\nDo you wish to overwrite existing combined data? [y/N] :', char(input_files{i})),'s');
            %   default is use current file w/ filename
            if isempty(input_reply{i})
                input_reply{i} = 'n'; 
            end
        % ELSE, if file doesn't exist, just give notice that new combined datafile will be created
        else
            fprintf('Creating new combined file/folder for trial %s with name %s\n', trial_name, char(input_files{i}));
            % also indicate that the filename is cleared for creation
            input_reply{i} = 'y';
        end
    end

end


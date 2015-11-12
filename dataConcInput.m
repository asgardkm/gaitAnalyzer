function[comb_trialfile, patient_dir, conc_input] = dataConcInput(csv_str, txt_str, txt_idx)
% function - read in raw data files into MATLAB(DFLOW, NEXUS, or both!)
% form    : [comb_trialfile, patient_dir] = dataConcInput(csv_str, txt_str)
% Inputs  : csv_str - file path string indicator for csv files
%           txt_str - file path string indicator for txt files
% Outputs : comb_trialfile - string variable of select datafile
%           patient_dir    - directory for the patient you are looking at
%           conc_output    - input choice for your input file
% last edited : Nov 10, 2015 (AKM)
%

% give user option to use existing combined file or create new comb data
% give prompt for options for selecting raw data
fprintf('Options for selecting input trial data : \n')
fprintf('  1 - use raw DFLOW txt only (default) \n')
fprintf('  2 - Use raw NEXUS csv only\n')
fprintf('  3 - Use preprocessed combined NEXUS+DFLOW file\n')
fprintf('  4 - Combine NEXUS csv and DFLOW txt raw datafiles \n')

% and display input prompt
conc_input = input('Select your input raw data : ', 's');
% conc_input = input('Do you have pre-processed trial data you would like to run? [Y/n] :', 's');

    %   default is use current file w/ filename
    if isempty(conc_input)
        conc_input = '1'; 
    end

% start logic tree for conc_input (will determine type of input file)
switch conc_input
    case '1' % if 1: just select and read txt file - no need to run anything else

        % if the input is yes - have user select the dflow txt trial data
        [comb_trialfile, patient_dir] = uigetfile([pwd txt_str], 'Select DFLOW txt trial data'); 
        
        
    case '2' % if 2 : select and read csv file  
        [comb_trialfile, patient_dir] = uigetfile([pwd csv_str], 'Select NEXUS csv trial data(DOESN''T WORK YET - 11nov2015)'); 
        

    case '3' % if reading in combined file - will be the same as case 2 (it's a csv)
        [comb_trialfile, patient_dir] = uigetfile([pwd csv_str], 'Select combined NEXUS+FLOW csv trial data');
       
        
    case '4' % if combing files, forward code to appropriate function (assignData())
        fprintf('You will be combining your trial data momentarily\n') 
        pause(1.1);
        [comb_trialfile, patient_dir] = assignData(csv_str, txt_str, txt_idx);
    
        
    otherwise % if something went wrong - assume default and give warning
        warning('Input %g not understood, assuming default (DFLOW only)')
        [comb_trialfile, patient_dir] = uigetfile([pwd txt_str], 'Select DFLOW txt trial data');
        
end % end of switch case

end % end of function
function[] = setMyWD()
% function - set your initial work directory!
% FORM : setMyWD()
% Input : none
% Output : 
%
% Created on 26oct2015 (Asgard Kaleb Marroquin)
% Lasted edited on 26oct2015 (Asgard Kaleb Marroquin)

% set whether user wishes to use current work directory
cur_dir = pwd();
fprintf('Current work directory : %s :\n', cur_dir) %disp

cur_ans = input(' Do you wish to use your current work directory? [Y/n] ', 's');

%   default is yes if user input is blank
if isempty(cur_ans)
    cur_ans = 'y'; 
end

% if user input is no, then prompt a display for choosing a new directory
if cur_ans == 'n'
    dir_name = uigetdir;
    % then go to the directory saved in dir_name
    cd(dir_name)
end

end
function[] = readConfig()
% poirpose - set up a function that reads in values established in an
% external text file

% created 25nov2015 akm
% last edited 25nov2015 akm

%% READING IN mainConfig.txt
%file name :
filename = 'mainConfig.txt';
fdata = fopen(filename, 'r');

% read in the file
a = ' ';
i = 1;
while ischar(a)
        a  = fgets(fdata);
        if ischar(a)
%                 b = sscanf(a, '%f %f');
%             for j = 1 : length(b)
                mat{i} = a;
%             end

            i = i + 1;
        else
            break
        end
end

%% DEFINING AND FINDING KEY WORDS
% define key words for finding the data we want
keywords = {'START CONFIG INPUTS', 'END CONFIG INPUTS'};
%             'START EXPOSURE GROUPS', 'END EXPOSURE GROUPS'};
keyindex = zeros(length(keywords), 1);

% look for keywords inside of mat - regexp!
for i = 1 : length(keywords)
   tmp = regexp(mat, keywords{i}); 
   keyindex(i) = find(~cellfun(@isempty, tmp));
end

inputvar_start  = keyindex(1) + 1;
inputvar_stop   = keyindex(2) - 1;

%% CONFIG INPUTS
% loop through the skip and lines and read in the values
for k = inputvar_start : inputvar_stop
    tmp_string = strtrim(strsplit(mat{k}, ','));
    value{k - keyindex(1)} = tmp_string{1};
    name{k - keyindex(1)}  = tmp_string{2};
end

% save values from looping above
clean = value{find(~cellfun(@isempty, regexp(name, 'clean.conc.dat')))}; % bool
filename = value{find(~cellfun(@isempty, regexp(name, 'conc.dat')))}; % string
res   = str2double(value{find(~cellfun(@isempty, regexp(name, 'cell.size')))}); %num

% throw values into a structure
concdataparams = struct('clean', clean, ...
                        'filename', filename, ...
                        'res', res );
% clear tmp variables to save memory
clear clean filename res


%% CLOSE FDATA - END
% and then close the connection now that the data is now in matlab as a var
fclose(fdata);

end
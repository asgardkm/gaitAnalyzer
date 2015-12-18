function[dataparams, markerstring] = readConfig(filename)
% poirpose - set up a function that reads in values established in an
% external text file

% created 25nov2015 akm
% last edited 8dec2015 akm - added 2nd group

%% READING IN mainConfig.txt
% read in filename :
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
keywords = {'START CONFIG INPUTS', 'END CONFIG INPUTS', ...
            'START MARKERSTRING INPUTS', 'END MARKERSTRING INPUTS'};
%             'START EXPOSURE GROUPS', 'END EXPOSURE GROUPS'};
keyindex = zeros(length(keywords), 1);

% look for keywords inside of mat - regexp!
for i = 1 : length(keywords)
   tmp = regexp(mat, keywords{i}); 
   keyindex(i) = find(~cellfun(@isempty, tmp));
end

inputvar_start  = keyindex(1) + 1;
inputvar_stop   = keyindex(2) - 1;
stringvar_start = keyindex(3) + 1;
stringvar_stop  = keyindex(4) - 1;

%% CONFIG INPUTS
% loop through the skip and lines and read in the values
for k = inputvar_start : inputvar_stop
    tmp_string = strtrim(strsplit(mat{k}, ','));
    value{k - keyindex(1)} = tmp_string{1};
    name{k - keyindex(1)}  = tmp_string{2};
end

% save values from looping above
txt_idx     = value{find(~cellfun(@isempty, regexp(name, 'txt_idx')))}; % string
frame_idx   = str2double(value{find(~cellfun(@isempty, regexp(name, 'frame_idx')))}); %num
time_idx    = str2double(value{find(~cellfun(@isempty, regexp(name, 'time_idx')))}); %num
frequency   = str2double(value{find(~cellfun(@isempty, regexp(name, 'frequency')))}); %num
threshold   = str2double(value{find(~cellfun(@isempty, regexp(name, 'threshold')))}); %num
LFB         = str2double(value{find(~cellfun(@isempty, regexp(name, 'LFB')))}); %num
UFB         = str2double(value{find(~cellfun(@isempty, regexp(name, 'UFB')))}); %num
gc_percent  = str2double(value{find(~cellfun(@isempty, regexp(name, 'gc_percent')))}); %num
prosthesis  = str2double(value{find(~cellfun(@isempty, regexp(name, 'prosthesis')))}); %num
p_calf      = str2double(value{find(~cellfun(@isempty, regexp(name, 'p_calf')))}); %num
p_foot      = str2double(value{find(~cellfun(@isempty, regexp(name, 'p_foot')))}); %num


ignore_idx  = [frame_idx time_idx];% combine frame_idx and time_idx
% clean = value{find(~cellfun(@isempty, regexp(name, 'clean.conc.dat')))}; % bool

% throw values into a structure
dataparams = struct('txt_idx',  txt_idx, ...
             'frame_idx',       frame_idx, ...
             'time_idx',        time_idx, ...
             'ignore_idx',      ignore_idx', ...
             'frequency',       frequency, ...
             'threshold',       threshold, ...
             'LFB',             LFB, ...
             'UFB',             UFB, ...
             'gc_percent',      gc_percent, ...
             'prosthesis_mass', prosthesis, ...
             'p_calf',          p_calf, ...
             'p_foot',          p_foot);

% clear tmp variables to save memory
clear txt_idx frame_idx time_idx ignore_idx frequency thresohld LFB UFB gc_percent value name



%% CONFIG INPUTS
% loop through the skip and lines and read in the values
for k = stringvar_start : stringvar_stop
    tmp_string = strtrim(strsplit(mat{k}, ','));
    value{k - keyindex(1)} = tmp_string{1};
    name{k - keyindex(1)}  = tmp_string{2};
end

% save values from looping above
sacr_str     = value{find(~cellfun(@isempty, regexp(name, 'sacr_str')))}; % string
nave_str     = value{find(~cellfun(@isempty, regexp(name, 'nave_str')))}; % string
llek_str     = value{find(~cellfun(@isempty, regexp(name, 'llek_str')))}; % string
rlek_str     = value{find(~cellfun(@isempty, regexp(name, 'rlek_str')))}; % string
llm_str      = value{find(~cellfun(@isempty, regexp(name, 'llm_str')))}; % string
rlm_str      = value{find(~cellfun(@isempty, regexp(name, 'rlm_str')))}; % string
lgtro_str    = value{find(~cellfun(@isempty, regexp(name, 'lgtro_str')))}; % string
rgtro_str    = value{find(~cellfun(@isempty, regexp(name, 'rgtro_str')))}; % string
ltoe_str     = value{find(~cellfun(@isempty, regexp(name, 'ltoe_str')))}; % string
rtoe_str     = value{find(~cellfun(@isempty, regexp(name, 'rtoe_str')))}; % string
lhee_str     = value{find(~cellfun(@isempty, regexp(name, 'lhee_str')))}; % string
rhee_str     = value{find(~cellfun(@isempty, regexp(name, 'rhee_str')))}; % string
fp1_str      = value{find(~cellfun(@isempty, regexp(name, 'fp1_str')))}; % string
fp2_str      = value{find(~cellfun(@isempty, regexp(name, 'fp2_str')))}; % string


% throw values into a structure
markerstring = struct('sacr_str',  sacr_str, ...
                      'nave_str',  nave_str, ...
                      'llek_str',  llek_str, ...
                      'rlek_str',  rlek_str, ...
                      'llm_str',   llm_str, ...
                      'rlm_str',   rlm_str, ...
                      'lgtro_str', lgtro_str, ...
                      'rgtro_str', rgtro_str, ...
                      'ltoe_str',  ltoe_str, ...
                      'rtoe_str',  rtoe_str, ...
                      'lhee_str',  lhee_str, ...
                      'rhee_str',  rhee_str, ...
                      'fp1_str',   fp1_str, ... 
                      'fp2_str',   fp2_str);

% clear tmp variables to save memory
clear value name sacr_str nave_str llek_str rlek_str llm_str rlm_str hee_str rhee_str fp1_str fp2_str

%5 CLOSE FDATA - END
% and then close the connection now that the data is now in matlab as a var
fclose(fdata);

end 
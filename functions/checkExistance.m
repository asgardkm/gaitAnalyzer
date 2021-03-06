function[bool] = checkExistance(markerstring, clean)
% function - checks for the existance of certain markers in the clean
% structure. 
%
% For future editing, feel free to add as many bool groups below as you
% deem fit. Just make sure you know what inputs you need for your parameter
% functions, as that must be provided below.
%
% Input strings come from mainConfig.txt
% Output will in form of bools to provide control for which gait functions
% to run
%
% created 8dec2015
% last edited 9dec2015 - added jointAngle bool

%% assigning boolcell existances
boolcell = cell(length(struct2cell(markerstring)), 2); % define names cell

names_tmp = fieldnames(markerstring); % get names 

for i = 1 : length(names_tmp) % populate the names cell
    
    check_str = markerstring.(names_tmp{i}); % set tmp var of str in markerstring
    split_names = strsplit(names_tmp{i}, '_'); % split up the names tmp
    marker_name{i} = split_names{1};
    
    boolcell{i,1} = sprintf('%s_bool', split_names{1}); % save bool str into cell
    boolcell{i,2} = ~isempty(find(cellfun(@(word) ~isempty(word), regexp(fieldnames(clean), check_str, 'match')))); % determine bool for existance

end

%% centerMass bool for existance (requires SACR and NAVE)
% check if centerMass function existance bool is good to go
if all(boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'sacr', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'nave', 'match'))), 2} )
    bool.centermass_bool = 1;
else
    bool.centermass_bool = 0;
end

%% dist and shankratio bool for existance (requires LLEK RLEK RLM and LLM)
if all(boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'llek', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'rlek', 'match'))), 2} && ... 
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'rlm', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'llm', 'match'))), 2})
    bool.distknee2ank_bool = 1;
    bool.shankratio_bool   = 1;
else
    bool.distknee2ank_bool = 0;
    bool.shankratio_bool   = 0;
end

%% getGRF and dlbstance bool for existance (requires FP1 and FP2)
if all(boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'fp1', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'fp2', 'match'))), 2} )
    bool.grf_bool       = 1;
    bool.dblstance_bool = 1;
else
    bool.grf_bool       = 0;
    bool.dblstance_bool = 0;
end

%% stride and cadence bool for existance (requires LHEE and RHEE)
if all(boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'lhee', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'rhee', 'match'))), 2})
    bool.stride_bool  = 1;
    bool.cadence_bool = 1;
else
    bool.stride_bool  = 0;
    bool.cadence_bool = 0;
end

%% gaitcycle and gcforce bool for existance (requires stride_bool and grf_bool to be true)
if all(bool.stride_bool && bool.grf_bool)
    bool.gaitcycle_bool = 1;
    bool.gcforce_bool   = 1;
else
    bool.gaitcycle_bool = 0;
    bool.gcforce_bool   = 0;
end

%% joint angle/vel/accel bool (requires shankratio_bool (includes llek/rlek and llm/rlm), lgtro/rgtro, ltoe/rtoe)
if all(boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'lgtro', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'rgtro', 'match'))), 2} && ... 
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'rtoe', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'ltoe', 'match'))), 2} && bool.shankratio_bool)
    bool.jointangle_bool    = 1;
    bool.jointanglevel_bool = 1;
    bool.jointangleacc_bool = 1;
else
    bool.jointangle_bool = 0;
    bool.jointanglevel_bool = 0;
    bool.jointangleacc_bool = 0;
end
   
%% bool for lower leg system center of mass (requires shankratio_bool(llek/rlek, llm/rlm),
%                                            stride_bool(lhee/rhee), and ltoe/rtoe)
if all(bool.shankratio_bool && bool.stride_bool && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'rtoe', 'match'))), 2} && ...
       boolcell{find(cellfun(@(word) ~isempty(word), regexp(boolcell(:,1), 'ltoe', 'match'))), 2})
    bool.lowleg_bool = 1;
else
    bool.lowleg_bool = 0;
end

%% display which functions will be run and which will not

boolnames = fieldnames(bool); % define names of bool struct
a = 1; % counters for the function cell variables
b = 1; % ^^ 

for i = 1 : length(boolnames) % go through function bools
    function_str = strsplit(boolnames{i}, '_'); % split up the function string
   if bool.(boolnames{i}) == 1 % assign boolnames that have value of 1 to goodfunction
        goodfunction{a} = function_str{1};
        a = a + 1;
   else
       badfunction{b} = function_str{1}; % assign the rest (w/ val=0) to badfunction
       b = b + 1;
   end
end

if b == 1 % if badfunction never procced, then save badmarker as a 
   badfunction = {'N/A, all functions will run! :)'}; 
end

p = 1; %marker counters
q = 1; % ^^
% display markers
fprintf('Status of critical markers needed for gait analysis :\n')
for k = 1 : length(boolcell(:,1))% go through marker bools
   if boolcell{k, 2} == 1 % assign boolnames that have value of 1 to goodfunction
        goodmarker{p} = marker_name{k};
        p = p + 1;
        disp_str{k} = 'found';
   else
       badmarker{q}   = marker_name{k};
       q = q + 1;
       disp_str{k} = 'missing';
   end
    fprintf('     %s - %s\n', marker_name{k}, disp_str{k}) % display

end

% display which functions will be ran and which will not:
fprintf('The following gait parameter functions will run based on the given input data :\n')
cellfun(@(string) fprintf('     %s\n', string), goodfunction) % printing!

fprintf('The following functions will NOT run : \n')
cellfun(@(string) fprintf('     %s\n', string), badfunction) % printing!




end % end of function
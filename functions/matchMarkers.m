function[marker] = matchMarkers(clean)
% function will assign marker data and XYZ coord to each marker title name
% where each title name will be a structure containing XYZ + data 
% FUNCTION FORM : struc_data <- grepMarkers(clean)
%
%  INPUT FORMAT : clean - structure containing clean organized data (see
%  cleanMarkers.m)
%  - clean structure:
%   clean.title  - cell array w/ {1x1} elements - marker names
%   clean.coords - cell array w/ {1x3} elements - X Y Z strings
%   clean.data   - cell array w/ {1x3} elements - data cell array per col
%
%  OUTPUT FORMAT : (pseudo) : title is a structure where : 
%   title{i}.coords{1} = data{1}
%   title{i}.coords{2} = data{2}
%   title{i}.coords{3} = data{3}

% assign structure values to tmp variables
tmp_name = clean.title;
tmp_cord = clean.coords;
tmp_data = clean.data;

% struc_data = cell(length(tmp_name), 1);
% go though each element in the clean structure (marker by marker)
for i = 1 : length(tmp_name)
    % get number of elements going into each marker title
    name_length = char(tmp_cord{i});
    tot_element = length(name_length(:, 1));
    
    %preallocate cell that will contain all needed structure elements
    mark_name = cell(tot_element, 1);
    
    for j = 1 : tot_element
        % assign mark_name to be whatever defined as marker title name
        mark_name{j} = char(tmp_name(i));
        % make structure w/ name of mark_name, .name as name_length, and
        % data inside as tmp_data for that specified element and marker
        marker.(mark_name{j}).(name_length(j,:)) = tmp_data{i}{j};
%         marker.(mark_name{j}).(sprintf('%s', name_length(j,:))) = tmp_data{i}{j};

    end

end

end

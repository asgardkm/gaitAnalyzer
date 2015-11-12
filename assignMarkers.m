function[ttl] = assignMarkers(marker_all, coord_all, data_all)
%% organize markers
fprintf('Organizing file data')
% define preallocations and variable k for loop below
k = 1;
write_tmp = false;
coords_tmp = cell(1,1);
data_tmp   = cell(1,1);
%since coord_all contains frame and subframe and they're not in marker_all
% assign the empty marker_all cells at the beginning to have the coord_all
empty_idx = find(cellfun(@isempty, marker_all) == 0, 1);
for b = 1:empty_idx-1
    marker_all{b} = coord_all{b};

end
% for the length of the marker_all vector cell array thingy
for x = 2:length(marker_all)
    % assign i to be one less than the loop so that i+1 indexes wont exceed
    % indexes
    i = x-1;
%     % add the frame columns to title since they appear before the 1st markers
%     while (rename == true)
%         % break once the marker titles begin
%         if isempty(marker_all{k}) == false
%             rename = false;
%             break
%         end
%         % assign frame title to title cell
%         ttl.title{k}  = coord_all{k};
%         k = k+1;
%     end
%   
    % then just add the rest of the titles of the marker/force titles
    if length(marker_all{i}) > 1
        ttl.title{k} = marker_all{i};  
        k = k + 1;
    end
    % check again if marker_all title cell is empty - the markers are
    % empty every three cells - group them when they're empty
    if isempty(marker_all{i}) == 0 && isempty(marker_all{i+1}) == 1 
        coords_tmp{1} = coord_all{i};
        data_tmp{1}   = data_all(:, i);
        write_tmp = false;
        % if current title+next title have names, assign each one
        % individually - ie for the forces
    elseif isempty(marker_all{i}) == 0 && isempty(marker_all{i+1}) == 0
        coords_tmp = cell(1,1);
        data_tmp   = coords_tmp;
        coords_tmp{1} = coord_all{i};
        data_tmp{1}   = data_all(:, i);
        write_tmp = true;
        % if the title slot is empty, keep writing for the previous one
    elseif isempty(marker_all{i}) == 1
        coords_tmp{end+1} = coord_all{i};
        data_tmp{end+1}   = data_all(:, i);
        write_tmp = false;
        % and once it hits the next marker, stop and prepare to write the
        % tmps defined above
      if (isempty(marker_all{i}) == true && isempty(marker_all{i+1}) == false)
        write_tmp = true;
      end
        
    end        
    % once write_tmp is true (b/c marker_all is no longer empty),
    % write coords_tmp and data_tmp into ttl and clear the tmps for
    % the next batch
    if write_tmp == true
        ttl.coords{k} = coords_tmp;
        ttl.data{k}   = data_tmp;
        clear coords_tmp data_tmp
        write_tmp = false;
    end
    fprintf('.')
end

ttl.title  = ttl.title(~cellfun('isempty', ttl.title));
ttl.coords = ttl.coords(~cellfun('isempty', ttl.coords));
ttl.data   = ttl.data(~cellfun('isempty', ttl.data));

% just add the last column - b/c of loop format above (i = x-1) it skips
% the last element (here its FP2.MomZ)
ttl.title{end+1}  = marker_all{end}; 
ttl.coords{end+1} = coord_all(end);
ttl.data{end+1}   = data_all(:, end);

%one more time? :)
ttl.title  = ttl.title(~cellfun('isempty', ttl.title));
ttl.coords = ttl.coords(~cellfun('isempty', ttl.coords));
ttl.data   = ttl.data(~cellfun('isempty', ttl.data));

fprintf('done\n')
end



function[new_marray] = useMarkerLCD(marray, str_ray, all_str, oldclean)
% function - given an input cell array of markers, find the empty indexes
% in each, and use for each marker data from lowest common denominator of
% available indexes. This will remove any possible missing data from
% parameter calculations, while allowing for the maximum possible amount of
% indexes for each calculation.
%
% form    : function[new_marray] = useMarkerLCD(marray, str_ray, all_str)
%
% INPUTS  : marray - marker array of the input markers you want to find the
%                   LCD number of indexes for
%           str_ray - string names of the markers in marray
%           all_str - string names of all the markers
% OUTPUTS : new_marray - updated markers from marray that now have the LCD
%                        number of indexes in their data structures.
%
% Created     : 27oct2015 (Asgard Kaleb Marroquin)
% Last edited : 27oct2015 (Asgard Kaleb Marroquin)

% need function for removing blank indexes - % 27oct2015 finished function!
% done with rmBlankData - set 'bool' value to 0

% run rmBlankData to find which of the markers has the most idx missing
for hi = 1 : length(marray)
	[tmpclean{hi}, ~, ~] = rmBlankData(oldclean, marray{hi}, 8, 0);   % 8 is a dummy input - %%missing is irrelevenat when taking a flat cut (bool==0)
end

% find which is the LCD of indexes by finding wich of the newclean is the
% smallest
for i = 1 : length(tmpclean)
    tmp_names = fieldnames(tmpclean{i});
    frame_tmp   = struct2cell(tmpclean{i}.(tmp_names{find(cellfun(@(word) ~isempty(word), regexp(fieldnames(tmpclean{i}), 'Frame', 'match')))})); % define frames automatically :)
    frame       = cell2mat(frame_tmp{:});
    l(i) = length(frame);
end

% lcd - value of smallest - lidx - shows which l(#) is the smallest
[lcd, lidx] = min(l);

% so then only use the markers with the lowest common denom!
% assign each element in 
% lowest length tmpclean data vector:
goodclean = tmpclean{lidx};

% for hi = 1 : length(marray)
%     [~,~,new_marray{hi}] = rmBlankData(goodclean, marray{hi}, 9, 0);
% end

for k = 1 : length(str_ray) % loop for every marker - find its idx in the structure list
    str_idx{k} = regexp(all_str, str_ray{k});
    stridx(k) = find(~cellfun(@isempty, str_idx{k})); % get index
    
    new_marray{k} = goodclean.(all_str{stridx(k)}); % assign new value to be the marker idx 
                                    % from goodclean (goodclean is the LCD idx # of the marker vector inputed)
end

end

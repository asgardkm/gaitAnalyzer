function[new, kill_list, new_dall] = cleanMarkers(ttl)
% function - cleans input markers and organizes data for easy seperation of
%  data per marker and by XYZ coord
%  FORM : clean.data = cleanMarkers(old.data)
%  both inputs are in structure form - .title(marker name)
%                                   ,  .coords(X Y Z)
%                                   ,  .data(numerical vectors in cells)

%test - functions below (cellfuns) clean up ttl.title, removing colons,
%periods, and duplicates
no_colons = sepCellStrings(ttl.title, ':', 'end');
no_spaces = sepCellStrings(no_colons, ' ', 'both');
no_dots   = sepCellStrings(no_spaces, '.', 'both');
% get rid of Pos - it's super annoying in text file
no_dots  = sepCellStrings(no_dots, 'Pos', 'both');

% do same as above for ttl.coords - needs a cellfun b/c elements in cell
% ttl.coords are cells, not strings.
tmp_coordlist = cellfun(@(word) char(word), ttl.coords(:), 'uniformoutput', false);
tmp_newcords  = sepCellStrings(cellstr(char(tmp_coordlist')), ' ', 'both');
% find the indexes where there are changes - where tmp_newcords is diff
% from tmp_coordlists - these are the idx where changes were made
[diff_val, idx1, idx2] = setxor(char(tmp_coordlist), tmp_newcords, 'stable');
tmp_coordlist(idx1)    = tmp_newcords(idx2);
ttl.coords             = cellfun(@(word) {word}, tmp_coordlist');

% get idx that are forces - FP
% pat_fp  = '\w*FP\w*';
% pat_pos = '\w*Pos\w*'; 
pat_test = '\w*[X-Z]$'; % this just might be the only thing i need 
%                          actually! - getting the strings that end with 
%                          XYZ after proper processing from sepCellStrings

% find_fp   = regexp(no_dots, pat_fp, 'match');
% find_pos  = regexp(no_dots, pat_pos, 'match');
find_test = regexp(no_dots, pat_test, 'match');
% rmcell_fp = cellfun(@(word)  char(word), find_fp,  'uniformoutput', false);
% rmcell_pos = cellfun(@(word) char(word), find_pos, 'uniformoutput', false);
rmcell_test = cellfun(@(word) char(word), find_test, 'uniformoutput', false);
% combining fp_idx and pos_idx : 
% fp_idx    = cellfun(@(word) all(size(word > 1, 2)), rmcell_fp);
% pos_idx   = cellfun(@(word) all(size(word > 1, 2)), rmcell_pos);
allgood_idx = cellfun(@(word) all(size(word > 1, 2)), rmcell_test);
% allgood_idx = fp_idx;
% % preallocate the allgood_idx vector
% for i = 1 : length(fp_idx)
%     if fp_idx(i) == 0 && fp_idx(i) ~= pos_idx(i)
%         allgood_idx(i) = pos_idx(i);        
%     end
% end

trim_fp    = no_dots(allgood_idx);
clean_fp  = cellfun(@(w) w(w~='x'&w~='y'&w~='z'&w~='X'&w~='Y'&w~='Z'), trim_fp, 'uniformoutput', false);

no_dots(allgood_idx) = clean_fp;

% 21sep2015 - need to find way to remove repeats in no_dots right now -
% there are 3 instances of each type of force  - done w/ unique()
fp_clean = unique(no_dots, 'stable');

%21sep2015 - now that fp_clean has all the cleaned up string names for each
%force, need to make each a structure with XYZ as its elements
% ttl.coords & ttl.data have cells w/ 3 col for pos and 1 col for forces(1
% per XYZ) - how to systematically concactenate the cols for forces based
% on XYZ?
%first step - get idx of the x, y and z
fp_cord   = upper(ttl.coords(allgood_idx));
fp_data   = ttl.data(allgood_idx);
% cord_tmp  = fp_cord(:);

cord_str = cellfun(@(word) char(word), fp_cord);

%want to concacenate groups of xyz's into cells - for both coords and for
%data
    patx = strfind(cord_str, 'X');
    paty = strfind(cord_str, 'Y');
    patz = strfind(cord_str, 'Z');
    
    cord_grp = cell(1, length(patx));
    data_grp = cell(1, length(patx));
    
    for i = 1:length(patx)
        cord_grp{i} = [{cord_str(patx(i))}, {cord_str(paty(i))}, {cord_str(patz(i))}];
        data_grp{i} = [fp_data{patx(i)}, fp_data{paty(i)}, fp_data{patz(i)}];
    end
      
    % add the concatnetated info back into ttl
cord_noforce = ttl.coords(~allgood_idx);
data_noforce = ttl.data(~allgood_idx);

cord_all = [cord_noforce cord_grp];
data_all = [data_noforce data_grp];


% organize function outputs into a structure and return it
clean.title = fp_clean;
clean.coords = cord_all;
clean.data = data_all;

% here is such a function :) - clean data values - remove markers that have
% more than 1/2 of its values as zero, and only keep idx for all markers if
% idx for any marker are less than half total which are nonzero
[new, kill_list, new_dall] = rmBlankData(clean, data_all, 0.5, 1);

%display removed markers:
fprintf('   The following markers were removed:\n') 
cellfun(@(idx) fprintf('     %s\n', char(idx)'), kill_list, 'uniformoutput', false);

end
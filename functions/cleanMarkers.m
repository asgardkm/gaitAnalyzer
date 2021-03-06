function[new, kill_list, new_dall] = cleanMarkers(ttl, ignore_idx, conc_input)
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

pat_testX  = '\w*X$';
pat_testY  = '\w*Y$';
pat_testZ =  '\w*Z$';

find_test  = regexp(no_dots, pat_test,  'match');
find_testX = regexp(no_dots, pat_testX, 'match');
find_testY = regexp(no_dots, pat_testY, 'match');
find_testZ = regexp(no_dots, pat_testZ, 'match');

% find_fp   = regexp(no_dots, pat_fp, 'match');
% find_pos  = regexp(no_dots, pat_pos, 'match');

% rmcell_fp = cellfun(@(word)  char(word), find_fp,  'uniformoutput', false);
% rmcell_pos = cellfun(@(word) char(word), find_pos, 'uniformoutput', false);
rmcell_test  = cellfun(@(word) char(word), find_test,  'uniformoutput', false);
rmcell_testX = cellfun(@(word) char(word), find_testX, 'uniformoutput', false);
rmcell_testY = cellfun(@(word) char(word), find_testY, 'uniformoutput', false);
rmcell_testZ = cellfun(@(word) char(word), find_testZ, 'uniformoutput', false);


% combining fp_idx and pos_idx : 
% fp_idx    = cellfun(@(word) all(size(word > 1, 2)), rmcell_fp);
% pos_idx   = cellfun(@(word) all(size(word > 1, 2)), rmcell_pos);
allgood_idx  = cellfun(@(word) all(size(word > 1, 2)),  rmcell_test);
allgood_idxX = cellfun(@(word) all(size(word > 1, 2)), rmcell_testX);
allgood_idxY = cellfun(@(word) all(size(word > 1, 2)), rmcell_testY);
allgood_idxZ = cellfun(@(word) all(size(word > 1, 2)), rmcell_testZ);

% allgood_idx = fp_idx;
% % preallocate the allgood_idx vector
% for i = 1 : length(fp_idx)
%     if fp_idx(i) == 0 && fp_idx(i) ~= pos_idx(i)
%         allgood_idx(i) = pos_idx(i);        
%     end
% end

%=========================================================================%
%17nov2015 - PLAN:
%   get which markers are X Y Z based on their name in trim_fp
%   once these are found, assign the coord value and the data column
%   respecviely instead of trying to mess around going in circles with all
%   the gibberish below
%   - using regexp!
%   - what if no X Y Z is found in the marker's string name?
%       - then it won't be used - this may not be the best of ideas, 
%   since the above will only work for text files (option 1) - maybe add an
%   ifstatement and only execute if option input 1 is chosen? yes thats good
%   ALSO! since time and frame won't be considered automatically, in the
%   mainscript include a little var that will include them! perfect!

trim_fp    = no_dots(allgood_idx);
fp_data   = ttl.data(allgood_idx);
if conc_input == '1'
    %assign the allgood_idx in coords to be X Y Z based on string names
    %defined above
    % first preallocate
    fp_cord = zeros(length(allgood_idx), 1);
    fp_cord(allgood_idxX) = 'X';
    fp_cord(allgood_idxY) = 'Y';
    fp_cord(allgood_idxZ) = 'Z';
    fp_cord = char(fp_cord);
    
    % now it's time to add the ignore indexes from input!
    % forloop it
    fp_cord = cellstr(fp_cord);
    for i = 1 : length(ignore_idx)
       fp_cord{ignore_idx(i)} = char(ttl.title{ignore_idx(i)});
    end
    
    fp_idx = ~cellfun(@isempty, fp_cord);
    
    fp_cord = char(fp_cord(fp_idx));    
        
    % and then pull out the fp names and the fp values
    data_all = ttl.data(fp_idx);
    fp_clean = no_dots(fp_idx);
    
    % finally clean up fp_cord and turn it into a cell for clean.struct
    cord_all = cellstr(fp_cord(fp_idx))';


    X_idx = find(allgood_idxX);
    Y_idx = find(allgood_idxY);
    Z_idx = find(allgood_idxZ);
%     name_grp = cell(1, length(X_idx)+length(ignore_idx)); % solved with
%     tmp_fp? we shall see if it breaks or not
    cord_grp = cell(1, length(X_idx)+length(ignore_idx));
    data_grp = cell(1, length(X_idx)+length(ignore_idx));
    
    
w = 0; % flag for selecting the cord_grp indexes

    for i = 1:length(X_idx) + length(ignore_idx)
        
        if ~any(unique([X_idx Y_idx Z_idx] == i))
%             name_grp(i) = fp_clean(i);
            cord_grp{i} = fp_clean(i);
            data_grp{i} = data_all{i};
        else
            w = w + 1;
            cord_grp{i} = [cord_all(X_idx(w)), cord_all(Y_idx(w)), cord_all(Z_idx(w))];
            data_grp{i} = [data_all{X_idx(w)}, data_all{Y_idx(w)}, data_all{Z_idx(w)}];
        end
    end

    % now clean up the markers
     tmp_fp = cellfun(@(w) w(w~='x'&w~='y'&w~='z'&w~='X'&w~='Y'&w~='Z'), fp_clean, 'uniformoutput', false);
     tmp_fp = unique(tmp_fp, 'stable');
     % assign for the clean structure
        fp_clean = tmp_fp;
        cord_all = cord_grp;
        data_all = data_grp;

    
else 
    fp_cord   = upper(ttl.coords(allgood_idx));

    cord_str = cellfun(@(word) char(word), fp_cord);

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
    % fp_cord   = upper(ttl.coords(allgood_idx));
    % fp_data   = ttl.data(allgood_idx);
    % % cord_tmp  = fp_cord(:);
    % 
    % cord_str = cellfun(@(word) char(word), fp_cord);

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
%     cord_noforce = ttl.coords(~allgood_idx);
%     data_noforce = ttl.data(~allgood_idx);
%     cord_all = [cord_noforce cord_grp];
%     data_all = [data_noforce data_grp];
    cord_all = cord_grp;
    data_all = data_grp;


end % end of if statement
% organize function outputs into a structure and return it
clean.title = fp_clean;
clean.coords = cord_all;
clean.data = data_all;

% here is such a function :) - clean data values - remove markers that have
% more than 1/2 of its values as zero, and only keep idx for all markers if
% idx for any marker are less than half total which are nonzero
[new, kill_list, new_dall] = rmBlankData(clean, data_all, 0.5, 1, 1);

%display removed markers - only if kill_list ~=0:
if iscell(kill_list)
    fprintf('   The following markers were removed:\n') 
    cellfun(@(idx) fprintf('     %s\n', char(idx)'), kill_list, 'uniformoutput', false);
end

end
function[new, kill_marker, new_dall] = rmBlankData(clean, dall, percent_missing_threshold, bool, verbose)
%function - gets rid of any blank data that may exist in data structure
% FORM    : [new, kill_marker] = rmBlankData(clean, dall, percent_missing_threshold, bool, verbose)
%
% INPUTS  : -clean - structure with all the markers
%           -dall - list with raw data for marker(s) (for bool == 1 - it is
%               entire data set. for bool == 0 - it is for a target marker)
%           -percent_missing_threshold - scalar - determine limit for
%               determining what goes on the kill list
%           -bool - if 1 : removes markers w/ missing-data ratios greater than theshold scalar
%                  if 0 : removes indexes from clean for dall indexes w/ empty data values
%           -verbose - show fprintf statements
%
% OUTPUTS : new - updated clean structure
%           kill_marker - list of names of markers killed
%           new_dall - updated dall so that it reflects raw data of new
%           
%         started 2oct2015 
%         revised 19oct2015 - created function information, added updated dall as output, added bool input
%         revised 26oct2015 - function is returning subscript mismatch
%           error - last week's revisions are probably not yet complete
%         revised 27oct2015 - believe function is complete!
%
% original idea/thought process for creating function: (2oct2015)
%NEED FUNCTION FOR DETERMINING NANS IN DATA - MAYBE A FUNCTION THAT
%     BASED ON WHAT THE ORIG DATA IS, ONLY TAKE INDEXES WHERE THE VALUES
%     ARE NOT 0.
%       - HOWEVER, NEEDS TO EVALUATE NUMBER OF 0's -BC IF A WHOLE COLUMN
%       IS MISSING- DON'T WANT TO HAVE BLANK NUMBERS BC NOTHING IS SELECTED
%       - COULD RETURN WARNING THAT A WHOLE COLUMN IS MISSING - AND IGNORE
%       IT IN FUTURE CALCULATIONS - EXCLUDE IT FROM markers.
%       - PERHAPS RETURN ERROR IF HALF OF NUMBERS OF MISSING - IF LESS THAN
%       HALF THAN PULL FROM THE IDX THAT ARE NONZERO
% ...
% this is that function :)
if verbose
    fprintf('Cleaning data values :\n')    
end

% percent_missing_threshold = 0.5

%% PART ONE-FIND INDEXES THAT HAVE INSUFFICIENT DATA-----------------------
% (as defined by user 'percent_missing_threshold')
% look through input 'dall' to find the indexes that have missing data
% - indexes where percentage of missing data is >= '%_missing_threshold'
% save these indexes - are saved here as kill_list
%--------------------------------------------------------------------------

% find if any of the markers have no data (criteria : if half of the values
% are missing)

%preallocate : 
empty_idx_all   = cell(size(dall));
kill_list       = cell(size(dall));

% if dall is a structure, then convert it into a cell array - primarily if
% bool == 0 is triggered (data may come in as structure)
if isstruct(dall)
    dall = struct2cell(dall);
end

if verbose
    fprintf('   finding markers missing at least %2.0f%% of total data', percent_missing_threshold*100)
end

for i = 1: length(dall)

    if bool == 1 
        for j = 1 : length(dall{i}(1,:)) % this is for the length of each matrix in each cell in dall
        % find where are empty values based on bools (1's and 0's)
        empty_idx_all{i}(:, j) = ~all(dall{i}(:, j), 2);
        % find the zeros - indexes where there is nothing
        empty_idx     = find(empty_idx_all{i}(:, j));

        % determine what goes on the kill_list based on value of bool
        % if bool == 1 - then you'll be killing whole markers
            % find percentage of missing data compared to all the data possible
            p_miss       = length(empty_idx) / length(empty_idx_all{i}(:,j));
            % if percentage of missing values are above threshold - add marker to
            % kill list
            kill_idx     = bsxfun(@ge, p_miss, percent_missing_threshold);
            kill_list{i}(:, j)    = kill_idx;
            % aannnddd BREAK! only need to run once - i better organized
            % data_all into a cell of vectors (it used to be a cell of cells
            % containing vectors and i don't know why that was a good idea)
%             break
        % if bool == 0 - then you'll be killing indexes of missing vals for
        % a certain marker(s)
        % and you only want one iteration - get your missing idx from your
        % input marker,break this loop, and move on to kill all the idx in
        % kill_list from all the datas
        end % end of j loop
        
    elseif bool == 0
    % find where are empty values based on bools (1's and 0's)
    empty_idx_all{i} = cellfun(@(idx) (all(idx, 2)), dall, 'uniformoutput', false);
    % find the zeros - indexes where there is nothing
    empty_idx{i}     = cellfun(@(idx) (find(~idx)),  empty_idx_all{i}, 'uniformoutput', false);
    
    % determine what goes on the kill_list based on value of bool
    % if bool == 1 - then you'll be killing whole markers
        
        kill_list = cell2mat(empty_idx{i});
        good_idx  = cellfun(@(idx) (find(idx)),  empty_idx_all{i}, 'uniformoutput', false);
        good_list = cell2mat(good_idx);
        break
    end
    
    %assign kill_idx found to an evergrowing cell array kill_list
%     kill_list{i}    = kill_idx;
    if verbose
        fprintf('.')
    end
    
end

if verbose
    fprintf('-done\n')
end
% % 15oct2015 - is this needed??? --------------------
% %%4oct2015 - now that i have the indexes that exceed the threshold - i
% %%need to filter out the data i have based from these indexes.
% blank_data = cellfun(@(kill, data)  (data(kill)), kill_list, dall, 'uniformoutput', false);
% %find indexes for each marker that have no values - concactenate empty
% blank_cord = cellfun(@(kill, cord)  {cord(kill)}, kill_list, clean.coords, 'uniformoutput', false);
% % blank_cord   = cellfun(@isempty, noblank_cord);
% % blank_cord   = ~blank_cord;
% % now just keep the non blank coords
% 
% % need to take indexes of clean.coords and clean.data - want to exclude
% % indexes of blank_cord and blank_data
% good_data = cell(size(blank_data));
% for i = 1 : length(clean.coords)
%   good_data = cellfun(@(idx, old_cell) old_cell(isempty(idx)), blank_data, clean.data, 'uniformoutput', false); 
% end
% ----------------------------------

%% PART TWO- REMOVE EMPTY INDEXES DEFINED BY KILL_LIST---------------------
% look through input 'clean' and only keep the indexes that were not
% singled out by kill_list
% save resultant strucutre as new - this is your cleaned out strucuture!
% also have 'kill_marker' - cell array that shows which markers were
% eliminated
%--------------------------------------------------------------------------

% 5oct2015 could not figure out indexing with built in cellfuns/bxsfun \
% - resorting to nested for loops (ugh)

q = 1; % this is for idx for assigning kill_marker names
if verbose
    if bool == 1
        fprintf('   removing markers missing at least %2.0f%% of total data', percent_missing_threshold*100)

    elseif bool == 0 && isempty(kill_list) == 0
        % finding name of dall is too much of a hassle and will not benefit
        % much b/c the user inputs the marker him/herself - ignoring (27oct2015)
        %   can instead just display simple message
        fprintf('   removing missing indexes for entire dataset\n')
    %     tmpname     = fieldnames(clean); % save names of markers into strings
    %     tmpname_idx = find() 
        % and then pull out the right one for fprintf below;
    %     fprintf('   removing missing indexes based from marker %s for entire dataset', dall)
    end
end % end of verbose bool if


% preallocate a cell vector new_dall - only if bool==1 (b/c clean.coords
% does not exist when bool==0 is needed)
if bool == 1
    new_dall = cell(length(clean.coords), 1);
else
    new_dall = cell(length(fieldnames(clean)));
    all_name = fieldnames(clean); % have all_name for finding tmp_name below
end

for i = 1:length(new_dall)
    % same as above for new_dall - apply if decision based on bool
    if bool == 1
        tmp_name = char(clean.coords{i});
    else
        tmp_name = char(fieldnames(clean.(all_name{i})));
    end
   for j = 1:length(tmp_name(:,1))
       
       % begin bool==1 decision
       if bool == 1
           
           % save coords that are not indexed to be empty
           if ~kill_list{i}(j)
               new.(clean.title{i}).(tmp_name(j,:)) = clean.data{i}(:, j);
               % also define new_data_all - don't want data from purged markers
               new_dall{i}{j} = clean.data{i}(:,j); %26oct2015 - fixed new_dall assignment
                                                 % fixed mismatch assignment error message
               
               % if index is on kill_list : return empty cell? - perhaps if length
               % of empty cells = length of total cells - kill the marker?
               %    - that may need to come in later - but maybe here its possible?
               %    - 14oct2015 - will attempt to include excluded list of markers
               %    here (15oct2015 - done!)
               
           elseif kill_list{i}(j)
               kill_marker{q} = [clean.title{i} '.' tmp_name(j,:)];
               q = q+1;
               % if length of 1's in kill_list = length of size of tmp_name -
               % kill the whole structure - kill clean.title{i}
               
               if sum(kill_list{i} == 1) == length(tmp_name(:,1))
                   break
               % otherwise just kill that specific tmp_name coord
               
               else
                   continue
               end

           else
           end % end of kill_list if loop
       
       elseif bool == 0 % end bool == 1 decision -> switch to bool == 0 decision
            % 27oct2015 : created this bool decision
            % for bool == 0 it doesn't matter whether or not if the j
            % marker meets/exceeds pmiss parameter - cause it doesn't exist
            % here - we are taking flat kill cut
            % check if value is in cell format - if it is, turn to mat
            if iscell((clean.(all_name{i}).(tmp_name(j,:))))
                tmp_data = cell2mat(clean.(all_name{i}).(tmp_name(j,:))); % assign to tmp variable
            else
                tmp_data = clean.(all_name{i}).(tmp_name(j,:)); % assign to tmp variable
            end
            tmp_data = tmp_data(cell2mat(good_idx)); % take out the indexes you want
            new.(all_name{i}).(tmp_name(j,:)) = {tmp_data}; % reassign to new struct
            
       end % end bool if decision
        
   end % end of j loop
   if verbose
   fprintf('.')
   end
end % end of i loop

% display killed indexes given that bool == 0 is true
if bool == 0
    % also define new_data_all - don't want data from purged markers
    % this would be for just the marker - is somewhat irrelevant
    % since the marker you need will be under new, but it may be
    % conveinent for it to be a direct output

    % i know this will overwrite a previously preallocated matrix
                                            % but i needed that preallocation for it's length for the loop,
    for k = 1 : length(dall)                % and i am too lazy to create a new variable for the loop
        if iscell(dall{k})
            good_tmp = dall{k}{:}(good_list);% length which would then change things in the bool==1
        else
            good_tmp = dall{k}(good_list);
        end
            new_dall_tmp.(tmp_name(k,:)) = {good_tmp};% decision. So that's why i'm overwriting a created matrix that
    end                                     % was never used (when bool==0 that is)                                    
       new_dall = new_dall_tmp;            
       clear new_dall_tmp
end  
   
if verbose
    if isempty(kill_list) == 0 && bool == 0 % display when the kill_list isnt empty
        fprintf('   removed following blank indexes from dataset\n : ')
        fprintf(' %g ', char(kill_list));
        fprintf('\n')
    end 
end
% if the kill_list is straight up empty, then return a message and save
% kill_list as zero

% note - may be able to encompase whole if statement within a verbose if,
% but not sure if it will affect subsequent runs by unintentionally leaving
% out kill_marker value when calling function w/ verbose=false
if iscell(kill_list)
    if all( cell2mat( (cellfun(@(bool) any(bool==1), kill_list, 'uniformoutput', false)) )  == 0)
        if verbose
            fprintf('\nNo markers removed! - all have at least %f% data\n', percent_missing_threshold*100)
        end
        kill_marker = 0;
    end
    if verbose
        fprintf('done\n')
    end
else
    if all( cell2mat( (cellfun(@(bool) any(bool==1), {kill_list}, 'uniformoutput', false)) )  == 0)
        if verbose
            fprintf('\nNo markers removed! - all have at least %f% data\n', percent_missing_threshold*100)
        end
        kill_marker = 0;
    end
    if verbose
        fprintf('done\n')
    end
end
    

if bool == 0 % assign kill_marker something if bool == 0 b/c it isnt defined
    kill_marker = 0;    
end
% % % 15oct2015 - is this needed??? ----------------------------------------
% % tmp = ~structfun(@isempty, new)
% % steps/format on how to reach the empty cells in the new structure
% tmp  = struct2cell(new);        % turns new structure into cell array
% % tmp2 = tmp{1}
% tmp2 = cell(size(tmp));
% for i = 1 : length(tmp)
%     tmp_name = char(clean.coords{i});
%     tmp2 = struct2cell(tmp{i}); % removes a cell layer - but it needs loop
%     tmp3 = cellfun(@(idx) cell2mat(idx), tmp2, 'uniformoutput', false); % turn cell structure into matrix - empty marker coords will have an empty vector
%     for j = 1 : length(tmp3)
%         new.(clean.title{i}).(tmp_name(j,:)) = tmp3{j}; % this is what we want to put into structure
%     end
% end
% % a loop in order to access each cell element in tmp
% % tmp3 = {tmp2}
% % tmp4 = struct2cell(tmp3{:})
% 
% % tmp5 = tmp4(~cellfun('isempty', tmp4))
% %indexes per marker into a matrix
% % -----------------------------------------------------------------------
end

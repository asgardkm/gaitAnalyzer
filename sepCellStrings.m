function[output_cell] = sepCellStrings(input_cell, delimeter, usepiece)
% function : with an input cell array, provide the following inputs:
%FORMAT
%       output_cell = sepCellStrings(input_cell, delimeter, usepiece)
%INPUTS
%  input_cell : cell with strings from splitting stuff up (cell)
%  delimeter  : indicates where in each cell element to seperate (string)                 
%  usepiece   : indicate which sections of split string to use (string)
%               - 'start' - use piece before split
%               - 'end'   - use piece after split - default
%               - 'both'  - concactenate both ends w/ delimeter removed
%               from string
%OUTPUTS
% clean_cell  : cell with its string elements processed based on inputs
%               above
% need to change to /s if the delimeter is a space! otherwise it don't work
if delimeter == ' '
    start_str = '\\w*(?=\s)';
    end_str   = '(?<=\s)\\w*';
elseif length(delimeter) > 1 % if the delimeter is more than one character long, dont use bracket!
    % b/c of syntax of bracket w/ regexp - it throws off the subsetting
    start_str = sprintf('\\w*(?=%s)', delimeter);
    end_str   = sprintf('(?<=%s)\\w*', delimeter);
else
    start_str = sprintf('\\w*(?=[%s])', delimeter);
    end_str   = sprintf('(?<=[%s])\\w*', delimeter);
end
% seperate the "Patient X" (startpiece) from the ":RHEE" (endpiece)
startpiece = regexp(input_cell, start_str, 'match');
clean_end    = regexp(input_cell, end_str,   'match');
% 
% [startpiece, endpiece] = cellfun(@(word) (strtok(word, delimeter)), input_cell, 'uniformoutput', false);
% % get idx where it actually happened - get rid of the empty ones w/ no
% % seperation b/c it had no ':'
good_endidx    = cellfun(@(word) ~isempty(word), clean_end);
good_startidx = cellfun(@(word) ~isempty(word), startpiece); % needed for checking purposes (see last if statement) 
% good_end  = endpiece(good_endidx);
% % remove the ':' from the good ends that were split
% clean_end = cellfun(@(word) (word(1+length(delimeter):end)), endpiece(good_end), 'uniformoutput', false);

% based on usepiece, throw processed pieces back into input_cell
if strcmp(usepiece, 'end')
    input_piece = clean_end;
elseif strcmp(usepiece, 'start')
    input_piece = startpiece;
elseif strcmp(usepiece, 'both');
    input_piece = cellfun(@(word1, word2) [word1{:} word2{:}], startpiece, clean_end, 'uniformoutput', false);
else 
    input_piece = clean_end;
end

% if nothing matches, then do nothing and just return the input_cell
if any(good_endidx) ~= 1 && any(good_startidx) ~= 1
    input_cell = input_cell;
else
    input_cell(good_endidx) = input_piece(good_endidx);
end

output_cell = cellfun(@(word) char(word), input_cell, 'uniformoutput', false);
end
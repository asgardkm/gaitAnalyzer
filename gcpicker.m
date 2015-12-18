function [output_tmp] = gcpicker(input, start_idx, end_idx)
% FORM   : output = gcpicker(input, start_idx, end_idx)
%
%function : pulls out select data from the gaitcycles from
%an entire data set of the trial, given that beginning and the end
%of the gaitcycles are known. Also find the average and standard 
%deviation of the pulled data.
% INPUTS : input - input vector from whole dataset you want to analyze per gc
%          start_idx - vector of gc start indexes
%          end_idx   - vector of gc end indexes
% OUPUTS : output - strucuture with vectors of input for each gaitcyle and
%           each gaitcycle's avg and std of that input vector
%
% last edited - 28oct2015 (AKM)
% is now super fast!!! running this function six times takes only 14ms!!
%
% OLD - i believe the code below is slow dont want that :( so wrote new
% code with some vectorization below!
% % for m = 1 : length(start_idx);
% %     output = [output, input((start_idx(m) : end_idx(m)), 1)];
% % end

% find sequence of indexes from start to end for each gaitcycle
% preallocate: 
gc_idx = zeros((end_idx(1)-start_idx(1)+1), length(start_idx));
% get sequence of indexes
for m = 1 : length(start_idx);
   tmp_idx = start_idx(m) : end_idx(m); 
   gc_idx(:, m) = tmp_idx;
end

% get the right indexes w/ assignment
output_tmp     = input(gc_idx);
output.vector  = output_tmp;
% and find the avg and std
output.avg     = mean(output_tmp, 2);
output.std     = std(output_tmp, 0, 2);
end

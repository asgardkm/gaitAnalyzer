function[maxs] = getMaxParams(input_matrix, rawtrial_vector, strideframes, TimeVector)
% FORM : maxs = getMaxParams(input_matrix, strideframes, TimeVector)
%
% function - find parameters about max of a matrix of vectors of a
% parameter for gaitcycles
% created : 28oct2015 (AKM)
% last edited : 9dec2015 (AKM) - added gaitcycle mean and std, rawmat, and
%                                trialvector

maxs.rawtrial_vector = rawtrial_vector; % add raw whole trial data vector
maxs.rawgc_matrix    = input_matrix; % add raw input matrix
maxs.gc_avg          = nanmean(input_matrix, 2); % find avg for each index across the columns of gaits
maxs.gc_std          = nanstd(input_matrix, 0, 2); % find std of above
% get max and its idx
[maxs.max_val, maxs.raw_idx.idx] = max(input_matrix);
% process raw_idxs - if the idx is greater than strideframes (that is, it
% is gone past 100% of the gaitcycle) - then substract from it strideframes
% number of indexes (so that it is with its proper indexes)
maxs.proc_idx.idx = maxs.raw_idx.idx; % assign proc_idx first
target_idx = find(maxs.raw_idx.idx>strideframes); % find target indexes
maxs.proc_idx.idx(target_idx) = round(maxs.proc_idx.idx(target_idx) - strideframes); % apply the minus operation

% get percentage idx (of the gaitcycle) : 
maxs.raw_idx.pidx                = maxs.raw_idx.idx  ./ strideframes;
maxs.proc_idx.pidx               = maxs.proc_idx.idx ./ strideframes;

% get max avg and std
maxs.max_val_avg = mean(maxs.max_val);
maxs.max_val_std = std(maxs.max_val);

% get raw index averages and std - note this is going to be really funky
% b/c the raw indexes haven't been properly designated
maxs.raw_idx.maxavg_idx = mean(maxs.raw_idx.idx);
maxs.raw_idx.maxstd_idx = std(maxs.raw_idx.idx);

maxs.proc_idx.maxavg_idx = mean(maxs.proc_idx.idx);
maxs.proc_idx.magstd_idx = std(maxs.proc_idx.idx);


% get the first derivitave of the original matrix
% maxs.diffmatrix = input_matrix ./ mean(unique(diff(TimeVector)));

end
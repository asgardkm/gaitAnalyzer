function[maxs] = getMaxParams(input_matrix, strideframes, TimeVector)
% function - find parameters about max of a matrix of vectors of a
% parameter for gaitcycles
% created : 28oct2015 (AKM)
% last edited : 28oct2015 (AKM)

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
maxs.maxavg = mean(maxs.max_val);
maxs.maxstd = std(maxs.max_val);

% get raw index averages and std - note this is going to be really funky
% b/c the raw indexes haven't been properly designated
maxs.raw_idx.maxavg_idx = mean(maxs.raw_idx.idx);
maxs.raw_idx.maxstd_idx = std(maxs.raw_idx.idx);

maxs.proc_idx.maxavg_idx = mean(maxs.proc_idx.idx);
maxs.proc_idx.magstd_idx = std(maxs.proc_idx.idx);


% get the first derivitave of the original matrix
maxs.diffmatrix = input_matrix ./ mean(unique(diff(TimeVector)));

end
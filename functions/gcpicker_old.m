function [output, output_avg, output_std] = gcpicker_old(output, input, start_idx, end_idx)
%The function gcpicker will pull out select data from the gaitcycles from
%an entire data set of the trial, given that beginning and the end
%of the gaitcycles are known. Also find the average and standard 
%deviation of the pulled data.
%FORMAT
%  for m = 1 : length(start_idx);   
%    OUTPUT = [OUTPUT, INPUT( (start_idx(m) : end_idx(m)) , 1)];
%  end
%  OUTPUT_avg = mean(OUTPUT, 2);
%  OUTPUT_std = std(OUTPUT, 0, 2);
for m = 1 : length(start_idx);
    output = [output, input((start_idx(m) : end_idx(m)), 1)];
end

output_avg = mean(output, 2);
output_std = std(output, 0, 2);
end

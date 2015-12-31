function[] = combiner(pos_name, pos_coord, pos_values, forces_name, forces_values, combined_file, patient_dir)
%% combine names for marker positions and forces
comb_names = [pos_name forces_name];

% get the 'x y z' string value...
comb_coords = pos_coord(3:5);
% ... and repeat it for each name (for pos and for forces)
comb_coords = repmat(comb_coords, 1, (length(comb_names)-2)/3);
comb_coords = [pos_coord{1:2} comb_coords];

% combine values of positions (nexus) and forces (dflow)
comb_values = [pos_values forces_values];

%% turn cells into a char matrices for writing 
% define the string cell (the one with the names and coords-'X','Y','Z')
strcell = [comb_names; comb_coords];
% make the values matrix into a cell array
valcell = num2cell(comb_values);
% concactenate the two
allcell = [strcell; valcell];

%% write strings and values!
%since the first 2 rows are 0's rewrite them with the strings
sprintf('Please wait, data concatenation in progress...')
comb_trialfile = sprintf('%s%s', patient_dir, combined_file);
fprintf('Data concatentation takes approximately 15-20 seconds, please wait /n')

tic
cell2csv(comb_trialfile, allcell)
toc

end


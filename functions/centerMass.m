function[centermass] = centerMass(SACR, NAVE, oldclean, multiplier)
% function - finds approximation of center of mass of person
%  - averages positions of person's sacrum and navel
%
% FORM : centermass = centerMass(marker.SACR, marker.NAVE)
%
% INPUTS - are in structure form organized by assignMarkers,
% cleanMarkers,  and matchMarkers.
%   marker.SACR - sacrum
%   marker.NAVE - navel
%
% OUPUTS - centermass structure(XYZ) - will be appended to output cell array
%
% - NOTE : changing the size of the datafile structure is not necessary
% here. Since the NAVE and SACR markers have no impact on kinetics and
% kinematics of gait, it makes no sense to get rid of other indexes of
% other markers that do, just because there are empty NAVE and SACR indexes
% lasted edited : 9dec2015(Asgard Kaleb Marroquin) - added multiplier 
%                          -more flexible now for indivudal COM body pieces 
    
%==========================================================================
% FINDING THE POSITON OF THE CENTER OF MASS (AVG OF SACRUM AND NAVEL)
%==========================================================================
% define what you want to call the cell you'll be adding to marker struct
fprintf('Finding center of mass')


%--------------------trimming idx------------------------------------------
% How can i automatize this below? I don't want to do this every time for
% every new function that needs trimming
%   I tried, spent a couple of hours on it, feel like i should move on and
%   look at this later. It is a tad cumbersome and it looks ugly,
%   especially to someone learning the code, but I will probably spend more
%   time trying to create a function that automates below than actually
%   just typing in the variables as a cell input for useMarkerLCD

% save inputs into an array to feed into useMarkerLCD
marray  = {SACR          NAVE};
str_ray = {varname(SACR) varname(NAVE)}; 
all_str = fieldnames(oldclean);
% run function for input cells - take mean of the XYZ cell arrays of the
% SACR and the NAVE to find center of mass
new_marray = useMarkerLCD(marray, str_ray, all_str, oldclean);
sacr = new_marray{1};
nave = new_marray{2};
%--------------end of trimming---------------------------------------------


sacr = struct2cell(sacr);
nave = struct2cell(nave);

% THIS IS WHERE CENTER OF MASS IS CALCULATED
tmp_values = cellfun(@(c1, c2) mean([c1{:} c2{:}], 2) * multiplier, sacr, nave, 'uniformoutput', false);
% get names of SACR - X Y Z
tmp_names = fieldnames(SACR);

% match tmp_values with tmp_names into a structure named cm
for i = 1 : length(tmp_names)
    fprintf('.')
    centermass.(tmp_names{i}) = tmp_values{i};
end
fprintf('done (centermass)\n') % output var name in fprintf

end
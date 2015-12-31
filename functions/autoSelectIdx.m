function[new_marray] = autoSelectIdx(oldclean, varargin)
% function - automatically find LCD of indexes of markers inputted to
% function ( this is invoked from that said function)
% form  : new_marray = autoSelect(varagin, nargin, m_num)
% INPUT : varagin - the input variables (marker structures) in the function
        %         nargin - # of inputs in the function
        %         m_num - # of inputs that are markers - only want to run function
        %         below for this number - don't want to be inputting things like
        %         constants or the clean structure
% OUPUT : new_marray - handy dandy new fixed up marker array!
%
% created : 27oct2015 (Asgard Kaleb Marroquin)
% last edited : 27oct2015 (Asgard Kaleb Marroquin)

% save inputs into an array to feed into useMarkerLCD -don't want to do
% the last nargin - that is oldclean!
all_str = char(fieldnames(oldclean));

for i = 1 : nargin-1
    marray{i}  = varargin{i};
    str_ray{i} = varname(varargin{i}); 
    % run function for input cells - take mean of the XYZ cell arrays of the
    % SACR and the NAVE to find center of mass
end
    new_marray = useMarkerLCD(marray, str_ray, all_str, oldclean);

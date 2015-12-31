function[f1, f2] = getGRF(clean)
% function - find ground force reactions
% form     : grf = getGRF(clean, bool)
%    input : clean - structure with all trial data 
%            proceed with function
%   output : grf   - list with ground force reactions (xyz) for 2 feet 
%       created : 16oct2015
%       last edited : 19oct2015
%
% the way the ground force reactions are set up (according to dflow) : 
% X component - side to side forces
% Y component - vertical forces
% Z component - horizontal forces (forward and back)
%==========================================================================
%                       FINDING THE GROUND REACTION FORCES
%==========================================================================
fprintf('Finding ground reaction forces...')
%assign forces in clean to variables
%Filter the force values with the FilterMe function for smoother graphs
f1.X = FilterMe(clean.FP1For.X, 2, 0.1);
f1.Y = FilterMe(clean.FP1For.Y, 2, 0.1);
f1.Z = FilterMe(clean.FP1For.Z, 2, 0.1);

f2.X = FilterMe(clean.FP2For.X, 2, 0.1);
f2.Y = FilterMe(clean.FP2For.Y, 2, 0.1);
f2.Z = FilterMe(clean.FP2For.Z, 2, 0.1);

fprintf('done (grf1, grf2)\n')
end
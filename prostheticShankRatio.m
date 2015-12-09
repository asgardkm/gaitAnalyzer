function[pRatio] = prostheticShankRatio(ldistavg, rdistavg)
% function - find length ratio of the person's prosthetic wrt to the
% person's shank length
% form  : pRatio = prostheticShankRatio(ldistavg, rdistavg)
% INPUT : -ldistavg - left shank length
%         -rdistavg - right shank length
%           note both inputs are from kinematics.dist_knee2ank.ldist (dist_Knee2Ank.m function)
%
% OUTPUT : pRatio - ratio of shorter dist shank length to higher dist shank
%          length
% created : 27oct2015 (Asgard Kaleb Marroquin)
% lasted edited : 27oct2015 (Asgard Kaleb Marroquin)

%==========================================================================
% CALCULATING THE PROSTHESES - SHANK LENGTH RATIO
if ldistavg < rdistavg;
    pRatio = (ldistavg / rdistavg) * 100;
else
    pRatio = (rdistavg / ldistavg) * 100;
end
pRatio = sprintf('%g%%', pRatio);
%==========================================================================

end
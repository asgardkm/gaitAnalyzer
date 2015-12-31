function[angleVel, LKVshift] = jointAngleVelocity(gc_angle, gc_info, strideframes, time, order)
% function - find the knee angle velocity of patient during gait. Angles are broken
% up into individual gait cycles.
%
% inputs  : gc_angle     - contains joint angle data
%           gc_info      - contains gaitcycle starts and stops
%           strideframes - # of frames per gaitcycle (aka stride)
%           time         - time vector
%           order        - order of derivative 
%
% outputs : anglevel     - structure with information about joint angle parameters
%           LKVshift     - bool for some old LKV nan cleaning (feeds to
%                          acceleration function
%
% created 9dec2015
% last edited 9dec2015

%% FIND THE Angular Velocity
% found by taking derivaties of joint angles wrt percentage gaitcycle
% vectors

% disp info:
if order == 1
    fprintf('Finding gaitcycle joint angle velocities...')
elseif order == 2
    fprintf('Finding gaitcycle joint angle accelerations...')
end

% percentvector
percentvector = gc_info.percentvector;

% diff the raw trial data vectors
ranklevel = diff(gc_angle.rankle.rawtrial_vector) ./ diff(time(order:end)); 
lanklevel = diff(gc_angle.lankle.rawtrial_vector) ./ diff(time(order:end));
rkneevel  = diff(gc_angle.rknee.rawtrial_vector)  ./ diff(time(order:end));
lkneevel  = diff(gc_angle.lknee.rawtrial_vector)  ./ diff(time(order:end));
rhipvel   = diff(gc_angle.rhip.rawtrial_vector)   ./ diff(time(order:end));
lhipvel   = diff(gc_angle.lhip.rawtrial_vector)   ./ diff(time(order:end));

% define a time matrix
STP = repmat(percentvector./100, length(gc_angle.rankle.rawtrial_vector(1,:)) , length(gc_angle.rankle.rawgc_matrix(1,:))); 
STP = STP(1:end-(order-1), :);

% diff the raw trial gaitcycle data vectors
RAV = diff(gc_angle.rankle.rawgc_matrix) ./ diff(STP);
LAV = diff(gc_angle.lankle.rawgc_matrix) ./ diff(STP);
RKV = diff(gc_angle.rknee.rawgc_matrix)  ./ diff(STP);
LKV = diff(gc_angle.lknee.rawgc_matrix)  ./ diff(STP);
RHV = diff(gc_angle.rhip.rawgc_matrix)   ./ diff(STP);
LHV = diff(gc_angle.rhip.rawgc_matrix)   ./ diff(STP);

% filter the data above
RAV = FilterMe(RAV, 2, 0.1);
LAV = FilterMe(LAV, 2, 0.1);
RKV = FilterMe(RKV, 2, 0.1);
LKV = FilterMe(LKV, 2, 0.1);
RHV = FilterMe(RHV, 2, 0.1);
LHV = FilterMe(LHV, 2, 0.1);


% must be some old cleaning - LKV must've had some nans in there somewhere
 if any(isnan(LKV(:))) == 0;
     LKVshift = 0;
 end
for k = 1 : length(LKV(:,1))
     if any(isnan(LKV(:))) == 1;
        if isnan(LKV(:,k)) == 1;
            LKV(:,k) = [];
            LKVshift = 1;
        end
     end
end


% output to user:
if order == 1
    fprintf('done (gc.angleVel)\n')
elseif order == 2
    fprintf('done (gc.angleAcc)\n')
end
%% get parameters
angleVel.lankle = getMaxParams(LAV, lanklevel, strideframes, time(order:end));
angleVel.rankle = getMaxParams(RAV, ranklevel, strideframes, time(order:end));

angleVel.lknee  = getMaxParams(LKV, lkneevel,  strideframes, time(order:end));
angleVel.rknee  = getMaxParams(RKV, rkneevel,  strideframes, time(order:end));

angleVel.lhip   = getMaxParams(LHV, lhipvel,   strideframes, time(order:end));
angleVel.rhip   = getMaxParams(RHV, rhipvel,   strideframes, time(order:end));

end
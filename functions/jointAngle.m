function[angle] = jointAngle(LLEK, RLEK, LLM, RLM, LGTRO, RGTRO, LTOE, RTOE, gc_info, strideframes, time, dataparams)
% function - find the knee angle of patient during gait. Angles are broken
% up into individual gait cycles.
% inputs  : LLEK         - left knee
%           RLEK         - right knee
%           LLM          - left ankle
%           RLM          - right ankle 
%           LGTRO        - left hip
%           RGTRO        - right hip
%           LTOE         - left toe
%           RTOE         - right toe
%           gc_info      - contains gaitcycle starts and stops
%           strideframes - # of frames per gaitcycle (aka stride)
%           time         - time vector
%           dataparams
% outputs : angle        - structure with information about joint angle parameters
%
%
% created 9dec2015
% last edited 9dec2015
%
%==========================================================================
%FIND THE ABSOLUTE ANGLES OF THE JOINTS
%==========================================================================
%Calculating angle displacement of the ankles, knees, and hip. The
%following angles that will be caluclated are absolute; that is, all these
%angles are the displacement of the joint below a straight horizontal
%imaginary line at the said joint's height.
fprintf('Finding gaitcycle joint angles...')
%% defining variables from markers (and starts and stops)
starts = gc_info.starts;
stops = gc_info.stops;

% define directions from mainConfig.txt (30dec2015
forward = dataparams.forward_marker;
vertical = dataparams.vertical_marker;

% assign
YRightAnkle = RLM.(vertical);
ZRightAnkle = RLM.(forward);
YRightToe   = RTOE.(vertical);
ZRightToe   = RTOE.(forward);
YRightKnee  = RLEK.(vertical);
ZRightKnee  = RLEK.(forward);
YRightHip   = RGTRO.(vertical);
ZRightHip   = RGTRO.(forward);

YLeftAnkle  = LLM.(vertical);
ZLeftAnkle  = LLM.(forward);
YLeftToe    = LTOE.(vertical);
ZLeftToe    = LTOE.(forward);
YLeftKnee   = LLEK.(vertical);
ZLeftKnee   = LLEK.(forward);
YLeftHip    = LGTRO.(vertical);
ZLeftHip    = LGTRO.(forward);

%Right Ankle
rahoriz     = YRightAnkle - YRightToe;
ravert      = ZRightAnkle - ZRightToe;
%Left Ankle
lahoriz     = YLeftAnkle - YLeftToe;
lavert      = ZLeftAnkle - ZLeftToe;
%Right Knee
rkhoriz     = YRightKnee - YRightAnkle;
rkvert      = ZRightKnee - ZRightAnkle;
%Left Knee
lkhoriz     = YLeftKnee - YLeftAnkle;
lkvert      = ZLeftKnee - ZLeftAnkle;
%Right Hip Marker
rhhoriz     = YRightHip - YRightKnee;
rhvert      = ZRightHip - ZRightKnee;
 %Left Hip Marker
lhhoriz     = YLeftHip - YLeftKnee;
lhvert      = ZLeftHip - ZLeftKnee;

%Preallocation of all the arrays that angle data will go into
rankleangle = zeros(length(ravert), 1);
lankleangle = zeros(length(lahoriz), 1);
rkneeangle  = zeros(length(rkhoriz), 1);
lkneeangle  = zeros(length(lkhoriz), 1);
rhipangle   = zeros(length(rhhoriz), 1);
lhipangle   = zeros(length(lhhoriz), 1);

%% define slopes and apply atan2 to the positive and negative aspects of vector
rankleslope = rahoriz .* ravert;
    ranklepos = rankleslope > 0;
    rankleneg = rankleslope < 0;
lankleslope = lahoriz .* lavert;
    lanklepos = lankleslope > 0;
    lankleneg = lankleslope < 0;
rkneeslope  = rkhoriz .* rahoriz;
    rkneepos  = rkneeslope > 0;
    rkneeneg  = rkneeslope < 0;
lkneeslope  = lkhoriz .* lahoriz;
    lkneepos  = lkneeslope > 0;
    lkneeneg  = lkneeslope < 0;
rhipslope   = rhhoriz .* rhvert;
    rhippos   = rhipslope > 0;
    rhipneg   = rhipslope < 0;
lhipslope   = lhhoriz .* lhvert;
    lhippos   = lhipslope > 0;
    lhipneg   = lhipslope < 0;

%% define the ankle/knee/hip angles with arctan
% ankle angles
rankleangle(ranklepos) = atan2(ravert(ranklepos), rahoriz(ranklepos));
rankleangle(rankleneg) = atan2(ravert(rankleneg), rahoriz(rankleneg));
lankleangle(lanklepos) = atan2(lavert(lanklepos), lahoriz(lanklepos));
lankleangle(lankleneg) = atan2(lavert(lankleneg), lahoriz(lankleneg));

% knee angles
rkneeangle(rkneepos) = atan2(rkvert(rkneepos), rkhoriz(rkneepos));
rkneeangle(rkneeneg) = atan2(rkvert(rkneeneg), rkhoriz(rkneeneg));
lkneeangle(lkneepos) = atan2(lkvert(lkneepos), lkhoriz(lkneepos));
lkneeangle(lkneeneg) = atan2(lkvert(lkneeneg), lkhoriz(lkneeneg));

% hip angles 
rhipangle(rhippos) = atan2(rhvert(rhippos), rhhoriz(rhippos));
rhipangle(rhipneg) = atan2(rhvert(rhipneg), rhhoriz(rhipneg)) + pi; % add pi for a full revelution, b/c of issue w/ hip angles
lhipangle(lhippos) = atan2(lhvert(lhippos), lhhoriz(lhippos));
lhipangle(lhipneg) = atan2(lhvert(lhipneg), lhhoriz(lhipneg)) + pi; % add pi again
%
% note - i didnt add pi for the knee and ankle since they don't need them,
% but i found the neg and pos slope indexes anyways so that if for whatever
% reason, they can be modified with easily in the future (if needed)

% feed angles (in rads) into gcpicker

RAtheta = gcpicker(rankleangle, starts, stops);
LAtheta = gcpicker(lankleangle, starts, stops);
RKtheta = gcpicker(rkneeangle,  starts, stops);
LKtheta = gcpicker(lkneeangle,  starts, stops);
RHtheta = gcpicker(rhipangle,   starts, stops);
LHtheta = gcpicker(lhipangle,   starts, stops);

%% angle corrections?
% 9dec2015 - why did i do this stuff below? will comment out because it was
% doing something, but must keep in mind to check this if angles are
% returning funky

%The right ankle angle was somehow returning a negative value (in only one
%column trial) in V_NW1_1 - this piece of code is its correction
for k = 1 : length(RAtheta(1,:));
    for i = 1 : length(RAtheta(:,1));
        if RAtheta(i,k) < 0; 
            if abs(RAtheta(i,k)) > mean(RAtheta,2);
            RAtheta(i,k) = -RAtheta(i,k);  
            end
        end
    end
end %end of correction

%Same goes for left ankle (V_PS3_1)
for k = 1 : length(LAtheta(1,:));
    for i = 1 : length(LAtheta(:,1));
        if LAtheta(i,k) < 0; 
            if abs(LAtheta(i,k)) > mean(LAtheta,2);
            LAtheta(i,k) = -LAtheta(i,k);  
            end
        end
    end
end %end of correction


%Might as well do it for the other two joints, while we're at it, for some
%extra backend automatic debugging (you never know):

%Right Knee
for k = 1 : length(RKtheta(1,:));
    for i = 1 : length(RKtheta(:,1));
        if RKtheta(i,k) < 0; 
            if abs(RKtheta(i,k)) > mean(RKtheta,2);
            RKtheta(i,k) = -RKtheta(i,k);  
            end
        end
    end
end

%Left Knee
for k = 1 : length(LKtheta(1,:));
    for i = 1 : length(LKtheta(:,1));
        if LKtheta(i,k) < 0; 
            if abs(LKtheta(i,k)) > mean(LKtheta,2);
            LKtheta(i,k) = -LKtheta(i,k);  
            end
        end
    end
end


% %Right Hip
% for k = 1 : length(RHtheta(1,:));
%     for i = 1 : length(RHtheta(:,1));
%         if RHtheta(i,k) < 0; 
%             if abs(RHtheta(i,k)) > mean(RHtheta,2);
%             RHtheta(i,k) = -RHtheta(i,k);  
%             end
%         end
%     end
% end
% 
% %Left Hip
% for k = 1 : length(LHtheta(1,:));
%     for i = 1 : length(LHtheta(:,1));
%         if LHtheta(i,k) < 0; 
%             if abs(LHtheta(i,k)) > mean(LHtheta,2);
%             LHtheta(i,k) = -LHtheta(i,k);  
%             end
%         end
%     end
% end

%end of all joint std corrections

%display output for user
fprintf('done (gc.angle)\n')
%% run getMaxParams function and get parameters
angle.lankle = getMaxParams(LAtheta, lankleangle, strideframes, time);
angle.rankle = getMaxParams(RAtheta, rankleangle, strideframes, time);

angle.lknee  = getMaxParams(LKtheta, lkneeangle,  strideframes, time);
angle.rknee  = getMaxParams(RKtheta, rkneeangle,  strideframes, time);

angle.lhip   = getMaxParams(LHtheta, lhipangle,   strideframes, time);
angle.rhip   = getMaxParams(RHtheta, rhipangle,   strideframes, time);

end
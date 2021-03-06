function[stride, lstep, rstep] = findStride(LHEE, RHEE, frequency, frame, dataparams)
%    form   : [stride, lstep, rstep] = findStride(clean.LHEE, clean.RHEE, frequency)
%
% function - find step time, distances, and stride values
%
%    inputs : clean.LHEE - left ankle points
%             clean.RHEE - right ankle points
%             frequency  - frequency in Hz of the camera
%             frame
%             dataparams
%
%    ouputs : stride.(dist/time).(avg, std, vector/time_in_frames),
%             lstep.(dist/time).(avg, std, vector, idx),
%             rstep.(dist/time).(avg, std, vector, idx)
%
%    created     : 19oct2015 (AKM)
%    last edited : 24nov2015 (AKM) - revising while statements - they go
%       infinite if conditions aren't met! something is wrong with the
%       index diff values b/c lengths are not matching - maybe person's
%       gait is really messed up? (looking @ NinaW20001.txt)
%
%% CODE
%==========================================================================
%FINDING THE STEP DISTANCE OF BOTH FEET
%==========================================================================
fprintf('Finding trial step parameters')
%     YLeftStep  = RHEE.Y - LHEE.Y;
%     YRightStep = LHEE.Y - RHEE.Y;

% assign forward direction for mainConfig.txt (30dec2015)
forward_dir = dataparams.forward_marker;

YLeftStep  = FilterMe(RHEE.(forward_dir) - LHEE.(forward_dir), 2, 0.1); % Left Step = Right Heel Pos - Left Heel Pos
YRightStep = FilterMe(LHEE.(forward_dir) - RHEE.(forward_dir), 2, 0.1); % Right Step = vice versa of above
%Butterworth filter to smooth out data - necessary to find the peaks of
%the heel steps.   

% AbsRightStep = abs(YRightStep);    %Need the abs value in order to find 
% AbsLeftStep = abs(YLeftStep);      %the maximum values.

% [LeftStep, LeftStep_Idx]   = findpeaks(AbsRightStep);
%     %Find maximums of Left Step Graph (and their indeces).
% [RightStep, RightStep_Idx] = findpeaks(AbsLeftStep);
%     %Find maximums of Right Step Graph (and their indeces).
%     
%==========================================================================
% FINDING THE MAXIMUM VALUES OF STRIDE DISTANCE AND STRIDE TIME BY FINDING
% THE MAXIMUMS BETWEEN THE ZEROES OF THE RELATIVE L-R HEEL POSITIONS GRAPH
%==========================================================================

% Since YLeftStep = YRightHeel - YLeftHeel --> Right Heel Position
% (horiz) - Left Heel Position (horiz),
% if the YLeftStep switches from Negative to Positive, then the Left
% Heel is passing the Right Heel(Right Heel is on ground, and Left Heel is in the air).
% if the YLeft Step switches from Positive to Negative, then the Right
% Heel is passing the Left Heel(Left Heel is on ground, and Right Heel
% is in the air).
Lstep_unit = bsxfun(@ldivide, YLeftStep,  abs(YLeftStep));
Rstep_unit = bsxfun(@ldivide, YRightStep, abs(YRightStep));
% 19oct2015 - yay vectorization :)
% Therefore, when the above situation occurs, the zeroes that occur are
% saved into an array - save indexes where step_unit switches sign
ZeroLStep_idx = find(Lstep_unit(1:end-1).*Lstep_unit(2:end) < 0);
ZeroRStep_idx = find(Rstep_unit(1:end-1).*Rstep_unit(2:end) < 0);


%19oct2015 - commented out Zero values becaues they are only needed for
%graphing purposes
% and get the values for those indexes
% ZeroLStep = YLeftStep(ZeroLStep_idx);
% ZeroRStep = YLeftStep(ZeroRStep_idx);    %Same as above - will result
% in same points but need both zeroes to calculate peaks from the two
% different graphs.
% do i need averages? - 19oct2015
% ZeroLStepAvg = mean(ZeroLStep);
% ZeroRStepAvg = mean(ZeroRStep);


%Now that we have the zeroes of the step graph comparing the relative position of
%the right and left heels, we can now calculate the maximum distance
%distance between the right and left heels - which would also be
%heel-strike. 
%This max distance is the stride distance (when all the max
%distances are averaged.)

%Should the zero index be larger than the actual time of
%the trial, then simply trim the last value of the array one by one until
%it fits.
ZeroLStep_idx = ZeroLStep_idx(ZeroLStep_idx<=length(frame));  
ZeroRStep_idx = ZeroRStep_idx(ZeroRStep_idx<=length(frame));

%The index of the max (or the heel-strike) can be used to find the time of
%the heelstrike, and this the stride time(when the difference of indexes 
%between maxes / heel strikes are averaged. - cant figure out how to
%vectorize
for i = 2 : length(ZeroLStep_idx);  

    [MaxLStep(i-1,1), ~] = max(YLeftStep(ZeroLStep_idx(i-1,:)  : ZeroLStep_idx(i,:)));
    [MaxRStep(i-1,1), ~] = max(YRightStep(ZeroRStep_idx(i-1,:) : ZeroRStep_idx(i,:)));
    fprintf('.')
end

%NOTE: POSITIVE MAXIMUM OF RIGHT HEEL - LEFT HEEL ( OR YLEFTSTEP) IS A LEFT HEEL
%    STRIKE
%    : POSITIVE MAXIMUM OF LEFT HEEL - RIGHT HEEL ( OR YRIGHTSTEP) IS A RIGHT HEEL
%    STRIKE
%
%    THIS IS BECAUSE THE NEGATIVE OF ABOVE IS TRUE WHEN THE GRAPH IS
%    NEGATIVE, 
%    THAT IS, THE NEGATIVE MAXIMUM OF RIGHT HEEL - LEFT IS A RIGHT HEEL STRIKE,
%    AND THE NEGATIVE MAXIMUM OF LEFT HEEL - RIGHT HEEL IS A LEFT HEEL STRIKE
%    ( WHICH IT IS - DIRECTION IS NEGATIVE IN THE CAREN SYSTEM, SO THE SIGN 
%    MUST BE CHANGED - DONE BY CHANGING THE GRAPH THAT IS BEING ANALYZED)

%Purge zeroes from data (would there even be any now by this point?) 
MaxLStepall = MaxLStep(MaxLStep~=0);
MaxRStepall = MaxRStep(MaxRStep~=0);

         
%when finding the max steps : since the feet alternate, there will be
%alternating high and low maxes for each foot. We only want the high maxes
%for each foot - the functions below take care of that by pulling the
%correct indexes.
maxl_idx = bsxfun(@ge, MaxLStepall, MaxRStepall);
maxr_idx = bsxfun(@ge, MaxRStepall, MaxLStepall);

% 21nov2015 - NEED TO FIND IF ANY ELEMENTS REPEAT 1 - THAT IS, GET THE
% INDEX OF ANY VALUE 1 THAT SHOULD BE A 0 WHEN CONSIDERING A 101010...
% ALTERNATING PATTERN - need to get rid of these! may be caused from 
% stumbling in trial? b/c maxes of same foot are one after the other

% first get indexes of where the 1's are in each vector
% maxl_ones = find(maxl_idx == 1);
% maxr_ones = find(maxr_idx == 1);

% checking for double-counted left indexes
leftcheck1 = find(diff(maxr_idx) == 0) + 1 ;
leftcheck2 = find(diff(maxl_idx) == 0) + 1 ; % is the plus one because of the way diff works - we want 
%   to get rid of the index AFTER a difference of one is detected - we don't
%   want to get rid of the index BEFORE the repeat.
leftcheck  = intersect(leftcheck1, leftcheck2);
%     leftcheck  = leftcheck(1);
% 
%     % checking for double-counted right indexes
%     rightcheck1 = maxr_ones(diff(maxl_ones) > 2) + 1;
%     rightcheck2 = maxr_ones(diff(maxr_ones) < 2) + 1;
%     rightcheck  = intersect(rightcheck1, rightcheck2);

% filter out the check indexes from the max_idx vectors - this will get rid
% of funny duplicates
maxl_idx(leftcheck)  = [];
%     maxl_idx(rightcheck) = [];
%     maxr_idx(rightcheck) = [];
maxr_idx(leftcheck)  = [];


% %Find the indexes of the heel strikes (or maxes of relative L-R heel positions) 
% %==========================================================================
% %Just cycle through all the YLeftStep values. When a match is found with
% %the MaxLStep - the heel strike -, the according frame is assigned to the
% %index 
% % 24nov2015- but don't need to, just use the index option in using max function
% %above! commenting out below by implenting index option above
% % 24nov2015 - actually you do want to keep those intersect functions b/c
% % those tell you the index value for the ENTIRE trial (which is needed for
% % the while loops below). The index value from the max function would
% % return the index in that gaitcycle, which will be found anyways
% % afterwards. 
% %
% % 19oct2015 - vectorize and use intersect!
[~, ~, MaxLStep_idx] = intersect(MaxLStepall, YLeftStep,  'stable');
[~, ~, MaxRStep_idx] = intersect(MaxRStepall, YRightStep, 'stable');


% get the MaxStep data from the cleaned up max_idx vectors
MaxLStep = MaxLStep(maxl_idx);
MaxRStep = MaxRStep(maxr_idx);

% and pull out the indexes as well
MaxLStep_idx = MaxLStep_idx(maxl_idx);
MaxRStep_idx = MaxRStep_idx(maxr_idx);

%Need to find another parameter in dealing with the little ones, because
%some data sets have hiccups in the step pattern, throwing the mean off
% 19oct2015 - found it! just alternate the steps - the low values for one
% foot are the high values for the other - takes care of lots of issues


%Should, for whatever reason there be more Right Heel Strikes than Left
%Heel Strikes ( or vice versa), just get rid of the last value from the
%greater value until the two are equal. - 19oct2015 is this necessary? -
%yes believe so, but it can be done much better - see awesome code below:)

% it may be - but you don't have to deal with both step values and idx at
% the same time. just deal with indexes! You can assign values after the
% indexes are all organized

% do a sample counter for while loop
counter = 1;

% 24nov2015 - will try using "key" flags for restricting while loop,
% because it is running infinitly - that's not good
% toggle key to be zero when each of the four conditions below fail to
% occur - that means that the two step_idx vectors are now the same size
key = 1;
while key == 1;
    %WHILE LEFT FOOT VECTOR IS LONGER THAN RIGHT FOOT VECTOR ---------------

    %Compare number of Left and Right Step Indexes to make sure they are also equal.  
    % while the left foot idx vector is longer...
    if length(MaxLStep_idx) > length(MaxRStep_idx);
        % check if last left value is bigger than the right ft's last value
            if MaxLStep_idx(end) > MaxRStep_idx(end)
                % if so, then trim the last value
                MaxLStep_idx = MaxLStep_idx(1:end-1);   
%                 continue % jump - to check whether vectors are now equal
                % otherwise, vector will feed to next piece of while loop
                key1 = 1;
            else
                key1 = 0;
            end
        % check if left first value is bigger than the right ft's first value
            if MaxLStep_idx(1) > MaxRStep_idx(1)
                MaxLStep_idx = MaxLStep_idx(2:end);
                key2 = 1;
            else
                key2 = 0;
            end

    else
        key1 = 0; key2 = 0;
    end % end of nested if loop
    %----------------------------------------------------------------------  

    %WHILE RIGHT FOOT VECTOR IS LONGER THAN LEFT FOOT VECTOR --------------

    % while the right foot idx vector is longer...
    if length(MaxRStep_idx) > length(MaxLStep_idx);
        % check if last right value is bigger than the left ft's last value
            if MaxRStep_idx(end) > MaxLStep_idx(end)
                % if so, then trim the last value
                MaxRStep_idx = MaxRStep_idx(1:end-1);
%                 continue % jump - to check whether vectors are now equal
                % otherwise, vector will feed to next piece of while loop
                key3 = 1;
            else
                key3 = 0;
            end
        % check if right first value is bigger than the left ft's first value
            if MaxRStep_idx(1) > MaxLStep_idx(1)
                MaxRStep_idx = MaxRStep_idx(2:end);
                key4 = 1;
            else
                key4 = 0;
            end

    else
        key3 = 0; key4 = 0;
    end % end of nested if loop


    % bring all the key bools together - if all of them are equal to zero,
    % then the parent key bool will toggle zero, and the loop should stop
    % looping 
    if ~any([key1 key2 key3 key4])
        key = 0;
    else
        key = 1;

        % ping the counter
        counter = counter + 1;

    end

fprintf('-')
end % end of big while loop


% now set the values to be the values determined by the indexes!
MaxLStep = YLeftStep(MaxLStep_idx);
MaxRStep = YRightStep(MaxRStep_idx);

fprintf('done (lstep,rstep)\n') % fprintf for finished calculating step data
% CONFIGURING OUTPUTS
%==========================================================================
%CALCULATING THE STRIDE AND STEP DISTANCES
%==========================================================================
fprintf('Finding trial stride parameters...')

%Stride
%Stride = Right step + Left step
Stride = bsxfun(@plus, MaxRStep, MaxLStep);
StrideAvg = mean(Stride); % Average Stride distance 
StrideStd = std(Stride);  % Std of Stride distance

%Right Step
RStep = MaxRStep;       % Shorten for convenience.
RStepAvg = mean(RStep); % Average STEP distance of Right Heel
RStepStd = std(RStep);

%Left Step
LStep = MaxLStep;       %Shorten for convenience.
LStepAvg = mean(LStep); % Average STEP distance of Left Heel
LStepStd = std(LStep);

%==========================================================================
%CALCULATING THE STRIDE AND STEP TIMES
%==========================================================================

%Step - convert frames into seconds based on # of Hz by camera
RStep_timeidx = MaxRStep_idx./frequency;
LStep_timeidx = MaxLStep_idx./frequency;

%Preallocation
RStep_time = zeros(length(RStep_timeidx), 1);
LStep_time = zeros(length(RStep_timeidx), 1);

%Takes the difference between the index(which is now in seconds) of the 
%maximum right heel strike and maximum left heel strike in order to find
%the time it took to go from right heel strike to left heel strike, thus
%finding Right STEP Time (and vice versa).
% 190ct2015 - dont know how to vectorize - will leave alone for now
if LStep_timeidx(1) < RStep_timeidx(1);
    for i = 2:length(RStep_timeidx);
        RStep_time(i-1,:) = abs(RStep_timeidx(i) - LStep_timeidx(i));
        LStep_time(i-1,:) = abs(LStep_timeidx(i) - RStep_timeidx(i-1));
    end

elseif RStep_timeidx(1) < LStep_timeidx(1);
    for i = 2:length(RStep_timeidx);
        RStep_time(i-1,:) = abs(RStep_timeidx(i) - LStep_timeidx(i-1));
        LStep_time(i-1,:) = abs(LStep_timeidx(i) - RStep_timeidx(i));
    end
end

%Reassigns name of Right and Left STEP times for convenience
RST = RStep_time;
LST = LStep_time;

%Right and Left STEP Time averages and std
RSTAvg = mean(RST);
LSTAvg = mean(LST);

RSTStd = std(RST);
LSTStd = std(LST);

%Stidetime
Stridetime = bsxfun(@plus, LST, RST); % STRIDE Time = Right STEP Time + Left STEP Time

%Average STRIDE Time (taking average of all the L-R STEP sums) in TIME [s]
StridetimeAvg = mean(Stridetime); 
%STRIDE time std
StridetimeStd = std(Stridetime);

%Average STRIDE "Time" in frameS
Stridetimeframes = StridetimeAvg*frequency;

fprintf('done (stride)\n') % fprintf for finished calculating stride data

% Outputs
% ouputs : stride.(dist/time).(avg, std, vector/time_in_frames),
%          lstep.(dist/time).(avg, std, vector, idx),
%          rstep.(dist/time).(avg, std, vector, idx)

%stride
stride.dist.avg    = StrideAvg;
stride.dist.std    = StrideStd;
stride.dist.vector = Stride;
%stridetime
stride.time.avg            = StridetimeAvg;
stride.time.std            = StridetimeStd;
stride.time.vector         = Stridetime;
stride.time.time_in_frames = Stridetimeframes;
%lstep
lstep.distavg     = LStepAvg;
lstep.diststd     = LStepStd;
lstep.distvector  = LStep;
lstep.distidx     = MaxLStep_idx;
lstep.timeavg     = LSTAvg; 
lstep.timestd     = LSTStd;
lstep.timevector  = LST;
lstep.timeidx     = LStep_timeidx;
%rstep
rstep.distavg     = RStepAvg;
rstep.diststd     = RStepStd;
rstep.distvector  = RStep;
rstep.distidx     = MaxRStep_idx;
rstep.timeavg     = RSTAvg; 
rstep.timestd     = RSTStd;
rstep.timevector  = RST;
rstep.timeidx     = RStep_timeidx;

end 
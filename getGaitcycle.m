function[gc_info] = getGaitcycle(f1_vert, frame, Time, stridetime_struct, LFB, UFB, gc_percent)
% function - get gaitcycles of the trial!
% form    :  = getGaitcycle(kinetics.gfr1.vert, frame, LFB, UFB)
% INPUTS  : kinetics.gfr1.vert - vertical ground force reaction of foot1
%          frame - frames of trial
%          time - derived from frame/frequency
%          stridetime_struct - kinematics.stride.time struct build from
%          findStride.m - need the frames/stride & stridetimeavg values
%          LFB - lower force bound for finding start of force hill
%          UFB - upper force bound for finding start of force hill
%          gc_percent - input constant - choose what percentage of the gait
%          cycle you want to include in a gaitcycle calculation (%100,
%          %150, etc - would be inputted as 1, 1.5, etc)
% OUTPUTS : gc_info - structure w/ gc starts, stops, timevector, and
%           gc_stride_percent values per index
% created     : 12oct2015 (AKM)
% last edited : 28oct2015 (AKM)
%==========================================================================
%FINDING THE START POINTS AND INDEXES OF THE GAIT CYCLE
%==========================================================================
fprintf('Finding gaitcycles')
% Assign values from stridetime input strucutre
Stridetimeframes = stridetime_struct.time_in_frames;
StridetimeAvg    = stridetime_struct.avg;
%Calculating slope/(velocity) of the vertical force graph
V1slope = diff(f1_vert)./diff(frame);
% V2slope = diff(f2.vert)./diff(frame);

% If the velocity is positive (force graph is increasing), and the the
% value chosen is between two force thresholds (they are low threshhold
% chosen specifically so that one point at the very bottom of the force
% graph is chosen)
%vectorization!
slope_idx1  = find(f1_vert>LFB & f1_vert<UFB);
slope_idx2 = find(V1slope > 0);
slope_idx = intersect(slope_idx1, slope_idx2, 'stable'); % get idx for below
slope_val = f1_vert(slope_idx);  % set this force value as the start of the force hill
% for i = 1:length(V1slope);
%     % If the velocity is positive (force graph is increasing), and the the
%     % value chosen is between two force thresholds (they are low threshhold
%     % chosen specifically so that one point at the very bottom of the force
%     % graph is chosen)
%     if V1slope(i) > 0 && f1_vert(i) > LFB && f1_vert(i) < UFB;
%         V1start(i,:) = f1_vert(i); % set this force value as the start of the force hill
%         V1start_idx(i,:) = frame(i); % as well as the index
%     end
% end
% 
% %Purge the zeroes from the data
% V1start = V1start(V1start~=0);
% V1start_idx = V1start_idx(V1start_idx~=0);

% V1start = V1start((end-(end-2)):end-2);
% V1start_idx = V1start_id-x((end-(end-2)):end-2);

%If an index is counted "twice" - that is, a step value produced two very
%close index values because both of those indexes hold the same step value
%- then get rid of the second index, because otherwise, the extra index
%will shift all the step positions after the second index and will mess up
%the data
%Two seperate for loops for each leg because, due to a possible extra
%index, the two legs may not have the same number of indexes - so the same
%length-of-index parameter cannot be applied
%Left
counter = 0;

%GOAL: to get the closest possible consistent match of beginning gaitcycle
%point. To do this, a number of points at the beginning of each gait cycle
%have been identified. The procudure to get the closest "match" (the
%closest force value) for each hill is the following:
%   1. Get the individual mean force value of the points on each hill. - is
%   this necessary? 
%   2. Get the mean of all of these hill means.
%   3. Find the closest match from the points on each hill to the mean of
%   all the hills. This will be the point chosen for the gaitcycle start.

%organize each hill force point for each hill (1 hill= 1 column)
k = 1;
for i = 2 : length(slope_idx);
   if slope_val(i) - slope_val(i-1) < 29;
       hillstart(i-1,k) = slope_val(i-1);
       hillstart_idx(i-1,k) = slope_idx(i-1);
       
   else 
       hillstart(i-1,k) = slope_val(i-1);
       hillstart_idx(i-1,k) = slope_idx(i-1);
       k = k + 1;   
   end 
     fprintf('.') % display counter for force slope indexes 
end

%average of all the force hill starts
hillmean = mean(slope_val);
% hillstart_z = hillstart(hillstart~=0); % not needec

for k = 1 : length(hillstart(1,:));
    for i = 1 : length(hillstart(:,1));
        d(i,k) = abs(hillstart(i,k) - hillmean);
        [cstart_f(1,k) cstart_idx(1,k)] = min(d(:,k));
        
    end
      fprintf('-') % display counter for clean maxes 
end

% only take first row if the size is too big
csize = size(cstart_idx);
if csize(1) > 1
    cstart_idx = cstart_idx(1,:);
end
cstart_idx = cstart_idx';

cstart_idx = slope_idx(cstart_idx);

while counter < 3; 
for i = 2 : length(cstart_idx);
   if cstart_idx(i) - cstart_idx(i-1) < 20;
       cstart_idx(i) = 0;
   end
end
cstart_idx = cstart_idx(cstart_idx~=0);
counter = counter + 1;
fprintf('_') % counter for # of cleaning runs
end


%In order to calculate the end of the force hill, we add 1.5 of the stride
%time indexes (we add a little more than just one so that we can also see
%the other leg in the same graph - if we were just to graph only 100% of
%the GC, instead of 150%, then the second force graph would be cut off
V1end_idx = round(bsxfun(@plus, cstart_idx, (gc_percent*Stridetimeframes)));

%Should the end of the gatecycle index be larger than the actual time of
%the trial, then simply trim the last value of the array one by one until
%it fits.
while V1end_idx(end) > length(Time);
    cstart_idx = cstart_idx(1:end-1);
    V1end_idx = V1end_idx(1:end-1); 
    fprintf('+') % counter for trimming
end

%Time Vector for the STD Cloud graph. This saves each moment/index in a
%gaitcycle as a function of time (seconds). Each element in this vector is
%an index in the gaitcycle. This is what determines how much info you want
%to graph in the figures.
TimeVector = Time(cstart_idx(1) : V1end_idx(1)) - Time(cstart_idx(1));

%Since the Time Vector gives back each moment in the gaitcycle as a
%function of time, we want to turn it into a percentage for our figures for
%better graphs. This converts each index/second of the gaitcycle into a
%percentage
Stridetimepercent = 100.*TimeVector./StridetimeAvg;

fprintf('done (gc.info)\n')
% DEFINING OUTPUT STRUCTURE
gc_info.starts        = cstart_idx;
gc_info.stops         = V1end_idx;
gc_info.timevector    = TimeVector;
gc_info.percentvector = Stridetimepercent;

end
function[dblstance, swing, stance] = dblStance(FV1, FV2, LHEE, RHEE, Time, dataparams, rstep)
% FORM : dblstance  = dblStance(FV1, FV2, LHEE, RHEE, Time, dataparams)
%
% function - find dblstance time - this is when both feet are touching the
% ground - there is 'double' (two feet) 'support' (holding your body up)
%
%
% created - 27oct2015 (AKM)
% last edited - 22dec2015 (AKM) - need to determine left and right
%               31dec2015 akm - added swing/stance
% Left dblstance - when left leg is leading forward
% Right dblstance- when right left is leading forward
%
% Assuming that FV1 is left plate and FV2 is right plate
%==========================================================================
% FINDING THE DOUBLE STANCE TIME
%==========================================================================
fprintf('Finding double stance percentage time...')
%Doublestance time is the percentage of time in a gate cycle that both feet
%are on the ground. This can be calculated by counting each frame/"fraction
%of a second" that vertical forces from both feet are present.
%A threshhold is included for better accuracy.
threshold       = dataparams.threshold;
forward_bool    = dataparams.forward_bool; % checking whether forward walking direction is + or - (in data)
forward         = dataparams.forward_marker;

if forward_bool == 0 % if forward direction is negative, then flip RHEE and LHEE
    LHEE.(forward) = -LHEE.(forward);
    RHEE.(forward) = -RHEE.(forward);
end

lcounter = 1; % set counters for left dblstance and right doublestance
rcounter = 1;
j = 1; % individual counters for each lcounter and rcounter run
k = 1;
dblstnce = 0; % counter for ALL dblstance indexes
for i = 1:length(Time); 
    
    if FV1(i) > threshold && FV2(i) > threshold % when both plates register forces
         
         dblstnce = dblstnce + 1;  % counter for ALL dblstance times
         d_idx(dblstnce) = i;           
        
        if LHEE.(forward)(i) > RHEE.(forward)(i) % while left foot is ahead of the right
            ldbl(dblstnce) = i; % then assign that i time idx to ldbl cell array while true

        else % otherwise, right dblstance
            rdbl(dblstnce) = i; % same as above, but reverse
        end

    end   
end

%% Get Left/Right Stance/Swing Times

lwhole = FV1 > threshold; % left foot
rwhole = FV2 > threshold; % right foot
lswing = length(lwhole(lwhole == 0)); % left swing indexes
rswing = length(rwhole(rwhole == 0)); % right swing indexes
lstance = length(lwhole(lwhole == 1)); % left stance indexes
rstance = length(rwhole(rwhole == 1)); % right stance indexes


%% Get Ratios
%Converting the number of frames calculated above into a ratio / percentage of the
%total number of frames
dblstance.ratio.total  = (dblstnce/length(Time));
dblstance.ratio.left   = (length(find(ldbl)) / length(Time));
dblstance.ratio.right  = (length(find(rdbl)) / length(Time));

swing.ratio.left = lswing / length(Time);
swing.ratio.right = rswing / length(Time);

stance.ratio.left  = lstance / length(Time);
stance.ratio.right = rstance / length(Time);
%% get dblstance for each step ( approximation)
totaltime = Time(end) - Time(1);            % total time
numbersteps = length(rstep.timevector);     % get number of steps

% get (approx) left and right dblstance step times
dblstance.steptime.left  = (totaltime * dblstance.ratio.left) / numbersteps;
dblstance.steptime.right = (totaltime * dblstance.ratio.right) / numbersteps;

% do same for swing and stance
swing.indivtime.left   = (totaltime * swing.ratio.left) / numbersteps;
swing.indivtime.right  = (totaltime * swing.ratio.right) / numbersteps;
stance.indivtime.left  = (totaltime * stance.ratio.left) / numbersteps;
stance.indivtime.right = (totaltime * stance.ratio.right) / numbersteps;

fprintf('done (dblstance, swing, stance)\n')
end
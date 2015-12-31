function[symmetry] = symmetryAnalysis(output, paretic, nonparetic)
% FORM : symmetry  = symmetryAnalysis(output, paretic, nonparetic)
%
% function : runs symmetry tests for given parameters. Note that to choose
% these parameters, user must go into this function and add them. Currently
% five parameters run : step length, swing time, stance time, doublestance
% time, and swing-stance ratio. - parameters chosen and equations used are 
% from Patterson et. al., 2010, University of Toronto
%
% inputs :  output - structure with all analyzed datafiles
%           paretic - string  keyword for paretic structure 
%           nonparetic string keyword for nonparetic structure
%
% outputs : symmetry - structure with symmetry values
%
% created : 21dec2015 (akm) - developed framework
% last edited : 30dec2015 (akm) - wrote code
%
% --------------------------FOUR SYMMETRY TESTS----------------------------
% NOTE : the notes below were obtained from 'Evaluation of gait symmetry 
%     after stroke: A comparison of current methods and recommendations for
%     standardization' (Patterson et. al., 2010, University of Toronto)
%
% SYMMETRY RATIO : V(p) / V(np)
% SYMMETRY INDEX : [ (V(p) - V(np)) / 0.5*((V(p) + V(np)) ] * 100%
% GAIT ASYMMETRY : abs[ 100*ln( V(p) / V(np) ) ]
% SYMMETRY ANGLE : [ ( 45deg - arctan(V(p) / V(np)) ) * 100] / 90
%
% where V can be one of five spatiotemporal parameters :
%   step length                                  (got it)
%   swing time                                   (got it)
%   stance time                                  (got it)
%   doublestance time (DS time)                  (got it)
%   intralimb ratio of swing-stance time (SW/ST) (got it)
% -------------------------------------------------------------------------

% NOW : how to determine what is doublestance for each foot? (because BOTH
% feet are on the ground during doublestance, how to determine which is for
% each leg?)
%   - will assume that the doublestance for the given leg is when that leg
%   is heelstriking and is in the lead (e.g. left doublestance begins when
%   the left heel striks and ends when the right toes off)
%   - why not take the total doublestance and use half for each? - b/c this
%   would not accurately represent differences in doublestance during gait,
%   ESPECIALLY if the gait is asymmetric; one leg will have longer
%   doublestance than the other, and using the whole doublestance in half
%   would not show this

fprintf('Running symmetry analsyis')
% define filenames
filenames = fieldnames(output);

% get structures which are paretic and non paretic
pdata_raw  = regexp(filenames, paretic,    'match');
npdata_raw = regexp(filenames, nonparetic, 'match');

% get empty idx
pdata_emptyidx  = cellfun(@isempty, pdata_raw);
npdata_emptyidx = cellfun(@isempty, npdata_raw);

p_idx = find(~pdata_emptyidx);      % get indexes of paretic structures
np_idx = find(~npdata_emptyidx);    % get indexes of nonparetic structures

% make a string cell of the functions that will be run in loops below
func_str = {'lstep',        'rstep', ...
            'lswing',       'rswing', ...
            'lstance',      'rstance', ...
            'ldouble',      'rdouble', ...
            'lswingstance', 'rswingstance'};
%--------------------------------------------------------------------------
% (PARETIC) get the necessary gait parameters for gait analysis
for i = 1 : length(p_idx)
    % steplength
    p.lstep(i)      = output.(filenames{p_idx(i)}).lstep.distavg;
    p.rstep(i)      = output.(filenames{p_idx(i)}).rstep.distavg;
    
    %swingtime
    p.lswing(i)     = output.(filenames{p_idx(i)}).swing.indivtime.left;
    p.rswing(i)     = output.(filenames{p_idx(i)}).swing.indivtime.right;
    
    %stancetime
    p.lstance(i)    = output.(filenames{p_idx(i)}).stance.indivtime.left;
    p.rstance(i)    = output.(filenames{p_idx(i)}).stance.indivtime.right;
    
    %doublestance
    p.ldouble(i)    = output.(filenames{p_idx(i)}).dblstance.steptime.left;
    p.rdouble(i)    = output.(filenames{p_idx(i)}).dblstance.steptime.right;

    %swing-stance ratio
    p.lswingstance(i)   = p.lswing(i) / p.lstance(i);
    p.rswingstance(i)   = p.rswing(i) / p.rstance(i);
    fprintf('.');
end

% (NONPARETIC) 
for i = 1 : length(np_idx)
    % steplength
    np.lstep(i)      = output.(filenames{np_idx(i)}).lstep.distavg;
    np.rstep(i)      = output.(filenames{np_idx(i)}).rstep.distavg;
    
    %swingtime
    np.lswing(i)     = output.(filenames{np_idx(i)}).swing.indivtime.left;
    np.rswing(i)     = output.(filenames{np_idx(i)}).swing.indivtime.right;
    
    %stancetime
    np.lstance(i)    = output.(filenames{np_idx(i)}).stance.indivtime.left;
    np.rstance(i)    = output.(filenames{np_idx(i)}).stance.indivtime.right;
    
    %doublestance
    np.ldouble(i)    = output.(filenames{np_idx(i)}).dblstance.steptime.left;
    np.rdouble(i)    = output.(filenames{np_idx(i)}).dblstance.steptime.right;

    %swing-stance ratio
    np.lswingstance(i)   = np.lswing(i) / np.lstance(i);
    np.rswingstance(i)   = np.rswing(i) / np.rstance(i);
    fprintf('-');
end
%--------------------------------------------------------------------------

%% get means
p_params  = structfun(@(param) mean(param), p);
np_params = structfun(@(param) mean(param), np);

%% SYMMETRY RATIO : V(p) / V(np)
sym_ratio   = p_params ./ np_params;

%% SYMMETRY INDEX : [ (V(p) - V(np)) / 0.5*((V(p) + V(np)) ] * 100%
sym_idx     = ((p_params - np_params) ./ (0.5*(p_params + np_params))) * 100;

%% GAIT ASYMMETRY : abs[ 100*ln( V(p) / V(np) ) ]
gait_asym   = abs(100 * log(p_params ./ np_params));

%% SYMMETRY ANGLE : [ ( 45deg - arctan(V(p) / V(np)) ) * 100] / 90
sym_angle   = (45 - atand(p_params ./ np_params) * 100) /90;

%% ASSIGN OUTPUTS
% run through func_str and assign values from above
for i = 1 : length(func_str)
    symmetry.sym_ratio.(func_str{i}) = sym_ratio(i);
    symmetry.sym_idx.(func_str{i})   = sym_idx(i);
    symmetry.gait_asym.(func_str{i}) = gait_asym(i);
    symmetry.sym_angle.(func_str{i}) = sym_angle(i);
end

fprintf('done (symmetry)\n');
end 
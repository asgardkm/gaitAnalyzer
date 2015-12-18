function[weight, weightidx, mass] = weightMass(trialfile, dataparams, gc_f1)
% FORM : [weight, weightidx, mass] = weightMass(trialfile, dataparams, gc_f1)
%
% function - caluclate the weight and the mass of the patient w/ and w/o
% the prosthetic
%
% inputs  : trialfile - string name of file
%           dataparams - mainConfig.txt group1 variables
%           gc_f1 - gaitcycle info for forces on forceplate 1
%
% outputs : weight - patient's weight (Newtons)
%           weightidx - index where max weight was found (% of avg gaitcycle)
%           mass - patient's mass (kilograms)
%           
%
% created 10dec2015
% last edited 10dec2015

%% find patient's total mass
fprintf('Finding patient weight and mass...')
% check if trial is normal walking or not
if isempty(regexp(trialfile, 'NW', 'ONCE')) % if it is not NW
    prostheses = dataparams.prosthesis_mass * 9.81; % set prosthesis weight to whatever was defined in mainConfig.txt
else
    prostheses = 0; % otherwise set prosthesis mass to 0
end

% define the max value from force on forceplate1 and add prostheses weight (if any)
%   - multiplied by .9 it is the patient's weight in Newtons
weight    = (gc_f1.vert.max_val_avg + prostheses) * 0.9;
weightidx = mean(gc_f1.vert.proc_idx.pidx); 

mass.patient = weight / 9.81; % mass (kg) is Newtons / 9.81

%% find mass of calves and feet

% Based on paper : calf is %4.50 of total body mass
%                  foot is 1.97% of total body mass
mass.lcalf = mass.patient*.045;
mass.lfoot = mass.patient*.0197;

if  isempty(regexp(trialfile, 'NW', 'ONCE')) % if it is a prosthetic trial
    mass.rcalf = dataparams.p_calf; % prostheses calf (most/all weight is at knee housing) is 1.2kg
    mass.rfoot = dataparams.p_foot; % prostheses foot is 0.9kg 
else                                % Otherwise, if it is NW - follow paper params
    mass.rcalf = mass.patient*.045;
    mass.rfoot = mass.patient*.0197;
end

fprintf('done (weight, weightidx, mass)\n')
end
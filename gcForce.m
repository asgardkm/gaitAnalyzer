function[f1, f2] = gcForce(gfr1, gfr2, gc_info, Strideframes, TimeVector, dataparams)
% function : get forces in each gaitcycle per foot, as well as some
% parameters about these forces
% form : [f1, f2] = gcforce(kinetics, gc_info, Strideframes)

%==========================================================================
%FINDING THE MEAN AND STD OF FORCE PER GATE CYCLE 
%==========================================================================
fprintf('Finding gaitcycle ground reaction forces...')
% assign variables from kinetics
FS1 = gfr1.(dataparams.lateral_force);
FS2 = gfr2.(dataparams.lateral_force);
FV1 = gfr1.(dataparams.vertical_force);
FV2 = gfr2.(dataparams.vertical_force);
FH1 = gfr1.(dataparams.forward_force);
FH2 = gfr2.(dataparams.forward_force);
% assign variables from gc_info
cstart_idx = gc_info.starts;
V1end_idx  = gc_info.stops;
%Call all the vertical and horizontal force values from both force plates
%in each gate cycle into their respective arrays
f1_vert_matrix = gcpicker(FV1, cstart_idx, V1end_idx);
f2_vert_matrix = gcpicker(FV2, cstart_idx, V1end_idx);
f1_forw_matrix = gcpicker(FH1, cstart_idx, V1end_idx);
f2_forw_matrix = gcpicker(FH2, cstart_idx, V1end_idx);
f1_side_matrix = gcpicker(FS1, cstart_idx, V1end_idx);
f2_side_matrix = gcpicker(FS2, cstart_idx, V1end_idx);

% get parameters for f1
f1.(dataparams.vertical_force) = getMaxParams(f1_vert_matrix, FV1, Strideframes, TimeVector);
f1.(dataparams.forward_force)  = getMaxParams(f1_forw_matrix, FH1, Strideframes, TimeVector);
f1.(dataparams.lateral_force)  = getMaxParams(f1_side_matrix, FS1, Strideframes, TimeVector);
% get parameters for f2
f2.(dataparams.vertical_force) = getMaxParams(f2_vert_matrix, FV2, Strideframes, TimeVector);
f2.(dataparams.forward_force)  = getMaxParams(f2_forw_matrix, FH2, Strideframes, TimeVector);
f2.(dataparams.lateral_force)  = getMaxParams(f2_side_matrix, FS1, Strideframes, TimeVector);
fprintf('done (gc.f1, gc.f2)\n')
end
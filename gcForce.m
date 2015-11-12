function[f1, f2] = gcForce(kinetics, gc_info, Strideframes, TimeVector)
% function : get forces in each gaitcycle per foot, as well as some
% parameters about these forces
% form : blah = gcforce(kinetics, gc_info, Strideframes)

%==========================================================================
%FINDING THE MEAN AND STD OF FORCE PER GATE CYCLE 
%==========================================================================
% assign variables from kinetics
FS1 = kinetics.gfr1.side;
FS2 = kinetics.gfr2.side;
FV1 = kinetics.gfr1.vert;
FV2 = kinetics.gfr2.vert;
FH1 = kinetics.gfr1.forw;
FH2 = kinetics.gfr2.forw;
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
f1.vert = getMaxParams(f1_vert_matrix, Strideframes, TimeVector);
f1.forw = getMaxParams(f1_forw_matrix, Strideframes, TimeVector);
f1.side = getMaxParams(f1_side_matrix, Strideframes, TimeVector);
% get parameters for f2
f2.vert = getMaxParams(f2_vert_matrix, Strideframes, TimeVector);
f2.forw = getMaxParams(f2_forw_matrix, Strideframes, TimeVector);
f2.side = getMaxParams(f2_side_matrix, Strideframes, TimeVector);

% append the matrix above to either f1 or f2
f1.vert.matrix = f1_vert_matrix;
f1.forw.matrix = f1_forw_matrix;
f1.side.matrix = f1_side_matrix;
f2.vert.matrix = f2_vert_matrix;
f2.forw.matrix = f2_forw_matrix;
f2.side.matrix = f2_side_matrix;

end
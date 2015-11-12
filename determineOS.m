function[pc_os, unix_os] = determineOS() 
% determine if system being used is windows or unix based
pc_os = ispc();
unix_os = isunix();
end










function[csv_str, txt_str] = formatStrings(unix_os, pc_os)

if unix_os == 1;
   csv_str = '/folder1/*.csv';
   txt_str = '/folder1/*.txt';
   fprintf('Using unix file standard for filechoosing\n')
end

if pc_os == 1;
   csv_str = '\folder1\*.csv';
   txt_str = '\folder1\*.txt';
   fprintf('Using pc file standard for filechoosing\n')
end
 
if unix_os == 0 && pc_os == 0;
    csv_str = '/folder1/*.csv';
    txt_str = '/folder1/*.txt';
    fprintf('Using unix file standard for filechoosing\n')
end      
    
end




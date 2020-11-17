function [val] = stateCounter(path)
%% Reading the data and arranging them properly
path = strrep(path,'\','/');
x = strcat(path,"/*solution_gk_*.dat");
solution_path_dir = dir(x);
solution_paths = strings(length(solution_path_dir),1);
for i = 1:length(solution_path_dir)
    
    s = strcat(solution_path_dir(i).folder,"/",solution_path_dir(i).name);
    solution_paths(i,1) = strrep(s,'\','/');
    
end
xxx = char(solution_paths(2));
while xxx(length(xxx)-5) == '1'
    solution_paths = [solution_paths; solution_paths(2)];
    solution_paths(2) = [];
    xxx = char(solution_paths(2));
end
xxx = char(solution_paths(3));
while xxx(length(xxx)-5) == '2'
    solution_paths = [solution_paths; solution_paths(3)];
    solution_paths(3) = [];
    xxx = char(solution_paths(3));
end
xxx = char(solution_paths(4));
if xxx(length(xxx)-5) == '3'
    solution_paths = [solution_paths; solution_paths(4)];
    solution_paths(4) = [];
end

%% Select each stability state file and work the calculation separetely 
val = zeros(length(solution_paths),2);
regex_pattern = '\_\d+';

for i = 1:length(solution_paths)
    match = regexp(solution_paths(i), regex_pattern, 'match');
    match = strsplit(match, '_');
    match = match(2);
    stability_state =  str2double(match);
    
    solution_values_all = dlmread(solution_paths(i));
    val(i,1) = size(solution_values_all,1);
    val(i,2) = stability_state;
end

end
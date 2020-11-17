function output_table = stabilityStateCounter(path)
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
if xxx(length(xxx)-5) == '2'
    solution_paths = [solution_paths; solution_paths(3)];
    solution_paths(3) = [];
end
%% Select each stability state file and work the calculation separetely
regex_pattern = '\_\d+';
output_table = zeros(4,1);
for i = 1:length(solution_paths)
    match = regexp(solution_paths(i), regex_pattern, 'match');
    match = strsplit(match, '_');
    match = match(2);
    stability_state =  str2num(match);
    
    solution_values_all = dlmread(solution_paths(i));
    total_number = size(solution_values_all,1);
    
    if stability_state < 4
        output_table(stability_state,1) = total_number;
    else
        output_table(4) = output_table(4) + total_number;
    end
end
output_table = output_table./sum(output_table);
end

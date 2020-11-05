%{
 This function takes as input all the RACIPE solutions starting from the 
 monostable ones to the highest order solution present and merge those 
 to form the a combined solution to mimic the Boolean type of solution for
 further comparision downstream the pipeline.    
%}

function [output_table] = allSolutionFileCombiner(path,components_num,Name)
%% Reading the data and arranging them
path = strrep(path,'\','/');
x = strcat(path,"/*solution_gk_*.dat");
solution_path_dir = dir(x);
solution_paths = strings(length(solution_path_dir),1);
for i = 1:length(solution_path_dir)
    
    s = strcat(solution_path_dir(i).folder,"/",solution_path_dir(i).name);
    solution_paths(i,1) = strrep(s,'\','/');
    
end
%{
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
%}
%% Select each solution file, do the necessary operatoins and put into a .dat file
regex_pattern = '\_\d+';
output_table = zeros(0,components_num+2);
for i = 1:length(solution_paths)
    match = regexp(solution_paths(i), regex_pattern, 'match');
    match = strsplit(match, '_');
    match = match(2);
    stability_state =  str2double(match);
    
    % read each line and break each line into n parts depending upon the
    % stability state of the solution file
    current_file = dlmread(solution_paths(i));
    current_file = current_file(:,3:end);
    filler = ones(size(current_file,1),2);
    
    for j=1:stability_state
        output_table = [output_table; [filler current_file(:,1:components_num)]];
        current_file = current_file(:,components_num+1:end);
    end 
end

name = path + string(Name) + '.dat';
dlmwrite(name,output_table,'delimiter',' ');

end

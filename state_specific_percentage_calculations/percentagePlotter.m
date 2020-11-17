function [val] = percentagePlotter(path,components_num,pat1,pat2)

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
val = zeros(length(solution_paths),4);
regex_pattern = '\_\d+';


for i = 1:length(solution_paths)
    pat1count = 0;
    pat2count = 0;
    
    match = regexp(solution_paths(i), regex_pattern, 'match');
    match = strsplit(match, '_');
    match = match(2);
    stability_state =  str2double(match);
    
    solution_values_all = dlmread(solution_paths(i));
    solution_values_all = solution_values_all(:,3:end);
    solutions_normalised = solution_values_all;
    
    col = [];
    for j =1:stability_state 
        col = [col ;solutions_normalised(:,1:components_num)];
        solutions_normalised = solutions_normalised(:,components_num+1:end);
    end
    
    leftArrow = zeros(size(col,1),1);
    rightArrow = zeros(size(col,1),1);
    for jj = 1:size(col,1)
        leftArrow(jj,1) = 9;
        rightArrow(jj,1) = 9;
    end
    
    Cm = mean(col);
    Csd = std(col);
    col = (col - Cm)./(Csd);
    col = col > 0;
    
    col = [leftArrow, col, rightArrow];
    
    dlmwrite('data.txt',col,'delimiter','');
    Fn = dlmread('data.txt');
    
    for j=1:size(Fn,1)
        if Fn(j,1) == pat1
            pat1count = pat1count + 1;
        end
        if Fn(j,1) == pat2
            pat2count = pat2count + 1;
        end
    end
    delete('data.txt')
    val(i,1) = pat1count;
    val(i,2) = pat2count;
    val(i,3) = size(Fn,1);
    val(i,4) = stability_state;
end
end
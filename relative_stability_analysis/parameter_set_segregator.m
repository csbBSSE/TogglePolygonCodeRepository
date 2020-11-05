function parameter_sets_for_simulating = parameter_set_segregator(path,components_num,external_signal,sol_num,categories)

% path = 'D:\OneDrive - Indian Institute of Science\Duddu\Spring 2020\Simulations and results\three component basic networks\3c3\3';
% components_num = 3;
% external_signal = 0;
% sol_num = 2;
% category1 = 23;
% category2 = 32;

% categories is a 1*2 matrix for the case of bistable solutions only


[topo_file_info, parameter_names] = parameter_generator(path);

path = strrep(path,'\','/');
x = strcat(path,"/*solution_gk_*.dat");
y = strcat(path,"/*parameters.dat");

solution_path_dir = dir(x);
parameter_value_file_dir = dir(y);

paramater_value_path = strcat(parameter_value_file_dir(1).folder,"/",parameter_value_file_dir(1).name);
paramater_value_path = strrep(paramater_value_path,'\','/');
parameter_values = readtable(paramater_value_path);

%% The paths copied will have backward slashes so have to be replaced with 
% backward slashes --------------------------------------------------------

solution_paths = strings(length(solution_path_dir),1);

for i = 1:length(solution_path_dir)
    
    s = strcat(solution_path_dir(i).folder,"/",solution_path_dir(i).name);
    solution_paths(i,1) = strrep(s,'\','/');
    
end

%%-------------------------------------------------------------------------

%% reordering the solution_paths to keep solution_10 at last rather than at the second place 
% -- Souvadra 
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
%%

if sol_num == 1
    solution_values_all = dlmread(solution_paths(sol_num,1));
else, solution_values_all = dlmread(solution_paths(sol_num,1));
end

solution_values_all_copy = solution_values_all;
solution_values_all(:,1:2) = [];

for i = 1:sol_num

    solution_values_all(:,(i*components_num)+1:(i*components_num)+external_signal) = [];

end

solution_values_all_mean = mean(solution_values_all);
solution_values_all_sd = std(solution_values_all);
solution_values_all_normalized = (solution_values_all - solution_values_all_mean)./(solution_values_all_sd);

a = size(solution_values_all_normalized);

%%-------------------------------------------------------------------------
%% Making the elements of the matrix binary to represent the states -------

% for i = 1:components_num*sol_num
%     for j = 1:a(1,1)
%         if solution_values_all_normalized(j,i) < 0
%             solution_values_all_normalized(j,i) = 0;
%         else, solution_values_all_normalized(j,i) = 1;
%         end
%     end
% end

solution_values_all_normalized = solution_values_all_normalized > 0;

%%-------------------------------------------------------------------------
%% Determining the phase of the solution obtained ---------------

v1 = repmat(0,components_num,1);
v2 = repmat(1,components_num,1);
v = horzcat(v1',v2');

% A1 = nchoosek(v,components_num);
% A1 = unique(A1,'rows');
% A1size = size(A1);

% This code-block is written by Souvadra
n_sh = components_num;
lim_sh = 1;
for ii=(1:n_sh)
    lim_sh = lim_sh + (2^(ii-1));
end    

A3 = zeros(1,n_sh);
for ii=(1:lim_sh-1)
    c_sh = ii;
    vector_sh = [];
    while c_sh > 0
        if c_sh == 1
            vector_sh = [vector_sh, c_sh];
            c_sh = 0;
        else
            rem_sh = mod(c_sh,2);
            vector_sh = [vector_sh, rem_sh];
            c_sh = (c_sh - rem_sh) / 2;
        end
    end
    l_sh = n_sh - length(vector_sh);
    for jjj=(1:l_sh)
        vector_sh = [vector_sh, 0];
    end
    vector_sh = fliplr(vector_sh);
    A3 = [A3 ; vector_sh];
end

% A3 = zeros(1,components_num);
% 
% for i = 1:A1size(1,1)
% 
%     A2 = perms(A1(i,:));
%     A2 = unique(A2,'rows');
%     A3 = vertcat(A3,A2);
% 
% end
% 
% A3(1,:) = [];
a3 = size(A3);

solution_values_all_categorized = zeros(a(1,1),components_num*sol_num);

for i=1:components_num:components_num*sol_num
    for j = 1:a(1,1)
        for k = 1:a3(1,1)
            if isequal(solution_values_all_normalized(j,i:i+components_num-1),A3(k,:))
                solution_values_all_categorized(j,i)=k;
            end
        end
    end
end

clear A1 A1size A2 A3 a2 a3 v v1 v2 x y i j k s

%%-------------------------------------------------------------------------
%% Sorting the solutions for ease of counting -----------------------------

solutions_all_categorized_no_null = zeros(a(1,1),sol_num);

for i = 1:sol_num

    solutions_all_categorized_no_null(:,i) = solution_values_all_categorized(:,((components_num*(i-1)+1)));

end

% Zn = sort(Zn,2);
% Zn = sortrows(Zn);

clear i

%%-------------------------------------------------------------------------
%% Making the X-tick labels -----------------------------------------------

% writing the matrix to txt file, then remove delimiters followed by
% reading the txt file so that the rows are horizontally combines i.e. the
% three coloumn single digit elements are converted to a single coloumn
% three digit number. Finally the vector is converted to a string array.

dlmwrite('data.txt',solutions_all_categorized_no_null,'delimiter','');
solutions_all_categorized_final = dlmread('data.txt');
delete data.txt;
% Fn = unique(Fn);
% f = size(Fn);
% Fnn = string(Fn);

%%-------------------------------------------------------------------------

solutions_all_categorized_final = horzcat(solutions_all_categorized_final,solution_values_all_copy(:,1));

if sol_num == 1
    for i = 1:size(solutions_all_categorized_final,1)
        if solutions_all_categorized_final(i,1)==categories(1,1) %|| solutions_all_categorized_final(i,1)==categories(1,2) || solutions_all_categorized_final(i,1)==categories(1,3)
            solution_indices_required(i) = solutions_all_categorized_final(i,2);
        end
    end
% if sol_num == 1
%     for i = 1:size(solutions_all_categorized_final,1)
%         if solutions_all_categorized_final(i,1)==categories(1,1)
%             solution_indices_required(i) = solutions_all_categorized_final(i,2);
%         end
%     end
elseif sol_num == 2
    for i = 1:size(solutions_all_categorized_final,1)
        if solutions_all_categorized_final(i,1)==categories(1,1) || solutions_all_categorized_final(i,1)==categories(1,2)
            solution_indices_required(i) = solutions_all_categorized_final(i,2);
        end
    end
elseif sol_num == 3
    for i = 1:size(solutions_all_categorized_final,1)
        if solutions_all_categorized_final(i,1)==categories(1,1) || solutions_all_categorized_final(i,1)==categories(1,2) || solutions_all_categorized_final(i,1)==categories(1,3) || solutions_all_categorized_final(i,1)==categories(1,4) || solutions_all_categorized_final(i,1)==categories(1,5) || solutions_all_categorized_final(i,1)==categories(1,6)
            solution_indices_required(i) = solutions_all_categorized_final(i,2);
        end
    end
end

solution_indices_required = solution_indices_required';
solution_indices_required = nonzeros(solution_indices_required);

%%-------------------------------------------------------------------------

% parameters = zeros(size(solution_indices_required,1)+1,size(parameter_names,2));

for i = 1:size(parameter_names,1)
    parameters(1,i) = convertCharsToStrings(parameter_names(i,1:size(parameter_names,2)));
end

parameter_values_newfilenames = cellstr(parameters);

parameter_values.Properties.VariableNames = ["S_no" "States_number" parameter_values_newfilenames];

clear i

%%-------------------------------------------------------------------------

% parameter_sets_for_simulating = table(size(solution_indices_required,1),size(parameter_values,2));
xxx = parameter_values.S_no;
%LLL = size(parameter_values);
for i = 1:numel(solution_indices_required)
    for j = 1:numel(parameter_values.Prod_of_A) % Souvadra's commenting
     
    %for j = 1:LLL(1,1)
     if solution_indices_required(i,1) == xxx(j)
         parameter_sets_for_simulating(i,:)=parameter_values(j,:);
     end
       
   end 
end

%%-------------------------------------------------------------------------

end
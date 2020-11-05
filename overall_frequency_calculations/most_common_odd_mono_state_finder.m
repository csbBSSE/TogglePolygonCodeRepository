%{
This function is for odd-numbered toggle polygons. It reads all the mono-stable solution 
from each of the triplicates of the RACIPE simulations and makes a .xls file of the states 
with descending frequencies.
%}
function output_matrix = most_common_odd_bi_state_finder(p1,p2,p3,components_num,name)
%% Reading all the solution files into matrices ---------------------------

sol_num = 1;
file1 = p1 ;
file2 = p2 ;
file3 = p3 ;

[X1, F1, F1sh] = err_bar_maker(file1,sol_num,components_num,0);
[X2, F2, F2sh] = err_bar_maker(file2,sol_num,components_num,0);
[X3, F3, F3sh] = err_bar_maker(file3,sol_num,components_num,0);

%% Sorting the most common bistable states and and arranging them for calculations
most_common_combi = components_num * 2;
X1 = sort(double(X1(:,:)),'descend');
X2 = sort(double(X2(:,:)),'descend');
X3 = sort(double(X3(:,:)),'descend');

major1 = sum(X1(1:most_common_combi)); minor1 = sum(X1(most_common_combi+1:end));
major2 = sum(X2(1:most_common_combi)); minor2 = sum(X2(most_common_combi+1:end));
major3 = sum(X3(1:most_common_combi)); minor3 = sum(X3(most_common_combi+1:end));

major_val = mean([major1; major2; major3]); major_err = std([major1; major2; major3]);
minor_val = mean([minor1; minor2; minor3]); minor_err = std([minor1; minor2; minor3]);


output_matrix = [major_val, minor_val, major_err, minor_err];
name = name + ".xls";
writematrix(output_matrix, name);
end
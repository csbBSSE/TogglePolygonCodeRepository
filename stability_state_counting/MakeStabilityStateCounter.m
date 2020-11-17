%{
    This function outputs the percentage of RACIPE solutions belonging each 
    stability state (obviously incorporating the triplicates) in the form of 
    a .xls file. 
%}
function output_table = MakeStabilityStateCounter(path,name)
%% Call the helper functions
vec1 = stabilityStateCounter(path + "/1");
vec2 = stabilityStateCounter(path + "/2");
vec3 = stabilityStateCounter(path + "/3");
%% take mean and std-dev 
vec = [vec1 vec2, vec3];
vec = vec';
Mean = mean(vec);
Std = std(vec);
Mean = Mean';
Std = Std';
output_table = [Mean Std];
%% time for plotting the function
x_axis = ["mono", "bi", "tri", "other"];
x = 1:4;

figure
bar(x,Mean); hold on;
er = errorbar(x,Mean,Std,Std);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

set(gca,'xticklabel',x_axis)
ylabel('Percentage Stability States');
Name = "Circuit topology: "+ string(name);
title(Name);

savefig(string(name) + "_stability_state_percentage.fig");
Name = string(name) + "stability-state-percentage" + ".xls";
writematrix(output_table,Name)
end
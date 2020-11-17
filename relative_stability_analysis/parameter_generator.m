function [prs_file_info, parameters] = parameter_generator(path)

%% Reading the topo file and generating the variables ---------------------

path = strrep(path,'\','/');
path = strcat(path,"/*.prs");
file_dir = dir(path);
prs_path = strcat(file_dir(1).folder,"/",file_dir(1).name);
prs_path = strrep(prs_path,'\','/');
prs_file_info = tdfread(prs_path);

parameters = prs_file_info.Parameter ;

%%-------------------------------------------------------------------------
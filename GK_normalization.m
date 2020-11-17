function GK_normalization(path,components_num,external_signal)

%% Reading the paths and making string array of solution files ------------
% and parameters file separately ------------------------------------------

path = strrep(path,'\','/');
x = strcat(path,"/*solution_*.dat");
y = strcat(path,"/*parameters.dat");

F = dir(x);
F2 = dir(y);

%%-------------------------------------------------------------------------
%% Replacing backward slash with forward slashes  for parameters file -----

for i = 1:length(F2)
    
    s2 = strcat(F2(i).folder,"/",F2(i).name);
    str2(i,1) = strrep(s2,'\','/');
    
end

%%-------------------------------------------------------------------------
%% Reading the parameters file, remove all coloumns after the degradation -
% rate values, divide production rates coloumn by degradation rates coloumn
% and then remove all coloumns after the G/K values -----------------------

%external_signal = str2double(external_signal); %Souvadra's addition
%components_num = str2double(components_num);   %Souvadra's addition

F1 = dlmread(str2(1));
F1(:,2+2*(components_num+external_signal)+1:end) = [];

 for j = 3:(3+components_num-1)
               
    F1(:,j) = F1(:,j)./F1(:,j+components_num+external_signal);
    
 end
 
 
F1(:,2+components_num+1:end) = [];

%%-------------------------------------------------------------------------
%% Replacing backward slash with forward slashes  for solution files ------

str = strings(length(F),1);

for i = 1:length(F)
    
    s = strcat(F(i).folder,"/",F(i).name);
    str(i,1) = strrep(s,'\','/');
    
end

%%-------------------------------------------------------------------------
%% Reading the solution files into matrix and performing G/K normalization 
% and further the concatenation of all solutions and calculating the ------
% z-scores for plotting the scatter diagram -------------------------------

Mn = zeros(1,components_num);

for i = 1:length(str)
    
    A = dlmread(str(i));
    B = A(:,1);
    A = 2.^A;
    a = size(A);
    
    for k = 1:a(1,1)
        
       for m = 1:length(F1)
           
       if B(k,1) == F1(m,1)

                for j = 3:components_num + external_signal:a(1,2)
                    
                    for l = 1:components_num
               
                        A(k,j+l-1) = A(k,j+l-1)./F1(k,2+l);
                        
                    end
               
                end
       end

       end
       
    end
    
    A = log2(A);
    A(:,1) = B;
    newstr = split(str(i,1),"_");
    size(newstr,1);
    new = strings(1);
    for i = 1:size(newstr,1)-1
        new = strcat(new,newstr(i,1),"_");
    end
    new = strcat(new,"gk_",newstr(size(newstr,1),1));
    dlmwrite(new,A,'delimiter','\t');
 end

    
    %new = strcat(newstr(i,1),"_",newstr(2,1),"gk_",newstr(3,1));
%%-------------------------------------------------------------------------
end
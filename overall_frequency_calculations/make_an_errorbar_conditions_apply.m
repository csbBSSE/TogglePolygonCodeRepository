function matrix_sh = make_an_errorbar_conditions_apply(p1,p2,p3,sol_num,components_num,ext_signals_num,condition,name)

%% Reading all the solution files into matrices ---------------------------

file1 = p1 ;
file2 = p2 ;
file3 = p3 ;

[X1, F1, F1sh] = err_bar_maker(file1,sol_num,components_num,ext_signals_num);
[X2, F2, F2sh] = err_bar_maker(file2,sol_num,components_num,ext_signals_num);
[X3, F3, F3sh] = err_bar_maker(file3,sol_num,components_num,ext_signals_num);

%%-------------------------------------------------------------------------
%% Making all data vectors of same length ---------------------------------

maxlen = [length(X1) length(X2) length(X3)];
maxlen = max(maxlen);
X1(end+1:maxlen) = 0;
X2(end+1:maxlen) = 0;
X3(end+1:maxlen) = 0;
F1(end+1:maxlen) = "0";
F2(end+1:maxlen) = "0";
F3(end+1:maxlen) = "0"; 

%%-------------------------------------------------------------------------
%% Making the Categories --------------------------------------------------

% v = [1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6 7 7 7 8 8 8];
% C = nchoosek(v,3);
% dlmwrite('data.txt',C,'delimiter','');
% C = dlmread('data.txt');
% delete data.txt;
% C = unique(C);
% c = size(C);

%v1 = 2^components_num ;
% Souvadra is commenting the bottom block
% v2 = 1:v1 ;
% v = zeros(1,1);
% 
% for i = 1:v2(1,v1)
% 
%     v3 = repmat(i,sol_num,1);
%     v = horzcat(v,v3');
% 
% end
% 
% v(:,1) = [] ;
% 
% C = nchoosek(v,sol_num);
% C = unique(C,'rows');

% % Souvadra's addition 
% C = [];
% if sol_num > 3
%     fprintf("Need to write more code!!\n")
% end
% if sol_num == 3
% for iii=(1:v1)
%     for jjj=(1:v1)
%         for kkk=(1:v1)
%             C = [C; iii, jjj, kkk];
%         end
%     end
% end
% end
% if sol_num == 2
% for iii=(1:v1)
%     for jjj=(1:v1)
%         C = [C; iii, jjj];
%     end
% end 
% end
% if sol_num == 1
% for iii=(1:v1)
%     C = [C; iii];
% end
% end
% dlmwrite('data.txt',C,'delimiter','');
% C = dlmread('data.txt');
% delete data.txt;
% C = unique(C); % Additional Step by me
% c = size(C);

C = unique([F1;F2;F3]);
C = double(C);
c = size(C);

%%-------------------------------------------------------------------------
%% Make the data from different simulations match based on the category ---

data = zeros(c(1,1),3);

for i = 1:c(1,1)
    for j = 1:maxlen
        
        if C(i,1)==double(F1(j,1))
            data(i,1) = X1(j,1);
        end

    end
end
for i = 1:c(1,1)
    for j = 1:maxlen
        
        if C(i,1)==double(F2(j,1))
            data(i,2) = X2(j,1);
        end

    end
end
for i = 1:c(1,1)
    for j = 1:maxlen
        
        if C(i,1)==double(F3(j,1))
            data(i,3) = X3(j,1);
        end

    end
end

data_mod = data;

%%-------------------------------------------------------------------------
%% Remove the rows containing all zeros from the C and data matrix --------

a = sum(data,2);
a1 = zeros(length(a),1);

for i = 1:c(1,1)
   
    if a(i) == 0
        a1(i) = i;        
    end
    
end

a1 = a1(a1 ~= 0);
data_mod = horzcat(data_mod,C);
data_mod(a1,:) = [] ;

data_mod = sortrows(data_mod,'descend');

%%-------------------------------------------------------------------------
%% Calculation errors required for barplot --------------------------------

data_final = data_mod(:,1:3)';
mean_data = mean(data_final);
std_data = std(data_final);

cnn = string(data_mod(:,4));

%%-------------------------------------------------------------------------
%% Conditioning of the data -----------------------------------------------

% required_indexes = find(mean_data>50);
B = mean_data > condition ;
new_mean_data = mean_data(B);
new_std_data = std_data(B);
new_cnn = cnn(B);


%%-------------------------------------------------------------------------
%% Plotting the bar plot with errorbars -----------------------------------
% Souvadra is commentinf this block of code
cn = categorical(new_cnn);

grid on
bar(cn,new_mean_data);
hold on

er = errorbar(cn,new_mean_data,new_std_data);
er.Color = [0 0 0];                            
er.LineStyle = 'none';

hold off

%%-------------------------------------------------------------------------
%% Souvadra's modificaiton, Let's not plot the data and store it instead in
%% .csv file 
%cn = categorical(new_cnn)
QSH = [F1sh; F2sh; F3sh];
QSH = unique(QSH,'rows');
Map = containers.Map(QSH(:,1),QSH(:,2));
nameSH = strings(length(new_mean_data),1);
for i=(1:length(new_mean_data)) % THis was initially 'length(QSH)'
    variable = {new_cnn(i,1)};
    mappedTo = string(values(Map,variable));
    mappedTo = "<" + mappedTo + ">";
    %nameSH = [nameSH ; mappedTo];
    nameSH(i,1) = mappedTo;
end

Name = name + ".xls";
matrix_sh = [new_cnn, nameSH, new_mean_data', new_std_data']
writematrix(matrix_sh,Name)
%%-------------------------------------------------------------------------
end
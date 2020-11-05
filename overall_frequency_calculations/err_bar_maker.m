function [y, Fn1, Fn] = err_bar_maker(path,sol_num,components_num,ex_sig)

%% Reading the data into matrices and arraging them -----------------------

C = dlmread(path);
C(:,1:2) = [];

for i = 1:sol_num
    C(:,(i*components_num)+1:(i*components_num)+ex_sig) = [];
end

Cm = mean(C);
Csd = std(C);
Cn = (C - Cm)./(Csd);

a = size(Cn);
Cn = Cn > 0 ;

%%-------------------------------------------------------------------------
%% Determining the phase of the solution obtained ---------------

% A1 = [0 0 0];
% A2 = [1 0 0];
% A3 = [0 1 0];
% A4 = [0 0 1];
% A5 = [1 1 0];
% A6 = [1 0 1];
% A7 = [0 1 1];
% A8 = [1 1 1];

v1 = repmat(0,components_num,1);
v2 = repmat(1,components_num,1);
v = horzcat(v1',v2');

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

 a3 = size(A3);

Dn = zeros(a(1,1),components_num*sol_num);

for i=1:components_num:components_num*sol_num
    for j = 1:a(1,1)
        for k = 1:a3(1,1)
            if isequal(Cn(j,i:i+components_num-1),A3(k,:))
                Dn(j,i)=k;
            end
        end
    end
end

%%-------------------------------------------------------------------------
%% Sorting the solutions for ease of counting -----------------------------

Zn = zeros(a(1,1),sol_num);

for i = 1:sol_num
    Zn(:,i) = Dn(:,((components_num*(i-1)+1)));
end

Zn = sort(Zn,2);
Zn = sortrows(Zn);
%%-------------------------------------------------------------------------
%% Explicitly putting the naming system (Binary-ish) - Souvadra 
naming = []; 
L = size(A3);
L = L(1,1);
B = size(A3);
B = B(1,2);
for i=(1:L)
	sSH = "";
	for j=(1:B)
		sSH = sSH + A3(i,j); 
	end
	naming = [naming; sSH];
end

Zn_naming = [];
BB = size(Zn);
BB = BB(1,2);
for i=(1:length(Zn))
	eSH = [];
	for j=(1:BB)
		aSH = naming(Zn(i,j));
		eSH = [eSH aSH];
	end
	Zn_naming = [Zn_naming; eSH];
end

BBB = size(Zn_naming);
BBB = BBB(1,2);
for i=(1:length(Zn_naming))
    for j=(2:BBB)
	Zn_naming(i,1) = Zn_naming(i,1)+Zn_naming(i,j);
    end
end
Zn_naming = Zn_naming(:,1);
%Fn_naming = unique(Zn_naming);

%%-------------------------------------------------------------------------
%% Making the X-tick labels -----------------------------------------------

% writing the matrix to txt file, then remove delimiters followed by
% reading the txt file so that the rows are horizontally combines i.e. the
% three coloumn single digit elements are converted to a single coloumn
% three digit number. Finally the vector is converted to a string array.

dlmwrite('data.txt',Zn,'delimiter','');
Fn = dlmread('data.txt');
Var_SH = Fn;
delete data.txt;
Fn = [Fn, Zn_naming]; % Souvadra's addition 
Fn = unique(Fn,'rows');
f = size(Fn);
Fn1 = Fn(:,1); % Souvadra's addition

%%-------------------------------------------------------------------------
%% Souvadra's alternative to the happeing issue
y = zeros(f(1,1),1);
for i=(1:length(Var_SH))
    for j=(1:f(1,1))
        if Var_SH(i,1) == double(Fn(j,1))
            y(j,1) = y(j,1) + 1;
        end
    end
end
y = y ./ sum(y); % giving percentage result rather than the full value
%%-------------------------------------------------------------------------
end
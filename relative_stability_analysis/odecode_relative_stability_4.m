%% Initialization of code by setting up values necessary

path = 'path_to_the_RACIPE_simulations/FOUR_SA/2'; % path of the file for network in question
components_num = 4; % number of components in network
external_signal = 0; % if any external signalskanha

sol_num = 2; % solution number in question, mono, bi or tri and such
categories = [710 107]; %[234 243 342 324 432 423]; % for monostable just write [2] or 
% [3] or [4]... and for bistable [23 32] or [34 43] or [24 42] ...

a=0; b=0; c=0; d=0; 
%state1 = 0; state2 = 0; state3 = 0;

% for counting how many initial conditions went into which state
parameter_sets_for_simulating = parameter_set_segregator(path,components_num,external_signal,sol_num,categories); 
% look at parameter segregator file to understand
save('') 
run_time = 0:1:200; % run time for ode solver
num_initials = 1000; % number of initial conditions for each parameter set

%%
final_table = zeros(size(parameter_sets_for_simulating,1),5); 
% to store thedata of fractions going to each state

for ii = 1:size(parameter_sets_for_simulating,1)
    ga = parameter_sets_for_simulating.Prod_of_A(ii);
    gb = parameter_sets_for_simulating.Prod_of_B(ii);
    gc = parameter_sets_for_simulating.Prod_of_C(ii);
    gd = parameter_sets_for_simulating.Prod_of_D(ii);
    
    ka = parameter_sets_for_simulating.Deg_of_A(ii);
    kb = parameter_sets_for_simulating.Deg_of_B(ii);
    kc = parameter_sets_for_simulating.Deg_of_C(ii);
    kd = parameter_sets_for_simulating.Deg_of_D(ii);
    
   for jj = 1:num_initials
    [ii,jj]
    Ajj = (ga/ka)*rand ;
    Bjj = (gb/kb)*rand ;
    Cjj = (gc/kc)*rand ;
    Djj = (gd/kd)*rand ;
    
    I = [Ajj Bjj Cjj Djj] ;
    
    [t,y] = ode45(@(t,y)dynamic_simulation_FOUR_SA(t,y,parameter_sets_for_simulating(ii,:)),run_time,I) ;
    
    % In this variant of the code, rather than saving individual solution
    % states we are saving the values of each component at the end of the
    % differential equation directly. Not much different from the
    % state-based sytem used for 5 and 7 numbered circuit code, so the user
    % can choose any system of his/her choice. 
        if log2(y(end,1))>log2(y(end,2)) && log2(y(end,1))>log2(y(end,4))
            if  log2(y(end,3))>log2(y(end,2)) && log2(y(end,3))>log2(y(end,4))
               a = a+1;
               c = c+1;
            end
        end

        if log2(y(end,2))>log2(y(end,1)) && log2(y(end,2))>log2(y(end,3)) 
            if  log2(y(end,4))>log2(y(end,1)) && log2(y(end,4))>log2(y(end,3)) 
                b = b+1;
                d = d+1;
            end
        end
        
        if log2(y(end,2))>log2(y(end,1)) && log2(y(end,2))>log2(y(end,4)) 
            if  log2(y(end,3))>log2(y(end,1)) && log2(y(end,3))>log2(y(end,4)) 
                b = b+1;
                c = c+1;
            end
        end
   end
              
final_table(ii,1) = ii;
final_table(ii,2) = a;
final_table(ii,3) = b;
final_table(ii,4) = c;
final_table(ii,5) = d;

a = 0; b = 0; c = 0; d = 0;
    
end

%% save the solution matrix for further analysis and plotting
save('final_table_FOUR_SA_tri'); %% to save the table containing all parameter set no vs the fractions of A, B and C just in case


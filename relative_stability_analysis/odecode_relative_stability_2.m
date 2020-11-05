%% Initialization of code by setting up values necessary

path = 'path_to_the_RACIPE_simulations/TWO_SA/2'; % path of the file for network in question
components_num = 2; % number of components in network
external_signal = 0; % if any external signalskanha

sol_num = 2; % solution number in question, mono, bi or tri and such
categories = [23 32]; %[234 243 342 324 432 423]; % for monostable just write [2] or 
% [3] or [4]... and for bistable [23 32] or [34 43] or [24 42] ...

state1 = 0; state2 = 0;
parameter_sets_for_simulating = parameter_set_segregator(path,components_num,external_signal,sol_num,categories); 
save('') 
run_time = 0:1:200; % run time for ode solver
num_initials = 40; %100; % number of initial conditions for each parameter set

%%
final_table = zeros(size(parameter_sets_for_simulating,1),3); 
% to store thedata of fractions going to each state

for ii = 1:size(parameter_sets_for_simulating,1)-4740
    ga = parameter_sets_for_simulating.Prod_of_A(ii);
    gb = parameter_sets_for_simulating.Prod_of_B(ii);
    
    ka = parameter_sets_for_simulating.Deg_of_A(ii);
    kb = parameter_sets_for_simulating.Deg_of_B(ii);
    
   for jj = 1:num_initials
    [ii,jj]
    Ajj = (ga/ka)*rand ;
    Bjj = (gb/kb)*rand ;
    
    I = [Ajj Bjj] ;
    
    [t,y] = ode45(@(t,y)dynamic_simulation_TWO_SA(t,y,parameter_sets_for_simulating(ii,:)),run_time,I) ;
    
    % condition1 and condition2 has to be written every time separately
    % depending on the solution states were are trying to analyze   
    condition1 = log2(y(end,2))>log2(y(end,1));
    condition2 = log2(y(end,1))>log2(y(end,2));     

    if condition1 == true && condition2 == false
        state1 = state1 + 1;
    end
    if condition1 == false && condition2 == true
        state2 = state2 + 1;
    end
   end
    final_table(ii,1) = ii;
    final_table(ii,2) = state1;
    final_table(ii,3) = state2;
    
    state1 = 0; state2 = 0; 
    
end

%% save the solution matrix for further analysis and plotting
save('final_table_TWO_SA_bi'); %% to save the table containing all parameter set no vs the fractions of A, B and C just in case



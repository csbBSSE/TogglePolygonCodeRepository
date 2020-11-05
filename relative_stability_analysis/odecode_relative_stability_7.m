%% Initialization of code by setting up values necessary

path = 'path_to_the_RACIPE_simulations/SEVEN/3'; % path of the file for network in question
components_num = 7; % number of components in network
external_signal = 0;
sol_num = 2; % As we are calculating the Bistable solutions here 
categories = [621 216]; %[234 243 342 324 432 423]; % for monostable just write [2] or 
% [3] or [4]... and for bistable [23 32] or [34 43] or [24 42] ...
state1 = 0; state2 = 0; 
parameter_sets_for_simulating = parameter_set_segregator(path,components_num,external_signal,sol_num,categories); 
save('') 

run_time = 0:1:200; % run time for ode solver
num_initials = 1000; % number of initial conditions we want to solve the ODE for
%% solve the ODE 
final_table = zeros(size(parameter_sets_for_simulating,1),3); 
for ii = 1:size(parameter_sets_for_simulating,1)
    ga = parameter_sets_for_simulating.Prod_of_A(ii);
    gb = parameter_sets_for_simulating.Prod_of_B(ii);
    gc = parameter_sets_for_simulating.Prod_of_C(ii);
    gd = parameter_sets_for_simulating.Prod_of_D(ii);
    ge = parameter_sets_for_simulating.Prod_of_E(ii);
    gf = parameter_sets_for_simulating.Prod_of_F(ii);
    gg = parameter_sets_for_simulating.Prod_of_G(ii);
    
    ka = parameter_sets_for_simulating.Deg_of_A(ii);
    kb = parameter_sets_for_simulating.Deg_of_B(ii);
    kc = parameter_sets_for_simulating.Deg_of_C(ii);
    kd = parameter_sets_for_simulating.Deg_of_D(ii);
    ke = parameter_sets_for_simulating.Deg_of_E(ii);
    kf = parameter_sets_for_simulating.Deg_of_F(ii);
    kg = parameter_sets_for_simulating.Deg_of_G(ii);
    
   parfor jj = 1:num_initials
       [ii,jj]
       Ajj = (ga/ka)*rand;
       Bjj = (gb/kb)*rand;
       Cjj = (gc/kc)*rand;
       Djj = (gd/kd)*rand;
       Ejj = (ge/ke)*rand;
       Fjj = (gf/kf)*rand;
       Gjj = (gg/kg)*rand;

       I = [Ajj Bjj Cjj Djj Ejj Fjj Gjj];

       [t,y] = ode45(@(t,y)dynamic_simulation_SEVEN(t,y,parameter_sets_for_simulating(ii,:)),run_time,I) ;
       
       % condition1 and condition2 has to be written every time separately
       % depending on the solution states were are trying to analyze
       condition1 = log2(y(end,3))>log2(y(end,1)) && log2(y(end,3))>log2(y(end,2)) && log2(y(end,3))>log2(y(end,4)) ...
           && log2(y(end,5))>log2(y(end,1)) && log2(y(end,5))>log2(y(end,2)) && log2(y(end,5))>log2(y(end,4));
       
       condition2 = log2(y(end,1))>log2(y(end,2)) && log2(y(end,1))>log2(y(end,4)) && log2(y(end,1))>log2(y(end,5)) ...
           && log2(y(end,3))>log2(y(end,2)) && log2(y(end,3))>log2(y(end,4)) && log2(y(end,3))>log2(y(end,5));
       
       if condition1 == true && condition2 == false
           state1 = state1 + 1;
       end

       if condition2 == true && condition1 == false
           state2 = state2 + 1;
       end
   end
              
final_table(ii,1) = ii;
final_table(ii,2) = state1;
final_table(ii,3) = state2;

state1 = 0; state2 = 0; 
end

%% save the solution matrix for further analysis and plotting
save('final_table_SEVEN_bi_1');
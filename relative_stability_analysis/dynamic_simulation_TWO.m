function dydt = dynamic_simulation_TWO_SA(t,y,parameter_set)

dydt = zeros(2,1);

A = y(1);
B = y(2);
    
    ga = parameter_set.Prod_of_A;
    gb = parameter_set.Prod_of_B;
    ka = parameter_set.Deg_of_A;
    kb = parameter_set.Deg_of_B;
    HBA = hill(B,parameter_set.Trd_of_BToA,parameter_set.Inh_of_BToA,parameter_set.Num_of_BToA);  
    HAB = hill(A,parameter_set.Trd_of_AToB,parameter_set.Inh_of_AToB,parameter_set.Num_of_AToB);
    
    dydt(1) = ga*HBA - ka*A;
    dydt(2) = gb*HAB - kb*B;


end


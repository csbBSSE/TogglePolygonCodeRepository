function dydt = dynamic_simulation_FIVE(t,y,parameter_set)

    dydt = zeros(5,1);

    A = y(1);
    B = y(2);
    C = y(3);
    D = y(4);
    E = y(5);
    
    ga = parameter_set.Prod_of_A;
    gb = parameter_set.Prod_of_B;
    gd = parameter_set.Prod_of_D;
    gc = parameter_set.Prod_of_C;
    ge = parameter_set.Prod_of_E;
    
    ka = parameter_set.Deg_of_A;
    kb = parameter_set.Deg_of_B;
    kd = parameter_set.Deg_of_D;
    kc = parameter_set.Deg_of_C;
    ke = parameter_set.Deg_of_E;

    HBA = hill(B,parameter_set.Trd_of_BToA,parameter_set.Inh_of_BToA,parameter_set.Num_of_BToA);
    HEA = hill(E,parameter_set.Trd_of_EToA,parameter_set.Inh_of_EToA,parameter_set.Num_of_EToA);

    HAB = hill(A,parameter_set.Trd_of_AToB,parameter_set.Inh_of_AToB,parameter_set.Num_of_AToB);
    HCB = hill(C,parameter_set.Trd_of_CToB,parameter_set.Inh_of_CToB,parameter_set.Num_of_CToB);
    
    HBC = hill(B,parameter_set.Trd_of_BToC,parameter_set.Inh_of_BToC,parameter_set.Num_of_BToC);
    HDC = hill(D,parameter_set.Trd_of_DToC,parameter_set.Inh_of_DToC,parameter_set.Num_of_DToC);
    
    HED = hill(E,parameter_set.Trd_of_EToD,parameter_set.Inh_of_EToD,parameter_set.Num_of_EToD);
    HCD = hill(C,parameter_set.Trd_of_CToD,parameter_set.Inh_of_CToD,parameter_set.Num_of_CToD);
    
    HDE = hill(D,parameter_set.Trd_of_DToE,parameter_set.Inh_of_DToE,parameter_set.Num_of_DToE);
    HAE = hill(A,parameter_set.Trd_of_AToE,parameter_set.Inh_of_AToE,parameter_set.Num_of_AToE);

    dydt(1) = ga*HBA*HEA - ka*A;
    dydt(2) = gb*HAB*HCB - kb*B;
    dydt(3) = gc*HBC*HDC - kc*C;
    dydt(4) = gd*HED*HCD - kd*D;
    dydt(5) = ge*HAE*HDE - ke*E;

end


function dydt = dynamic_simulation_FOUR_SA(t,y,parameter_set)

dydt = zeros(4,1);

A = y(1);
B = y(2);
C = y(3);
D = y(4);
    
    ga = parameter_set.Prod_of_A;
    gb = parameter_set.Prod_of_B;
    gd = parameter_set.Prod_of_D;
    gc = parameter_set.Prod_of_C;
    ka = parameter_set.Deg_of_A;
    kb = parameter_set.Deg_of_B;
    kd = parameter_set.Deg_of_D;
    kc = parameter_set.Deg_of_C;
    HBA = hill(B,parameter_set.Trd_of_BToA,parameter_set.Inh_of_BToA,parameter_set.Num_of_BToA);
    HDA = hill(D,parameter_set.Trd_of_DToA,parameter_set.Inh_of_DToA,parameter_set.Num_of_DToA);
    HAA = hill(A,parameter_set.Trd_of_AToA,parameter_set.Act_of_AToA,parameter_set.Num_of_AToA);
    
    HAB = hill(A,parameter_set.Trd_of_AToB,parameter_set.Inh_of_AToB,parameter_set.Num_of_AToB);
    HCB = hill(C,parameter_set.Trd_of_CToB,parameter_set.Inh_of_CToB,parameter_set.Num_of_CToB);
    HBB = hill(B,parameter_set.Trd_of_BToB,parameter_set.Act_of_BToB,parameter_set.Num_of_BToB);
    
    HBC = hill(B,parameter_set.Trd_of_BToC,parameter_set.Inh_of_BToC,parameter_set.Num_of_BToC);
    HDC = hill(D,parameter_set.Trd_of_DToC,parameter_set.Inh_of_DToC,parameter_set.Num_of_DToC);
    HCC = hill(C,parameter_set.Trd_of_CToC,parameter_set.Act_of_CToC,parameter_set.Num_of_CToC);
    
    HAD = hill(A,parameter_set.Trd_of_AToD,parameter_set.Inh_of_AToD,parameter_set.Num_of_AToD);
    HCD = hill(C,parameter_set.Trd_of_CToD,parameter_set.Inh_of_CToD,parameter_set.Num_of_CToD);
    HDD = hill(D,parameter_set.Trd_of_DToD,parameter_set.Act_of_DToD,parameter_set.Num_of_DToD);
    
    dydt(1) = ga*HBA*HDA*HAA - ka*A;
    dydt(2) = gb*HAB*HCB*HBB - kb*B;
    dydt(3) = gc*HBC*HDC*HCC - kc*C;
    dydt(4) = gd*HAD*HCD*HDD - kd*D;

end


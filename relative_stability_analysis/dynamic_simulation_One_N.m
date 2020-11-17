function dydt = dynamic_simulation_One_N(t,y,parameter_set)
% unlike most of the toggle polygons, where the naming of the nodes are
% a-b-c-d-e... circularly, in case of One_N (which is a modified version of
% FOUR) the naming is a-b-d-c circular. Which is essentially the same
% circuit, but with a slightly different naming convention.
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
    HCA = hill(C,parameter_set.Trd_of_CToA,parameter_set.Inh_of_CToA,parameter_set.Num_of_CToA);
    
    HAB = hill(A,parameter_set.Trd_of_AToB,parameter_set.Inh_of_AToB,parameter_set.Num_of_AToB);
    HDB = hill(D,parameter_set.Trd_of_DToB,parameter_set.Inh_of_DToB,parameter_set.Num_of_DToB);
     
    HBD = hill(B,parameter_set.Trd_of_BToD,parameter_set.Inh_of_BToD,parameter_set.Num_of_BToD);
    HCD = hill(C,parameter_set.Trd_of_CToD,parameter_set.Inh_of_CToD,parameter_set.Num_of_CToD);
     
    HAC = hill(A,parameter_set.Trd_of_AToC,parameter_set.Inh_of_AToC,parameter_set.Num_of_AToC);
    HDC = hill(D,parameter_set.Trd_of_DToC,parameter_set.Inh_of_DToC,parameter_set.Num_of_DToC);
     
    dydt(1) = ga*HBA*HCA - ka*A;
    dydt(2) = gb*HAB*HDB - kb*B;
    dydt(3) = gc*HAC*HDC - kc*C;
    dydt(4) = gd*HBD*HCD - kd*D;

end


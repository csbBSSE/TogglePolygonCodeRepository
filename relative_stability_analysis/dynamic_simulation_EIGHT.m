function dydt = dynamic_simulation_EIGHT(t,y,parameter_set)

    dydt = zeros(4,1);

    A = y(1);
    B = y(2);
    C = y(3);
    D = y(4);
    E = y(5);
    F = y(6);
    G = y(7);
    H = y(8);
    
    ga = parameter_set.Prod_of_A;
    gb = parameter_set.Prod_of_B;
    gd = parameter_set.Prod_of_D;
    gc = parameter_set.Prod_of_C;
    ge = parameter_set.Prod_of_E;
    gf = parameter_set.Prod_of_F;
    gg = parameter_set.Prod_of_G;
    gh = parameter_set.Prod_of_H;
    
    ka = parameter_set.Deg_of_A;
    kb = parameter_set.Deg_of_B;
    kd = parameter_set.Deg_of_D;
    kc = parameter_set.Deg_of_C;
    ke = parameter_set.Deg_of_E;
    kf = parameter_set.Deg_of_F;
    kg = parameter_set.Deg_of_G;
    kh = parameter_set.Deg_of_H;
    
    HBA = hill(B,parameter_set.Trd_of_BToA,parameter_set.Inh_of_BToA,parameter_set.Num_of_BToA);
    HHA = hill(H,parameter_set.Trd_of_HToA,parameter_set.Inh_of_HToA,parameter_set.Num_of_HToA);
    
    HAB = hill(A,parameter_set.Trd_of_AToB,parameter_set.Inh_of_AToB,parameter_set.Num_of_AToB);
    HCB = hill(C,parameter_set.Trd_of_CToB,parameter_set.Inh_of_CToB,parameter_set.Num_of_CToB);
        
    HBC = hill(B,parameter_set.Trd_of_BToC,parameter_set.Inh_of_BToC,parameter_set.Num_of_BToC);
    HDC = hill(D,parameter_set.Trd_of_DToC,parameter_set.Inh_of_DToC,parameter_set.Num_of_DToC);
        
    HED = hill(E,parameter_set.Trd_of_EToD,parameter_set.Inh_of_EToD,parameter_set.Num_of_EToD);
    HCD = hill(C,parameter_set.Trd_of_CToD,parameter_set.Inh_of_CToD,parameter_set.Num_of_CToD);
        
    HDE = hill(D,parameter_set.Trd_of_DToE,parameter_set.Inh_of_DToE,parameter_set.Num_of_DToE);
    HFE = hill(F,parameter_set.Trd_of_FToE,parameter_set.Inh_of_FToE,parameter_set.Num_of_FToE);
    
    HGF = hill(G,parameter_set.Trd_of_GToF,parameter_set.Inh_of_GToF,parameter_set.Num_of_GToF);
    HEF = hill(E,parameter_set.Trd_of_EToF,parameter_set.Inh_of_EToF,parameter_set.Num_of_EToF);
        
    HFG = hill(F,parameter_set.Trd_of_FToG,parameter_set.Inh_of_FToG,parameter_set.Num_of_FToG);
    HHG = hill(H,parameter_set.Trd_of_HToG,parameter_set.Inh_of_HToG,parameter_set.Num_of_HToG);
    
    HAH = hill(A,parameter_set.Trd_of_AToH,parameter_set.Inh_of_AToH,parameter_set.Num_of_AToH);
    HGH = hill(G,parameter_set.Trd_of_GToH,parameter_set.Inh_of_GToH,parameter_set.Num_of_GToH);
       
    dydt(1) = ga*HBA*HHA - ka*A;
    dydt(2) = gb*HAB*HCB - kb*B;
    dydt(3) = gc*HBC*HDC - kc*C;
    dydt(4) = gd*HED*HCD - kd*D;
    dydt(5) = ge*HFE*HDE - ke*E;
    dydt(6) = gf*HGF*HEF - kf*F;
    dydt(7) = gg*HHG*HFG - kg*G;
    dydt(8) = gh*HAH*HGH - kh*H;

end


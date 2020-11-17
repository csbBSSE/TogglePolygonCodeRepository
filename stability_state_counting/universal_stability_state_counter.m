function universal_stability_state_counter(p1,p2,p3,name)
%{
This function can be used to easily plot the numbers of different
stability states in a given ciruit, using the data from the triplicates and
plots the results in the form of a .fig file. This function is made to 
handle larger RACIPE simulations will 20th- and 30th-stable solutions and more general
than that of standard 10th-stable solutions used otherwise.
%}
%% Call the helper functinos 
    file1 = p1 ;
    file2 = p2 ;
    file3 = p3 ;
    [val1] = stateCounter(file1);
    [val2] = stateCounter(file2);
    [val3] = stateCounter(file3);
    % let me first finish the helper functions
%% Do the required calculatios     
    allStates = unique([val1(:,2); val2(:,2); val3(:,2)]);
    val = zeros(length(allStates),1); % val is actually my y axis 
    x = zeros(length(allStates),1);
    err = zeros(length(allStates),1);
    i = 0;
    for currState = allStates'
        i = i + 1; 
        z = [];
        participants = 0;
        
        for j1=1:size(val1,1)
            if val1(j1,2) == currState
                z = [z; val1(j1,1)];
                participants = participants + 1;
            end
        end
        
        for j2=1:size(val2,1)
            if val2(j2,2) == currState
                z = [z; val2(j2,1)];
                participants = participants + 1;
            end
        end
        
        for j3=1:size(val3,1)
            if val3(j3,2) == currState
                z = [z; val3(j3,1)];
                participants = participants + 1;
            end
        end
        
        val(i,1) = sum(z)/participants;
        err(i,1) = std(z);
        x(i,1) = int8(currState);
    end
    
%% Its time to plot the data 
    bar(x,val); hold on;
    er = errorbar(x,val,err,err);    
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';  
    
    ylabel('Number of the stability states');
    titl = ['Circuit topology: ',name];
    title(titl);
    saveName = [name,'_stability_state_counts<30>.fig'];
    savefig(saveName);
end
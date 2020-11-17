function makePercentagePlotter(p1,p2,p3,components_num,circuit_name) 
%{ 
ONLY FOR EVEN ELEMENT CYCLES -- as of now 

The function takes three paths p1, p2, p3 that are specifying one of the
triplicates of the RACIPE solution files, and selects the GK normalised
values. then sees how many of the solutions fall under 1010... and 0101..
type of solutions and store their number and the number of the total 
solutions files in that stability states. Then finally its combines all the
three solutions and give the results in terms of a .csv file, whose
structure is as below: 

    % COL1 = % PATTERN 1 
    % COL2 = ERROR BAR OF PATTERN 1 
    % COL3 = % PATTERN 2
    % COL4 = ERROR BAR OF PATTERN 2 
    % COL5 = STABILITY STATE OF THE CORRESPONDING ROW
    % LAST ROW --> THE SAME CALCULATION FOR ALL STATES COMBINED
%}
%% For states other than N1
    pattern1 = zeros(1,components_num);
    pattern2 = zeros(1,components_num);
    for i=1:components_num
        toput = binary_complement(i);
        pattern1(1,i) = toput(1,1);
        pattern2(1,i) = toput(2,1);
    end
        pattern = [pattern1; pattern2];
        arrow = zeros(size(pattern,1),1);
        for j = 1:size(pattern,1)
            arrow(j,1) = 9;
        end
        pattern = [arrow, pattern, arrow];
        dlmwrite('data.txt',pattern,'delimiter','');
        Fn = dlmread('data.txt');
        
        pat2 = Fn(1,1);
        pat1 = Fn(2,1);
        
        delete('data.txt')

% %if states are for N1 circuit
% pat1 = 901109;
% pat2 = 910019;
%% Call the helper funciton 
    file1 = p1 ;
    file2 = p2 ;
    file3 = p3 ;
    [val1] = percentagePlotter(file1,components_num,pat1,pat2);
    [val2] = percentagePlotter(file2,components_num,pat1,pat2);
    [val3] = percentagePlotter(file3,components_num,pat1,pat2);
    val1
    val2
    val3
     
%% do the required calculations in each stability state using a for loop
    allStates = unique([val1(:,4); val2(:,4); val3(:,4)]);
    val = zeros(length(allStates)+3,5);
    i = 0;
    for currState = [allStates']
        i = i + 1; 
        z = []; q = [];
        participants = 0;
        
        for j1=1:size(val1,1)
            if val1(j1,4) == currState
                z = [z; val1(j1,1)*100/val1(j1,3)];
                q = [q; val1(j1,2)*100/val1(j1,3)];
                participants = participants + 1;
            end
        end
        
        for j2=1:size(val2,1)
            if val2(j2,4) == currState
                z = [z; val2(j2,1)*100/val2(j2,3)];
                q = [q; val2(j2,2)*100/val2(j2,3)];
                participants = participants + 1;
            end
        end
        
        for j3=1:size(val3,1)
            if val3(j3,4) == currState
                z = [z; val3(j3,1)*100/val3(j3,3)];
                q = [q; val3(j3,2)*100/val3(j3,3)];
                participants = participants + 1;
            end
        end
        
        val(i,1) = sum(z)/participants;
        val(i,2) = std(z);
        val(i,3) = sum(q)/participants;
        val(i,4) = std(q); 
        val(i,5) = int8(currState);
    end
        
%% Do the same calculations for all the states combined 
    one = sum(val1);
    two = sum(val2);
    three = sum(val3);
    
    total1 = [one(1,1)*100/one(1,3) two(1,1)*100/two(1,3) three(1,1)*100/three(1,3)]';
    total2 = [one(1,2)*100/one(1,3) two(1,2)*100/two(1,3) three(1,2)*100/three(1,3)]';
    
    val(end,1) = sum(total1)/3;
    val(end,2) = std(total1);
    val(end,3) = sum(total2)/3;
    val(end,4) = std(total2);
        
    name = [circuit_name,'.csv'];
    writematrix(val,name)
    % FINAL FORMAT OF VAL MATIX:
    % COL1 = % PATTERN 1 
    % COL2 = ERROR BAR OF PATTERN 1 
    % COL3 = % PATTERN 2
    % COL4 = ERROR BAR OF PATTERN 2 
    % COL5 = STABILITY STATE OF THE CORRESPONDING ROW
    % LAST ROW --> THE SAME CALCULATION FOR ALL STATES COMBINED 
   
end
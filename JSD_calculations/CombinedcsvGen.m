function output_matrix = CombinedcsvGen(pathRacipe, pathBoolean,name)
%{
This function outputs the distributions of the frequencies of the different
states combining the results from both RACIPE and Boolean simulations. Results 
from this function can be further used to calculate the JSD betwen the RACIPE 
and Boolean simulations.

the output_matrix is written in the following format:
col1: naming 01010...
col2: mean-values of RACIPE simulations
col3: mean-values of Boolean simulations
col4: std-dev of the RACIPE simulations
col5: std-dev of the Boolean simulations
%}
%% Make the mean column vector for the RACIPE file
    matrixR = readtable(pathRacipe);
    nameR = matrixR(:,2); nameR = table2array(nameR);
    nameR = cell2mat(nameR);
    meanR = matrixR(:,3); meanR = meanR{:,:};
    stdR = matrixR(:,4); stdR = stdR{:,:};
    nameR = nameR(:,2:(end-1));
    final_name = [];
    for i = 1:length(nameR)
        pattern = string(nameR(i,:));
        final_name = [final_name; pattern];
    end
    nameR = final_name;
%% Make the mean column vector for the Boolean file
    matrixB = readtable(pathBoolean,'Format','%s%f%f');
    nameB = matrixB(:,1); nameB = table2array(nameB);
    nameB = cell2mat(nameB);
    meanB = matrixB(:,2); meanB = meanB{:,:};
    stdB = matrixB(:,3); stdB = stdB{:,:};
    final_name = [];
    for i = 1:length(nameB)
        pattern = string(nameB(i,:));
        final_name = [final_name; pattern];
    end
    nameB = final_name;
%% perform JSD on both the distribution and store the value 
    C = setdiff(nameB,nameR);
    
    if length(nameB) < length(nameR)
        for i=1:length(C)
            nameB = [nameB; C(i)];
            meanB = [meanB; 0.00];
            stdB = [stdB; 0.00];
        end
    elseif length(nameR) < length(nameB)
        for i=1:length(C) 
            nameR = [nameR; C(i)];
            meanR = [meanR; 0.00];
            stdR = [stdR; 0.00];
        end
    else
        % do nothing
    end
    
    outputMB = meanB;
    outputSB = stdB;
    outputMR = [];
    outputSR = [];
    for i=1:length(nameB)
        pattern = string(nameB(i,1));
        for j = 1:length(nameR)
            if (nameR(j,1) == pattern)
                outputMR = [outputMR; meanR(j,1)];
                outputSR = [outputSR; stdR(j,1)];
            end
        end
    end
    output_matrix = [nameB, string(outputMR), string(outputMB), string(outputSR), string(outputSB)]
    Name = name + ".csv";
    writematrix(output_matrix,Name)
end
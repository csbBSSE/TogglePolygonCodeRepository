# Article: Operating principles of circular toggle polygons

# Instruction to the end-user to replicate the results

## Step 1: RACIPE Simulations (Three independent replicates for each network)

Detailed instructions about RACIPE is given [here:](https://www.google.com "RACIPE Code Repo")

The details of the networks are generated in a .topo file. For details, visit the above link. 
After the topo file is created, the compiled RACIPE can be run using: 
`./RACIPE <file>.topo -num_paras <number_of_parameter_sets> -num_ode <number_of_initial_conditions_for_each_parameter_set>` 
Additinal flags were used in special conditions, for those details, refer to "Methods" section or our article and visit the above mentioned repository of RACIPE.

Once the triplicates of the RACIPE simulations are done, we use the following pipelines to analyze the data in different ways.

**Important**: Keep all the triplicates of the RACIPE solutions for a same network in the same directory (preferebly, name the directory as the name of the network). For example Make a directory `/home/user1/4c` and keep the replicate one inside the the folder as `/home/user1/4c/1` and same for replicate two and three. 

# Code definitions: 

**G/K Normalization:**  
filename: `GK_normalization.md`

This code performs G/K normalization on all the RACIPE solution files present in the Given directory and writes the output in the `*_solutions_gk_?.dat` files in the same directory.

inputs: 
1. `path`: path where the RACIPE solution files i.e. `*_solution_?.dat` files are stored. 
2. `components_num`: Number of components in the network. Example: `components_num = 4` for network 4c, 4cS, 
3. `external_signal`: Always equal to Zero for all the analysis we have performed in this article. Hence, `external_signal = 0`

Example: `GK_normalization("path_to_RACIPE_simulations/4c/2",4,0)`

**Stability State Counting** 
filenames: `MakeStabilityStateCounter.m, stabilityStateCounter.m` <-- For default RACIPE files, which performs calculations till "deca-stable" solutions. 
   `universal_stability_state_counter.m, stateCounter.m` <-- for more complex RACIPE simulations file, where we specify to calculate beyond "deca-stable solutions"

This set of codes basically reads the RACIPE solutions files (of the triplicates for a particular network) and calculates what percentage of the total number of solutions belong to mono-stable, bi-stable, tri-stable and "higher-stable" solutions. This stores this data, in the form of a .fig and .xls file, which can be later used to plot the data. 
   The data contains, the mean of the frequency of the each solution states, found in each of the triplicates and the standard deviation is calculated for the error-bar. 

_MainFiles:_
_For default RACIPE solutions:_ i.e. `-num_stability 10` --> `MakeStabilityStateCounter.m `
inputs: 
1. `path`: path of the directory of the network, where all the triplicates of the RACIPE simulations results are kept. 
2. `Name`: `<Name>_stability_state_counter`will be the name of the .fig and .xls file, which will be generated as the output of this code. 

Example: `MakeStabilityStateCounter('path_to_RACIPE_simulations/5cS','5cS')`

_For larger RACIPE solutions:_ e.g. `-num_stability 20` -->   `universal_stability_state_counter.m`
1. `p1`: path of the first replicate of the RACIPE simulation of the concerned network 
2. `p2`: path of the second replicate of the RACIPE simulation of the concerned network 
3. `p3`: path of the third replicate of the RACIPE simulation of the concerned network 
4. `name`: `<name>_stability_state_counts<30>` is the name of the .fig file it generates as output. [Note, this code does not generate a separate .xls file, although the .fig file can be used to extract the mean and standard deviation data using standard MATLAB functions]


# Article: Operating principles of circular toggle polygons

# Instruction to the end-user to replicate the results

## Step 1: RACIPE Simulations (Three independent replicates for each network)

Detailed instructions about RACIPE is given [here:](https://www.google.com "RACIPE Code Repo")

The details of the networks are generated in a .topo file. For details, visit the above link. 
After the topo file is created, the compiled RACIPE can be run using: 
`./RACIPE <file>.topo -num_paras <number_of_parameter_sets> -num_ode <number_of_initial_conditions_for_each_parameter_set> -`

Once the triplicates of the RACIPE simulations are done, we use the following pipelines to analyze the data in different ways.

**Important**: Keep all the triplicates of the RACIPE solutions for a same network in the same directory (preferebly, name the directory as the name of the network). For example Make a directory `/home/user1/4c` and keep the replicate one inside the the folder as `/home/user1/4c/1` and same for replicate two and three. 
   We performed three replicates for each replicates in our analysis. It is certainly possible to use more, if the user wants. 

# Code definitions: 

**G/K Normalization:**  
filename: `GK_normalization.md`

This code performs G/K normalization on all the RACIPE solution files present in the Given directory and writes the output in the `*_solutions_gk_?.dat` files in the same directory.

inputs: 
1. `path`: path where the RACIPE solution files i.e. `*_solution_?.dat` files are stored. 
2. `components_num`: Number of components in the network. Example: `components_num = 4` for network 4c, 4cS, 
3. `external_signal`: Always equal to Zero for all the analysis we have performed in this article. Hence, `external_signal = 0`

Example: `GK_normalization("path_to_RACIPE_simulations/4c/replicate_number_folder",4,0)`

**Stability State Counting** 

# Article: Operating principles of circular toggle polygons

# Instruction to the end-user to replicate the results

## RACIPE Simulations (Three independent replicates for each network)

Detailed instructions about RACIPE is given [here:](https://github.com/hebbaranish/Gene_Network_Modelling/tree/master/RACIPE-1.0-master/Multithreaded_Racipe_2.28 "RACIPE Code Repo")

The information of the network and its interactions are written in a .topo file. For details, visit the above link. 
After the topo file is created, the compiled RACIPE can be run using: 
`./RACIPE <file>.topo -num_paras <number_of_parameter_sets> -num_ode <number_of_initial_conditions_for_each_parameter_set>` 
Additinal flags were used in special conditions, for those details, refer to "Methods" section or our article and visit the above mentioned repository of RACIPE.

Once the triplicates of the RACIPE simulations are done, we use the following pipelines to analyze the data in different ways.

**Important**: Keep all the triplicates of the RACIPE solutions for a same network in the same directory (preferebly, name the directory as the name of the network). For example Make a directory `/home/user1/4c` and keep the replicate one inside the folder as `/home/user1/4c/1` and same for replicate two and three. 

## Boolean Simulations [Link is still missing]
For Boolean analysis, network topology is given as the input file that mentions the nodes and edges of the network. The edges can be of two types, activating and inhibiting. The analysis was carried out by the asynchronous update of the nodes, i.e. one node is chosen randomly and updated in a given timestep. The constraint of equal weightage to inhibitory and activating links was used. The updating of the nodes follows a simple majority rule. The node is updated to 1 if the sum of activations to the node is higher than inhibitions and updated to 0 for the opposite case. The steady state is said to be reached if there is no change in the updates for a predefined number of time-steps. We have run the simulations for 10000 random initial conditions for a given network. For more information, visit this [link](https://github.com/ComplexityBiosystems/bmodel "Boolean")

## sRACIPE Simulations
We performed RACIPE simulations on toggle square and toggle pentagon to generate a set of random parameter sets and simulated the system with a fixed amount of noise in one of the parameters using sRACIPE. We used the webserver facility of Gene Circuit Explorer (GeneEx) to simulate stochastic dynamics of gene regulatory circuits: [link](https://geneex.jax.org/ "sRACIPE")

# Code definitions: 

**G/K Normalization:**  
filename: `GK_normalization.md`

This code performs G/K normalization on all the RACIPE solution files present in the Given directory and writes the output in the `*_solutions_gk_?.dat` files in the same directory. [`*` and `?` denote their standard meaning as that of UNIX command line.]

inputs: 
1. `path`: path where the RACIPE solution files i.e. `*_solution_?.dat` files are stored. 
2. `components_num`: Number of components in the network. Example: `components_num = 4` for network 4c, 4cS, 
3. `external_signal`: Always equal to Zero for all the analysis we have performed in this article. Hence, `external_signal = 0`

Example: `GK_normalization("path_to_RACIPE_simulations/4c/2",4,0)`

***

**Stability State Counting** 
filenames: `MakeStabilityStateCounter.m, stabilityStateCounter.m` <-- For default RACIPE files, which performs calculations till "deca-stable" solutions. 
   `universal_stability_state_counter.m, stateCounter.m` <-- for more complex RACIPE simulations file, where we specify to calculate beyond "deca-stable solutions"

This set of codes basically reads the RACIPE solutions files (of the triplicates for a particular network) and calculates what percentage of the total number of solutions belong to mono-stable, bi-stable, tri-stable and "higher-stable" solutions. This stores this data, in the form of a .fig and .xls file, which can be later used to plot the data. 
   The data contains, the mean of the frequency of the each solution states, found in each of the triplicates and the standard deviation is calculated for the error-bar. 

---

_Main Functions:_

_For default RACIPE solutions:_ i.e. `-num_stability 10` --> `MakeStabilityStateCounter.m `

inputs: 
1. `path`: path of the directory of the network, where all the triplicates of the RACIPE simulations results are kept. 
2. `Name`: `<Name>_stability_state_counter`will be the name of the .fig and .xls file, which will be generated as the output of this code. 

Example: `MakeStabilityStateCounter('path_to_RACIPE_simulations/5cS','5cS')`

---
_For "larger" RACIPE solutions:_ e.g. `-num_stability 20` -->   `universal_stability_state_counter.m`

*Here*, "larger" RACIPE solutions are defined as those simulations with `num_stability` > 10 (default). 

inputs:
1. `p1`: path of the first replicate of the RACIPE simulation of the concerned network 
2. `p2`: path of the second replicate of the RACIPE simulation of the concerned network 
3. `p3`: path of the third replicate of the RACIPE simulation of the concerned network 
4. `name`: `<name>_stability_state_counts<30>` is the name of the .fig file it generates as output. [Note, this code does not generate a separate .xls file, although the .fig file can be used to extract the mean and standard deviation data using standard MATLAB functions]

Example: `universal_stability_state_counter('path_to_larger_RACIPE_simulations/7cS/1','path_to_larger_RACIPE_simulations/7cS/2','path_to_larger_RACIPE_simulations/7cS/3','7cS')`

***

**Frequency Calculations**
filename: `allSolutionCombiner.m`

This function takes all the solution files of a RACIPE simulation, starting from the monostable solution to the highest-stable solution present in the directory, and merge those to form a combined solution files, which mimic that of a mono-stable solution file, but containes solution from all the stability states. The output of this file is a .dat file, which is printed in the same directory. Basically, this function makes a solutions file, which mimics that of a Boolean solution file, for the same network, for further downstream analysis. This output file(.dat) also requires G/K normalization for further analysis. 

inputs:

1. `path`: path where the RACIPE solution files i.e. `*_solution_?.dat` files are stored.
2. `components_num`: Number of components in the network.
3. `Name`: the name of the ouput .dat file. 

example: `allSolutionFileCombiner('path_to_RACIPE_simulations/9cS/2/', 9, '9cS_combined')`

---

filenames: 
   Main Function: `make_an_errorbar_conditions_apply.m`
   Helper Function: `err_bar_maker.m`

Main Function: This function reads the solution files, mentioned in the inputs and output the average frequency and the standard deviation across all the triplicates of the different solution states in that solution file. The output result is stored in a .xls file, which can be later analysed using Microsoft Excel. 

inputs:

1. `p1`: path of the solution file of our choice of stability state in the first replicate of the RACIPE simulation of the concerned network 
2. `p2`: path of the solution file of our choice of stability state in the the second replicate of the RACIPE simulation of the concerned network 
3. `p3`: path of the solution file of our choice of stability state in the the third replicate of the RACIPE simulation of the concerned network 
4. `sol_num`: number of stabiliy-state. e.g. `2` for bistable states, `10` for decastable states
5. `components_num`: Number of components in the network
6. `ext_signals_num`: always = `0` for all the relevant simulations done in this study 
7. `condition`: the output will only show sates with frequency, larger than the magnitude mentioned in this variable. In our case, we used `condition = 0` universally, and then later used Microsoft Excel to pick the most dominant states later from the output .xls file. 
8. `name`: Name of the output .xls file. 

example: `make_an_errorbar_conditions_apply('/path_to_RACIPE_simulations/7c/1/7c_solution_gk_10.dat','/path_to_RACIPE_simulations/7c/2/7c_solution_gk_10.dat', '/path_to_RACIPE_simulations/7c/3/7c_solution_gk_10.dat', 10, 7, 0, 0,'7c_deca_stable')`

---

filenames: 
   Main Function: `most_common_odd_mono_state_finder.m`
   Helper Function: `err_bar_maker.m`

Main Function: ONLY WORKS WITH ODD-NUMBERED TOGGLE POLYGON NETWORKS. It reads all the monostable solution files from each of the triplicates of the RACIPE simulations and make a .xls file that states the relative frequency of all the dominant monostable states compared to the rest of the states in the monostable solution.

inputs: 

1. `p1`: path of the monostable state solution file in the first replicate of the RACIPE simulation of the concerned network 
2. `p2`: path of the monostable state solution file in the the second replicate of the RACIPE simulation of the concerned network 
3. `p3`: path of the monostable state solution file in the the third replicate of the RACIPE simulation of the concerned network 
4. `components_num`: Number of components in the network. 
5. `name`: Name of the output .xls file. 

example: `most_common_odd_mono_state_finder('path_to_RACIPE_simulations/9c/1/9c_solution_gk_1.dat','path_to_RACIPE_simulations/9c/2/9c_solution_gk_1.dat', 'path_to_RACIPE_simulations/9c/3/9c_solution_gk_1.dat', 9,'9c_mono_common')

---

filenames: 
   Main Function: `most_common_odd_bi_state_finder.m`
   Helper Function: `err_bar_maker.m`

Main Function: ONLY WORKS WITH ODD-NUMBERED TOGGLE POLYGON NETWORKS. It reads all the bistable solution files from each of the triplicates of the RACIPE simulations and make a .xls file that states the relative frequency of the all the bistable states generated via some combination of the dominant monostable states compared to the rest of the states in the bistable solution.

inputs:

1. `p1`: path of the bistable state solution file in the first replicate of the RACIPE simulation of the concerned network 
2. `p2`: path of the bistable state solution file in the the second replicate of the RACIPE simulation of the concerned network 
3. `p3`: path of the bistable state solution file in the the third replicate of the RACIPE simulation of the concerned network 
4. `components_num`: Number of components in the network. 
5. `name`: Name of the output .xls file. 


example: `most_common_odd_bi_state_finder('path_to_RACIPE_simulations/9c/1/9c_solution_gk_2.dat','path_to_RACIPE_simulations/9c/2/9c_solution_gk_2.dat', 'path_to_RACIPE_simulations/9c/3/9c_solution_gk_2.dat', 9,'9c_bi_common')`

---

**JSD (Jensen-Shannon Divergence) Calculations**

filename: `CombinedcsvGen.m`

This function takes the frequency distribution of the combined results of the RACIPE and Boolean simulations and make a combined matrix that displays the predicted frequencies of each solution states as per RACIPE and Boolean simulations. This output matrix is saved as a .csv file, which we are going to use later for calculation of the JSD of those two distributions. 

inputs:

1. `pathRacipe`: path to the combined frequency distribution file generated after analysing the RACIPE simulation data 
2. `pathBoolean`: path to the combined frequency distribution file generated in Boolean simulation
4. `name`: Name of the output .csv file.

example: `CombinedcsvGen('RACIPE/3c_combined.csv','Boolean/Boolean_freq_3c.csv','3c_RACIPE_plus_Boolean')`

--- 

filename: `JSD-operation.ipynb`

This is a very small Jupyter Notebook script that prompts the user to input the frequency distrubtion of the combined RACIPE simulation and then the frequency distribution of the Boolean simulation. Then it calculates the JSD between the two distributions to find out how much similar those distrubutions are. The input data that the program prompts for can be manually copy-pasted in the terminal (when it prompts for it) from the output .csv file of the `CombinedcsvGen.m` function. 

---

**Relative Stability Analysis** 

_Note: This part of the code is not as straight forward as previous ones and requires bit more manual effort from the end-user to be able to run it properly._

_Some Naming Conventions_: The naming conventions for the circuits used here are little different from that used in the manuscript and other places. 
The general pattern is like: 
- 7c <--> SEVEN 
- 7cS <--> SEVEN_SA
- 5c <--> FIVE 
- 5cS <--> FIVE_SA
... 

filename: `dynamic_simulation_<circuit name>.m`

These functions are primarily there to build the coupled shifted Hill function required to solve the networks in MATLAB and those results can be plotted to find out the presence of any oscillations and also to find out the relative stability of the individual states in a multi-stable solution (our primary focus in this article was on the relative stability of the corresponding monostable states in the most dominant bistable solution(s)).
   Hence, the right function (i.e. the function corresponding the right networks, that the user wants to analyze) must be used while doing relative stability analysis or just plotting the results to search for oscillations.

filename: `odecode_relative_stability_<circuit component number>.m`

_This code requires the end user to modify it everytime before running on a different network._

variables to change: 
1. `path`: path to any of the triplicates of the RACIPE simulation of the network under consideration. e.g. `path_to_the_RACIPE_simulations/SEVEN/3`
2. `components_num`: Number of components in the network. 
3. `sol_num`: 2 for bistable solutions, 3 for tristable solutions, ... 
4. `categories`: Trying to explain this via an example. Suppose you want to calculate the relative frequency of the corresponding mono-stable states in the most common bistable solution in 4c circuit (which is: 611 <--This naming convention derives from the fact that my previous code represents: 0101 as 6 and 1010 as 11, this naming convention and transformatin is clearly mentioned in the output files of the `make_an_errorbar_conditions_apply.m` function). So, we want to know the relative stability of the corresponding states 6 (0101) and 11 (1010) in that bistable solution. For that we have to write `categories = [611 116]`, basically all the possible permutations of 6 and 11, in a vector format.
   Similarly, for a hypothetical tristable state `234`, we have to write `categories = [234 243 342 324 432 423]` to get the relative stability of the corresponding monostable states. 
5. `run_time`: `run_time = 0:1:200` generally is enough for the solutions to reach convergence in all the cases, but it can be modified by the end-user as per the need 
6. `num_initials`: This number indicates how many random initial conditions to generate for this simulations, we have used 1000 initial conditions for all our analysis. 

Now, how exactly the data should be retrieved in the ouput is the choice of the user. I have given four examples, in my Code repository, where in `odecode_relative_stability_4.m` I collected the values of a,b,c,d separately and then chose the solutions where A=1,B=0,C=1,D=0 as state 11 and where A=0,B=1,C=0,D=1 as state 6 for the relative stability plotting. But, for `odecode_relative_stability_2.m, odecode_relative_stability_5.m, odecode_relative_stability_7.m` I wrote the definition of the states inside the code and just stored how many initial conditions converged to which state in each run. 

_User should go through `odecode_relative_stability_<circuit component number>.m` files carefully and understand these (the more complicated helpfer functions used inside this code can be neglected, as that part remains same in all the analysis. The user must tune his results as per his requirements to get the output in a mode that will be easier for him to analyze later.)_

---

filename: `personalODEplotter.m`

This code is very similar to the `odecode_relative_stability_<circuit component number>.m` codes. The different is that it plots all the solutions of Shifted Hill simulations with time as x-axis present in the given solution file. This is helpful to visualize if there is any oscillation in any solutions, which could not be done from RACIPE simulation results directl. 

variables to change: 
1. `path`: path to any of the triplicates of the RACIPE simulation of the network under consideration. e.g. `path_to_the_RACIPE_simulations/TEN_SA/2`
2. `components_num`: Number of components in the network. 
3. `sol_num`: 2 for bistable solutions, 3 for tristable solutions, ... 

Note: The current version of the code is for a 10 element toggle polygon, the end-user has to change the code accordingly to use it with any other toggle polygon network.

*IMPORTANT*: It has come to my notice that, the a part of the above two code will be a little different in different versions of MATLAB in cross platform. For example, in some versions `parameter_sets_for_simulating.("Prod_of_A  ")(ii)` has to be written as `parameter_sets_for_simulating.Prod_of_A(ii)`,  `parameter_sets_for_simulating.("Deg_of_A   ")` as `parameter_sets_for_simulating.Deg_of_A(ii)`. This has to looked into by the end user, to find which edition of the MATLAB he/she is using and in which operating system. The same goes for all the `dynamic_simulation_<circuit name>.m` files as well. This is not something very difficult to do, and must be one of the first line of debugging if any random error arises while running these codes. 

---

filename: `rel_stability_hist_plotting.m`

This performs the plotting of the relative stability of the different monostable states that make a bistable states. For this file to run properly, the matrix generated by the `dynamic_simulation_<circuit name>.m` file has to be loaded manually. 

---
---
# Pipelines used 


## Figure 2: Even numbered networks 

`RACIPE --> allSolutionFileCombiner.m --> GK_normalization --> make_and_errorbar_conditions_apply --> Choose top 5/6 dominant states in Microsoft Excel and plot the bar-chart `

`RACIPE --> allSolutionFileCombiner.m --> GK_normalization --> make_and_errorbar_conditions_apply --> A`   
`Boolean solution file --> B`     
`A + B -->CombinedcsvGen.m --> JSD-operation.ipynb --> JSD values `     


## Figure 3: A and B

`RACIPE --> GK_normalization --> MakeStabilityStateCounter.m --> Plot the data in Microsoft Excel and plot the bar-chart `

## Figure 3: C

`RACIPE --> allSolutionFileCombiner.m --> GK_normalization --> make_and_errorbar_conditions_apply --> Choose top 3 most dominant states in Microsoft Excel and plot the stacked bar-chart. `


## Figure 4

`RACIPE --> parameter and solution files ---> odecode_relative_stability_<circuit component number>.m --> rel_stability_hist_plotting.m` 

The function `rel_stability_his_plotting.m` prints the percentage of the bistable solutions, which fall inside the [0,0.045)U(0.965,1.00] range (i.e. the effective monostable solutions). Those can be copy pasted inside an Excel Sheet and then used to plot the bar-chart of *Fig. 4-D* 

## Figure 5: Odd numbered networks 

`RACIPE --> allSolutionFileCombiner.m --> GK_normalization --> make_and_errorbar_conditions_apply --> Choose top (n*2) dominant states in Microsoft Excel and plot the bar-chart ` n = number of components in the circuit 

`(RACIPE --> allSolutionFileCombiner.m --> GK_normalization --> make_and_errorbar_conditions_apply) + Boolean solution file --> CombinedcsvGen.m --> JSD-operation.ipynb --> JSD values `

## Figure 6: A

`RACIPE --> GK_normalization --> MakeStabilityStateCounter.m --> Plot the data in Microsoft Excel and plot the bar-chart `

## Figure 6: B and C

`RACIPE --> allSolutionFileCombiner.m --> GK_normalization --> most_common_odd_mono_stable_finder.m --> Open the .xls file in Microsoft Excel and plot it`

`RACIPE --> allSolutionFileCombiner.m --> GK_normalization --> most_common_odd_bi_stable_finder.m --> Open the .xls file in Microsoft Excel and plot it`

## Figure 8:
Refer to the sRACIPE section. 

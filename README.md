# VBDM
A value-based decision-making battery to asses impulsive and risky behavior 

Using simple mathematical models of choice behaviour, we implemented a Bayesian adaptive
algorithm under Octave\Matlab to assess measures of impulsive and risky decision making. 
Practically, these measures are characterized by discounting rates and are used to classify
individuals or groups of populations, distinguish unhealthy behaviour and predict 
developmental courses. The algorithm is based on trial-by-trial observations. 
At each step a choice is made between immediate (certain) and delayed (risky) options. 
Then the current parameter estimates are updated by the likelihood of observing the 
choice and the next offers are provided from the indifference point which would acquire
the most informative data based on the current parameter estimates. 
The procedure continues for certain number of trials in order to reach a stable
estimation.

The battery consists of four independent tasks including Delay Discounting (DD), 
Probability Discounting for Gains (PDG), Probability Discounting for Losses (PDL)
and Mixed Gambles (MG).

During each task, participants are supposed to choose one of the two offers presented
simultaneously for 5 seconds on a computer screen. The time limit has been set regarding the
average response time of previous assessments. For each trial the participant’s choice is
highlighted with a frame before presenting the next offer. Presenting the outcomes of gambles
during the experiment and the time interval of each trial as well as the number of trials are
optional and set initially. In general, subjects are informed by an instruction part before each task
that at the end of the experiment one trial per task is selected randomly from their choices and
credited to their compensation. However, instructions are integrated into the battery and can be
modified based on alternative task designs. 

Temporal delays in DD are set to 3, 7, 14, 31, 61,180, and 365 days. For PDG and PDL gambles are
played with five possible probability values: 2/3, 1/2, 1/3, 1/4, and 1/5. The task length for 
DD, PDL and PDG is 50 trials and monetary gains/losses ranges from €3 to €50. For MG, 50 trials 
are played presenting amounts of 1--40 for gains and 5--20 for losses in Euros. The number of trials,
50, was chosen according to data acquired by previous implementations of the algorithm to end up  
with stable estimates. At the beginning of the MG task participants receive €10 as "house money".
During all tasks, offers are randomly assigned to the left or to the right of the screen.
# Running the battery
1. Downlod or clone the repository to your local drive.
2. Navigate to the directory.
3. Run the function "runVBDM.m" in Matlab
4. Fill in the required information in the GUI.
5. Select the tasks you would like to run.
6. Press "Run All".
The output is saved in a directory called "data" next to "runVBDM.m".

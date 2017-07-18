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

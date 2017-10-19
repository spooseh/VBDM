function runVBDMnoGUI
% % RUNVBDMNOGUI runs selected tasks from the VBDM task battery.
% % It starts with a diolog box to input the general 
% % information such as "Subject ID", "Age", "Gender", etc.
% % All four tasks have been selected by default (1). 
% % Please hard-code the "Project ID" at line 25.
% % The file name can be modified at ./source/runTasks, line 31.
% % 
% % For the theoretical background please refer to: 
% % Value-based decision-making battery: 
% % A Bayesian adaptive approach to assess impulsive and risky behavior
% % S. Pooseh, N. Bernhardt, A. Guevara, Q. J. M. Huys, M. N. Smolka
% % https://doi.org/10.3758/s13428-017-0866-x
% % 
% % Contact:  Shakoor.Pooseh@tu-dresden.de
% % Section of Systems Neuroscience
% % Department of Psychiatry and Psychotherapy
% % Faculty of Medicine Carl Gustav Carus
% % Technische Universität Dresden

addpath(genpath('./source'))
genInfo.expVersion = '3.0.0717';
genInfo.timedStimulus = 1;
genInfo.giveFeedback  = 1;
genInfo.ProjectID = '034'; %'B3';      
genInfo.subjn     = ''; %'012';
genInfo.session   = ''; %'1';
genInfo.age       = ''; %'34';
genInfo.sex       = ''; %'F';
genInfo.type      = ''; %'C';

genInfo.doDebug    = 0;
genInfo.nTrials    = 50; 
genInfo.language   = 'DE';% 'DE': Deutsch, 'EN': English
genInfo.doInstruct = '1'; 
genInfo.doPay      = '1';
genInfo.doSave     = '1';
chooseDD  = '1';
choosePDG = '1';
choosePDL = '1';
chooseMG  = '1';
taskChoice = {chooseDD,choosePDG,choosePDL,chooseMG};

KbName('UnifyKeyNames');
tasks = {'DD','PDG','PDL','MG'};
if ~genInfo.doDebug
    [genInfo,toRun] = setupVBDM(genInfo,tasks,taskChoice);
    if ~isempty(toRun)
        runTasks(genInfo,toRun);
    end
else
    toRun = tasks(strcmp(taskChoice,'1'));
    genInfo.nTrials    = 1;
    runTasks(genInfo,toRun);
end
closeExperiment; % clear the screen and exit
fprintf('\n');
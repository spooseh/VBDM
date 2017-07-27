% % This script runs selected tasks from the VBDM task battery.
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

clear;
if exist('OCTAVE_VERSION', 'builtin')
    pkg load financial;
end
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
genInfo.doInstruct = 1; 
genInfo.doPay      = 1;
genInfo.doSave     = 1;
chooseDD  = 1;
choosePDG = 1;
choosePDL = 1;
chooseMG  = 1;
tmp = [chooseDD,choosePDG,choosePDL,chooseMG];

KbName('UnifyKeyNames');
tasks = {'DD','PDG','PDL','MG'};
if ~genInfo.doDebug
    prompt = {
        'Project ID',...
        'Subject ID',...
        'Session',...
        'Age',...
        'Gender   (F / M)',...
        'Type     (C / P)',...
        'Run DD   (0 / 1)',...
        'Run PDG  (0 / 1)',...
        'Run PDL  (0 / 1)',...
        'Run MG   (0 / 1)'
        };
    def    = { (genInfo.ProjectID),...
               (genInfo.subjn),...
               (genInfo.session),...
               (genInfo.age),...
               (genInfo.sex),...
               (genInfo.type),...
        num2str(chooseDD),...
        num2str(choosePDG),...
        num2str(choosePDL),...
        num2str(chooseMG),...
        };
    dlg_title = 'General info and setup';
    answer = inputdlg(prompt,dlg_title,1,def);
    if ~isempty(answer)
        i = 0;
        i = i+1;  genInfo.ProjectID  =           (answer{i});
        i = i+1;  genInfo.subjn      =           (answer{i});
        i = i+1;  genInfo.session    =           (answer{i});
        i = i+1;  genInfo.age        =           (answer{i});
        i = i+1;  genInfo.sex        =           (answer{i});
        i = i+1;  genInfo.type       =           (answer{i});
        i = i+1;  chooseDD           = str2double(answer{i});
        i = i+1;  choosePDG          = str2double(answer{i});
        i = i+1;  choosePDL          = str2double(answer{i});
        i = i+1;  chooseMG           = str2double(answer{i});
    else
        return
    end
    sbjInfo={genInfo.ProjectID,genInfo.subjn,genInfo.age,genInfo.sex,genInfo.type};
    missing= cellfun(@isempty,(sbjInfo),'UniformOutput',0);
    missing = cell2mat(missing);
    if sum(missing)
        vars={'ProjectID','SubjectID','Age','Sex','Type'};
        mis=vars(missing==1);
        txt=sprintf('%s\n',mis{:});
        txt1=sprintf('Missing information:\n %s',txt);
        errMsg = errordlg(txt1,'Error');
        set(errMsg, 'WindowStyle', 'modal');
        uiwait(errMsg);
        return
    end
    tmp = [chooseDD,choosePDG,choosePDL,chooseMG];
    tmp(isnan(tmp)) = 0;
    if sum(tmp) == 0
        errMsg = errordlg('Select at least one task!','Error');
        set(errMsg, 'WindowStyle', 'modal');
        uiwait(errMsg);
        return
    else
        toRun = tasks(tmp == 1);
        choice = questdlg(['Please confirm!';...
                          ['subject ID: ' genInfo.subjn];toRun'], ...
                          'Confirmation', ...
                          'Cancel','RUN','RUN');
    end
else
    toRun = tasks(tmp == 1);
    genInfo.nTrials    = 1;
    choice = 'RUN';
end
if strcmp(choice,'RUN')
    runTasks(genInfo,toRun);
else
    return
end
closeExperiment; % clear the screen and exit
fprintf('\n');
%         'Instruct (0/1)',...
%         'Pay      (0/1)',...
%         'Save     (0/1)',...

%         num2str(genInfo.doInstruct),...
%         num2str(genInfo.doPay),...
%         num2str(genInfo.doSave),...

%         i = i+1;  genInfo.doInstruct = str2double(answer{i});
%         i = i+1;  genInfo.doPay      = str2double(answer{i});
%         i = i+1;  genInfo.doSave     = str2double(answer{i});


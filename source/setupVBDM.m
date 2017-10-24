function [genInfo,toRun] = setupVBDM(genInfo,tasks,taskChoice)
toRun = [];
while 1
    vars = {
        'Project ID: ';
        'Subject ID: ';
        'Session: ';
        'Age: ';
        'Gender (Female \ Male): ';
        'Type (Control \ Patient): ';
        'Language (EN \ DE): '};
    def    = {
        genInfo.ProjectID;
        genInfo.subjn;
        genInfo.session;
        genInfo.age;
        genInfo.sex;
        genInfo.type;
        genInfo.language};
    dlg_title = 'General information:';
    answer = inputdlg(vars,dlg_title,1,def);
    if isempty(answer)
        return
    else
        i = 0;
        i = i+1;  genInfo.ProjectID  = answer{i};
        i = i+1;  genInfo.subjn      = answer{i};
        i = i+1;  genInfo.session    = answer{i};
        i = i+1;  genInfo.age        = answer{i};
        i = i+1;  genInfo.sex        = answer{i};
        i = i+1;  genInfo.type       = answer{i};
        i = i+1;  genInfo.language   = answer{i};
    end
    sbjInfo = {genInfo.ProjectID;
               genInfo.subjn;
               genInfo.session;
               genInfo.age;
               genInfo.sex;
               genInfo.type;
               genInfo.language};
    missing = cellfun(@isempty,sbjInfo,'UniformOutput',0);
    missing = cell2mat(missing);
    if sum(missing)
        mis  = vars(missing==1);
        txt  = sprintf('%s\n',mis{:});
        txt1 = sprintf('Missing information:\n %s',txt);
        errMsg = errordlg(txt1,'Error');
        set(errMsg, 'WindowStyle', 'modal');
        uiwait(errMsg);
        continue
    else
        txt = {
        'Project ID: ';'';
        'Subject ID: ';'';
        'Session: ';'';
        'Age: ';'';
        'Gender: ';'';
        'Type: ';'';
        'Language: '};
        info = {genInfo.ProjectID;'';
                genInfo.subjn;'';
                genInfo.session;'';
                genInfo.age;'';
                genInfo.sex;'';
                genInfo.type;'';
                genInfo.language};
        txt  = strcat(txt,info);
        choice = questdlg(txt,'Please confirm!','Continue','Modify','Cancel','Cancel');
        switch choice
            case 'Continue'
                break;
            case 'Modify'
                continue;
            otherwise 
                return
        end
    end
end

while 1
    vars = {
        'Instruct: ';
        'Pay: ';
        'Save: '
        'Delay Discounting (DD): ';
        'Prob. Discounting for Gains. (PDG): ';
        'Prob. Discounting for Losses (PDL): ';
        'Mixed Gambles (MG): '};
    def    = {
        genInfo.doInstruct;
        genInfo.doPay;
        genInfo.doSave;
        taskChoice{1};
        taskChoice{2};
        taskChoice{3};
        taskChoice{4}};
    dlg_title = 'Runtime setup:';
    answer = inputdlg(vars,dlg_title,1,def);
    if isempty(answer)
        return
    else
        i = 0;
        i = i+1;  genInfo.doInstruct = answer{i};
        i = i+1;  genInfo.doPay      = answer{i};
        i = i+1;  genInfo.doSave     = answer{i};
        i = i+1;  chooseDD           = answer{i};
        i = i+1;  choosePDG          = answer{i};
        i = i+1;  choosePDL          = answer{i};
        i = i+1;  chooseMG           = answer{i};
    end
    sbjInfo = {genInfo.doInstruct;
               genInfo.doPay;
               genInfo.doSave;
               chooseDD;
               choosePDG;
               choosePDL;
               chooseMG};
    missing = cellfun(@isempty,sbjInfo,'UniformOutput',0);
    missing = cell2mat(missing);
    if sum(missing)
        mis  = vars(missing==1);
        txt  = sprintf('%s\n',mis{:});
        txt1 = sprintf('Missing information (please give 0 or 1):\n %s',txt);
        errMsg = errordlg(txt1,'Error');
        set(errMsg, 'WindowStyle', 'modal');
        uiwait(errMsg);
        continue
    else
        tmp = {chooseDD,choosePDG,choosePDL,chooseMG};
        if sum(strcmp(tmp,'1'))== 0
            errMsg = errordlg('Select at least one task!','Error');
            set(errMsg, 'WindowStyle', 'modal');
            uiwait(errMsg);
            continue;
        else
            txt = {
                   'Instruct: ';'';
                   'Pay: ';'';
                   'Save: ';'';
                   'DD: ';'';
                   'PDG: ';'';
                   'PDL: ';'';
                   'MG: '};
            info = {genInfo.doInstruct;'';
                    genInfo.doPay;'';
                    genInfo.doSave;'';
                    chooseDD;'';
                    choosePDG;'';
                    choosePDL;'';
                    chooseMG};
            txt  = strcat(txt,info);
            choice = questdlg(txt,'Please confirm!','Run','Modify','Cancel','Cancel');
            switch choice
                case 'Run'
                    break;
                case 'Modify'
                    continue;
                otherwise
                    return
            end
        end
    end
end
genInfo.doInstruct = str2double(genInfo.doInstruct);
genInfo.doPay      = str2double(genInfo.doPay);
genInfo.doSave     = str2double(genInfo.doSave);
taskChoice   = {chooseDD,choosePDG,choosePDL,chooseMG};
toRun = tasks(strcmp(taskChoice,'1'));

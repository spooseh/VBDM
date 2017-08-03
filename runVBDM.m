function varargout = runVBDM(varargin)
% Begin initialization code - DO NOT EDIT
addpath(genpath('./source'))
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @runVBDM_OpeningFcn, ...
                   'gui_OutputFcn',  @runVBDM_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before runVBDM is made visible.
function runVBDM_OpeningFcn(hObject, ~, handles, varargin)

handles.output        = hObject;
handles.expVersion    = '3.0.0717';

handles.timedStimulus = 1;
handles.giveFeedback  = 1;
handles.doDebug       = 0;
handles.nTrials       = 50;
handles.language      = 'DE';

handles.ProjectID = '';
handles.subjn     = '';
handles.session   = '';
handles.age       = '';
handles.sex       = '';
handles.type      = '';

handles.doInstruct = 1;
handles.doPay      = 1;
handles.doSave     = 1;

handles.runDD  = 1;
handles.runPDG = 1;
handles.runPDL = 1;
handles.runMG  = 1;

if handles.doDebug
    handles.nTrials = 1;
end

set(findobj('Tag','prjID'),'String',handles.ProjectID);
set(findobj('Tag','sbjID') ,'String',handles.subjn);
set(findobj('Tag','sbjSes'),'String',handles.session);
set(findobj('Tag','sbjAge'),'String',handles.age);
set(findobj('Tag','sexF'), 'Value',strcmp(handles.sex,'F'));
set(findobj('Tag','sexM'), 'Value',strcmp(handles.sex,'M'));
set(findobj('Tag','typeC'),'Value',strcmp(handles.type,'C'));
set(findobj('Tag','typeP'),'Value',strcmp(handles.type,'P'));
set(findobj('Tag','instructEN'),'Value',strcmp(handles.language,'EN'));
set(findobj('Tag','instructDE'),'Value',strcmp(handles.language,'DE'));
set(findobj('Tag','doInstruct'),'Value',handles.doInstruct);
set(findobj('Tag','doPay'),'Value',handles.doPay);
set(findobj('Tag','doSave'),'Value',handles.doSave);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = runVBDM_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

% --- Executes on button press in loadProfile.
function loadProfile_Callback(hObject, ~, handles)
[x,y] = uigetfile('Profile*.txt');
if x == 0;return;end
try
    fid = fopen(fullfile(y,x));
    tmp = textscan(fid,'%*s %s %*[^\n]'); tmp = tmp{1};
    i = 1;
    handles.ProjectID = char(tmp{i});
    set(findobj('Tag','prjID'),'String',tmp{i});
    i = i+1;
    handles.subjn=char(tmp{i});
    set(findobj('Tag','sbjID'),'String',tmp{i})
    i = i+1;
    handles.session = char(tmp{i});
    set(findobj('Tag','sbjSes'),'String',tmp{i})
    i = i+1;
    handles.age = char(tmp{i});
    set(findobj('Tag','sbjAge'),'String',tmp{i});
    i = i+1;
    handles.sex = char(tmp{i});
    if strcmp(tmp{i},'M')
        set(findobj('Tag','sexM'),'Value',1);
        set(findobj('Tag','sexF'),'Value',0);
    elseif strcmp(tmp{i},'F')
        set(findobj('Tag','sexF'),'Value',1);
        set(findobj('Tag','sexM'),'Value',0);
    end
    i = i+1;
    handles.type = char(tmp{i});
    if strcmp(tmp{i},'P')
        set(findobj('Tag','typeP'),'Value',1);
        set(findobj('Tag','typeC'),'Value',0);
    elseif strcmp(tmp{i},'C')
        set(findobj('Tag','typeC'),'Value',1);
        set(findobj('Tag','typeP'),'Value',0);
    end
    i = i+1;
    handles.language = char(tmp{i});
    if strcmp(tmp{i},'EN')
        set(findobj('Tag','instructEN'),'Value',1);
        set(findobj('Tag','instructDE'),'Value',0);
    elseif strcmp(tmp{i},'DE')
        set(findobj('Tag','instructDE'),'Value',1);
        set(findobj('Tag','instructEN'),'Value',0);
    end
    i = i+1;
    handles.doInstruct = str2double(tmp{i});
    if handles.doInstruct
        set(findobj('Tag','doInstruct'),'Value',1);
    else
        set(findobj('Tag','doInstruct'),'Value',0);
    end
    i = i+1;
    handles.doPay = str2double(tmp{i});
    if handles.doPay
        set(findobj('Tag','doPay'),'Value',1);
    else
        set(findobj('Tag','doPay'),'Value',0);
    end
    i = i+1;
    handles.doSave = str2double(tmp{i});
    if handles.doSave
        set(findobj('Tag','doSave'),'Value',1);
    else
        set(findobj('Tag','doSave'),'Value',0);
    end
    fclose(fid);
    guidata(hObject, handles);
catch
    errMsg = errordlg('Wrong file format!','Error');
    set(errMsg, 'WindowStyle', 'modal');
    uiwait(errMsg);
    return
end

function saveProfile_Callback(hObject, ~, handles)
sbjInfo={handles.ProjectID,handles.subjn,handles.session,handles.age,handles.sex,handles.type};
missing=cellfun('isempty',sbjInfo);
if sum(missing)
    vars={'Project_ID','Subject_ID','Session','Age','Sex','Type'};
    mis=vars(missing==1);
    txt=sprintf('%s,',mis{:});
    txt1=sprintf('Missing information:\n %s',txt);
    errMsg = errordlg(txt1,'Error');
    set(errMsg, 'WindowStyle', 'modal');
    uiwait(errMsg);
    return
end
fName=['Profile_' handles.ProjectID '_' handles.subjn '_' datestr(now,'yymmdd_HHMM_') '.txt'];
items = {'Project_ID','Subject_ID','Session','Age','Sex','Type','Language','Instruct','Pay','Save'};
vars  = {handles.ProjectID,handles.subjn,handles.session,handles.age,...
    handles.sex,handles.type,handles.language,...
    num2str(handles.doInstruct),num2str(handles.doPay),num2str(handles.doSave)};
fid=fopen(fName,'w');
for i = 1:length(items)   
   fprintf(fid,'%10s%10s\n',items{i},vars{i});
end
fclose(fid);
msg = msgbox('Profile saved!');
set(msg, 'WindowStyle', 'modal');
uiwait(msg);

function RunAll_Callback(hObject, ~, handles)
sbjInfo = {handles.ProjectID,handles.subjn,handles.session,handles.age,...
           handles.sex,handles.type};
missing = cellfun('isempty',sbjInfo);
if sum(missing) 
    vars = {'ProjectID','SubjectID','Session','Age','Sex','Type'};
    mis = vars(missing == 1);
    txt = sprintf('%s,',mis{:});
    txt1 = sprintf('Missing information:\n %s',txt);
    errMsg = errordlg(txt1,'Error');
    set(errMsg, 'WindowStyle', 'modal');
    uiwait(errMsg);
    return
end
tmp = [handles.runDD,handles.runPDG,handles.runPDL,handles.runMG];
if sum(tmp) == 0
    errMsg = errordlg('Select at least one task!','Error');
    set(errMsg, 'WindowStyle', 'modal');
    uiwait(errMsg);
    return
end
tasks = {'DD','PDG','PDL','MG'};
toRun = tasks(tmp == 1);
if isempty(toRun)
    errMsg = errordlg('Please select a task!','Error');
    set(errMsg, 'WindowStyle', 'modal');
    uiwait(errMsg);
    return
end
genInfo.expVersion    = handles.expVersion;
genInfo.timedStimulus = handles.timedStimulus;
genInfo.giveFeedback  = handles.giveFeedback;
genInfo.doDebug       = handles.doDebug;
genInfo.nTrials       = handles.nTrials;
genInfo.ProjectID     = handles.ProjectID;
genInfo.subjn         = handles.subjn;
genInfo.session       = handles.session;
genInfo.age           = handles.age;
genInfo.sex           = handles.sex;
genInfo.type          = handles.type;
genInfo.language      = handles.language;
genInfo.doInstruct    = handles.doInstruct;
genInfo.doPay         = handles.doPay;
genInfo.doSave        = handles.doSave;
runTasks(genInfo,toRun);
javaaddpath(which('MatlabGarbageCollector.jar'));
jheapcl;
fprintf('\n');

function prjID_Callback(hObject, ~, handles)
handles.ProjectID = get(hObject,'String');
set(hObject,'Enable', 'off');
guidata(hObject,handles);
function prjID_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function prjID_ButtonDownFcn(hObject, ~, handles)
set(hObject,'String','','Enable', 'on');
handles.ProjectID = '';
guidata(hObject,handles);
uicontrol(handles.prjID)


function sbjID_Callback(hObject, ~, handles)
handles.subjn = get(hObject,'String');
set(hObject,'Enable', 'off');
guidata(hObject,handles);
function sbjID_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function sbjID_ButtonDownFcn(hObject, ~, handles)
set(hObject,'String','','Enable', 'on');
handles.subjn = '';
guidata(hObject,handles);
uicontrol(handles.sbjID);

function sbjSes_Callback(hObject, ~, handles)
handles.session = get(hObject,'String');
set(hObject,'Enable', 'off');
guidata(hObject,handles);
function sbjSes_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function sbjSes_ButtonDownFcn(hObject, ~, handles)
set(hObject,'String','','Enable', 'on');
handles.session = '';
guidata(hObject,handles);
uicontrol(handles.sbjSes);

function sbjAge_Callback(hObject, ~, handles)
handles.age = get(hObject,'String');
set(hObject,'Enable', 'off');
guidata(hObject,handles);
function sbjAge_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function sbjAge_ButtonDownFcn(hObject, ~, handles)
set(hObject,'String','','Enable', 'on');
handles.age = '';
guidata(hObject,handles);
uicontrol(handles.sbjAge);

function sexM_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.sex = 'M';
    set(handles.sexF,'Value',0);
else
    handles.sex = '';
end
guidata(hObject,handles)
function sexM_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.sexM);

function sexF_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.sex = 'F';
    set(handles.sexM,'Value',0);
else
    handles.sex = '';
end
guidata(hObject,handles);
function sexF_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.sexF);

function typeP_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.type='P';
    set(handles.typeC,'Value',0);
else
    handles.type='';
end
guidata(hObject,handles);
function typeP_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.typeP);

function typeC_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.type='C';
    set(handles.typeP,'Value',0);
else
    handles.type='';
end
guidata(hObject,handles)
function typeC_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.typeC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function instructEN_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.language = 'EN';
    set(handles.instructDE,'Value',0);
else
    handles.doInstruct = 'DE';
    set(handles.instructEN,'Value',0);
end
guidata(hObject,handles);
function instructEN_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.instructEN);

function instructDE_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.language = 'DE';
    set(handles.instructEN,'Value',0);
else
    handles.language = 'EN';
    set(handles.instructDE,'Value',0);
end
guidata(hObject,handles)
function instructDE_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.instructDE);

function doInstruct_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.doInstruct=1;
else
    handles.doInstruct=0;
end
guidata(hObject,handles)
function doInstruct_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.doInstruct);

function doPay_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.doPay=1;
else
    handles.doPay=0;
end
guidata(hObject,handles)
function doPay_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.doPay);

function doSave_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.doSave=1;
else
    handles.doSave=0;
end
guidata(hObject,handles);
function doSave_ButtonDownFcn(hObject, ~, handles)
handles.doSave
set(hObject,'Enable', 'on');
uicontrol(handles.doSave);

function runDD_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.runDD = 1;
else
    handles.runDD = 0;
end
guidata(hObject,handles);
function runDD_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.runDD);

function runMG_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.runMG = 1;
else
    handles.runMG = 0;
end
guidata(hObject,handles)
function runMG_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.runMG);

function runPDL_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.runPDL = 1;
else
    handles.runPDL = 0;
end
guidata(hObject,handles);
function runPDL_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.runPDL);

function runPDG_Callback(hObject, ~, handles)
if get(hObject,'Value');
    handles.runPDG = 1;
else
    handles.runPDG = 0;
end
guidata(hObject,handles);
function runPDG_ButtonDownFcn(hObject, ~, handles)
set(hObject,'Enable', 'on');
uicontrol(handles.runPDL);

function saveProfile_KeyPressFcn(hObject, ~, handles)
function prjID_KeyPressFcn(hObject, ~, handles)
function sbjID_KeyPressFcn(hObject, ~, handles)
function sbjAge_KeyPressFcn(hObject, ~, handles)
function sbjLoc_KeyPressFcn(hObject, ~, handles)

function admin_Callback(hObject, ~, handles)
pass='VBDMAdmin';
while 1
    prompt={'Please enter the administrative password'};
    dlg_title = 'Administrative password';
    answer = inputdlg(prompt,dlg_title,1);
    if isempty(answer)
        return;
    elseif strcmp(pass,answer{1});
        break; 
    end
end
prompt = {'Experiment version',...
          'Timed stimuli',...
          'Give feedback',...
          'Debug',...
          'Number of trials'};
def    = {handles.expVersion,num2str(handles.timedStimulus),...
         num2str(handles.giveFeedback),num2str(handles.doDebug),...
         num2str(handles.nTrials)};
dlg_title = 'Administrative control';
answer = inputdlg(prompt,dlg_title,1,def);
if ~isempty(answer)
    handles.expVersion=answer{1};
    handles.timedStimulus=str2num(answer{2});
    handles.giveFeedback=str2num(answer{3});
    handles.doDebug=str2num(answer{4});
    handles.nTrials=str2num(answer{5});
end
guidata(hObject,handles);

function readMe_Callback(hObject, ~, handles)
msgbox({'This application runs selected tasks from the',...
        'Value-Based Decision-Making Battery, VBDM,',...
        'designed in SeSyN, TU Dresden.',...
        'In panel "I", on the left side, give general information',...'
        'about the subject and the way the tasks will run, i.e., with.',...
        'or whithout instructions, saving and payment. It is also possible ',...
        'to load these information from a text file which has been saved',...
        'previously by this application in a suitable format.',...
        'Further manuplations are accesible through the administrative',...
        'controls button which is password protected. You can decide if',...
        '  1. a stimulus is shown for a fixed amount of time or it waits',...
        '     till a response is given. ',...
        '  2. you want to give the feedback at the end of each trial.',...
        '  3. the battery runs in a debugging mode with only five trials.',...
        'Please give a value of "1" for a condition to be effective.',...
        'All these variables are stored under "genInfo" as a struct.',...
        'After providing general information and controls, the selected tasks',...
        'from panel "II" will run in a top-down order once "RUN" is pressed.',...
        'The results will be saved, if requested, in a directory called "data"',...
        'in the current working directory of this application. The variables',...
        'used for the layout and presentation of the task are not stored.',...
        '',...
        'Section of Systems Neuroscience','Department of Psychiatry and Psychotherapy',...
        'Faculty of Medicine Carl Gustav Carus','Technische Universität Dresden',...
        'Contact:',...
        '        Shakoor.Pooseh@tu-dresden.de'})

function clearAll_Callback(hObject, ~, handles)

set(handles.sexF,'Value',0,'Enable', 'on');
set(handles.sexM,'Value',0,'Enable', 'on');
handles.sex='';
set(handles.typeC,'Value',0,'Enable', 'on');
set(handles.typeP,'Value',0,'Enable', 'on');
handles.type='';
set(handles.sbjAge,'String','','Enable', 'on');
handles.age='';
set(handles.sbjSes,'String','','Enable', 'on');
handles.session='';
set(handles.sbjID,'String','','Enable', 'on');
handles.subjn='';
set(handles.prjID,'String','','Enable', 'on');
handles.ProjectID='';
guidata(hObject,handles);


function clearAll_ButtonDownFcn(hObject, eventdata, handles)
function loadProfile_ButtonDownFcn(hObject, eventdata, handles)
function saveProfile_ButtonDownFcn(hObject, eventdata, handles)


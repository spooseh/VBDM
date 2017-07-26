function abortExp(auxVars)

wd = auxVars.wd;
Screen('TextSize',wd,2*auxVars.txtSize);

Screen('Fillrect',wd,ones(1,3)*100);
text='Aborting experiment';        col=[200 30 0];
DrawFormattedText(wd,text,'center','center',col,60);
Screen('Flip',wd);       WaitSecs(1);

fprintf('                               \n')
fprintf(' ******************************\n')
fprintf(' **** Experiment aborted ******\n')
fprintf(' ******************************\n')
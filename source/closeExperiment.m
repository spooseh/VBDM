function closeExperiment
% CLOSEEXPERIMENT closes screen, returns priority to 0, starts the update process,
%                 and shows the cursor.

Priority(0);
Screen('CloseAll'); % close psychtoolbox, return screen control to the OS
ShowCursor; % show the mouse cursor again
if(~ismac && ~IsLinux)
    ShowHideWinTaskbarMex(1);
end
close all
% system('shutdown -l')
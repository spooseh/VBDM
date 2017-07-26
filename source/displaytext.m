function displaytext(txt,wd,wdw,wdh,col,waitTime,dontblank)

nrow = length(txt);
for k = 1:nrow
	[wt] = Screen(wd,'TextBounds',txt{k});
	xpos = wdw/2-wt(3)/2;
	ypos = wdh/2+2*(k-1-nrow/2)*wt(4);
	Screen('Drawtext',wd,txt{k},xpos,ypos,col);
end

if dontblank; Screen('flip', wd,[],1);
else         Screen('flip', wd);
end

if ~isempty(waitTime)
    WaitSecs(waitTime);
end

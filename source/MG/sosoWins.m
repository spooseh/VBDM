function win = sosoWins(numWins,numLoss)
if numWins - 3 == numLoss
    win = -1;
elseif numLoss - 3 == numWins
    win = 1;
else
    if rand <= 0.5
        win = 1;
    else
        win = -1;
    end
end
function aborted = instructAll_DE(auxVars,N)

wd       = auxVars.wd;
txtCol = auxVars.txtCol;
i = 0; 
func{1} = [];
yposm='center';
i = i+1; 
	ypos{i} = yposm;
    tx{i} = ['Die Aufgabe kann nun beginnen. Sie k�nnen mit der '...
             'rechten und linken Pfeiltaste vor- und zur�ck bl�ttern.'];
    func{i} = 'getRarrow';
i = i+1; 
	ypos{i} = yposm;
	tx{i} = ['Sie f�hren ' num2str(N) ' Test(s) zu Ihrem '...
             'Entscheidungsverhalten durch.'];     
    func{i} = 'getLRarrow';    

if length(func) < i;    func{i} = [];    end
Pages = i;
page = 1;
while 1
	DrawFormattedText(wd,tx{page},'center',ypos{page},txtCol,55,[],[],1.8);
    [page,aborted] = eval([func{page} '(auxVars,page);']); % must contain 'getLRarrow' command 
    if aborted;    return;    end
	if page > Pages; break;end
end

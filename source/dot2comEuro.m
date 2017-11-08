function txt = dot2comEuro(rew)
% Separates the cents with a comma
txt = sprintf('%d,%02d €',floor(rew),int64(mod(rew*100,100)));
txt = double(txt);

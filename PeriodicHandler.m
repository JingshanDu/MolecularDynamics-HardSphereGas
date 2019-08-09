function out = PeriodicHandler(pos, len)
%PERIODICHANDLER Handles the Periodic Boundary Conditions
%   Detailed explanation goes here

for i=1:size(pos,1)
    for j=1:3
        if pos(i,j)<0
            pos(i,j) = pos(i,j)+len;
        elseif pos(i,j)>len
            pos(i,j) = pos(i,j)-len;
        end
    end
end
out = pos;

end


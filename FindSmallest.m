function [num, dt] = FindSmallest( input )
%FINDSMALLEST Find the smallest time span of collision
sml = Inf;
smlnm = Inf;
for ii=1:size(input)
    if input(ii) ~=0
        if input(ii)<sml
            sml = input(ii);
            smlnm = ii;
        end
    end
    dt = sml;
    num = smlnm;
end
x=1;


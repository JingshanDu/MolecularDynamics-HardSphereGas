function out = CalcCollision( i, j)
%CALCCOLLISION Calculate if collision can happen and its time
out = 0;
if i==j 
    return
end
global Position Velocity diameter;
r12 = Position(i,:)-Position(j,:);  % relative variables
v12 = Velocity(i,:)-Velocity(j,:);
tt = (-dot(r12,v12)-abs(norm(v12)*diameter))/norm(v12)^2;
if tt >= 0
    out = tt;
end
% % check if collision happens
% if dot(r12,v12)<0
%     if subspace(r12,v12) <= acos(norm(v12)/norm(r12))
%         % calculate time
%         CollideMap1(i,j) = (-dot(r12,v12)-abs(norm(v12)*diameter))/norm(v12)^2;
%     end
% end


end


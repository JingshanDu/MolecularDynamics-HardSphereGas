function c = dotr( a,b )
%DOTR Summary of this function goes here
%   Detailed explanation goes here
if any(size(a)~=size(b)),
   error('MATLAB:dot:InputSizeMismatch', 'A and B must be same size.');
end

sz = size(a,2);
c = zeros(1,sz);
parfor i=1:sz
    if isnan(a(i)) || isnan(b(i))
        c(i)=0;
    else
        c(i) = a(i)*b(i);
    end
end

end


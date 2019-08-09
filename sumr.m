function S = sumr( A )
%SUMR Revision of Sum()
%   ignore NAN (regarded as zero)
S = 0;
parfor i=1:size(A)
    if ~isnan(A(i));
        S = S + A(i);
    end
end

end


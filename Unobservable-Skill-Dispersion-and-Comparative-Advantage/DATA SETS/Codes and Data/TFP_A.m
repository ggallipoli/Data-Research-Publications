function A=TFP_A(lambda,nscore,W,gamma) 

N = 19;            %number of countries%
M = 63;            %number of industries%

AA = ones(N,M);
for i = 1:N
    temp1 = nscore(i,:);
    temp2 = W(i,:);
    a=temp1(isfinite(temp1));
    w=temp2(isfinite(temp1)); 
    for r = 1:M
        AA(i,r) = ((1/sum(w))*sum(w.*(a.^lambda(r))))^(gamma/lambda(r));
    end
end

% the data fo Chile needs to be removed
A = ones(N-1,M); 
A(1:3,:) = AA(1:3,:);
A(4:18,:) = AA(5:19,:);



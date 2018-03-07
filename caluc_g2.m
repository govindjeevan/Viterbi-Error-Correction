% Calculate the XOR of the state values of the 10 flip flops for g2 polynomial

function g2=caluc_g2(states)
g2=mod(sum(states([3 4 5 7 8 10])),2);
end

%{
function g2=caluc_g2(states)
g2=mod(sum(states([1 2 4])),2);
end
%}
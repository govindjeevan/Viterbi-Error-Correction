% Converts a binary sequence to a decimal number
function y=decify(x)
    sum =0;
    for i=1:length(x)
        sum=sum+x(i)*2^(length(x)-i);
    end
    y=sum;
end
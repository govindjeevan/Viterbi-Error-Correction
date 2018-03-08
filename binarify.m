% Converts a decimal number to a binary sequence in an array

 function bin=binarify(dec_nr)
    bin=zeros(1,3);
    i = 1;
    q = floor(dec_nr/2);
    r = rem(dec_nr, 2);
    bin(i) = r(i);
    while 2 <= q
        dec_nr = q;
        i = i + 1;
        q = floor(dec_nr/2);
        r = rem(dec_nr, 2);
        bin(i) = r;
    end
    bin(i + 1) = q;
    bin = fliplr(bin);
    if size(bin)==2
        bin=bin(1,end+1);
        bin=circshift(bin,1);
    end
end

 
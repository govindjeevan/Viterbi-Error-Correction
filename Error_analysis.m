length = 2

for i=0:2.^length-1
    dataword = binary(i);
    
    codeword = encoder(dataword);
    for i = 1:size(codeword,2)
    
    end
end


function output=encoder(input)
    states=zeros(1,4);
    index=1;
    output=zeros(1,2);
    while(sum(states)>0 || size(input,2)>0)

        states = circshift(states,1);   
        if size(input,2)
            states(1)=input(1);    
        else
            states(1)=0;
        end

        input=input(2:end);

        g1=mod(sum(states([1 2 3 4])),2);
        g2=mod(sum(states([1 2 4])),2);


        output(index)=g1;
        output(index+1)=g2;

        index=index+2;

    end

end

function bin=binary(dec_nr)
bin=zeros(1,1);
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

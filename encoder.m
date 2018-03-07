
%=======> CONVOLUTIONAL ENCODER FUNCTION <============
function encoded=encoder(input)
    global n;
    states=zeros(1,n);
    index=1;
   	encoded=zeros(1,2);
    while(sum(states)>0 || size(input,2)>0)
        states = circshift(states,1);   
        if size(input,2)
            states(1)=input(1);    
        else
            states(1)=0;
        end
        input=input(2:end);
        g1=caluc_g1(states);
        g2=caluc_g2(states);
        encoded(index)=g1;
        encoded(index+1)=g2;
        index=index+2;
    end
end

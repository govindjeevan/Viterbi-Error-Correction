
%=======> CONVOLUTIONAL ENCODER FUNCTION <============
function encoded=encoder(input)
    global n;
    states=zeros(1,n);  % INITIALIZE THE FLIP FLOPS WITH n STATES
    index=1;
   	encoded=zeros(1,2);
    while(sum(states)>0 || size(input,2)>0)
        states = circshift(states,1);   % SHIFT THE FLIP FLOP VALUES TO THE RIGHT BY 1 BIT
        if size(input,2)
            states(1)=input(1);    % IF THE INPUT IS NOT FINISHED, INSERT NEXT INPUT BIT INTO THE FLIP FLOPS
        else
            states(1)=0;    % IF INPUT IS FINISHED, PURGE THE FLIP FLOPS WITH ZEROS
        end
        input=input(2:end); % REDUCE INPUT SIZE BY REMOVING THE INSERTED BIT
        g1=caluc_g1(states);    % CALCULATE XOR FOR g1 POLYNOMIAL
        g2=caluc_g2(states);    % CALCULATE XOR FOR g2 POLYNOMIAL
        encoded(index)=g1;      % APPENDING THE XOR VALUES TO THE CODE WORD
        encoded(index+1)=g2;
        index=index+2;
    end
end

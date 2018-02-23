
input=[1 0 1 0 1 0 1 1 1 0 ];


states=zeros(1,10);

index=1;
output=zeros(1,2);
while(sum(states)>0 || size(input,2)>0)
    
    states = circshift(states,1);   
    if size(input,2)
        states(1)=input(end);    
    else
        states(1)=0;
    end
    input
    states
    
    input=input(1:end-1);

    g1=mod(sum(states([5 6 8 9 10])),2)
    g2=mod(sum(states([3 4 5 7 8 10])),2)

    
    output(index)=g1;
    output(index+1)=g2;
    
    index=index+2;
    
end


input=[1 0 1 1];
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
    input
    states
    
    input=input(2:end);

    g1=mod(sum(states([1 2 3 4])),2)
    g2=mod(sum(states([1 2 4])),2)

    
    output(index)=g1;
    output(index+1)=g2;
    
    index=index+2;
    
end


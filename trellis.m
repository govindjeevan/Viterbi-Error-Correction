
import "q.m"

enqueue(1,2)

i=0;j=0;

% states=zeros(1,3);



global trellisdiag;
trellisdiag=zeros(8,8,2);

for i=1:8
    for j=1:8
    
    trellisdiag(i,j,1)=-1;
    trellisdiag(i,j,2)=-1;
    end
end

state=0;
time=0;

trellisdiag=path(state,time,trellisdiag)


while time <8
    
    x=state;
    for i=0:2^time
        
    state=trellisdiag(state+1,time+1,rem(i,2)+1);
    
    trellisdiag=path(state,time,trellisdiag);

    state=x; 
    end
    
time=time+1;
end



function y=path(state,time,trellisdiag)

    if time == 8
        return
    end
    
    y=trellisdiag;
    disp("Time: "+ time);
    disp("State "+state);
    
    
    
    [zero,one]=nextState(state);
    
    
    y(state+1,time+1)=zero;
    y(state+1,time+1,2)=one;
  
    % y=path(one+1,time+1,y);
 
    
    
    
    %nextState(zero)
    %nextState(one)
    
    %trellisdiag(zero+1,time+2,1)=path(zero,time+1);
    %trellisdiag(one+1,time+2,2)=path(one,time+1);
    
end

function [zero,one] = nextState(i)
 states=binarify(i);
 states = circshift(states,1);
 states(1)=0;
 zero=decify(states);
 states(1)=1;
 one=decify(states);
end




    

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
 




function y=decify(x)
sum =0;

for i=1:length(x)
    sum=sum+x(i)*2^(length(x)-i);
end
 y=sum;
end

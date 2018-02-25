
i=0;j=0;

% states=zeros(1,3);



global queue;
queue  = zeros( 50, 2 );
global firstq;
global lastq;
firstq= 1;
lastq  = 1;

global td;
td=zeros(8,8,2);

for i=1:8
    for j=1:8
    
    td(i,j,1)=-1;
    td(i,j,2)=-1;
    end
end

state=0;
time=0;

enqueue(state,time);


while notEmpty()
    
   [state,time]=dequeue();
   
   td=path(state,time,td);
   enqueue(td(state+1,time+1,1),time+1);
   enqueue(td(state+1,time+1,2),time+1);
   

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
 


function x=notEmpty()
global lastq;
global queue;
global firstq;

if firstq==lastq
    x=0;
else x=1;
end

end
function q= enqueue(state,time)
global lastq;
global queue;
queue(lastq,1)=state;
queue(lastq,2)=time;
lastq=lastq+1;
q=queue;
end

function [state,time]=dequeue()
global firstq;
global queue;
state=queue(firstq,1);
time=queue(firstq,2);
firstq=firstq+1;
end



function y=decify(x)
sum =0;

for i=1:length(x)
    sum=sum+x(i)*2^(length(x)-i);
end
 y=sum;
end

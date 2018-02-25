
i=0;j=0;

global queue;
queue  = zeros( 50, 2 );
global firstq;
global lastq;
firstq= 1;
lastq  = 1;

global td;
td=zeros(8,8,4);
for i=1:8
    for j=1:8
    td(i,j,1)=-1;
    td(i,j,2)=-1;
    td(i,j,3)=-1;
    td(i,j,4)=-1;
    end
end

state=0;
time=0;

enqueue(state,time);


while notEmpty()
    
   [state,time]=dequeue();
   
   td=path(state,time,td);
   if time+1 <8
   enqueue(td(state+1,time+1,1),time+1);
   enqueue(td(state+1,time+1,2),time+1);
   end

end


% TRELLIS DIAGRAM FOR THE CONVOLUTIONAL CODE IS NOW AVAILABLE
%------------------------------------------------------------



incoming=[0 1 1 1 0 1 1 1 0 1 0 1 1 1];



input=[1 0 1 1];

global encoded;
encoded=encoder(input);

encoded(3)=0;




% VITERBI DECODER

time=0;
global pathmetric;
pathmetric=repmat(10000,size(encoded,2)/2,size(encoded,2)/2+1);
state=0;

%Purging the queue for reuse
queue  = zeros( 50, 2 );
firstq= 1;
lastq  = 1;

enqueue(state,time);

global flag;
flag=repmat(-1,size(encoded,2)/2,size(encoded,2)/2);


    
    while notEmpty()
        
    
    [state,time]=dequeue();
    if time> size(encoded,2)/2
        return;
    end
    
    received=[encoded(2*time+1),encoded(2*time+2)];
    
    disp(state +" "+ time); 
    
    value=binarify(td(state+1,time+1,3));
    value=value(2:end);
    
    disp("Sequence Value: ");
    disp(received);
    
    
    disp("Trellis (Path Zero)");
    disp(value);
    
    if time==0
        zero=hd(received,value)
    else
        zero=hd(received,value)+pathmetric(state+1,time+1)
    end
    metricupdate(state,time,zero,0)
    
    
    value=binarify(td(state+1,time+1,4));
    value=value(2:end);
    
    disp("Trellis (Path One): ");
    disp(value);
    if time==0
        one= hd(received,value)
    else
        one= hd(received,value)+pathmetric(state+1,time+1)
    end
    metricupdate(state,time,one,1)
    
    
    
    disp(" ");
    end
    

  %Minimum Path Metric
    x=(size(encoded,2)/2);
    [min_v,min_i]=min(pathmetric(:,x));
    
    correctpath=[min_i];

    while x>1
        min_i=correctpath(1);
        x=x-1;
        correctpath=[flag(min_i+1,x),correctpath]
    end
    
 
    
    
    
    
    
    
function pm=metricupdate(state, time, new_metric,path)
    
    global pathmetric;
    global td;
    global flag;
    global encoded;
    next=td(state+1,time+1,path+1)
    
    if pathmetric(next+1,time+2) > new_metric
        pathmetric(next+1,time+2)=new_metric;
    if time+2 > size(encoded,2)/2
        return
    end
        if flag(next+1,time+2)==-1
            enqueue(next,time+1);
            disp("Enqueued " + next+" , " + (time+1));
        end
        flag(next+1,time+2)=state;
    end
 
    pm=pathmetric;
    
end 


% 2-bit Hamming Distance Calculator
function z=hd(x,y)
z=0;
if x(1)~=y(1)
    z=z+1;
end
if x(2)~= y(2)
    z=z+1;
end
end

function encoded=encoder(input)
    states=zeros(1,4);
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

        g1=mod(sum(states([1 2 3 4])),2);
        g2=mod(sum(states([1 2 4])),2);


        encoded(index)=g1;
        encoded(index+1)=g2;

        index=index+2;

    end

end




function y=path(state,time,trellisdiag)

    y=trellisdiag;
    [zero,one]=nextState(state);
    [zero_o,one_o]=output(state);
    y(state+1,time+1,1)=zero;
    y(state+1,time+1,3)=zero_o;
    y(state+1,time+1,2)=one;
    y(state+1,time+1,4)=one_o;
    
end

function [zero,one] = output(i)
 states=binarify(i);
 states = [0, states];
 zero=[mod(sum(states([1 2 3 4])),2),mod(sum(states([1 2 4])),2)];
 zero=decify(zero);
 
 states(1)=1;
 one=[mod(sum(states([1 2 3 4])),2),mod(sum(states([1 2 4])),2)];
 one=decify(one);
 
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
    global firstq;
    if firstq==lastq
        x=0;
    else
        x=1;
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

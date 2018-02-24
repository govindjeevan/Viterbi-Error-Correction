global queue;
queue  = zeros( 50, 2 );
global firstq;
global lastq;
firstq= 1;
lastq  = 1;


function x=isEmpty()
global lastq;
global queue;
global firstq;

if firstq==lastq
    x=1;
else x=0;
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
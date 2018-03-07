
% ===========> VITERBI DECODER <========================================
% INITIALIZES A 2-D PATHMETRIC ARRAY
% THE LEFT TO RIGHT TRAVERSAL OF THE PATHMETRIC ARRAY DENOTES THE HISTORY
% OF DECODING

% LAST COLUMN OF PATH METRIC ARRAY SHOWS THE FINAL PATH METRIC AFTER
% COMPLETE TRAVERSAL

function correctpath=viterbi(encoded)

global pathmetric;
global s;
global maxtime;
global td;
global indexerror;
global detect;
global flag;

pathmetric=repmat(10000,s,maxtime); %INITIALIZE THE PATHMETRIC ARRAY
flag=repmat(-1,s,maxtime);  %INITIALIZE THE FLAG ARRAY

initializeQ();  %PURGE THE QUEUE
time=0;state=0;
enqueue(state,time);    %ENQUEUE THE FIRST STATE AND TIME

    while notEmpty()    % WHILE THERE ARE STILL STATES WAITING IN THE QUEUE
        [state,time]=dequeue(); % TAKE THE NEXT STATE IN THE QUEUE
        if time >= maxtime
            return;
        end
        received=[encoded(2*time+1),encoded(2*time+2)]; % CONSIDER THE NEXT TWO SIMULTANEOUS BITS OF THE CODEWORD RECEIVED BY VITERBI
        value=de2bi(td(state+1,time+1,3), 'left-msb'); % CONVERT THE 3 BIT STATE TO DECIMAL
        if size(value,2) == 1
            value=[0,value];
        end
        if hd(received,value)~=0 
            detect=1;   % CHANGE DETECT FLAG AS ONE IF THE OUTPUT DOESN'T MATCH THE TTWO RECEIVED BITS
        end
        if time==0
            zero=hd(received,value); % THE PATHMETRIC OF THE FIRST COLUMN IS JUST THE DIFFERENCE
        else
            zero=hd(received,value)+pathmetric(state+1,time+1); % THE PATHMETRIC OF THE OTHER COLUMNS IS THE DIFFERENCE PLUS PARENT'S PATHMETRIC
        end
        metricupdate(state,time,zero,0); % CALLS HELPER FUNCTION TO UPDATE THE NEW PATHMETRIC TO ZERO CHILD
        value=de2bi(td(state+1,time+1,4), 'left-msb');
        if size(value,2) == 1
            value=[0,value];
        end
        if hd(received,value)~=0 
            detect=1;   % CHANGE DETECT FLAG AS ONE IF THE OUTPUT DOESN'T MATCH THE TTWO RECEIVED BITS
        else
            detect=0;   % CHANGE DETECT FLAG AS ZERO IF THE OUTPUT MATCHES THE TTWO RECEIVED BITS
        end
        if time==0
            one= hd(received,value);  % THE PATHMETRIC OF THE FIRST COLUMN IS JUST THE DIFFERENCE
        else
            one= hd(received,value)+pathmetric(state+1,time+1); % THE PATHMETRIC OF THE OTHER COLUMNS IS THE DIFFERENCE PLUS PARENT'S PATHMETRIC
        end
        metricupdate(state,time,one,1); % CALLS HELPER FUNCTION TO UPDATE THE NEW PATHMETRIC TO ONE CHILD
    end
    x=(size(encoded,2)/2);  % THE FINAL COLUMN IS X
    [min_v,min_i]=min(pathmetric(:,x)); % THE VALUE AND INDEX OF MINIMUM PATH METRIC FROM THE FINAL COLUMN IS SELECTED
    correctpath=[min_i,min_i-1];    % APPEND THE INDICES INTO THE CORRECT PATH BEING CONSTRUCTED
    while x>1   % WHILE THE PATH METRIC HASN'T REACHED IT'S FIRST STATE
        min_i=correctpath(1);
        if min_i+1 > s
            disp("error"+ min_i);
            indexerror=indexerror+1;
            return
        end 
        x=x-1;
        correctpath=[flag(min_i+1,x),correctpath];  % APPEND THE INDICES OF THE PARENT OF THE LAST STATE IN CORRRECT PATH INTO THE CORRECT PATH BEING CONSTRUCTED
    end    
end
  
% HELPER FUNCTION FOR UPDATING PATH METRIC MATRIX IN VITERBI ALGORITHM
    
function pm=metricupdate(state, time, new_metric,path)
    
    global pathmetric;
    global td;
    global flag;
    global encoded;
    next=td(state+1,time+1,path+1);
    
    if pathmetric(next+1,time+2) > new_metric
        pathmetric(next+1,time+2)=new_metric;
    if time+2 > size(encoded,2)/2
        return
    end
        if flag(next+1,time+2)==-1
            enqueue(next,time+1);
            
        end
        flag(next+1,time+2)=state;
    end
 
    pm=pathmetric;
    
end 
    

    
  
    % ==============> 2-bit Hamming Distance Calculator <==========
function z=hd(x,y)
z=0;
if x(1)~=y(1)
    z=z+1;
end
if x(2)~= y(2)
    z=z+1;
end
end
    



%=============================================================================================



%==============> FUNCTIONS TO INITIALIZE A QUEUE DATA STRUCTURE <=================
%---------------- IMPLEMENTED USING GLOBAL ARRAYS --------------------------------
function q=initializeQ()
global firstq;
global queue;
global lastq;
queue  = zeros( 100, 2 );
firstq= 1;
lastq  = 1;
q=queue;
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


 % CHECKS IF THE QUEUE IS EMPTY
function x=notEmpty()
    global lastq;
    global firstq;
    if firstq==lastq
        x=0;
    else
        x=1;
    end
end
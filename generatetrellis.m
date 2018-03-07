

%==============> FUNCTIONS THAT GENERATES TRELLIS DIAGRAM <==========================
%--------------TRELLIS_FUNCTIONS
%------------- USES A GRAPH TRAVERSAL ALGORITHM TO TRANVERSE AND ASSIGN VALUES TO EACH POINT OF THE DIAGRAM--------
function td=generatetrellis(td)
    
    global s;
    global maxtime;
    
    state=0;
    time=0;
    initializeQ();
    td=zeros(s,maxtime,4);
    
    disp("Generating Trellis Diagram with "+s+" states");
    for i=1:s
        for j=1:maxtime
        td(i,j,1)=-1;
        td(i,j,2)=-1;
        td(i,j,3)=-1;
        td(i,j,4)=-1;
        end
    end
    enqueue(state,time);
    while notEmpty()
       [state,time]=dequeue();
       td=path(state,time,td);
       if time+1 < maxtime
       enqueue(td(state+1,time+1,1),time+1);
       enqueue(td(state+1,time+1,2),time+1);
       end
    end
end


% UPDATER FUCNTION FOR THE TRELLIS DIAGRAM
function y=path(state,time,trellisdiag)
    time;
    state;
    y=trellisdiag;
    [zero,one]=nextState(state);
    [zero_o,one_o]=output(state);
    y(state+1,time+1,1)=zero;
    y(state+1,time+1,3)=zero_o;
    y(state+1,time+1,2)=one;
    y(state+1,time+1,4)=one_o;
    
end

% DETERMINES THE OUTPUT OF A STATE FOR 0 AND 1 INPUT
function [zero,one] = output(i)
     global n;
     states=de2bi(i,'left-msb');
     extra=n-size(states,2);
     extraO=zeros(1,extra);
     states = [extraO, states];
     zero=[caluc_g1(states),caluc_g2(states)];
     zero=bi2de(zero,'left-msb');
     states(1)=1;
     one=[caluc_g1(states),caluc_g2(states)];
     one=bi2de(one,'left-msb');
end


% DETERMINES THE NEXT STATE FOR 0 AND 1 INPUT
function [zero,one] = nextState(i)
     global n;
     states=de2bi(i,'left-msb');
     extra=n-1-size(states,2);
     extraO=zeros(1,extra);
     states = [extraO, states];
     states = circshift(states,1);
     states(1)=0;
     zero=bi2de(states,'left-msb');
     states(1)=1;
     one=bi2de(states,'left-msb');
end





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
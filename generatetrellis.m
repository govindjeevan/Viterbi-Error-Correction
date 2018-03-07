

%==============> FUNCTIONS THAT GENERATES TRELLIS DIAGRAM <==========================
%--------------TRELLIS_FUNCTIONS
%------------- USES A GRAPH TRAVERSAL ALGORITHM TO TRANVERSE AND ASSIGN VALUES TO EACH POINT OF THE DIAGRAM--------
function td=generatetrellis(td)
    % GETTING THE VARIABLES INITIALIZED IN THE GLOBAL SPACE
    global s;
    global maxtime;
    
    state=0;
    time=0;
    initializeQ();  % INITIALIZE THE QUEUE TO TRAVERSE THE 2D TRELLIS DIAGRAM PLANE
    td=zeros(s,maxtime,4);  % INITIALIZE 3D TRELLIS DIAGRAM WITH 4 FEATURES TO BE STORED
    
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
    while notEmpty()    % WHILE THERE ARE STATES LEFT IN THE QUEUE TO TRAVERSE
       [state,time]=dequeue(); % DEQUEING
       td=path(state,time,td);
       if time+1 < maxtime
       enqueue(td(state+1,time+1,1),time+1);    % ENQUEUE BOTH THE CHILD STATES OF THE CURRENT STATE TO VISIT LATER
       enqueue(td(state+1,time+1,2),time+1);
       end
    end
end


% UPDATER FUCNTION FOR THE TRELLIS DIAGRAM
function y=path(state,time,trellisdiag)
    time;
    state;
    y=trellisdiag;                  % RETURN ITEM IS THE TRELLIS DIAGRAM
    % MAKING CHANGES TO THE THE TRELLIS TO BE RETURNED
    [zero,one]=nextState(state);    % CALCULATE NEXT STATE FOR ZERO AND ONE INPUT
    [zero_o,one_o]=output(state);   % CALCULATE OUTPUT FOR ZERO AND ONE INPUT
    y(state+1,time+1,1)=zero;       % NEXT STATE FOR ZERO INPUT
    y(state+1,time+1,3)=zero_o;     % OUTPUT FOR ZERO INPUT
    y(state+1,time+1,2)=one;        % NEXT STATE FOR ONE INPUT
    y(state+1,time+1,4)=one_o;      % OUTPUT FOR ONE INPUT
    
end

% DETERMINES THE OUTPUT OF A STATE FOR 0 AND 1 INPUT
function [zero,one] = output(i)
     global n;
     states=de2bi(i,'left-msb');    % CONVERT THE CURRENT STATE TO ITS FLIP FLOP STATE FORM
     extra=n-size(states,2);        % IF THE NO OF BITS IS LESS THAN THE NUMBER OF FLIP FLOPS OF THE CONVOLUTIONAL ENCODER APPEND ZERO STATES TO ITS LEFT
     extraO=zeros(1,extra);
     states = [extraO, states];     % FOR ZERO INPUT
     zero=[caluc_g1(states),caluc_g2(states)];
     zero=bi2de(zero,'left-msb');
     states(1)=1;                   % FOR ONE INPUT
     one=[caluc_g1(states),caluc_g2(states)];
     one=bi2de(one,'left-msb');
end


% DETERMINES THE NEXT STATE FOR 0 AND 1 INPUT
function [zero,one] = nextState(i)
     global n;
     states=de2bi(i,'left-msb');     % CONVERT THE CURRENT STATE TO ITS FLIP FLOP STATE FORM
     extra=n-1-size(states,2);       % IF THE NO OF BITS IS LESS THAN THE NUMBER OF FLIP FLOPS OF THE CONVOLUTIONAL ENCODER APPEND ZERO STATES TO ITS LEFT
     extraO=zeros(1,extra);
     states = [extraO, states];
     states = circshift(states,1);  % SHIFT TO THE RIGHT BY ONE BIT
     states(1)=0;                   % INPUT ZERO
     zero=bi2de(states,'left-msb'); % DECIMAL FORM OF THE NEXT STATE
     states(1)=1;                   % INPUT ONE
     one=bi2de(states,'left-msb');  % DECIMAL FORM OF THE NEXT STATE
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

global queue;
global td;
global firstq;
global lastq;
global encoded;
global n;
global s;
global maxtime;
global flag;
global pathmetric;

maxtime=8;
n=4;
s=2^(n-1);


%INITIALIZING A QUEUE
initializeQ();

%%GIVE THE INPUT HERE

input=[1 0 1 0 0 1 0 0 1];
encoded=encoder(input);
maxtime=size(encoded,2)/2+1;
td=generatetrellis(td);
initializeQ();


% TRELLIS DIAGRAM FOR THE CONVOLUTIONAL CODE IS NOW AVAILABLE
%------------------------------------------------------------


total=zeros(4,1);
count=zeros(4,1);


for k=1:4
    for i=1:250
    errorcode=encoded;
    y = randsample(size(encoded,2),k)
    errorcode(y)=~errorcode(y);
    
    total(k)=total(k)+1;
    % CORRECTING ERROR CODE TO GET CODEWORD USING VITERBI
    correctpath=viterbi(errorcode);

    corrected=corrector(correctpath);

    if verify(corrected)~=1
        count(k,1)=count(k,1)+1;
    end
    end
end

count
total

errorrate=sum(count)/sum(total)*100
percent=(total-count)/total*100;
percent=percent(:,1)
k=[1:4];
figure
graph=plot(percent,'b --o')
title('Convolutional Encoder/Decoder Viterbi Plot I')
xlabel('Error Bits')
ylabel('Success %')
ylim([0 100])

figure
graph=plot(k,total,'b --o')
title('Convolutional Encoder/Decoder Viterbi Plot II')
xlabel('Error Bits')
ylabel('Success %')
ylim([0 100])

errorrate


%=======> CONVOLUTIONAL ENCODER FUNCTION <============
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

        g1=caluc_g1(states);
        g2=caluc_g2(states);


        encoded(index)=g1;
        encoded(index+1)=g2;

        index=index+2;

    end

end




%==============> FUNCTIONS THAT GENERATES TRELLIS DIAGRAM <==========================
%--------------TRELLIS_FUNCTIONS
%------------- USES A GRAPH TRAVERSAL ALGORITHM TO TRANVERSE AND ASSIGN VALUES TO EACH POINT OF THE DIAGRAM--------
function td=generatetrellis(td)
state=0;
time=0;
global s;
global maxtime;
td=zeros(s,maxtime,4);
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



function g1=caluc_g1(states)
g1=mod(sum(states([1 2 3 4])),2);
end

function g2=caluc_g2(states)
g2=mod(sum(states([1 2 4])),2);
end

%{

function g1=caluc_g1(states)
g1=mod(sum(states([5 6 8 9 10])),2);
end

function g2=caluc_g2(states)
g2=mod(sum(states([3 4 5 7 8 10])),2);
end
%}








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
pathmetric=repmat(10000,s,maxtime);
global td;

time=0;state=0;
enqueue(state,time);

global flag;
flag=repmat(-1,s,maxtime);

    while notEmpty()
        
    
    [state,time]=dequeue();
    if time >= maxtime
        return;
    end
    
    received=[encoded(2*time+1),encoded(2*time+2)];
    
    
    value=de2bi(td(state+1,time+1,3), 'left-msb');
    if size(value,2) == 1
        value=[0,value];
    end
    
    if time==0
        zero=hd(received,value);
    else
        zero=hd(received,value)+pathmetric(state+1,time+1);
    end
    metricupdate(state,time,zero,0);
    
    
    value=de2bi(td(state+1,time+1,4), 'left-msb');
    if size(value,2) == 1
        value=[0,value];
    end
    

    if time==0
        one= hd(received,value);
    else
        one= hd(received,value)+pathmetric(state+1,time+1);
    end
    metricupdate(state,time,one,1);
 
    end
    

  % Minimum Path Metric is selected
    x=(size(encoded,2)/2);
    [min_v,min_i]=min(pathmetric(:,x));
    
    correctpath=[min_i,min_i-1];

    while x>1
        min_i=correctpath(1)
        x=x-1
        if min_i+1 > s
            return
        end 
        correctpath=[flag(min_i+1,x),correctpath]
    end
   
    
end


  
% HELPER FUNCTION FOR UPDATING METRIX MATRIX IN VITERBI ALGORITHM
    
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
    
    % ============> CORRECTION FUNCTION <=============================
    % FUNCTION TO DETERMININE THE CORRECTED SEQUENCE BASED ON THE CORRECT
    % PATH GENERATED BY VITERBI ALGORITHM
    
    function corrected=corrector(correctpath)
    global td;
    k=2;
    time=0;
    corrected=[0,0];
    while k< size(correctpath,2)+1
        i=correctpath(k);
        if k == size(correctpath,2)
        
            o=binarify(td(i+1,time+1,3));
            o=o(2:end);
            corrected=[corrected,o];
            corrected=corrected(3:end);
            return
        end
        
        if td(i+1,time+1,1)==correctpath(k+1)
      
           o=binarify(td(i+1,time+1,3));
           o=o(2:end);
           corrected=[corrected,o];
        end
        
        if td(i+1,time+1,2)==correctpath(k+1)
     
            o=binarify(td(i+1,time+1,4));
            o=o(2:end);
            corrected=[corrected,o];
        end 
        k=k+1;
        time=time+1;
        
    end
   
    end
    
  
    
    

% ===========> VERIFICATION BY COMPARING THE CORRECTED CODEWORD TO THE CODE WORD THAT WAS INITIALLY ENCODED
function success = verify(corrected)
k=1;
global encoded;
success=1;

if size(encoded,2) ~= size(corrected,2)
    success=0;
    return;
end
while k < size(encoded,2)
    if corrected(k)~=encoded(k)
        success=0;
    end
    k=k+1;
end

%if success==1
    %disp("Correction Successful"); 
%else
    %disp("Correction Unsuccessful");
%end

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










% TYPE CONVERSION FUNCTIONS
%=============================================================================================
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
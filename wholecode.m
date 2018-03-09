%========================================>Convolutional Coding for using Viterbi decoding and path metric<=================================================
% INITIALISING THE GLOBAL VARIABLES
global queue;       % VARIABLE FOR THE QUEUE
global td;          % VARIABLE FOR THE TRELLIS DIAGRAM
global firstq;      % POINTS TO THE STARTING OF THE QUEUE
global lastq;       % POINTS TO THE ENDING OF THE QUEUE
global encoded;     % STORES THE ENCODED SEQUENCE
global n;           % LENGTH OF THE DATAWORD BITS 
global s;           % ROWS IN TRELLIS DIAGRAM
global maxtime;     % VARIABLE THAT TAKED INTO ACCOUNT THE MAXIMUM TRAVERSAL IN THE TRELLIS DIAGRAM
global flag;        % FOR CREATES COPIES 
global pathmetric;  % FOR THR PATHMETRIC MATRIX


n=10;   % NUMBER OF FLIP FLOPS
s=2^(n-1);  % NUMBER OF STATES IN TRELLIS DIAGRAM
maxerror=3; % MAXIMUM NUMBER OF ERROR BITS TO BE INTRODUCED


    %INITIALIZING THE ERROR CORRECTION/DETECTION COUNTS TO ZERO
total=zeros(maxerror,1);
count=zeros(maxerror,1);
detected=zeros(maxerror,1);
detect=0;
indexerror=0;


%=============================>>>>>>>>  GIVE THE INPUT HERE
%<<<<<<<<<==========================================================
input=[1 0];

encoded=encoder(input); %ENCODING THE INPUT USING THE GENERATAOR FUNCTIONS

%CALCULATING THE EXTENT OF TRELLIS GRAPH REQUIRED TO DECODE THE CODEWORD
maxtime=size(encoded,2)/2+1;

%GENERATING THE TRELLIS DIAGRAM FOR THE GIVEN GENERATOR POLYNOMIALS
td=generatetrellis(td);


%------------------------------------------------------------
% TRELLIS DIAGRAM FOR THE CONVOLUTIONAL CODE IS NOW AVAILABLE
%------------------------------------------------------------



disp("Generating Errors and Viterbi Correction ");
disp(encoded);


% INTRODUCING ALL POSSIBLE ERRORS IN THE CODE WORD
% NUMBER OF ERROR BITS VARY FROM 1 TO maxerror
for k=1:maxerror
    
    indexarray=[1:size(encoded,2)];
    C=combnk(indexarray,k);
    for i=1:size(C,1)
    errorcode=encoded;
    C(i,:)
    errorcode(C(i,:))=~errorcode(C(i,:));
    total(k)=total(k)+1;
    
    % CORRECTING ERROR CODE TO GET CODEWORD USING VITERBI
    correctpath=viterbi(errorcode);
    if detect==1
        detected(k,1)=detected(k,1)+1;
        detect=0;
    end
    %USING THE PATH IDENTIFIED BY VITERBI ALGORITHM TO RECONSTRUCT THE
    %CODEWORD
    corrected=corrector(correctpath);
    if verify(corrected)~=1
        %INCREASING THE COUNT FOR EVERY UNSUCCESSFUL CORRECTION
        count(k,1)=count(k,1)+1;
    end
    end
end

count
total


%{
% INTRODUCING RANDOM ERROS WITH A SAMPLING SIZE IN THE CODE WORD
for k=1:maxerror
    for i=1:50
    errorcode=encoded;
    y = randsample(size(encoded,2),k)
    errorcode(y)=~errorcode(y);
    
    total(k)=total(k)+1;
    % CORRECTING ERROR CODE TO GET CODEWORD USING VITERBI
    correctpath=viterbi(errorcode);
    if detect==1
        detected(k,1)=detected(k,1)+1;
        detect=0;
    end
    corrected=corrector(correctpath);

    if verify(corrected)~=1
        count(k,1)=count(k,1)+1;
    end
    end
end

%}

%CALCULATING THE PERCENTAGES OF ERROR DETECTION, AND ERROR CORRETION
correctrate=sum(total-count)/sum(total)*100
detectrate=sum(detected)./sum(total)*100
percent=(total-count)./total*100;
percent=percent(:,1)
k=[1:maxerror];


%PLOTTING THE FIGURES OBTAINED
figure
graph=plot(percent,'b --o')
title('Convolutional Encoder/Decoder Viterbi Plot I')
xlabel('Error Bits')
ylabel('Success %')
ylim([0 100])


detectrate
correctrate





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


% Calculate the XOR of the state values of the 10 flip flops for g1 polynomial
function g1=caluc_g1(states)
g1=mod(sum(states([5 6 8 9 10])),2);
end


% Calculate the XOR of the state values of the 10 flip flops for g2 polynomial

function g2=caluc_g2(states)
g2=mod(sum(states([3 4 5 7 8 10])),2);
end




% ===========> VITERBI DECODER <========================================
% INITIALIZES A 2-D PATHMETRIC ARRAY
% THE LEFT TO RIGHT TRAVERSAL OF THE PATHMETRIC ARRAY DENOTES THE HISTORY
% OF DECODING

% LAST COLUMN OF PATH METRIC ARRAY SHOWS THE FINAL PATH METRIC AFTER
% COMPLETE TRAVERSAL

function correctpath=viterbi(encoded)

    % GETTING THE VARIABLES INITIALIZED IN THE GLOBAL SPACE
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
        next=td(state+1,time+1,path+1); % GETTING THE NEXT STATE FROMM THE TRELLIS DIAGRAM
        
        if pathmetric(next+1,time+2) > new_metric
            pathmetric(next+1,time+2)=new_metric;   %UPDATING THE PATH METRIC OF THE NEXT STATE IF IT'S CURRENT VALUE IS LESSER
        if time+2 > size(encoded,2)/2
            return
        end
            if flag(next+1,time+2)==-1
                enqueue(next,time+1);   % IF THAT STATE HAS NOT BEEN VISITED BEFORE, ENQUEUE IT
                
            end
            flag(next+1,time+2)=state; % UPDATE THE PARENT OF THIS NEXT STATE AS THE STATE THAT UPDATED IT'S PATH METRIC LAST
        end
        pm=pathmetric;  % RETURN THE UPDATED PATH METRIC MATRIX
        
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
        

    % ============> CORRECTION FUNCTION <=============================
    % FUNCTION TO DETERMININE THE CORRECTED SEQUENCE BASED ON THE CORRECT
    % PATH GENERATED BY VITERBI ALGORITHM
    
    function corrected=corrector(correctpath)
        global td;
        k=2;
        time=0;
        corrected=[0,0]; % REDUNTANT ZERO BITS TO BE REMOVED AT THE END
        while k< size(correctpath,2)+1  % WHILE COUNT LESS THAN THE SIZE OF CORRECT PATH
            i=correctpath(k);
            if k == size(correctpath,2) % WHEN THE COUNT REACHES THE LAST BIT OF CORRECT PATH
                o=binarify(td(i+1,time+1,3)); % THE LAST INPUT WILL BE ZERO ( PURGING THE FLIP FLOPS)
                o=o(2:end);  % O IS THE 2-BIT VALUE OF THE OUTPUT FOR INPUT ZERO
                corrected=[corrected,o]; % APPEND THE 2 OUTPUT BITS TO THE END CORRECTED CODE
                corrected=corrected(3:end); % REMOVE THE TWO REDUNTANT ZERO BITS ADDED IN THE BEGINING
                return
            end

            if td(i+1,time+1,1)==correctpath(k+1) % IF THE NEXT BIT OF CORRECT PATH MATCHES THE NEXT STATE FOR ZERO INPUT

               o=binarify(td(i+1,time+1,3)); % O IS THE 3-BIT VALUE OF THE OUTPUT FOR INPUT ZERO
               o=o(2:end);  % O IS THE 2-BIT VALUE OF THE OUTPUT FOR INPUT ZERO
               corrected=[corrected,o]; % APPEND THE 2 OUTPUT BITS TO THE CORRECTED CODE
            end

            if td(i+1,time+1,2)==correctpath(k+1) % IF THE NEXT BIT OF CORRECT PATH MATCHES THE NEXT STATE FOR 0NE INPUT

                o=binarify(td(i+1,time+1,4)); % O IS THE 3-BIT VALUE OF THE OUTPUT FOR INPUT ONE
                o=o(2:end); % O IS THE 2-BIT VALUE OF THE OUTPUT FOR INPUT ONE
                corrected=[corrected,o]; %APPEND THE 2 OUTPUT BITS TO THE CORRECTED CODE
            end 
            k=k+1;
            time=time+1;

        end
   
    end
  
    
    

% ===========> VERIFICATION BY COMPARING THE CORRECTED CODEWORD TO THE CODE WORD THAT WAS INITIALLY ENCODED
    function success = verify(corrected)
        k=1;
        global encoded;
        success=1; % INITIALIZED TO CORRECTED SUCCESSFULLY
        if size(encoded,2) ~= size(corrected,2)
            success=0;  % IF THE SIZE OF ENCODED AND CORRECTED SEQUENCES DO NOT MATCH, CORRECTION IS NOT SUCCESSFULL
            return;
        end
        while k < size(encoded,2)
            if corrected(k)~=encoded(k) % IF EVERY BIT OF BOTH SEQUENCES DO NOT MATCH, CORRECTION IS NOT SUCCESSFULL
                success=0;
            end
            k=k+1;
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
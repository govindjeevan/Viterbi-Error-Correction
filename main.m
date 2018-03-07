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
maxerror=4; % MAXIMUM NUMBER OF ERROR BITS TO BE INTRODUCED


    %INITIALIZING THE ERROR CORRECTION/DETECTION COUNTS TO ZERO
total=zeros(maxerror,1);
count=zeros(maxerror,1);
detected=zeros(maxerror,1);
detect=0;
indexerror=0;


%=============================>>>>>>>>  GIVE THE INPUT HERE
%<<<<<<<<<==========================================================
input=[1 0 1];

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


% INTRODUCING RANDOM ERRORS IN THE CODE WORD
% NUMBER OF ERROR BITS VARY FROM 1 TO maxerror
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


%CALCULATING THE PERCENTAGES OF ERROR DETECTION, AND ERROR CORRETION
correctrate=sum(total-count)/sum(total)*100
detectrate=sum(detected)/sum(total)*100
percent=(total-count)/total*100;
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



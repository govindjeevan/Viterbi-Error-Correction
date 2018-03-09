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


n=10;               % NUMBER OF FLIP FLOPS
s=2^(n-1);          % NUMBER OF STATES IN TRELLIS DIAGRAM
maxerror=3;         % MAXIMUM NUMBER OF ERROR BITS TO BE INTRODUCED
maxlength=3;        % MAXIMUM BIT SIZE OF DATAWORDS CONSIDERED


%INITIALIZING THE ERROR CORRECTION/DETECTION COUNTS TO ZERO
total=zeros(2^maxlength-3,maxerror,1);
count=zeros(2^maxlength-3,maxerror,1);
detected=zeros(maxerror,1);
detect=0;
indexerror=0;


for l=1:2^maxlength-3   % ALL VALUES FROM 1 BIT TO maxlength BITS
    dataword = de2bi(l) % CONVERTING THE VALUE TO BINARY STATE (DATAWORD)
    encoded = encoder(dataword) % ENCODING THE DATA WORD
    maxtime=size(encoded,2)/2+1;    %CALCULATING THE EXTENT OF TRELLIS GRAPH REQUIRED TO DECODE THE CODEWORD
    td=generatetrellis(td);         %GENERATING THE TRELLIS DIAGRAM FOR THE GIVEN GENERATOR POLYNOMIALS
    
    % INTRODUCING ALL POSSIBLE ERRORS IN THE CODE WORD
    for k=1:maxerror                    % NUMBER OF ERROR BITS VARY FROM 1 TO maxerror
        indexarray=[1:size(encoded,2)]; % CREATE AN ARRAY CONTAINING THE INDEXES OF ELEMENTS IN THE ENCODED DATAWORD
        C=combnk(indexarray,k);         % C HAS ALL POSSIBLE COMBINATIONS OF INDEXES TAKEN K AT A TIME
        for i=1:size(C,1)
        errorcode=encoded;
        dataword
        errorbits=C(i,:)                % ERROR BITS ARE TAKEN AS INDEX COMBINATIONS WITHIN C
        errorcode(errorbits)=~errorcode(errorbits); % NEGATE THE BIT VALUES OF THE ERROR BIT COMBINATIONS
        total(l,k)=total(l,k)+1;

        % CORRECTING ERROR CODE TO GET CODEWORD USING VITERBI
        correctpath=viterbi(errorcode);
        if detect==1
            detected(l,k,1)=detected(l,k,1)+1;
            detect=0;
        end
        %USING THE PATH IDENTIFIED BY VITERBI ALGORITHM TO RECONSTRUCT THE
        %CODEWORD
        corrected=corrector(correctpath);
        if verify(corrected)~=1
            %INCREASING THE COUNT FOR EVERY UNSUCCESSFUL CORRECTION
            count(l,k)=count(l,k)+1;
        end
        end
    end
end
count
total


%CALCULATING THE PERCENTAGES OF ERROR DETECTION, AND ERROR CORRETION
correctrate=sum(total-count)/sum(total)*100
detectrate=sum(detected)./sum(total)*100
percent=(total-count)./total*100;
percent=percent(:,1)
k=[1:maxerror];


%PLOTTING THE FIGURES OBTAINED
figure
surf(percent)
title('Convolutional Encoder/Decoder Viterbi ')
xlabel('Error Bits')
xlabel('Dataword Value')
zlabel('Success %')
zlim([0 100])


detectrate
correctrate



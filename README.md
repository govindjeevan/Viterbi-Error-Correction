# CONVOLUTIONAL ENCODING  AND VITERBI DECODING

## Problem Statement
MATLAB code for  convolution code *(2, 1, 10)* decoding with **g1 = 110111** and **g2  =  11101101**  and  the  analysis  of  %  of  error  detection  and  correction  using **Viterbi decoding** and path metric.


# Project Contributors

- **Govind Jeevan**, 16CO221 

-  **Darshan D V**, 16CO216

## File/Function Sequence
The sequence of files/functions called during execution.
>
![Function Sequence](https://image.ibb.co/d1mqYS/Function_Sequence.png)

> The Purpose of each file is provided in the yellow note boxes.

## Execution

Open the ***main.m*** file in MATLAB.
Change the input data word.

    input=[1  0  1];
Change the maximum number of errors to be generated in testing.

    maxerror=4; % MAXIMUM NUMBER OF ERROR BITS TO BE INTRODUCED

Run the file. 
> ( Ctrl + Enter )

Alternatively, use the ***wholecode.m*** file to view all the code in one file.
## Results

The initial runs were on a lower order polynomial **g1=1111** and **g2=1101** with **( 2, 1, 4 )**
![enter image description here](https://i.imgur.com/7M498X2.jpg)

After acheiving reasonable success using this lower polynomial, whose trellis diagram was comprehensible we moved to the higher polynomials **g1 = 110111** and **g2  =  11101101**   with **( 2, 1, 4 )**.

> This Trellis Diagram would have 1024 states !

![enter image description here](https://i.imgur.com/JGQqvTx.jpg)

We then ran it for larger number of error bits and received the following graphs after a considerabe amount  of processing time.

![enter image description here](https://i.imgur.com/aTTPvwS.jpg)

> And a lot of processing time for this

![enter image description here](https://i.imgur.com/fTLVISO.jpg)
## Limitations

The code takes a lot of processing time when the number of encoded bits exceed a certain limit, as the graph traversal algorithm will have to traverse through a matrix of size
1024 X size(encoded).
The algorithm fails to satisfactorily correct codewords with more than 4 error bits.
## Final Words

Thank you for patiently going through the project ( That's 550+ lines of code! ).
It was a good experience working out the implementation of Trellis generation and Viterbi Algorithm, for which a graph algorithm similar to **djikstra's** was used after failing at a recursive approach.
Tried really really hard along the recursive lines, but the graph algorithm repeatedly enqueing and dequeueing states was the more suitable and efficient approach after all.
We gained a lot of insight about error correction mechanism and it's capabilities by being able to monitor the process so repeatedly.
MATLAB made the coding more easier and harder at the same time. 
The project is open to bug fixes and optimizations in the future.
# CONVOLUTIONAL ENCODING  AND VITERBI DECODING

MATLAB code for  convolution code *(2, 1, 10)* decoding with **g1 = 110111** and **g2  =  11101101**  and  the  analysis  of  %  of  error  detection  and  correction  using **Viterbi decoding** and path metric.


# Project Contributors

- **Govind Jeevan**, 16CO221 

-  **Darshan D V**, 16CO216

## File/Function Sequence

![Function Sequence](https://i.imgur.com/HBpvBiy.png)

## Running The Code

Open the ***main.m*** file in MATLAB.
Change the input data word.

    input=[1  0  1];
Change the maximum number of errors to be generated in testing.

    maxerror=4; % MAXIMUM NUMBER OF ERROR BITS TO BE INTRODUCED

Run the file. 
> ( Ctrl + Enter )

Alternatively, use the ***assg1_216_221.m*** file to view all the code in one file.
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
## Final Words

Thank you for patiently going through the project. It was a good experience working out the implementation of Trellis generationa nd Viterbi Algorithm, for which a graph algorithm similar to **djikstra's** was used after failing at a recursive approach.
Tried really really hard along the recursive lines, but the graph algorithm repeatedlytly enqueing and dequeuing states was the more suitable and efficient approach after all.
MATLAB made the coding more easier and harder at the same time. 
The project is open to bug fixes and optimizations in the future.
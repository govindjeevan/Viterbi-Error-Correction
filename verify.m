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
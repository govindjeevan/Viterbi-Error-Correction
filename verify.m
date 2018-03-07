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
end
function output = binary_complement(input)
    if mod(input,2) == 0
        output = [0 1]';
    end
    if mod(input,2) == 1
        output = [1 0]';
    end
end
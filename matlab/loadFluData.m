function [fluDat] = loadFluData(csvFile)

    tmp = readmatrix(csvFile, 'NumHeaderLines', 1, 'OutputType', 'char');
    
    % locate rows with "Influenza_Total" and "Influenza Tested" for
    % category
    % only pull "California" region, start with whole state instead of just
    % counties
    
    % convert the date code into a datetime (current format is YYYYWW)
    % season runs from week 40 to week 39 the following year
    
    % for a given week return the total, number tested, and positive test
    % ratio

end
function [fluDates, fluTotals] = loadFluData(csvFile)

    rawCSV = readmatrix(csvFile, 'NumHeaderLines', 1, 'OutputType', 'string');
    
    % locate rows with "Influenza_Total" and "Influenza Tested" for
    % category
    category_index = find(contains(rawCSV(:,5),["Influenza_Total"])); %, "Influenza Tested"]));

    % only pull "California" region, start with whole state instead of just
    % counties
    location_index = find(contains(rawCSV(:,4),"California"));
    
    desiredRows = intersect(category_index, location_index);
    
    % pull date, area, type of data, and number for each desired row
    rawDataSubset = rawCSV(desiredRows, [3 4 5 6]);
    
    % convert the date code into a datetime (MM/DD/YY)
    % season runs from week 40 to week 39 the following year
    rawDate = double(split(rawDataSubset(:,1), '/'));
    fluDates = datetime(2000+rawDate(:,3), rawDate(:,1), rawDate(:,2));
    
    
   fluTotals = double(rawDataSubset(:,4));

end

% tabling this for now, may return to it later

% for a given week return the total, number tested, and positive test
    % ratio
    
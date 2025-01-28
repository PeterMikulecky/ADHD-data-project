% MATLAB script for extracting raw EEG data from .mat struct file
% and saving as a channel-wise timeseries array in .csv format
% Author: Peter Mikulecky, pmikule1@asu.edu
% Date: 1/28/25


% Load .mat file into structData variable
structData = load('embeddedCTL_v41p_proc.mat')


% Extract raw EEG data into embeddedData variable
embeddedData = structData.embeddedData


% Initialize appropriately sized array for data
tableArray = cell(1, numel(embeddedData))


% Loop through cells (data channels), convert to table format, fill into tableArray
for i = 1:numel(embeddedData)
    tsData = embeddedData{i};
    if istimetable(tsData)
        tableArray{i} = timetable2table(tsData);  % Convert timetable to table if needed
    elseif isstruct(tsData)
        tableArray{i} = struct2table(tsData);  % Convert struct to table if it's a struct
    else
        tableArray{i} = table(tsData);  % Convert other data types to table format
    end
end



% Write filled tableArray to .csv file
for i = 1:numel(tableArray)
    writetable(tableArray{i}, sprintf('v41p-embed-test_%d.csv', i));
end


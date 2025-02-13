% MATLAB script for extracting raw EEG data from .mat struct file
% and saving as a channel-wise timeseries array in .csv format
% Author: Peter Mikulecky, pmikule1@asu.edu
% Date: 1/28/25


% Define the directory containing the .mat files
dirPath = './path-to-your-mat-files/';  % Update to your directory path

% Get a list of all .mat files in the directory
matFiles = dir(fullfile(dirPath, '*.mat'));

% Loop through each file in the directory
for fileIdx = 1:length(matFiles)
    % Load the current .mat file into structData variable
    fileName = fullfile(matFiles(fileIdx).folder, matFiles(fileIdx).name);
    structData = load(fileName);

    % Extract raw EEG data and channel labels
    embeddedData = structData.embeddedData;
    channelLabels = structData.channelLabels;

    % Initialize appropriately sized array for data
    tableArray = cell(1, numel(embeddedData));

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

    % Write filled tableArray to .csv file with channel labels in the filename
    for i = 1:numel(tableArray)
        channelLabel = channelLabels{i};
        % Ensure the channel label is valid filename
        validChannelLabel = regexprep(channelLabel, '[^\w]', '_');
        writetable(tableArray{i}, sprintf('%s-embed-test_%s.csv', fileName, validChannelLabel));
    end
end

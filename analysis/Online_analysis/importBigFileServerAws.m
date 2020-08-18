function tableEmoAws2507 = importBigFileServerAws(filename, startRow, endRow)
%IMPORTFILE1 Import numeric data from a text file as a matrix.
%   TABLEEMOAWS2507 = IMPORTFILE1(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   TABLEEMOAWS2507 = IMPORTFILE1(FILENAME, STARTROW, ENDROW) Reads data
%   from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   tableEmoAws2507 = importfile1('tableEmo_Aws_2507.csv', 1, 44533);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2020/07/25 12:47:42

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,5,6,11,14,16,17,18,19,20,21,22,23,24,26,27,29]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [1,5,6,11,14,16,17,18,19,20,21,22,23,24,26,27,29]);
rawStringColumns = string(raw(:, [2,3,4,7,8,9,10,12,13,15,25,28,30]));


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
for catIdx = [7,13]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% Create output variable
tableEmoAws2507 = table;
tableEmoAws2507.runID = cell2mat(rawNumericColumns(:, 1));
tableEmoAws2507.startTime = rawStringColumns(:, 1);
tableEmoAws2507.doneTime = rawStringColumns(:, 2);
tableEmoAws2507.participant_participantID = rawStringColumns(:, 3);
tableEmoAws2507.taskSession_taskSessionID = cell2mat(rawNumericColumns(:, 2));
tableEmoAws2507.taskSessionID = cell2mat(rawNumericColumns(:, 3));
tableEmoAws2507.sessionName = rawStringColumns(:, 4);
tableEmoAws2507.openingTime = rawStringColumns(:, 5);
tableEmoAws2507.closingTime = rawStringColumns(:, 6);
tableEmoAws2507.task_taskID = categorical(rawStringColumns(:, 7));
tableEmoAws2507.rt = cell2mat(rawNumericColumns(:, 4));
tableEmoAws2507.stimulus = rawStringColumns(:, 8);
tableEmoAws2507.responses = rawStringColumns(:, 9);
tableEmoAws2507.key_press = cell2mat(rawNumericColumns(:, 5));
tableEmoAws2507.test_part = rawStringColumns(:, 10);
tableEmoAws2507.blockNb = cell2mat(rawNumericColumns(:, 6));
tableEmoAws2507.trialNb = cell2mat(rawNumericColumns(:, 7));
tableEmoAws2507.condiEmoBlock = cell2mat(rawNumericColumns(:, 8));
tableEmoAws2507.condiEmoTrial = cell2mat(rawNumericColumns(:, 9));
tableEmoAws2507.condiRwd = cell2mat(rawNumericColumns(:, 10));
tableEmoAws2507.posCritDist = cell2mat(rawNumericColumns(:, 11));
tableEmoAws2507.distractor = cell2mat(rawNumericColumns(:, 12));
tableEmoAws2507.posTarget = cell2mat(rawNumericColumns(:, 13));
tableEmoAws2507.target = cell2mat(rawNumericColumns(:, 14));
tableEmoAws2507.trial_type = rawStringColumns(:, 11);
tableEmoAws2507.trial_index = cell2mat(rawNumericColumns(:, 15));
tableEmoAws2507.time_elapsed = cell2mat(rawNumericColumns(:, 16));
tableEmoAws2507.internal_node_id = rawStringColumns(:, 12);
tableEmoAws2507.run_id = cell2mat(rawNumericColumns(:, 17));
tableEmoAws2507.date = categorical(rawStringColumns(:, 13));
% Task 1: Program to segment raw data into individual classes
%
% 10 csv files, 1 for each gesture will be created under the folder Task-1-Out and under each
% group or user
numOfFeatures = 34;
maxTimeLength = 55;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
diffRegexForGoOut = ["Go Out","Go_Out","GoOut"];
folderName = "DM";
% Looping over different groups as user independent analysis
userNameRegex = strcat(folderName,'/',folderName,'*');
userNames = dir(char(userNameRegex));
for k=1:length(userNames)
    userName = userNames(k).name;
    outputFolder = strcat('Task-1-Output','/',userName);
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    % Looping for all gestures
    for i=1:length(words)
        fileNameRegex = strcat(folderName,'/',userName,'/','*.csv');
        fileNames = dir(char(fileNameRegex));
        concatenatedContent = [];
        % Looping for all files per gestures
        for j=1:length(fileNames)
            fileObj = fileNames(j);
            fileName = fileObj.name;
            if strcmpi(words(i),'GoOut')
                for g=1:length(diffRegexForGoOut)
                    regEx = strcat('\w*',diffRegexForGoOut(g),'\w*','.csv');
                    startIndex = regexpi(fileName,regEx);
                    if ~isempty(startIndex)
                        break
                    end
                end
                if isempty(startIndex)
                    continue
                end
            else
                regEx = strcat('\w*',words(i),'\w*','.csv');
                startIndex = regexpi(fileName,regEx);
                if isempty(startIndex)
                    continue
                end
            end
            fileContent = readtable(strcat(fileObj.folder,'/',fileName));
            table = fileContent(1:end,1:numOfFeatures);
            content = table2array(table);
            contentTransposed = content.';
            [x1,y1] = size(contentTransposed);
            if y1>maxTimeLength
                % Neglecting the action which was recorded for more than 55
                % seconds
                continue
            elseif y1<maxTimeLength
                % Padding zeros for actions which have data for less than 55
                % seconds
                padding = zeros(x1,maxTimeLength-y1);
                contentTransposed = cat(2,contentTransposed,padding);
            end
            % Concatenating data of different actions of the same gesture
            if isempty(concatenatedContent)
                concatenatedContent = contentTransposed;
            else
                concatenatedContent = cat(1, concatenatedContent, contentTransposed);
            end
        end
        % Writing the data of each gesture into the csv files which is fed for
        % task 2
        csvwrite(strcat(outputFolder,'/',words(i),'.csv'),concatenatedContent);
        concatenatedContent = contentTransposed;
    end
end
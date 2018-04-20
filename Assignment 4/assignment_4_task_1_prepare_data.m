% Assignment 3 : Dividing the data(O/P of assignment_1_task 3) into test and training for binary classification
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
inputFolder = 'Task-3-Output';
outputFolder = 'Classification-DataSet';
if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
end
trainingData = [];
testingData = [];
% Looping over different groups as user dependent analysis
userNameRegex = strcat(inputFolder,'/','DM*');
userNames = dir(char(userNameRegex));
for u=1:length(userNames)
    userName = userNames(u).name;
    % Looping over each gesture
    for i=1:length(words)
        labels = [];
        fileName = strcat(inputFolder,'/',userName,'/',words(i),'-pca','.csv');
        file = readtable(fileName,'ReadVariableNames',false);
        content = table2array(file);
        [numOfActions,numberOfComponents] = size(content);
        labels(1:numOfActions,1) = i;
        content = cat(2, content, labels);
        nTrain = ceil(numOfActions * 0.6);
        content = content(randperm(size(content,1)),:);
        if isempty(trainingData)
            trainingData = content(1:nTrain,1:end);
        else
            trainingData = cat(1, trainingData, content(1:nTrain,1:end));
        end
        if isempty(testingData)
            testingData = content(nTrain+1:end,1:end);
        else
            testingData = cat(1, testingData, content(nTrain+1:end,1:end));
        end
    end
end
csvwrite(strcat(outputFolder,'/','training_data','.csv'),trainingData);
csvwrite(strcat(outputFolder,'/','testing_data','.csv'),testingData);
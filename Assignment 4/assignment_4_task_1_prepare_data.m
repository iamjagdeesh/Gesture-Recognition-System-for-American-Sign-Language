% Assignment 4 : Dividing the data(O/P of assignment_1_task 3) into test and training for binary classification
numberOfPCAComponents = 20;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
inputFolder = 'Task-3-Output';
outputFolderName = 'Classification-DataSet';
outputFolder = strcat(outputFolderName);
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
trainingData = [];
testingData = [];
% Looping over each gesture
for i=1:length(words)
    labels = [];
    fileName = strcat(inputFolder,'/',words(i),'-pca','.csv');
    file = readtable(fileName,'ReadVariableNames',false);
    content = table2array(file);
    [numOfActions,numberOfComponents] = size(content);
    labels(1:numOfActions,1) = i;
    content = cat(2, content, labels);
    nTrain = ceil(numOfActions * 0.6);
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
csvwrite(strcat(outputFolderName,'/','training_data','.csv'),trainingData);
csvwrite(strcat(outputFolderName,'/','testing_data','.csv'),testingData);
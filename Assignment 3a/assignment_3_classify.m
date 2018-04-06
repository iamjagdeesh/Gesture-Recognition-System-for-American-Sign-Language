% Dividing data for binary classification
numOfFeatures = 34;
maxTimeLength = 45;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
inputFolder = 'Classification-DataSet';
classifiers = ["DT","SVM","NN"];
% Looping over different groups as user dependent analysis
userNameRegex = strcat(inputFolder,'/','DM*');
userNames = dir(char(userNameRegex));
for u=1:length(userNames)
    userName = userNames(u).name;
    trainFileName = strcat(inputFolder,'/',userName,'/','training_data.csv');
    trainFile = readtable(trainFileName,'ReadVariableNames',false);
    trainContent = table2array(trainFile);
    testFileName = strcat(inputFolder,'/',userName,'/','testing_data.csv');
    testFile = readtable(testFileName,'ReadVariableNames',false);
    testContent = table2array(testFile);
    [numOfTrainActions,~] = size(trainContent);
    [numOfTestActions,~] = size(testContent);
    fprintf('Metrics of %s\n',userName);
    for i=1:length(words)
        fprintf('\tGesture: %s\n',words(i));
        trainLabels = trainContent(1:numOfTrainActions,6) == i;
        testLabels = testContent(1:numOfTestActions,6) == i;
        for j=1:length(classifiers)
            fprintf('\t\tMachine: %s\n',classifiers(j));
            switch classifiers(j)
                case "DT"
                    model = fitctree(trainContent(1:end,1:end-1),trainLabels);
                case "SVM"
                    model = fitcsvm(trainContent(1:end,1:end-1),trainLabels);
                case "NN"
                    model = fitctree(trainContent(1:end,1:end-1),trainLabels);
            end
            predictedLabels = predict(model,testContent(1:end,1:end-1));
            TP = sum((predictedLabels + testLabels) == 2);
            FP = sum((predictedLabels - testLabels) == 1);
            FN = sum((predictedLabels - testLabels) == -1);
            precision = TP / (TP + FP);
            recall = TP / (TP + FN);
            F1 = (2 * precision * recall) / (precision + recall);
            accuracy = sum(predictedLabels == testLabels) / numOfTestActions;
            fprintf('\t\t\tAccuracy: %f\n',accuracy);
            fprintf('\t\t\tPrecision: %f\n',precision);
            fprintf('\t\t\tRecall: %f\n',recall);
            fprintf('\t\t\tF1 Score: %f\n',F1);
        end
    end
end
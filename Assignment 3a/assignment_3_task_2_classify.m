% Dividing data for binary classification
numOfFeatures = 34;
maxTimeLength = 45;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
inputFolder = 'Classification-DataSet';
classifiers = ["DT","SVM","NN"];
% Looping over different groups as user dependent analysis
userNameRegex = strcat(inputFolder,'/','DM*');
userNames = dir(char(userNameRegex));
results = [];
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
%     fprintf('Metrics of %s\n',userName);
    for i=1:length(words)
%         fprintf('\tGesture: %s\n',words(i));
        trainLabels = trainContent(1:numOfTrainActions,6) == i;
        testLabels = testContent(1:numOfTestActions,6) == i;
        for j=1:length(classifiers)
%             fprintf('\t\tMachine: %s\n',classifiers(j));
            switch classifiers(j)
                case "DT"
                    model = fitctree(trainContent(1:end,1:end-1),trainLabels);
                    predictedLabels = predict(model,testContent(1:end,1:end-1));
                case "SVM"
                    model = fitcsvm(trainContent(1:end,1:end-1),trainLabels);
                    predictedLabels = predict(model,testContent(1:end,1:end-1));
                case "NN"
                    inputs = trainContent(1:end,1:end-1);
                    targets = trainLabels;
%                     targetsSecond = targets == 0;
%                     targets = cat(2,targets,targetsSecond);
                    testInputs = testContent(1:end,1:end-1);
                    testTargets = testLabels;
%                     testTargetsSecond = testTargets == 0;
%                     testTargets = cat(2,testTargets,testTargetsSecond);
                    net = feedforwardnet(15);
                    trainedNet = train(net, inputs', targets');
                    predictedValues = trainedNet(testInputs');
                    predictedLabels = predictedValues >= 0.5;
                    predictedLabels = predictedLabels';
            end
            TP = sum((predictedLabels + testLabels) == 2);
            FP = sum((predictedLabels - testLabels) == 1);
            FN = sum((predictedLabels - testLabels) == -1);
            precision = TP / (TP + FP);
            recall = TP / (TP + FN);
            F1 = (2 * precision * recall) / (precision + recall);
            accuracy = sum(predictedLabels == testLabels) / numOfTestActions;
%             fprintf('\t\t\tAccuracy: %f\n',accuracy);
%             fprintf('\t\t\tPrecision: %f\n',precision);
%             fprintf('\t\t\tRecall: %f\n',recall);
%             fprintf('\t\t\tF1 Score: %f\n',F1);
            result = [userName, words(i), classifiers(j), num2str(accuracy), num2str(precision), num2str(recall), num2str(F1)];
            if isempty(results)
                results = result;
            else
                results = cat(1, results, result);
            end
        end
    end
end
T = table(results(:,1),results(:,2),results(:,3),results(:,4),results(:,5),results(:,6),results(:,7),'VariableNames',{'User' 'Gesture' 'Machine' 'Accuracy' 'Precision' 'Recall' 'F1'});
writetable(T,'report.csv');
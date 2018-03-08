numOfFeatures = 34;
words = ["About","And","Can","Cat","Cop","Cost","Day","Deaf","Decide","Father","Find","Gold","Goodnight","GoOut","Hearing","Here","Hospital","If"];
inputFolder = 'Task-1-Output';
for featureIndex=1:numOfFeatures
    outputFolderName = strcat('Task-2-Output','/','F',num2str(featureIndex));
    if ~exist(outputFolderName, 'dir')
        mkdir(outputFolderName);
    end
    for i=1:length(words)
        fileName = strcat(inputFolder,'/',words(i),'.csv');
        file = readtable(fileName,'ReadVariableNames',false);
        content = table2array(file);
        [x,y] = size(content);
        numOfActions = x / numOfFeatures;
        for j=0:numOfActions-1
            rowNumber = numOfFeatures*j + featureIndex;
            plot(content(rowNumber,1:end));
            hold on;
        end
        imageName = strcat(outputFolderName,'/',words(i),'-F',num2str(featureIndex),'.jpg');
        saveas(gcf,imageName);
        hold off;
    end
end    
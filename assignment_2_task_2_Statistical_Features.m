numOfFeatures = 34;
words = ["About","And","Can","Cat","Cop","Cost","Day","Deaf","Decide","Father","Find","Gold","Goodnight","GoOut","Hearing","Here","Hospital","If"];
statisticalFeatures = ["MIN","MAX","AVG","STD","RMS"];
inputFolder = 'Task-1-Output';
outputFolderNames = statisticalFeatures;
for featureIndex=1:numOfFeatures
    for stat=1:length(statisticalFeatures)
        outputFolderNames(stat) = strcat('Task-2-Output','/',statisticalFeatures(stat),'/','F',num2str(featureIndex));
        if ~exist(char(outputFolderNames(stat)), 'dir')
            mkdir(char(outputFolderNames(stat)));
        end
    end
    for i=1:length(words)
        fileName = strcat(inputFolder,'/',words(i),'.csv');
        file = readtable(fileName,'ReadVariableNames',false);
        content = table2array(file);
        [x,y] = size(content);
        numOfActions = x / numOfFeatures;
        for j=0:numOfActions-1
            rowNumber = numOfFeatures*j + featureIndex;
            if j==0
                concatenatedContent = content(rowNumber,1:end);
            else
                concatenatedContent = cat(1, concatenatedContent, content(rowNumber,1:end));
            end
        end
        for j=1:length(statisticalFeatures)
            switch statisticalFeatures(j)
                case "MIN"
                    plotValues = min(concatenatedContent);
                case "MAX"
                    plotValues = max(concatenatedContent);
                case "AVG"
                    plotValues = mean(concatenatedContent);
                case "STD"
                    plotValues = std(concatenatedContent);
                case "RMS"
                    plotValues = rms(concatenatedContent);
                otherwise
                    plotValues = std(concatenatedContent);
            end
            plot(plotValues);
            imageName = strcat(outputFolderNames(j),'/',words(i),'-F',num2str(featureIndex),'.jpg');
            saveas(gcf,imageName);
        end
    end
end    
numOfFeatures = 34;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
statisticalFeatures = ["MIN","MAX","AVG","STD","RMS"];
inputFolder = 'Task-1-Output';
for statFeatureIndex=1:length(statisticalFeatures)
    for featureIndex=1:numOfFeatures
        outputFolderName = strcat('Task-2-Output-New','/',statisticalFeatures(statFeatureIndex));
        if ~exist(char(outputFolderName), 'dir')
            mkdir(char(outputFolderName));
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
            switch statisticalFeatures(statFeatureIndex)
                case "MIN"
                    plotValues = min(concatenatedContent,[],2);
                case "MAX"
                    plotValues = max(concatenatedContent,[],2);
                case "AVG"
                    plotValues = mean(concatenatedContent,2);
                case "STD"
                    plotValues = std(concatenatedContent,0,2);
                case "RMS"
                    plotValues = rms(concatenatedContent,2);
                otherwise
                    plotValues = std(concatenatedContent,0,2);
            end
            [m,n] = size(plotValues);
            if i==1
                concatenatedPlotValues = plotValues(1:20,1);
            else
                concatenatedPlotValues = cat(2, concatenatedPlotValues, plotValues(1:20,1));
            end
%             xAxis(1:m,1) = words(i);
%             scatter(xAxis(1:m,1), plotValues);
%             hold on;
%             boxplot(plotValues, words(i));
%             hold on;
        end
        boxplot(concatenatedPlotValues,words);
        imageName = strcat(outputFolderName,'/','F',num2str(featureIndex),'.jpg');
        saveas(gcf,imageName);
    end
end
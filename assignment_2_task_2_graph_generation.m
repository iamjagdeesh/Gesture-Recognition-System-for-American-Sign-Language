numOfFeatures = 34;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
sensorNames = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];
inputFolder = 'Task-1-Output';
for featureIndex=1:numOfFeatures
    for i=1:length(words)
        outputFolderName = strcat('Task-2-Output-For-Graphs','/',words(i));
        if ~exist(outputFolderName, 'dir')
            mkdir(char(outputFolderName));
        end
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
        title(strcat(sensorNames(featureIndex),' values vs time plot for ',' ',words(i),' gesture'));
        xlabel('Time');
        ylabel(strcat(sensorNames(featureIndex),' values'));
        imageName = strcat(outputFolderName,'/',words(i),'-',sensorNames(featureIndex),'.jpg');
        saveas(gcf,imageName);
        hold off;
    end
end
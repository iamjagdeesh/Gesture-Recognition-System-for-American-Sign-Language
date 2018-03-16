statisticalFeatures = ["FFT","DWT","RMS","STD"];
sensorsForStats = ["EMG0R","EMG7R","EMG1R","EMG0L","EMG5R";
    "OYR","EMG4L","EMG3L","EMG7R","EMG2R";
    "EMG6L","EMG4L","EMG0L","EMG5L","EMG7L";
    "EMG6L","EMG4L","ORL","ALY","EMG5L"];
sensorNames = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];
numOfFeatures = 34;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
maxTimeLength = 45;
inputFolder = 'Task-1-Output';
outputFolderName = strcat('Task-2-Output-Final');

if ~exist(outputFolderName, 'dir')
    mkdir(char(outputFolderName));
end
for i=1:length(words)
    fileName = strcat(inputFolder,'/',words(i),'.csv');
    file = readtable(fileName,'ReadVariableNames',false);
    content = table2array(file);
    [x,y] = size(content);
    numOfActions = x / numOfFeatures;
    concatenatedContentAfterAllAlgo = [];
    xAxisNames = [];
    for j=1:length(statisticalFeatures)
        for sensorIndex=1:length(sensorsForStats(j,1:end))
            concatenatedContentAfterAlgo = [];
            sensorName = sensorsForStats(j,sensorIndex);
            featureIndex = find(sensorNames == sensorName);
            for k=0:numOfActions-1
                rowNumber = numOfFeatures*k + featureIndex;
                switch statisticalFeatures(j)
                    case "FFT"
                        contentAfterAlgo = abs(fft(content(rowNumber,1:end)));
                        contentAfterAlgo = sort(contentAfterAlgo,'descend');
                        contentAfterAlgo = contentAfterAlgo(:,1:3);% 3 interesting points from fft
                    case "DWT"
                        contentIndividual = content(rowNumber,1:end);
                        nanIndex = find(isnan(contentIndividual));
                        contentIndividual(nanIndex) = 0;
                        contentAfterAlgo = dwt(contentIndividual,'sym4');
                        % contentAfterAlgo = dwt(content(rowNumber,1:end),'sym4');
                        contentAfterAlgo = contentAfterAlgo(:,1:3);% 3 interesting points from dwt
                    case "RMS"
                        contentAfterAlgo = rms(content(rowNumber,1:end));
                    case "STD"
                        contentAfterAlgo = std(content(rowNumber,1:end));
                    otherwise
                        contentAfterAlgo = rms(content(rowNumber,1:end));
                end
                if isempty(concatenatedContentAfterAlgo)
                    concatenatedContentAfterAlgo = contentAfterAlgo;
                else
                    concatenatedContentAfterAlgo = cat(1,concatenatedContentAfterAlgo, contentAfterAlgo);
                end
            end
            [r,numPoints] = size(concatenatedContentAfterAlgo);
            algoName = statisticalFeatures(j);
            for p=1:numPoints
                if isempty(xAxisNames)
                    xAxisNames = strcat(algoName,'-',sensorName,'-',num2str(p));
                else
                    xAxisNames = cat(2,xAxisNames, strcat(algoName,'-',sensorName,'-',num2str(p)));
                end
            end
            if isempty(concatenatedContentAfterAllAlgo)
                concatenatedContentAfterAllAlgo = concatenatedContentAfterAlgo;
            else
                concatenatedContentAfterAllAlgo = cat(2, concatenatedContentAfterAllAlgo, concatenatedContentAfterAlgo);
            end
        end
    end
    csvwrite(strcat(outputFolderName,'/',words(i),'.csv'),concatenatedContentAfterAllAlgo);
    [rows,col] = size(concatenatedContentAfterAllAlgo);
    for n=1:rows
        plot(concatenatedContentAfterAllAlgo(n,1:end));
        hold on;
    end
    title(strcat(' Values vs Features plot for ',' ',words(i),' gesture'));
    xlabel('Extracted Features');
    ylabel('Values of Features');
    imageName = strcat(outputFolderName,'/',words(i),'.jpg');
    saveas(gcf,imageName);
    hold off;
end
% Task 2: Program to extract features and obtain feature matrix for each
% gesture
statisticalFeatures = ["FFT","DWT","RMS","STD","AVG"];
sensorsForStats = ["EMG7R","EMG0R","EMG1R","EMG5R","EMG6R";
    "GLY","GLZ","GLX","ALY","GRX";
    "EMG6L","EMG4L","EMG7L","EMG0L","EMG5L";
    "EMG4L","EMG6L","EMG5L","EMG0L","EMG7L";
    "GRZ","GRY","GRX","ALY","GLZ"];
sensorNames = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];
numOfFeatures = 34;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
maxTimeLength = 55;
inputFolder = 'Task-1-Output';
outputFolderName = strcat('Task-2-Output');
numberOfPeakValues = 4;
if ~exist(outputFolderName, 'dir')
    mkdir(char(outputFolderName));
end
% Looping over gestures
for i=1:length(words)
    fileName = strcat(inputFolder,'/',words(i),'.csv');
    file = readtable(fileName,'ReadVariableNames',false);
    content = table2array(file);
    [x,y] = size(content);
    numOfActions = x / numOfFeatures;
    concatenatedContentAfterAllAlgo = [];
    xAxisNames = [];
    % Looping over different techniques
    for j=1:length(statisticalFeatures)
        % Looping over different sensors for each technique
        for sensorIndex=1:length(sensorsForStats(j,1:end))
            concatenatedContentAfterAlgo = [];
            sensorName = sensorsForStats(j,sensorIndex);
            featureIndex = find(sensorNames == sensorName);
            % Looping over different actions
            for k=0:numOfActions-1
                rowNumber = numOfFeatures*k + featureIndex;
                % Applying techniques
                switch statisticalFeatures(j)
                    case "FFT"
                        contentAfterAlgo = abs(fft(content(rowNumber,1:end)));
                        contentAfterAlgo = sort(contentAfterAlgo,'descend');
                        contentAfterAlgo = contentAfterAlgo(:,1:numberOfPeakValues);% num of interesting points from fft
                    case "DWT"
                        contentIndividual = content(rowNumber,1:end);
                        nanIndex = find(isnan(contentIndividual));
                        contentIndividual(nanIndex) = 0;
                        contentAfterAlgo = dwt(contentIndividual,'sym4');
                        contentAfterAlgo = sort(contentAfterAlgo,'descend');
                        contentAfterAlgo = contentAfterAlgo(:,1:numberOfPeakValues);% num of interesting points from dwt
                    case "RMS"
                        contentAfterAlgo = rms(content(rowNumber,1:end));
                    case "STD"
                        contentAfterAlgo = std(content(rowNumber,1:end));
                    case "AVG"
                        contentAfterAlgo = std(content(rowNumber,1:end));
                    otherwise
                        contentAfterAlgo = rms(content(rowNumber,1:end));
                end
                % Concatenating different actions of the same gesture
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
            % Stacking the features side by side
            if isempty(concatenatedContentAfterAllAlgo)
                concatenatedContentAfterAllAlgo = concatenatedContentAfterAlgo;
            else
                concatenatedContentAfterAllAlgo = cat(2, concatenatedContentAfterAllAlgo, concatenatedContentAfterAlgo);
            end
        end
    end
    % Writing the output to csc
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
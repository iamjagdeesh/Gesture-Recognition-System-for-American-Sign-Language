maxTimeLength = 55;
sensorNames = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];
numOfFeatures = 34;
inputFolder = 'Task-1-Output';
fileName = "Task-1-Output/About.csv";
selectedFeatures = ["GRX","EMG0R"];
algoUsed = ["FFT","RMS"];
extractedFeatures = ["GRX-FFT-1","GRX-FFT-2","GRX-FFT-3","GRX-FFT-4","EMG0R-RMS"];
concatenatedContentAfterAlgo = [];
for i=1:length(selectedFeatures)
    file = readtable(fileName,'ReadVariableNames',false);
    content = table2array(file);
    [x,y] = size(content);
    numOfActions = x / numOfFeatures;
    featureIndex = find(sensorNames == selectedFeatures(i));
    contentOfAllActions = [];
    for j=0:numOfActions-1
        rowNumber = numOfFeatures*j + featureIndex;
        contentOfEachAction = content(rowNumber,1:end);
        if isempty(contentOfAllActions)
            contentOfAllActions = contentOfEachAction;
        else
            contentOfAllActions = cat(1,contentOfAllActions, contentOfEachAction);
        end
    end
    if algoUsed(i) == "FFT"
        L = maxTimeLength;
        n = 2^nextpow2(L);
        contentAfterAlgo = fft(contentOfAllActions,n,2);
        contentAfterAlgo = abs(contentAfterAlgo/L);
        contentAfterAlgo = sort(contentAfterAlgo,2,'descend');
        contentAfterAlgo = contentAfterAlgo(:,1:4);% 4 interesting points from fft
    elseif algoUsed(i) == "RMS"
        contentAfterAlgo = rms(contentOfAllActions,2);
    end
    if isempty(concatenatedContentAfterAlgo)
        concatenatedContentAfterAlgo = contentAfterAlgo;
    else
        concatenatedContentAfterAlgo = cat(2,concatenatedContentAfterAlgo,contentAfterAlgo);
    end
end
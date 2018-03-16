sensorNames = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];
numOfFeatures = 34;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
maxTimeLength = 55;
inputFolder = 'Task-1-Output';
statisticalFeatures = ["DWT","FFT","RMS","STD"];
numberOfSensorsInAlgos = [5, 5, 5, 5];
for statFeatureIndex=1:length(statisticalFeatures)
    meanedValue = [];
    corrCoffSum = zeros(1,numOfFeatures);
    for featureIndex=1:numOfFeatures
        meanedValuePerSensor = [];
        for i=1:length(words)
            fileName = strcat(inputFolder,'/',words(i),'.csv');
            file = readtable(fileName,'ReadVariableNames',false);
            content = table2array(file);
            [x,y] = size(content);
            numOfActions = x / numOfFeatures;
            for j=0:numOfActions-1
                rowNumber = numOfFeatures*j + featureIndex;
                switch statisticalFeatures(statFeatureIndex)
                    case "FFT"
                        contentAfterAlgo = abs(fft(content(rowNumber,1:end)));
                    case "DWT"
                        x = content(rowNumber,1:end);
                        k = find(isnan(x));
                        x(k) = 0;
                        contentAfterAlgo = dwt(x,'sym4');
                    case "RMS"
                        contentAfterAlgo = rms(content(rowNumber,1:end));
                    case "STD"
                        contentAfterAlgo = std(content(rowNumber,1:end));
                    otherwise
                        contentAfterAlgo = abs(fft(content(rowNumber,1:end)));
                end
                if j==0
                    concatenatedContentAfterAlgo = contentAfterAlgo;
                else
                    concatenatedContentAfterAlgo = cat(1, concatenatedContentAfterAlgo, contentAfterAlgo);
                end
            end
            meanedValuePerGesturePerSensor = mean(concatenatedContentAfterAlgo);
            if isempty(meanedValuePerSensor)
                meanedValuePerSensor = meanedValuePerGesturePerSensor;
            else
                meanedValuePerSensor = cat(1, meanedValuePerSensor, meanedValuePerGesturePerSensor);
            end
        end
        [row,col] = size(meanedValuePerSensor);
        sum = 0;
        for i1=1:row-1
            for j1=i1+1:row
                if statisticalFeatures(statFeatureIndex)=="RMS" || statisticalFeatures(statFeatureIndex)=="STD"
                    coff = min(meanedValuePerSensor(i1,1:end),meanedValuePerSensor(j1,1:end))/max(meanedValuePerSensor(i1,1:end),meanedValuePerSensor(j1,1:end));
                    sum = sum + coff;
                else
                    coff = corrcoef(meanedValuePerSensor(i1,1:end),meanedValuePerSensor(j1,1:end));
                    sum = sum + coff(1,2);
                end
            end
        end
        corrCoffSum(featureIndex) = sum;
        if isempty(meanedValue)
            meanedValue = meanedValuePerSensor;
        else
            meanedValue = cat(1, meanedValue, meanedValuePerSensor);
        end
    end
    sortedCorrCoffSum = sort(corrCoffSum);
    disp(strcat('Features selected by ',statisticalFeatures(statFeatureIndex)));
    for nums=1:numberOfSensorsInAlgos(statFeatureIndex)
        val = sortedCorrCoffSum(nums);
        index = find(corrCoffSum == val);
        disp(sensorNames(index));
    end
end
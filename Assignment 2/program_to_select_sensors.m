% Program to select sensors for each technique
%
% This is a helper program which need not be run while demonstrating
sensorNames = ["ALX","ALY","ALZ","ARX","ARY","ARZ","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","GLX","GLY","GLZ","GRX","GRY","GRZ","ORL","OPL","OYL","ORR","OPR","OYR"];
numOfFeatures = 34;
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
maxTimeLength = 45;
inputFolder = 'Task-1-Output';
statisticalFeatures = ["FFT","DWT","RMS","STD","AVG"];
numberOfSensorsInAlgos = [5, 5, 5, 5, 5];
% Looping for each technique
for statFeatureIndex=1:length(statisticalFeatures)
    meanedValue = [];
    corrCoffSum = zeros(1,numOfFeatures);
    % Looping for each of the sensor
    for featureIndex=1:numOfFeatures
        meanedValuePerSensor = [];
        % Looping for each of the gesture
        for i=1:length(words)
            fileName = strcat(inputFolder,'/',words(i),'.csv');
            file = readtable(fileName,'ReadVariableNames',false);
            content = table2array(file);
            [x,y] = size(content);
            numOfActions = x / numOfFeatures;
            % Looping for each of the action of the same gesture
            for j=0:numOfActions-1
                rowNumber = numOfFeatures*j + featureIndex;
                % Applying the technique on the corresponding data
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
                    case "AVG"
                        contentAfterAlgo = mean(content(rowNumber,1:end));
                    otherwise
                        contentAfterAlgo = abs(fft(content(rowNumber,1:end)));
                end
                % Concatenating data of actions of same gesture after applying the technique 
                if j==0
                    concatenatedContentAfterAlgo = contentAfterAlgo;
                else
                    concatenatedContentAfterAlgo = cat(1, concatenatedContentAfterAlgo, contentAfterAlgo);
                end
            end
            % Taking mean over all actions of the same gesture and same
            % sensor
            meanedValuePerGesturePerSensor = mean(concatenatedContentAfterAlgo);
            if isempty(meanedValuePerSensor)
                meanedValuePerSensor = meanedValuePerGesturePerSensor;
            else
                meanedValuePerSensor = cat(1, meanedValuePerSensor, meanedValuePerGesturePerSensor);
            end
        end
        % Finding similarity value between every pair of gestures for the
        % sensor and summing them to get 1 value per sensor
        [row,col] = size(meanedValuePerSensor);
        sum = 0;
        for i1=1:row-1
            for j1=i1+1:row
                if statisticalFeatures(statFeatureIndex)=="RMS" || statisticalFeatures(statFeatureIndex)=="STD" || statisticalFeatures(statFeatureIndex)=="AVG"
                    coff = min(meanedValuePerSensor(i1,1:end),meanedValuePerSensor(j1,1:end))/max(meanedValuePerSensor(i1,1:end),meanedValuePerSensor(j1,1:end));
                    sum = sum + coff;
                else
                    coff = corrcoef(meanedValuePerSensor(i1,1:end),meanedValuePerSensor(j1,1:end));
                    sum = sum + coff(1,2);
                end
            end
        end
        corrCoffSum(featureIndex) = sum;
        % Concatenate the value obtained for each sensor 
        if isempty(meanedValue)
            meanedValue = meanedValuePerSensor;
        else
            meanedValue = cat(1, meanedValue, meanedValuePerSensor);
        end
    end
    % Sorting the value for all sensors and picking the sensors which
    % provided smallest values as they are more dissimilar
    sortedCorrCoffSum = sort(corrCoffSum);
    disp(strcat('Sensors selected by',' ',statisticalFeatures(statFeatureIndex)));
    for nums=1:numberOfSensorsInAlgos(statFeatureIndex)
        val = sortedCorrCoffSum(nums);
        index = find(corrCoffSum == val);
        disp(sensorNames(index));
    end
end
xAxisNames = {'FFT-EMG3R[1]','FFT-EMG3R[2]','FFT-EMG3R[3]','FFT-EMG3R[4]','FFT-EMG6R[1]','FFT-EMG6R[2]','FFT-EMG6R[3]','FFT-EMG6R[4]','FFT-EMG5R[1]','FFT-EMG5R[2]','FFT-EMG5R[3]','FFT-EMG5R[4]','FFT-EMG4R[1]','FFT-EMG4R[2]','FFT-EMG4R[3]','FFT-EMG4R[4]','FFT-EMG1R[1]','FFT-EMG1R[2]','FFT-EMG1R[3]','FFT-EMG1R[4]','DWT-EMG3R[1]','DWT-EMG3R[2]','DWT-EMG3R[3]','DWT-EMG3R[4]','DWT-EMG4R[1]','DWT-EMG4R[2]','DWT-EMG4R[3]','DWT-EMG4R[4]','DWT-GLX[1]','DWT-GLX[2]','DWT-GLX[3]','DWT-GLX[4]','DWT-GLY[1]','DWT-GLY[2]','DWT-GLY[3]','DWT-GLY[4]','DWT-GLZ[1]','DWT-GLZ[2]','DWT-GLZ[3]','DWT-GLZ[4]','RMS-EMG6L','RMS-EMG2L','RMS-EMG7L','RMS-EMG0L','RMS-EMG3L','STD-OPL','STD-ALX','STD-EMG2L','STD-EMG7L','STD-ALY','AVG-GRY','AVG_GRX','AVG_GRZ','AVG_ARX','AVG-ALZ'};
numberOfPCAComponents = 5;
inputFolder = 'Task-2-Output';
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
outputFolderName = strcat('Task-3-Output');
if ~exist(outputFolderName, 'dir')
    mkdir(char(outputFolderName));
end
% Looping over each gesture
for i=1:length(words)
    fileName = strcat(inputFolder,'/',words(i),'.csv');
    file = readtable(fileName,'ReadVariableNames',false);
    content = table2array(file);
    % Input to PCA
    [numOfActions,numberOfExtractedFeatures] = size(content);
    % Running PCA
    [coeff,score,latent,tsquared,explained] = pca(content);
    pcaFeatureMatrix = content * coeff;
    printStatement = strcat('Percentage of variance covered by the top-', char(numberOfPCAComponents) ,'-principal components:-', ' for ',words(i));
    disp(char(printStatement));
    disp(explained(1:numberOfPCAComponents,1:end));
    % Writing the data in terms of PCA components to csv
    csvwrite(strcat(outputFolderName,'/',words(i),'-','pca','.csv'),pcaFeatureMatrix);
    [rows,col] = size(pcaFeatureMatrix);
    % Plotting data in terms of PCA components
    for n=1:rows
        plot(pcaFeatureMatrix(n,1:numberOfPCAComponents));
        hold on;
    end
    title(strcat(' Values vs PCA Components plot for ',' ',words(i),' gesture'));
    xlabel('PCA Components');
    ylabel('Values for the PCA Components');
    imageName = strcat(outputFolderName,'/',words(i),'-','score','.jpg');
    saveas(gcf,imageName);
    hold off;
    % Plotting the contribution of old features to first 3 Principal components
    biplot(coeff(:,1:3),'scores',score(:,1:3),'varlabels',xAxisNames);
    imageName = strcat(outputFolderName,'/',words(i),'-','biplot','.jpg');
    saveas(gcf,imageName);
end
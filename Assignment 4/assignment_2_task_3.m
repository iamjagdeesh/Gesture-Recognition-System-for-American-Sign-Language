numberOfPCAComponents = 20;
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
    % Writing the data in terms of PCA components to csv
    csvwrite(strcat(outputFolderName,'/',words(i),'-','pca','.csv'),pcaFeatureMatrix(1:end,1:numberOfPCAComponents));
end
numberOfPCAComponents = 5;
inputFolder = 'Task-2-Output';
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
outputFolderName = 'Task-3-Output';
% Looping over different groups as user dependent analysis
userNameRegex = strcat(inputFolder,'/','DM*');
userNames = dir(char(userNameRegex));
for u=1:length(userNames)
    userName = userNames(u).name;
    outputFolder = strcat(outputFolderName,'/',userName);
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    % Looping over each gesture
    for i=1:length(words)
        fileName = strcat(inputFolder,'/',userName,'/',words(i),'.csv');
        file = readtable(fileName,'ReadVariableNames',false);
        content = table2array(file);
        % Input to PCA
        [numOfActions,numberOfExtractedFeatures] = size(content);
        % Running PCA
        coeff = pca(content);
        pcaFeatureMatrix = content * coeff;
        % Writing the data in terms of PCA components to csv
        csvwrite(strcat(outputFolderName,'/',userName,'/',words(i),'-','pca','.csv'),pcaFeatureMatrix(1:end,1:numberOfPCAComponents));
    end
end
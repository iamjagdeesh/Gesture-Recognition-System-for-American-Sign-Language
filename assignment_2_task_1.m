numOfFeatures = 34;
maxTimeLength = 45;
wordsForMatch = ["About","And","Can","Cop","Deaf","Decide","Father","Find","Out","Hearing"];
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
folderName = "DM";
outputFolder = 'Task-1-Output';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
for i=1:length(wordsForMatch)
    fileNameRegex = strcat(folderName,'/',folderName,'*/','*.csv');
    fileNames = dir(char(fileNameRegex));
    concatenatedContent = [];
    for j=1:length(fileNames)
        fileObj = fileNames(j);
        fileName = fileObj.name;
        regEx = strcat('\w*',wordsForMatch(i),'\w*','.csv');
        startIndex = regexpi(fileName,regEx);
        if isempty(startIndex)
            continue
        end
        fileContent = readtable(strcat(fileObj.folder,'/',fileName));
        table = fileContent(1:end,1:numOfFeatures);
        content = table2array(table);
        contentTransposed = content.';
        [x1,y1] = size(contentTransposed);
        if y1>maxTimeLength
            continue
        elseif y1<maxTimeLength
            padding = zeros(x1,maxTimeLength-y1);
            contentTransposed = cat(2,contentTransposed,padding);
        end
        if isempty(concatenatedContent)
            concatenatedContent = contentTransposed;
        else
            concatenatedContent = cat(1, concatenatedContent, contentTransposed);
        end
    end
    csvwrite(strcat(outputFolder,'/',words(i),'.csv'),concatenatedContent);
    concatenatedContent = contentTransposed;
end
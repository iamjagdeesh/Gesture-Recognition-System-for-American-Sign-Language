numOfFeatures = 34;
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
        if isempty(concatenatedContent)
            concatenatedContent = contentTransposed;
        else
            [x1,y1] = size(concatenatedContent);
            [x2,y2] = size(contentTransposed);
            if y1>y2
                padding = zeros(x2,y1-y2);
                contentTransposed = cat(2,contentTransposed,padding);
            elseif y2>y1
                padding = zeros(x1,y2-y1);
                concatenatedContent = cat(2,concatenatedContent,padding);
            end
            concatenatedContent = cat(1, concatenatedContent, contentTransposed);
        end
    end
    csvwrite(strcat(outputFolder,'/',words(i),'.csv'),concatenatedContent);
    concatenatedContent = contentTransposed;
end
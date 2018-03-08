words = ["About","And","Can","Cat","Cop","Cost","Day","Deaf","Decide","Father","Find","Gold","Goodnight","GoOut","Hearing","Here","Hospital","If"];
folderName = "DM07";
outputFolder = 'Task-1-Output';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
for i=1:length(words)
    fileNameRegex = strcat(folderName,'/',words(i),'*.csv');
    fileNames = dir(char(fileNameRegex));
    for j=1:length(fileNames)
        fileObj = fileNames(j);
        fileName = fileObj.name;
        fileContent = readtable(strcat(folderName,'/',fileName));
        table = fileContent(1:end,1:34);%Only 34 sensor data as mentioned
        content = table2array(table);
        contentTransposed = content.';
        if j==1
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
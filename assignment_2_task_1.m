words = ["About","And","Can","Cat","Cop","Cost","Day","Deaf","Decide","Father","Find","Gold","Goodnight","GoOut","Hearing","Here","Hospital","If"];
folderName = "DM07/";
for i=1:length(words)
    fileNameRegex = strcat(folderName,words(i),'*.csv');
    fileNames = dir(char(fileNameRegex));
    for j=1:length(fileNames)
        fileObj = fileNames(j);
        fileName = fileObj.name;
        fileContent = readtable(strcat(folderName,fileName),'ReadVariableNames', false);
        table = fileContent(1:end,1:end-5);
        content = table2array(table);
        contentTransposed = content.';
        if j==1
            concatenatedContent = contentTransposed;
        else
            concatenatedContent = cat(1, concatenatedContent, contentTransposed);
        end
    end
    csvwrite(strcat(words(i),'.csv'),concatenatedContent);
    concatenatedContent = contentTransposed;
end
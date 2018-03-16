inputFolder = 'Task-2-Output-Final';
words = ["About","And","Can","Cop","Deaf","Decide","Father","Find","GoOut","Hearing"];
for i=1:length(words)
    fileName = strcat(inputFolder,'/',words(i),'.csv');
    file = readtable(fileName,'ReadVariableNames',false);
    content = table2array(file);
    [numOfActions,numberOfExtractedFeatures] = size(content);
    [coeff,score,latent,tsquared,explained] = pca(content);
%     biplot(coeff(:,1:2),'scores',score(:,1:2));%,'varlabels',xAxisNames);
%     scatter3(score(:,1),score(:,2),score(:,3));
%     axis equal;
%     xlabel('1st Principal Component');
%     ylabel('2nd Principal Component');
%     zlabel('3rd Principal Component'); 
end
% Reset matlab
close all
clear
clc

dataDir = '\\ROOT\projects\GSA_Daysimeter\Federal_Highway\DaysimeterData\fall2';
exportDir = '\\ROOT\projects\GSA_Daysimeter\Federal_Highway\DaysimeterData\fall2\daysigrams';

% Load data
data = loadData(dataDir);

n  = numel(data);

timestamp = upper(datestr(now,'mmmdd'));

IDs = matlab.lang.makeUniqueStrings({data.ID}');

[IDs,I] = sort(IDs);

for iObj = 1:n
    thisObj = data(I(iObj));
    
    if isempty(thisObj.Time)
        continue
    end
    
    titleText = {'GSA - Turner-Fairbank Highway Research Center';['ID: ',thisObj.ID,', Device SN: ',num2str(thisObj.SerialNumber)]};
    
    d = d12pack.daysigram(thisObj,titleText);
    
    for iFile = 1:numel(d)
        d(iFile).Title = titleText;
        
        fileName = [IDs{iObj},'_',timestamp,'_p',num2str(iFile),'.pdf'];
        filePath = fullfile(exportDir,fileName);
        try
        saveas(d(iFile).Figure,filePath);
        close(d(iFile).Figure);
        catch
        end
        
    end
end

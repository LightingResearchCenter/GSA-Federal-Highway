%% Reset MATLAB
close all
clear
clc

%% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,  'd12pack');
circadianDir	= fullfile(githubDir,'circadian');
addpath(d12packDir,circadianDir);

%% Map paths
timestamp = datestr(now,'yyyy-mm-dd_HHMM');
rootDir = '\\root\projects';
calPath = fullfile(rootDir,'DaysimeterAndDimesimeterReferenceFiles',...
    'recalibration2016','calibration_log.csv');
prjDir  = fullfile(rootDir,'GSA_Daysimeter','Federal_Highway','DaysimeterData','fall2');
orgDir  = fullfile(prjDir,'originalData');
dbName  = [timestamp,'.mat'];
dbPath  = fullfile(prjDir,dbName);

%% Crop and convert data
LocObj = d12pack.LocationData;
LocObj.BuildingName             = 'Turner-Fairbank Highway Research Center';
LocObj.Street                   = '6300 Georgetown Pike';
LocObj.City                     = 'McLean';
LocObj.State_Territory          = 'Virginia';
LocObj.PostalStateAbbreviation	= 'VA';
LocObj.ZIP                      = '22101-2200';
LocObj.Country                  = 'United States of America';
LocObj.Organization             = 'General Services Administration';
LocObj.Lattitude                =  38.956385;
LocObj.Longitude                = -77.1520347;

listingCDF   = dir(fullfile(orgDir,'*.cdf'));
cdfPaths     = fullfile(orgDir,{listingCDF.name});
loginfoPaths = regexprep(cdfPaths,'\.cdf','-LOG.txt');
datalogPaths = regexprep(cdfPaths,'\.cdf','-DATA.txt');

tmp = load('\\ROOT\projects\GSA_Daysimeter\Federal_Highway\DaysimeterData\fall2\2016-12-13_1345.mat','objArray');
objArray =  tmp.objArray;

% for iFile = numel(loginfoPaths):-1:1
for iFile = 8
    cdfData = daysimeter12.readcdf(cdfPaths{iFile});
    ID = cdfData.GlobalAttributes.subjectID;
    
    thisObj = d12pack.HumanData;
    thisObj.CalibrationPath = calPath;
    thisObj.RatioMethod     = 'newest';
    thisObj.ID              = ID;
    thisObj.Location        = LocObj;
    thisObj.TimeZoneLaunch	= 'America/New_York';
    thisObj.TimeZoneDeploy	= 'America/New_York';
    
    % Import the original data
    thisObj.log_info = thisObj.readloginfo(loginfoPaths{iFile});
    thisObj.data_log = thisObj.readdatalog(datalogPaths{iFile});
    
    % Crop the data
    thisObj = crop(thisObj);
    
    
end

objArray = [objArray;thisObj];

%% Save converted data to file
save(dbPath,'objArray');



clear all
close all
cd ('D:\Acad\GitHub\GlisteningDetection\Data')
%%
dir0        = dir('*_GT.tif');
numFiles    = size(dir0,1);
%%
for k=1:numFiles
    location_GT         = strfind(dir0(k).name,'_GT');
    currentFileGT       = dir0(k).name;
    currentFileData     = dir0(k).name([1:location_GT-1 location_GT+3:end] );
    currentFileGTMat    = strcat(dir0(k).name(1:end-3),'mat');
    
    GTIn                = imread(currentFileGT);
    dataIn              = imread(currentFileData);
    GT_1    = +GTIn(:,:,1)-dataIn(:,:,1);
    GT_2    = GT_1>0;
    GT    = imfill(GT_2,'holes');
    
    %figure(k)
    %imagesc(GT)
    save(currentFileGTMat,'GT');
end
%dataIn      = imread('D:\Acad\GitHub\GlisteningDetection\Data\S2.tif');
%GTIn        = imread('D:\Acad\GitHub\GlisteningDetection\Data\S2_GT.tif');

%%
% channelGT = 1;
% 
% GT_1    = +GTIn(:,:,channelGT)-dataIn(:,:,channelGT);
% GT_2    = GT_1>0;
% GT_3    = imfill(GT_2,'holes');
% imagesc(GT_3)
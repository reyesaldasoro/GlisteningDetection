function  [dataOut,Jacc,HitRate] = segmentationOtsu(dataIn,GT,OtsuT)

if ~exist('OtsuT','var')
    OtsuT = 1.4;
end

%% Take only red channel, filter to remove backgroun
dataIn_2    = (dataIn(:,:,1));
dataIn_3    = imfilter(dataIn_2,gaussF(19,19,1),'replicate');
dataIn_4    = (dataIn_2-dataIn_3);

%%
thresLevel  = 255 *graythresh(dataIn_4);
dataOut     = dataIn_4>OtsuT*thresLevel;


%% Measure Jaccard Index if GT available
if exist('GT','var')
    Jacc = sum(sum(dataOut&GT)) / sum(sum(dataOut|GT));
else
    Jacc = [];
end
%% Hit Rate, how many of the regions are detected, even if small hit
[GT_labelled,numLabels] = bwlabel(GT);
HitNumber               = unique (GT_labelled.*dataOut);
HitRate                 = numel(HitNumber)/numLabels;
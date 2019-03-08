function  [dataOut,Jacc,HitRate] = segmentationAdaptive(dataIn,GT,OtsuT)


if ~exist('OtsuT','var')
    OtsuT = 1.4;
end
%% Take only red channel, filter to remove background
dataIn_2        = (dataIn(:,:,1));
thresLevel      = adaptthresh(dataIn_2, 0.05);
%Convert image to binary image, specifying the threshold value.
dataOut         = imbinarize(dataIn_2,thresLevel*OtsuT);



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

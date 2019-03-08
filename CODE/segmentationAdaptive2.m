function  [dataOut,Jacc,HitRate] = segmentationAdaptive2(dataIn,GT,OtsuT)


if ~exist('OtsuT','var')
    OtsuT = 1.4;
end

%% Take only red channel, filter to remove background
dataIn_2    = (dataIn(:,:,1));

%% Segmentation process

thresLevel      = adaptthresh(dataIn_2, 0.05);
%Convert image to binary image, specifying the threshold value.
dataOut         = imbinarize(dataIn_2,thresLevel*OtsuT);

%Convert image to binary image, with a lower value than the default
dataLowT         = imbinarize(dataIn_2,thresLevel*0.9*OtsuT);
dataLowT_lab       = bwlabel(dataLowT);
dataLowT_R          = regionprops(dataLowT_lab);

% Remove very large regions and dots
dataLotT_filt       = ismember(dataLowT_lab,find(([dataLowT_R.Area]<200)&([dataLowT_R.Area]>1)));
%dataLotT_filt       = ismember(dataLowT_lab,find([dataLowT_R.Area]>1));
dataOut             = dataLotT_filt;

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

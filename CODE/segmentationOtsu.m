function  [dataOut,Jacc,HitRate] = segmentationOtsu(dataIn,GT,OtsuT)

if ~exist('OtsuT','var')
    OtsuT = 1.4;
end
[rows,cols,levs]=size(dataIn);
%% Take only red channel, filter to remove backgroun
dataIn_2    = (dataIn(:,:,1));
dataIn_3    = imfilter(dataIn_2,gaussF(9,9,1),'replicate');
dataIn_4    = (dataIn_2-dataIn_3);

%% Find the threshold


neighSize1 = 2;
neighSize2 = 7;
thresLevel  = 255 *graythresh(dataIn_4(dataIn_4>0));


[dataIn_max,index_max]  = max(dataIn_4(:));
[xmax,ymax]             = ind2sub(size(dataIn),index_max);


max_Neighbourhood1       = dataIn_4(xmax-neighSize1:xmax+neighSize1,ymax-neighSize1:ymax+neighSize1);
max_Neighbourhood2       = dataIn_4(xmax-neighSize2:xmax+neighSize2,ymax-neighSize2:ymax+neighSize2);


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
function  [dataOut,Jacc] = segmentationAdaptive(dataIn,GT)


%% Take only red channel, filter to remove backgroun
dataIn_2    = dataIn(:,:,1);


thresLevel = adaptthresh(dataIn_2, 0.05);
%Convert image to binary image, specifying the threshold value.

dataOut = imbinarize(dataIn_2,thresLevel);



%% Measure Jaccard Index if GT available
if exist('GT','var')
    Jacc = sum(sum(dataOut&GT)) / sum(sum(dataOut|GT));
else
    Jacc = [];
end
function  [dataOut,Jacc] = segmentationPeaks(dataIn,GT)


%% Take only red channel, filter to remove backgroun
dataIn_2    = (dataIn(:,:,1));
% blur to remove background
dataIn_3 = imfilter(dataIn_2,gaussF(19,19,1),'replicate');
dataIn_4 = double(dataIn_2-dataIn_3);

%% find peaks

dataIn_5 = houghpeaks((dataIn_4),200,'Threshold',(0.2*max(dataIn_4(:))));


hold off
imagesc(dataIn)
hold on 
plot(dataIn_5(:,2),dataIn_5(:,1),'s','color','white');
%% Measure Jaccard Index if GT available
if exist('GT','var')
    dataIn_6 = houghpeaks(double(GT),200,'Threshold',0.5);
    plot(dataIn_6(:,2),dataIn_6(:,1),'d','color','red');

    Jacc = sum(sum(dataOut&GT)) / sum(sum(dataOut|GT));
else
    Jacc = [];
end
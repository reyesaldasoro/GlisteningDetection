function  [dataOut,Jacc,HitRate] = segmentationGlistenings(dataIn,GT,OtsuT)


% Usual dimension check
[rows1,cols1,levs]          = size(dataIn);

%% remove the bright sections (if any) at the top or bottom of the image
[a1,S1_1,regionIris]                   = removeIris(dataIn(:,:,1));

%% filter with a median filter to obtain a uniform region
S1_2                        = medfilt2(S1_1,15*[1 1]);
S1_2B                       = medfilt2(a1,15*[1 1]);
%S1_2B                       = imfilter(a1,gaussF(29,29,1),'replicate');
%% Segmentation of the peaks by edges

dataIn_backRemoved          = a1 - S1_2B;
dataIn_waters               = watershed(255-imfilter(dataIn_backRemoved,gaussF(3,3,1),'replicate'));
preliminaryPeaks            = (double(dataIn_backRemoved) .*(dataIn_waters>0));


%edgesData                   = (edge(dataIn_backRemoved,'canny',[],0.5));
%edgesFilled                 = imfill(edgesData,'holes');
 %peaks                      = edgesFilled - edgesData;
%S1_3                        = mean(S1_2);


%% Obtain watershed from a blurred version to find the vertical strips 
S1_4                        =  watershed(imfilter(S1_2,gaussF(39,39,1)))==0;
% Break and remove the horizontal lines
S1_5                        = bwhitmiss(S1_4,ones(3,1));

%% Repeat with the inverse to find the central valley
S1_4B                       =  watershed(imfilter(255-S1_2,gaussF(39,39,1)))==0;
% Break and remove the horizontal lines
S1_5B                       = bwhitmiss(S1_4B,ones(3,1));

%% Dilate to join disjoint sections
dilBox  = ones(11,5);
S1_6 = imdilate(S1_5,dilBox);
S1_6B = imdilate(S1_5B,dilBox);

%% label to find just the two strips
S1_7        = bwlabel(S1_6);    S1_7R      = regionprops(S1_7);
S1_7B       = bwlabel(S1_6B);   S1_7RB      = regionprops(S1_7B);

%% Strips will be the two largest regions
[q1,q2]     = sort([S1_7R.Area],'descend');
S1_8        = ismember(S1_7,q2(1:2));
% Valley will be in between the other two strips
S1_7RB_Cent = [S1_7RB.Centroid];
S1_7RB_Cent = S1_7RB_Cent (1:2:end);
[q3,q4]     = min(abs( S1_7RB_Cent -(0.5*S1_7R(q2(1)).Centroid(1)+0.5*S1_7R(q2(2)).Centroid(1))));
S1_8B       = (S1_7B==q4);

%% Thin to find the central line
S1_9    = bwlabel(bwmorph(S1_8,'thin','inf'));
% Split into left and right and find the distance transform
S1_9L   = bwdist(S1_9==1); 
S1_9R   = bwdist(S1_9==2);

%% Find the intensity drop towards the sides
clear avInt*
avInt_1L(35)        = 0;
avInt_1R(35)        = 0;
for k=1:35
    avInt_1L(k)     = median(a1(S1_9L==k));
    avInt_1R(k)     = median(a1(S1_9R==k));
end

% Find the values towards the end, that will be the extent of the strip
minInt_1L           =  0.5*mean(avInt_1L(end-10:end)) +  0.5*mean(avInt_1L);
minInt_1R           =  0.5*mean(avInt_1R(end-10:end)) +  0.5*mean(avInt_1R);

% Find where the strip ends (width)
posMin_1L            = find(avInt_1L<minInt_1L,1,'first');
posMin_1R            = find(avInt_1R<minInt_1R,1,'first');


%%
% 
% plot(1:35,(avInt_1R),'r',...
%     1:35,(avInt_2R),'k',...
%     1:35,(avInt_3R),'b',...
%     1:35,(avInt_4R),'m',...
%     -1:-1:-35,(avInt_1L),'r',...
%     -1:-1:-35,(avInt_2L),'k',...
%     -1:-1:-35,(avInt_3L),'b',...
%     -1:-1:-35,(avInt_4L),'m')
%     
% grid on 
% axis tight

%% Find the actual strip by thresholding the distance transform
S1_10Left      = (S1_9L<posMin_1L).*(1-regionIris);
% Regions may overlap, ensure this does not happen by removing the first region
% calculated
S1_10Right      = (S1_9R<posMin_1R).*(1-S1_10Left).*(1-regionIris);

%% Find the intermediate region and the others
BackgroundRegions   = bwlabel(1-(S1_10Left|S1_10Right|regionIris));

centralR            = unique(BackgroundRegions.*S1_8B);
centralR(centralR==0)=[];



S1_10Centre           = (BackgroundRegions==centralR);
S1_10Edges          = (BackgroundRegions>0) - S1_10Centre;
%% Proceed to segment but set thresholds per region

data_Edges          = preliminaryPeaks(S1_10Edges>0);
data_Left           = preliminaryPeaks(S1_10Left>0);
data_Centre         = preliminaryPeaks(S1_10Centre>0);
data_Right          = preliminaryPeaks(S1_10Right>0);

data_Edges          = data_Edges(data_Edges>0);
data_Left           = data_Left(data_Left >0);
data_Centre         = data_Centre (data_Centre>0) ;
data_Right          = data_Right(data_Right >0);

data_Edges_S        = sort(data_Edges);
data_Left_S         = sort(data_Left);
data_Centre_S       = sort(data_Centre);
data_Right_S        = sort(data_Right);
data_Edges_N        = numel(data_Edges);
data_Left_N         = numel(data_Left);
data_Centre_N       = numel(data_Centre);
data_Right_N        = numel(data_Right);

levThres            = 0.95;
thres_Edges         = data_Edges_S (round(levThres*data_Edges_N));
thres_Left          = data_Left_S  (round(levThres*data_Left_N));
thres_Centre        = data_Centre_S(round(levThres*data_Centre_N));
thres_Right         = data_Right_S (round(levThres*data_Right_N));

% thres_Edges         = 255 *graythresh(uint8(data_Edges(data_Edges>0)));
% thres_Left          = 255 *graythresh(uint8(data_Left(data_Left >0)));
% thres_Centre        = 255 *graythresh(uint8(data_Centre (data_Centre>0) ));
% thres_Right         = 255 *graythresh(uint8(data_Right(data_Right >0)));

%% Segment and discard small
peaks_Edges          = bwlabel((preliminaryPeaks.*S1_10Edges)>thres_Edges);
peaks_Left           = bwlabel((preliminaryPeaks.*S1_10Left)>thres_Left);
peaks_Centre         = bwlabel((preliminaryPeaks.*S1_10Centre)>thres_Centre);
peaks_Right          = bwlabel((preliminaryPeaks.*S1_10Right)>thres_Right);

peaks_Edges_R       = regionprops(peaks_Edges,preliminaryPeaks,'Area','meanIntensity');
peaks_Left_R        = regionprops(peaks_Left,preliminaryPeaks,'Area','meanIntensity');
peaks_Centre_R      = regionprops(peaks_Centre,preliminaryPeaks,'Area','meanIntensity');
peaks_Right_R       = regionprops(peaks_Right,preliminaryPeaks,'Area','meanIntensity');

minInt_Edges        = std([peaks_Edges_R.MeanIntensity]) +mean([peaks_Edges_R.MeanIntensity]);
minInt_Left         = std([peaks_Left_R.MeanIntensity]) +mean([peaks_Left_R.MeanIntensity]);
minInt_Centre       = std([peaks_Centre_R.MeanIntensity]) +mean([peaks_Centre_R.MeanIntensity]);
minInt_Right        = std([peaks_Right_R.MeanIntensity]) +mean([peaks_Right_R.MeanIntensity]);

minSize             = 15;
% relatively Bright and large
peaks_Edges_2       = ismember(peaks_Edges,find(([peaks_Edges_R.Area]>minSize)&([peaks_Edges_R.MeanIntensity]>minInt_Edges)));
peaks_Left_2       = ismember(peaks_Left,find(([peaks_Left_R.Area]>minSize)&([peaks_Left_R.MeanIntensity]>minInt_Left)));
peaks_Centre_2       = ismember(peaks_Centre,find(([peaks_Centre_R.Area]>minSize)&([peaks_Centre_R.MeanIntensity]>minInt_Centre)));
peaks_Right_2       = ismember(peaks_Right,find(([peaks_Right_R.Area]>minSize)&([peaks_Right_R.MeanIntensity]>minInt_Right)));

minInt_Edges        = 1.5*std([peaks_Edges_R.MeanIntensity]) +mean([peaks_Edges_R.MeanIntensity]);
minInt_Left         = 1.5*std([peaks_Left_R.MeanIntensity]) +mean([peaks_Left_R.MeanIntensity]);
minInt_Centre       = 1.5*std([peaks_Centre_R.MeanIntensity]) +mean([peaks_Centre_R.MeanIntensity]);
minInt_Right        = 1.5*std([peaks_Right_R.MeanIntensity]) +mean([peaks_Right_R.MeanIntensity]);

% very Bright but small
minSize             = 5;
peaks_Edges_3       = ismember(peaks_Edges,find(([peaks_Edges_R.Area]>minSize)&([peaks_Edges_R.MeanIntensity]>minInt_Edges)));
peaks_Left_3        = ismember(peaks_Left,find(([peaks_Left_R.Area]>minSize)&([peaks_Left_R.MeanIntensity]>minInt_Left)));
peaks_Centre_3      = ismember(peaks_Centre,find(([peaks_Centre_R.Area]>minSize)&([peaks_Centre_R.MeanIntensity]>minInt_Centre)));
peaks_Right_3       = ismember(peaks_Right,find(([peaks_Right_R.Area]>minSize)&([peaks_Right_R.MeanIntensity]>minInt_Right)));

allPeaks            =   peaks_Edges_2 + peaks_Left_2 + peaks_Centre_2 + peaks_Right_2 + ...
                        peaks_Edges_3 + peaks_Left_3 + peaks_Centre_3 + peaks_Right_3;
%%
% figure(10)
% subplot(151)
% imagesc(dataIn_backRemoved.*(uint8(S1_10Edges)))
% colorbar
% subplot(152)
% imagesc(dataIn_backRemoved.*(uint8(S1_10Left)))
% colorbar
% subplot(153)
% imagesc(dataIn_backRemoved.*(uint8(S1_10Centre)))
% colorbar
% subplot(154)
% imagesc(dataIn_backRemoved.*(uint8(S1_10Right)))
% colorbar
% subplot(155)
% imagesc(dataIn)
%%
% figure(11)
% subplot(151)
% imagesc(peaks_Edges)
% colorbar
% subplot(152)
% imagesc(peaks_Left)
% colorbar
% subplot(153)
% imagesc(peaks_Centre)
% colorbar
% subplot(154)
% imagesc(peaks_Right)
% colorbar
% 
% 
% colormap jet

dataOut         = dataIn;
dataOut(:,:,2) = dataOut(:,:,2) +38.71793*uint8(allPeaks);


%%
figure
subplot(161)
imagesc(dataOut.*repmat(uint8(S1_10Edges),[1 1 3]))
subplot(162)
imagesc(dataOut.*repmat(uint8(S1_10Left),[1 1 3]))
subplot(163)
imagesc(dataOut.*repmat(uint8(S1_10Centre),[1 1 3]))
subplot(164)
imagesc(dataOut.*repmat(uint8(S1_10Right),[1 1 3]))
subplot(165)
imagesc(dataOut)
subplot(166)
imagesc(bwlabel(allPeaks))

 set(gcf,'position',[100 400 1000 500])
 qqq=1;
%% Display
% figure
% S1B = dataIn;
% S1B(:,:,2) = S1B(:,:,2) +38.71793*uint8(S1_10Left+S1_10Right);
% S1B(:,:,1) = S1B(:,:,1) +38.71793*uint8(regionIris);
% S1B(S1B>255) = 255;
% %imagesc(S1_1+25*uint8(S1_10Left+S1_10Right))
% %colormap jet
% imagesc(S1B)
% axis equal
% axis([1 cols1 1 rows1])
% set(gca,'position',[0 0 1 1 ]);axis off
% set(gcf,'position',[10 10 10+cols1 10+rows1])
% 




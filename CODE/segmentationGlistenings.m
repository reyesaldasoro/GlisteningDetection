function  [dataOut,Jacc,HitRate] = segmentationGlistenings(dataIn,GT,OtsuT)


% Usual dimension check
[rows1,cols1,levs]          = size(dataIn);

%% remove the bright sections (if any) at the top or bottom of the image
[a1,S1_1,regionIris]                   = removeIris(dataIn(:,:,1));

%% filter with a median filter to obtain a uniform region
S1_2                        = medfilt2(S1_1,15*[1 1]);

%% obtain the mean of the filtered version
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
S1_10L      = (S1_9L<posMin_1L);
S1_10R      = (S1_9R<posMin_1R);

%% Display
figure
S1B = dataIn;
S1B(:,:,2) = S1B(:,:,2) +38.71793*uint8(S1_10L+S1_10R);
S1B(:,:,1) = S1B(:,:,1) +38.71793*uint8(regionIris);
S1B(S1B>255) = 255;
%imagesc(S1_1+25*uint8(S1_10L+S1_10R))
%colormap jet
imagesc(S1B)
axis equal
axis([1 cols1 1 rows1])
set(gca,'position',[0 0 1 1 ]);axis off
set(gcf,'position',[10 10 10+cols1 10+rows1])





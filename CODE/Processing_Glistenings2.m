
clear
S1 =imread('/Users/ccr22/Academic/GitHub/GlisteningDetection/Data/S1.tif');
S2 =imread('/Users/ccr22/Academic/GitHub/GlisteningDetection/Data/S2.tif');
S3 =imread('/Users/ccr22/Academic/GitHub/GlisteningDetection/Data/S3.tif');
S4 =imread('/Users/ccr22/Academic/GitHub/GlisteningDetection/Data/S4.tif');
%%
[rows1,cols1,levs]=size(S1);
[rows2,cols2,levs]=size(S2);
[rows3,cols3,levs]=size(S3);
[rows4,cols4,levs]=size(S4);

%%
[a1,S1_1] = removeIris(S1(:,:,1));
[a2,S2_1] = removeIris(S2(:,:,1));
[a3,S3_1] = removeIris(S3(:,:,1));
[a4,S4_1] = removeIris(S4(:,:,1));


%%
S1_2 = medfilt2(S1_1,15*[1 1]);
S2_2 = medfilt2(S2_1,15*[1 1]);
S3_2 = medfilt2(S3_1,15*[1 1]);
S4_2 = medfilt2(S4_1,15*[1 1]);

%%
S1_3 = mean(S1_2);
S2_3 = mean(S2_2);
S3_3 = mean(S3_2);
S4_3 = mean(S4_2);

%%
S1_4 =  watershed(imfilter(S1_2,gaussF(39,39,1)))==0;
S2_4 =  watershed(imfilter(S2_2,gaussF(39,39,1)))==0;
S3_4 =  watershed(imfilter(S3_2,gaussF(39,39,1)))==0;
S4_4 =  watershed(imfilter(S4_2,gaussF(39,39,1)))==0;

S1_5 = bwhitmiss(S1_4,ones(3,1));
S2_5 = bwhitmiss(S2_4,ones(3,1));
S3_5 = bwhitmiss(S3_4,ones(3,1));
S4_5 = bwhitmiss(S4_4,ones(3,1));
%%
S1_4B =  watershed(imfilter(255-S1_2,gaussF(39,39,1)))==0;
S2_4B =  watershed(imfilter(255-S2_2,gaussF(39,39,1)))==0;
S3_4B =  watershed(imfilter(255-S3_2,gaussF(39,39,1)))==0;
S4_4B =  watershed(imfilter(255-S4_2,gaussF(39,39,1)))==0;
S1_5B = bwhitmiss(S1_4B,ones(3,1));
S2_5B = bwhitmiss(S2_4B,ones(3,1));
S3_5B = bwhitmiss(S3_4B,ones(3,1));
S4_5B = bwhitmiss(S4_4B,ones(3,1));
%%
% S1_5 = bwmorph(S1_4,'branchpoints');
% S2_5 = bwmorph(S2_4,'branchpoints');
% S3_5 = bwmorph(S3_4,'branchpoints');
% S4_5 = bwmorph(S4_4,'branchpoints');

dilBox  = ones(11,5);

S1_6 = imdilate(S1_5,dilBox);
S2_6 = imdilate(S2_5,dilBox);
S3_6 = imdilate(S3_5,dilBox);
S4_6 = imdilate(S4_5,dilBox);
S1_6B = imdilate(S1_5B,dilBox);
S2_6B = imdilate(S2_5B,dilBox);
S3_6B = imdilate(S3_5B,dilBox);
S4_6B = imdilate(S4_5B,dilBox);

%%
S1_7 = bwlabel(S1_6);S1_7R = regionprops(S1_7);
S2_7 = bwlabel(S2_6);S2_7R = regionprops(S2_7);
S3_7 = bwlabel(S3_6);S3_7R = regionprops(S3_7);
S4_7 = bwlabel(S4_6);S4_7R = regionprops(S4_7);
S1_7B = bwlabel(S1_6B);S1_7RB = regionprops(S1_7B);
S2_7B = bwlabel(S2_6B);S2_7RB = regionprops(S2_7B);
S3_7B = bwlabel(S3_6B);S3_7RB = regionprops(S3_7B);
S4_7B = bwlabel(S4_6B);S4_7RB = regionprops(S4_7B);



%%
[q1,q2]=sort([S1_7R.Area],'descend');
S1_8 = ismember(S1_7,q2(1:2));
S1_7RB_Cent = [S1_7RB.Centroid];
S1_7RB_Cent  = S1_7RB_Cent (1:2:end);
[q3,q4] = min(abs( S1_7RB_Cent -(0.5*S1_7R(q2(1)).Centroid(1)+0.5*S1_7R(q2(2)).Centroid(1))));
S1_8B = (S1_7B==q4);


[q1,q2]=sort([S2_7R.Area],'descend');
S2_8 = ismember(S2_7,q2(1:2));
S2_7RB_Cent = [S2_7RB.Centroid];
S2_7RB_Cent  = S2_7RB_Cent (1:2:end);
[q3,q4] = min(abs( S2_7RB_Cent -(0.5*S2_7R(q2(1)).Centroid(1)+0.5*S2_7R(q2(2)).Centroid(1))));
S2_8B = (S2_7B==q4);


[q1,q2]=sort([S3_7R.Area],'descend');
S3_8 = ismember(S3_7,q2(1:2));
S3_7RB_Cent = [S3_7RB.Centroid];
S3_7RB_Cent  = S3_7RB_Cent (1:2:end);
[q3,q4] = min(abs( S3_7RB_Cent -(0.5*S3_7R(q2(1)).Centroid(1)+0.5*S3_7R(q2(2)).Centroid(1))));
S3_8B = (S3_7B==q4);


[q1,q2]=sort([S4_7R.Area],'descend');
S4_8 = ismember(S4_7,q2(1:2));



S4_7RB_Cent = [S4_7RB.Centroid];
S4_7RB_Cent  = S4_7RB_Cent (1:2:end);
[q3,q4] = min(abs( S4_7RB_Cent -(0.5*S4_7R(q2(1)).Centroid(1)+0.5*S4_7R(q2(2)).Centroid(1))));
S4_8B = (S4_7B==q4);

%%
S1_9    = bwlabel(bwmorph(S1_8,'thin','inf'));
S2_9    = bwlabel(bwmorph(S2_8,'thin','inf'));
S3_9    = bwlabel(bwmorph(S3_8,'thin','inf'));
S4_9    = bwlabel(bwmorph(S4_8,'thin','inf'));

S1_9L   = bwdist(S1_9==1); S1_9R   = bwdist(S1_9==2);
S2_9L   = bwdist(S2_9==1); S2_9R   = bwdist(S2_9==2);
S3_9L   = bwdist(S3_9==1); S3_9R   = bwdist(S3_9==2);
S4_9L   = bwdist(S4_9==1); S4_9R   = bwdist(S4_9==2);

%%
clear avInt*
for k=1:35
    avInt_1L(k)     = median(a1(S1_9L==k));
    avInt_1R(k)     = median(a1(S1_9R==k));
    avInt_2L(k)     = median(a2(S2_9L==k));
    avInt_2R(k)     = median(a2(S2_9R==k));
    avInt_3L(k)     = median(a3(S3_9L==k));
    avInt_3R(k)     = median(a3(S3_9R==k));
    avInt_4L(k)     = median(a4(S4_9L==k));
    avInt_4R(k)     = median(a4(S4_9R==k));
end

minInt_1L           =  0.5*mean(avInt_1L(end-10:end)) +  0.5*mean(avInt_1L);
minInt_1R           =  0.5*mean(avInt_1R(end-10:end)) +  0.5*mean(avInt_1R);
minInt_2L           =  0.5*mean(avInt_2L(end-10:end)) +  0.5*mean(avInt_2L);
minInt_2R           =  0.5*mean(avInt_2R(end-10:end)) +  0.5*mean(avInt_2R);
minInt_3L           =  0.5*mean(avInt_3L(end-10:end)) +  0.5*mean(avInt_3L);
minInt_3R           =  0.5*mean(avInt_3R(end-10:end)) +  0.5*mean(avInt_3R);
minInt_4L           =  0.5*mean(avInt_4L(end-10:end)) +  0.5*mean(avInt_4L);
minInt_4R           =  0.5*mean(avInt_4R(end-10:end)) +  0.5*mean(avInt_4R);

posMin_1L            = find(avInt_1L<minInt_1L,1,'first');
posMin_1R            = find(avInt_1R<minInt_1R,1,'first');
posMin_2L            = find(avInt_2L<minInt_2L,1,'first');
posMin_2R            = find(avInt_2R<minInt_2R,1,'first');
posMin_3L            = find(avInt_3L<minInt_3L,1,'first');
posMin_3R            = find(avInt_3R<minInt_3R,1,'first');
posMin_4L            = find(avInt_4L<minInt_4L,1,'first');
posMin_4R            = find(avInt_4R<minInt_4R,1,'first');





%%

plot(1:35,(avInt_1R),'r',...
    1:35,(avInt_2R),'k',...
    1:35,(avInt_3R),'b',...
    1:35,(avInt_4R),'m',...
    -1:-1:-35,(avInt_1L),'r',...
    -1:-1:-35,(avInt_2L),'k',...
    -1:-1:-35,(avInt_3L),'b',...
    -1:-1:-35,(avInt_4L),'m')
    
grid on 
axis tight

%%
S1_10L      = (S1_9L<posMin_1L);
S1_10R      = (S1_9R<posMin_1R);
S2_10L      = (S2_9L<posMin_2L);
S2_10R      = (S2_9R<posMin_2R);
S3_10L      = (S3_9L<posMin_3L);
S3_10R      = (S3_9R<posMin_3R);
S4_10L      = (S4_9L<posMin_4L);
S4_10R      = (S4_9R<posMin_4R);



%%

% [pks_1,locPeak_1] = findpeaks(S1_3,'MinPeakDistance',cols/4,'SortStr','descend');
% [pks_2,locPeak_2] = findpeaks(S2_3,'MinPeakDistance',cols/4,'SortStr','descend');
% [pks_3,locPeak_3] = findpeaks(S3_3,'MinPeakDistance',cols/4,'SortStr','descend');
% [pks_4,locPeak_4] = findpeaks(S4_3,'MinPeakDistance',cols/4,'SortStr','descend');
% 
% 
% 
% locPeak_1 = sort(locPeak_1(1:2)); pks_1 = pks_1(1:2);
% locPeak_2 = sort(locPeak_2(1:2)); pks_2 = pks_2(1:2);
% locPeak_3 = sort(locPeak_3(1:2)); pks_3 = pks_3(1:2);
% locPeak_4 = sort(locPeak_4(1:2)); pks_4 = pks_4(1:2);
% %
% 
% [val_1,locVal_1] = findpeaks(-S1_3(locPeak_1(1):locPeak_1(2)),'MinPeakDistance',cols/4,'SortStr','descend');
% [val_2,locVal_2] = findpeaks(-S2_3(locPeak_2(1):locPeak_3(2)),'MinPeakDistance',cols/4,'SortStr','descend');
% [val_3,locVal_3] = findpeaks(-S3_3(locPeak_3(1):locPeak_3(2)),'MinPeakDistance',cols/4,'SortStr','descend');
% [val_4,locVal_4] = findpeaks(-S4_3(locPeak_4(1):locPeak_4(2)),'MinPeakDistance',cols/4,'SortStr','descend');
% 
% locVal_1 = locVal_1(1) + locPeak_1(1);
% locVal_2 = locVal_2(1) + locPeak_2(1);
% locVal_3 = locVal_3(1) + locPeak_3(1);
% locVal_4 = locVal_4(1) + locPeak_4(1);
% 
% %
% figure(5)
% %
% imagesc((imfilter(S2(250:950,:,1),gaussF(15,15,1))))
% imagesc((medfilt2(S4_1(:,:,1),15*[1 1])))
%%

figure(1)
S1B = S1;
S1B(:,:,2) = S1B(:,:,2) +38.71793*uint8(S1_10L+S1_10R);
S1B(S1B>255) = 255;
%imagesc(S1_1+25*uint8(S1_10L+S1_10R))
%colormap jet

imagesc(S1B)


figure(2)
S2B = S2;
S2B(:,:,2) = S2B(:,:,2) +33.15995*uint8(S2_10L+S2_10R);
S2B(S2B>255) = 255;

imagesc(S2B)
%imagesc(S2_1+25*uint8(S2_10L+S2_10R))
%colormap jet

figure(3)
S3B = S3;
S3B(:,:,2) = S3B(:,:,2) +38.71793*uint8(S3_10L+S3_10R);
S3B(S3B>255) = 255;
%imagesc(S3_1+25*uint8(S3_10L+S3_10R))
%colormap jet

imagesc(S3B)

figure(4)
S4B = S4;
S4B(:,:,2) = S4B(:,:,2) +38.71793*uint8(S4_10L+S4_10R);
S4B(S4B>255) = 255;
%imagesc(S4+repmat(25*uint8(S4_10L+S4_10R),[1 1 3]))
%colormap jet

imagesc(S4B)



%%
%imagesc(edge(S2(:,:,1),'canny',[],5))
figure(1)
plot(1:cols,S1_3,'b',locPeak_1,S1_3(locPeak_1(1:2)),'rx',locVal_1,S1_3(locVal_1),'mo')
figure(2)
plot(1:cols,S2_3,'b',locPeak_2,S2_3(locPeak_2(1:2)),'rx',locVal_2,S2_3(locVal_2),'mo')
figure(3)
plot(1:cols,S3_3,'b',locPeak_3,S3_3(locPeak_3(1:2)),'rx',locVal_3,S3_3(locVal_3),'mo')
figure(4)
plot(1:cols,S4_3,'b',locPeak_4,S4_3(locPeak_4(1:2)),'rx',locVal_4,S4_3(locVal_4),'mo')



%%


figure(1)
hold off
imagesc(S1_2)
hold on
plot([locPeak_1(1) locPeak_1(1)],[1 rows1],'w')
plot([locPeak_1(2) locPeak_1(2)],[1 rows1],'w')
plot([locVal_1 locVal_1],[1 rows1],'y')
colorbar
colormap(jet)

figure(2)
hold off
imagesc(S2_2)
hold on
plot([locPeak_2(1) locPeak_2(1)],[1 rows2],'w')
plot([locPeak_2(2) locPeak_2(2)],[1 rows2],'w')
plot([locVal_2 locVal_2],[1 rows2],'y')
colorbar
colormap(jet)

figure(3)
hold off
imagesc(S3_2)
hold on
plot([locPeak_3(1) locPeak_3(1)],[1 rows3],'w')
plot([locPeak_3(2) locPeak_3(2)],[1 rows3],'w')
plot([locVal_3 locVal_3],[1 rows3],'y')
colorbar
colormap(jet)

figure(4)
hold off
imagesc(S4_2)
hold on
plot([locPeak_4(1) locPeak_4(1)],[1 rows4],'w')
plot([locPeak_4(2) locPeak_4(2)],[1 rows4],'w')
plot([locVal_4 locVal_4],[1 rows4],'y')
colorbar
colormap(jet)



%%
 imagesc(S4_2)





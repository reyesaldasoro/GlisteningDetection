



clear all
close all
clc
baseDir = ('D:\Acad\GitHub\GlisteningDetection\Data\');
%%
dir0        = dir(strcat(baseDir,'*_GT.tif'));
numFiles    = size(dir0,1);
for TT=0.8:0.1:6
    disp(TT)
for k=1%:numFiles
    location_GT         = strfind(dir0(k).name,'_GT');
    currentFileGT       = dir0(k).name;
    currentFileData     = dir0(k).name([1:location_GT-1 location_GT+3:end] );
    currentFileGTMat    = strcat(dir0(k).name(1:end-3),'mat');
    
    GTData                  = load(strcat(baseDir,currentFileGTMat),'GT');
    GT                  = GTData.GT;
    dataIn              = imread(strcat(baseDir,currentFileData));
    
    [dataOut1,Jacc1(round(10*TT),k),HitRate1]  = segmentationOtsu(dataIn,GT,TT);
    [dataOut2,Jacc2(round(10*TT),k),HitRate2]  = segmentationAdaptive(dataIn,GT,TT);
    [dataOut3,Jacc3(round(10*TT),k),HitRate3]  = segmentationAdaptive2(dataIn,GT,TT);
    [dataOut4,Jacc4(round(10*TT),k),HitRate4]  = segmentationOtsu(removeIris(dataIn(:,:,1)),GT,TT);
    [dataOut5,Jacc5(round(10*TT),k),HitRate5]  = segmentationAdaptive(removeIris(dataIn(:,:,1)),GT,TT);
    [dataOut6,Jacc6(round(10*TT),k),HitRate6]  = segmentationAdaptive2(removeIris(dataIn(:,:,1)),GT,TT);    
    
    %OtsuJaccards(k) = Jacc;
%     subplot(2,4,k) 
%     imagesc(dataOut+2*GT)   
%     title(strcat('Jacc =',num2str(Jacc,3)))
    %AdaptJaccards(k) = Jacc;
    %AdaptHits(k)    = HitRate;
%     subplot(2,4,k+4) 
%     imagesc(dataOut+2*GT)
%     title(strcat('Jacc =',num2str(Jacc,3)))
    %Adapt2Jaccards(k) = Jacc;
    %Adapt2Hits(k)    = HitRate;
    
end

%
% res(round(10*TT),1) = mean(OtsuJaccards) ;
% res(round(10*TT),2) = mean(AdaptJaccards) ;
% res(round(10*TT),3) = mean(AdaptHits) ;
% res(round(10*TT),4) = mean(Adapt2Jaccards) ;
% res(round(10*TT),5) = mean(Adapt2Hits) ;

end
%%
ttt=[4 ];
plot(1:60,mean(Jacc1(:,ttt),2),'r',...
    1:60,mean(Jacc2(:,ttt),2),'b',...
    1:60,mean(Jacc3(:,ttt),2),'k',...
    1:60,mean(Jacc4(:,ttt),2),'m',...
    1:60,mean(Jacc5(:,ttt),2),'c',...
    1:60,mean(Jacc6(:,ttt),2),'g');
legend
grid on;axis tight
% dataIn_1 = imread('D:\OneDrive - City, University of London\Acad\Research\ChrisHULL\RE__Ophthalmic_IP_problem\S1.tif');
% 
% %%
% imagesc(dataIn_1(70:738,:,:))
% colorbar
% %%
% imagesc(dataIn_4) 
% 
% colorbar
% 
% 
% %%
% %dataIn_2 = dataIn(70:738,:,1);
% dataIn_2 = dataIn(:,:,1);
% %dataIn_2([1:70 738:end],:,1)=0;
% dataIn_3 = imfilter(dataIn_2,gaussF(19,19,1),'replicate');
% %%
% 
% dataIn_4 = (dataIn_2-dataIn_3);
% dataIn_5 = (dataIn_4/max(dataIn_4(:)));
% %%
% 
% se = strel('disk',4);
% dataIn_2 = imtophat(dataIn,se);
% dataIn_3 = rgb2gray(dataIn_2);
% %dataIn_4 = double(imfilter(dataIn_3(70:738,:,:),gaussF(3,3,1),'replicate'));
% dataIn_4 = double(imfilter(dataIn_3,gaussF(3,3,1),'replicate'));
% imagesc(dataIn_4)
% colorbar
% 
% 
% %%
% 
% dataIn_5 = houghpeaks((dataIn_4),55,'Threshold',0.1*max(dataIn_4(:)));
% %%
% hold off
% imagesc(dataIn_4)
% hold on 
% plot(dataIn_5(:,2),dataIn_5(:,1),'s','color','white');
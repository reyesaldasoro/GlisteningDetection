
dataIn_1 = imread('D:\OneDrive - City, University of London\Acad\Research\ChrisHULL\RE__Ophthalmic_IP_problem\S1.tif');

%%
imagesc(dataIn_1(70:738,:,:))
colorbar
%%
imagesc(dataIn_4)
colorbar


%%
dataIn_2 = dataIn(70:738,:,1);
dataIn_3 = imfilter(dataIn_2,gaussF(19,19,1),'replicate');
%%

dataIn_4 = (dataIn_2-dataIn_3);
dataIn_5 = (dataIn_4/max(dataIn_4(:)));
%%

se = strel('disk',4);
dataIn_2 = imtophat(dataIn_1,se);
dataIn_3 = rgb2gray(dataIn_2);
dataIn_4 = double(imfilter(dataIn_3(70:738,:,:),gaussF(3,3,1),'replicate'));
imagesc(dataIn_4)
colorbar


%%

dataIn_5 = houghpeaks((dataIn_4),55,'Threshold',0.1*max(dataIn_4(:)));

hold off
imagesc(dataIn_1)
hold on 
plot(dataIn_5(:,2),71+dataIn_5(:,1),'s','color','white');
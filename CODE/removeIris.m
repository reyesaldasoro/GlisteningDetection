function  [dataOut] = removeIris(dataIn)



%% Dimensions
[rows,cols,levs]    = size(dataIn); 
midRows             = floor(rows/2);
%% Take only red channel, filter to remove background
dataIn_2        = dataIn(:,:,1);

%% First, check the Iris has been removed, this is manifest with higher
% levels at the edges than the centre.
dataIn_3        = mean(dataIn_2,2);
topInt          = mean(dataIn_3(1:round(rows/10)));
topMidInt       = mean(dataIn_3(round(0.25*rows:midRows)));
botMidInt       = mean(dataIn_3(round(midRows+1:0.75*rows)));
bottomInt       = mean(dataIn_3(end-round(rows/10):end));
% if top and bottom are much larger than centre, it was not properly
% segmented. Remove top and bottom
if (0.7*(topInt))>topMidInt
    % Find edges top and bottom
    limitTop    =5+ 30+find(dataIn_3(31:midRows)<((topInt+topMidInt)/2),1,'first');
    %disp(strcat('Remove first ',32,num2str(limitTop),' rows'))
    dataIn_2(1:limitTop,:) = 0;
end
if (0.7*(bottomInt))>botMidInt
    % Find edges top and bottom
    limitBot    =-5+ midRows+ find(dataIn_3(midRows:end)>((botMidInt+bottomInt)/2),1,'first');
    %disp(strcat('Remove last ',32,num2str(rows-limitBot),' rows'))
    dataIn_2(limitBot:end,:) = 0;
end
%clf
%imagesc([dataIn(:,:,1) dataIn_2])

dataOut = dataIn2;

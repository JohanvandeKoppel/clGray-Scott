clear all; clc;
on=1; off=0;

Movie = off;
PlotAll=on;

BarFontSize      = 18;
TitleFontSize    = 24;

FID=fopen('output.dat', 'r');

X=fread(FID, 1, 'int32');
Y=fread(FID, 1, 'int32');
Length=fread(FID, 1, 'float');
NumFrames=fread(FID, 1, 'int32');
EndTime=fread(FID, 1, 'int32');

W=zeros(X,Y,'double');
N=zeros(X,Y,'double');

% Get Screen dimensions and set Main Window Dimensions
x = get(0,'ScreenSize'); ScreenDim=x(3:4);
MainWindowDim=floor(ScreenDim.*[0.9 0.8]);

if Movie==on,
    writerObj = VideoWriter('Gray-Scott.mp4', 'MPEG-4');
    open(writerObj);
end;

if PlotAll==on,
    MainWindowDim=[1920 818];
else
    MainWindowDim=[960 720];
end;

% The graph window is initiated, with specified dimensions.
Figure1=figure('Position',[(ScreenDim-MainWindowDim)/2 MainWindowDim],...
               'Color', 'white');

if PlotAll==on, 
    subplot('position',[0.02 0.10 0.45 0.80]);
end;
F1=imagesc(N',[0 0.4]);
title('Substance V','FontSize',TitleFontSize);  
colorbar('SouthOutside','FontSize',BarFontSize); 
colormap('default'); axis image;axis off;

if PlotAll==on,
    subplot('position',[0.52 0.10 0.45 0.80]);
    F2=imagesc(W',[0 1]);
    title('Substance U','FontSize',TitleFontSize);  
    colorbar('SouthOutside','FontSize',BarFontSize);
    axis image; axis off; 
end

for x=1:NumFrames,
    W = reshape(fread(FID,X*Y,'float32'),X,Y);
    N = reshape(fread(FID,X*Y,'float32'),X,Y);

    set(F1,'CData',N');
    if PlotAll==on,
        set(F2,'CData',W');
    end;
    set(Figure1,'Name',['Timestep ' num2str(ceil(x/NumFrames*EndTime)) ' of ' num2str(EndTime)]); 

    drawnow; 
    
    if Movie==on,
         frame = getframe(Figure1);
         writeVideo(writerObj,frame);
    end

end;

fclose(FID);

if Movie==on,
    close(writerObj);
end;

disp('Done');beep;



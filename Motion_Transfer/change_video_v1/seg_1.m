clc;
clear;
utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
    'html', 'KinectForWindows');
addpath(utilpath);
fnum = 150;
filename='Dataset_v1/Gaurav_1'; % File name for video and also data file

pause(5);
%% Code starts
% create video object
combinedStr = strcat(filename,'.mp4');
vidObj = VideoWriter(combinedStr,'MPEG-4');
vidObj.Quality = 100;
vidObj.FrameRate = 10;

combinedStr2 = strcat(filename,'_no_skel.mp4');
vidObj2 = VideoWriter(combinedStr2,'MPEG-4');
vidObj2.Quality = 100;
vidObj2.FrameRate = 10;

vid1 = videoinput('kinect',1);
vid2 = videoinput('kinect',2);
srcDepth = getselectedsource(vid2);
set(srcDepth, 'TrackingMode', 'Skeleton')
set(srcDepth, 'BodyPosture', 'Standing')

vid1.FramesPerTrigger = 1;
vid2.FramesPerTrigger = 1;
vid1.TriggerRepeat = fnum;
vid2.TriggerRepeat = fnum;
triggerconfig([vid1 vid2],'manual');
start([vid1 vid2]);

% Trigger 200 times to get the frames.

All_img={};
All_meta={};
All_depth = {};

for i = 1:fnum+1
    trigger([vid1 vid2])
    
    % Get the acquired frames and metadata.
    [imgColor, ts_color, metaData_color] = getdata(vid1);
    [imgDepth, ts_depth, metaData_Depth] = getdata(vid2);
    All_img{i} = imgColor;
    All_meta{i} = metaData_Depth;
    All_depth{i} = imgDepth;
     if any(metaData_Depth.IsPositionTracked)~=0
        figure(1),imshow(imgColor);
     end
end

stop([vid1 vid2]);
close all;

%% Data captured now plot
disp('Continue');
waitforbuttonpress;

open(vidObj);
open(vidObj2);
Data_file = {};
[r,c,d] = size(All_img{1});              %# Get the image size
mask = All_img{1};


start = 1;
for i=1:fnum+1
    metaData_Depth = All_meta{i};
    imgColor = All_img{i};
    if any(metaData_Depth.IsPositionTracked)~=0
        skl=find(metaData_Depth.IsPositionTracked);
        jointIndices = metaData_Depth.JointDepthIndices(:, :, skl(1));
        jointCoordinates = metaData_Depth.JointWorldCoordinates(:, :, skl(1));
        nSkeleton = length(1);
        
        
        [alignedFlippedImage,flippedDepthImage] = alignColorToDepth(All_depth{i},imgColor,vid2);
        imgColor = fliplr(alignedFlippedImage);
        writeVideo(vidObj2, imgColor);
        % Find segmented imgColor 
        for m=1:r
            for n=1:c
                if(metaData_Depth.SegmentationData(m,n)==0)
                    imgColor(m,n,1)=0;
                    imgColor(m,n,2)=0;
                    imgColor(m,n,3)=0;
                end
            end
        end
        [SKDATA,r,c,d] = skeletonViewer(jointIndices, imgColor, nSkeleton);
        
        Data_file{start} = SKDATA;
        start = start+1;
        set(gcf,'Units','pixels','Position',[200 200 c r]);  %# Modify figure size
        writeVideo(vidObj, getframe(gcf));
       
        
    end
   
end
close(vidObj);
close(vidObj2);
save(filename,'Data_file');
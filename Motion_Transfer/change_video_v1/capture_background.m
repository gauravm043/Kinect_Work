clc;
clear;
utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
    'html', 'KinectForWindows');
addpath(utilpath);
fnum = 10;
filename='Dataset_v1/Gaurav_1_background.jpg';

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

for i = 1:fnum+1
    trigger([vid1 vid2])
    
    % Get the acquired frames and metadata.
    [imgColor, ts_color, metaData_color] = getdata(vid1);
    [imgDepth, ts_depth, metaData_Depth] = getdata(vid2);
     if any(metaData_Depth.IsPositionTracked)==0
        figure(1),imshow(imgColor);
        [alignedFlippedImage,flippedDepthImage] = alignColorToDepth(imgDepth,imgColor,vid2);
        imgColor = fliplr(alignedFlippedImage);
        imwrite(imgColor, filename);
     end
end
stop([vid1 vid2]);
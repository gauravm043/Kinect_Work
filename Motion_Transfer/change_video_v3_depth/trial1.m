clc;
clear;
utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
    'html', 'KinectForWindows');
addpath(utilpath);
fnum = 200;
filename='trial_1'; % File name for video and also data file

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


for i = 1:fnum+1
    trigger([vid1 vid2])
    
    % Get the acquired frames and metadata.
    [imgColor, ts_color, metaData_color] = getdata(vid1);
    [imgDepth, ts_depth, metaData_Depth] = getdata(vid2);
    
%      if any(metaData_Depth.IsPositionTracked)~=0
        figure(1),imshow(imgDepth);
%      end
end

stop([vid1 vid2]);
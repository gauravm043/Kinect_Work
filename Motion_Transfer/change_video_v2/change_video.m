% clc;
% clear all;
% close all;
%% Align Infile with Source
Infile= './Dataset_v2/Vinit_2';
Sourcefile = './Dataset_v2/Gaurav_1';


%% Loading Data
bg_file = './Dataset_v2/Gaurav_1_background.jpg';
load(Infile);
Input_skel = Data_file;
load(Sourcefile);
Source_skel = Data_file;
% % % % load(strcat(Infile,'_depth'));
% % % % In_depth = Depth_data;
Input_video = strcat(Infile, '.mp4');
Source_video = strcat(Sourcefile, '.mp4');
%% Converting to vector
Source_vec = {};
n = size(Source_skel,2);
for i=1:n
    if strcmp(Source_skel{i}, 'NULL')
        Source_vec{i} = 'NULL';
        continue;
    end
    Source_vec{i} = convert_it(Source_skel{i});
end

Input_vec = {};
n = size(Input_skel,2);
for i=1:n
    if strcmp(Input_skel{i}, 'NULL')
        Input_vec{i} = 'NULL';
        continue;
    end
    Input_vec{i} = convert_it(Input_skel{i});
end

%% Find mapping for matching source frame to Input frame
MAP = find_mapping(Source_vec, Input_vec);
n = size(MAP, 2);

Source_Obj = VideoReader(Source_video);
Input_Obj = VideoReader(Input_video);
vidObj = VideoWriter('new_output3.mp4','MPEG-4');
vidObj.Quality = 100;
vidObj.FrameRate = 10;

% open(vidObj);
% Inportant to set MAP(1) = -1;
p = imread(bg_file);
MAP(1) = -1;
for i = 67:100
    if MAP(i) < 0
        continue;
    end
    S1 = read(Source_Obj,i);
    I1 = read(Input_Obj,MAP(i));
    New_A = align_me(Input_skel{MAP(i)}, Source_skel{i});
    I2 = I1;   
    I2 = construct_skeleton(Input_skel{MAP(i)}, New_A, Input_skel{MAP(i)},I1,I1,I1);
    close all;
   figure(1),imshow(S1);

   figure(2), imshow(I1);
   figure(3), imshow(I2);
%     writeVideo(vidObj, I2);
%    waitforbuttonpress;  
        break;
%  pause(1);
   
end
% close(vidObj);

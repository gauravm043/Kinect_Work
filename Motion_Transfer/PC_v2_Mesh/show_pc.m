clc;
clear all;
close all;

%% Map of bones
SkeletonConnectionMap = [[1 2]; % Spine
    [2 3];
    [3 4];
    [3 5]; %Left Hand
    [5 6];
    [6 7];
    [7 8];
    [3 9]; %Right Hand
    [9 10];
    [10 11];
    [11 12];
    [1 17]; % Right Leg
    [17 18];
    [18 19];
    [19 20];
    [1 13]; % Left Leg
    [13 14];
    [14 15];
    [15 16]];

colors = [[1 1 0];[0 0 0];[0 0 1];[0 1 0];[0 1 1];[1 0 0];[1 0 1];[0.67 0.15 0.31];[0.9412 0.4706 0];[0.251 0 0.502]	;[0.502 0.251 0];[0 0.251 0];[0.502 0.502 0.502];[0.502 0.502 1];[0 0.502 0.502];[0.502 0 0];[1 0.502 0.502];[.7 .2 .2];[.2 .7 .2]];

%% Align Infile with Source
Infile= './Dataset_v1/Gaurav_1';
Sourcefile = './Dataset_v1/Gaurav_2';

load('./Camera_Settings/kinect_camera');
Input_camera = vid2;

%% Loading Data
load(Infile);
Input_skel = Data_file;
load(Sourcefile);
Source_skel = Data_file;

load(strcat(Infile,'_depth'));
In_depth = Depth_data;
load(strcat(Sourcefile,'_depth'));
Source_depth = Depth_data;


Input_video = strcat(Infile, '.mp4');
Source_video = strcat(Sourcefile, '.mp4');

%% Find mapping for matching source frame to Input frame
%Converting to vector
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
MAP(1) = -1;

% Try on 100th and 85th/80th frame of Gaurav_2 for body parts identification
% on 5th and 6th frame of Gaurav_1

for j = 20:n
    if MAP(j) < 0
        continue;
    end
    S1 = read(Source_Obj,j);
    I1 = read(Input_Obj,MAP(j));
    original_I1 = I1;
    original_S1 = S1;
    
    
    figure(1),imshow(S1);
    figure(2),imshow(I1);
    
    %% Write here the stored xyz
    [In_xyz,flippedDepthImage1] = depthToPointCloud(In_depth{MAP(j)},Input_camera);
    In_xyz = fliplr(In_xyz);
    [Source_xyz,flippedDepthImage2] = depthToPointCloud(In_depth{j},Input_camera);
    Source_xyz = fliplr(Source_xyz);
    
    %% Continue to plotting
    A = Input_skel{MAP(j)};
    New_A = align_me(Input_skel{MAP(j)}, Source_skel{j});
    
    figure(3),showPointCloud(In_xyz,I1,'VerticalAxis','y','VerticalAxisDir','down');
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    % Lets store the mid points of all bones in Mid and then use this to
    % find weights
    MID = [];
    hold on;
    for i = 1:19
        x1 = In_xyz(A{SkeletonConnectionMap(i,1)}{3},A{SkeletonConnectionMap(i,1)}{2},1);
        y1 = In_xyz(A{SkeletonConnectionMap(i,1)}{3},A{SkeletonConnectionMap(i,1)}{2},2);
        z1 = In_xyz(A{SkeletonConnectionMap(i,1)}{3},A{SkeletonConnectionMap(i,1)}{2},3);
        
        x2 =  In_xyz(A{SkeletonConnectionMap(i,2)}{3},A{SkeletonConnectionMap(i,2)}{2},1);
        y2 = In_xyz(A{SkeletonConnectionMap(i,2)}{3},A{SkeletonConnectionMap(i,2)}{2},2);
        z2 = In_xyz(A{SkeletonConnectionMap(i,2)}{3},A{SkeletonConnectionMap(i,2)}{2},3);
        
        X1 = [x1,x2];
        Y1 = [y1,y2];
        Z1 = [z1,z2];
        MID = [MID ;[mean(X1), mean(Y1), mean(Z1)]];
        col = [colors(i,1),colors(i,2),colors(i,3)];
        plot3(X1, Y1, Z1,'LineWidth',4,'Color',col);
    end
    hold off;
   
    
    %% Finding skin weights
    Label = zeros(size(I1));
    for m=1:size(In_xyz,1)
        for n=1:size(In_xyz,2)
            x1 = In_xyz(m,n,1);
            y1 = In_xyz(m,n,2);
            z1 = In_xyz(m,n,3);
            
            if isnan(x1) || isnan(y1) || isnan(z1)
                continue;
            end
            ind = -1;
            min_dist = 100000;
            for k=1:size(MID,1)
                x2 = MID(k,1);
                y2 = MID(k,2);
                z2 = MID(k,3);
                
                dist = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
                if dist<min_dist
                    min_dist = dist;
                    ind = k;
                end
            end
            
            I1(m,n,1) = colors(ind,1)*255;
            I1(m,n,2) = colors(ind,2)*255;
            I1(m,n,3) = colors(ind,3)*255;
            Label(m,n,1) = ind;
        end
    end
    
    
    figure(4),showPointCloud(In_xyz,I1,'VerticalAxis','y','VerticalAxisDir','down');
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    
    %% Store the transformations and perform them on Original_I1 labels are stored in Label
   
    Transformations = find_transformations (Input_skel{MAP(j)},New_A,original_I1,original_S1);
    Output_xyz = zeros(size(In_xyz));
    Output_I1 = uint8(zeros(size(Label)));
    
    for p = 1:size(original_I1,1)
        for q = 1:size(original_I1,2)
            if Label(p,q,1) == 0
                continue;
            end
            bone = Label(p,q,1);
            tform = Transformations{bone};
            [new_q,new_p]=transformPointsForward(tform, q,p);
            new_p = min(round(new_p),size(original_I1,1));
            new_p = max(new_p,1);
            new_q = min(round(new_q),size(original_I1,2));
            new_q = max(new_q,1);
            Output_I1(new_p, new_q, 1) = original_I1(p, q, 1);
            Output_I1(new_p, new_q, 2) = original_I1(p, q, 2);
            Output_I1(new_p, new_q, 3) = original_I1(p, q, 3);
            
        end
    end
    figure(2),imshow(Output_I1);
    
    break;
    
end

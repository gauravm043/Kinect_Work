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
Infile= './Dataset_v1/Gaurav_3';

load('./Camera_Settings/kinect_camera');
Input_camera = vid2;

%% Loading Data
load(Infile);
Input_skel = Data_file;

load(strcat(Infile,'_depth'));
In_depth = Depth_data;

load(strcat(Infile,'_xyz'));
In_xyz_data = xyz_data;

Input_video = strcat(Infile, '.mp4');
Input_Obj = VideoReader(Input_video);

for j = 7:10
    I1 = read(Input_Obj,j);
    original_I1 = I1;
    figure(1),imshow(I1);
    In_xyz = In_xyz_data{j};
    In_xyz = fliplr(In_xyz);
    
    %% Continue to plotting
    A = Input_skel{j};
    figure(3),showPointCloud(In_xyz,I1,'VerticalAxis','y','VerticalAxisDir','down');
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    
    first_point = [];
    second_point = [];
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
        
        first_point = [first_point ;[x1, y1, z1]];
        second_point = [second_point ;[x2, y2, z2]];
        
        col = [colors(i,1),colors(i,2),colors(i,3)];
        plot3(X1, Y1, Z1,'LineWidth',4,'Color',col);
    end
    hold off;
    
    
    %% Finding skin weights
    sigmas = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    Label = zeros(size(I1));
    iter = 1;
    
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
            for k=1:size(first_point,1)
                xa = first_point(k,1);
                ya = first_point(k,2);
                za = first_point(k,3);
                
                xb = second_point(k,1);
                yb = second_point(k,2);
                zb = second_point(k,3);
                
                mean_x = mean([xa,xb]);
                mean_y = mean([ya,yb]);
                mean_z = mean([za,zb]);
                
                if k==4 || k==5 || k==8 || k==9 || k==6 || k==10
                    dist = distance_of_point_to_line([xb,yb,zb],[mean_x,mean_y,mean_z],[x1,y1,z1],k);       
                else
                    dist = distance_of_point_to_line([xa,ya,za],[xb,yb,zb],[x1,y1,z1],k);
                end
                
                if dist<min_dist
                    min_dist = dist;
                    ind = k;
                    sigmas(k) = max(sigmas(k),dist);
                end
            end
        end
    end
    
    %% Label Them
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
            for k=1:size(first_point,1)
                xa = first_point(k,1);
                ya = first_point(k,2);
                za = first_point(k,3);
                
                xb = second_point(k,1);
                yb = second_point(k,2);
                zb = second_point(k,3);   
                
                dist = distance_of_point_to_line_while_transforming([xa,ya,za],[xb,yb,zb],[x1,y1,z1]);
                if dist > sigmas(k)
                    continue;
                end
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
    save(strcat(Infile,'_sigmas'),'sigmas');
    break;
    
end

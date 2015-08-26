function [all_transforms] = find_transformations (A,B,In_xyz,I1,colors, Label)

Labels = {'HC','Sp','Sc','Head','SL','EL','WL','HanL','SR','ER','WR','HanR','HipR','KnR','AnkR','FtR','HipL','KnL','AnkL','FtL'};
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

all_transforms = {};
initial = [];
final = [];
In_start = [];
In_endd = [];
In_dir = [];
%% Find transformations
for i = 1:19
    In_x1 = In_xyz(A{SkeletonConnectionMap(i,1)}{3},A{SkeletonConnectionMap(i,1)}{2},1);
    In_y1 = In_xyz(A{SkeletonConnectionMap(i,1)}{3},A{SkeletonConnectionMap(i,1)}{2},2);
    In_z1 = In_xyz(A{SkeletonConnectionMap(i,1)}{3},A{SkeletonConnectionMap(i,1)}{2},3);
    
    In_x2 =  In_xyz(A{SkeletonConnectionMap(i,2)}{3},A{SkeletonConnectionMap(i,2)}{2},1);
    In_y2 = In_xyz(A{SkeletonConnectionMap(i,2)}{3},A{SkeletonConnectionMap(i,2)}{2},2);
    In_z2 = In_xyz(A{SkeletonConnectionMap(i,2)}{3},A{SkeletonConnectionMap(i,2)}{2},3);
    
    Out_x1 = B{SkeletonConnectionMap(i,1)}{2};
    Out_y1 = B{SkeletonConnectionMap(i,1)}{3};
    Out_z1 = B{SkeletonConnectionMap(i,1)}{4};
    
    Out_x2 =  B{SkeletonConnectionMap(i,2)}{2};
    Out_y2 = B{SkeletonConnectionMap(i,2)}{3};
    Out_z2 = B{SkeletonConnectionMap(i,2)}{4};
    
    
    In_start = double([In_x1, In_y1,In_z1]);
    In_endd = double([In_x2, In_y2,In_z2]);
    In_dir = In_endd - In_start;
    
    In_point = [];
    for t=0:0.01:1
        In_point = [In_point; (In_start + t*In_dir)];
    end
    
    Out_start = double([Out_x1, Out_y1,Out_z1]);
    Out_endd = double([Out_x2, Out_y2,Out_z2]);
    Out_dir = Out_endd - Out_start;
    
    Out_point = [];
    for t=0:0.01:1
        Out_point = [Out_point; (Out_start + t*Out_dir)];
    end
    
    hold on;
    col = [colors(i,1),colors(i,2),colors(i,3)];
    %% Finding New Points
    % % % %         plot3(In_point(:,1), In_point(:,2), In_point(:,3),'LineWidth',4);
    % % % %         plot3(Out_point(:,1), Out_point(:,2), Out_point(:,3),'LineWidth',4);
    A1 = In_point';
    B1 = Out_point';
    full = absor(A1,B1);
    all_transforms{i} = full.M;
    
    tform = full.M;
    New_Out = [];
    for j=1:size(A1,2)
        s1 = [A1(1,j),A1(2,j),A1(3,j),1];
        s1 = s1*tform';
        New_Out = [New_Out; [s1(1) s1(2) s1(3)]];
    end
    plot3(New_Out(:,1), New_Out(:,2), New_Out(:,3),'LineWidth',4)
end
hold off;
% % % % Output = [];
% % % % Out_xyz = In_xyz;
% % % % for m=1:size(In_xyz,1)
% % % %     for n=1:size(In_xyz,2)
% % % %         x1 = In_xyz(m,n,1);
% % % %         y1 = In_xyz(m,n,2);
% % % %         z1 = In_xyz(m,n,3);
% % % %         
% % % %         if isnan(x1) || isnan(y1) || isnan(z1)
% % % %             continue;
% % % %         end
% % % %         Out_xyz(m,n,1) = 0;
% % % %         Out_xyz(m,n,2) = 0;
% % % %         Out_xyz(m,n,3) = 0;
% % % %         
% % % %         initial = double([x1, y1, z1]);
% % % %         initial = [initial 1];
% % % %         tform_ind = Label(m,n,1);
% % % %         tform = all_transforms{tform_ind};
% % % %         final =  initial*tform';
% % % %         Output = [Output;final(1) final(2) final(3)];
% % % %         
% % % %         I1(m,n,1) = colors(tform_ind,1)*255;
% % % %         I1(m,n,2) = colors(tform_ind,2)*255;
% % % %         I1(m,n,3) = colors(tform_ind,3)*255;
% % % %         
% % % %         Out_xyz(m,n,1) = final(1);
% % % %         Out_xyz(m,n,2) = final(2);
% % % %         Out_xyz(m,n,3) = final(3);
% % % %         
% % % %     end
% % % % end
% % % % figure(1),showPointCloud(Out_xyz,I1,'VerticalAxis','y','VerticalAxisDir','down');
% % % % xlabel('X (m)');
% % % % ylabel('Y (m)');
% % % % zlabel('Z (m)');

end


function [A,r,c,d] = skeletonViewer(skeleton, image, nSkeleton)

imshow(image);                      %# Display it
[r,c,d] = size(image);              %# Get the image size
set(gca,'Units','normalized','Position',[0 0 1 1]);  %# Modify axes size


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
 % End points Or Y1 below                    
 Labels = {'HC', 'Sp','Sc','Head','SL','EL','WL','HanL','SR','ER','WR','HanR','HipR','KnR','AnkR','FtR','HipL','KnL','AnkL','FtL'};
 hold on;
 
 A{1} = {Labels(1), skeleton(SkeletonConnectionMap(1,1),1,1), skeleton(SkeletonConnectionMap(1,1),2,1)};
%  text(skeleton(SkeletonConnectionMap(1,1),1,1), skeleton(SkeletonConnectionMap(1,1),2,1),Labels(1),'color','red');
 
 for i = 1:19
     
     if nSkeleton > 0
         X1 = [skeleton(SkeletonConnectionMap(i,1),1,1) skeleton(SkeletonConnectionMap(i,2),1,1)];
         Y1 = [skeleton(SkeletonConnectionMap(i,1),2,1) skeleton(SkeletonConnectionMap(i,2),2,1)];
         
         line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'g');
%          text(X1(2),Y1(2),Labels(i+1),'color','red');
         A{i+1} = {Labels(i+1),X1(2),Y1(2)};         
     end
     if nSkeleton > 1
         X2 = [skeleton(SkeletonConnectionMap(i,1),1,2) skeleton(SkeletonConnectionMap(i,2),1,2)];
         Y2 = [skeleton(SkeletonConnectionMap(i,1),2,2) skeleton(SkeletonConnectionMap(i,2),2,2)];     
         line(X2,Y2, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'g');
     end
 end
 
 hold off;
end

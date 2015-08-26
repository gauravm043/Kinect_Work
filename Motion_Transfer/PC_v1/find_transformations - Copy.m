function [all_transforms] = find_transformations (A,B,img_A,img_B)

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


% Define the respective width of body parts
r = [80,80,30,30, 30,30,30,30,30,30,30,30,50,80,30,30,50,80,30,30];
weight = [80,80,30,30, 30,30,30,30,30,30,30,30,20,20,20,20,20,20,20,20];
all_transforms = {};
figure(1);
imshow(img_A);

show_patch = 1;


%% Find transformations
for i =1:19
    r(i) = 3;
    trick = 2.5;
    hold on;
    %% Hull of image A
    % Consider Lines to be drawn seperately
    
    X1 = [A{SkeletonConnectionMap(i,1)}{2} A{SkeletonConnectionMap(i,2)}{2}];
    Y1 = [A{SkeletonConnectionMap(i,1)}{3} A{SkeletonConnectionMap(i,2)}{3}];
    NX1 = [B{SkeletonConnectionMap(i,1)}{2} B{SkeletonConnectionMap(i,2)}{2}];
    NY1 = [B{SkeletonConnectionMap(i,1)}{3} B{SkeletonConnectionMap(i,2)}{3}];
    PX1 = X1;
    PY1 = Y1;
    %Consider tags [Position of joints] seperately
    figure(1);
    text(A{i+1}{2},A{i+1}{3},Labels(i+1),'color','red');
    figure(1);
    line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'g');
    
    A1 = [X1(1) Y1(1)];
    B1 = [X1(2) Y1(2)];
    C1 = B1-A1;
    C1 = C1/norm(C1);
    w1 = r(i)*-C1(2);
    w2 = r(i)*C1(1);
    
    x1=X1(1);y1=Y1(1); %corner position
    x2=X1(2);y2=Y1(2);
    xv=[x1-w1 x2-w1 x2+w1 x1+w1];yv=[y1-w2 y2-w2 y2+w2 y1+w2];
    
    p_vector_x = xv;
    p_vector_y = yv;
    figure(1);
    if show_patch==1
        patch(p_vector_x,p_vector_y,'r',...
            'facecolor',[rand(1,1) rand(1,1) rand(1,1)],...
            'edgecolor',[1 .2 .2],...
            'facealpha',0.7)
    end
    
    
    %% Hull of Image B
    % Consider Lines to be drawn seperately
    
    X1 = [B{SkeletonConnectionMap(i,1)}{2} B{SkeletonConnectionMap(i,2)}{2}];
    Y1 = [B{SkeletonConnectionMap(i,1)}{3} B{SkeletonConnectionMap(i,2)}{3}];
    figure(1);
    line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'y');
    figure(1);
    text(B{i+1}{2},B{i+1}{3},Labels(i+1),'color','yellow');
    
    A1 = [X1(1) Y1(1)];
    B1 = [X1(2) Y1(2)];
    C1 = B1-A1;
    C1 = C1/norm(C1);
    w1 = r(i)*-C1(2);
    w2 = r(i)*C1(1);
    
    
    x1=X1(1);y1=Y1(1); %corner position
    x2=X1(2);y2=Y1(2);
    xv=[x1-w1 x2-w1 x2+w1 x1+w1];yv=[y1-w2 y2-w2 y2+w2 y1+w2];
    
    vector_x = xv;
    vector_y = yv;
    figure(1);
    if show_patch==1
        patch(vector_x,vector_y,'r',...
            'facecolor',[rand(1,1) rand(1,1) rand(1,1)],...
            'edgecolor',[1 .2 .2],...
            'facealpha',0.7)
    end
    
   
    
    %% Finding Transformation
    init = [PX1(1) PY1(1); PX1(2) PY1(2)];
    final = [X1(1) Y1(1); X1(2) Y1(2)];
    
    for gg=1:size(vector_x,2)
        init = [p_vector_x(gg) p_vector_y(gg);init];
        final = [vector_x(gg) vector_y(gg);final];
    end
    
    tform = fitgeotrans(init,final,'similarity');
    all_transforms{i} = tform;
end

end
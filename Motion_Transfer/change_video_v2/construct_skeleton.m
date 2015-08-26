% This function will draw only skeleton given joint locations in A

function [New_image, New_N] = construct_skeleton (A,B,N,img_A,img_B,img_N)
Labels = {'HC','Sp','Sc','Head','SL','EL','WL','HanL','SR','ER','WR','HanR','HipR','KnR','AnkR','FtR','HipL','KnL','AnkL','FtL'};
countt=1;
set(gca,'Units','normalized','Position',[0 0 1 1]);
if strcmp(A, 'NULL')
    return;
end
% % % % f1 = figure(1);
% % % % imshow(Depth_image, []);
% % % % colormap('default');
% % % % colorbar();
% % % % F1=getframe(f1);
% % % % imwrite(F1.cdata,'ori.jpg');
% % % % return;

show_patch = 1;
ori_img_A = img_A;
ori_img_B = img_B;
ori_img_N = img_N;
New_N = N;
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
r = [30,50,30,30, 30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30];
weight = [50,40,30,30, 30,30,30,30,30,30,30,30,20,20,20,20,20,20,20,20];
is_found = [0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
new_rect = [0,0,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,1];
first = size(img_A,1);
second = size(img_A,2);
New_image = uint8(zeros(size(img_N)));
for i=1:size(New_image, 1)
    for j=1:size(New_image, 2)
        New_image(i, j, 1) = 255;
    end
end
f1=figure(1);
imshow(ori_img_A);
f2=figure(2);
imshow(ori_img_N);
figure(1);
text(A{1}{2}, A{1}{3},Labels(1),'color','red');

all_transforms = {};
rectangle_ax = {};
rectangle_bx = {};
rectangle_nx = {};
rectangle_ay = {};
rectangle_by = {};
rectangle_ny = {};

for i =1:19
    r(i) = weight(i);
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
    rectangle_ax{i} = xv;
    rectangle_ay{i} = yv;
    
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
    rectangle_bx{i} = xv;
    rectangle_by{i} = yv;
    
    
    vector_x = xv;
    vector_y = yv;
    figure(1);
    if show_patch==1
        patch(vector_x,vector_y,'r',...
            'facecolor',[rand(1,1) rand(1,1) rand(1,1)],...
            'edgecolor',[1 .2 .2],...
            'facealpha',0.7)
    end
    
    f4=figure(4);
    imshow(ori_img_A);
    hold on;
    text(p_vector_x(1), p_vector_y(1),'1','color','yellow');
    text(vector_x(1), vector_y(1),'1','color','y');
    
    text(p_vector_x(2), p_vector_y(2),'2','color','yellow');
    text(vector_x(2), vector_y(2),'2','color','y');
    
    text(p_vector_x(3), p_vector_y(3),'3','color','yellow');
    text(vector_x(3), vector_y(3),'3','color','y');
    
    text(p_vector_x(4), p_vector_y(4),'4','color','yellow');
    text(vector_x(4), vector_y(4),'4','color','y');
    patch(vector_x,vector_y,'r',...
        'facecolor',[rand(1,1) rand(1,1) rand(1,1)],...
        'edgecolor',[1 .2 .2],...
        'facealpha',0.7)
    patch(p_vector_x,p_vector_y,'r',...
        'facecolor',[rand(1,1) rand(1,1) rand(1,1)],...
        'edgecolor',[1 .2 .2],...
        'facealpha',0.7)
    hold off;
    
    
    %% Finding Transformation
    init = [PX1(1) PY1(1); PX1(2) PY1(2)];
    final = [X1(1) Y1(1); X1(2) Y1(2)];
    
    for gg=1:size(vector_x,2)
        init = [p_vector_x(gg) p_vector_y(gg);init];
        final = [vector_x(gg) vector_y(gg);final];
    end
    
    tform = fitgeotrans(init,final,'affine');
    all_transforms{i} = tform;
    
    %% Hull of image N
    % Consider Lines to be drawn seperately
    r(i) = weight(i);
    X1 = [N{SkeletonConnectionMap(i,1)}{2} N{SkeletonConnectionMap(i,2)}{2}];
    Y1 = [N{SkeletonConnectionMap(i,1)}{3} N{SkeletonConnectionMap(i,2)}{3}];
    figure(2);
    line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'b');
    figure(2);
    text(N{i+1}{2},N{i+1}{3},Labels(i+1),'color','blue');
    
    
    if is_found(SkeletonConnectionMap(i,1))==0
        m=N{SkeletonConnectionMap(i,1)}{2};
        n=N{SkeletonConnectionMap(i,1)}{3};
        [new_m,new_n]=transformPointsForward(tform,m,n);
        new_m = min(round(new_m),second);
        new_m = max(new_m,1);
        new_n = min(round(new_n),first);
        new_n = max(new_n,1);
        New_N{SkeletonConnectionMap(i,1)}{2} = new_m;
        New_N{SkeletonConnectionMap(i,1)}{3} = new_n;
        is_found(SkeletonConnectionMap(i,1))=1;
    end
    
    if is_found(SkeletonConnectionMap(i,2))==0
        m=N{SkeletonConnectionMap(i,2)}{2};
        n=N{SkeletonConnectionMap(i,2)}{3};
        
        [new_m,new_n]=transformPointsForward(tform,m,n);
        new_m = min(round(new_m),second);
        new_m = max(new_m,1);
        new_n = min(round(new_n),first);
        new_n = max(new_n,1);
        New_N{SkeletonConnectionMap(i,2)}{2} = new_m;
        New_N{SkeletonConnectionMap(i,2)}{3} = new_n;
        is_found(SkeletonConnectionMap(i,2))=1;
    end
    hold off;
    pause(0.02);
    %waitforbuttonpress;
end

%% New rectangles from 20 onwards
start = 20;
for i=1:19
    if new_rect(i) == 1
        if i==5 || i==9
            p_vector_x = [rectangle_ax{i}(1) rectangle_ax{i}(4) A{SkeletonConnectionMap(4,1)}{2}];
            p_vector_y = [rectangle_ay{i}(1) rectangle_ay{i}(4) A{SkeletonConnectionMap(4,1)}{3}];
            vector_x = [rectangle_bx{i}(1) rectangle_bx{i}(4) B{SkeletonConnectionMap(4,1)}{2}];
            vector_y = [rectangle_by{i}(1) rectangle_by{i}(4) B{SkeletonConnectionMap(4,1)}{3}];
        else
            
            
            p_vector_x = [rectangle_ax{i}(1) rectangle_ax{i}(4) rectangle_ax{i-1}(3) rectangle_ax{i-1}(2)];
            p_vector_y = [rectangle_ay{i}(1) rectangle_ay{i}(4) rectangle_ay{i-1}(3) rectangle_ay{i-1}(2)];
            vector_x = [rectangle_bx{i}(1) rectangle_bx{i}(4) rectangle_bx{i-1}(3) rectangle_bx{i-1}(2)];
            vector_y = [rectangle_by{i}(1) rectangle_by{i}(4) rectangle_by{i-1}(3) rectangle_by{i-1}(2)];
        end
        figure(2)
        patch(p_vector_x,p_vector_y,'r',...
            'facecolor',[1 1 1],...
            'edgecolor',[1 .2 .2],...
            'facealpha',0.7)
        patch(vector_x,vector_y,'r',...
            'facecolor',[1 1 1],...
            'edgecolor',[1 .2 .2],...
            'facealpha',0.7)
        
        for me1=1:size(vector_x,2)
            for me2=1:size(vector_x,2)
                if me1 == me2
                    continue;
                end
                if (p_vector_x(me1) == p_vector_x(me2))&&(p_vector_y(me1) == p_vector_y(me2))
                    new_rect(i) = 0;
                    break;
                end
            end
        end
        
        for me1=1:size(vector_x,2)
            for me2=1:size(vector_x,2)
                if me1 == me2
                    continue;
                end
                
                if (vector_x(me1) == vector_x(me2))&&(vector_y(me1) == vector_y(me2))
                    new_rect(i) = 0;
                    break;
                end
            end
        end
        if new_rect(i) == 0
            continue;
        end
        init = [];
        final = [];
        
        for gg=1:size(vector_x,2)
            init = [p_vector_x(gg) p_vector_y(gg);init];
            final = [vector_x(gg) vector_y(gg);final];
        end
        
        tform = fitgeotrans(init,final,'affine');
        all_transforms{start} = tform;
        start = start+1;
    end
end

figure(3),imshow(New_image);
for i =1:19
    X1 = [New_N{SkeletonConnectionMap(i,1)}{2} New_N{SkeletonConnectionMap(i,2)}{2}];
    Y1 = [New_N{SkeletonConnectionMap(i,1)}{3} New_N{SkeletonConnectionMap(i,2)}{3}];
    figure(2);
    line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'y');
    
    figure(2);
    text(New_N{i+1}{2},New_N{i+1}{3},Labels(i+1),'color','red');
end
all_transforms{1};

%% Transform image here
data_check = uint8(zeros(size(img_N)));
for i=1:19
    figure(4);
    imshow(New_image);
     
    figure(2);
    imshow(ori_img_N);
    
    X1 = [New_N{SkeletonConnectionMap(i,1)}{2} New_N{SkeletonConnectionMap(i,2)}{2}];
    Y1 = [New_N{SkeletonConnectionMap(i,1)}{3} New_N{SkeletonConnectionMap(i,2)}{3}];
    %     figure(3);
    %     line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
    %
    %     figure(3);
    %     text(New_N{i+1}{2},New_N{i+1}{3},Labels(i+1),'color','red');
    
    A1 = [X1(1) Y1(1)];
    B1 = [X1(2) Y1(2)];
    C1 = B1-A1;
    C1 = C1/norm(C1);
    w1 = r(i)*-C1(2);
    w2 = r(i)*C1(1);
    
    x1=X1(1);y1=Y1(1); %corner position
    x2=X1(2);y2=Y1(2);
    
    m = sqrt((X1(1)-X1(2))*(X1(1)-X1(2)) + (Y1(1)-Y1(2))*(Y1(1)-Y1(2)));
    A1 = [X1(1) Y1(1)];
    B1 = [X1(2) Y1(2)];
    C1 = B1-A1;
    C1 = C1/norm(C1);
    if i==3
        x2 = x1+round(1.5*(m)*C1(1));
        y2 = y1+round(1.5*(m)*C1(2));
    end
    if i==7 || i==11
        x2 = x1+round(2.5*(m)*C1(1));
        y2 = y1+round(2.5*(m)*C1(2));
    end
    if i==15 || i==19
        x2 = x1+round(1.5*(m)*C1(1));
        y2 = y1+round(1.5*(m)*C1(2));
    end
    
    xv=[x1-w1 x2-w1 x2+w1 x1+w1];yv=[y1-w2 y2-w2 y2+w2 y1+w2];
    
    
    rectangle_nx{i} = xv;
    rectangle_ny{i} = yv;
    
    tform = all_transforms{i};
    invtform = invert(tform);
    
% % % %     % Calculating depth at old skeleton joints
% % % %     [oldx1,oldy1]=transformPointsForward(invtform,x1,y1);
% % % %     oldx1 = min(round(oldx1),second);
% % % %     oldx1 = max(oldx1,1);
% % % %     oldy1 = min(round(oldy1),first);
% % % %     oldy1 = max(oldy1,1);
% % % %     
% % % %     [oldx2,oldy2]=transformPointsForward(invtform,x2,y2);
% % % %     oldx2 = min(round(oldx2),second);
% % % %     oldx2 = max(oldx2,1);
% % % %     oldy2 = min(round(oldy2),first);
% % % %     oldy2 = max(oldy2,1);
% % % %     
% % % %     depth1 = Depth_image(oldy1,oldx1);
% % % %     depth2 = Depth_image(oldy2,oldx2);
% % % %     d_a = min(depth1,depth2);
% % % %     d_b = max(depth1,depth2);
    
    for m = max(1,round(min(xv))):min(second, round(max(xv)))
        for n = max(1, round(min(yv))):min(first, round(max(yv)))
            in = inpolygon(m,n,xv,yv);
            if in==1 && data_check(n,m) == 0
                [new_m,new_n]=transformPointsForward(invtform,m,n);
                new_m = min(round(new_m),second);
                new_m = max(new_m,1);
                new_n = min(round(new_n),first);
                new_n = max(new_n,1);
               
                New_image(n, m, 1) = ori_img_N(new_n, new_m, 1);
                New_image(n, m, 2) = ori_img_N(new_n, new_m, 2);
                New_image(n, m, 3) = ori_img_N(new_n, new_m, 3);
% % % %                  if Depth_image(new_n, new_m)>=d_a && Depth_image(new_n, new_m)<=d_b
% % % %                     ori_img_N(new_n, new_m, 1) = 0;
% % % %                     ori_img_N(new_n, new_m, 2) = 255;
% % % %                     ori_img_N(new_n, new_m, 3) = 0;
% % % %                 end
                data_check(n,m) = 1;
            end
        end
    end
    figure(3);
    patch(xv,yv,'r',...
        'facecolor',[rand(1,1) rand(1,1) rand(1,1)],...
        'edgecolor',[1 .2 .2],...
        'facealpha',0.7)
    pause(0.02);
end

start = 20;
for i=1:19
    figure(4),imshow(New_image);
    if new_rect(i) == 1
        xv = [rectangle_nx{i}(1) rectangle_nx{i}(4) rectangle_nx{i-1}(3) rectangle_nx{i-1}(2)];
        yv = [rectangle_ny{i}(1) rectangle_ny{i}(4) rectangle_ny{i-1}(3) rectangle_ny{i-1}(2)];
        tform = all_transforms{start};
        start = start+1;
        invtform = invert(tform);
        for m = max(1,round(min(xv))):min(second, round(max(xv)))
            for n = max(1, round(min(yv))):min(first, round(max(yv)))
                in = inpolygon(m,n,xv,yv);
                if data_check(n,m) == 0
                    [new_m,new_n]=transformPointsForward(invtform,m,n);
                    new_m = min(round(new_m),second);
                    new_m = max(new_m,1);
                    new_n = min(round(new_n),first);
                    new_n = max(new_n,1);
                    
                    New_image(n, m, 1) = ori_img_N(new_n, new_m, 1);
                    New_image(n, m, 2) = ori_img_N(new_n, new_m, 2);
                    New_image(n, m, 3) = ori_img_N(new_n, new_m, 3);
                    data_check(n,m) = 1;
                end
            end
        end
        
        figure(3);
        patch(xv,yv,'r',...
            'facecolor',[1 1 1],...
            'edgecolor',[1 .2 .2],...
            'facealpha',0.7)
    end
    
end

% % % % imwrite(New_image,strcat(num2str(item),'.jpg'));
% % % % % pause(2);
% % % %
F1=getframe(f1);
imwrite(F1.cdata,'ori.jpg');
% % % %
% % % % F2=getframe(f2);
% % % % imwrite(F2.cdata,'conv.jpg');
%  pause(3);
% close all;
%waitforbuttonpress;
end
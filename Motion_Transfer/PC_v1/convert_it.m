function [Ans] = convert_it(A)
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

% Ans = [A{1}{2} A{1}{3}];
Ans = [];
for i =1:19
%     if i<=2 || i==7 || i==11 || i==15 || i==19 || i==12 || i==16 %(WL-HL, WR-HR, HC-HipL, HC-HipR)
%         continue;
%     end
    % Consider Lines to be drawn seperately
    X1 = [A{SkeletonConnectionMap(i,1)}{2} A{SkeletonConnectionMap(i,2)}{2}];
    Y1 = [A{SkeletonConnectionMap(i,1)}{3} A{SkeletonConnectionMap(i,2)}{3}];
%     line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'g');
    y = Y1(1) - Y1(2);
    x = X1(2) - X1(1);
    theta = my_atan(y, x);
    
    if theta >=345
        theta = 360-theta;
    end
    Ans = [Ans theta];
end

end
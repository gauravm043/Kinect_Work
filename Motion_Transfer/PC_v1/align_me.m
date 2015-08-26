function [New_A] = align_me(A, B, In_xyz, Source_xyz)
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

%% Do it
% Let us fix Hip_C position for both then align

New_A = A;
New_A{1}{2} = Source_xyz(B{1}{3},B{1}{2},1);
New_A{1}{3} = Source_xyz(B{1}{3},B{1}{2},2);
New_A{1}{4} = Source_xyz(B{1}{3},B{1}{2},3);

% New Head [3->4]
for i=1:19
p = SkeletonConnectionMap(i,1);
q = SkeletonConnectionMap(i,2);
start = double([In_xyz(A{p}{3}, A{p}{2},1),In_xyz(A{p}{3}, A{p}{2},2),In_xyz(A{p}{3}, A{p}{2},3)]);
endd = double([In_xyz(A{q}{3}, A{q}{2},1),In_xyz(A{q}{3}, A{q}{2},2),In_xyz(A{q}{3}, A{q}{2},3)]);
diff = double(endd)-double(start);
ori_dist = Find_distance(start(1),start(2),start(3),endd(1),endd(2),endd(3));

New_A{q}{2} = New_A{p}{2} + ori_dist*diff(1)/norm(diff);
New_A{q}{3} = New_A{p}{3} + ori_dist*diff(2)/norm(diff);
New_A{q}{4} = New_A{p}{4} + ori_dist*diff(3)/norm(diff);
end
end
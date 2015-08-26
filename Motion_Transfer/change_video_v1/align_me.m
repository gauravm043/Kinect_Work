function [New_A] = align_me(A, B)
% Aligns A with B
% By aligning here we are safely assuming that length between 2 joints is fixed

Labels = {'HC','Sp','Sc','Head','SL','EL','WL','HanL','SR','ER','WR','HanR','HipR','KnR','AnkR','FtR','HipL','KnL','AnkL','FtL'};

% Let us fix SC position for both then align
New_A = A;
% New_A{3}{2} = B{3}{2};New_A{3}{3} = B{3}{3};

% New Head [3->4]


ori_dist = Find_distance(A{3}, A{4});
new_theta = atan(Find_Slope(B{3}, B{4}));
if B{3}{2} <= B{4}{2}
    New_A{4}{2} = New_A{3}{2} + ori_dist*cos(new_theta);
    New_A{4}{3} = New_A{3}{3} + ori_dist*sin(new_theta);
else
    New_A{4}{2} = New_A{3}{2} - ori_dist*cos(new_theta);
    New_A{4}{3} = New_A{3}{3} - ori_dist*sin(new_theta);
end

% New SL [3->5]
ori_dist = Find_distance(A{3}, A{5});
new_theta = atan(Find_Slope(B{3}, B{5}));
if B{3}{2} <= B{5}{2}
    New_A{5}{2} = New_A{3}{2} + ori_dist*cos(new_theta);
    New_A{5}{3} = New_A{3}{3} + ori_dist*sin(new_theta);
else
    New_A{5}{2} = New_A{3}{2} - ori_dist*cos(new_theta);
    New_A{5}{3} = New_A{3}{3} - ori_dist*sin(new_theta);
end
% New SR [3->9]
ori_dist = Find_distance(A{3}, A{9});
new_theta = atan(Find_Slope(B{3}, B{9}));
if B{3}{2} <= B{9}{2}
    New_A{9}{2} = New_A{3}{2} + ori_dist*cos(new_theta);
    New_A{9}{3} = New_A{3}{3} + ori_dist*sin(new_theta);
else
    New_A{9}{2} = New_A{3}{2} - ori_dist*cos(new_theta);
    New_A{9}{3} = New_A{3}{3} - ori_dist*sin(new_theta);
    
end
% New EL [5->6]
ori_dist = Find_distance(A{5}, A{6});
new_theta = atan(Find_Slope(B{5}, B{6}));
if B{5}{2} <= B{6}{2}
    New_A{6}{2} = New_A{5}{2} + ori_dist*cos(new_theta);
    New_A{6}{3} = New_A{5}{3} + ori_dist*sin(new_theta);
else
    New_A{6}{2} = New_A{5}{2} - ori_dist*cos(new_theta);
    New_A{6}{3} = New_A{5}{3} - ori_dist*sin(new_theta);
end

% New ER [9->10]
ori_dist = Find_distance(A{9}, A{10});
new_theta = atan(Find_Slope(B{9}, B{10}));
if B{9}{2} <= B{10}{2}
    New_A{10}{2} = New_A{9}{2} + ori_dist*cos(new_theta);
    New_A{10}{3} = New_A{9}{3} + ori_dist*sin(new_theta);
else
    New_A{10}{2} = New_A{9}{2} - ori_dist*cos(new_theta);
    New_A{10}{3} = New_A{9}{3} - ori_dist*sin(new_theta);
    
end
% New WL [6->7]
ori_dist = Find_distance(A{6}, A{7});
new_theta = atan(Find_Slope(B{6}, B{7}));
if B{6}{2} <= B{7}{2}
    New_A{7}{2} = New_A{6}{2} + ori_dist*cos(new_theta);
    New_A{7}{3} = New_A{6}{3} + ori_dist*sin(new_theta);
else
    New_A{7}{2} = New_A{6}{2} - ori_dist*cos(new_theta);
    New_A{7}{3} = New_A{6}{3} - ori_dist*sin(new_theta);
end

% New WR [10->11]
ori_dist = Find_distance(A{10}, A{11});
new_theta = atan(Find_Slope(B{10}, B{11}));
if B{10}{2} <= B{11}{2}
    New_A{11}{2} = New_A{10}{2} + ori_dist*cos(new_theta);
    New_A{11}{3} = New_A{10}{3} + ori_dist*sin(new_theta);
else
    New_A{11}{2} = New_A{10}{2} - ori_dist*cos(new_theta);
    New_A{11}{3} = New_A{10}{3} - ori_dist*sin(new_theta);
    
end
% New HanL [7->8]
ori_dist = Find_distance(A{7}, A{8});
new_theta = atan(Find_Slope(B{7}, B{8}));
if B{7}{2} <= B{8}{2}
    New_A{8}{2} = New_A{7}{2} + ori_dist*cos(new_theta);
    New_A{8}{3} = New_A{7}{3} + ori_dist*sin(new_theta);
else
    New_A{8}{2} = New_A{7}{2} - ori_dist*cos(new_theta);
    New_A{8}{3} = New_A{7}{3} - ori_dist*sin(new_theta);
    
end
% New HanR [11->12]
ori_dist = Find_distance(A{11}, A{12});
new_theta = atan(Find_Slope(B{11}, B{12}));
if B{11}{2} <= B{12}{2}
    New_A{12}{2} = New_A{11}{2} + ori_dist*cos(new_theta);
    New_A{12}{3} = New_A{11}{3} + ori_dist*sin(new_theta);
else
    New_A{12}{2} = New_A{11}{2} - ori_dist*cos(new_theta);
    New_A{12}{3} = New_A{11}{3} - ori_dist*sin(new_theta);
end

% New SP [3->2]
ori_dist = Find_distance(A{3}, A{2});
new_theta = atan(Find_Slope(B{3}, B{2}));
if B{3}{2} <= B{2}{2}
    New_A{2}{2} = New_A{3}{2} + ori_dist*cos(new_theta);
    New_A{2}{3} = New_A{3}{3} + ori_dist*sin(new_theta);
else
    New_A{2}{2} = New_A{3}{2} - ori_dist*cos(new_theta);
    New_A{2}{3} = New_A{3}{3} - ori_dist*sin(new_theta);
end

% New HC [2->1]
ori_dist = Find_distance(A{2}, A{1});
new_theta = atan(Find_Slope(B{2}, B{1}));
if B{2}{2} <= B{1}{2}
    New_A{1}{2} = New_A{2}{2} + ori_dist*cos(new_theta);
    New_A{1}{3} = New_A{2}{3} + ori_dist*sin(new_theta);
else
    New_A{1}{2} = New_A{2}{2} - ori_dist*cos(new_theta);
    New_A{1}{3} = New_A{2}{3} - ori_dist*sin(new_theta);
end

% New HipL [1->17]
ori_dist = Find_distance(A{1}, A{17});
new_theta = atan(Find_Slope(B{1}, B{17}));
if B{1}{2} <= B{17}{2}
    New_A{17}{2} = New_A{1}{2} + ori_dist*cos(new_theta);
    New_A{17}{3} = New_A{1}{3} + ori_dist*sin(new_theta);
else
    New_A{17}{2} = New_A{1}{2} - ori_dist*cos(new_theta);
    New_A{17}{3} = New_A{1}{3} - ori_dist*sin(new_theta);
end

% New HipR [1->13]
ori_dist = Find_distance(A{1}, A{13});
new_theta = atan(Find_Slope(B{1}, B{13}));
if B{1}{2} <= B{13}{2}
    New_A{13}{2} = New_A{1}{2} + ori_dist*cos(new_theta);
    New_A{13}{3} = New_A{1}{3} + ori_dist*sin(new_theta);
else
    New_A{13}{2} = New_A{1}{2} - ori_dist*cos(new_theta);
    New_A{13}{3} = New_A{1}{3} - ori_dist*sin(new_theta);
end

% New KneeL [17->18]
ori_dist = Find_distance(A{17}, A{18});
new_theta = atan(Find_Slope(B{17}, B{18}));
if B{17}{2} <= B{18}{2}
    New_A{18}{2} = New_A{17}{2} + ori_dist*cos(new_theta);
    New_A{18}{3} = New_A{17}{3} + ori_dist*sin(new_theta);
else
    New_A{18}{2} = New_A{17}{2} - ori_dist*cos(new_theta);
    New_A{18}{3} = New_A{17}{3} - ori_dist*sin(new_theta);
end

% New KneeR [13->14]
ori_dist = Find_distance(A{13}, A{14});
new_theta = atan(Find_Slope(B{13}, B{14}));
if B{13}{2} <= B{14}{2}
    New_A{14}{2} = New_A{13}{2} + ori_dist*cos(new_theta);
    New_A{14}{3} = New_A{13}{3} + ori_dist*sin(new_theta);
else
    New_A{14}{2} = New_A{13}{2} - ori_dist*cos(new_theta);
    New_A{14}{3} = New_A{13}{3} - ori_dist*sin(new_theta);
end

% New AnkL [18->19]
ori_dist = Find_distance(A{18}, A{19});
new_theta = atan(Find_Slope(B{18}, B{19}));
if B{18}{2} <= B{19}{2}
    New_A{19}{2} = New_A{18}{2} + ori_dist*cos(new_theta);
    New_A{19}{3} = New_A{18}{3} + ori_dist*sin(new_theta);
else
    New_A{19}{2} = New_A{18}{2} - ori_dist*cos(new_theta);
    New_A{19}{3} = New_A{18}{3} - ori_dist*sin(new_theta);
end

% New AnkR [14->15]
ori_dist = Find_distance(A{14}, A{15});
new_theta = atan(Find_Slope(B{14}, B{15}));
if B{14}{2} <= B{15}{2}
    New_A{15}{2} = New_A{14}{2} + ori_dist*cos(new_theta);
    New_A{15}{3} = New_A{14}{3} + ori_dist*sin(new_theta);
else
    New_A{15}{2} = New_A{14}{2} - ori_dist*cos(new_theta);
    New_A{15}{3} = New_A{14}{3} - ori_dist*sin(new_theta);
end


% New FtL [19->20]
ori_dist = Find_distance(A{19}, A{20});
new_theta = atan(Find_Slope(B{19}, B{20}));
if B{19}{2} <= B{20}{2}
    New_A{20}{2} = New_A{19}{2} + ori_dist*cos(new_theta);
    New_A{20}{3} = New_A{19}{3} + ori_dist*sin(new_theta);
else
    New_A{20}{2} = New_A{19}{2} - ori_dist*cos(new_theta);
    New_A{20}{3} = New_A{19}{3} - ori_dist*sin(new_theta);
end

% New FtR [15->16]
ori_dist = Find_distance(A{15}, A{16});
new_theta = atan(Find_Slope(B{15}, B{16}));
if B{15}{2} <= B{16}{2}
    New_A{16}{2} = New_A{15}{2} + ori_dist*cos(new_theta);
    New_A{16}{3} = New_A{15}{3} + ori_dist*sin(new_theta);
else
    New_A{16}{2} = New_A{15}{2} - ori_dist*cos(new_theta);
    New_A{16}{3} = New_A{15}{3} - ori_dist*sin(new_theta);
end

end
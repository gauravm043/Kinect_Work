function MAP = find_mapping(S , I)
% For each i in S find j in I that matches with i
MAP = [];
n_i = size(S, 2);
n_j = size(I, 2);
I{51};
for i = 1:n_i
    if strcmp(S{i}, 'NULL')
        MAP = [MAP -20];
        continue;
    end
    
    min = 1000000;
    idx = -1;
    for j = n_j:-1:1
%     for j = 1:n_j
        if strcmp(I{j}, 'NULL')
            continue;
        end
        d = calc_distance(S{i} , I{j});
        if d<min
            min = d;
            idx = j;
        end
    end
    
    MAP = [MAP idx];
end
end
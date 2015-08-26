function val = calc_distance(A, B)
val = 0;
n = size(A, 2);
for i=1:n
    val = val + abs(A(i) - B(i));
end
val = sqrt(val);
end
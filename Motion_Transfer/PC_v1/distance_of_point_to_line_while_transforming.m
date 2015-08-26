function [ans] = distance_of_point_to_line_while_transforming(a, b, p)
n = b - a;
pa = a - p;

c = dot( n, pa );

% Closest point is a
if ( c > 0.0 )
    m= dot(pa, pa);
    ans = m;
    return;
end

bp = p - b;

% Closest point is b
if ( dot( n, bp ) > 0.0 )
    ans = dot( bp, bp );
    return;
end

% Closest point is between a and b
e = pa - n * (c / dot( n, n ));

ans = dot( e, e );
end
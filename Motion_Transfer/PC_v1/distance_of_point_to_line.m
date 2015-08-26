function [ans] = distance_of_point_to_line (a, b, p, k)
n = b - a;
pa = a - p;

c = dot( n, pa );

% Closest point is a
if ( c > 0.0 )
    m= dot(pa, pa);
    ans = m;
    if k==4 || k==5 || k==8 || k==9 || k==6 || k==10
        ans = 100;
    end
    return;
end

bp = p - b;

% Closest point is b
if ( dot( n, bp ) > 0.0 )
    ans = dot( bp, bp );
    if k==4 || k==5 || k==8 || k==9  || k==6 || k==10
        ans = 100;
    end
    return;
end

% Closest point is between a and b
e = pa - n * (c / dot( n, n ));

ans = dot( e, e );
end
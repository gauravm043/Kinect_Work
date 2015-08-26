function [dist] = Find_distance(A, B)
dist = sqrt((A{2} - B{2})*(A{2} - B{2}) + (A{3} - B{3})*(A{3} - B{3}));
end
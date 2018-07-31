function [wid,len,area,surf vol] = calc_geom_contour(x,y)

% furthest points from each other
% for perfect rod shape

diffx = meshgrid(x) - meshgrid(x)';
diffy = meshgrid(y) - meshgrid(y)';

diff = sqrt(diffx.^2 + diffy.^2);
[M, I] = max(diff);
[m,i] = max(M);
%disp(m);

% Indices for midline endpoints
i1 = i;i2 = I(i);


% Now calculate 'widths'
v1 = [x(i1) y(i1)];
v2 = [x(i2) y(i2)];

vol = 0;
surf = 0;

for k=1:length(x)
    pt = [x(k) y(k)];
    a = v1 - v2;
    b = pt - v2;
    d = norm(cross([a 0],[b 0])) / norm(a');
    vol = pi*d^2/2 + vol;
    surf = pi*d+surf;
    
    rad(k) = d;
end
    
% Plot centerline
if true
    figure;
    plot(x,y,'r');
    axis equal;
    hold on;
    plot([v1(1) v2(1)], [v1(2) v2(2)], 'b');
end
    

area = polyarea(x,y);
wid = median(rad);
len = m; 




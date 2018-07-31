close all;

s = 1; % Frame number
k = 20; % Object number

x = frame(s).object(k).Xcont;
y = frame(s).object(k).Ycont;

figure;
plot(x,y,'b');
axis equal;

[w,l,a,s,v] = calc_geom_contour(x,y);
disp(w);

function plot_single_cell_frame(f,i)
close all
% f=load('feature_0_frame_0_19-Jul-2018_CONTOURS_pill_MESH.mat');
width = [];
frames = f.cells(i).frame;
obids = f.cells(i).object
 for i = 1:numel(frames)
    c = f.frame(frames(i)).object(obids(i));
    width = [ width c.cell_width];
    plot(c.Xcont, c.Ycont);
    axis equal
    hold on;

end
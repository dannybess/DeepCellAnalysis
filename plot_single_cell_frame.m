%plot single cell over multiple frames + cell length and width
function plot_small_cell(f,i)
close all
% f=load('feature_0_frame_0_19-Jul-2018_CONTOURS_pill_MESH.mat');
width = [];
length = [];
frames = f.cells(i).frame;
obids = f.cells(i).object;
shift = 100;
 for i = 1:numel(frames)
    c = f.frame(frames(i)).object(obids(i));
    width = [ width c.cell_width];
    length = [ length c.cell_length];
    subplot(2,1,1)
    plot(c.Xcont+shift*i, c.Ycont);
    axis equal
    hold on;

 end
 subplot(2,1,2)
 yyaxis left
 plot(frames,width)
 yyaxis right
 plot(frames,length)
end
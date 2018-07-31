function plot_small_cells()
f=load('feature_0_frame_0_19-Jul-2018_CONTOURS_pill_MESH.mat');
width = [];
for i = 1:numel(f.cells)
    width = f.frame.object(i).cell_width;
    if (width < 100) 
        c = f.frame.object(i);
        plot(c.Xcont, c.Ycont)
        xlim([0 2500])
        ylim([0 2000])
        hold on;
    end
end

end
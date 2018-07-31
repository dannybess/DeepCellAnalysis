function plot_single_cell_timelapse(file)
close all
if isstr(file)
    f = load(file)
end
for i = 1:numel(f.cells)
        frames = f.cells(i).frame;
        cellid = f.cells(i).object;
        length = [];
        width = [];
        time = [];
        for j = 1:numel(frames)
                length = [length f.frame(frames(j)).object(cellid(j)).cell_length];
                width = [width f.frame(frames(j)).object(cellid(j)).cell_width];
                time = [ time frames(j)];
        end
        subplot(1,2,1)
        plot(time, length,'UserData',i); hold on;
        subplot(1,2,2)
        plot(time, width,'UserData',i); hold on;
end
end

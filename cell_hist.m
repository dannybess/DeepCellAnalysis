function cell_hist(file)
if isstr(file)
    f = load(file);
end

for i = 1:numel(f.cells)
    frames = f.cells(i).frame
    cellid = f.cells(i).object;
    width = []
    length = [] 
    for j = 1:numel(frames)
        length = [length f.frame(frames(j)).object(cellid(j)).length];
        width = [width f.frame(frames(j)).object(cellid(j)).width];
    end
    histogram(length);
end

end

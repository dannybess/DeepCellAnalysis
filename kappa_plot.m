function kappa_plot(file)
if isstr(file)
    f = load(file)
end
min_kappa=[];
for i = 1:numel(f.cells)
    frames = f.cells(i).frame;
    cellid = f.cells(i).object;
    min_val = min(f.frame(frames(1)).object(cellid(1)).kappa_smooth);
    min_kappa = [min_kappa min_val];
end
histogram(min_kappa);

end
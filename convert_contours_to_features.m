function convert_contours_to_features(contour)

if isstr(contour)
    contour = load(contour);
end

imagex = 2160;
imagey = 2560;

for l = 1:numel(contour.frame)
    feature_0 = zeros(imagex,imagey);
    feature_1 = zeros(imagex,imagey);
    feature_2 = zeros(imagex,imagey);
    immask = zeros(imagex,imagey);
    
    for g = 1:numel(contour.frame(l).object)
        
        % getting contour
        if isfield(contour.frame(l).object(g),'C') % gabe format
            xPos = contour.frame(l).object(g).C(:,1);
            yPos = contour.frame(l).object(g).C(:,2);
        else
            xPos = contour.frame(l).object(g).Xcont; % morph format
            yPos = contour.frame(l).object(g).Ycont;
            if ~isempty(xPos)
                xPos = [xPos(:); xPos(1)];
                yPos = yPos([1:end 1]);
            else
                continue
            end
        end
        
        x_min = ceil(min(xPos));
        x_max = floor(max(xPos));
        y_min = ceil(min(yPos));
        y_max = floor(max(yPos));
        xv = x_min : x_max;
        yv = y_min : y_max;
        
        [XV, YV] = meshgrid(xv, yv);
        
        [in_contour] = inpolygon(XV, YV, xPos, yPos);
        for i = y_min : y_max
            for j = x_min : x_max
                if in_contour(i - y_min + 1, j - x_min + 1)
                    if(i > 0 && j > 0)
                        immask(i,j) = 1;
                    end
                end
            end
        end
    end
    
    feature_0 = double(edge(immask));
    %feature_0 = imdilate(edge(immask),strel('disk',1));
    feature_1 = immask - feature_0;
    feature_2 = ~immask;
    if ~exist(sprintf('set%d',l),'dir')
        mkdir(sprintf('set%d',l))
    end
    imwrite(feature_0,sprintf('set%d/feature_0.tif',l));
    imwrite(feature_1,sprintf('set%d/feature_1.tif',l));
    imwrite(feature_2,sprintf('set%d/feature_2.tif',l));
end


end
% test for RoC filter and rod-shaped filter
function [roc,not_rod] = test_roc_rod(data)

var_thresh = 0.1; % how much variability to tolerate in width

%RoC filter paramters
cont_shift = 25; %number of points RoC values rotated to orient capture both poles of cotnour
pk_thresh = 0.05; % peak detection threshold for RoC filter
pk_dist = 20; % minimum allowed distance between two local maxima

%minimum contour area
min_area = 500;

%RoC smoothing parameters
window = 20; %no of points on curvature averaged
no_std = 5; %std deviations of gausian 

roc = 0; % default value
not_rod = 0;
if isfield(data,'cell_width') & ~isnan(data.cell_width)
    if data.area>min_area
                  
        % Filter contours based on radius of curvature
        % kappa_smooth is truncated 10 points at each to remove 
        % ambigous peak detection due to edge effects. 
        % Pill shape cells have one peak of positive curvature 

        kappa = data.kappa_raw;
        N= size(kappa);
        if N(1) ~=1
            kappa = kappa';
        end
        kappaX=(1:3*length(kappa));
        kappaY=[kappa,kappa,kappa];
        [~,yout2,~]=peakfind(kappaX,kappaY,1,window,no_std); 
        kappa_smooth= yout2(length(kappa)+1:2*length(kappa))';
        
        KM = circshift(kappa_smooth,cont_shift);
        
        [pks,loc] = findpeaks(KM,'minpeakheight',pk_thresh,'minpeakdistance',pk_dist);
        
        % check to see if cell is sufficiently
        % rod-shaped
        
        % calculate number of grid points corresponding
        % to midcell region
         mesh = data.mesh;
         dx = mesh(:,3)-mesh(:,1);
         dy = mesh(:,4)-mesh(:,2);
         dist = sqrt(dx.^2+dy.^2);
         
         num = ceil(length(dist)*data.cell_width/data.cell_length);
         if num+1>=length(dist)-num
             not_rod = 1;
             avg_width = [];
             std_width = [];
         else
             avg_width = mean(dist(num+1:end-num));
             std_width = std(dist(num+1:end-num));
             if std_width>var_thresh*avg_width
                 not_rod = 1;
             else
                 not_rod = 0;
             end
         end
        
        if length(pks)== 2
            
            roc = 1;
        else
            roc = 0;
            
        end
    end
elseif isfield(data,'MT_width') & ~isnan(data.MT_width)
    if ~data.on_edge && isempty(data.proxID)&data.area>min_area
                  
        % Filter contours based on radius of curvature
        % kappa_smooth is truncated 10 points at each to remove 
        % ambigous peak detection due to edge effects. 
        % Pill shape cells have one peak of positive curvature 

        kappa = data.kappa_raw;
        kappaX=(1:3*length(kappa));
        kappaY=[kappa',kappa',kappa'];
        [~,yout2,~]=peakfind(kappaX,kappaY,1,window,no_std); 
        kappa_smooth= yout2(length(kappa)+1:2*length(kappa))';
        
        KM = circshift(kappa_smooth,cont_shift);
        
        [pks,loc] = findpeaks(KM,'minpeakheight',pk_thresh,'minpeakdistance',pk_dist);
        
        % check to see if cell is sufficiently
        % rod-shaped
        
        % calculate number of grid points corresponding
        % to midcell region
             mesh = data.MT_mesh;
             dx = mesh(:,3)-mesh(:,1);
             dy = mesh(:,4)-mesh(:,2);
             dist = sqrt(dx.^2+dy.^2);

             num = ceil(length(dist)*data.MT_width/data.MT_length);
             if num+1>=length(dist)-num
                 not_rod = 1;
                 avg_width = [];
                 std_width = [];
             else
                 avg_width = mean(dist(num+1:end-num));
                 std_width = std(dist(num+1:end-num));
                 if std_width>var_thresh*avg_width
                     not_rod = 1;
                 else
                     not_rod = 0;
                 end
             end
        
        if length(pks)== 2
            roc = 1;
        else
            roc = 0;

        end
    end
    
end

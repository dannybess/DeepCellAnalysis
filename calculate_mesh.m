function [mesh,cell_length,cell_width]=calculate_mesh(cell_obj)

% take out XY coordinates
X=cell_obj.Xcont;
Y=cell_obj.Ycont;

% n of mesh points to interpolate, current set to ~4X pixel length
TIMESPIXELLENGTH = 4;
n=round(sum(cell_obj.arc_length)*TIMESPIXELLENGTH);

% first interpolation of the curve
[X,Y]=interpcurv2n([X;X(1)],[Y;Y(1)],n);
% find and refine far pole
pole_cand=findCandPole(cell_obj.kappa_smooth);
pole1=refinePole(X,Y,pole_cand*TIMESPIXELLENGTH,50,n);

% shift and refine original pole (1st coordinate)
% X=circshift(X,-pole1);
% Y=circshift(Y,-pole1);
% pole2=refinePole(X,Y,numel(X)-pole1+1,10,n);

% calculate the mesh
% [mesh,midX,midY] = findMesh(X,Y,pole_cand,n);
[mesh,midX,midY] = findMesh(X,Y,pole1,n);
% if mesh failed, return empty array
if sum(isnan(mesh(:)))
    mesh=[];
    cell_length=nan;
    cell_width=nan;
% else calculate the relevant metrics
else
    [cell_length,cell_width]=measureMesh(mesh,midX,midY);
end


function [mesh,midX,midY] = findMesh(X,Y,pole2,n)

Xc=[X;X(1)];
Yc=[Y;Y(1)];

[X1,Y1]=interpcurv2n(Xc(1:pole2),Yc(1:pole2),n);
[X2,Y2]=interpcurv2n(Xc(end:-1:pole2),Yc(end:-1:pole2),n);

midX=mean([X1,X2],2);
midY=mean([Y1,Y2],2);

mesh=[X1,Y1,X2,Y2];

function pole_cand = findCandPole(kappa)

[pks,locs]=findpeaks(kappa);
locs_shift=abs(locs-round(numel(kappa)/2));
cand_locs=find(locs_shift==min(locs_shift));
[~,shift_max]=max(pks(cand_locs));
pole_cand=locs(cand_locs(shift_max));
if isempty(pole_cand)
    pole_cand=round(numel(kappa)/2);
end


function pole_loc = refinePole(X,Y,pole_cand,n_search,n)

Xc=[X;X(1)];
Yc=[Y;Y(1)];

% coarse refinement to existing contour points
cand_poles=pole_cand-n_search:pole_cand+n_search;

if any(cand_poles <= 0) %% added 2018-06-11 AVM Matlab crashing due to negative numbers
    cand_poles = cand_poles(cand_poles >0);
end

if any(cand_poles > numel(Xc)) %% added 2018-06-11 AVM error due to pole search going over numel(Xc)
    cand_poles = cand_poles(cand_poles <= numel(Xc));
end

p=zeros(1,numel(cand_poles));
for j=1:numel(cand_poles);
    peak2=cand_poles(j);
    [X1,Y1]=interpcurv2n(Xc(1:peak2),Yc(1:peak2),n);
    [X2,Y2]=interpcurv2n(Xc(end:-1:peak2),Yc(end:-1:peak2),n);    
    dY=Y2-Y1;
    dX=X2-X1;
    ang = atan2(dY(2:end-1),dX(2:end-1));
    p(j)=sum(abs(diff(ang).^2));
end
[~,I]=min(smooth(p,7));
pole_loc=cand_poles(I);

function [cell_length,cell_width]=measureMesh(mesh,midX,midY)

thresh=0.2;
% width at each mesh point
w=sqrt((mesh(:,4)-mesh(:,2)).^2+(mesh(:,3)-mesh(:,1)).^2);
% calculate dx and dy relative to midline
dy=diff(w./2);
dx=sqrt(diff(midX).^2+diff(midY).^2);
% calculate contour angle relative to midline
theta=atan2(dy,dx);
theta_sum=[pi; theta(1:end-1)+theta(2:end); -pi];
% threshold angle to get only rod section
ind=find(abs(theta_sum)<thresh);
w_rod=w(min(ind):max(ind));
% calculate length and width
cell_width=mean(w_rod);
cell_length=sum(dx);

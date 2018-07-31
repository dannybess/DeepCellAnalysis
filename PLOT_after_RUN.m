% Plot trajectories %
%figure;
close all;

%CALC_GEOM_CONTOUR_WRAPPER;
%frame2frame_MAKE_STRUCT_2;
%frame2frame_MAKE_TRAJECTORY;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_int = 5; % Frame interval
res = 0.222; % Pixel resolution

tree = TOTALS;
bigT = [];
bigR = [];
growthrates = [];
my_tree=[];
b_total = [];
r_sq=[];

figure;

for k=1:length(tree)
    clearvars L T;
    endcut = 3;
    if length(tree(k).traj)>10
        for j=1:length(tree(k).traj)
            L(j) = tree(k).traj(j).cell_length;
            T(j) = tree(k).traj(j).frame_num-1;
        end
        R = gradient(log(smooth(L(1:end-endcut))))*60/t_int;
        bigT = [bigT; (T(1:end-endcut))'*t_int];
        bigR = [bigR; R];
        %disp(size(L));
        %ft=fittype('0.5x^a');
        %fit1=fit(L(:),T(:), 'exp1');
        %disp(fit2);
        val=[];
        for i = (1:numel(L)) - 1
            val=[val (1/t_int)*((log(L+1)/log(L)))];
        end
        growthrates = [growthrates mean(val)];
        
        time = [0:1:(length(L)-1)]';
        my_tree(k).L = L;
        [fit1 g] = fit(time, L(:), 'exp1');
        my_tree(k).fits = fit1;
        my_tree(k).g = g;
        b_total = [b_total fit1.b];
        r_sq=[r_sq g.rsquare];
        
        subplot(2,1,1);
        plot(T(1:end-endcut)*t_int, smooth(L(1:end-endcut))*res, 'color', [131/255, 255/255, (k*2)/255]);
        %plot(fit2, T(1:end-endcut)*t_int, smooth(L(1:end-endcut))*res, 'color', [131/255, 255/255, (k*2)/255]);
        hold on;
        subplot(2,1,2);   
        plot(T(1:end-endcut)*t_int, R,'color', [131/255, 255/255, (k*2)/255]);
        hold on;
    end
end
figure 
histogram(b_total)
xlabel('min^{-1}');

figure 
plot(b_total, r_sq, 'o');
%ylim([0 10]);
%disp(my_tree(1).fits);
%subplot(1, 1, 1)
%histogram(growthrates);
set(gca, 'fontsize', 15);
%{
%%%%%%%%%%%%%%%%%
% Plot binned rates?
if true
    gx = min(bigT):t_int*2:max(bigT);
    [b,n,s] = bindata(bigT,bigR, gx);
    figure; errorbar(gx/60,b,s,'ro');
    ylim([0 0.8])
    set(gca, 'fontsize', 20);
    xlabel('Time (h)');
    ylabel('Log rate');
end
%}

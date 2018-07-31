function jaccard_dice_index(img1, img2) 
orig = imread(img1);
feature = imread(img2);
%imshow((feature));
sim_j = jaccard(imbinarize(orig), imbinarize(feature));
sim_d = dice(imbinarize(orig), imbinarize(feature));
disp(sim_j);
disp(sim_d);
end

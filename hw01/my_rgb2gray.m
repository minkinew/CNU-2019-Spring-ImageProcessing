function image = my_rgb2gray(rgb)
R = rgb(:,:,1);
G = rgb(:,:,2);
B = rgb(:,:,3);
image=0.2989*R + 0.5870*G + 0.1140*B;
figure,imshow(image);
return;
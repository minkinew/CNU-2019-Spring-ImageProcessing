function filter_img = my_gaussian(img, filter_size, sigma)
%  img: Image.     dimension (X x Y)
%  fil_size: Filter maks(kernel)'s size.  type: (uint8)
%  sigma: Sigma value of gaussian filter.  type: (double)
pad_size = floor(filter_size/2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);


[a, b] = meshgrid(ceil(-filter_size/2):floor(filter_size/2), ceil(-filter_size/2):floor(filter_size/2));
mask = exp(-a.^2/(2*sigma^2)-b.^2/(2*sigma^2))/(2*pi*sigma*sigma);
mask = mask./sum(mask(:));

for i = 1:x
    for j = 1:y
        filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*mask));
    end
end

filter_img = uint8(filter_img);
figure, surf(mask); title('filter image');
figure, imshow(filter_img); title('f');
end
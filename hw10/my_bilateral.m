function filter_img = my_bilateral(img, filter_size, sigma, sigma2)
% Apply bilateral filter
% img         : GrayScale Image
% filter_img = bilateral filtered image

% Pre-compute Gaussian filter distance weights.
[X,Y] = meshgrid(-filter_size:filter_size,-filter_size:filter_size);
G = exp(-(X.^2+Y.^2)/(2*sigma^2)); 

% Apply bilateral filter
[x, y] = size(img);
filter_img = zeros(x, y);
filter_img = double(filter_img);
img = double(img);

for i = 1:x
    for j = 1:y
        % Adjusting the filter_size
        Min = max(i-filter_size, 1);
        Max = min(i+filter_size, x);
        Min2 = max(j-filter_size, 1);
        Max2 = min(j+filter_size, y);
        I = img(Min:Max, Min2:Max2);
        
        % Taking the product of the H and G & calculate Bilateral Filter
        F = (exp(-(I-img(i, j)).^2 / (2*sigma2^2))).*G((Min:Max)-i+filter_size+1, (Min2:Max2)-j+filter_size+1);
        filter_img(i,j) = sum(F(:).*I(:)) / sum(F(:)); % Normalize the filter_img
    end
end
filter_img = uint8(filter_img);
end
 
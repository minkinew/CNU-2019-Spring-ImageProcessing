function edge_image = my_canny_edge(img, low_th, high_th, filter_size)
% Find edge of Image using canny edge detection
% img         : Grayscale image    dimension ( height x width )
% low_th      : low threshold      type ( uint8 )
% high_th     : high threshold     type ( uint8 )
% filter_size : size of filter     type ( int64 )
% edge_image  : edge of input img  dimension ( height x width )
pad_size = floor(filter_size/2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);

% Gaussian filter 
[X, Y] = meshgrid(-pad_size:pad_size, -pad_size:pad_size);
sigma = 1;
g_mask = exp(-(X.^2+Y.^2)/(2*(sigma^2))) / (2*pi*(sigma^2));
g_mask = g_mask / sum(sum(g_mask));

for i = 1:x
   for j = 1:y
       filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*g_mask)); 
   end
end

% Sobel filter
pad_img = my_padding(filter_img, pad_size, 'mirror');
v_img = zeros(x, y);
h_img = zeros(x, y);
v_mask = [1:pad_size+1 pad_size:-1:1]' * [-pad_size:pad_size];
h_mask = v_mask';
for i = 1:x
    for j = 1:y
        v_img(i, j) = abs(sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*v_mask))); 
        h_img(i, j) = abs(sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*h_mask))); 
    end
end

% Magnitude & Angel
mag = sqrt(v_img.^2 + h_img.^2);
Angle = atan(h_img./v_img) * 180/pi;

% Non-maximum Suppression using interpolation
for i = 2 : x-1
    for j = 2:y-1
        if Angle(i, j) >= 0 && Angle(i, j) < 45
            temp1 = mag(i, j+1) * tan(Angle(i, j) * pi/180) + mag(i+1, j+1) * (1-tan(Angle(i, j) * pi/180));
            temp2 = mag(i-1, j-1) * tan(Angle(i, j) * pi/180) + mag(i, j-1) * (1-tan(Angle(i, j) * pi/180));
            if mag(i, j) < temp1 || mag(i,j) < temp2
                mag(i, j)=0;
            end
        end
        if Angle(i,j) >= 45 && Angle(i,j) < 90
            temp1 = mag(i+1, j) * cot(Angle(i, j) * pi/180) + mag(i+1, j+1) * (1-cot(Angle(i,j) * pi/180));
            temp2 = mag(i-1, j-1) * cot(Angle(i, j) * pi/180) + mag(i-1, j) * (1-cot(Angle(i,j) * pi/180));
            if mag(i, j) < temp1 || mag(i, j) < temp2
                mag(i, j)=0;
            end
        end
        if Angle(i, j) > -90 && Angle(i, j) <= -45
            temp1 = mag(i-1, j) * cot(-Angle(i, j) * pi/180) + mag(i-1, j+1 ) * (1-cot(-Angle(i, j)*pi/180));
            temp2 = mag(i+1, j-1) * cot(-Angle(i, j) * pi/180) + mag(i+1, j) * (1-cot(-Angle(i, j)*pi/180));
            if mag(i, j) < temp1 || mag(i, j) < temp2
                
                mag(i, j)=0;
            end
        end
        if Angle(i, j) >= -45 && Angle(i, j) < 0
            temp1 = mag(i-1, j+1) * tan(-Angle(i, j) * pi/180) + mag(i,j+1) * (1-tan(-Angle(i, j)*pi/180));
            temp2 = mag(i+1, j-1) * tan(-Angle(i, j) * pi/180) + mag(i,j-1) * (1-tan(-Angle(i, j)*pi/180));
            if mag(i, j) < temp1 || mag(i, j) < temp2
                mag(i, j)=0;
            end
        end
    end
end

% Double thresholding
con = zeros(x, y);     
output = zeros(x, y);
queue = zeros(2, x*y);      
index = 1;

for i = 2 : x - 1
    for j = 2 : y - 1 
        if mag(i, j) <= low_th
            output(i, j) = 0;
        elseif mag(i, j) >= high_th
            output(i, j) = 1;
            con(i, j) = 1;
            queue(1, index) = i;    
            queue(2, index) = j;
            index = index + 1;
        elseif mag(i, j) > low_th && mag(i, j) < high_th
            output(i, j) = 0.5;
        end
    end
end

%BFS
for i = 1 : index
    a = queue(1, i);
    b = queue(2, i);
    if  output(a-1, b-1) == 0.5 && con(a-1, b-1) ~= 1 
        con(a-1, b-1) = 1;
        queue(1, index) = a-1;
        queue(2, index) = b-1;
        result(a-1, b-1) = 1;
        index = index + 1;
    end
    if output(a-1, b) == 0.5 && con(a-1, b) ~= 1
        con(a-1, b) = 1;
        queue(1, index) = a-1;
        queue(2, index) = b;
        output(a-1, b) = 1;
        index = index + 1; 
    end
    if output(a-1, b+1) == 0.5 && con(a-1, b+1) ~= 1
        con(a-1, b+1) = 1;
        queue(1, index) = a-1;
        queue(2, index) = b+1;
        output(a-1, b+1) = 1;
        index = index + 1;
    end
    if output(a, b-1) == 0.5 && con(a, b-1) ~= 1
        con(a, b-1) = 1;
        queue(1, index) = a;
        queue(2, index) = b-1;
        output(a, b-1) = 1;
        index = index + 1;
    end
    if output(a, b+1) == 0.5 && con(a, b+1) ~= 1
        con(a, b+1) = 1;
        queue(1, index) = a-1;
        queue(2, index) = b+1;
        output(a, b+1) = 1;
        index = index + 1;
    end
    if output(a+1, b-1) == 0.5 && con(a-1, b-1) ~= 1
        con(a+1, b-1) = 1;
        queue(1, index) = a+1;
        queue(2, index) = b-1;
        output(a+1, b-1) = 1;
        index = index + 1;
    end
    if output(a+1, b) == 0.5 && con(a+1, b) ~= 1
        con(a+1, b) = 1;
        queue(1, index) = a+1;
        queue(2, index) = b;
        output(a+1, b) = 1;
        index = index + 1;
    end
    if output(a+1, b+1) == 0.5 && con(a+1, b+1) ~= 1
        con(a+1, b+1) = 1;
        queue(1, index) = a+1;
        queue(2, index) = b+1;
        output(a+1, b+1) = 1;
        index = index + 1;
    end
end

for i = 1 : x
    for j = 1 : y
        if output(i, j) == 0.5 || output(i, j) == 0
            output(i, j) = 0;
        end
    end
end

edge_image = uint8(output.*255);

end


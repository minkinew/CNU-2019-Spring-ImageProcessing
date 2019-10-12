function re_img = my_rotate(img, rad, interpolation)
c = cos(rad);
s = sin(rad);
[x, y] = size(img);

f = [c s; -s c];
row = int64(abs(c*x)+abs(s*y));
col = int64(abs(c*y)+abs(s*x));
re_img = zeros(row, col);

if strcmp(interpolation, 'nearest')
    for i = 1:row
        for j = 1:col
            v = f * (double([i-row/2 ; j-col/2]));
            v = v + double([x/2; y/2]);
            if v(1) < 1 || v(1) > x || v(2) < 1 || v(2) > y
                continue;
            end
            re_img(i,j) = img(round(v(1)), round(v(2)));
        end
    end
    
elseif strcmp(interpolation, 'bilinear')
    for i = 1:row
        for j = 1:col
            v = f * (double([i-row/2 ; j-col/2]));
            v = v + double([x/2; y/2]);
            if v(1) < 1 || v(1) > x || v(2) < 1 || v(2) > y
                continue;
            end
            
            x1 = floor(v(1));
            y1 = floor(v(2));
            
            x2 = floor(v(1));
            y2 = ceil(v(2));
            
            x3 = ceil(v(1));
            y3 = ceil(v(2));
            
            x4 = ceil(v(1));
            y4 = floor(v(2));
            
            s = (v(1)) - floor(v(1));
            t = (v(2)) - floor(v(2));
            re_img(i,j) = (1-s)*(1-t)*img(x1,y1) + s*(1-t)*img(x2,y2)+(1-s)*t*img(x4,y4)+s*t*img(x3,y3);
        end
    end
end

re_img = uint8(re_img);
end
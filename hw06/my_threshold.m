%201502023

function [thres_img, level] = my_threshold(img, type)
% Find Threshold 
% img       : GrayScale Image     dimension (height x width)
% type      : kinds of threshold  {'within', 'between'}
% thres_img : threshold image     dimension (height x width)
% level     : threshold value     type( uint8 )
thres_img = img;

img_p = zeros(1, 256);
[x, y] = size(img);

for i = 1:x
    for j = 1:y
        img_p(img(i, j)+1) = img_p(img(i, j)+1) + 1;
    end
end

q1 = 0;
mg = dot((0:255), img_p); 
mean1 = 0;
result = sum(img_p);

if strcmp(type, 'within')
    v1 = 0;
    v2 = 0;
    w = 0;
    min = inf;
    
    for i = 0 : 255
        q1 = q1 + img_p(i + 1);
        q2 = result - q1;
        if (q1 == 0 || q2 == 0)
            continue;
        end
        
        mean1 = mean1 + (i + 1)*img_p(i + 1);
        mean2 = mg - mean1;
        m1 = mean1/q1;
        m2 = mean2/q2;
        v1 = v1 + ((i + 1)*mean1)/q1 - m1^2;
        v2 = v2 + ((i + 1)*mean2)/q2 - m2^2;
        w = q1*v1 + q2*v2;
        
        if (w < min)
            level = i + 1;
            min = w;
        end
    end
 
    
elseif strcmp(type, 'between')
    max = 0;
    b = 0;
    
    for i = 0 : 255
        q1 = q1 + img_p(i + 1);
        q2 = result - q1;
        if (q1 == 0 || q2 == 0)
            continue;
        end
        
        mean1 = mean1 + (i + 1)*img_p(i + 1);
        mean2 = mg - mean1;
        m1 = mean1/q1;
        m2 = mean2/q2;
        b = q1*q2*(m1 - m2)^2;
        
        if (b > max)
            level = i + 1;
            max = b;
        end
    end

end

  for i = 1:x
      for j = 1:y
            if (img(i, j) < level)
                thres_img(i, j) = 0;
            else
                thres_img(i ,j) = 255; 
      end
  end
  

end
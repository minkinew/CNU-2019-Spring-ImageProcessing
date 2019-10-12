function re_img = my_bilinear(img, row, col)
[x, y] =size(img);
pad_img = zeros(x+2, y+2);
pad_img(2:x+1, 2:y+1) = img;

% ������ �κ� �е�
pad_img(1,1) = img(1,1);
pad_img(1,y+2) = img(1, y);
pad_img(x+2,1) = img(x, 1);
pad_img(x+2,y+2) =img(x, y);

% �𼭸� �κ� �е�
pad_img(2:x+1, 1) = img(1:x, 1);
pad_img(2:x+1,y+2) = img(1:x, y);
pad_img(1,2:y+1) = img(x, 1:y);
pad_img(x+2,2:y+1) =img(x, 1:y);

pad_img = uint8(pad_img);
r_p = x / row;
c_p = y / col;

for i = 1:row
    for j = 1:col
        % �ݿø��ؼ� ����� �ȼ��� ���� ������
        x = round(i * r_p)+1; 
        y = round(j * c_p)+1; 
        
        % s, t�� �簢�� �ȿ� ��ġ
        s = (i * r_p) - floor(i * r_p); 
        t = (j * c_p) - floor(j * c_p);
        
        % ���� ������
        re_img(i, j) = ((1-s) * (1-t) * pad_img(x, y)) + (s * (1-t) * pad_img(x, y+1)) + ((1-s) * t * pad_img(x+1, y)) + (s * t * pad_img(x+1, y+1));     
    end
end
re_img = uint8(re_img);  
end
function pad_img = my_padding(img, pad, type)
% img: Image.     dimension (X x Y)
% pad: Pad Size.  type: (uint8)
% type: Padding type. {'mirror', 'repetition', 'zero'}
[x, y] = size(img);
pad_img = zeros(x+2*pad, y+2*pad);
pad_img(1+pad:x+pad, 1+pad:y+pad) = img;

if strcmp(type, 'mirror') % mirror padding
    % �𼭸� �κ� �е�
    pad_img(1:pad, pad+1:pad+y) =  pad_img(2*pad:-1:pad+1, pad+1:pad+y); %�� 2
    pad_img(pad+1:pad+x,1:pad) = pad_img(pad+1:pad+x, 2*pad:-1:pad+1); %�� 4
    pad_img(pad+1:pad+x, pad+y+1:2*pad+y) = pad_img(pad+1:pad+x, 2*pad:-1:pad+1); %�� 5
    pad_img(pad+y+1:2*pad+y,pad+1:pad+y) = pad_img(2*pad:-1:pad+1, pad+1:pad+y); %�� 7
    
    % ������ �κ� �е�
    pad_img(1:pad, 1:pad) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %������ 1
    pad_img(1:pad, pad+y+1:2*pad+y) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %�������� 3
    pad_img (pad+x+1:2*pad+x,1:pad) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %���ʾƷ� 6
    pad_img(pad+x+1:2*pad+x, pad+y+1:2*pad+y) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %�����ʾƷ�8
    
elseif strcmp(type, 'repetition') % repetition padding
    % �𼭸� �κ� �е�
    pad_img(1:pad, pad+1:pad+y) = repmat(pad_img(pad+1, pad+1:pad+y), pad, 1); %�� 2
    pad_img(pad+1:pad+x,1:pad) = repmat(pad_img(pad+1:pad+x, pad+1), 1, pad); %�� 4
    pad_img(pad+1:pad+x, pad+y+1:2*pad+y) = repmat(pad_img(pad+1:pad+x, pad+y), 1, pad); %�� 5
    pad_img(pad+y+1:2*pad+y, pad+1:pad+y) = repmat(pad_img(pad+x, pad+1:pad+y), pad, 1); %�� 7
    
    % ������ �κ� �е�
    pad_img(1:pad, 1:pad) = ones(pad) * pad_img(pad+1, pad+1);  %������ 1
    pad_img(1:pad, pad+y+1:2*pad+y) = ones(pad) * pad_img(pad+1, pad+y); %�������� 3
    pad_img (pad+y+1:2*pad+y,1:pad) = ones(pad) * pad_img(pad+x+1, pad+1); %���ʾƷ� 6
    pad_img(pad+y+1:2*pad+y, pad+y+1:2*pad+y) = ones(pad) * pad_img(pad+x, pad+y); %�����ʾƷ� 8
    
else % zero padding
    pad_img = uint8(pad_img);
end
pad_img = uint8(pad_img);
end
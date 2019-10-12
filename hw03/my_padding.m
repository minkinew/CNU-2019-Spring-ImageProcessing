function pad_img = my_padding(img, pad, type)
% img: Image.     dimension (X x Y)
% pad: Pad Size.  type: (uint8)
% type: Padding type. {'mirror', 'repetition', 'zero'}
[x, y] = size(img);
pad_img = zeros(x+2*pad, y+2*pad);
pad_img(1+pad:x+pad, 1+pad:y+pad) = img;

if strcmp(type, 'mirror') % mirror padding
    % 모서리 부분 패딩
    pad_img(1:pad, pad+1:pad+y) =  pad_img(2*pad:-1:pad+1, pad+1:pad+y); %북 2
    pad_img(pad+1:pad+x,1:pad) = pad_img(pad+1:pad+x, 2*pad:-1:pad+1); %서 4
    pad_img(pad+1:pad+x, pad+y+1:2*pad+y) = pad_img(pad+1:pad+x, 2*pad:-1:pad+1); %동 5
    pad_img(pad+y+1:2*pad+y,pad+1:pad+y) = pad_img(2*pad:-1:pad+1, pad+1:pad+y); %남 7
    
    % 꼭짓점 부분 패딩
    pad_img(1:pad, 1:pad) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %왼쪽위 1
    pad_img(1:pad, pad+y+1:2*pad+y) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %오른쪽위 3
    pad_img (pad+x+1:2*pad+x,1:pad) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %왼쪽아래 6
    pad_img(pad+x+1:2*pad+x, pad+y+1:2*pad+y) = pad_img(2*pad:-1:pad+1, 2*pad:-1:pad+1); %오른쪽아래8
    
elseif strcmp(type, 'repetition') % repetition padding
    % 모서리 부분 패딩
    pad_img(1:pad, pad+1:pad+y) = repmat(pad_img(pad+1, pad+1:pad+y), pad, 1); %북 2
    pad_img(pad+1:pad+x,1:pad) = repmat(pad_img(pad+1:pad+x, pad+1), 1, pad); %서 4
    pad_img(pad+1:pad+x, pad+y+1:2*pad+y) = repmat(pad_img(pad+1:pad+x, pad+y), 1, pad); %동 5
    pad_img(pad+y+1:2*pad+y, pad+1:pad+y) = repmat(pad_img(pad+x, pad+1:pad+y), pad, 1); %남 7
    
    % 꼭짓점 부분 패딩
    pad_img(1:pad, 1:pad) = ones(pad) * pad_img(pad+1, pad+1);  %왼쪽위 1
    pad_img(1:pad, pad+y+1:2*pad+y) = ones(pad) * pad_img(pad+1, pad+y); %오른쪽위 3
    pad_img (pad+y+1:2*pad+y,1:pad) = ones(pad) * pad_img(pad+x+1, pad+1); %왼쪽아래 6
    pad_img(pad+y+1:2*pad+y, pad+y+1:2*pad+y) = ones(pad) * pad_img(pad+x, pad+y); %오른쪽아래 8
    
else % zero padding
    pad_img = uint8(pad_img);
end
pad_img = uint8(pad_img);
end
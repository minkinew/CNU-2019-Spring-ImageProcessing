function img = my_decoding(zigzag,row,col)
% Compress Image using portion of JPEG
% zigzag : result of zigzag scanning
% img    : GrayScale Image

% Zigzag scanning
N = 8;
count = 1;
pad_img = zeros(row,col);
for i=1:N:row
    for j=1:N:col
        matrix = zigzag{count};
        array = zeros(N, N);
        
        row_ = 1; % coordinate of x
        col_ = 1; % coordinate of y
        index = 1; % index number
        
        while row_ <= N && col_ <= N % move right at row_ 1
            if (row_ == 1) && (mod(row_+col_, 2) == 0) && (col_ ~= N)
                if matrix(index) == 999
                    break;
                end
                array(row_, col_) = matrix(index);
                col_ = col_ + 1;
                index = index + 1;
                
            elseif (row_ == N) && (mod(row_+col_, 2) ~= 0) && (col_ ~= N) % move right at row_ N
                if matrix(index) == 999
                    break;
                end
                array(row_, col_) = matrix(index);
                col_ = col_ + 1;
                index = index + 1;
                
            elseif (col_ == 1) && (mod(row_+col_, 2) ~= 0) && (row_ ~= N)  % move down at col_ 1
                if matrix(index) == 999
                    break;
                end
                array(row_, col_) = matrix(index);
                row_ = row_ + 1;
                index = index + 1;
                
            elseif (col_ == N) && (mod(row_+col_, 2) == 0) && (row_ ~= N) % move down at col_ N
                if matrix(index) == 999
                    break;
                end
                array(row_, col_) = matrix(index);
                row_ = row_ + 1;
                index = index + 1;
                
            elseif (row_ ~= N) && (col_ ~= 1) && (mod(row_+col_, 2) ~= 0) % move diagonally left down
                if matrix(index) == 999
                    break;
                end
                array(row_ ,col_) = matrix(index);
                row_ = row_ + 1;
                col_ = col_ - 1;
                index = index + 1;
                
            elseif (row_ ~= 1) && (col_ ~= N) && (mod(row_+col_, 2)==0)  % move diagonally right up
                if matrix(index) == 999
                    break;
                end
                array(row_, col_) = matrix(index);
                row_ = row_ - 1;
                col_ = col_ + 1;
                index = index + 1;
                
            elseif (row_ == N) && (col_ == N)
                break
            end
        end
        pad_img(i:i+N-1, j:j+N-1) = array(1:N, 1:N);
        count = count + 1;
    end
end

% Multiply Quantization using Luminance
Luminance =     [16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];

for i = 1:N:row
    for j = 1:N:col
        pad_img(i:i+N-1, j:j+N-1) = (pad_img(i:i+N-1, j:j+N-1) .* Luminance(1:N, 1:N)) ;
    end
end

% IDCT
[x,y] = size(pad_img);
IDCT = zeros(N);

for i = 1:N:row
    for j = 1:N:col
        block = pad_img(i:i+N-1, j:j+N-1); 
        for u = 0:N-1
            for v = 0:N-1
                IDCT_result = 0;
                for q = 0:N-1
                    for w = 0:N-1
                        % calculate C(u), C(v)
                        if q == 0
                            Cu = sqrt(1/N);
                        else
                            Cu = sqrt(2/N);
                        end
                        
                        if w == 0
                            Cv = sqrt(1/N);
                        else
                            Cv = sqrt(2/N);
                        end
                        
                        cos_result = cos((((2*u)+1)*q*pi)/(2*N)) * cos((((2*v)+1)*w*pi)/(2*N));
                        Func_result = Cu * Cv * block(q+1,w+1) * cos_result;
                        IDCT_result = IDCT_result + Func_result;
                    end
                end
                IDCT(u+1, v+1) = IDCT_result;
            end
        end
        pad_img(i:i+N-1, j:j+N-1) = IDCT(1:N, 1:N);
    end
end

% Add 128
pad_img = pad_img + 128;
img = uint8(pad_img);
imshow(img);
end
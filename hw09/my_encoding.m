function [zigzag, wx, hy] = my_encoding(img)
% Compress Image using portion of JPEG
% img    : GrayScale Image
% zigzag : result of zigzag scanning

[x,y] = size(img);
sub_img = zeros(x,y);
img = double(img);

% Subtract 128
sub_img = img - 128;

% padding
w = 0;
h = 0;

if mod(x,8) ~= 0
    w = 8 - mod(x,8);
end
if mod(y,8) ~= 0
    h = 8 - mod(y,8);
end

pad_img = zeros(x+w, y+h);
pad_img(1:x, 1:y) = sub_img(1:x, 1:y);
pad_img(x+1:x+w, 1:y) = sub_img(x:-1:x-w+1, 1:y);
pad_img(1:x, y+1:y+h) = sub_img(1:x, y:-1:y-h+1);
pad_img(x:x+w, y:y+h) = sub_img(x:-1:x-w, y:-1:y-h);


% DCT
N=8;
DCT = zeros(N);
for i = 1:N:x
    for j = 1:N:y
        block = pad_img(i:i+N-1, j:j+N-1);
        for u = 0:N-1
            for v = 0:N-1
                % calculate C(u), C(v)
                if u == 0
                    Cu = sqrt(1/N);
                else
                    Cu = sqrt(2/N);
                end
                
                if v == 0
                    Cv = sqrt(1/N);
                else
                    Cv = sqrt(2/N);
                end
                
                DCT_result = 0;
                for a = 0:N-1
                    for b = 0:N-1
                        cos_result = cos((((2*a)+1)*u*pi)/(2*N)) * cos((((2*b)+1)*v*pi)/(2*N));
                        func_result = block(a+1, b+1) * cos_result  ;
                        DCT_result = DCT_result + func_result;
                    end
                end
                DCT(u+1,v+1) = Cu * Cv * DCT_result;
            end
        end
        pad_img(i:i+N-1, j:j+N-1) = DCT(1:N,1:N);
    end
end

% Divide Quantization using Luminance
Luminance=     [16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];

for i = 1:N:x
    for j = 1:N:y
        pad_img(i:i+N-1, j:j+N-1) = (pad_img(i:i+N-1, j:j+N-1) ./ Luminance(1:N, 1:N));
    end
end

% Zigzag scanning
scan = {}
for i = 1:N:x
    for j = 1:N:y
        matrix = pad_img(i:i+N-1,j:j+N-1);
        array = zeros(1, N*N);
        
        row = 1; % coordinate of x
        col = 1; % coordinate of y
        index = 1; % index number
        count = 0; % count zero number
        result = 0; 
        
        
        
        while row <= N && col <= N % move right at row 1
            if (row == 1) && (mod(row+col, 2) == 0) && (col ~= N)
                array(index) = matrix(row, col);
                if matrix(row, col) == 0
                    count = count + 1;
                else
                    count = 0;
                end
                col = col + 1;                     
                index = index + 1;
                
            elseif (row == N) && (mod(row+col, 2) ~= 0) && (col ~= N) % move right at row N
                array(index) = matrix(row, col);
                if matrix(row, col) == 0
                    count = count + 1;
                else
                    count = 0;
                end
                col = col + 1;                     
                index = index + 1;
                
            elseif (col == 1) && (mod(row+col, 2) ~= 0) && (row ~= N) % move down at col 1
                array(index) = matrix(row, col);
                if matrix(row, col) == 0
                    count = count + 1;
                else
                    count = 0;
                end
                row = row + 1;                     
                index = index + 1;
                
            elseif (col == N) && (mod(row+col, 2) == 0) && (row ~= N) % move down at col N
                array(index) = matrix(row, col);
                if matrix(row, col) == 0
                    count = count + 1;
                else
                    count = 0;
                end
                row = row + 1;                    
                index = index + 1;
                
            elseif (row ~= N) && (col ~= 1) && (mod(row + col, 2) ~= 0) % move diagonally left down
                array(index) = matrix(row, col);
                if matrix(row, col) == 0
                    count = count + 1;
                else
                    count = 0;
                end
                row = row + 1;
                col = col - 1;   
                index = index + 1;
                
            elseif (row ~= 1) && (col ~= N) && (mod(row + col, 2) == 0) % move diagonally right up
                array(index) = matrix(row, col);
                if matrix(row, col) == 0
                    count = count + 1;
                else
                    count = 0;
                end
                row = row - 1;
                col = col + 1;   
                index = index + 1;
                
            elseif (row == N) && (col == N)   
                break                              
            end
        end
        
        result = (N*N) - count;
        array(result) = 999; % EOB
        array
        scan{end + 1} = array(1:result);
    end
end
zigzag = scan;
wx = x
hy = y
end 

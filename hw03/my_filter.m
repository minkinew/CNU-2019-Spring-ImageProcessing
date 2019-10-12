function filter_img = my_filter(img, filter_size, type)
%  img: Image.     dimension (X x Y)
%  fil_size: Filter maks(kernel)'s size.  type: (uint8)
%  type: Filter type. {'avr', 'laplacian', 'median', 'sobel', 'unsharp'}
pad_size = floor(filter_size/2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);

if strcmp(type, 'avr')
    for i = 1:x
        for j = 1:y
            % fil_size-1������ �ؾ� filter size��ŭ�� mask�� ����
            filter_img(i,j) = mean(mean(pad_img(i:i+filter_size-1, j:j+filter_size-1)));
        end
    end
elseif strcmp(type, 'weight')
    % �ٸ� ������ ����ũ�� ���� ���� ����
    mask = [1:pad_size+1 pad_size:-1:1]' * [1:pad_size+1 pad_size:-1:1];
    % ������ ���� 1�� �ǰ� �ϱ� ���� sum�� �̸� ����
    s = sum(sum(mask));
    for i = 1:x
       for j = 1:y
           filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*mask))/s; 
       end
    end
elseif strcmp(type, 'laplacian') % Laplacian Filter
    mask = ones(filter_size); %filter_size��ŭ�� �迭�� �� ���� 1�� �ʱ�ȭ
    mask(ceil(filter_size/2), ceil(filter_size/2)) = -1*(filter_size*filter_size - 1); %�߾Ӱ� ���
    for i = 1:x
        for j = 1:y
            filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1, j:j+filter_size-1)).*mask)); 
        end
    end
elseif strcmp(type, 'median') % Median Filter
    for i = 1:x
        for j = 1:y
            filter_img(i,j) = median(median(double(pad_img(i:i+filter_size-1, j:j+filter_size-1)))); 
        end
    end
elseif strcmp(type, 'sobel') % Sobel Filter
    % Fill it
    v_img = zeros(x, y);
    h_img = zeros(x, y);
    
    v_mask = ([1:pad_size+1 pad_size:-1:1]' * [-pad_size:pad_size]); %������ ���� ���
    h_mask = v_mask'; %������ ���� ���
    
    for i = 1:x
        for j = 1:y
            v_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*v_mask)); 
            h_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*h_mask)); 
            filter_img(i, j) = v_img(i, j) + h_img(i, j); %����, ���� ���� ���͸� ���� ���� ����
        end
    end

    % Sobel���� ��������� �̹��� ��
    figure
    subplot(1, 1500, 1:490), imshow(v_img), title('v mask image');
    subplot(1, 1500, 501:990), imshow(h_img), title('h mask image');
    subplot(1, 1500, 1001:1490), imshow(filter_img), title('sobel image');
elseif strcmp(type, 'unsharp')
    % k�� �����ص� ������ (0 <= k <= 1)
    k = 0.5;
    mask = zeros(filter_size); %PPT�� I�� �ش��ϴ� ��Ŀ� 0�� �־���
    mask(ceil(filter_size/2), ceil(filter_size/2)) = 1; %�߾��� ���� 1�� �־���
    L = 1/9 * ones(filter_size); %PPT�� L�� �ش��ϴ� ���(1/9)
    mask = (1/(1-k))*mask - (k/(1-k))*L; %Scaling
    for i = 1:x
        for j = 1:y
            filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*mask)); 
        end
    end

end
filter_img = uint8(filter_img);
end
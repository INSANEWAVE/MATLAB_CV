close all; clear;
Image = imread('L:\Labor\Техническое зрение\Lab2\izobr1.bmp'); % vvedite stroku

if size(Image,3)>1
    Image = rgb2gray(Image);
end
Image = im2double(Image);
figure; imshow(Image); title('Original Image');
[E_S, threshold_s] = edge(Image,'sobel');
[E_P, threshold_p] = edge(Image,'prewitt');
[E_R, threshold_r] = edge(Image,'roberts');
[E_L, threshold_l] = edge(Image,'log');
[E_C, threshold_c] = edge(Image,'canny');
SumE = im2double(E_S) + im2double(E_P) + im2double(E_R) + im2double(E_L) + im2double(E_C);
E_T = SumE > 2;
method = 'log'; % vvedite stroku
init_threshold = 0.002 ; % vvedite chislo
final_threshold =  0.02; % vvedite chislo
% step_threshold = 0.1; % vvedite chislo
step_threshold = (final_threshold-init_threshold)/9;
for i = 1 : 10
    threshold = init_threshold + step_threshold*(i-1);
    Edges = edge(Image, method, threshold);
    Edges = im2double(Edges);
    quality(i) = nnz(Edges&E_T)/nnz(Edges|E_T);
    figure; imshow(Edges); title(strcat('Contour Image (', method, ')', ' threshold=', num2str(threshold)));
end
figure; imshow(edge(Image,method)); title(strcat('Contour Image (', method, ')', ' threshold=auto'));
figure; imshow(E_T); title('Contour Image (Combined)');
arg = init_threshold : step_threshold : final_threshold;
figure; plot(arg, quality);
ylabel(strcat('edge detection quality for {\bf', method, '} method'));
xlabel('{\bfthreshold} value');

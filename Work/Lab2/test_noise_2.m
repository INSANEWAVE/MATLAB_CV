close all; clear;
Image = imread('C:\Users\Insanewave\Desktop\MATLAB_CV\Work\Lab2\izobr1.BMP'); % vvedite stroku
if size(Image,3)~=1
    Image = rgb2gray(Image);
end;
Image = im2double(Image);
noise_type = 'speckle'; % vvedite stroku: 'gaussian','salt & pepper','speckle'
init_parameter = 0.00; % vvedite chislo
step_parameter = 0.004; % vvedite chislo
final_parameter = 0.02; % vvedite chislo
for i = 1 : 6
    parameter = init_parameter + step_parameter*(i-1);
    if isequal(noise_type,'gaussian')
        Noised = imnoise(Image, noise_type, 0, parameter);
        x_caption = 'additive gaussian noise variance {\bf\sigma^2}';
    else
        Noised = imnoise(Image, noise_type, parameter);
        if isequal(noise_type,'salt & pepper')
            x_caption = 'impulse (salt-and-pepper) noise density {\bfd}';
        else
            x_caption = 'speckle noise parameter {\bf\it\mu}';
        end;
    end;
    h1 = [1 1 1; 1 1 1; 1 1 1]/9;
    Smoothed1 = imfilter(Noised, h1);
    h2 = [1 1 1; 1 2 1; 1 1 1]/10;
    Smoothed2 = imfilter(Noised, h2);
    h3 = [1 2 1; 2 4 2; 1 2 1]/16;
    Smoothed3 = imfilter(Noised, h3);
    Smoothed4 = wiener2(Noised, [3 3]);
    Smoothed5 = medfilt2(Noised, [3 3]);
	noise_error(i) = sqrt(sum(sum(abs(Image-Noised).^2))/prod(size(Image)));
	mask1_error(i) = sqrt(sum(sum(abs(Image-Smoothed1).^2))/prod(size(Image)));
	mask2_error(i) = sqrt(sum(sum(abs(Image-Smoothed2).^2))/prod(size(Image)));
	wiener_error(i) = sqrt(sum(sum(abs(Image-Smoothed4).^2))/prod(size(Image)));
	mask3_error(i) = sqrt(sum(sum(abs(Image-Smoothed3).^2))/prod(size(Image)));
	median_error(i) = sqrt(sum(sum(abs(Image-Smoothed5).^2))/prod(size(Image)));
end;
figure; imshow(Image); title('Original Image');
figure; imshow(Noised); title('Noised Image');
figure; imshow(Smoothed1); title('Smoothed Image (mask_1)');
figure; imshow(Smoothed2); title('Smoothed Image (mask_2)');
figure; imshow(Smoothed3); title('Smoothed Image (mask_3)');
figure; imshow(Smoothed4); title('Smoothed Image (wiener)');
figure; imshow(Smoothed5); title('Smoothed Image (median)');
arg = init_parameter : step_parameter : final_parameter;
figure; plot(arg, mask1_error, arg, mask2_error, arg, mask3_error, arg, wiener_error, arg, median_error);
legend('mask1', 'mask2', 'mask3', 'wiener', 'median');
ylabel('mean square error of smoothing');
xlabel(x_caption);
close all; clear;
Image = imread('C:\Users\Insanewave\Desktop\MATLAB_CV\Work\Lab2\izobr1.BMP'); % vvedite stroku

if size(Image,3)~=1
    Image = rgb2gray(Image);
end;
Image = im2double(Image);
[num_rows num_cols] = size(Image);
new_rows = 256;
new_cols = 256;
if (num_rows > new_rows)
    init_rows = round((num_rows-new_rows)/2);
    final_rows = init_rows + new_rows - 1;
else
    init_rows = 1;
    final_rows = num_rows;
end;
if (num_cols > new_cols)
    init_cols = round((num_cols-new_cols)/2);
    final_cols = init_cols + new_cols - 1;
else
    init_cols = 1;
    final_cols = num_cols;
end;
Image = Image(init_rows:final_rows,init_cols:final_cols);
blur_type = 'motion'; % vvedite stroku
init_parameter = 5; % vvedite chislo
step_parameter = 5; % vvedite chislo
final_parameter = 25; % vvedite chislo
for i = 1 : 5
    switch lower(blur_type)
        case 'motion'
            len = init_parameter + step_parameter*(i-1);
            theta = 30;
            psf = fspecial(blur_type, len, theta);
            x_caption = '{\bfmotion} filter parameter {\bflen}';
        case 'disk'
            radius = init_parameter + step_parameter*(i-1);
            psf = fspecial(blur_type, radius);
            x_caption = '{\bfdisk} filter parameter {\bfradius}';
        case 'gaussian'
            sigma = init_parameter + step_parameter*(i-1);
            hsize = 4*sigma;
            psf = fspecial(blur_type, hsize, sigma);
            x_caption = '{\bfgaussian} filter parameter {\bfsigma}'
    end;
    Blurred = imfilter(Image, psf,'circular');
    BlurredNoisy = imnoise(Blurred,'gaussian', 0, 0.001);
    %Mask =  hamming(256)*hamming(256)';
    %BlurredNoisy =  BlurredNoisy.*Mask;
    inv_flt = deconvwnr(BlurredNoisy, psf);
    inv_error(i) = sqrt(sum(sum(abs(Image-inv_flt).^2))/prod(size(Image)));
    noise_power = abs(fftn(BlurredNoisy - Blurred)).^2;
    noise_acorr = fftshift(real(ifftn(noise_power)));
    image_power = abs(fftn(Image)).^2;
    image_acorr = fftshift(real(ifftn(image_power)));
    wnr_flt = deconvwnr(BlurredNoisy, psf, noise_acorr, image_acorr);
    wnr_error(i) = sqrt(sum(sum(abs(Image-wnr_flt).^2))/prod(size(Image)));
    init_psf = ones(size(psf));
    [blind_flt, psf_est] = deconvblind(BlurredNoisy, init_psf);
    blind_error(i) = sqrt(sum(sum(abs(Image-blind_flt).^2))/prod(size(Image)));
end;
figure; imshow(Image); title('Original Image');
figure; imshow(Blurred); title('Blurred Image');
figure;imshow(BlurredNoisy); title('Blurred & Noisy');
figure; imshow(inv_flt,[]); title('Restored image (inverse), True PSF');
figure; imshow(wnr_flt); title('Restored image (Wiener), True PSF');
figure; imshow(blind_flt); title('Restored (Blind), Raw PSF');
par = init_parameter : step_parameter : final_parameter;
figure; plot(par, inv_error, par, wnr_error, par, blind_error);
legend('inverse', 'Wiener', 'blind');
ylabel('mean square error of deconvolution');
xlabel(x_caption);
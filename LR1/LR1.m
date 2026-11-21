%% Бельтюков АА ЛР1
clc;
close all;
A = "C:\Users\Insanewave\Desktop\MATLAB_CV\Work\Lab1_pictures\Pictures\FRM002.BMP" %%Путь к нашей картинке

%%Читаем картинку, можем впринципе выбрать uint8 но double 
im = im2double(imread(A));
imfinfo(A) %Выводим инфу
figure
imshow(im)
axis on;%Выводим саму картинку
figure
imC = imcrop(im)
figure
imshow(imC)
axis on;%%Включаем оси ТОЛЬКо для графика сверху
title('Ручной кроп');
imwrite(imC, 'LR1/Cropped_A.bmp')

figure
Crop_Destination = [400, 140, 100, 100];%Вектор обозначающий верхний левый угол кропа и размер кропа как (Y, X, Ycr, Xcr) 
%При этом отсчёт координат также идёт слева-сверху
imCXY = imcrop(im, Crop_Destination);
imshow(imCXY)
title('Кроп по координатам');
axis on;

imCXY_resized = imresize(imCXY, 2, "bilinear");
figure
imshow(imCXY_resized)
axis on;
title('Увеличение в 2 раза');

imCXY_resized_rotated = imrotate(imCXY_resized, 45, "bilinear");
figure
imshow(imCXY_resized_rotated)
axis on;
title('Поворот на 45 градусов');

figure
surf(im, 'EdgeColor','none');
title('Двумерная функция яркости');

%%Последовательность кадров
figure
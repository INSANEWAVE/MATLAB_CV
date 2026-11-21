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
disp('Выберите область кадрирования');
imC = imcrop(im)
pause(3)
figure
imshow(imC)
axis on;%%Включаем оси ТОЛЬКо для графика сверху
title('Ручной кроп');
imwrite(imC, 'LR1/Cropped_A.bmp')
pause(3)
figure
Crop_Destination = [400, 140, 100, 100];%Вектор обозначающий верхний левый угол кропа и размер кропа как (Y, X, Ycr, Xcr) 
%При этом отсчёт координат также идёт слева-сверху
imCXY = imcrop(im, Crop_Destination);
imshow(imCXY)
title('Кроп по координатам');
axis on;
pause(3)
imCXY_resized = imresize(imCXY, 2, "bilinear");
figure
imshow(imCXY_resized)
axis on;
title('Увеличение в 2 раза');
pause(3)
imCXY_resized_rotated = imrotate(imCXY_resized, 45, "bilinear");
figure
imshow(imCXY_resized_rotated)
axis on;
title('Поворот на 45 градусов');
pause(3)
figure
surf(im, 'EdgeColor','none');
title('Двумерная функция яркости');
pause(3)
%%Последовательность кадров
figure
hImg = imshow(imread('Work/Lab1_pictures/Pictures/FRM001.BMP'))
title('Последовательность кадров');

%%Цикл вывода

for i = 1:50
        filename = sprintf('Work/Lab1_pictures/Pictures/FRM%03d.BMP', i)
        %%Вот тут проходимся в цикле по всем кадром от 1 до 100 тактируя строчку 
        % %03d здесь это "дырка" для спринтф чтобы оно ставило вместо этого
        % спецификатора номер в соответсвии с номером цикла и как минимум
        % трёхзначный
        new_pic = imread(filename);
        set(hImg, 'CData', new_pic);
        drawnow limitrate;
        pause(0.2)
end
figure
subplot(1, 2 ,1), imhist(imC, 256);title('Гистограмма ручной кроп');subtitle('Диапазон яркостей 256')
subplot(1, 2 ,2), imhist(imCXY, 64);title('Гистограмма координатный кроп');subtitle('Диапазон яркостей 64')

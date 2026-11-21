figure;
set(gcf,'WindowStyle','modal');
set(gcf,'NumberTitle','off');
axes;

% cd('C:\MATLAB6p5\work\Лабораторная');
% dir = pwd;
filename='logo';

[Image,map]=imread(filename,'bmp');
subimage(Image);

set(gca,'XTickLabel',{''})
set(gca,'YTickLabel',{''})

text(90,180,'Лабораторная работа','FontSize',24,'FontName','MS Sans Serif');

text(55,270,'"Исследование методов','FontSize',24,'FontName','MS Sans Serif');

text(45,330,'сегментации изображений"','FontSize',24,'FontName','MS Sans Serif');
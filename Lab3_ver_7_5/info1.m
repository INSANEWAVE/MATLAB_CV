h=figure;
axes;
set(gcf,'WindowStyle','modal');
set(gcf,'Color',[0.8,0.8,0.8]);
set(gca,'Color',[0.8,0.8,0.8]);
set(gca,'XTickLabel',{''});
set(gca,'YTickLabel',{''});
set(gcf,'NumberTitle','off');

set(gca,'ALim',[0,100])
set(gca,'CLim',[0,100])
set(gca,'XLim',[0,100])
set(gca,'YLim',[0,100])
set(gca,'ZLim',[0,100])
set(gca,'XColor',[0.8,0.8,0.8]);
set(gca,'YColor',[0.8,0.8,0.8]);

set(gcf,'ButtonDownFcn','info2');
set(gcf,'KeyPressFcn','info2');

set(gca,'ButtonDownFcn','info2');

h=text(8,90,'Лабораторная работа','FontSize',24,'FontName','MS Sans Serif');
set(h,'ButtonDownFcn','info2');

h=text(3,72,'"Исследование методов','FontSize',24,'FontName','MS Sans Serif');
set(h,'ButtonDownFcn','info2');

h=text(0,60,'сегментации изображений"','FontSize',24,'FontName','MS Sans Serif');
set(h,'ButtonDownFcn','info2');

h=text(5,15,'Разработчики: Алпатов Б.А., Балашов О.Е., Муравьев В.С.','FontSize',10,'FontName','MS Sans Serif');
set(h,'ButtonDownFcn','info2');

h=text(40,0,'Выйти','FontSize',14,'FontName','MS Sans Serif');
set(h,'ButtonDownFcn','info2');


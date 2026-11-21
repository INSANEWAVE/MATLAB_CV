function handles=process(handles);

rect_object=handles.rect_object;
Image=handles.Image;
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

t1=round(0.22*rect_object(3));
t2=round(0.22*rect_object(4));
rect_frame=[rect_object(1)-t1 rect_object(2)-t2 2*t1+rect_object(3) 2*t2+rect_object(4)];
rect_frame=round(rect_frame);  

rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
rectangle('Position',[rect_frame(1),rect_frame(2),rect_frame(3),rect_frame(4)], 'EdgeColor', 'g');
% drawnow;

image_object = imcrop(Image,rect_object);
image_frame  = imcrop(Image,rect_frame);

handles.rect_frame=rect_frame;
handles.image_object=image_object;
handles.image_frame=image_frame;
guidata(handles.figure1,handles);


set(handles.text2,'Visible','on');
axes(handles.axes2);
imshow(image_object);
set(handles.figure1, 'NextPlot', 'add');

% drawnow;

% Отображение градиента
set(handles.text3,'Visible','on');
handles=Sobel(handles);
axes(handles.axes5);
image_gradient=handles.image_gradient;
imshow(image_gradient);       
set(handles.figure1, 'NextPlot', 'add');

drawnow;

handles=get_histogram_1(handles);
handles=image_segmentation(handles);
handles=smooth_ob(handles);
        
axes(handles.axes3);
smooth_object=handles.smooth_object;
imshow(smooth_object);   
set(handles.figure1, 'NextPlot', 'add');
    
% разметка изображения
smooth_object=handles.smooth_object;
[label_object,count]=bwlabel(smooth_object,8);
handles.label_object=label_object;
handles.count=count;
guidata(handles.figure1,handles);
        
if (count==0)
    % объектов не обнаружено
    handles.ObjectFound=0;
    guidata(handles.figure1,handles);
%     msgbox('Объектов не обнаружено','Предупреждение','warn');
else
    handles.ObjectFound=1;
    guidata(handles.figure1,handles);
    % парамеиризация бинарного изображения и выбор объекта как ближайшего
    % к центру
    handles=compute_parameter(handles);   
    
    % сглаживание параметров объектов
    handles=smooth_parameter_object(handles);
end

global processing;
if (processing==1)
    % коррекция размеров рамки и траекторный фильтр
    handles=edit_size_frame(handles);    
end

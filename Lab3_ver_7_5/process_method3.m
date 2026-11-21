function handles=process_method2(handles);

rect_object=handles.rect_object;
Image=handles.Image;
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

% drawnow;

image_object = imcrop(Image,rect_object);
set(handles.text1,'Visible','on');
axes(handles.axes2);
imshow(image_object);
set(handles.figure1, 'NextPlot', 'add');

% drawnow;

handles.rect_frame=rect_object;
handles.image_object=image_object;
guidata(handles.figure1,handles);

diapason=handles.method3_diapason;
handles=svyazyvanie(handles);
bw = handles.segm_image;
set(handles.text3,'Visible','on');
% axes(handles.axes3);
% set(handles.axes3,'Visible','on');
% imshow(bw);
% set(handles.figure1, 'NextPlot', 'add');

% drawnow;

axes(handles.axes1);
rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
% drawnow;

handles.bin_object=bw;
guidata(handles.figure1,handles);
handles=smooth_ob(handles);
        
set(handles.axes3,'Visible','on');
axes(handles.axes3);
smooth_object=handles.smooth_object;
imshow(smooth_object);
set(handles.figure1, 'NextPlot', 'add');

drawnow;
set(handles.text3,'Visible','on');

    
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

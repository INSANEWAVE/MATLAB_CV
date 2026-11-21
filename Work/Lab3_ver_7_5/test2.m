function handles=test2(handles)


hndl4=handles.hndl4;

val=get(hndl4(2),'String');
val=str2double(val);
[n1,n2]=size(val);
if (n1==0)
    msgbox('Введите число','Предупреждение','warn')
else
    handles.diapason=val;
    guidata(handles.figure1,handles);

    handles=svyazyvanie(handles);
    segm_image=handles.segm_image;
       
%     set(handles.text4,'Visible','on');
    axes(handles.axes3);
    set(handles.axes3,'Visible','on');
    imshow(segm_image);
end

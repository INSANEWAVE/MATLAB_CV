function hide_almost(handles);

% скрыть все кроме объекта и надписи объект
axes(handles.axes3);
cla reset;
set(handles.axes3,'Visible','off');
axes(handles.axes5);
cla reset;
set(handles.axes5,'Visible','off');

set(handles.pushbutton1,'Visible','off');
set(handles.pushbutton2,'Visible','off');
% set(handles.pushbutton3,'Visible','off');
% set(handles.pushbutton4,'Visible','off');
% set(handles.pushbutton5,'Visible','off');

set(handles.listbox1,'Visible','off');
% set(handles.frame2,'Visible','off');

set(handles.popupmenu1,'Visible','off');
% set(handles.popupmenu2,'Visible','off');

set(handles.edit1,'Visible','off');
set(handles.edit2,'Visible','off');

set(handles.text2,'Visible','off');
set(handles.text3,'Visible','off');

% hndl=handles.hndl;
% hndl2=handles.hndl2;
% hndl3=handles.hndl3;
% hndl4=handles.hndl4;
% hndl5=handles.hndl5;
% [t,t]=size(hndl);
% if (t~=1)
%     for i=1:t
%         set(hndl(i),'Visible','off');
%     end
% end
% [t,t]=size(hndl2);
% if (t~=1)
%     for i=1:t
%         set(hndl2(i),'Visible','off');
%     end
% end
% [t,t]=size(hndl3);
% if (t~=1)
%     for i=1:t
%         set(hndl3(i),'Visible','off');
%     end
% end
% [t,t]=size(hndl4);
% if (t~=1)
%     for i=1:t
%         set(hndl4(i),'Visible','off');
%     end
% end
% [t,t]=size(hndl5);
% if (t~=1)
%     for i=1:t
%         set(hndl5(i),'Visible','off');
%     end
% end

hndl1=handles.hndl_test1;
hndl2=handles.hndl_test2;
hndl3=handles.hndl_test3;
hndl4=handles.hndl_test4;
[t,t]=size(hndl1);
if (t~=1)
    for i=1:t
        set(hndl1(i),'Visible','off');
    end
end
[t,t]=size(hndl2);
if (t~=1)
    for i=1:t
        set(hndl2(i),'Visible','off');
    end
end
[t,t]=size(hndl3);
if (t~=1)
    for i=1:t
        set(hndl3(i),'Visible','off');
    end
end
[t,t]=size(hndl4);
if (t~=1)
    for i=1:t
        set(hndl4(i),'Visible','off');
    end
end


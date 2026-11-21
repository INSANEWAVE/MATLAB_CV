function varargout = form3(varargin)
% FORM3 M-file for form3.fig
%      FORM3, by itself, creates a new FORM3 or raises the existing
%      singleton*.
%
%      H = FORM3 returns the handle to a new FORM3 or the handle to
%      the existing singleton*.
%
%      FORM3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM3.M with the given input arguments.
%
%      FORM3('Property','Value',...) creates a new FORM3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form3

% Last Modified by GUIDE v2.5 21-Jan-2004 11:42:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form3_OpeningFcn, ...
                   'gui_OutputFcn',  @form3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before form3 is made visible.
function form3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form3 (see VARARGIN)

% Choose default command line output for form3
handles.output = hObject;

% Режим тестирования выключен
handles.test_mode=0;

handles.hndl_test1=0;
handles.hndl_test2=0;
handles.hndl_test3=0;
handles.hndl_test4=0;

handles.kind_method=0;

% начальная директория с видеопоследовательностями
global dir;
% dir=get(handles.figure1,'UserData');
dir=varargin{2};

% Фон и объект не загружены для режима Тестирования
handles.load_background=0;
handles.load_object=0;

% Режим тестирования выключен
handles.mood_testirovanie=0;

% допольнительное окно для вывода графиков
handles.dop_figure=0;

% Update handles structure
guidata(hObject, handles);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
clc;
clear;
tic;
h=gcf;

t=timer('StartFcn','logo1','TimerFcn','toc','StartDelay',2);
start(t);
h=gcf;
wait(t);
% disp('zzz');
set(gca,'Visible','off');
% toc
close(h);

% индикатор загрузки файла
global file_load;
file_load=0;

% без шума
global noise;
noise=0;

% объект на изображении не выделен
global object_selected;
object_selected=0;

% обработка по кадрам
global compute_sequences;
compute_sequences=0;

% % метод обработки не выбран
% global method_selected;
% method_selected=0;

% метод обработки не выбран (вид метода)
global kind_method_;
kind_method_=0;

% не выбран алгоритм сегментации
global kind_selected;
kind_selected=0;


% Обработка не была прервана
global tracking;
tracking=1;

% Обрабатывается последовательность, если processing=1
global processing;
processing=0;

% реакция на закрытие программы
set(gcf,'CloseRequestFcn','exit1');

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% UIWAIT makes form3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = form3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --------------------------------------------------------------------
function mFile_Callback(hObject, eventdata, handles)
% hObject    handle to mFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mLoadFrame_Callback(hObject, eventdata, handles)
% hObject    handle to mLoadFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hide_all(handles);
handles=reload(handles);

global dir;

dir1=[dir,'\1\'];
a=exist(dir1,'dir');
if (a==0)
    dir1=dir;
end
directiry=pwd;
cd(dir1);
[FileName,PathName] = uigetfile('*.bmp','Изображение фона');
cd(directiry);

file_name=[PathName,FileName];
[Image,map]=imread(file_name,'bmp');

set(handles.axes1,'Visible','on');
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

handles.file_name_background=file_name;
handles.Image=Image;
handles.Store_image=Image;
handles.map=map;

handles.load_background=1;
guidata(handles.figure1,handles);

set(handles.text5,'String',' Загрузите тестовый объект или выберите область обработки');

% global file_load;
% file_load=1;

% --------------------------------------------------------------------
function mLoadObject_Callback(hObject, eventdata, handles)
% hObject    handle to mLoadObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.load_background==0)
    msgbox('Загризите сначала кадр','Предупреждение','help');
    return;
end


global dir;
dir2=[dir,'\test_object\'];
a=exist(dir2,'dir');
if (a==0)
    dir2=dir;
end
directiry=pwd;
cd(dir2);
[FileName,PathName] = uigetfile('*.bmp','Изображение объекта');
cd(directiry);

file_name=[PathName,FileName];
[Image,map]=imread(file_name,'bmp');

set(handles.axes6,'Visible','on');
set(handles.text6,'Visible','on');
axes(handles.axes6);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

handles.file_name_object=file_name;
handles.Image_test_object=Image;
handles.map=map;
[n1, m1]=size(Image);

handles.load_object=1;
guidata(handles.figure1,handles);

set(handles.text5,'String',' Поместите объект на фоновое изображение');

Image=handles.Image;
h1=gcf;
h=figure;
set(h,'Name',' Выберите положение объекта на фоновом изображении');
axes;
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

t=true;
[n, m]=size(Image);
while t
    [x,y]=ginput(1);
    x=round(x);
    y=round(y);
    if ((x>0) && (x<=m-m1) && (y>0) && (y<=n-n1))
        t=false;
    end
end
close(h);
figure(h1);

handles.object_position=[x, y];
guidata(handles.figure1,handles);
% добавление объекта на фон
handles=combine_object_background(handles);

axes(handles.axes1);
Image=handles.Image;
map=handles.map;
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

global object_selected;
if (object_selected==1)
    rect_object=handles.rect_object;
    rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
end
drawnow;

set(handles.text5,'String',' Выберите область обработки, затем можете добавить шум');

% global file_load;
% file_load=1;


% Включить режим тестирования(добавление объекта на фон)
handles.mood_testirovanie=1;
guidata(handles.figure1,handles);

% figure1_WindowButtonDownFcn(hObject, eventdata, handles);

% --------------------------------------------------------------------
function mWork_Callback(hObject, eventdata, handles)
% hObject    handle to mWork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global object_selected;

Children=get(handles.mWork,'Children');
[n,m]=size(Children);

if (object_selected==0)
    for i=1:n
        set(Children(i),'Visible','off');
    end
else
    for i=1:n
        set(Children(i),'Visible','on');
    end    
end
    
% --------------------------------------------------------------------
function mInfo_Callback(hObject, eventdata, handles)
% hObject    handle to mInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mAbout_Callback(hObject, eventdata, handles)
% hObject    handle to mAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

info1;

% --------------------------------------------------------------------
function mExit_Callback(hObject, eventdata, handles)
% hObject    handle to mExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exit1;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% global file_load;
global object_selected;
% global noise;

coordinat_cursor=get(handles.figure1,'CurrentPoint');
rect_axes=get(handles.axes1,'Position');
Image=handles.Image;
map=handles.map;

if (object_selected==1)
    axes(handles.axes1);
    imshow(Image);       
    set(handles.figure1, 'NextPlot', 'add');
    drawnow;    
end


if ((handles.load_background==1) && (coordinat_cursor(1)>rect_axes(1)) && (coordinat_cursor(1)<(rect_axes(1)+rect_axes(3))) && (coordinat_cursor(2)>rect_axes(2)) && (coordinat_cursor(2)<(rect_axes(2)+rect_axes(4))))      
    rect=get_axes_region;
    rect_object=round(rect);
%     rect_object=[300 295 62 72];
    
    object_selected=1;
    
    set(handles.axes2,'Visible','on');
    set(handles.text1,'Visible','on');
    
    image_object=imcrop(Image,rect_object);
    axes(handles.axes2);
    imshow(image_object);       
    set(handles.figure1, 'NextPlot', 'add');
    drawnow;

    handles.rect_object=rect_object;
    handles.image_object=image_object;    
    guidata(handles.figure1,handles);
       
    set(handles.text5,'String',' Выберите метод сегментации');
    
end




% --------------------------------------------------------------------
function mAddNoise_Callback(hObject, eventdata, handles)
% hObject    handle to mAddNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pushbutton1,'Visible','on');
set(handles.pushbutton2,'Visible','on');
set(handles.popupmenu1,'Visible','on');
set(handles.edit1,'Visible','on');
set(handles.edit2,'Visible','on');

val = get(handles.popupmenu1,'Value');
switch val
case 1
    set(handles.text7,'Visible','on');
    set(handles.text8,'Visible','on');
    set(handles.text7,'String','Мат. ожидание');
    set(handles.text8,'String','Дисперсия шума');
case 2
    set(handles.text7,'Visible','on');
    set(handles.text7,'String','Интенсивность');
case 3
    set(handles.text7,'Visible','on');
    set(handles.text7,'String','Дисперсия шума');
end

handles.status_bar=get(handles.text5,'String');
guidata(handles.figure1,handles);
set(handles.text5,'String',' Выберите шум и параметры шума');
popupmenu1_Callback(hObject, eventdata, handles);

Image=handles.Store_image;
map=handles.map;
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

handles.Image=handles.Store_image;
guidata(handles.figure1,handles);
global object_selected;
if (object_selected==1)
    rect_object=handles.rect_object;
    rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
    
    image_object=imcrop(handles.Image,rect_object);
    axes(handles.axes2);
    imshow(image_object);
    set(handles.figure1, 'NextPlot', 'add');
    
    drawnow;

    handles.image_object=image_object;    
    guidata(handles.figure1,handles);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bool1=cellstr(get(handles.edit1,'Visible'));
bool2=cellstr(get(handles.edit2,'Visible'));
if (isequal(bool1,cellstr('on'))==1)
    param1=str2double(get(handles.edit1,'String'));
%     param1=param1/255;
else
    param1=-1000;
end
if (isequal(bool2,cellstr('on'))==1)
    param2=str2double(get(handles.edit2,'String'));
%     param2=param2/255;
else
    param2=-1000;    
end

handles.noise_kind=get(handles.popupmenu1,'Value');
handles.noise_param1=param1;
handles.noise_param2=param2;
Image=handles.Store_image;

val = get(handles.popupmenu1,'Value');
switch val
case 1
    noise_Image=imnoise(Image,'gaussian',param1,param2);
case 2
    noise_Image=imnoise(Image,'salt & pepper',param1);
case 3
    noise_Image=imnoise(Image,'speckle',param1);
end
handles.Image=noise_Image;
guidata(handles.figure1,handles);

set(handles.pushbutton1,'Visible','off');
set(handles.pushbutton2,'Visible','off');
set(handles.popupmenu1,'Visible','off');
set(handles.edit1,'Visible','off');
set(handles.edit2,'Visible','off');
set(handles.text7,'Visible','off');
set(handles.text8,'Visible','off');

set(handles.text5,'String',handles.status_bar);
global object_selected;
if (object_selected==1)
    rect_object=handles.rect_object;
    rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
    
    image_object=imcrop(handles.Image,rect_object);
    axes(handles.axes2);
    imshow(image_object);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;

    handles.image_object=image_object;    
    guidata(handles.figure1,handles);
end

global noise;
noise=1;

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

param1=0;
param2=0;    

Image=handles.Image;
map=handles.map;

val = get(handles.popupmenu1,'Value');
switch val
case 1
    set(handles.edit1,'Visible','on');
    set(handles.edit2,'Visible','on');
    set(handles.edit1,'String','0');
    set(handles.edit2,'String','0');
    set(handles.text7,'Visible','on');
    set(handles.text8,'Visible','on');
    set(handles.text7,'String','Мат. ожидание');
    set(handles.text8,'String','Дисперсия шума');

    noise_Image=imnoise(Image,'gaussian',param1,param2);
    axes(handles.axes1);
    imshow(noise_Image);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;
case 2
    set(handles.edit1,'Visible','on');
    set(handles.edit2,'Visible','off');
    set(handles.edit1,'String','0');
    set(handles.text7,'Visible','on');
    set(handles.text8,'Visible','off');
    set(handles.text7,'String','Интенсивность');

    noise_Image=imnoise(Image,'salt & pepper',param1);
    axes(handles.axes1);
    imshow(noise_Image);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;
case 3
    set(handles.edit1,'Visible','on');
    set(handles.edit2,'Visible','off');    
    set(handles.edit1,'String','0');
    set(handles.text7,'Visible','on');
    set(handles.text8,'Visible','off');
    set(handles.text7,'String','Дисперсия шума');

    noise_Image=imnoise(Image,'speckle',param1);
    axes(handles.axes1);
    imshow(noise_Image);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;
end

handles.noise_Image=noise_Image;
guidata(handles.figure1,handles);

global object_selected;
if (object_selected==1)
    rect_object=handles.rect_object;
    rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

Image=handles.Image;
map=handles.map;
param1=str2double(get(handles.edit1,'String'));
param2=str2double(get(handles.edit2,'String'));
% param1=param1/255;
% param2=param2/255;
% if (abs(param1)>255)
%     msgbox('Введите 1-ый параметр от -255 до 255','warn');
% end
% if (param2>255)
%     msgbox('Введите 2-ой параметр от 0 до 255','warn');
% end    
    
axes(handles.axes1);
val = get(handles.popupmenu1,'Value');
switch val
case 1
    noise_Image=imnoise(Image,'gaussian',param1,param2);
    imshow(noise_Image);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;
case 2
    noise_Image=imnoise(Image,'salt & pepper',param1);
    imshow(noise_Image);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;
case 3
    noise_Image=imnoise(Image,'speckle',param1);
    imshow(noise_Image);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;
end

global object_selected;
if (object_selected==1)
    rect_object=handles.rect_object;
    rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
end

handles.noise_Image=noise_Image;
guidata(handles.figure1,handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

Image=handles.Image;
map=handles.map;
param1=str2double(get(handles.edit1,'String'));
param2=str2double(get(handles.edit2,'String'));
% param1=param1/255;
% param2=param2/255;
% if (param1>255)
%     msgbox('Введите 1-ый параметр от 0 до 255','warn');
% end
% if (param2>255)
%     msgbox('Введите 2-ой параметр от 0 до 255','warn');
% end    

val = get(handles.popupmenu1,'Value');
switch val
case 1
    noise_Image=imnoise(Image,'gaussian',param1,param2);
    axes(handles.axes1);
    imshow(noise_Image);
    set(handles.figure1, 'NextPlot', 'add');

    drawnow;
end

global object_selected;
if (object_selected==1)
    rect_object=handles.rect_object;
    rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
end

handles.noise_Image=noise_Image;
guidata(handles.figure1,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global noise;
noise=0;

set(handles.pushbutton1,'Visible','off');
set(handles.pushbutton2,'Visible','off');
set(handles.popupmenu1,'Visible','off'); 
set(handles.edit1,'Visible','off');
set(handles.edit2,'Visible','off');
set(handles.text7,'Visible','off');
set(handles.text8,'Visible','off');

set(handles.text5,'String',handles.status_bar);

handles.Image=handles.Store_image;
guidata(handles.figure1,handles);
Image=handles.Image;
map=handles.map;
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

global object_selected;
if (object_selected==1)
    rect_object=handles.rect_object;
    rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
end
drawnow;


% --------------------------------------------------------------------
function mMet_1_Callback(hObject, eventdata, handles)
% hObject    handle to mMet_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hide_almost(handles);

rect_object=handles.rect_object;
t1=round(0.22*rect_object(3));
t2=round(0.22*rect_object(4));
rect_frame=[rect_object(1)-t1 rect_object(2)-t2 2*t1+rect_object(3) 2*t2+rect_object(4)];
rect_frame=round(rect_frame);  
axes(handles.axes1);
rectangle('Position',[rect_frame(1),rect_frame(2),rect_frame(3),rect_frame(4)], 'EdgeColor', 'g');
drawnow;

category=strvcat('не используется','2','4','8','16','32','64','128','256');
hpop1  = uicontrol('Style', 'popup',  'String', category,                    'Position', [230  95 150  50], 'Value', 5);
hpop2  = uicontrol('Style', 'popup',  'String', category,                    'Position', [230  65 150  50], 'Value', 5);
htext1 = uicontrol('Style', 'text',   'String', 'ЯРКОСТИ',                   'Position', [150  93  70  50]);
htext2 = uicontrol('Style', 'text',   'String', 'ГРАДИЕНТУ',                 'Position', [150  63  70  50]);
htext3 = uicontrol('Style', 'text',   'String', 'РАЗРЯДНОСТИ ГИСТОГРАММ ПО', 'Position', [150 150 200  15]);
hlist1 = uicontrol('Style', 'listbox','String', '',                          'Position', [390  35 150 120]);

hbutton1=uicontrol('Style', 'pushbutton', 'String', 'Вычислить','Position', [230  60 150 25], 'Callback', @my_button1_metod1_Callback);
% hbutton2=uicontrol('Style', 'pushbutton', 'String', 'Принять',  'Position', [230  35 150 25], 'Callback', @my_button2_metod1_Callback);
hndl_test1=[hpop1, hpop2, htext1, htext2, htext3, hbutton1, hlist1];
handles.hndl_test1=hndl_test1;
guidata(handles.figure1,handles);

set(handles.text5,'String',' Выберите параметры и нажмите кнопку Вычислить');


% --------------------------------------------------------------------
function my_button1_metod1_Callback(hObject, eventdata)

tic;
handles = guidata(gcbo);
hndl_test1=handles.hndl_test1;

n1 = get(hndl_test1(1),'Value');
n2 = get(hndl_test1(2),'Value');
n1=2^(n1-1);
n2=2^(n2-1);

% выбран метод N1
handles.kind_method=1;

handles.capacity1=n1;
handles.capacity2=n2;
handles.current_number_file=1;
guidata(handles.figure1,handles);
% обработка изображения
handles=process(handles);

t=toc/100;
[h,m,s] = hms2mat(t);
% time=[num2str(s)];
time=sprintf('%.2f',s);

if (handles.ObjectFound==1)
    parametr_object=handles.parametr_object;
    member=handles.member;
else
    parametr_object = repmat(struct('square',0,'size_x',0,'size_y',0,'centre_x',0,'centre_y',0,'left_edge',10000,'right_edge',0,'top_edge',10000,'bottom_edge',0,'mean_brightness',0,'density',0),1,1);
    member=1;
end

str = strvcat(['время на кадр, с  ',time],['площадь S1           ',int2str(parametr_object(member).square)],['размер гор.              ',int2str(parametr_object(member).size_x)],['размер верт.           ',int2str(parametr_object(member).size_y)],['ср. яркость            ',int2str(parametr_object(member).mean_brightness)]);

if (handles.load_object==1)
    handles=criterion_segmentation(handles);
    t=handles.criterion_segm;
    t=sprintf('%.2f',t);
    str = strvcat(str,['критерий сегм.   ', t]);
%     msgbox(['Критерий сегментации равен ' t],'','help');
end

[n1, n2]=size(hndl_test1);
set(hndl_test1(n2),'String',str);
tracking=0;

digit1 = get(hndl_test1(1),'Value');
digit2 = get(hndl_test1(2),'Value');

if (digit1>1)
    hist_ob=handles.hist_ob;
    [n,m]=size(hist_ob);
    i=1:n-1;
    j=1:m-1;
    hist1(i,j)=hist_ob(i,j);
    hist_fr=handles.hist_fr;
    [n,m]=size(hist_fr);
    i=1:n-1;
    j=1:m-1;
    hist2(i,j)=hist_fr(i,j);
    hist3=hist2-hist1;

    if (handles.dop_figure==0)
        handles.dop_figure=figure;
    else
        delete (handles.dop_figure);
        handles.dop_figure=figure;
    end
    guidata(handles.figure1,handles);
    
    if (digit2>1)
        subplot(2,2,1);
        surf(hist1);
        title('гистограмма в окне','FontName','MS Sans Serif');
        xlabel('градиент','FontName','MS Sans Serif');
        ylabel('яркость','FontName','MS Sans Serif');
        
        subplot(2,2,2);
        surf(hist2);
        title('гистограмма в рамке','FontName','MS Sans Serif');        
        xlabel('градиент','FontName','MS Sans Serif');
        ylabel('яркость','FontName','MS Sans Serif');
        
        subplot(2,2,4);
        surf(hist3);
        title('разность гистограмм в рамке и окне','FontName','MS Sans Serif');
        xlabel('градиент','FontName','MS Sans Serif');
        ylabel('яркость','FontName','MS Sans Serif');
    end
    
    % отображение гистограммы
    n1=handles.capacity1;
    image_object=handles.image_object;
    image_frame=handles.image_frame;
    [y1,x]=imhist(image_object,n1);
    [y2,x]=imhist(image_frame,n1);
    i=1:n1;
    y(i,1)=y1(i);
    y(i,2)=y2(i);
    subplot(2,2,3);
    bar(y,'group');
    axis tight;
    h=legend('гист. в окне','гист. в рамке',2);
    set(h,'FontName','MS Sans Serif');
    legend('boxoff');
    title('гист-мы по яркости','FontName','MS Sans Serif');
end

% --------------------------------------------------------------------
% function my_button2_metod1_Callback(hObject, eventdata)
% 
% handles = guidata(gcbo);
% hndl_test1=handles.hndl_test1;
% [n1, n2]=size(hndl_test1);
% 
% for i=1:n2
%     set(hndl_test1(i),'Visible','off');
% end
% 
% set(handles.text5,'String','');

% --------------------------------------------------------------------
function mMet_2_Callback(hObject, eventdata, handles)
% hObject    handle to mMet_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hide_almost(handles);

Image=handles.Image;
rect_object=handles.rect_object;
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
drawnow;

image_object=handles.image_object;
level = graythresh(image_object);
level = round(255*level);
htext1   = uicontrol('Style', 'text',   'String', 'Порог яркости', 'Position', [195 65 150 50]);
htext2   = uicontrol('Style', 'text',   'String', num2str(level),  'Position', [325 65  50 50]);
hlist1   = uicontrol('Style', 'listbox','String', '',              'Position', [375  35 160 140]);
hslider1 = uicontrol('Style', 'slider', 'Max', 255, 'Min', 0, 'SliderStep', [1/255 10/255], 'Value', level, 'Position', [225 120 150 20], 'Callback', @my_slider1_metod2_Callback);

hbutton1=uicontrol('Style', 'pushbutton', 'String', 'Вычислить','Position', [225  60 150 25], 'Callback', @my_button1_metod2_Callback);
hndl_test2=[htext1, htext2, hlist1, hslider1, hbutton1];
handles.hndl_test2=hndl_test2;
guidata(handles.figure1,handles);

my_slider1_metod2_Callback(hObject, eventdata);
set(handles.text5,'String',' Выберите параметры и нажмите кнопку Вычислить');

% h=gcf;
if (handles.dop_figure==0)
    handles.dop_figure=figure;
else
    delete (handles.dop_figure);
    handles.dop_figure=figure;
end
guidata(handles.figure1,handles);

% h1=figure;
axes;
n1=32;
[y,x]=imhist(image_object,n1);
bar(x,y,'r');
axis tight;
title('гистограмма в окне','FontName','MS Sans Serif');
xlabel('яркость','FontName','MS Sans Serif');
% figure(h);

% --------------------------------------------------------------------
function my_slider1_metod2_Callback(hObject, eventdata)

handles = guidata(gcbo);
hndl_test2=handles.hndl_test2;

val=round(get(hndl_test2(4),'Value'));
str=num2str(val);
set(hndl_test2(2),'String',str);

% --------------------------------------------------------------------
function my_button1_metod2_Callback(hObject, eventdata)

tic;
handles = guidata(gcbo);
hndl_test2=handles.hndl_test2;

% выбран метод N2
handles.kind_method=2;
val=round(get(hndl_test2(4),'Value'));
handles.threshold=val;

% обработка кадра изображения    
handles.current_number_file=1;
guidata(handles.figure1,handles);
% обработка изображения
handles=process_method2(handles);       

t=toc/100;
[h,m,s] = hms2mat(t);
time=sprintf('%.2f',s);
if (handles.ObjectFound==1)
    parametr_object=handles.parametr_object;
    member=handles.member;
else
    parametr_object = repmat(struct('square',0,'size_x',0,'size_y',0,'centre_x',0,'centre_y',0,'left_edge',10000,'right_edge',0,'top_edge',10000,'bottom_edge',0,'mean_brightness',0,'density',0),1,1);
    member=1;
end
    
str = strvcat(['время на кадр, с  ',time],['площадь S1           ',int2str(parametr_object(member).square)],['размер гор.              ',int2str(parametr_object(member).size_x)],['размер верт.           ',int2str(parametr_object(member).size_y)],['ср. яркость            ',int2str(parametr_object(member).mean_brightness)],['пл.обл.обработки ',int2str((handles.rect_object(3)+1)*(handles.rect_object(4)+1))]);

if (handles.load_object==1)
    handles=criterion_segmentation(handles);
    t=handles.criterion_segm;
    t=sprintf('%.2f',t);
    false_alarm=num2str(handles.false_alarm);
    miss=num2str(handles.miss);
    
    str = strvcat(str,['критерий сегм.   ', t]);
    str = strvcat(str,['ложная тревога   ', false_alarm]);
    str = strvcat(str,['пропуск объекта  ', miss]);
end

set(hndl_test2(3),'String',str);
tracking=0;

% --------------------------------------------------------------------
% function my_button2_metod2_Callback(hObject, eventdata)
% 
% handles = guidata(gcbo);
% hndl_test2=handles.hndl_test2;
% [n1, n2]=size(hndl_test2);
% 
% for i=1:n2
%     set(hndl_test2(i),'Visible','off');
% end
% 
% set(handles.text5,'String','');

% --------------------------------------------------------------------
function mMet_3_Callback(hObject, eventdata, handles)
% hObject    handle to mMet_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% очищение экрана
hide_almost(handles);

Image=handles.Image;
rect_object=handles.rect_object;
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
drawnow;

htext1 = uicontrol('Style', 'text', 'String', 'Порог связывания', 'Position', [230 100 150 50]);
hedit1 = uicontrol('Style', 'edit', 'String', '10',               'Position', [230 100 150 25]);
hlist1   = uicontrol('Style', 'listbox','String', '',             'Position', [390  35 150 120]);
hbutton1=uicontrol('Style', 'pushbutton', 'String', 'Вычислить',  'Position', [230  60 150 25], 'Callback', @my_button1_metod3_Callback);
% hbutton2=uicontrol('Style', 'pushbutton', 'String', 'Запомнить параметры',    'Position', [230  35 150 25], 'Callback', @my_button2_metod3_Callback);
hndl_test3=[htext1, hedit1, hlist1, hbutton1];
handles.hndl_test3=hndl_test3;
guidata(handles.figure1,handles);

set(handles.text5,'String',' Выберите параметры и нажмите кнопку Вычислить');

% --------------------------------------------------------------------
function my_button1_metod3_Callback(hObject, eventdata)

handles = guidata(gcbo);
hndl_test3=handles.hndl_test3;

value=get(hndl_test3(2),'String');
val=str2double(value);

if (val>0)
    image_object=handles.image_object;
    h=figure;
    set(h,'Name',' Выберите положение объекта на фоновом изображении');
    axes;
    imshow(image_object);
    set(handles.figure1, 'NextPlot', 'add');

    t=true;
    [n, m]=size(image_object);
    while t
        [x,y]=ginput(1);
        x=round(x);
        y=round(y);
        handles.method3_centre_x=x;
        handles.method3_centre_y=y;
        guidata(handles.figure1,handles);

        if ((x>0) && (x<=m) && (y>0) && (y<=n))
            t=false;
        end
    end
    close(h);

    tic;
   
    % выбран метод N3
    handles.kind_method=3;
    handles.method3_diapason=val;
    
    % обработка кадра изображения    
    handles.current_number_file=1;
    guidata(handles.figure1,handles);
    
    % обработка изображения
    handles=process_method3(handles);
    
    t=toc/100;
    [h,m,s] = hms2mat(t);
    time=sprintf('%.2f',s);
    
    if (handles.ObjectFound==1)
        parametr_object=handles.parametr_object;
        member=handles.member;
    else
        parametr_object = repmat(struct('square',0,'size_x',0,'size_y',0,'centre_x',0,'centre_y',0,'left_edge',10000,'right_edge',0,'top_edge',10000,'bottom_edge',0,'mean_brightness',0,'density',0),1,1);
        member=1;
    end
    
    str = strvcat(['время на кадр, с  ',time],['площадь S1           ',int2str(parametr_object(member).square)],['размер гор.              ',int2str(parametr_object(member).size_x)],['размер верт.           ',int2str(parametr_object(member).size_y)],['ср. яркость            ',int2str(parametr_object(member).mean_brightness)],['начальная точка (',int2str(handles.method3_centre_x),',',int2str(handles.method3_centre_y),')']);
    
    if (handles.load_object==1)
        handles=criterion_segmentation(handles);
        t=handles.criterion_segm;
        t=sprintf('%.2f',t);
        str = strvcat(str,['критерий сегм.   ', t]);
    end

    set(hndl_test3(3),'String',str);   
    tracking=0;
else
    msgbox('Введите положительное число','Предупреждение','warn');    
end


% --------------------------------------------------------------------
% function my_button2_metod3_Callback(hObject, eventdata)
% 
% handles = guidata(gcbo);
% hndl_test3=handles.hndl_test3;
% [n1, n2]=size(hndl_test3);
% 
% for i=1:n2
%     set(hndl_test3(i),'Visible','off');
% end
% 
% set(handles.text5,'String','');

% --------------------------------------------------------------------
function mMet_4_Callback(hObject, eventdata, handles)
% hObject    handle to mMet_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% очищение экрана
hide_almost(handles);

Image=handles.Image;
rect_object=handles.rect_object;
axes(handles.axes1);
imshow(Image);
set(handles.figure1, 'NextPlot', 'add');

rectangle('Position',[rect_object(1),rect_object(2),rect_object(3),rect_object(4)], 'EdgeColor', 'g');
drawnow;

category=strvcat('Собеля','Превитта','Робертса','Лапласиан'); %,'Канни');
htext1 = uicontrol('Style', 'text',  'String', 'Маска',  'Position', [215 95  70 50]);
hpop1  = uicontrol('Style', 'popup', 'String', category, 'Position', [230 75 150 50], 'Value', 1);
hlist1   = uicontrol('Style', 'listbox','String', '',             'Position', [390  35 150 120]);
hbutton1=uicontrol('Style', 'pushbutton', 'String', 'Вычислить',  'Position', [230  60 150 25], 'Callback', @my_button1_metod4_Callback);
% hbutton2=uicontrol('Style', 'pushbutton', 'String', 'Принять',    'Position', [230  35 150 25], 'Callback', @my_button2_metod4_Callback);
hndl_test4=[htext1, hpop1, hlist1, hbutton1];
handles.hndl_test4=hndl_test4;
guidata(handles.figure1,handles);

set(handles.text5,'String',' Выберите параметры и нажмите кнопку Вычислить');


% --------------------------------------------------------------------
function my_button1_metod4_Callback(hObject, eventdata)

handles = guidata(gcbo);
hndl_test4=handles.hndl_test4;

tic;

n = get(hndl_test4(2),'Value');
handles.method4_mask=n;
% выбран метод N4
handles.kind_method=4;
% обработка кадра изображения    
handles.current_number_file=1;
guidata(handles.figure1,handles);
% обработка изображения
handles=process_method4(handles);

t=toc/100;
[h,m,s] = hms2mat(t);
time=sprintf('%.2f',s);

if (handles.ObjectFound==1)
    parametr_object=handles.parametr_object;
    member=handles.member;
else
    parametr_object = repmat(struct('square',0,'size_x',0,'size_y',0,'centre_x',0,'centre_y',0,'left_edge',10000,'right_edge',0,'top_edge',10000,'bottom_edge',0,'mean_brightness',0,'density',0),1,1);
    member=1;
end

str = strvcat(['время на кадр, с  ',time],['площадь S1           ',int2str(parametr_object(member).square)],['размер гор.              ',int2str(parametr_object(member).size_x)],['размер верт.           ',int2str(parametr_object(member).size_y)],['ср. яркость            ',int2str(parametr_object(member).mean_brightness)]);

if (handles.load_object==1)
    handles=criterion_segmentation(handles);
    t=handles.criterion_segm;
    t=sprintf('%.2f',t);
    str = strvcat(str,['критерий сегм.   ', t]);
end

set(hndl_test4(3),'String',str);
tracking=0;

% --------------------------------------------------------------------
% function my_button2_metod4_Callback(hObject, eventdata)
% 
% handles = guidata(gcbo);
% hndl_test4=handles.hndl_test4;
% [n1, n2]=size(hndl_test4);
% 
% for i=1:n2
%     set(hndl_test4(i),'Visible','off');
% end
% 
% set(handles.text5,'String','');


% --------------------------------------------------------------------
function mComputeSequences_Callback(hObject, eventdata, handles)
% hObject    handle to mComputeSequences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.text5,'String',' Обработка изображения');
% set(handles.axes3,'Visible','on');

global noise;
global tracking;
tracking=1;

file_name=handles.file_name_background;
[pathstr,name,ext] = fileparts(file_name);
kind_method=handles.kind_method;

hide_almost(handles);
% Обработка кадра

% command=['dir ',pathstr,' /A-D /B'];
% [status,result]=system(command);

command=['result=dir(''',pathstr,'\*.bmp'')'];
eval(command);
[n,t1]=size(result);
s=result(n);
z='';

% for i=1:n
%     if ~strcmpi(result(i).name,s.name)
%         z=[z, result(i)];
%     else         
%         break; 
%     end
% end
% 
% [x1,x2]=size(z);
% x=n/(x2+1);
% files = cell(1,x);


files = cell(1,n);
z='';
j=1;
% for i=1:n
%     if ~strcmpi(result(i).name,s.name)
%         z=[z, result(i).name];
%     else
%         files(j)=cellstr(z);
%         j=j+1;
%         z='';
%     end
% end
for i=1:n
    files(i)=cellstr(result(i).name);
end
x=n;

global processing;
processing=1;
% последовательность кадров
for i=1:x
    if (tracking==0)
        % прервать обработку последовательности
        break;
    end
    
    tic;
    file=[pathstr,'\',char(files(i))];
    axes(handles.axes1);
    [Image,map]=imread(file,'bmp');
    
    if (noise==1)
        noise_kind=handles.noise_kind;
        param1=handles.noise_param1;
        param2=handles.noise_param2;
        switch noise_kind
            case 1
                Image=imnoise(Image,'gaussian',param1,param2);
            case 2
                Image=imnoise(Image,'poisson');
            case 3
                Image=imnoise(Image,'salt & pepper',param1);
            case 4
                Image=imnoise(Image,'speckle',param1);
        end
    end
    
    handles.Image=Image;
    handles.current_number_file=i;
    guidata(handles.figure1,handles);
    
    % обработка изображения
    switch kind_method
        case 1
            handles=process(handles);
        case 2
            handles=process_method2(handles);
        case 3
            handles=process_method3(handles);
        case 4
            handles=process_method4(handles);
    end
    
    t=toc/100;
    [h,m,s] = hms2mat(t);
    time=[num2str(s)];
    
    parametr_object=handles.parametr_object;
    member=handles.member;
    set(handles.listbox1,'Visible','on');
    str=['Номер кадра            ',num2str(i)];       
    
    str = strvcat(['Время на кадр,сек',time],['площадь S1     ',int2str(parametr_object(member).square)],['размер гор.              ',int2str(parametr_object(member).size_x)],['размер верт.           ',int2str(parametr_object(member).size_y)],['ср. яркость            ',int2str(parametr_object(member).mean_brightness)]);
    set(handles.listbox1,'String',str);
    
end

processing=0;
set(handles.text5,'String','');
msgbox('Последовательность кадров закончилась','','help');
tracking=0;

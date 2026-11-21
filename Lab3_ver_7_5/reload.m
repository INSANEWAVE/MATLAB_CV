function handles=reload(handles);

handles.hndl_test1=0;
handles.hndl_test2=0;
handles.hndl_test3=0;
handles.hndl_test4=0;

% Режим тестирования выключен
handles.test_mode=0;

handles.kind_method=0;

% Фон и объект не загружены для режима Тестирования
% handles.load_background=0;
handles.load_object=0;

% Режим тестирования выключен
handles.mood_testirovanie=0;

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

guidata(handles.figure1, handles);
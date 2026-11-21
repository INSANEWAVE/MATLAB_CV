 function varargout = f8(varargin)
% F8 M-file for f8.fig
% Last Modified by GUIDE v2.5 29-Nov-2010 10:54:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @f8_OpeningFcn, ...
                   'gui_OutputFcn',  @f8_OutputFcn, ...
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

%--------------------------------------------------------------------------

function f8_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
set(handles.text3,'String','«агрузите последовательность');
handles.Plus=str2num(get(handles.edit8, 'String')); % добавка
handles.K   =str2num(get(handles.edit9, 'String')); % k фильтрации
handles.MPI  = 0;
handles.Steps = 1;  
handles.Limit=str2num(get(handles.edit10, 'String')); % k метода последовательных испытаний;
% Choose default command line output for f8
handles.output = hObject;
handles.CritFunMas = zeros(10);
handles.DeltaXMas = zeros(10);
handles.DeltaYMas = zeros(10);

% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------------
function varargout = f8_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
function pushbutton1_Callback(hObject, eventdata, handles)
% загрузка последовательности----------------------------------------------
handles.Path = get(handles.edit1,'String');
handles.FileList = dir(fullfile(handles.Path,'*.bmp'));
handles.SizeFL = size(handles.FileList);
set(handles.text3,'String',['¬ последовательности ' int2str(handles.SizeFL(1)) ' кадров. ¬ыберите эталон или другую последовательность.']);
[handles.Image,mapImage] = imread([ handles.Path '\' handles.FileList(1).name ]);
axes(handles.axes1);
h=imshow(handles.Image);
set(handles.figure1, 'NextPlot', 'add');
set(handles.pushbutton4,'Enable','on')

if  handles.SizeFL(1)>10  
 for i=10:10:handles.SizeFL(1)
     
 end; 
 else set(handles.popupmenu4, 'String',  int2str(handles.SizeFL(1)));
end;

% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------------
function pushbutton2_Callback(hObject, eventdata, handles)
% работа корелл€тора-------------------------------------------------------
global brc;

brc=0;

CorrMode = get(handles.popupmenu2,'Value');
mminPrev=0;
nminPrev=0;
CritFMasMax=0;
DeltaMasMax=0;


for i=2:handles.SizeFL(1);

% дл€ прерывани€ слежени€
if (brc~=0) 
 return;
end;
    
tic;
% подгрука очередного изображени€
[handles.Image,mapImage] = imread([ handles.Path '\' handles.FileList(i).name]);

% зашумление
NoiseChecked = get(handles.checkbox1,'Value');
NoiseType    = get(handles.popupmenu3, 'Value');
NoiseVar     = str2double(get(handles.edit2, 'String'));
if NoiseChecked==1;
    switch NoiseType
        case 1 
            handles.Image=imnoise(handles.Image,'gaussian',0,NoiseVar);
        case 2    
            handles.Image=imnoise(handles.Image,'salt & pepper',NoiseVar);
        otherwise
            handles.Image=imnoise(handles.Image,'speckle',NoiseVar);
    end;
end; 

 
axes(handles.axes1);
h=imshow(handles.Image);
set(handles.figure1, 'NextPlot', 'add');

mmin=handles.FRect(1);
nmin=handles.FRect(2);
CritFmin=((handles.Rect(3)+1)*(handles.Rect(4)+1)*256)^2+1;
CritFminPrev=0;

TotalP = (handles.FRect(3)-handles.Rect(3)+1)*(handles.FRect(4)-handles.Rect(4)+1);
BadP   = 0;

% корелл€тор
for m=handles.FRect(1):(handles.FRect(1)+handles.FRect(3)-handles.Rect(3))
   for n=handles.FRect(2):(handles.FRect(2)+handles.FRect(4)-handles.Rect(4))
               
        for Step=1:handles.Steps
        
        kStep=1/(2^(handles.Steps-Step));
                          
             if (handles.Steps==1 || Step==handles.Steps)
            SizeX=handles.Rect(3);    
            SizeY=handles.Rect(4);
            M1 = imcrop(handles.Image,[ m n SizeX SizeY] );
            M2 = handles.Template;
             else
            SizeX=ceil(sqrt(kStep)*handles.Rect(3));
            SizeY=ceil(sqrt(kStep)*handles.Rect(4));
            kStep=(SizeX*SizeY)/(handles.Rect(3)*handles.Rect(4));
            M1 = imcrop(handles.Image   , [ m+round(handles.Rect(3)-SizeX)/2 n+round(handles.Rect(4)-SizeY)/2 SizeX SizeY] );
            M2 = imcrop(handles.Template, [   round(handles.Rect(3)-SizeX)/2   round(handles.Rect(4)-SizeY)/2 SizeX SizeY] );
             end;
          
            
            switch CorrMode
                case 1 % классическа€ коррел€ци€
                    M1 = double(M1);
                    M2 = double(M2);
                    M3 = M1.*M2*(-1);
                case 2 % классическа€ коррел€ци€ с нормированием
                    M1 = double(M1);
                    M2 = double(M2);
                    M3 = M1.*M2*(-1);
                    M1 = M1.^2;
                    M2 = M2.^2;
                    M3 = M3./(sum(M1(:))*sum(M2(:)));
                case 3 % модуль разности
                    M3 = imabsdiff(M1,M2);        
                case 4 % квадрат разности
                    M3 = double(M1)-double(M2);                   
                    M3 = M3 .* M3;
                otherwise % друга€..................
                    M3 = imabsdiff(M1,M2);        
            end;       
            
            CritF = sum(M3(:));
           
             if (Step==handles.Steps)
            CFmat((handles.FRect(1)+handles.FRect(3)-handles.Rect(3))-m+1,n-handles.FRect(2)+1) = CritF;
                if (CritF<=CritFmin)
                  CritFmin=CritF;
                  mmin=m;
                  nmin=n;
                end;
             else
              if (CritF>=CritFminPrev * kStep * handles.Limit)
                 BadP=BadP+1;
                 break;
             end;  
            end;   
            
        end; % end for {Step}  
        
        CritFminPrev=CritFmin;
        
    end;  % end for {n}
end; % end for {m}
toc;


if i<3 
DeltaX=0;
DeltaY=0;
CritFmin_=0;
else
DeltaX=abs(mminPrev-mmin);
DeltaY=abs(nminPrev-nmin);
CritFmin_=abs(CritFmin);
end;

CFminmat(i)=abs(CritFmin);
CDXmat(i)=DeltaX;
CDYmat(i)=DeltaY;


if DeltaX>=DeltaMasMax 
    DeltaMasMax = DeltaX+1;
end;
if DeltaY>=DeltaMasMax 
    DeltaMasMax = DeltaY+1;
end;
if CritFmin_>=CritFMasMax
    CritFMasMax = CritFmin_+250;
end;


    
handles.CritFunMas = horzcat ( handles.CritFunMas(2:10), CritFmin_);
handles.DeltaXMas  = horzcat ( handles.DeltaXMas (2:10), DeltaX);
handles.DeltaYMas  = horzcat ( handles.DeltaYMas (2:10), DeltaY);

mminPrev=mmin;
nminPrev=nmin;


Time=num2str(toc);

 if (handles.Steps==1)
  Persents='';   
 else
  Persents=['ќтсе€но ' num2str((BadP/TotalP)*100) '%'];
 end;
set(handles.text3,'String',[' адр ' int2str(i) ' из ' int2str(handles.SizeFL(1)) '. —мещение эталона ' mat2str([DeltaX DeltaY]) '. «начение Fкрит=' int2str(abs(CritFmin)) '. «атрачено времени ' Time ' c. ' Persents]);

% нарисовать рамочки   
% handles.Rect=[ mmin nmin handles.Rect(3) handles.Rect(4)];
handles.Rect(1)=mmin;
handles.Rect(2)=nmin;
rectangle('Position', handles.Rect, 'LineWidth', 1, 'EdgeColor', 'y', 'Curvature', [0.1]);
rectangle('Position', handles.FRect,'LineWidth', 1, 'EdgeColor', 'b', 'Curvature', [0.1], 'LineStyle', ':');

% фильтраци€
k=handles.K;
P1 = uint8(handles.Template);
P2 = uint8(imcrop(handles.Image, handles.Rect));
handles.Template=imlincomb(k,P1,1-k,P2);

% прорисовка эталона
axes(handles.axes2);
h=imshow(handles.Template);
set(handles.figure1, 'NextPlot', 'add');

if (handles.Steps==1)
 set(handles.axes5,'Visible','on');
 axes(handles.axes5);
 
 switch CorrMode
     case 1,2 
         %imshow(-1*CFmat,[]); % contourf(CFmat,10); %mesh(CFmat); %surface(CFmat,'LineStyle','none');
         surf(-1*CFmat,'LineStyle','none');
         set(handles.figure1, 'NextPlot', 'add');     
     otherwise 
         %imshow(CFmat,[]);
         surf(CFmat,'LineStyle','none');
         set(handles.figure1, 'NextPlot', 'add');
 end;
 
axes(handles.axes8);
plot(handles.CritFunMas, '-b',  'LineWidth', 2);
axis([1 10 0 CritFMasMax]);

axes(handles.axes7);

plot(handles.DeltaXMas,  '-rs'  ,  'LineWidth', 2);
text(2, handles.DeltaXMas(3)+0.5, '\DeltaX(red)','HorizontalAlignment','left');

hold on;
plot(handles.DeltaYMas,  '-bo'  ,  'LineWidth', 2);
text(6, handles.DeltaYMas(7)+0.5, '\DeltaY(blue)','HorizontalAlignment','left');
hold off;
axis([1 10 0 DeltaMasMax]);

end;
drawnow;%----------->>>>>>>     

% нова€ област поиска
handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];

end;
set(handles.axes5,'Visible','off');

figure;
%subplot(2,2,1:2);
subplot(3,1,1);

plot(CFminmat(3:end),'LineWidth',2);
xlabel('n of frame')
ylabel('F_{crit}')


subplot(3,1,2);
plot(CDXmat(3:end),'LineWidth',2);
xlabel('n of frame')
ylabel('\Delta x')

subplot(3,1,3);
plot(CDYmat(3:end),'LineWidth',2);
xlabel('n of frame')
ylabel('\Delta y')


% Update handles structure
guidata(hObject, handles);




%--------------------------------------------------------------------------
function pushbutton4_Callback(hObject, eventdata, handles)
% ¬ыбор эталона------------------------------------------------------------

hh = figure;
h=imshow(handles.Image);
[handles.Template handles.Rect]=imcrop;
handles.Rect = round(handles.Rect);
[handles.Template handles.Rect]=imcrop(handles.Image , handles.Rect);
close(hh);

% Update handles structure
guidata(hObject, handles);

handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];
set(handles.text3,'String',['ѕоложение выбраного эталона ' mat2str(handles.Rect(1:2)) '. –азмер выбранного эталона ' mat2str(handles.Rect(3:4)) '.' ]);

set(handles.edit3, 'String', int2str(handles.Rect(1)));
set(handles.edit5, 'String', int2str(handles.Rect(2)));
set(handles.edit6, 'String', int2str(handles.Rect(3)));
set(handles.edit7, 'String', int2str(handles.Rect(4)));

% рамочка
rectangle('Position', handles.Rect, 'LineWidth', 1, 'EdgeColor', 'y', 'Curvature', [0.1]);

% прорисовка эталона
axes(handles.axes2);
set(handles.text2,'Visible','off');

set(handles.text5,'Visible','on');
set(handles.text6,'Visible','on');
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text9,'Visible','on');

set(handles.edit3,'Visible','on');
set(handles.edit5,'Visible','on');
set(handles.edit6,'Visible','on');
set(handles.edit7,'Visible','on');
set(handles.edit8,'Visible','on');

set(handles.pushbutton5,'Visible','on');

h=imshow(handles.Template);
set(handles.figure1, 'NextPlot', 'add');

set(handles.pushbutton2,'Enable','on')

% Update handles structure
guidata(hObject, handles);

%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%--------------------------------------------------------------------------
function edit1_Callback(hObject, eventdata, handles)


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%--------------------------------------------------------------------------
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
handles.K   =str2num(get(handles.edit9, 'String')); % k фильтрации

if  (get(handles.popupmenu2, 'Value') ~= 3 )
    handles.Steps = 1;  
    set (handles.checkbox2  , 'Value', 0 );
    set (handles.popupmenu4, 'Visible', 'off');
    set (handles.text12    , 'Visible', 'off');
    set (handles.edit10    , 'Visible', 'off');
end;  

% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------------
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
 checked=get(hObject,'Value')
 if checked==0 
    set(handles.popupmenu3,'Visible','off'); 
    set(handles.text4,'Visible','off');
    set(handles.edit2,'Visible','off');    
 else
    set(handles.popupmenu3,'Visible','on'); 
    set(handles.text4,'Visible','on');
    set(handles.edit2,'Visible','on');    
 end;
    
% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
%-----------------------------------------------------------
val= str2num(get(hObject,'String'));

handles.Rect(1) = val;
[handles.Template handles.Rect]=imcrop(handles.Image , handles.Rect);

handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];
set(handles.text3,'String',['ѕоложение выбраного эталона ' mat2str(handles.Rect(1:2)) '. –азмер выбранного эталона ' mat2str(handles.Rect(3:4)) '.']);

% рамочка
axes(handles.axes1);
h=imshow(handles.Image);
set(handles.figure1, 'NextPlot', 'add');
rectangle('Position', handles.Rect, 'LineWidth', 1, 'EdgeColor', 'y', 'Curvature', [0.1]);

% прорисовка эталона
axes(handles.axes2);
h=imshow(handles.Template);
set(handles.figure1, 'NextPlot', 'add');

% Update handles structure
guidata(hObject, handles);

drawnow;


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
%-----------------------------------------------------------
val= str2num(get(hObject,'String'));

handles.Rect(2) = val;
[handles.Template handles.Rect]=imcrop(handles.Image , handles.Rect);

handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];
set(handles.text3,'String',['ѕоложение выбраного эталона ' mat2str(handles.Rect(1:2)) '. –азмер выбранного эталона ' mat2str(handles.Rect(3:4)) '.']);

% рамочка
axes(handles.axes1);
h=imshow(handles.Image);
set(handles.figure1, 'NextPlot', 'add');
rectangle('Position', handles.Rect, 'LineWidth', 1, 'EdgeColor', 'y', 'Curvature', [0.1]);

% прорисовка эталона
axes(handles.axes2);
h=imshow(handles.Template);
set(handles.figure1, 'NextPlot', 'add');

% Update handles structure
guidata(hObject, handles);

drawnow;


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit6_Callback(hObject, eventdata, handles)
%-----------------------------------------------------------
val= str2num(get(hObject,'String'));

handles.Rect(3) = val;
[handles.Template handles.Rect]=imcrop(handles.Image , handles.Rect);

handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];
set(handles.text3,'String',['ѕоложение выбраного эталона ' mat2str(handles.Rect(1:2)) '. –азмер выбранного эталона ' mat2str(handles.Rect(3:4)) '.']);

% рамочка
axes(handles.axes1);
h=imshow(handles.Image);
set(handles.figure1, 'NextPlot', 'add');
rectangle('Position', handles.Rect, 'LineWidth', 1, 'EdgeColor', 'y', 'Curvature', [0.1]);

% прорисовка эталона
axes(handles.axes2);
h=imshow(handles.Template);
set(handles.figure1, 'NextPlot', 'add');

% Update handles structure
guidata(hObject, handles);

drawnow;


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
%-----------------------------------------------------------
val= str2num(get(hObject,'String'));

handles.Rect(4) = val;
[handles.Template handles.Rect]=imcrop(handles.Image , handles.Rect);

handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];
set(handles.text3,'String',['ѕоложение выбраного эталона ' mat2str(handles.Rect(1:2)) '. –азмер выбранного эталона ' mat2str(handles.Rect(3:4)) '.']);

% рамочка
axes(handles.axes1);
h=imshow(handles.Image);
set(handles.figure1, 'NextPlot', 'add');
rectangle('Position', handles.Rect, 'LineWidth', 1, 'EdgeColor', 'y', 'Curvature', [0.1]);

% прорисовка эталона
axes(handles.axes2);
h=imshow(handles.Template);
set(handles.figure1, 'NextPlot', 'add');

% Update handles structure
guidata(hObject, handles);

drawnow;


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
handles.Plus=str2num(get(handles.edit8, 'String')); % добавка
handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit9_Callback(hObject, eventdata, handles)
k=str2num(get(hObject, 'String'));
if (k<0) k=0; end;
if (k>1) k=1; end;
set(hObject, 'String',num2str(k));
handles.K=k;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
MPI  = get (handles.checkbox2  , 'Value' );
MPIs = get (handles.popupmenu4 , 'Value' );
if ( MPI  && (get(handles.popupmenu2, 'Value') == 3 ))
    handles.Steps = MPIs + 1;
    set (handles.popupmenu4, 'Visible', 'on');
    set (handles.text12    , 'Visible', 'on');
    set (handles.edit10    , 'Visible', 'on');
else
    handles.Steps = 1;  
    set (handles.checkbox2  , 'Value', 0 );
    set (handles.popupmenu4, 'Visible', 'off');
    set (handles.text12    , 'Visible', 'off');
    set (handles.edit10    , 'Visible', 'off');
end;  

% Update handles structure
guidata(hObject, handles);


function f8_KeyPressFnc(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit10_Callback(hObject, eventdata, handles)

handles.Limit=str2num(get(handles.edit10, 'String')); % k метода последовательных испытаний;
% Update handles structure
guidata(hObject, handles);





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global brc;

button = questdlg('„то вы хотите сделать','«апрос','¬ыйти','ѕрервать слежение','ѕрервать слежение');
if strcmp(button,'¬ыйти')
 shh=get(0,'ShowHiddenHandles');
 set(0,'ShowHiddenHandles','on');
 currFig=get(0,'CurrentFigure');
 set(0,'ShowHiddenHandles',shh);
 delete(hObject);
else 
 brc=1;   
end;



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
handles.defRect  = handles.Rect;
handles.defPlus  = handles.Plus;
handles.defFRect = handles.FRect;

set(handles.text3, 'String', 'Ёталон в пам€ти.')

set(handles.pushbutton6,'Visible','on');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
handles.Rect  = handles.defRect;
handles.Plus  = handles.defPlus;
handles.FRect = handles.defFRect;

set(handles.edit3, 'String', int2str(handles.Rect(1)));
set(handles.edit5, 'String', int2str(handles.Rect(2)));
set(handles.edit6, 'String', int2str(handles.Rect(3)));
set(handles.edit7, 'String', int2str(handles.Rect(4)));

%
handles.Plus=str2num(get(handles.edit8, 'String')); % добавка
handles.FRect= [handles.Rect(1)-handles.Plus handles.Rect(2)-handles.Plus handles.Rect(3)+2*handles.Plus handles.Rect(4)+2*handles.Plus];

% Update handles structure
guidata(hObject, handles);

% рамочка
axes(handles.axes1);
h=imshow(handles.Image);
set(handles.figure1, 'NextPlot', 'add');
rectangle('Position', handles.Rect, 'LineWidth', 1, 'EdgeColor', 'y', 'Curvature', [0.1]);

% прорисовка эталона
[handles.Template handles.Rect]=imcrop(handles.Image , handles.Rect);
axes(handles.axes2);
h=imshow(handles.Template);
set(handles.figure1, 'NextPlot', 'add');

set(handles.text2,'Visible','off');
set(handles.text3, 'String', 'Ёталон загружен.')

% Update handles structure
guidata(hObject, handles);

drawnow;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


MATLAB_dir=pwd;
cd('C:\');

[FileName,PathName] = uigetfile('*.bmp','»зображение фона');
set(handles.edit1,'String',PathName);

cd(MATLAB_dir);




function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



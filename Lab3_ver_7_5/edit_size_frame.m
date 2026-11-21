function handles=edit_size_frame(handles);

smooth_parametr=handles.smooth_parametr;
rect_object=handles.rect_object;
old_rect_object=rect_object;

%коррекция размера рамки
%**************************************************************************
coeff_x=2;
coeff_y=2;

if (smooth_parametr.size_x<8)
    base_x=14;
    coeff_x=1;
  else
    base_x=18;
end
 
if (smooth_parametr.size_y<8)
    base_y=14;
    coeff_y=1;
  else
    base_y=18;
end

Lx=(smooth_parametr.size_x-mod(smooth_parametr.size_x,4))/4;
Ly=(smooth_parametr.size_y-mod(smooth_parametr.size_y,4))/4;
W_x=base_x+4*(Lx-1);
W_y=base_y+4*(Ly-1);

HorizontalSizeFrame = rect_object(3);
VerticalSizeFrame   = rect_object(4);

if ((HorizontalSizeFrame-W_x)>0)
    znak=1;
  else
    if ((HorizontalSizeFrame-W_x)<0)
        znak=-1;
      else
        znak=0;
    end
end

if (coeff_x==2)
    if (abs(HorizontalSizeFrame-W_x)>1)
        rect_object(1)=rect_object(1)+znak;
        rect_object(3)=rect_object(3)-2*znak;
      else
        rect_object(1)=rect_object(1)+znak;
        rect_object(3)=rect_object(3)-znak;
    end
  else
    rect_object(1)=rect_object(1)+znak;
end
  
if ((VerticalSizeFrame-W_y)>0)
    znak=1;
  else
    if ((VerticalSizeFrame-W_y)<0)
        znak=-1;
      else
        znak=0;
    end
end

if (coeff_y==2)
    if (abs(VerticalSizeFrame-W_y)>1)
        rect_object(2)=rect_object(2)+znak;
        rect_object(4)=rect_object(4)-2*znak;
      else
        rect_object(2)=rect_object(2)+znak;
        rect_object(4)=rect_object(4)-znak;
    end
  else
    rect_object(2)=rect_object(2)+znak;
end

%##########################################################################
%траекторный фильтр и коррекция размера рамки
N_selected=10;

if (handles.current_number_file>N_selected)
    Nf=N_selected;
  else
    Nf=handles.current_number_file;
end

An=(4*Nf-2)/(Nf^2+Nf);
Bn=6/(Nf^2+Nf);

centr_x_frame=rect_object(1)+round(rect_object(3)/2);
centr_y_frame=rect_object(2)+round(rect_object(4)/2);

% первый кадр
if (handles.current_number_file==1)
    LastCoordinatCentre(1)=smooth_parametr.centre_x+old_rect_object(1)-1;
    LastCoordinatCentre(2)=smooth_parametr.centre_y+old_rect_object(2)-1;
    LastVelosity(1)=0;
    LastVelosity(2)=0;
  else
    ForecastCoordinatCentre=handles.ForecastCoordinatCentre;
    ForecastVelosity=handles.ForecastVelosity;

%     LastCoordinatCentre(1)=ForecastCoordinatCentre(1);
%     LastCoordinatCentre(2)=ForecastCoordinatCentre(2);
%     LastVelosity(1)=ForecastVelosity(1);
%     LastVelosity(2)=ForecastVelosity(2);

    LastCoordinatCentre=ForecastCoordinatCentre;
    LastVelosity=ForecastVelosity;
end

% объект найден
if (handles.ObjectFound==1)
    CurrentCoordinatCentre(1)=smooth_parametr.centre_x+old_rect_object(1)-1;
    CurrentCoordinatCentre(2)=smooth_parametr.centre_y+old_rect_object(2)-1;

    NextCoordinatCentre(1)=LastCoordinatCentre(1)+round(An*(CurrentCoordinatCentre(1)-LastCoordinatCentre(1)));
    NextCoordinatCentre(2)=LastCoordinatCentre(2)+round(An*(CurrentCoordinatCentre(2)-LastCoordinatCentre(2)));

    NextVelosity(1)=LastVelosity(1)+round(Bn*(CurrentCoordinatCentre(1)-LastCoordinatCentre(1)));
    NextVelosity(2)=LastVelosity(2)+round(Bn*(CurrentCoordinatCentre(2)-LastCoordinatCentre(2)));
  else
    NextCoordinatCentre(1)=LastCoordinatCentre(1);
    NextCoordinatCentre(2)=LastCoordinatCentre(2);

    NextVelosity(1)=LastVelosity(1);
    NextVelosity(2)=LastVelosity(2);
end

% прогноз на следующий кадр
ForecastVelosity(1)=NextVelosity(1);
ForecastVelosity(2)=NextVelosity(2);

ForecastCoordinatCentre(1)=NextCoordinatCentre(1)+ForecastVelosity(1);
ForecastCoordinatCentre(2)=NextCoordinatCentre(2)+ForecastVelosity(2);

% коррекция положения строба
% if (handles.current_number_file<=handles.learner_quantity)
    rect_object(1)=rect_object(1)+ForecastCoordinatCentre(1)-centr_x_frame;
    rect_object(2)=rect_object(2)+ForecastCoordinatCentre(2)-centr_y_frame;
%   else
%     rect_object(1)=rect_object(1)+ForecastCoordinatCentre(1)-centr_x_frame;
%     rect_object(2)=rect_object(2)+ForecastCoordinatCentre(2)-centr_y_frame;
% end
  
handles.ForecastCoordinatCentre=ForecastCoordinatCentre;
handles.ForecastVelosity=ForecastVelosity;


handles.rect_object=rect_object;
guidata(handles.figure1,handles);
function handles=smooth_parameter_object(handles);

parametr_object=handles.parametr_object;
member=handles.member;

if (handles.current_number_file==1)
    smooth_parametr=struct('square',0,'size_x',0,'size_y',0,'centre_x',0,'centre_y',0,'left_edge',10000,'right_edge',0,'top_edge',10000,'bottom_edge',0,'mean_brightness',0,'density',0);

    smooth_parametr.square         =parametr_object(member).square;
    smooth_parametr.size_x         =parametr_object(member).size_x;
    smooth_parametr.size_y         =parametr_object(member).size_y;
    smooth_parametr.mean_brightness=parametr_object(member).mean_brightness;
    smooth_parametr.density        =parametr_object(member).density;
else
    coeff           =0.5;
    smooth_parametr=handles.smooth_parametr;
    
    smooth_parametr.square         =my_filter(smooth_parametr.square,parametr_object(member).square,coeff);
    smooth_parametr.size_x         =my_filter(smooth_parametr.size_x,parametr_object(member).size_x,coeff);
    smooth_parametr.size_y         =my_filter(smooth_parametr.size_y,parametr_object(member).size_y,coeff);
    smooth_parametr.mean_brightness=my_filter(smooth_parametr.mean_brightness,parametr_object(member).mean_brightness,coeff);
    smooth_parametr.density        =smooth_parametr.density*coeff+(1-coeff)*parametr_object(member).density;
end

smooth_parametr.centre_x       =parametr_object(member).centre_x;
smooth_parametr.centre_y       =parametr_object(member).centre_y;
smooth_parametr.left_edge      =parametr_object(member).left_edge;
smooth_parametr.right_edge     =parametr_object(member).right_edge;
smooth_parametr.top_edge       =parametr_object(member).top_edge;
smooth_parametr.bottom_edge    =parametr_object(member).bottom_edge;

handles.smooth_parametr=smooth_parametr;
guidata(handles.figure1,handles);

function z=my_filter(val1,val2,coeff);
z=round(val1*coeff+val2*(1-coeff));
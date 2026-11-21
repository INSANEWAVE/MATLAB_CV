function handles=image_segmentation(handles);

n1=handles.capacity1;
n2=handles.capacity2;
% t_rect_fr=handles.rect_frame;
t_rect_fr=handles.rect_object;
hist_ob=handles.hist_ob;
hist_fr=handles.hist_fr;

t_rect_fr=[t_rect_fr(1) t_rect_fr(2) t_rect_fr(1)+t_rect_fr(3) t_rect_fr(2)+t_rect_fr(4)];
m1=256/n1;
m2=256/n2;

for j=t_rect_fr(2):t_rect_fr(4)
  for i=t_rect_fr(1):t_rect_fr(3)
    shift=calculate_shift(handles,m1,m2,j,i);

    if (hist_ob(shift(1),shift(2))>hist_fr(shift(1),shift(2)))
        bin_image(j,i)=1;
      else
        bin_image(j,i)=0;     
    end
  end
end

rect=[t_rect_fr(1) t_rect_fr(2) t_rect_fr(3)-t_rect_fr(1) t_rect_fr(4)-t_rect_fr(2)];

bin_object=imcrop(bin_image,rect);
handles.bin_object=bin_object;
guidata(handles.figure1,handles);
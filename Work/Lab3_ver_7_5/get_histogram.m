function handles=get_histogram(handles);

n1=handles.capaciry1;
n2=handles.capaciry2;
t_rect_fr=handles.rect_frame;
t_rect_ob=handles.rect_object;
t_rect_fr=[t_rect_fr(1) t_rect_fr(2) t_rect_fr(1)+t_rect_fr(3)-1 t_rect_fr(2)+t_rect_fr(4)-1];
t_rect_ob=[t_rect_ob(1) t_rect_ob(2) t_rect_ob(1)+t_rect_ob(3)-1 t_rect_ob(2)+t_rect_ob(4)-1];

m1=256/n1;
m2=256/n2;

p1=1:n1+1;
p2=1:n2+1;

hist_ob(p1,p2)=0;
hist_fr(p1,p2)=0;

for j=t_rect_fr(2):t_rect_fr(4)
  for i=t_rect_fr(1):t_rect_fr(3) 
    shift=calculate_shift(handles,m1,m2,j,i);
    
    if ((j>=t_rect_ob(2)) && (j<=t_rect_ob(4)) && (i>=t_rect_ob(1)) &&  (i<=t_rect_ob(3))) 
        hist_ob(shift(1),shift(2))= hist_ob(shift(1),shift(2))+1;        
      else
        hist_fr(shift(1),shift(2))= hist_fr(shift(1),shift(2))+1;        
      end   
  end
end

s1=sum(sum(hist_ob));
s2=sum(sum(hist_fr));

handles.hist_ob=hist_ob;     
handles.hist_fr=hist_fr;

guidata(handles.figure1,handles);
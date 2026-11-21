function shift=calculate_shift(handles,m1,m2,j,i);

A=handles.Image;
rect_fr=handles.rect_frame;

%€ркость
x=A(j,i);
zz=double(x)/m1;
k1=floor(zz)+1;

%градиент
% q=abs(double(A(j-1,i))-double(A(j+1,i)))+abs(double(A(j,i-1))-double(A(j,i+1)));
% q=floor(q/2);
q1=abs(double(A(j-1,i-1))+double(A(j-1,i))+double(A(j-1,i+1))-double(A(j+1,i-1))-double(A(j+1,i))-double(A(j+1,i+1)));
q2=abs(double(A(j-1,i-1))+double(A(j,i-1))+double(A(j+1,i-1))-double(A(j-1,i+1))-double(A(j,i+1))-double(A(j+1,i+1)));
q=q1+q2;
% q=floor(q/6);
if (q>255)
    q=255;
end

ww=q/m2;
k2=floor(ww)+1;

shift=[k1 k2];
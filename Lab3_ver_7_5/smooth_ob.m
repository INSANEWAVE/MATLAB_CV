function handles=smooth_ob(handles);

a=handles.bin_object;
[m,n] = size(a);
d=zeros(m,n);

h=[1 1 1;1 1 1;1 1 1];
a=double(a);
c=imfilter(a,h,'symmetric');

for i=1:m
    for j=1:n
        if (a(i,j)>0)
            if (c(i,j)>4) 
                d(i,j)=1;
            end
        else
            if (c(i,j)>5) 
                d(i,j)=1;
            end
        end
    end
end

handles.smooth_object=d;
guidata(handles.figure1,handles);
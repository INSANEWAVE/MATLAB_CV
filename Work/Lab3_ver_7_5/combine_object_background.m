function handles=combine_object_background(handles);

Image=handles.Image;
Image_test_object=handles.Image_test_object;
pos=handles.object_position;

[n1, n2, n3]=size(Image_test_object);
transparency=Image_test_object(n1,1);
for i=1:n1
    for j=1:n2
        if (Image_test_object(i,j)~=transparency)
            Image(pos(2)+i-1,pos(1)+j-1)=Image_test_object(i,j);
        end
    end
end

handles.Image=Image;
handles.Store_image=Image;
guidata(handles.figure1,handles);
